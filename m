Return-Path: <kvm+bounces-38749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56CDA3E1FB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BDF9178C99
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5522D222565;
	Thu, 20 Feb 2025 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAr5MP5d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0921C175
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071209; cv=none; b=UiR/GmmwLbHGNHsyRA5GBSJH17yOgUYIguzQRLMYu6AdwSuhBx9IZYklPNO/0WOux5hVB0YKCU5tmOPYUpCOdzW5vEDPPweHUp4k7uTlM7f589J/71Ap3bEc0KGpqyTA42zfLunBXJp6mSWGrMZGM5+eQKJEvY8mMbx8aWxO50w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071209; c=relaxed/simple;
	bh=UCUf0WyaxvAozDgNJlMmXYQQR4qcCYaO/4RPAwrQSfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOZLtxytZfSiSViB+Oz/Dr1m6XyoPzAjhECndsCcRb9zbvksvI5F+b3zJObqQpbEUvOGRUjiAhMnDbrOr9kd8uAXbiXa339vw4/W+IIB6SdnUFyfDBA2xFxbJwrtgzV+RAVSvtRYURxsx+SD+Ec26RkMgGd8LPyVAkZCM/CINGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAr5MP5d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pkrWwiFaHZ0PGvjtFhAWrOFEruuB86cN9cT+7PSgjU=;
	b=NAr5MP5d1ZI2LuEkdTE4meBkCCBbTs/Ub8TEzuWl9/Stxvq6TQgCczT38PqQg6w6R/nU3i
	RrEmB64zGfsEHWIj3hX5+6BE0OMMA1xz5izfMlVcfe+1+7dN+s20jwM4pd0KdCW+ByDDZ6
	mJ0ihjieOvUK+3kuaFoIHD5br2xjT0w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-wSHAWirlNWehX0sLT43a6Q-1; Thu,
 20 Feb 2025 12:06:42 -0500
X-MC-Unique: wSHAWirlNWehX0sLT43a6Q-1
X-Mimecast-MFC-AGG-ID: wSHAWirlNWehX0sLT43a6Q_1740071201
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2BCE190F9C9;
	Thu, 20 Feb 2025 17:06:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DA5D119412A3;
	Thu, 20 Feb 2025 17:06:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 23/30] KVM: TDX: initialize VM with TDX specific parameters
Date: Thu, 20 Feb 2025 12:05:57 -0500
Message-ID: <20250220170604.2279312-24-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

After the crypto-protection key has been configured, TDX requires a
VM-scope initialization as a step of creating the TDX guest.  This
"per-VM" TDX initialization does the global configurations/features that
the TDX guest can support, such as guest's CPUIDs (emulated by the TDX
module), the maximum number of vcpus etc.

This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
to be done before KVM creates any vcpus.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  24 +++
 arch/x86/kvm/vmx/tdx.c          | 258 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h          |  25 ++++
 3 files changed, 297 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 8a4633cdb247..b64351076f2a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -930,6 +930,7 @@ struct kvm_hyperv_eventfd {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -961,4 +962,27 @@ struct kvm_tdx_capabilities {
 	struct kvm_cpuid2 cpuid;
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 xfam;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+
+	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+	__u64 reserved[12];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 60c26600bf18..ec8864453787 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -69,6 +69,11 @@ static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
 	return val;
 }
 
+static int tdx_get_guest_phys_addr_bits(const u32 eax)
+{
+	return (eax & GENMASK(23, 16)) >> 16;
+}
+
 static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
 {
 	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
@@ -365,7 +370,11 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 
 void tdx_vm_free(struct kvm *kvm)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
 	tdx_reclaim_td_control_pages(kvm);
+
+	kvm_tdx->state = TD_STATE_UNINITIALIZED;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -384,10 +393,10 @@ static int tdx_do_tdh_mng_key_config(void *param)
 	return 0;
 }
 
-static int __tdx_td_init(struct kvm *kvm);
-
 int tdx_vm_init(struct kvm *kvm)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
 	kvm->arch.has_private_mem = true;
 
 	/*
@@ -403,8 +412,9 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
 
-	/* Place holder for TDX specific logic. */
-	return __tdx_td_init(kvm);
+	kvm_tdx->state = TD_STATE_UNINITIALIZED;
+
+	return 0;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -455,15 +465,151 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
-static int __tdx_td_init(struct kvm *kvm)
+/*
+ * KVM reports guest physical address in CPUID.0x800000008.EAX[23:16], which is
+ * similar to TDX's GPAW. Use this field as the interface for userspace to
+ * configure the GPAW and EPT level for TDs.
+ *
+ * Only values 48 and 52 are supported. Value 52 means GPAW-52 and EPT level
+ * 5, Value 48 means GPAW-48 and EPT level 4. For value 48, GPAW-48 is always
+ * supported. Value 52 is only supported when the platform supports 5 level
+ * EPT.
+ */
+static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
+					struct td_params *td_params)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	int guest_pa;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
+	if (!entry)
+		return -EINVAL;
+
+	guest_pa = tdx_get_guest_phys_addr_bits(entry->eax);
+
+	if (guest_pa != 48 && guest_pa != 52)
+		return -EINVAL;
+
+	if (guest_pa == 52 && !cpu_has_vmx_ept_5levels())
+		return -EINVAL;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+	if (guest_pa == 52) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->config_flags |= TDX_CONFIG_FLAGS_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	return 0;
+}
+
+static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+				 struct td_params *td_params)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	const struct kvm_cpuid_entry2 *entry;
+	struct tdx_cpuid_value *value;
+	int i, copy_cnt = 0;
+
+	/*
+	 * td_params.cpuid_values: The number and the order of cpuid_value must
+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
+	 * It's assumed that td_params was zeroed.
+	 */
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		struct kvm_cpuid_entry2 tmp;
+
+		td_init_cpuid_entry2(&tmp, i);
+
+		entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
+					      tmp.function, tmp.index);
+		if (!entry)
+			continue;
+
+		copy_cnt++;
+
+		value = &td_params->cpuid_values[i];
+		value->eax = entry->eax;
+		value->ebx = entry->ebx;
+		value->ecx = entry->ecx;
+		value->edx = entry->edx;
+
+		/*
+		 * TDX module does not accept nonzero bits 16..23 for the
+		 * CPUID[0x80000008].EAX, see setup_tdparams_eptp_controls().
+		 */
+		if (tmp.function == 0x80000008)
+			value->eax = tdx_set_guest_phys_addr_bits(value->eax, 0);
+	}
+
+	/*
+	 * Rely on the TDX module to reject invalid configuration, but it can't
+	 * check of leafs that don't have a proper slot in td_params->cpuid_values
+	 * to stick then. So fail if there were entries that didn't get copied to
+	 * td_params.
+	 */
+	if (copy_cnt != cpuid->nent)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
+	int ret;
+
+	if (kvm->created_vcpus)
+		return -EBUSY;
+
+	if (init_vm->attributes & ~tdx_get_supported_attrs(td_conf))
+		return -EINVAL;
+
+	if (init_vm->xfam & ~tdx_get_supported_xfam(td_conf))
+		return -EINVAL;
+
+	td_params->max_vcpus = kvm->max_vcpus;
+	td_params->attributes = init_vm->attributes | td_conf->attributes_fixed1;
+	td_params->xfam = init_vm->xfam | td_conf->xfam_fixed1;
+
+	td_params->config_flags = TDX_CONFIG_FLAGS_NO_RBP_MOD;
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
+
+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
+	if (ret)
+		return ret;
+
+	ret = setup_tdparams_cpuids(cpuid, td_params);
+	if (ret)
+		return ret;
+
+#define MEMCPY_SAME_SIZE(dst, src)				\
+	do {							\
+		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
+		memcpy((dst), (src), sizeof(dst));		\
+	} while (0)
+
+	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
+	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
+	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
+
+	return 0;
+}
+
+static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
+			 u64 *seamcall_err)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages;
 	struct page **tdcs_pages = NULL;
 	struct page *tdr_page;
 	int ret, i;
