Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47A2304107
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390919AbhAZOzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:55:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:12999 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391172AbhAZJex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:34:53 -0500
IronPort-SDR: bXqQGwDLj/jy5bqR6ek/50fPwI1+Nsj73pRTi7ZAKVFhsZeBtFVooUQjROmn4zsS0eN8LhysLm
 BUTV96JL9R9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264698114"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="264698114"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:32:36 -0800
IronPort-SDR: JJ07u1dxxC68zJX3ST+gnGGB2zecCsbIQ47Y+JhHUtTzdKBZkTFtlIY4NxxzgyFvx5bvrJFuS6
 W/8OnfQ41lXA==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747972"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:32:32 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 24/27] KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
Date:   Tue, 26 Jan 2021 22:31:45 +1300
Message-Id: <002d830685c07fddaf8dbece64d2ccb76866ca3f.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Emulate the four Launch Enclave public key hash MSRs (LE hash MSRs) that
exist on CPUs that support SGX Launch Control (LC).  SGX LC modifies the
behavior of ENCLS[EINIT] to use the LE hash MSRs when verifying the key
used to sign an enclave.  On CPUs without LC support, the LE hash is
hardwired into the CPU to an Intel controlled key (the Intel key is also
the reset value of the LE hash MSRs). Track the guest's desired hash so
that a future patch can stuff the hash into the hardware MSRs when
executing EINIT on behalf of the guest, when those MSRs are writable in
host.

Note, KVM allows writes to the LE hash MSRs if IA32_FEATURE_CONTROL is
unlocked.  This is technically not architectural behavior, but it's
roughly equivalent to the arch behavior of the MSRs being writable prior
to activating SGX[1].  Emulating SGX activation is feasible, but adds no
tangible benefits and would just create extra work for KVM and guest
firmware.

[1] SGX related bits in IA32_FEATURE_CONTROL cannot be set until SGX
    is activated, e.g. by firmware.  SGX activation is triggered by
    setting bit 0 in MSR 0x7a.  Until SGX is activated, the LE hash
    MSRs are writable, e.g. to allow firmware to lock down the LE
    root key with a non-Intel value.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/sgx.c | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h |  6 ++++++
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 4 files changed, 63 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 4281045318ac..6ad6a24c4e93 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -12,6 +12,9 @@
 
 bool __read_mostly enable_sgx;
 
+/* Initial value of guest's virtual SGX_LEPUBKEYHASHn MSRs */
+static u64 sgx_pubkey_hash[4] __ro_after_init;
+
 /*
  * ENCLS's memory operands use a fixed segment (DS) and a fixed
  * address size based on the mode.  Related prefixes are ignored.
@@ -292,3 +295,35 @@ int handle_encls(struct kvm_vcpu *vcpu)
 	}
 	return 1;
 }
+
+void setup_default_sgx_lepubkeyhash(void)
+{
+	/*
+	 * Use Intel's default value for Skylake hardware if Launch Control is
+	 * not supported, i.e. Intel's hash is hardcoded into silicon, or if
+	 * Launch Control is supported and enabled, i.e. mimic the reset value
+	 * and let the guest write the MSRs at will.  If Launch Control is
+	 * supported but disabled, then use the current MSR values as the hash
+	 * MSRs exist but are read-only (locked and not writable).
+	 */
+	if (!enable_sgx || !boot_cpu_has(X86_FEATURE_SGX_LC) ||
+	    rdmsrl_safe(MSR_IA32_SGXLEPUBKEYHASH0, &sgx_pubkey_hash[0])) {
+		sgx_pubkey_hash[0] = 0xa6053e051270b7acULL;
+		sgx_pubkey_hash[1] = 0x6cfbe8ba8b3b413dULL;
+		sgx_pubkey_hash[2] = 0xc4916d99f2b3735dULL;
+		sgx_pubkey_hash[3] = 0xd4f8c05909f9bb3bULL;
+	} else {
+		/* MSR_IA32_SGXLEPUBKEYHASH0 is read above */
+		rdmsrl(MSR_IA32_SGXLEPUBKEYHASH1, sgx_pubkey_hash[1]);
+		rdmsrl(MSR_IA32_SGXLEPUBKEYHASH2, sgx_pubkey_hash[2]);
+		rdmsrl(MSR_IA32_SGXLEPUBKEYHASH3, sgx_pubkey_hash[3]);
+	}
+}
+
+void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	memcpy(vmx->msr_ia32_sgxlepubkeyhash, sgx_pubkey_hash,
+	       sizeof(sgx_pubkey_hash));
+}
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
index 6e17ecd4aca3..6502fa52c7e9 100644
--- a/arch/x86/kvm/vmx/sgx.h
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -8,8 +8,14 @@
 extern bool __read_mostly enable_sgx;
 
 int handle_encls(struct kvm_vcpu *vcpu);
+
+void setup_default_sgx_lepubkeyhash(void);
+void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu);
 #else
 #define enable_sgx 0
+
+static inline void setup_default_sgx_lepubkeyhash(void) { }
+static inline void vcpu_setup_sgx_lepubkeyhash(struct kvm_vcpu *vcpu) { }
 #endif
 
 #endif /* __KVM_X86_SGX_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dbe585329842..349585f63c4d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1888,6 +1888,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_FEAT_CTL:
 		msr_info->data = vmx->msr_ia32_feature_control;
 		break;
+	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+			return 1;
+		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
+			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
+		break;
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
@@ -2154,6 +2161,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
 		break;
+	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
+		if (!msr_info->host_initiated &&
+		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
+		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
+		    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
+			return 1;
+		vmx->msr_ia32_sgxlepubkeyhash
+			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
+		break;
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
@@ -6957,6 +6973,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
+	vcpu_setup_sgx_lepubkeyhash(vcpu);
+
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
 
@@ -7907,6 +7925,8 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 
+	setup_default_sgx_lepubkeyhash();
+
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 903f246b5abd..af4bced6c84b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -299,6 +299,8 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
+	/* SGX Launch Control public key hash */
+	u64 msr_ia32_sgxlepubkeyhash[4];
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
-- 
2.29.2

