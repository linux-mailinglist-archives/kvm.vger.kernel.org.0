Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50404776F0
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfG0FwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfG0FwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568626"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 16/21] KVM: VMX: Edd emulation of SGX Launch Control LE hash MSRs
Date:   Fri, 26 Jul 2019 22:52:09 -0700
Message-Id: <20190727055214.9282-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGX Launch Control (LC) modifies the behavior of ENCLS[EINIT] to query
a set of user-controllable MSRs (Launch Enclave, a.k.a. LE, Hash MSRs)
when verifying the key used to sign an enclave.  On CPUs without LC
support, the public key hash of allowed LEs is hardwired into the CPU to
an Intel controlled key (the Intel key is also the reset value of the LE
hash MSRs).  Track the guest's desired hash and stuff it into hardware
when executing EINIT on behalf of the guest (in a future patch).

Note, KVM allows writes to the LE hash MSRs if IA32_FEATURE_CONTROL is
unlocked.  This is technically not arch behavior, but it's roughly
equivalent to the arch behavior of the MSRs being writable prior to
activating SGX[1].  Emulating SGX activation is feasible, but adds no
tangible benefits and would just create extra work for KVM and guest
firmware.

[1] SGX related bits in IA32_FEATURE_CONTROL cannot be set until SGX
    is activated, e.g. by firmware.  SGX activation is triggered by
    setting bit 0 in MSR 0x7a.  Until SGX is activated, the LE hash
    MSRs are writable, e.g. to allow firmware to lock down the LE
    root key with a non-Intel value.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index abcd2f7a36f5..819c47fee157 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -390,6 +390,8 @@ static const struct kvm_vmx_segment_field {
 
 u64 host_efer;
 
+static u64 sgx_pubkey_hash[4] __ro_after_init;
+
 /*
  * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
  * will emulate SYSCALL in legacy mode if the vendor string in guest
@@ -1740,6 +1742,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_FEATURE_CONTROL:
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
@@ -1953,6 +1962,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
 		break;
+	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
+		if (!msr_info->host_initiated &&
+		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
+		    ((vmx->msr_ia32_feature_control & FEATURE_CONTROL_LOCKED) &&
+		    !(vmx->msr_ia32_feature_control & FEATURE_CONTROL_SGX_LE_WR))))
+			return 1;
+		vmx->msr_ia32_sgxlepubkeyhash
+			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
+		break;
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
@@ -6698,6 +6716,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	else
 		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
+	memcpy(vmx->msr_ia32_sgxlepubkeyhash, sgx_pubkey_hash,
+	       sizeof(sgx_pubkey_hash));
+
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
 
@@ -7588,6 +7609,27 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 
+	/*
+	 * Use Intel's default value for Skylake hardware if Launch Control is
+	 * not supported, i.e. Intel's hash is hardcoded into silicon, or if
+	 * Launch Control is supported and enabled, i.e. mimic the reset value
+	 * and let the guest write the MSRs at will.  If Launch Control is
+	 * supported but disabled, then we have to use the current MSR values
+	 * as the MSRs the hash MSRs exist but are locked and not writable.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SGX_LC) ||
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
+
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept, enable_apicv);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6d1b57e0337e..1519c6918190 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -272,6 +272,8 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
+	/* SGX Launch Control public key hash */
+	u64 msr_ia32_sgxlepubkeyhash[4];
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
-- 
2.22.0

