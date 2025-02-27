Return-Path: <kvm+bounces-39458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FA7A470F6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB9D3B5CD6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98BF15624B;
	Thu, 27 Feb 2025 01:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6h7vY4J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406421D5AAE;
	Thu, 27 Feb 2025 01:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619197; cv=none; b=thrTj/BLMia9X3ZwQgCujfnz5Ht45302oXxTXPuqATV8YFDpBfj6Xvv/73zItp2K4jKnepucemcg+zzW4k0JFlgCPqn/ibh5iQY/gSrtOpsYM4SvQsSID/yjP0DOB+BCcfYZitOPyxORFuWCYpIQsH1vpZMjHO65+k+pKtXS4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619197; c=relaxed/simple;
	bh=mIjc+dLi3yzXCyrtTzBHorO1x7uI89b87fbmJwN5hf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuW2M+s01c0gXMANMUSOePeXiuk9K/5PPjoCLCn+JYxYMqSB1HmIgaf74z4oZClaeD5tva3eeIqhJUEOrQBU746MOR472yF8Z0hMrSxc3Y4XH7U7BtdTUupASGzBwu0gIBRKXAQwzlmB7gjaRDBoTbMlNeiNDUCFWT9EOH4qb/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6h7vY4J; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619195; x=1772155195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mIjc+dLi3yzXCyrtTzBHorO1x7uI89b87fbmJwN5hf4=;
  b=N6h7vY4JIOSRThjDJj2eULJnweECnZDKhnL+xMjaHOA/cmoFKO4A3qWF
   BYUv6PticyGmf7UrtPL275gN/EfaaNDKPtvlWLTl8tiDbTeUH2c138Bz3
   dAe5U5Nfzr9O6DvZYfIYiXgm11rPZftRfVbJZwD8Vnz9jdCShImqg/CnZ
   wiHa5ODKkpz/k845nrEOdGk5+K39lkKA4CM4O2w1fO0lo8PsRHRPzQpI1
   1l7zhE47eRUmhAtBagLFEJSFtZfwwCXCtJRUrDhfZN9CmHFg0v+oWZl7/
   NDxm+5soivwD1aXNU1qDiF5mgpetZnSL8wNFBZXN0GU0VkRTKO7F+w+Ys
   w==;
X-CSE-ConnectionGUID: Z8beyJ6zTvmH2/Jm7JaKAg==
X-CSE-MsgGUID: sAwaCRRbRGaQ34FQzP7Vmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959712"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959712"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:55 -0800
X-CSE-ConnectionGUID: x2H/xLwYT+qC6U4pKLvfuQ==
X-CSE-MsgGUID: h3A4Th8kSmmqbsLzAVo7tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674951"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:51 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 20/20] Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)
Date: Thu, 27 Feb 2025 09:20:21 +0800
Message-ID: <20250227012021.1778144-21-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add documentation to Intel Trusted Domain Extensions (TDX) support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Update for configurable CPUID comment (Tony)
- Add the documentation for KVM_TDX_GET_CPUID
- Add missing white space. (Kai)
- Consolidate description of KVM_MEMORY_ENCRYPT_OP for SEV and TDX. (Kai)
- Update the "Overview" part. (Kai)
- Sync description of struct kvm_tdx_cmd with source code. (Kai)
- Update description of KVM_TDX_CAPABILITIES. (Xiaoyao)
- Use hw_error instead of error and remove the description of "unused"
  for TDX specific sub ioctl commands. (Kai)
- Add description for return values for TDX specific sub-ioctl() commands.
  (Kai)
- Replace "SEAM call" with "SEAMCALL", and replace "sub ioctl" with
  "sub-ioctl()" for consistency. (Kai)
- Remove the detailed SEAMCALLs when describing TDX specific sub-ioctl()
  commands. (Kai, Xiaoyao)
- Update description for KVM_TDX_INIT_VM, KVM_TDX_INIT_VCPU, and
  KVM_TDX_INIT_MEM_REGION. (Xiaoyao)
- Update "KVM TDX creation flow". (Kai, Xiaoyao)
- Fix typos in enum/struct comments (Xiaoyao)
- Remove design section (Kai)

TDX "the rest" v1:
- Updates to match code changes (Tony)
---
 Documentation/virt/kvm/api.rst           |  13 +-
 Documentation/virt/kvm/x86/index.rst     |   1 +
 Documentation/virt/kvm/x86/intel-tdx.rst | 255 +++++++++++++++++++++++
 3 files changed, 265 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 641d3537a38d..7e155977a8ed 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1407,6 +1407,9 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
+For TDX guest, deleting/moving memory region loses guest memory contents.
+Read only region isn't supported.  Only as-id 0 is supported.
+
 Note: On arm64, a write generated by the page-table walker (to update
 the Access and Dirty flags, for example) never results in a
 KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
