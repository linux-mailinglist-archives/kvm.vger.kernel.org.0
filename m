Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39062EB7F2
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbhAFB6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:58:34 -0500
Received: from mga03.intel.com ([134.134.136.65]:2891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbhAFB6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:58:33 -0500
IronPort-SDR: NcA2vEjxtI4hmz2bd8w2jq8cDP4eaoMazk1NHadxZonUDwKqsu4i2ULLoYNzsMJVQNY68sj7OZ
 GdeIFx362JcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="177313709"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="177313709"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:57:57 -0800
IronPort-SDR: 6DQhEFXQ/mGdMjJ4PGxSpWm8fjJWShwlHNzIJoqeiMA4dLL6gB3S6SGZuMQLNmkv/M8Dt/Lcig
 viJxgdzc/AIw==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993596"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:57:52 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        mattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 21/23] KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
Date:   Wed,  6 Jan 2021 14:56:51 +1300
Message-Id: <3637c30a871d7a167da6073e2af2ac84cde7d77d.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
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
index 6ad6a24c4e93..979d0597e4ac 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -256,6 +256,59 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
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
@@ -288,6 +341,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
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

