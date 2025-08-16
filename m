Return-Path: <kvm+bounces-54836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071D2B28E94
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 16:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AFD97BAB84
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 14:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16B22F60D3;
	Sat, 16 Aug 2025 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QJ3UeKI1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2972D2F0C64;
	Sat, 16 Aug 2025 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755355501; cv=none; b=At8va2gzEX2AP2JMgzUdeI2JKO1KfxJTZHe+L7lSOQvzylXpTfiIBLlS0EkNrrBfEmDNHcuTm65gR02KvOwQtzKtjJq/neIy4uuCpZbeC+oqudlFK/hOy+C3eofVgvfE4XN6Yto2z2SNCUl00YCw6R9frbq8tjhC7GJ9G9jsg1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755355501; c=relaxed/simple;
	bh=nxaZ5rLodTUBsxVd5XYQtVcb791QDELrBcEKjfDaopg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdtRAO2zYOAD8SeZ3gLknHxtWhwDo9JWKe2CeicNdoLjBQFYFRw0Fu3J/K1m2/7K7y7sjkTWn1xATlkT6HyNL3zt3Z9P9IRIovt8elAiwxjkl63Bnfq6mfGYQKUzYs0fZELPX5/YQdvnGLX2n/B6/dhYhnbwrODKlmODCgmRBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QJ3UeKI1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755355500; x=1786891500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nxaZ5rLodTUBsxVd5XYQtVcb791QDELrBcEKjfDaopg=;
  b=QJ3UeKI1JDIsOF/2/dtRUN/dsygh6h9+YW1D0O9lf9tPNL8H0JD9jrEJ
   e48CJRLYz1Q4KAIcC5hO53zd33powx86LIpntnepT/B9ZrkV7fnbX7Tlp
   qc2VPyv+rRXykDtSECmuyYk2Y0zzuh/S/irL9rMLF7ryWzwDIHckXiGWQ
   jLG10Vt3teuw5nhG/6iGTVNBQiXyTqhCLaT7Iiab1DLZ+EQCO3pTcVWbc
   w0ZCWWhz69630nsX2E1nstBXYkmzKRIOJjqpmKc/+q5ta9zTKU/DeWVt2
   3DsPpHJF/RwiEfbqeRkjnhKVEcWaZFIVL0Bex37i9W2hju+rbgWOniAlr
   g==;
X-CSE-ConnectionGUID: 3MPJsmeCQNKSjXU5eBiOdg==
X-CSE-MsgGUID: ncYYr5bYS+i8EzCBCG1YrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57508500"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57508500"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:45:00 -0700
X-CSE-ConnectionGUID: 6mnG0BvdQSqzgLIE55rb7g==
X-CSE-MsgGUID: XCCewDyIQcCMz6ijXM6dzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="198220481"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:44:54 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	ira.weiny@intel.com
Subject: [PATCH RFC 2/2] KVM: TDX: Add flag to support MWAIT instruction only
Date: Sat, 16 Aug 2025 17:44:35 +0300
Message-ID: <20250816144436.83718-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250816144436.83718-1-adrian.hunter@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Add a TDX-specific flag to allow for using the MWAIT instruction in a
guest.  This provides for users that understand the limitations that TDX
has compared with VMX in this regard.

The limitations are:

 1. TDX Module versions prior to 1.5.09 and 2.0.04 do not expose the
    Always-Running-APIC-Timer (ARAT) feature (CPUID leaf 6: EAX bit 2),
    which a TDX guest may need for correct handling of deep C-states.

    For example, with a Linux guest, that results in cpuidle disabling the
    timer interrupt and invoking the Tick Broadcast framework to provide a
    wake-up.  Currently, that falls back to the PIT timer which does not
    work for TDX, resulting in the guest becoming stuck in the idle loop.

 2. TDX Module versions 1.5.09 and 2.0.04 or later support #VE reduction,
    which, if the guest opts to enable it, results in the TDX Module
    injecting #GP for accesses to MSRs that the guest could reasonably
    assume to exist if the MWAIT feature is available.

A Linux guest could possibly be used with TDX support for MWAIT, for
example by:

 a)	- Using TDX Module versions 1.5.09 and 2.0.04 or later, and
	- Using acpi_idle driver with suitable ACPI tables like _CST

 b)	- Using TDX Module versions 1.5.09 and 2.0.04 or later, and
	- Ignoring unchecked MSR access errors from intel_idle

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 28 ++++++++++-
 arch/x86/include/uapi/asm/kvm.h          |  3 ++
 arch/x86/kvm/vmx/tdx.c                   | 62 ++++++++++++++++--------
 3 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index bcfa97e0c9e7..b534a092b4c1 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -70,8 +70,12 @@ Return the TDX capabilities that current KVM supports with the specific TDX
 module loaded in the system.  It reports what features/capabilities are allowed
 to be configured to the TDX guest.
 
