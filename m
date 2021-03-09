Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAFA331C8A
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhCIBlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:41:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:12933 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhCIBl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:41:29 -0500
IronPort-SDR: qZMDQmgCWQMM/vmCImRN4OUr7t6/dj0Kc6eKE5IZMpGu6ude09kwLxGfflLu5WZFIVTR4QqGGX
 Y2SdfiCmyfRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="273166499"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="273166499"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:41:27 -0800
IronPort-SDR: cP2ySDsxYa23lLwHN1WEwhypVOdLo8A/OilxJT9md7qdt3xtiWQ1C0kkVEPEB7lqWM0WgPwF9b
 W9WHgmSM3gBg==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327773"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:41:22 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 23/25] KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
Date:   Tue,  9 Mar 2021 14:40:30 +1300
Message-Id: <e3b4feacde906b5c94dc6f8a5b0371e15df19a3d.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a VM-Exit handler to trap-and-execute EINIT when SGX LC is enabled
in the host.  When SGX LC is enabled, the host kernel may rewrite the
hardware values at will, e.g. to launch enclaves with different signers,
thus KVM needs to intercept EINIT to ensure it is executed with the
correct LE hash (even if the guest sees a hardwired hash).

Switching the LE hash MSRs on VM-Enter/VM-Exit is not a viable option as
writing the MSRs is prohibitively expensive, e.g. on SKL hardware each
WRMSR is ~400 cycles.  And because EINIT takes tens of thousands of
cycles to execute, the ~1500 cycle overhead to trap-and-execute EINIT is
unlikely to be noticed by the guest, let alone impact its overall SGX
performance.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/sgx.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index be0429c3c04a..9f0149b9d53f 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -275,6 +275,59 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int handle_encls_einit(struct kvm_vcpu *vcpu)
+{
+	unsigned long sig_hva, secs_hva, token_hva, rflags;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gva_t sig_gva, secs_gva, token_gva;
+	gpa_t sig_gpa, secs_gpa, token_gpa;
+	int ret, trapnr;
+
+	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 1808, 4096, &sig_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rdx_read(vcpu), 304, 512, &token_gva))
+		return 1;
+
+	/*
+	 * Translate the SIGSTRUCT, SECS and TOKEN pointers from GVA to GPA.
+	 * Resume the guest on failure to inject a #PF.
+	 */
+	if (sgx_gva_to_gpa(vcpu, sig_gva, false, &sig_gpa) ||
+	    sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa) ||
+	    sgx_gva_to_gpa(vcpu, token_gva, false, &token_gpa))
+		return 1;
+
+	/*
+	 * ...and then to HVA.  The order of accesses isn't architectural, i.e.
+	 * KVM doesn't have to fully process one address at a time.  Exit to
+	 * userspace if a GPA is invalid.  Note, all structures are aligned and
+	 * cannot split pages.
+	 */
+	if (sgx_gpa_to_hva(vcpu, sig_gpa, &sig_hva) ||
+	    sgx_gpa_to_hva(vcpu, secs_gpa, &secs_hva) ||
+	    sgx_gpa_to_hva(vcpu, token_gpa, &token_hva))
+		return 0;
+
+	ret = sgx_virt_einit((void __user *)sig_hva, (void __user *)token_hva,
+			     (void __user *)secs_hva,
+			     vmx->msr_ia32_sgxlepubkeyhash, &trapnr);
+
+	if (ret == -EFAULT)
+		return sgx_inject_fault(vcpu, secs_gva, trapnr);
+
+	rflags = vmx_get_rflags(vcpu) & ~(X86_EFLAGS_CF | X86_EFLAGS_PF |
+					  X86_EFLAGS_AF | X86_EFLAGS_SF |
+					  X86_EFLAGS_OF);
+	if (ret)
+		rflags |= X86_EFLAGS_ZF;
+	else
+		rflags &= ~X86_EFLAGS_ZF;
+	vmx_set_rflags(vcpu, rflags);
+
+	kvm_rax_write(vcpu, ret);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
 {
 	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
@@ -307,6 +360,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 	} else {
 		if (leaf == ECREATE)
 			return handle_encls_ecreate(vcpu);
+		if (leaf == EINIT)
+			return handle_encls_einit(vcpu);
 		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
 		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
 		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
-- 
2.29.2

