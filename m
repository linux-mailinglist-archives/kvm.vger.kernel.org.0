Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CA153F22
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 08:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgBFHJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 02:09:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:56103 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgBFHJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 02:09:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 23:09:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="231957263"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 23:09:34 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 6/8] kvm: vmx: Extend VMX's #AC interceptor to handle split lock #AC happens in guest
Date:   Thu,  6 Feb 2020 15:04:10 +0800
Message-Id: <20200206070412.17400-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206070412.17400-1-xiaoyao.li@intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
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

when host enables split lock detectin, i.e., split_lock_detect != off,
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
v3:
 - Use handle_user_split_lock() to handle unexpected #AC in guest.
---
 arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c475fa2aaae0..822211975e6c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4557,6 +4557,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
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
@@ -4622,9 +4628,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4653,6 +4656,28 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		/*
+		 * Inject #AC back to guest only when guest enables legacy
+		 * alignment check.
+		 * Otherwise, it must be an unexpected split lock #AC of guest
+		 * since hardware SPLIT_LOCK_DETECT bit keeps unchanged set
+		 * when vcpu is running. In this case, treat guest the same as
+		 * user space application that calls handle_user_split_lock():
+		 *  - If sld_state = sld_warn, it sets TIF_SLD and disables SLD
+		 *    for this vcpu thread.
+		 *  - If sld_state = sld_fatal, we forward #AC to userspace,
+		 *    similar as sending SIGBUS.
+		 */
+		if (!split_lock_detect_enabled() ||
+		    guest_cpu_alignment_check_enabled(vcpu)) {
+			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
+			return 1;
+		}
+
+		if (handle_user_split_lock(kvm_rip_read(vcpu)))
+			return 1;
+		/* fall through */
 	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
-- 
2.23.0

