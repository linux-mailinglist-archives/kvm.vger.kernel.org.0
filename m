Return-Path: <kvm+bounces-14123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD62A89F9F7
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BE7C1C22B40
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A00616DECB;
	Wed, 10 Apr 2024 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mAM6hD8s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ECC16D9D6;
	Wed, 10 Apr 2024 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759720; cv=none; b=fMdRsO6BAPjdSiQGYpGexJeTFWOeKygU1aWPe2jsLsp7UQEyjd2VkPR3KaZ/2ZWlgBGwLd8jtXj2iMLnBTMxNgJc4/TSKzlx0CytMH9ZlQVWLIWOsPwkmCnyS1Yi/RTq7/65KMW4GNjvivEV+zd4j1hhlaWqnqzhNbSy+yZwBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759720; c=relaxed/simple;
	bh=lp3rXRKa6Fi/CTX+nXd22i7jmZlFr/jrwPBQoIWIaag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=au+D5ld0xusUtoo68voXPNhUrtMcR9E7ddKgUERQyab7QWnClRUAYI6IowccFddWvr4aJ6kEZ0YnAUoCq4Hru8jcGe1mx5VEKWBWav+S7AizM6uVx00q2/77cx8fhoyQSYnDuSWv8H/zxAa3TmLnXt0tjtYVWTKrIArH6qJ5zYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mAM6hD8s; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759718; x=1744295718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lp3rXRKa6Fi/CTX+nXd22i7jmZlFr/jrwPBQoIWIaag=;
  b=mAM6hD8sfh0IlQoEiviKyEJNQJbt08dWsVlMymLxDZWhCY/krji5gPE/
   CbgEusAtWc8t+IeX03IcgQ1lA0g7livWYndE0AVgZElIIFNRHCLfbxxUD
   E8TdLQGYg8ZfuPK6eqNeaZqCfy9GsKzVz0KIbFdKDdM/GEBIALJnIcpZz
   MGjbmzGugQ2zfWajk+u7iRCak7sysoZFWVXgJGS+cCTJgLdrq2gwV6DfN
   XKewnLc/w5X+XMwU0XlBxSZEJLwnRO4GtNCZK9KvNEEaAbT2tPpKlcDKR
   XrwMFX60BPdJq1G9g4uhY6By+KyYRwomlTqjZP/Wn4uVeH9oH8FCweFZr
   A==;
X-CSE-ConnectionGUID: +ibCV/esS5aVBOkZkHyxyw==
X-CSE-MsgGUID: zv9z4XyzTjyVTNdEINiKLg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837741"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837741"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:18 -0700
X-CSE-ConnectionGUID: k+Sjza0NTwagt4rdPS9t7w==
X-CSE-MsgGUID: 6jMrHIHFTxmj0dV9tcelWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095489"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:13 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v3 01/10] KVM: VMX: Virtualize Intel IA32_SPEC_CTRL
Date: Wed, 10 Apr 2024 22:34:29 +0800
Message-Id: <20240410143446.797262-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
written to IA32_SPEC_CTRL by guest. The guest is allowed to write any
value directly to hardware. There is a tertiary control for
IA32_SPEC_CTRL. This control allows for bits in IA32_SPEC_CTRL to be
masked to prevent guests from changing those bits.

Add controls setting the mask for IA32_SPEC_CTRL and desired value for
masked bits.

These new controls are especially helpful for protecting guests that
don't know about BHI_DIS_S and that are running on hardware that
supports it. This allows the hypervisor to set BHI_DIS_S to fully
protect the guest.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
[ add a new ioctl to report supported bits. Fix the inverted check ]
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 Documentation/virt/kvm/api.rst     | 39 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  4 ++
 arch/x86/include/asm/vmx.h         |  5 +++
 arch/x86/include/asm/vmxfeatures.h |  2 +
 arch/x86/kvm/vmx/capabilities.h    |  5 +++
 arch/x86/kvm/vmx/vmx.c             | 68 +++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h             |  3 +-
 arch/x86/kvm/x86.c                 | 30 +++++++++++++
 arch/x86/kvm/x86.h                 |  1 +
 include/uapi/linux/kvm.h           |  4 ++
 10 files changed, 155 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..b6eeb1d6eb65 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6352,6 +6352,19 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_GET_SUPPORTED_FORCE_SPEC_CTRL
+---------------------------------------
+
+:Capability: KVM_CAP_FORCE_SPEC_CTRL
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: u64 supported_bitmask (out)
+:Returns: 0 on success, -EFAULT if supported_bitmap cannot be accessed
+
+Returns a bitmask of SPEC_CTRL MSR bits which can be forced on. All bits can be
+forced to 0 (i.e., prevent guest from setting it) even if KVM doesn't support
+the bit.
+
 5. The kvm_run structure
 ========================
 
