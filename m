Return-Path: <kvm+bounces-6690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD81837881
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:21:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F16B1F21C93
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B87385C45;
	Mon, 22 Jan 2024 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RUO+kyQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E382D75;
	Mon, 22 Jan 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967781; cv=none; b=cYUy8Mgk49wuh4OeL0nkRl4MjGcZeWzRm710OzGdC66e0xr/73DaMLUASUomVv0ik39EExS5Bk8veNXm5U842p2bN+jqo3FfR1mRIh6ZLEWuXmhIGSks14zm7XkznnktX90TGn4euQF9x9ekPnzo21irdqHyl6I8Q1uGRHtA+24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967781; c=relaxed/simple;
	bh=Q13V8DvtQHrsTZUe8rmuYSGyBiWbNlbB+9x4lzzA/X0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SC69cpBmw1hi/CtNUdYyBK5dLKbnqyEVoeF+w8wtPGqPtl2RcblJGymHzcaUgRyivKRtlEqewyJagkipsjxJVrbM64YFIFXfxB2ZXGrqvBtBApNGkb52AkbpNRF+IwG5c7lBZZPWxpQFRsdg7x3/iNCAicqqWiwzSNvuF7TAOLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RUO+kyQ2; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967779; x=1737503779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q13V8DvtQHrsTZUe8rmuYSGyBiWbNlbB+9x4lzzA/X0=;
  b=RUO+kyQ2tV/yJWSR+nhNzp3hw49kNoYHn3B2fQK7ElpDeIBLG/haT+cc
   vta+ut/zC3kj39hPsIAZkwFMFeqhElpqvemTCkdWuWeCm8STePt/km9xI
   wWfIBUmxb9C3NRTpwrooFacc9GoxvZt3wEU6xJq8wZ4KFRC9pVrdLxqxL
   PSCC1STBGFuSoPbwWUreFTsGdJ0kPuOHzZZQNSpVyE51TP6Rrg6OEbRjj
   wKZ0NzZAL0d9InIUK5PzV+irqG2+uYzqO575/0zNVlPX5VBbdZln7TDYp
   2HYK1voFr7+PGZ+Y8Xp9WzG40sgFmAYzm0aMriGHG4uGXkroIspwqkip2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217949"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217949"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818038"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:58 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 116/121] Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
Date: Mon, 22 Jan 2024 15:54:32 -0800
Message-Id: <2f32572b915922602b52c874d0ad9c5aba7a2c16.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add documentation to Intel Trusted Domain Extensions(TDX) support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/api.rst           |   9 +-
 Documentation/virt/kvm/x86/index.rst     |   1 +
 Documentation/virt/kvm/x86/intel-tdx.rst | 362 +++++++++++++++++++++++
 3 files changed, 371 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..2dafa5296978 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1394,6 +1394,9 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
+For TDX guest, deleting/moving memory region loses guest memory contents.
+Read only region isn't supported.  Only as-id 0 is supported.
+
 Note: On arm64, a write generated by the page-table walker (to update
 the Access and Dirty flags, for example) never results in a
 KVM_EXIT_MMIO exit when the slot has the KVM_MEM_READONLY flag. This
@@ -4734,7 +4737,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
 
 :Capability: basic
 :Architectures: x86
