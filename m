Return-Path: <kvm+bounces-16791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFAB8BDB3D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 801041F21F83
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDA96F09C;
	Tue,  7 May 2024 06:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jh+gmYi2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5E6EB5C;
	Tue,  7 May 2024 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062756; cv=none; b=Wzp266MlqYE8rpH1i0sSblHNOmiw6PDulBB+v1rIYIP7i19TyRLoAzgSSzyQgIHZqOIxZ/RIz6SJ12S2XNDy4/A17ELZi3aTVI2DM6OlCU8A/vPlaU1epcibRnA0txEcCnr9G8Iro+KH6yXROL1Iqpv2kMnItDSsFSWG7cZo48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062756; c=relaxed/simple;
	bh=iaZ2BMDeNoeIPBrEjGkR8jv5Pwu9igYECttuPc3fJY0=;
	h=From:To:Cc:Subject:Date:Message-Id; b=d3C8V1s02sYLWIOoVz1RbgyEqHv2MztIkklY2KvWs9e3VBh/wpi36GfHFTdclbtI9miCfhtXBM4p/NN+VrgeIo5QAhYc684xXO2WsqCS9iYM02dgiGOCEDE1BXI9cwfE1oUNM7P9g36S52GRPtUkX9QYepOY0xYMw03wQu1lpxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jh+gmYi2; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715062754; x=1746598754;
  h=from:to:cc:subject:date:message-id;
  bh=iaZ2BMDeNoeIPBrEjGkR8jv5Pwu9igYECttuPc3fJY0=;
  b=Jh+gmYi2oiBhFGwP8lnfCPCe5+T3LoYqmUou9qdLFy6PchgwcY/TahzE
   gPRfet3duTJ/FSwT+5z9EIBZ0UkUXaVW6bU4IL4XMk8+QtulzNxhYxWwL
   YUdQvF+EQTE/VWqrfxoB6V4DnSRQ5MXBiGw2/LTENRUL/iamVl27RfOpT
   1rCWzJE6AoL/QXtpq5xH0625OjM1ckhEwVOGcuWew464Tb2qFAaEp0fAu
   Po9QiGyHyqKbsJiaRjqMY+zZ8f4chdMFopMun+SBLc2O2Exe4mOH0Napi
   G9Z614x4FCAyN/X6NeeGiVU0uADNPhIze4ikJMYUc1XJGJDlv/IwNp/45
   w==;
X-CSE-ConnectionGUID: imv3xiiWT4S1M9fO2oCBrg==
X-CSE-MsgGUID: nvg9xBbvSGGZfzcFvm7EVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10959867"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10959867"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:19:07 -0700
X-CSE-ConnectionGUID: K3mnPjYqRI2ryvq1sHWuxQ==
X-CSE-MsgGUID: q4DDVl/dRzapz5IkroCiBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28804352"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:19:02 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: iommu@lists.linux.dev,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	corbet@lwn.net,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	baolu.lu@linux.intel.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/5] Enforce CPU cache flush for non-coherent device assignment
Date: Tue,  7 May 2024 14:18:02 +0800
Message-Id: <20240507061802.20184-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This is a follow-up series to fix the security risk for non-coherent device
assignment raised by Jason in [1].

When IOMMU does not enforce cache coherency, devices are allowed to perform
non-coherent DMAs (DMAs that lack CPU cache snooping). This scenario poses
a risk of information leakage when the device is assigned into a VM.
Specifically, a malicious guest could potentially retrieve stale host data
through non-coherent DMA reads of physical memory, while data initialized
by host (e.g., zeros) still resides in the cache.

Furthermore, host kernel (e.g. a ksm thread) might encounter inconsistent
data between the CPU cache and physical memory (left by a malicious guest)
after a page is unpinned for DMA but before the page is recycled.

Therefore, a mitigation in VFIO/IOMMUFD is required to flush CPU caches on
pages involved in non-coherent DMAs prior to or following their mapping or
unmapping to or from the IOMMU.

The mitigation is not implemented in DMA API layer, so as to avoid slowing
down the DMA API users. Users of the DMA API are expected to take care of
CPU cache flushing in one of two ways: (a) by using the DMA API which is
aware of the non-coherence and does the flushes internally or (b) be aware
of its flushing needs and handle them on its own if they are overriding the
platform using no-snoop. A general mitigation in DMA API layer will only
come when non-coherent DMAs are common, which, however, is not the case
(now only Intel GPU and some ARM devices).