+KVM_TDX_FLAGS_ALLOW_MWAIT flag allows the capability to use the MWAIT
+instruction in a guest (CPUID leaf 1 ECX bit 3), but beware of the limitations,
+see "MWAIT Limitations" below.
+
 - id: KVM_TDX_CAPABILITIES
-- flags: must be 0
+- flags: must be 0, or KVM_TDX_FLAGS_ALLOW_MWAIT (if KVM_TDX_CAP_ALLOW_MWAIT)
 - data: pointer to struct kvm_tdx_capabilities
 - hw_error: must be 0
 
@@ -111,8 +115,12 @@ KVM_TDX_INIT_VM
 Perform TDX specific VM initialization.  This needs to be called after
 KVM_CREATE_VM and before creating any VCPUs.
 
+KVM_TDX_FLAGS_ALLOW_MWAIT flag allows the capability to use the MWAIT
+instruction in a guest (CPUID leaf 1 ECX bit 3), but beware of the limitations,
+see "MWAIT Limitations" below.
+
 - id: KVM_TDX_INIT_VM
-- flags: must be 0
+- flags: must be 0, or KVM_TDX_FLAGS_ALLOW_MWAIT (if KVM_TDX_CAP_ALLOW_MWAIT)
 - data: pointer to struct kvm_tdx_init_vm
 - hw_error: must be 0
 
@@ -282,6 +290,22 @@ control flow is as follows:
 
 #. Run VCPU
 
+MWAIT Limitations
+=================
+
+- TDX Module versions 1.5.09 and 2.0.04 or later support #VE reduction,
+  which, if the guest opts to enable it, results in the TDX Module
+  injecting #GP for accesses to MSRs that the guest could reasonably
+  assume to exist if the MWAIT feature is available.
+
+- TDX Module versions prior to 1.5.09 and 2.0.04 do not expose the
+  Always-Running-APIC-Timer (ARAT) feature (CPUID leaf 6: EAX bit 2),
+  which a TDX guest may need for correct handling of deep C-states.
+  For example, with a Linux guest, that results in cpuidle disabling the
+  timer interrupt and invoking the Tick Broadcast framework to provide a
+  wake-up.  Currently, that falls back to the PIT timer which does not
+  work for TDX, resulting in the guest becoming stuck in the idle loop.
+
 References
 ==========
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e019111e2150..8175e05c9e50 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -945,6 +945,8 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CMD_NR_MAX,
 };
 
+#define KVM_TDX_FLAGS_ALLOW_MWAIT	_BITUL(0)
+
 struct kvm_tdx_cmd {
 	/* enum kvm_tdx_cmd_id */
 	__u32 id;
@@ -964,6 +966,7 @@ struct kvm_tdx_cmd {
 };
 
 #define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0)
+#define KVM_TDX_CAP_ALLOW_MWAIT        _BITULL(1)
 
 struct kvm_tdx_capabilities {
 	__u64 supported_attrs;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cdf0dc6cf068..db85624e0e78 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -143,7 +143,7 @@ static void clear_mwait(struct kvm_cpuid_entry2 *entry)
 	entry->ecx &= ~__feature_bit(X86_FEATURE_MWAIT);
 }
 
-static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
+static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry, bool disallow_mwait)
 {
 	if (has_tsx(entry))
 		clear_tsx(entry);
@@ -152,18 +152,20 @@ static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
 		clear_waitpkg(entry);
 
 	/* Also KVM_X86_DISABLE_EXITS_MWAIT is disallowed in tdx_vm_init() */
-	if (has_mwait(entry))
+	if (disallow_mwait && has_mwait(entry))
 		clear_mwait(entry);
 }
 
-static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
+static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry, bool disallow_mwait)
 {
-	return has_tsx(entry) || has_waitpkg(entry) || has_mwait(entry);
+	return has_tsx(entry) || has_waitpkg(entry) ||
+	       (disallow_mwait && has_mwait(entry));
 }
 
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
 
-static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
+static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx,
+				 bool disallow_mwait)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
 
@@ -185,14 +187,15 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	if (entry->function == 0x80000008)
 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
 
-	tdx_clear_unsupported_cpuid(entry);
+	tdx_clear_unsupported_cpuid(entry, disallow_mwait);
 }
 
 #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT	BIT(1)
 
