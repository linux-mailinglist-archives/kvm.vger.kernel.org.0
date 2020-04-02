Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE52719C693
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbgDBP4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:56:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:50594 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389627AbgDBP4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 11:56:51 -0400
IronPort-SDR: ICu/c4KiZyA407sSE+7/DVI1S51FIZMOSxE0DBewjRjqjh9ukxqfN3CLbWBIN82khm4sWawLJh
 jdzIVkv9Hsdg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 08:56:49 -0700
IronPort-SDR: WOh0tZZUR7nYfDfkljwsZyG5Hh+gNA+F9Ymy3BoEYIocTeJHaCyMsmtClKuCz+/Rw8jPxCZUGk
 NsKAxf6sKOEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="396413087"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 02 Apr 2020 08:56:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
Date:   Thu,  2 Apr 2020 08:55:54 -0700
Message-Id: <20200402155554.27705-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402155554.27705-1-sean.j.christopherson@intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Two types #AC can be generated in Intel CPUs:
 1. legacy alignment check #AC
 2. split lock #AC

Reflect #AC back into the guest if the guest has legacy alignment checks
enabled or if SLD is disabled.  If SLD is enabled, treat the guest like
a host userspace application by calling handle_user_split_lock().  If
the #AC is handled (SLD disabled and TIF_SLD set), then simply resume
the guest.  If the #AC isn't handled, i.e. host is sld_fatal, then
forward the #AC to the userspace VMM, similar to sending SIGBUS.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 458e684dfbdc..a96cfda0a5b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4623,6 +4623,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4688,9 +4694,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4719,6 +4722,27 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		/*
+		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
+		 * legacy alignment check enabled.  Pre-check host split lock
+		 * turned on to avoid the VMREADs needed to check legacy #AC,
+		 * i.e. reflect the #AC if the only possible source is legacy
+		 * alignment checks.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ||
+		    guest_cpu_alignment_check_enabled(vcpu)) {
+			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
+			return 1;
+		}
+
+		/*
+		 * Forward the #AC to userspace if kernel policy does not allow
+		 * temporarily disabling split lock detection.
+		 */
+		if (handle_user_split_lock(kvm_rip_read(vcpu)))
+			return 1;
+		fallthrough;
 	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
-- 
2.24.1