@@ -4764,7 +4767,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
 
 :Capability: basic
 :Architectures: x86
-:Type: vm
+:Type: vm ioctl, vcpu ioctl
 :Parameters: an opaque platform specific structure (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4772,9 +4775,11 @@ If the platform supports creating encrypted VMs then this ioctl can be used
 for issuing platform-specific memory encryption commands to manage those
 encrypted VMs.
 
-Currently, this ioctl is used for issuing Secure Encrypted Virtualization
-(SEV) commands on AMD Processors. The SEV commands are defined in
-Documentation/virt/kvm/x86/amd-memory-encryption.rst.
+Currently, this ioctl is used for issuing both Secure Encrypted Virtualization
+(SEV) commands on AMD Processors and Trusted Domain Extensions (TDX) commands
+on Intel Processors.  The detailed commands are defined in
+Documentation/virt/kvm/x86/amd-memory-encryption.rst and
+Documentation/virt/kvm/x86/intel-tdx.rst.
 
 4.111 KVM_MEMORY_ENCRYPT_REG_REGION
 -----------------------------------
diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
index 9ece6b8dc817..851e99174762 100644
--- a/Documentation/virt/kvm/x86/index.rst
+++ b/Documentation/virt/kvm/x86/index.rst
@@ -11,6 +11,7 @@ KVM for x86 systems
    cpuid
    errata
    hypercalls
+   intel-tdx
    mmu
    msr
    nested-vmx
diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
new file mode 100644
index 000000000000..de41d4c01e5c
--- /dev/null
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -0,0 +1,255 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Intel Trust Domain Extensions (TDX)
+===================================
+
+Overview
+========
+Intel's Trust Domain Extensions (TDX) protect confidential guest VMs from the
+host and physical attacks.  A CPU-attested software module called 'the TDX
+module' runs inside a new CPU isolated range to provide the functionalities to
+manage and run protected VMs, a.k.a, TDX guests or TDs.
+
+Please refer to [1] for the whitepaper, specifications and other resources.
+
+This documentation describes TDX-specific KVM ABIs.  The TDX module needs to be
+initialized before it can be used by KVM to run any TDX guests.  The host
+core-kernel provides the support of initializing the TDX module, which is
+described in the Documentation/arch/x86/tdx.rst.
+
+API description
+===============
+
+KVM_MEMORY_ENCRYPT_OP
+---------------------
+:Type: vm ioctl, vcpu ioctl
+
+For TDX operations, KVM_MEMORY_ENCRYPT_OP is re-purposed to be generic
+ioctl with TDX specific sub-ioctl() commands.
+
+::
+
+  /* Trust Domain Extensions sub-ioctl() commands. */
+  enum kvm_tdx_cmd_id {
+          KVM_TDX_CAPABILITIES = 0,
+          KVM_TDX_INIT_VM,
+          KVM_TDX_INIT_VCPU,
+          KVM_TDX_INIT_MEM_REGION,
+          KVM_TDX_FINALIZE_VM,
+          KVM_TDX_GET_CPUID,
+
+          KVM_TDX_CMD_NR_MAX,
+  };
+
+  struct kvm_tdx_cmd {
+        /* enum kvm_tdx_cmd_id */
+        __u32 id;
+        /* flags for sub-command. If sub-command doesn't use this, set zero. */
+        __u32 flags;
+        /*
+         * data for each sub-command. An immediate or a pointer to the actual
+         * data in process virtual address.  If sub-command doesn't use it,
+         * set zero.
+         */
+        __u64 data;
+        /*
+         * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+         * status code in addition to -Exxx.
+         */
+        __u64 hw_error;
+  };
+
+KVM_TDX_CAPABILITIES
+--------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Return the TDX capabilities that current KVM supports with the specific TDX
+module loaded in the system.  It reports what features/capabilities are allowed
+to be configured to the TDX guest.
+
+- id: KVM_TDX_CAPABILITIES
+- flags: must be 0
+- data: pointer to struct kvm_tdx_capabilities
+- hw_error: must be 0
+
+::
+
+  struct kvm_tdx_capabilities {
+        __u64 supported_attrs;
+        __u64 supported_xfam;
+        __u64 reserved[254];
+
+        /* Configurable CPUID bits for userspace */
+        struct kvm_cpuid2 cpuid;
+  };
+
+
+KVM_TDX_INIT_VM
+---------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Perform TDX specific VM initialization.  This needs to be called after
+KVM_CREATE_VM and before creating any VCPUs.
+
+- id: KVM_TDX_INIT_VM
+- flags: must be 0
+- data: pointer to struct kvm_tdx_init_vm
+- hw_error: must be 0
+
+::
+
+  struct kvm_tdx_init_vm {
+          __u64 attributes;
+          __u64 xfam;
+          __u64 mrconfigid[6];          /* sha384 digest */
+          __u64 mrowner[6];             /* sha384 digest */
+          __u64 mrownerconfig[6];       /* sha384 digest */
+
+          /* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+          __u64 reserved[12];
+
+        /*
+         * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+         * KVM_SET_CPUID2.
+         * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+         * TDX module directly virtualizes those CPUIDs without VMM.  The user
+         * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+         * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+         * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+         * module doesn't virtualize.
+         */
+          struct kvm_cpuid2 cpuid;
+  };
+
+
+KVM_TDX_INIT_VCPU
+-----------------
+:Type: vcpu ioctl
+:Returns: 0 on success, <0 on error
+
+Perform TDX specific VCPU initialization.
+
+- id: KVM_TDX_INIT_VCPU
+- flags: must be 0
+- data: initial value of the guest TD VCPU RCX
+- hw_error: must be 0
+
+KVM_TDX_INIT_MEM_REGION
+-----------------------
+:Type: vcpu ioctl
+:Returns: 0 on success, <0 on error
+
+Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
+provided data from @source_addr.
+
+Note, before calling this sub command, memory attribute of the range
+[gpa, gpa + nr_pages] needs to be private.  Userspace can use
+KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
+
+If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends measurement.
+
+- id: KVM_TDX_INIT_MEM_REGION
+- flags: currently only KVM_TDX_MEASURE_MEMORY_REGION is defined
+- data: pointer to struct kvm_tdx_init_mem_region
+- hw_error: must be 0
+
+::
+
+  #define KVM_TDX_MEASURE_MEMORY_REGION   (1UL << 0)
+
+  struct kvm_tdx_init_mem_region {
+          __u64 source_addr;
+          __u64 gpa;
+          __u64 nr_pages;
+  };
+
+
+KVM_TDX_FINALIZE_VM
+-------------------
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Complete measurement of the initial TD contents and mark it ready to run.
+
+- id: KVM_TDX_FINALIZE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
+
+KVM_TDX_GET_CPUID
+-----------------
+:Type: vcpu ioctl
+:Returns: 0 on success, <0 on error
+
+Get the CPUID values that the TDX module virtualizes for the TD guest.
+When it returns -E2BIG, the user space should allocate a larger buffer and
+retry. The minimum buffer size is updated in the nent field of the
+struct kvm_cpuid2.
+
+- id: KVM_TDX_GET_CPUID
+- flags: must be 0
+- data: pointer to struct kvm_cpuid2 (in/out)
+- hw_error: must be 0 (out)
+
+::
+
+  struct kvm_cpuid2 {
+	  __u32 nent;
+	  __u32 padding;
+	  struct kvm_cpuid_entry2 entries[0];
+  };
+
+  struct kvm_cpuid_entry2 {
+	  __u32 function;
+	  __u32 index;
+	  __u32 flags;
+	  __u32 eax;
+	  __u32 ebx;
+	  __u32 ecx;
+	  __u32 edx;
+	  __u32 padding[3];
+  };
+
+KVM TDX creation flow
+=====================
+In addition to the standard KVM flow, new TDX ioctls need to be called.  The
+control flow is as follows:
+
+#. Check system wide capability
+
+   * KVM_CAP_VM_TYPES: Check if VM type is supported and if KVM_X86_TDX_VM
+     is supported.
+
+#. Create VM
+
+   * KVM_CREATE_VM
+   * KVM_TDX_CAPABILITIES: Query TDX capabilities for creating TDX guests.
+   * KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPUS): Query maximum VCPUs the TD can
+     support at VM level (TDX has its own limitation on this).
+   * KVM_SET_TSC_KHZ: Configure TD's TSC frequency if a different TSC frequency
+     than host is desired.  This is Optional.
+   * KVM_TDX_INIT_VM: Pass TDX specific VM parameters.
+
+#. Create VCPU
+
+   * KVM_CREATE_VCPU
+   * KVM_TDX_INIT_VCPU: Pass TDX specific VCPU parameters.
+   * KVM_SET_CPUID2: Configure TD's CPUIDs.
+   * KVM_SET_MSRS: Configure TD's MSRs.
+
+#. Initialize initial guest memory
+
+   * Prepare content of initial guest memory.
+   * KVM_TDX_INIT_MEM_REGION: Add initial guest memory.
+   * KVM_TDX_FINALIZE_VM: Finalize the measurement of the TDX guest.
+
+#. Run VCPU
+
+References
+==========
+
+.. [1] https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/documentation.html
-- 
2.46.0


