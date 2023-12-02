Return-Path: <kvm+bounces-3216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81882801BB9
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:41:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37546281CF2
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57105125BC;
	Sat,  2 Dec 2023 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJ1NJaK3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6918910EA;
	Sat,  2 Dec 2023 01:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510077; x=1733046077;
  h=from:to:cc:subject:date:message-id;
  bh=KBVzLl+kMzCo3U3ohPB86E30usQbXq+GfH8nLunIBzA=;
  b=RJ1NJaK3/zvMkSpBU4DVVkJ2z7l2f+378ypkPzm6Czc910FRmwf7Y/+2
   HP3tSj9pKecBNljF6SdkiFyzAUl4yUUjlpC0tIxe5Lp2tBB8Ogk7YRG1K
   hgaYkPWl2w5kVX++3IyHcSmsdnJR4FQ5IbF/3vQ1UvIq7Fsxn9PQ51xfi
   hvle5kaR8B953DGbnDE8NmsTr+3Yr6sunWPIw9pnkFpLKJ+w6H2AxU+Bx
   d5H48bTJaxE3NukXSxkaGiRi4TAIO9IbITlR+phqktX+ecHT98XrQXxjB
   aKbc8r/aAybvHfgHoeuRDNZC6R6UDmQTXRR+mOvRpKmKYKlqb3+NGiWns
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="488057"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="488057"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:41:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="17275196"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:41:13 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Date: Sat,  2 Dec 2023 17:12:11 +0800
Message-Id: <20231202091211.13376-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This RFC series proposes a framework to resolve IOPF by sharing KVM TDP
(Two Dimensional Paging) page table to IOMMU as its stage 2 paging
structure to support IOPF (IO page fault) on IOMMU's stage 2 paging
structure.

Previously, all guest pages have to be pinned and mapped in IOMMU stage 2 
paging structures after pass-through devices attached, even if the device
has IOPF capability. Such all-guest-memory pinning can be avoided when IOPF
handling for stage 2 paging structure is supported and if there are only
IOPF-capable devices attached to a VM.

There are 2 approaches to support IOPF on IOMMU stage 2 paging structures:
- Supporting by IOMMUFD/IOMMU alone
  IOMMUFD handles IO page faults on stage-2 HWPT by calling GUPs and then
  iommu_map() to setup IOVA mappings. (IOAS is required to keep info of GPA
  to HVA, but page pinning/unpinning needs to be skipped.)
  Then upon MMU notifiers on host primary MMU, iommu_unmap() is called to
  adjust IOVA mappings accordingly.
  IOMMU driver needs to support unmapping sub-ranges of a previous mapped
  range and take care of huge page merge and split in atomic way. [1][2].

- Sharing KVM TDP
  IOMMUFD sets the root of KVM TDP page table (EPT/NPT in x86) as the root
  of IOMMU stage 2 paging structure, and routes IO page faults to KVM.
  (This assumes that the iommu hw supports the same stage-2 page table
  format as CPU.)
  In this model the page table is centrally managed by KVM (mmu notifier,
  page mapping, subpage unmapping, atomic huge page split/merge, etc.),
  while IOMMUFD only needs to invalidate iotlb/devtlb properly.

Currently, there's no upstream code available to support stage 2 IOPF yet.

This RFC chooses to implement "Sharing KVM TDP" approach which has below
main benefits: 

- Unified page table management
  The complexity of allocating guest pages per GPAs, registering to MMU
  notifier on host primary MMU, sub-page unmapping, atomic page merge/split
  are only required to by handled in KVM side, which has been doing that
  well for a long time.

- Reduced page faults:
  Only one page fault is triggered on a single GPA, either caused by IO
  access or by vCPU access. (compared to one IO page fault for DMA and one
  CPU page fault for vCPUs in the non-shared approach.)

- Reduced memory consumption:
  Memory of one page table are saved.


Design
==
In this series, term "exported" is used in place of "shared" to avoid
confusion with terminology "shared EPT" in TDX.

The framework contains 3 main objects:

"KVM TDP FD" object - The interface of KVM to export TDP page tables.
                      With this object, KVM allows external components to
                      access a TDP page table exported by KVM.

"IOMMUFD KVM HWPT" object - A proxy connecting KVM TDP FD to IOMMU driver.
                            This HWPT has no IOAS associated.