Also the mitigation is not implemented in IOMMU core for VMs exclusively,
because it would make a large IOTLB flush range being split due to the
absence of information regarding to IOVA-PFN relationship in IOMMU core.

Given non-coherent devices exist both on x86 and ARM, this series
introduces an arch helper to flush CPU caches for non-coherent DMAs which
is available for both VFIO and IOMMUFD, though current only implementation
for x86 is provided.


Series Layout:

Patch 1 first fixes an error in pat_pfn_immune_to_uc_mtrr() which always
        returns WB for untracked PAT ranges. This error leads to KVM
        treating all PFNs within these untracked PAT ranges as cacheable
        memory types, even when a PFN's MTRR type is UC. (An example is for
        VGA range from 0xa0000-0xbffff).
        Patch 3 will use pat_pfn_immune_to_uc_mtrr() to determine
        uncacheable PFNs.

Patch 2 is a side fix in KVM to prevent guest cacheable access to PFNs
        mapped as UC in host.

Patch 3 introduces and exports an arch helper arch_clean_nonsnoop_dma() to
        flush CPU cachelines. It takes physical address and size as inputs
        and provides a implementation for x86.
        Given that executing CLFLUSH on certain MMIO ranges on x86 can be
        problematic, potentially causing machine check exceptions on some
        platforms, while flushing is necessary on some other MMIO ranges
        (e.g., some MMIO ranges for PMEM), this patch determines
        cacheability by consulting the PAT (if enabled) or MTRR type (if
        PAT is disabled). It assesses whether a PFN is considered as
        uncacheable by the host. For reserved pages or !pfn_valid() PFN,
        CLFLUSH is avoided if the PFN is recognized as uncacheable on the
        host.

Patch 4/5 implement a mitigation in vfio/iommufd to flush CPU caches
         - before a page is accessible to non-coherent DMAs,
         - after the page is inaccessible to non-coherent DMAs, and right
           before it's unpinned for DMAs.


Performance data:

The overhead of flushing CPU caches is measured below:
CPU MHz:4494.377, 4 vCPU, 8G guest memory
Pass-through GPU: 1G aperture

Across each VM boot up and tear down,

IOMMUFD     |     Map        |   Unmap        | Teardown 
------------|----------------|----------------|-------------
w/o clflush | 1167M          |   40M          |  201M
w/  clflush | 2400M (+1233M) |  276M (+236M)  | 1160M (+959M)

Map = total cycles of iommufd_ioas_map() during VM boot up
Unmap = total cycles of iommufd_ioas_unmap() during VM boot up
Teardown = total cycles of iommufd_hwpt_paging_destroy() at VM teardown

VFIO        |     Map        |   Unmap        | Teardown 
------------|----------------|----------------|-------------
w/o clflush | 3058M          |  379M          |  448M
w/  clflush | 5664M (+2606M) | 1653M (+1274M) | 1522M (+1074M)

Map = total cycles of vfio_dma_do_map() during VM boot up
Unmap = total cycles of vfio_dma_do_unmap() during VM boot up
Teardown = total cycles of vfio_iommu_type1_detach_group() at VM teardown

[1] https://lore.kernel.org/lkml/20240109002220.GA439767@nvidia.com

Yan Zhao (5):
  x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR for untracked PAT
    range
  KVM: x86/mmu: Fine-grained check of whether a invalid & RAM PFN is
    MMIO
  x86/mm: Introduce and export interface arch_clean_nonsnoop_dma()
  vfio/type1: Flush CPU caches on DMA pages in non-coherent domains
  iommufd: Flush CPU caches on DMA pages in non-coherent domains

 arch/x86/include/asm/cacheflush.h       |  3 +
 arch/x86/kvm/mmu/spte.c                 | 14 +++-
 arch/x86/mm/pat/memtype.c               | 12 +++-
 arch/x86/mm/pat/set_memory.c            | 88 +++++++++++++++++++++++++
 drivers/iommu/iommufd/hw_pagetable.c    | 19 +++++-
 drivers/iommu/iommufd/io_pagetable.h    |  5 ++
 drivers/iommu/iommufd/iommufd_private.h |  1 +
 drivers/iommu/iommufd/pages.c           | 44 ++++++++++++-
 drivers/vfio/vfio_iommu_type1.c         | 51 ++++++++++++++
 include/linux/cacheflush.h              |  6 ++
 10 files changed, 237 insertions(+), 6 deletions(-)


base-commit: e67572cd2204894179d89bd7b984072f19313b03
-- 
2.17.1


