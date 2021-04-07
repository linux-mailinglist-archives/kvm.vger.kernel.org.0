Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5608357650
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhDGUuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:50:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:47225 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhDGUuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:50:37 -0400
IronPort-SDR: DA904PgLv9Er+QnXglLgcz8rymUahmsdZ/2KabJxLO2WsXl0O7JvRAABcE2vfVVNH+mUbq6krD
 DM6j9mub9x8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="278660402"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="278660402"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:50:27 -0700
IronPort-SDR: oXqkqZP1i5mwa/cqITz8R/4J5irpUtT/NZucD4UaX64tZcGIDBTm8B5Ok/VpBxsPU1AX8AAmjK
 URS95t97ECGg==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="415437479"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:50:24 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v4 09/11] KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
Date:   Thu,  8 Apr 2021 08:49:33 +1200
Message-Id: <6bf731227ac8d75696fa974846c3c2c64eadae7b.1617825858.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617825858.git.kai.huang@intel.com>
References: <cover.1617825858.git.kai.huang@intel.com>
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
 arch/x86/kvm/vmx/sgx.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index fb729e5c6949..6c96f87710f8 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -286,6 +286,67 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
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
+	 * sgx_virt_einit() returns -EINVAL when access_ok() fails on
+	 * @sig_hva, @token_hva or @secs_hva. It's unexpected and is kernel bug.
+	 * Just return.
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
@@ -318,6 +379,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
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