"KVM domain" in IOMMU driver - Stage 2 domain in IOMMU driver whose paging
                               structures are managed by KVM.
                               Its hardware TLB invalidation requests are
                               notified from KVM via IOMMUFD KVM HWPT
                               object.


                                               
                2.IOMMU_HWPT_ALLOC(fd)            1. KVM_CREATE_TDP_FD
                                       .------.
                        +--------------| QEMU |----------------------+
                        |              '------'<---+ fd              |
                        |                          |                 v
                        |                          |             .-------.
                        v                          |      create |  KVM  |
             .------------------.           .------------.<------'-------'
             | IOMMUFD KVM HWPT |           | KVM TDP FD |           |
             '------------------'           '------------'           |
                        |    kvm_tdp_fd_get(fd)    |                 |
                        |------------------------->|                 |
  IOMMU                 |                          |                 |
  driver    alloc(meta) |---------get meta-------->|                 |
.------------.<---------|                          |                 |
| KVM Domain |          |----register_importer---->|                 |
'------------'          |                          |                 |
  |                     |                          |                 |
  |   3.                |                          |                 |
  |----iopf handler---->|----------fault---------->|------map------->|
  |                     |                          |  4.             |
  |<-------invalidate---|<-------invalidate--------|<---TLB flush----|
  |                     |                          |                 |
  |<-----free-----------| 5.                       |                 |
                        |----unregister_importer-->|                 |
                        |                          |                 |
                        |------------------------->|                 |
                             kvm_tdp_fd_put()


1. QEMU calls KVM_CREATE_TDP_FD to create a TDP FD object.
   Address space must be specified to identify the exported TDP page table
   (e.g. system memory or SMM mode system memory in x86).

2. QEMU calls IOMMU_HWPT_ALLOC to create a KVM-type HWPT.
   The KVM-type HWPT is created upon an exported KVM TDP FD (rather than
   upon an IOAS), acting as the proxy between KVM TDP and IOMMU driver:
   - Obtain reference on the exported KVM TDP FD.
   - get and pass meta data of KVM TDP page tables to IOMMU driver for KVM
     domain allocation.
   - register importer callbacks to KVM for invalidation notification.
   - register a IOPF handler into IOMMU's KVM domain.

   Upon device attachment, the root HPA of the exported TDP page table is
   installed to IOMMU hardware.

3. When IO page faults come, IOMMUFD fault handler forwards the fault to
   KVM.

4. When KVM performs TLB flush, it notifies all importers of KVM TDP FD
   object. IOMMUFD KVM HWPT, as an importer, will pass the notification to
   IOMMU driver for hardware TLB invalidations.

5. On destroy IOMMUFD KVM HWPT, it frees IOMMU's KVM domain, unregisters
   itself as an importer from KVM TDP FD object and puts reference count of
   KVM TDP FD object.


Status
==
Current support of IOPF on IOMMU stage 2 paging structure is verified on
Intel DSA devices on Intel SPR platform. There's no vIOMMU for guest and
Intel DSA devices run in-kernel DMA tests successfully with IOPFs handled
in host.

- Nested translation in IOMMU is currently not supported.

- QEMU code in IOMMUFD to create KVM HWPT is just a temporary hack.
  As KVM HWPT has no IOAS associated, need to fit in current QEMU code to
  create KVM HWPT with no IOAS and to ensure the address space is from GPA
  to HPA. 

- DSA IOPF hack in guest driver.
  Although DSA hw tolerates IOPF in all DMA paths, DSA driver has the
  flexibility to turn off IOPF in certain paths. 
  This RFC currently hacks the guest driver to always turn on IOPF.


Note
==
- KVM page write-tracking

  Unlike write-protection which usually adds back the write permission upon
  a write fault and re-executes the faulting instruction, KVM page
  write-tracking keeps the write permission disabled for the tracked pages
  and instead always emulates the faulting instruction upon fault.
  There is no way to emulate a faulting DMA request so IOPF and KVM page
  write-tracking are incompatible.

  In this RFC we didn't handle the conflict given write-tracking is applied
  to guest page table pages so far, which are unlikely to be used as DMA
  buffer.

