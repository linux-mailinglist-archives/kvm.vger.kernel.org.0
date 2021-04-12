Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFB135B943
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhDLEWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:53388 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhDLEWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:34 -0400
IronPort-SDR: qhkqrJDnblzuELmJkPd+eAgOLDFKLfJcXjjJfyV/TB6KaZ15/fwGlvEeSbLS4pgiJIMPnyeuIZ
 T26YqNQY3dAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083786"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083786"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:16 -0700
IronPort-SDR: WhfeRJYvuWM6PRlq0vMvbyseBPccnUFpj7WksvOOinmkMmWE85/CqMFSPfBPrqx5YvG4LN24ZT
 /0NkfrhFa+sg==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030437"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:14 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 08/11] KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
Date:   Mon, 12 Apr 2021 16:21:40 +1200
Message-Id: <c58ef601ddf88f3a113add837969533099b1364a.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
v4->v5:
 - rebase to latest kvm/queue.

---
 arch/x86/kvm/vmx/sgx.c | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h |  6 ++++++
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  3 +++
 4 files changed, 64 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 2cf9d7cf818c..d53e6b17b320 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -11,6 +11,9 @@
 
 bool __read_mostly enable_sgx;
 
+/* Initial value of guest's virtual SGX_LEPUBKEYHASHn MSRs */
+static u64 sgx_pubkey_hash[4] __ro_after_init;
+
 /*
  * ENCLS's memory operands use a fixed segment (DS) and a fixed
  * address size based on the mode.  Related prefixes are ignored.
@@ -323,3 +326,35 @@ int handle_encls(struct kvm_vcpu *vcpu)
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
+	if (!enable_sgx || boot_cpu_has(X86_FEATURE_SGX_LC) ||
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
index d21036457c40..ccf49f596f28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1922,6 +1922,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2216,6 +2223,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -6978,6 +6994,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
+	vcpu_setup_sgx_lepubkeyhash(vcpu);
+
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
 
@@ -7915,6 +7933,8 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 
+	setup_default_sgx_lepubkeyhash();
+
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7886a08505cc..19fe09fad2fe 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,6 +325,9 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
+	/* SGX Launch Control public key hash */
+	u64 msr_ia32_sgxlepubkeyhash[4];
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	u64 hv_root_ept;
 #endif
-- 
2.30.2

