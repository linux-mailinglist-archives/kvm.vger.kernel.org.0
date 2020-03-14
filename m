Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB364185893
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgCOCOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:14:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:41896 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgCOCNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:39 -0400
IronPort-SDR: 7Dx4jeO+q7GNQWymEQd0AmGCAljbX3G3jr/R66WE6XbhpgazNs6dFJ9x9+3nV+NdOLcBzCrJcN
 0AxC0rfZa5FA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:52:17 -0700
IronPort-SDR: sIDcx8X+9yNrEo0qlSTkO5PF8Ib4uZZZPKiUy7hNOCsuIlyf0SaXWZ+yJnUvsYOjZW35LHnX9T
 N9I1lsUmJncA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537619"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:52:12 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 07/10] kvm: vmx: Extend VMX's #AC interceptor to handle split lock #AC happens in guest
Date:   Sat, 14 Mar 2020 15:34:11 +0800
Message-Id: <20200314073414.184213-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two types of #AC can be generated in Intel CPUs:
 1. legacy alignment check #AC;
 2. split lock #AC;

Legacy alignment check #AC can be injected to guest if guest has enabled
alignemnet check.

when host enables split lock detectin, i.e., sld_warn or sld_fatal,
there will be an unexpected #AC in guest and intercepted by KVM because
KVM doesn't virtualize this feature to guest and hardware value of
MSR_TEST_CTRL.SLD bit stays unchanged when vcpu is running.

To handle this unexpected #AC, treat guest just like host usermode that
calling handle_user_split_lock():
 - If host is sld_warn, it warns and set TIF_SLD so that __switch_to_xtra()
   does the MSR_TEST_CTRL.SLD bit switching when control transfer to/from
   this vcpu.
 - If host is sld_fatal, forward #AC to userspace, the similar as sending
   SIGBUS.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e6138cd5..3fb132ad489d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4609,6 +4609,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
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
@@ -4674,9 +4680,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4705,6 +4708,27 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		/*
+		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
+		 * legacy alignment check enabled.  Pre-check host split lock
+		 * support to avoid the VMREADs needed to check legacy #AC,
+		 * i.e. reflect the #AC if the only possible source is legacy
+		 * alignment checks.
+		 */
+		if (!split_lock_detect_on() ||
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
2.20.1