- IOMMU page-walk coherency

  It's about whether IOMMU hardware will snoop the processor cache of the
  I/O paging structures. If IOMMU page-walk is non-coherent, the software
  needs to do clflush after changing the I/O paging structures.

  Supporting non-coherent IOMMU page-walk adds extra burden (i.e. clflush)
  in KVM mmu in this shared model, which we don't plan to support.
  Fortunately most Intel platforms do support coherent page-walk in IOMMU
  so this exception should not be a big matter.

- Non-coherent DMA

  Non-coherent DMA requires KVM mmu to align the effective memory type
  with the guest memory type (CR0.CD, vPAT, vMTRR) instead of forcing all
  guest memory to be WB. It further involves complexities in fault handler
  to check guest memory type too which requires a vCPU context.

  There is certainly no vCPU context in an I/O page fault. So this RFC
  doesn't support devices which cannot be enforced to do coherent DMA.

  If there is interest in supporting non-coherent DMA in this shared model,
  there's a discussion about removing vMTRR stuffs in KVM page fault
  handler [3] hence it's also possible to further remove the vCPU context
  there.

- Enforce DMA cache coherency

  This design requires the IOMMU supporting a configuration forcing all
  DMAs to be coherent (even if the PCI request out of the device sets the
  non-snoop bit) due to aforementioned reason.

  The control of enforcing cache coherency could be per-IOPT or per-page.
  e.g. Intel VT-d defines a per-page format (bit 11 in PTE represents the
  enforce-snoop bit) in legacy mode and a per-IOPT format (control bit in
  the pasid entry) in scalable mode.

  Supporting per-page format requires KVM mmu to disable any software use
  of bit 11 and also provide additional ops for on-demand set/clear-snp
  requests from iommufd. It's complex and dirty.

  Therefore the per-IOPT scheme is assumed in this design. For Intel IOMMU,
  the scalable mode is the default mode for all new IOMMU features (nested
  translation, pasid, etc.) anyway.