-static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
+static int init_kvm_tdx_caps(struct kvm *kvm, const struct tdx_sys_info_td_conf *td_conf,
 			     struct kvm_tdx_capabilities *caps)
 {
+	bool disallow_mwait = kvm->arch.unsupported_disable_exits & KVM_X86_DISABLE_EXITS_MWAIT;
 	int i;
 
 	caps->supported_attrs = tdx_get_supported_attrs(td_conf);
@@ -203,7 +206,7 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 	if (!caps->supported_xfam)
 		return -EIO;
 
-	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
+	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM | KVM_TDX_CAP_ALLOW_MWAIT;
 
 	caps->cpuid.nent = td_conf->num_cpuid_config;
 
@@ -211,7 +214,7 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 		TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT;
 
 	for (i = 0; i < td_conf->num_cpuid_config; i++)
-		td_init_cpuid_entry2(&caps->cpuid.entries[i], i);
+		td_init_cpuid_entry2(&caps->cpuid.entries[i], i, disallow_mwait);
 
 	return 0;
 }
@@ -2268,7 +2271,9 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	}
 }
 
-static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
+#define KVM_TDX_CAPABILITIES_FLAGS KVM_TDX_FLAGS_ALLOW_MWAIT
+
+static int tdx_get_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
 	struct kvm_tdx_capabilities __user *user_caps;
@@ -2276,10 +2281,12 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	u32 nr_user_entries;
 	int ret = 0;
 
-	/* flags is reserved for future use */
-	if (cmd->flags)
+	if (cmd->flags & ~KVM_TDX_CAPABILITIES_FLAGS)
 		return -EINVAL;
 
+	if (cmd->flags & KVM_TDX_FLAGS_ALLOW_MWAIT)
+		kvm->arch.unsupported_disable_exits &= ~KVM_X86_DISABLE_EXITS_MWAIT;
+
 	caps = kzalloc(sizeof(*caps) +
 		       sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid_config,
 		       GFP_KERNEL);
@@ -2297,7 +2304,7 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 		goto out;
 	}
 
-	ret = init_kvm_tdx_caps(td_conf, caps);
+	ret = init_kvm_tdx_caps(kvm, td_conf, caps);
 	if (ret)
 		goto out;
 
@@ -2356,9 +2363,19 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
 	return 0;
 }
 
-static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+static void tdx_update_mwait_in_guest(struct kvm *kvm, struct kvm_cpuid2 *cpuid)
+{
+	const struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 1, 0);
+
+	kvm->arch.mwait_in_guest = entry && has_mwait(entry);
+}
+
+static int setup_tdparams_cpuids(struct kvm *kvm, struct kvm_cpuid2 *cpuid,
 				 struct td_params *td_params)
 {
+	bool disallow_mwait = kvm->arch.unsupported_disable_exits & KVM_X86_DISABLE_EXITS_MWAIT;
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
 	const struct kvm_cpuid_entry2 *entry;
 	struct tdx_cpuid_value *value;
@@ -2372,14 +2389,14 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 	for (i = 0; i < td_conf->num_cpuid_config; i++) {
 		struct kvm_cpuid_entry2 tmp;
 
-		td_init_cpuid_entry2(&tmp, i);
+		td_init_cpuid_entry2(&tmp, i, disallow_mwait);
 
 		entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
 					      tmp.function, tmp.index);
 		if (!entry)
 			continue;
 
-		if (tdx_unsupported_cpuid(entry))
+		if (tdx_unsupported_cpuid(entry, disallow_mwait))
 			return -EINVAL;
 
 		copy_cnt++;
@@ -2437,10 +2454,12 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	if (ret)
 		return ret;
 
-	ret = setup_tdparams_cpuids(cpuid, td_params);
+	ret = setup_tdparams_cpuids(kvm, cpuid, td_params);
 	if (ret)
 		return ret;
 
+	tdx_update_mwait_in_guest(kvm, cpuid);
+
 #define MEMCPY_SAME_SIZE(dst, src)				\
 	do {							\
 		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
@@ -2745,6 +2764,8 @@ static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
 	return -EIO;
 }
 
+#define KVM_TDX_INIT_VM_FLAGS KVM_TDX_FLAGS_ALLOW_MWAIT
+
 static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -2758,9 +2779,12 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	if (kvm_tdx->state != TD_STATE_UNINITIALIZED)
 		return -EINVAL;
 
-	if (cmd->flags)
+	if (cmd->flags & ~KVM_TDX_INIT_VM_FLAGS)
 		return -EINVAL;
 
+	if (cmd->flags & KVM_TDX_FLAGS_ALLOW_MWAIT)
+		kvm->arch.unsupported_disable_exits &= ~KVM_X86_DISABLE_EXITS_MWAIT;
+
 	init_vm = kmalloc(sizeof(*init_vm) +
 			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
 			  GFP_KERNEL);
@@ -2925,7 +2949,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 
 	switch (tdx_cmd.id) {
 	case KVM_TDX_CAPABILITIES:
-		r = tdx_get_capabilities(&tdx_cmd);
+		r = tdx_get_capabilities(kvm, &tdx_cmd);
 		break;
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
-- 
2.48.1


