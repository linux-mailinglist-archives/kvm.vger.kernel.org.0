Return-Path: <kvm+bounces-33367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 371979EA3E7
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D483188A825
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D284F227599;
	Tue, 10 Dec 2024 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmZmkodz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D1613A41F;
	Tue, 10 Dec 2024 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791737; cv=none; b=gwK8AfaC/A+xtRxjqJXu5lwTe4XAQA1sSqDWOGAKvTgkN1is40EI/EsSV2lnuTn+KrskCRm5PORjQFQlOpudnfdaUYrWHM8EJdPwWxQ6Z1gXsVviL+aoYLMZRXER7Ttj83AzxPeHBbe8KWDLgMscCJ28NgKnWCJ6SvdZaDPfTiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791737; c=relaxed/simple;
	bh=K6Q4ZaIrZrTcNAyuMVrFffvIa5+Juf5fCJtS8BkIwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onAKkbILmTr6QOaw44jg06TPHQfRq1bWCVrU2GQFaCKWHFGMikHfvBf+dao7mJedsfT1UWVM6vfkniBs1Jvnbj3xu4c2JIq7otLPpdhtp2ofw2ybZ5v5kvtOz7V53IOOSybM/OBEuIU3HlkI1kbtGWZB5dccmEDNdGT/oyHsQAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmZmkodz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791735; x=1765327735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6Q4ZaIrZrTcNAyuMVrFffvIa5+Juf5fCJtS8BkIwhg=;
  b=ZmZmkodzUthdoG7izBuWOvM0b8hyoj2NXAMcMckb86vb9/R1ZcC96FZ+
   mY7cWR6BS43PrIepo2PEDY7sga1dzqCOJLpw2Lxtm2TCzpQ4Ed5UiJ2vV
   Vf4SuFyYXC8uV1uSsvUhmOSw/HyOgHb7KvwQnnD3B0eq397RL1JLkImkR
   fZUIcLeprMM0S+jJ4/WgSWAddnULAhw8sx9aV9NIQJ4L9lag0+xqZ5VI9
   d8qVUCES3P6xev/LhpaTjp7T2BuZBQzSCniB3f5XiwC21KHMOOj22/iB6
   ZjW0GSo6WNqQ9apPE6BhzRxgaHzcM0fmBeY65dP644uBcaOSLHFDjawSL
   g==;
X-CSE-ConnectionGUID: u1gSsclcSGm/77xXCZLGGQ==
X-CSE-MsgGUID: LFwnxeZ8TFSaLQ19crp/Sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793799"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793799"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:54 -0800
X-CSE-ConnectionGUID: FIGGAXF/QTmA3ReAjkGiag==
X-CSE-MsgGUID: J74XKwKXQ0K0kbqvaoqNyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033125"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:51 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 18/18] Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
Date: Tue, 10 Dec 2024 08:49:44 +0800
Message-ID: <20241210004946.3718496-19-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
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
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Updates to match code changes (Tony)
---
 Documentation/virt/kvm/api.rst           |   9 +-
 Documentation/virt/kvm/x86/index.rst     |   1 +
 Documentation/virt/kvm/x86/intel-tdx.rst | 357 +++++++++++++++++++++++
 3 files changed, 366 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virt/kvm/x86/intel-tdx.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb39da72c647..c5da37565e1e 100644
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
@@ -4758,7 +4761,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
 
 :Capability: basic
 :Architectures: x86
-:Type: vm
+:Type: vm ioctl, vcpu ioctl
 :Parameters: an opaque platform specific structure (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4770,6 +4773,10 @@ Currently, this ioctl is used for issuing Secure Encrypted Virtualization
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
index 000000000000..12531c4c09e1
--- /dev/null
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -0,0 +1,357 @@
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
+          KVM_TDX_GET_CPUID,
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
+        __u64 hw_error;
+  };
+
+KVM_TDX_CAPABILITIES
+--------------------
+:Type: vm ioctl
+
+Subset of TDSYSINFO_STRUCT retrieved by TDH.SYS.INFO TDX SEAM call will be
+returned. It describes the Intel TDX module.
+
+- id: KVM_TDX_CAPABILITIES
+- flags: must be 0
+- data: pointer to struct kvm_tdx_capabilities
+- error: must be 0
+- unused: must be 0
+
+::
+
+  struct kvm_tdx_capabilities {
+        __u64 supported_attrs;
+        __u64 supported_xfam;
+        __u64 reserved[254];
+        struct kvm_cpuid2 cpuid;
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
+:Type: vcpu ioctl
+
+Encrypt a memory continuous region which corresponding to TDH.MEM.PAGE.ADD
+TDX SEAM call.
+If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends measurement
+which corresponds to TDH.MR.EXTEND TDX SEAM call.
+
+- id: KVM_TDX_INIT_MEM_REGION
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
2.46.0