-	u64 err;
+	u64 err, rcx;
 
+	*seamcall_err = 0;
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
@@ -575,10 +721,23 @@ static int __tdx_td_init(struct kvm *kvm)
 		}
 	}
 
-	/*
-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
-	 * ioctl() to define the configure CPUID values for the TD.
-	 */
+	err = tdh_mng_init(&kvm_tdx->td, __pa(td_params), &rcx);
+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
+		/*
+		 * Because a user gives operands, don't warn.
+		 * Return a hint to the user because it's sometimes hard for the
+		 * user to figure out which operand is invalid.  SEAMCALL status
+		 * code includes which operand caused invalid operand error.
+		 */
+		*seamcall_err = err;
+		ret = -EINVAL;
+		goto teardown;
+	} else if (WARN_ON_ONCE(err)) {
+		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
+		ret = -EIO;
+		goto teardown;
+	}
+
 	return 0;
 
 	/*
@@ -626,6 +785,82 @@ static int __tdx_td_init(struct kvm *kvm)
 	return ret;
 }
 
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm;
+	struct td_params *td_params = NULL;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (kvm_tdx->state != TD_STATE_UNINITIALIZED)
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	init_vm = kmalloc(sizeof(*init_vm) +
+			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+			  GFP_KERNEL);
+	if (!init_vm)
+		return -ENOMEM;
+
+	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	if (copy_from_user(init_vm->cpuid.entries,
+			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
+			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (init_vm->cpuid.padding) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
+	if (!td_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = setup_tdparams(kvm, td_params, init_vm);
+	if (ret)
+		goto out;
+
+	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
+	if (ret)
+		goto out;
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+
+	kvm_tdx->state = TD_STATE_INITIALIZED;
+out:
+	/* kfree() accepts NULL. */
+	kfree(init_vm);
+	kfree(td_params);
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -647,6 +882,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_CAPABILITIES:
 		r = tdx_get_capabilities(&tdx_cmd);
 		break;
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8102461f775d..f12854c8ff07 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -11,9 +11,23 @@ void tdx_cleanup(void);
 
 extern bool enable_tdx;
 
+/* TDX module hardware states. These follow the TDX module OP_STATEs. */
+enum kvm_tdx_state {
+	TD_STATE_UNINITIALIZED = 0,
+	TD_STATE_INITIALIZED,
+	TD_STATE_RUNNABLE,
+};
+
 struct kvm_tdx {
 	struct kvm kvm;
+
 	int hkid;
+	enum kvm_tdx_state state;
+
+	u64 attributes;
+	u64 xfam;
+
+	u64 tsc_offset;
 
 	struct tdx_td td;
 };
@@ -33,6 +47,17 @@ static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
 	return is_td(vcpu->kvm);
 }
 
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	u64 err, data;
+
+	err = tdh_mng_rd(&kvm_tdx->td, TDCS_EXEC(field), &data);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		return 0;
+	}
+	return data;
+}
 #else
 static inline int tdx_bringup(void) { return 0; }
 static inline void tdx_cleanup(void) {}
-- 
2.43.5