-:Type: vm
+:Type: vm ioctl, vcpu ioctl
 :Parameters: an opaque platform specific structure (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4746,6 +4749,10 @@ Currently, this ioctl is used for issuing Secure Encrypted Virtualization
 (SEV) commands on AMD Processors. The SEV commands are defined in
 Documentation/virt/kvm/x86/amd-memory-encryption.rst.
 
+Currently, this ioctl is used for issuing Trusted Domain Extensions
+(TDX) commands on Intel Processors. The TDX commands are defined in
+Documentation/virt/kvm/x86/intel-tdx.rst.
+
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
index 000000000000..a1b10e99c1ff
--- /dev/null
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -0,0 +1,362 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Intel Trust Domain Extensions (TDX)
+===================================
+
+Overview
+========
+TDX stands for Trust Domain Extensions which isolates VMs from
+the virtual-machine manager (VMM)/hypervisor and any other software on
+the platform. For details, see the specifications [1]_, whitepaper [2]_,
+architectural extensions specification [3]_, module documentation [4]_,
+loader interface specification [5]_, guest-hypervisor communication
+interface [6]_, virtual firmware design guide [7]_, and other resources
+([8]_, [9]_, [10]_, [11]_, and [12]_).
+
+
+API description
+===============
+
+KVM_MEMORY_ENCRYPT_OP
+---------------------
+:Type: vm ioctl, vcpu ioctl
+
+For TDX operations, KVM_MEMORY_ENCRYPT_OP is re-purposed to be generic
+ioctl with TDX specific sub ioctl command.
+
+::
+
+  /* Trust Domain eXtension sub-ioctl() commands. */
+  enum kvm_tdx_cmd_id {
+          KVM_TDX_CAPABILITIES = 0,
+          KVM_TDX_INIT_VM,
+          KVM_TDX_INIT_VCPU,
+          KVM_TDX_INIT_MEM_REGION,
+          KVM_TDX_FINALIZE_VM,
+
+          KVM_TDX_CMD_NR_MAX,
+  };
+
+  struct kvm_tdx_cmd {
+        /* enum kvm_tdx_cmd_id */
+        __u32 id;
+        /* flags for sub-commend. If sub-command doesn't use this, set zero. */
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
+         * Defined for consistency with struct kvm_sev_cmd.
+         */
+        __u64 error;
+        /* Reserved: Defined for consistency with struct kvm_sev_cmd. */
+        __u64 unused;
+  };
+
+KVM_TDX_CAPABILITIES
+--------------------
+:Type: vm ioctl
+
+Subset of TDSYSINFO_STRCUCT retrieved by TDH.SYS.INFO TDX SEAM call will be
+returned. Which describes about Intel TDX module.
+
+- id: KVM_TDX_CAPABILITIES
+- flags: must be 0
+- data: pointer to struct kvm_tdx_capabilities
+- error: must be 0
+- unused: must be 0
+
+::
+
+  struct kvm_tdx_cpuid_config {
+          __u32 leaf;
+          __u32 sub_leaf;
+          __u32 eax;
+          __u32 ebx;
+          __u32 ecx;
+          __u32 edx;
+  };
+
+  struct kvm_tdx_capabilities {
+        __u64 attrs_fixed0;
+        __u64 attrs_fixed1;
+        __u64 xfam_fixed0;
+        __u64 xfam_fixed1;
+  #define TDX_CAP_GPAW_48 (1 << 0)
+  #define TDX_CAP_GPAW_52 (1 << 1)
+        __u32 supported_gpaw;
+        __u32 padding;
+        __u64 reserved[251];
+
+        __u32 nr_cpuid_configs;
+        struct kvm_tdx_cpuid_config cpuid_configs[];
+  };
+
+
+KVM_TDX_INIT_VM
+---------------
+:Type: vm ioctl
+
+Does additional VM initialization specific to TDX which corresponds to
+TDH.MNG.INIT TDX SEAM call.
+
+- id: KVM_TDX_INIT_VM
+- flags: must be 0
+- data: pointer to struct kvm_tdx_init_vm
+- error: must be 0
+- unused: must be 0
+
+::
+
+  struct kvm_tdx_init_vm {
+          __u64 attributes;
+          __u64 mrconfigid[6];          /* sha384 digest */
+          __u64 mrowner[6];             /* sha384 digest */
+          __u64 mrownerconfig[6];       /* sha348 digest */
+          __u64 reserved[1004];         /* must be zero for future extensibility */
+
+          struct kvm_cpuid2 cpuid;
+  };
+
+
+KVM_TDX_INIT_VCPU
+-----------------
+:Type: vcpu ioctl
+
+Does additional VCPU initialization specific to TDX which corresponds to
+TDH.VP.INIT TDX SEAM call.
+
+- id: KVM_TDX_INIT_VCPU
+- flags: must be 0
+- data: initial value of the guest TD VCPU RCX
+- error: must be 0
+- unused: must be 0
+
+KVM_TDX_INIT_MEM_REGION
+-----------------------
+:Type: vm ioctl
+
+Encrypt a memory continuous region which corresponding to TDH.MEM.PAGE.ADD
+TDX SEAM call.
+If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends measurement
+which corresponds to TDH.MR.EXTEND TDX SEAM call.
+
+- id: KVM_TDX_INIT_VCPU
+- flags: flags
+            currently only KVM_TDX_MEASURE_MEMORY_REGION is defined
+- data: pointer to struct kvm_tdx_init_mem_region
+- error: must be 0
+- unused: must be 0
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
+
+Complete measurement of the initial TD contents and mark it ready to run
+which corresponds to TDH.MR.FINALIZE
+
+- id: KVM_TDX_FINALIZE_VM
+- flags: must be 0
+- data: must be 0
+- error: must be 0
+- unused: must be 0
+
+KVM TDX creation flow
+=====================
+In addition to KVM normal flow, new TDX ioctls need to be called.  The control flow
+looks like as follows.
+
+#. system wide capability check
+
+   * KVM_CAP_VM_TYPES: check if VM type is supported and if KVM_X86_TDX_VM
+     is supported.
+
+#. creating VM
+
+   * KVM_CREATE_VM
+   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
+   * KVM_ENABLE_CAP_VM(KVM_CAP_MAX_VCPUS): set max_vcpus. KVM_MAX_VCPUS by
+     default.  KVM_MAX_VCPUS is not a part of ABI, but kernel internal constant
+     that is subject to change.  Because max vcpus is a part of attestation, max
+     vcpus should be explicitly set.
+   * KVM_SET_TSC_KHZ for vm. optional
+   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
+
+#. creating VCPU
+
+   * KVM_CREATE_VCPU
+   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
+   * KVM_SET_CPUID2: Enable CPUID[0x1].ECX.X2APIC(bit 21)=1 so that the following
+     setting of MSR_IA32_APIC_BASE success. Without this,
+     KVM_SET_MSRS(MSR_IA32_APIC_BASE) fails.
+   * KVM_SET_MSRS: Set the initial reset value of MSR_IA32_APIC_BASE to
+     APIC_DEFAULT_ADDRESS(0xfee00000) | XAPIC_ENABLE(bit 10) |
+     X2APIC_ENABLE(bit 11) [| MSR_IA32_APICBASE_BSP(bit 8) optional]
+
+#. initializing guest memory
+
+   * allocate guest memory and initialize page same to normal KVM case
+     In TDX case, parse and load TDVF into guest memory in addition.
+   * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
+     If the pages has contents above, those pages need to be added.
+     Otherwise the contents will be lost and guest sees zero pages.
+   * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
+     This must be after KVM_TDX_INIT_MEM_REGION.
+
+#. run vcpu
+
+Design discussion
+=================
+
+Coexistence of normal(VMX) VM and TD VM
+---------------------------------------
+It's required to allow both legacy(normal VMX) VMs and new TD VMs to
+coexist. Otherwise the benefits of VM flexibility would be eliminated.
+The main issue for it is that the logic of kvm_x86_ops callbacks for
+TDX is different from VMX. On the other hand, the variable,
+kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.
+
+Several points to be considered:
+
+  * No or minimal overhead when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
+  * Avoid overhead of indirect call via function pointers.
+  * Contain the changes under arch/x86/kvm/vmx directory and share logic
+    with VMX for maintenance.
+    Even though the ways to operation on VM (VMX instruction vs TDX
+    SEAM call) are different, the basic idea remains the same. So, many
+    logic can be shared.
+  * Future maintenance
+    The huge change of kvm_x86_ops in (near) future isn't expected.
+    a centralized file is acceptable.
+
+- Wrapping kvm x86_ops: The current choice
+
+  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
+  main.c, is just chosen to show main entry points for callbacks.) and
+  wrapper functions around all the callbacks with
+  "if (is-tdx) tdx-callback() else vmx-callback()".
+
+  Pros:
+
+  - No major change in common x86 KVM code. The change is (mostly)
+    contained under arch/x86/kvm/vmx/.
+  - When TDX is disabled(CONFIG_INTEL_TDX_HOST=n), the overhead is
+    optimized out.
+  - Micro optimization by avoiding function pointer.
+
+  Cons:
+
+  - Many boiler plates in arch/x86/kvm/vmx/main.c.
+
+KVM MMU Changes
+---------------
+KVM MMU needs to be enhanced to handle Secure/Shared-EPT. The
+high-level execution flow is mostly same to normal EPT case.
+EPT violation/misconfiguration -> invoke TDP fault handler ->
+resolve TDP fault -> resume execution. (or emulate MMIO)
+The difference is, that S-EPT is operated(read/write) via TDX SEAM
+call which is expensive instead of direct read/write EPT entry.
+One bit of GPA (51 or 47 bit) is repurposed so that it means shared
+with host(if set to 1) or private to TD(if cleared to 0).
+
+- The current implementation
+
+  * Reuse the existing MMU code with minimal update.  Because the
+    execution flow is mostly same. But additional operation, TDX call
+    for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
+  * For performance, minimize TDX SEAM call to operate on S-EPT. When
+    getting corresponding S-EPT pages/entry from faulting GPA, don't
+    use TDX SEAM call to read S-EPT entry. Instead create shadow copy
+    in host memory.
+    Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
+    associate S-EPT to it.
+  * Treats share bit as attributes. mask/unmask the bit where
+    necessary to keep the existing traversing code works.
+    Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
+    for special case.
+
+    * 0 : for non-TDX case
+    * 51 or 47 bit set for TDX case.
+
+  Pros:
+
+  - Large code reuse with minimal new hooks.
+  - Execution path is same.
+
+  Cons:
+
+  - Complicates the existing code.
+  - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.
+
+New KVM API, ioctl (sub)command, to manage TD VMs
+-------------------------------------------------
+Additional KVM APIs are needed to control TD VMs. The operations on TD
+VMs are specific to TDX.
+
+- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
+
+  Although operations for TD VMs aren't necessarily related to memory
+  encryption, define sub operations of KVM_MEMORY_ENCRYPT_OP for TDX specific
+  ioctls.
+
+  Pros:
+
+  - No major change in common x86 KVM code.
+  - Follows the SEV case.
+
+  Cons:
+
+  - The sub operations of KVM_MEMORY_ENCRYPT_OP aren't necessarily memory
+    encryption, but operations on TD VMs.
+
+References
+==========
+
+.. [1] TDX specification
+   https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
+.. [2] Intel Trust Domain Extensions (Intel TDX)
+   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
+.. [3] Intel CPU Architectural Extensions Specification
+   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf
+.. [4] Intel TDX Module 1.0 EAS
+   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf
+.. [5] Intel TDX Loader Interface Specification
+   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-seamldr-interface-specification.pdf
+.. [6] Intel TDX Guest-Hypervisor Communication Interface
+   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
+.. [7] Intel TDX Virtual Firmware Design Guide
+   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.
+.. [8] intel public github
+
+   * kvm TDX branch: https://github.com/intel/tdx/tree/kvm
+   * TDX guest branch: https://github.com/intel/tdx/tree/guest
+
+.. [9] tdvf
+    https://github.com/tianocore/edk2-staging/tree/TDVF
+.. [10] KVM forum 2020: Intel Virtualization Technology Extensions to
+     Enable Hardware Isolated VMs
+     https://osseu2020.sched.com/event/eDzm/intel-virtualization-technology-extensions-to-enable-hardware-isolated-vms-sean-christopherson-intel
+.. [11] Linux Security Summit EU 2020:
+     Architectural Extensions for Hardware Virtual Machine Isolation
+     to Advance Confidential Computing in Public Clouds - Ravi Sahita
+     & Jun Nakajima, Intel Corporation
+     https://osseu2020.sched.com/event/eDOx/architectural-extensions-for-hardware-virtual-machine-isolation-to-advance-confidential-computing-in-public-clouds-ravi-sahita-jun-nakajima-intel-corporation
+.. [12] [RFCv2,00/16] KVM protected memory extension
+     https://lore.kernel.org/all/20201020061859.18385-1-kirill.shutemov@linux.intel.com/
-- 
2.25.1


