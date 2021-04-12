Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E6135B944
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhDLEWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:53388 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230109AbhDLEWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:37 -0400
IronPort-SDR: 2QKQBcbq4LVD3KdP9FQMajvbNYv/l3+9BlOk2QgvSGbkiAnn+svm9MZU1OtcXJd12CVWUAE8Jc
 vDxENMktEXbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083794"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083794"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:20 -0700
IronPort-SDR: rFNVaSHVMulNTg3of6nCh00H+NICa+J3Kopmml+R/WmbaK2itc/IwfbqY+T8I6+Ldgn5p6QTO2
 AYK377CYlq7Q==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030444"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:17 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 09/11] KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
Date:   Mon, 12 Apr 2021 16:21:41 +1200
Message-Id: <57c92fa4d2083eb3be9e6355e3882fc90cffea87.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
v4->v5:
 - Improve comment around sgx_virt_einit().

---
 arch/x86/kvm/vmx/sgx.c | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index d53e6b17b320..2eed5da91698 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -287,6 +287,68 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
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
+	/*
+	 * sgx_virt_einit() returns -EINVAL when access_ok() fails on @sig_hva,
+	 * @token_hva or @secs_hva. This should never happen as KVM checks host
+	 * addresses at memslot creation. sgx_virt_einit() has already warned
+	 * in this case, so just return.
+	 */
+	if (ret < 0)
+		return ret;
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
@@ -319,6 +381,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 	} else {
 		if (leaf == ECREATE)
 			return handle_encls_ecreate(vcpu);
+		if (leaf == EINIT)
+			return handle_encls_einit(vcpu);
 		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
 		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
 		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
-- 
2.30.2

