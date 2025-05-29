Return-Path: <kvm+bounces-47940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FCCAC7802
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CCD57B3D14
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BBA25D8E8;
	Thu, 29 May 2025 05:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STDobxnL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8499253F1B;
	Thu, 29 May 2025 05:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497357; cv=none; b=tkAM9zxX6iyLDVRbrwRZ7t8n6ae+RssW+CN/S37Ql4oNwtCVj6//1aaTeDEe15XyQA59+JFsTRY95zEnlaYUNa7QwNx7O8yrgtDdmh6CoZMxDQGbexwPVrAfzFZhrtNDi+VTznomZapc/7rU83r8Vdsn70Kh23DfGeXjahw3r8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497357; c=relaxed/simple;
	bh=p9hqoSu/HsjsyfABS0VPyixE2kcW46/UFMRJtpNvppI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pdjRac9eyRBZDN3EIxO57KOw3sviTzNrzOLd6yla0DcKIkOe1AS47U9/l++SDD7ittoYzdkxCFlBT/ny3BhceaE0PWRB4Y6GLK3Y7phwFIrudmzrF6VCQPdtRq+C1crBCXNQrqTbD1SvoMOtTVzqNnQH3cppL9FmpSQrn97zsH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STDobxnL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497356; x=1780033356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p9hqoSu/HsjsyfABS0VPyixE2kcW46/UFMRJtpNvppI=;
  b=STDobxnL0ps/z+In0pzUfcs+Gw8vVhuHQHyTA5lQLzgcXfj9wu3vGcrK
   fTp0bpTSr1q5fxK9PRsWjHBs4Z0o9tTfU+MXkyPQyxKyfb6jLe704Fht/
   7Cos15g7IqybnZzKgGpHSIs6hc28XpO/yfWEfHzPG7sfHogrpNZ3bmfQh
   VTeUYVlHGf2Uf7ma+ZVJ0fz89xv7mZWjmQhdDydpewmn1k5p7eERxYxqX
   sDbcn7CkV3zL5/fnOn/Iun41U7TvaAALns2a1zcWEuqC1sz8ZLvTwIOq0
   VmO8cPL5RpnrzxbspBK/KFdYSgUTymT6w6BGYwP+LRSsJ4HCSZ4n55j55
   Q==;
X-CSE-ConnectionGUID: OCOU+QPVRrSG+DLqWghyvw==
X-CSE-MsgGUID: h7XekdrSSjqNGGim05AA9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963032"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963032"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:42:36 -0700
X-CSE-ConnectionGUID: sX7W78N6RGefx/ixE10Qpg==
X-CSE-MsgGUID: EQlW02SCRkeY3QkKQvP9LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443338"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:29 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 09/30] KVM: x86/mmu: Handle page fault for private MMIO
Date: Thu, 29 May 2025 13:34:52 +0800
Message-Id: <20250529053513.1592088-10-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for resolving page faults on private MMIO. This is part of
the effort to enable private assigned devices (known as TDI in TDISP
spec).

Private MMIOs are set to KVM as vfio_dmabuf typed memory slot, which is
another type of can-be-private memory slot just like the gmem slot.
Like gmem slot, KVM needs to map its GFN as shared or private based on
the current state of the GFN's memory attribute. When page fault
happens for private MMIO but private <-> shared conversion is needed,
KVM still exits to userspace with exit reason KVM_EXIT_MEMORY_FAULT and
toggles KVM_MEMORY_EXIT_FLAG_PRIVATE. Unlike gmem slot, vfio_dmabuf
slot has only one backend MMIO resource, the switching of GFN's
attribute won't change the way of getting PFN, the vfio_dmabuf specific
way, kvm_vfio_dmabuf_get_pfn().

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c   | 9 +++++++--
 include/linux/kvm_host.h | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 40d33bd6b532..547fb645692b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4501,8 +4501,13 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+	if (kvm_slot_is_vfio_dmabuf(fault->slot))
+		r = kvm_vfio_dmabuf_get_pfn(vcpu->kvm, fault->slot, fault->gfn,
+					    &fault->pfn, &max_order);
+	else
+		r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn,
+				     &fault->pfn, &fault->refcounted_page,
+				     &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b850d3cff83c..dd9c876374b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -620,7 +620,7 @@ struct kvm_memory_slot {
 
 static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
 {
-	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
+	return slot && (slot->flags & (KVM_MEM_GUEST_MEMFD | KVM_MEM_VFIO_DMABUF));
 }
 
 static inline bool kvm_slot_is_vfio_dmabuf(const struct kvm_memory_slot *slot)
-- 
2.25.1


