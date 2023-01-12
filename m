Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D057D667B43
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbjALQkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbjALQhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6CE0DA;
        Thu, 12 Jan 2023 08:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541231; x=1705077231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FIvQT3V8B6ZW5ReL4ZxXn2G2ldDCp+PjO3KuHXMaQh4=;
  b=md3vA82i3QvnEaE6CbrGkTrR0kjITU3aP/M2cWKCghbc72S8zu5YylHU
   LlKut/5+uksvFhm+YZx6sZ3cmlq6skPizV+a1aZNVKKQpEV1XhND4Qh8O
   +aRfnrklbwoQYd2j547icdNztNdvU2EookDAsoe0bSsCfiF9y1q+Zl+DC
   l3tu0NtwCAZofa+Ua0Bj+RuBu4CvHwvoqPgf4BlaR6tZCICg7CzRBT9PJ
   NrnlnWRe9b3Akx0WA/HhwmPeAKrojQXXZW0VoFjeEmrmpTwEHH9mDEpvt
   Ewf4gFcYTOafJlZsCFUx14WQvpHo+L/CDh74aQHeufobKzzx9qh/tnt0+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089825"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089825"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372634"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372634"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:39 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 111/113] Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)
Date:   Thu, 12 Jan 2023 08:32:59 -0800
Message-Id: <db06a336c157ca8358228034249dc631a7880347.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add documentation to Intel Trusted Domain Extensions(TDX) support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/api.rst       |   9 +-
 Documentation/virt/kvm/index.rst     |   2 +
 Documentation/virt/kvm/intel-tdx.rst | 347 +++++++++++++++++++++++++++
 3 files changed, 357 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virt/kvm/intel-tdx.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d2baa05f7c04..0b5a64f3e335 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1401,6 +1401,9 @@ the memory region are automatically reflected into the guest.  For example, an
 mmap() that affects the region will be made visible immediately.  Another
 example is madvise(MADV_DROP).
 
+For TDX guest, deleting/moving memory region loses guest memory contents.
+Read only region isn't supported.  Only as-id 0 is supported.
+
 
 4.36 KVM_SET_TSS_ADDR
 ---------------------
@@ -4682,7 +4685,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
 
 :Capability: basic
 :Architectures: x86
-:Type: vm
+:Type: vm ioctl, vcpu ioctl
 :Parameters: an opaque platform specific structure (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4694,6 +4697,10 @@ Currently, this ioctl is used for issuing Secure Encrypted Virtualization
 (SEV) commands on AMD Processors. The SEV commands are defined in
 Documentation/virt/kvm/x86/amd-memory-encryption.rst.
 
+Currently, this ioctl is used for issuing Trusted Domain Extensions
+(TDX) commands on Intel Processors. The TDX commands are defined in
+Documentation/virt/kvm/intel-tdx.rst.
+
 4.111 KVM_MEMORY_ENCRYPT_REG_REGION
 -----------------------------------
 
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ad13ec55ddfe..20a2ab8fc78c 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -19,3 +19,5 @@ KVM
    vcpu-requests
    halt-polling
    review-checklist
+
+   intel-tdx
diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
new file mode 100644
index 000000000000..40e92aa2efea
--- /dev/null
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -0,0 +1,347 @@
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
+          __u64 attrs_fixed0;
+          __u64 attrs_fixed1;
+          __u64 xfam_fixed0;
+          __u64 xfam_fixed1;
+
+          __u32 nr_cpuid_configs;
+          struct kvm_tdx_cpuid_config cpuid_configs[0];
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
+          __u32 max_vcpus;
+          __u32 reserved;
+          __u64 attributes;
+          __u64 cpuid;  /* pointer to struct kvm_cpuid2 */
+          __u64 mrconfigid[6];          /* sha384 digest */
+          __u64 mrowner[6];             /* sha384 digest */
+          __u64 mrownerconfig[6];       /* sha348 digest */
+          __u64 reserved[43];           /* must be zero for future extensibility */
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
+   * KVM_CAP_VM_TYPES: check if VM type is supported and if TDX_VM_TYPE is
+     supported.
+
+#. creating VM
+
+   * KVM_CREATE_VM
+   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
+   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
+
+#. creating VCPU
+
+   * KVM_CREATE_VCPU
+   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
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
+     https://lkml.org/lkml/2020/10/20/66
-- 
2.25.1