- About device which partially supports IOPF

  Many devices claiming PCIe PRS capability actually only tolerate IOPF in
  certain paths (e.g. DMA paths for SVM applications, but not for non-SVM
  applications or driver data such as ring descriptors). But the PRS
  capability doesn't include a bit to tell whether a device 100% tolerates
  IOPF in all DMA paths.

  This creates a trouble how the userspace driver framework (e.g. VFIO)
  knows that a device with PRS can really avoid static-pinning of the
  entire guest memory and then reports such knowledge to the VMM.

  A simple way is to track an allowed list of devices which are known 100%
  IOPF-friendly in VFIO. Another option is to extend PCIe spec to allow
  device reporting whether it fully or partially supports IOPF in the PRS
  capability.

  Another interesting option is to explore supporting partial-IOPF in this
  sharing model:
  * Create a VFIO variant driver to intercept guest operations which
    registers non-faultable memory to the device and to call KVM TDP ops to
    request on-demand pinning of traped memory pages in KVM mmu. This
    allows the VMM to start with zero-pinning as for 100%-faultable device
    with on demand pinning initiated by the variant driver.

  * Supporting on-demand pinning in KVM mmu however requires non-trivial
    effort. Besides introducing logic to pin pages in long term and manage
    the list of pinned GFNs, more caveats are required to avoid breaking
    the implication of page pinning, e.g.:

      a. PTE updates in a pinned GFN range must be atomic, otherwise an
         in-fly DMA might be broken

      b. PTE zap in a pinned GFN range is allowed only when the related
         memory slot is removed (indicating guest won't use it for DMA).
         The PTE zap for the affected range must be either disabled or
         replaced by an atomic update.

      c. any feature related to write-protecting the pinned GFN range is
         not allowed. This implies live migration is also broken in current
         way as it starts with write-protection even when TDP dirty bit
         tracking is enabled. To support on-demand pinning it then requires
         to rely on a less efficient way by always walking TDP dirty bit
         instead of using write-protection. Or, we may enhance the live
         migration code to treat pinned ranges as dirty always.

      d. Auto NUMA balance also needs to be disabled. [4]

  If above trickiness can be resolved cleanly, this sharing model could
  also support a non-faultable device in theory by pinning/unpinning guest
  memory on slot addition/removal.


- How to map MSI page on arm platform demands discussions.


Patches layout
==
[01-08]: Skeleton implementation of KVM's TDP FD object.
         Patch 1 and 2 are for public and arch specific headers.
         Patch 4's commit message outlines overall data structure hierarchy
                 on x86 for preview. 

[09-23]: IOMMU, IOMMUFD and Intel vt-d.
       - 09-11: IOMMU core part
       - 12-16: IOMMUFD part
                Patch 13 is the main patch in IOMMUFD to implement KVM
                HWPT.
       - 17-23: Intel vt-d part for KVM domain
                Patch 18 is the main patch to implement KVM domain.

[24-42]: KVM x86 and VMX part
       - 24-34: KVM x86 preparation patches. 
                Patch 24: Let KVM to reserve bit 11 since bit 11 is
                          reserved as 0 in IOMMU side.
                Patch 25: Abstract "struct kvm_mmu_common" from
                          "struct kvm_mmu" for "kvm_exported_tdp_mmu"
                Patches 26~34: Prepare for page fault in non-vCPU context.

       - 35-38: Core part in KVM x86
                Patch 35: X86 MMU core part to show how exported TDP root
                          page is shared between KVM external components
                          and vCPUs.
                Patch 37: TDP FD fault op implementation

       - 39-42: KVM VMX part for meta data composing and tlb flush
                notification.


Code base
==
The code base is commit b85ea95d08647 ("Linux 6.7-rc1") +
Yi Liu's v7 series "Add Intel VT-d nested translation (part 2/2)" [5] +
Baolu's v7 series "iommu: Prepare to deliver page faults to user space" [6]

Complete code can be found at [7], Qemu could be found at [8],
Guest test script and workaround patch is at [9].

[1] https://lore.kernel.org/all/20230814121016.32613-1-jijie.ji@linux.alibaba.com/
[2] https://lore.kernel.org/all/BN9PR11MB5276D897431C7E1399EFFF338C14A@BN9PR11MB5276.namprd11.prod.outlook.com/
[3] https://lore.kernel.org/all/ZUAC0jvFE0auohL4@google.com/
[4] https://lore.kernel.org/all/4cb536f6-2609-4e3e-b996-4a613c9844ad@nvidia.com/
[5] https://lore.kernel.org/linux-iommu/20231117131816.24359-1-yi.l.liu@intel.com/
[6] https://lore.kernel.org/linux-iommu/20231115030226.16700-1-baolu.lu@linux.intel.com/
[7] https://github.com/yanhwizhao/linux_kernel/tree/sharept_iopt
[8] https://github.com/yanhwizhao/qemu/tree/sharept_iopf 
[9] https://github.com/yanhwizhao/misc/tree/master


Yan Zhao (42):
  KVM: Public header for KVM to export TDP
  KVM: x86: Arch header for kvm to export TDP for Intel
  KVM: Introduce VM ioctl KVM_CREATE_TDP_FD
  KVM: Skeleton of KVM TDP FD object
  KVM: Embed "arch" object and call arch init/destroy in TDP FD
  KVM: Register/Unregister importers to KVM exported TDP
  KVM: Forward page fault requests to arch specific code for exported
    TDP
  KVM: Add a helper to notify importers that KVM exported TDP is flushed
  iommu: Add IOMMU_DOMAIN_KVM
  iommu: Add new iommu op to create domains managed by KVM
  iommu: Add new domain op cache_invalidate_kvm
  iommufd: Introduce allocation data info and flag for KVM managed HWPT
  iommufd: Add a KVM HW pagetable object
  iommufd: Enable KVM HW page table object to be proxy between KVM and
    IOMMU
  iommufd: Add iopf handler to KVM hw pagetable
  iommufd: Enable device feature IOPF during device attachment to KVM
    HWPT
  iommu/vt-d: Make some macros and helpers to be extern
  iommu/vt-d: Support of IOMMU_DOMAIN_KVM domain in Intel IOMMU
  iommu/vt-d: Set bit PGSNP in PASIDTE if domain cache coherency is
    enforced
  iommu/vt-d: Support attach devices to IOMMU_DOMAIN_KVM domain
  iommu/vt-d: Check reserved bits for IOMMU_DOMAIN_KVM domain
  iommu/vt-d: Support cache invalidate of IOMMU_DOMAIN_KVM domain
  iommu/vt-d: Allow pasid 0 in IOPF
  KVM: x86/mmu: Move bit SPTE_MMU_PRESENT from bit 11 to bit 59
  KVM: x86/mmu: Abstract "struct kvm_mmu_common" from "struct kvm_mmu"
  KVM: x86/mmu: introduce new op get_default_mt_mask to kvm_x86_ops
  KVM: x86/mmu: change param "vcpu" to "kvm" in
    kvm_mmu_hugepage_adjust()
  KVM: x86/mmu: change "vcpu" to "kvm" in page_fault_handle_page_track()
  KVM: x86/mmu: remove param "vcpu" from kvm_mmu_get_tdp_level()
  KVM: x86/mmu: remove param "vcpu" from
    kvm_calc_tdp_mmu_root_page_role()
  KVM: x86/mmu: add extra param "kvm" to kvm_faultin_pfn()
  KVM: x86/mmu: add extra param "kvm" to make_mmio_spte()
  KVM: x86/mmu: add extra param "kvm" to make_spte()
  KVM: x86/mmu: add extra param "kvm" to
    tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Get/Put TDP root page to be exported
  KVM: x86/mmu: Keep exported TDP root valid
  KVM: x86: Implement KVM exported TDP fault handler on x86
  KVM: x86: "compose" and "get" interface for meta data of exported TDP
  KVM: VMX: add config KVM_INTEL_EXPORTED_EPT
  KVM: VMX: Compose VMX specific meta data for KVM exported TDP
  KVM: VMX: Implement ops .flush_remote_tlbs* in VMX when EPT is on
  KVM: VMX: Notify importers of exported TDP to flush TLBs on KVM
    flushes EPT

 arch/x86/include/asm/kvm-x86-ops.h       |   4 +
 arch/x86/include/asm/kvm_exported_tdp.h  |  43 +++
 arch/x86/include/asm/kvm_host.h          |  48 ++-
 arch/x86/kvm/Kconfig                     |  13 +
 arch/x86/kvm/mmu.h                       |  12 +-
 arch/x86/kvm/mmu/mmu.c                   | 434 +++++++++++++++++------
 arch/x86/kvm/mmu/mmu_internal.h          |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h           |  15 +-
 arch/x86/kvm/mmu/spte.c                  |  31 +-
 arch/x86/kvm/mmu/spte.h                  |  82 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c               | 209 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h               |   9 +
 arch/x86/kvm/svm/svm.c                   |   2 +-
 arch/x86/kvm/vmx/nested.c                |   2 +-
 arch/x86/kvm/vmx/vmx.c                   |  56 ++-
 arch/x86/kvm/x86.c                       |  68 +++-
 drivers/iommu/intel/Kconfig              |   9 +
 drivers/iommu/intel/Makefile             |   1 +
 drivers/iommu/intel/iommu.c              |  68 ++--
 drivers/iommu/intel/iommu.h              |  47 +++
 drivers/iommu/intel/kvm.c                | 185 ++++++++++
 drivers/iommu/intel/pasid.c              |   3 +-
 drivers/iommu/intel/svm.c                |  37 +-
 drivers/iommu/iommufd/Kconfig            |  10 +
 drivers/iommu/iommufd/Makefile           |   1 +
 drivers/iommu/iommufd/device.c           |  31 +-
 drivers/iommu/iommufd/hw_pagetable.c     |  29 +-
 drivers/iommu/iommufd/hw_pagetable_kvm.c | 270 ++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h  |  44 +++
 drivers/iommu/iommufd/main.c             |   4 +
 include/linux/iommu.h                    |  18 +
 include/linux/kvm_host.h                 |  58 +++
 include/linux/kvm_tdp_fd.h               | 137 +++++++
 include/linux/kvm_types.h                |  12 +
 include/uapi/linux/iommufd.h             |  15 +
 include/uapi/linux/kvm.h                 |  19 +
 virt/kvm/Kconfig                         |   6 +
 virt/kvm/Makefile.kvm                    |   1 +
 virt/kvm/kvm_main.c                      |  24 ++
 virt/kvm/tdp_fd.c                        | 344 ++++++++++++++++++
 virt/kvm/tdp_fd.h                        |  15 +
 41 files changed, 2177 insertions(+), 247 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm_exported_tdp.h
 create mode 100644 drivers/iommu/intel/kvm.c
 create mode 100644 drivers/iommu/iommufd/hw_pagetable_kvm.c
 create mode 100644 include/linux/kvm_tdp_fd.h
 create mode 100644 virt/kvm/tdp_fd.c
 create mode 100644 virt/kvm/tdp_fd.h

-- 
2.17.1