@@ -8063,6 +8076,32 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_FORCE_SPEC_CTRL
+----------------------------
+
+:Architectures: x86
+:Parameters: args[0] contains the bitmask to prevent guests from modifying those
+	     bits
+	     args[1] contains the desired value to set in IA32_SPEC_CTRL for the
+	     masked bits
+:Returns: 0 on success, -EINVAL if args[0] or args[1] contain invalid values
+
+This capability allows userspace to configure the value of IA32_SPEC_CTRL and
+what bits the VM can and cannot access. This is especially useful when a VM is
+migrated to newer hardware with hardware based speculation mitigations not
+provided to the VM previously.
+
+IA32_SPEC_CTRL virtualization works by introducing the IA32_SPEC_CTRL shadow
+and mask fields. When a guest writes to IA32_SPEC_CTRL when it is virtualized
+the value written is:
+
+(GUEST_WRMSR_VAL & ~MASK) | (REAL_MSR_VAL & MASK).
+
+No bit that is masked can be modified by the guest.
+
+The shadow field contains the value the guest wrote to the MSR and is what is
+returned to the guest when the virtualized MSR is read.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e07a2eee19..8220414cf697 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1404,6 +1404,10 @@ struct kvm_arch {
 
 	u32 notify_window;
 	u32 notify_vmexit_flags;
+
+	u64 force_spec_ctrl_mask;
+	u64 force_spec_ctrl_value;
+
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4dba17363008..f65651a3898c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -84,6 +84,7 @@
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
  */
 #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+#define TERTIARY_EXEC_SPEC_CTRL_SHADOW		VMCS_CONTROL_BIT(SPEC_CTRL_SHADOW)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -236,6 +237,10 @@ enum vmcs_field {
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	IA32_SPEC_CTRL_MASK             = 0x0000204A,
+	IA32_SPEC_CTRL_MASK_HIGH        = 0x0000204B,
+	IA32_SPEC_CTRL_SHADOW           = 0x0000204C,
+	IA32_SPEC_CTRL_SHADOW_HIGH      = 0x0000204D,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 266daf5b5b84..6dbfe9004d92 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -90,4 +90,6 @@
 
 /* Tertiary Processor-Based VM-Execution Controls, word 3 */
 #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
+#define VMX_FEATURE_SPEC_CTRL_SHADOW	( 3*32+  7) /* IA32_SPEC_CTRL shadow */
+
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..6c51a5abb16b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -138,6 +138,11 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static inline bool cpu_has_spec_ctrl_shadow(void)
+{
+	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_SPEC_CTRL_SHADOW;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..a6154d725025 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2008,7 +2008,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		msr_info->data = to_vmx(vcpu)->spec_ctrl;
+		if (cpu_has_spec_ctrl_shadow())
+			msr_info->data = vmcs_read64(IA32_SPEC_CTRL_SHADOW);
+		else
+			msr_info->data = to_vmx(vcpu)->spec_ctrl;
 		break;
 	case MSR_IA32_SYSENTER_CS:
 		msr_info->data = vmcs_read32(GUEST_SYSENTER_CS);
@@ -2148,6 +2151,19 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static void vmx_set_spec_ctrl(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->spec_ctrl = val;
+
+	if (cpu_has_spec_ctrl_shadow()) {
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
+
+		vmx->spec_ctrl |= vcpu->kvm->arch.force_spec_ctrl_value;
+	}
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2273,7 +2289,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
-		vmx->spec_ctrl = data;
+		vmx_set_spec_ctrl(vcpu, data);
+
 		if (!data)
 			break;
 
@@ -4785,6 +4802,23 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_xsaves())
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
+	if (cpu_has_spec_ctrl_shadow()) {
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, 0);
+
+		/*
+		 * Note, IA32_SPEC_CTRL_{SHADOW,MASK} subtly behave *very*
+		 * differently than other shadow+mask combinations.  Attempts
+		 * to modify bits in MASK are silently ignored and do NOT cause
+		 * a VM-Exit.  This allows the host to force bits to be set or
+		 * cleared on behalf of the guest, while still allowing the
+		 * guest modify other bits at will, without triggering VM-Exits.
+		 */
+		if (kvm->arch.force_spec_ctrl_mask)
+			vmcs_write64(IA32_SPEC_CTRL_MASK, kvm->arch.force_spec_ctrl_mask);
+		else
+			vmcs_write64(IA32_SPEC_CTRL_MASK, 0);
+	}
+
 	if (enable_pml) {
 		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
 		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
@@ -4853,7 +4887,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		__vmx_vcpu_reset(vcpu);
 
 	vmx->rmode.vm86_active = 0;
-	vmx->spec_ctrl = 0;
+	vmx_set_spec_ctrl(vcpu, 0);
 
 	vmx->msr_ia32_umwait_control = 0;
 
@@ -7211,8 +7245,14 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
 		return;
 
-	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
-		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+	if (flags & VMX_RUN_SAVE_SPEC_CTRL) {
+		if (cpu_has_spec_ctrl_shadow())
+			vmx->spec_ctrl = (vmcs_read64(IA32_SPEC_CTRL_SHADOW) &
+					~vmx->vcpu.kvm->arch.force_spec_ctrl_mask) |
+					 vmx->vcpu.kvm->arch.force_spec_ctrl_value;
+		else
+			vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+	}
 
 	/*
 	 * If the guest/host SPEC_CTRL values differ, restore the host value.
@@ -8598,6 +8638,24 @@ static __init int hardware_setup(void)
 	kvm_caps.tsc_scaling_ratio_frac_bits = 48;
 	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
 	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
+	kvm_caps.supported_force_spec_ctrl = 0;
+
+	if (cpu_has_spec_ctrl_shadow()) {
+		kvm_caps.supported_force_spec_ctrl |= SPEC_CTRL_IBRS;
+
+		if (boot_cpu_has(X86_FEATURE_STIBP))
+			kvm_caps.supported_force_spec_ctrl |= SPEC_CTRL_STIBP;
+
+		if (boot_cpu_has(X86_FEATURE_SSBD))
+			kvm_caps.supported_force_spec_ctrl |= SPEC_CTRL_SSBD;
+
+		if (boot_cpu_has(X86_FEATURE_RRSBA_CTRL) &&
+		    (host_arch_capabilities & ARCH_CAP_RRSBA))
+			kvm_caps.supported_force_spec_ctrl |= SPEC_CTRL_RRSBA_DIS_S;
+
+		if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
+			kvm_caps.supported_force_spec_ctrl |= SPEC_CTRL_BHI_DIS_S;
+	}
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..f26ac82b5a59 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -578,7 +578,8 @@ static inline u8 vmx_get_rvi(void)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-	(TERTIARY_EXEC_IPI_VIRT)
+	(TERTIARY_EXEC_IPI_VIRT |					\
+	 TERTIARY_EXEC_SPEC_CTRL_SHADOW)
 
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 984ea2089efc..9a59b5a93d0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4836,6 +4836,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
 			r |= BIT(KVM_X86_SW_PROTECTED_VM);
 		break;
+	case KVM_CAP_FORCE_SPEC_CTRL:
+		r = !!kvm_caps.supported_force_spec_ctrl;
+		break;
 	default:
 		break;
 	}
@@ -4990,6 +4993,13 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = kvm_x86_dev_has_attr(&attr);
 		break;
 	}
+	case KVM_GET_SUPPORTED_FORCE_SPEC_CTRL: {
+		r = 0;
+		if (copy_to_user(argp, &kvm_caps.supported_force_spec_ctrl,
+				 sizeof(kvm_caps.supported_force_spec_ctrl)))
+			r = -EFAULT;
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
@@ -6729,6 +6739,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_FORCE_SPEC_CTRL:
+		r = -EINVAL;
+
+		mutex_lock(&kvm->lock);
+
+		/*
+		 * Note, only the value is restricted to known bits that KVM
+		 * can force on.  Userspace is allowed to set any mask bits,
+		 * i.e. can prevent the guest from setting a bit, even if KVM
+		 * doesn't support the bit.
+		 */
+		if (kvm_caps.supported_force_spec_ctrl && !kvm->created_vcpus &&
+		    !(~kvm_caps.supported_force_spec_ctrl & cap->args[1]) &&
+		    !(~cap->args[0] & cap->args[1])) {
+			kvm->arch.force_spec_ctrl_mask = cap->args[0];
+			kvm->arch.force_spec_ctrl_value = cap->args[1];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8b71803777b..6dd12776b310 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -29,6 +29,7 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+	u64 supported_force_spec_ctrl;
 };
 
 void kvm_spurious_fault(void);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..fb918bdb930c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_FORCE_SPEC_CTRL 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1243,6 +1244,9 @@ struct kvm_vfio_spapr_tce {
 #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct kvm_device_attr)
 #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct kvm_device_attr)
 
+/* Available with KVM_CAP_FORCE_SPEC_CTRL */
+#define KVM_GET_SUPPORTED_FORCE_SPEC_CTRL _IOR(KVMIO,  0xe4, __u64)
+
 /*
  * ioctls for vcpu fds
  */
-- 
2.39.3


