Return-Path: <kvm+bounces-5715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B6F825116
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B00811F23990
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F9D24B20;
	Fri,  5 Jan 2024 09:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAs4YsIO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B6424213;
	Fri,  5 Jan 2024 09:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704447896; x=1735983896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dRCZ1S0CO2msFURA90luHjWFusP5YsJ6PzRmy9EYQoE=;
  b=HAs4YsIOHW+Pid1jcca5wKwo6ctPSfAA65outbCZccaszkdPYOsrdm76
   JGPi3y3xfPR5ZMT0D2ybPTPzA8os3obluvbRs38R26EHiclsnV0AUw16D
   PCdmqiMhTPk86PBHIyEYhEsE7gAlURIa/SuclNem7XRCBtKzh+8OJB+w/
   f/cbM8dU4HGnNzXPVQhbHXdIVLOVT2ts76277VWBgYHOy2VBOlbyncKsV
   9ajEIQ3iUuTlLpFS1cTbCaxeAob5hXgiT531WiS21gVukJ2pfvccLdgiB
   JHRK9rqT9iPIw0hukA260h4M/3/XJeB+vnuybrPw867bJpW3UCFU7E0MP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="10959399"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="10959399"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:44:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="784158177"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="784158177"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:44:47 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	olvaffe@gmail.com,
	kevin.tian@intel.com,
	zhiyuan.lv@intel.com,
	zhenyu.z.wang@intel.com,
	yongwei.ma@intel.com,
	vkuznets@redhat.com,
	wanpengli@tencent.com,
	jmattson@google.com,
	joro@8bytes.org,
	gurchetansingh@chromium.org,
	kraxel@redhat.com,
	zzyiwei@google.com,
	ankita@nvidia.com,
	jgg@nvidia.com,
	alex.williamson@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 3/4] KVM: VMX: Honor guest PATs for memslots of flag KVM_MEM_NON_COHERENT_DMA
Date: Fri,  5 Jan 2024 17:15:35 +0800
Message-Id: <20240105091535.24760-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240105091237.24577-1-yan.y.zhao@intel.com>
References: <20240105091237.24577-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Honor guest PATs in the range of memslots of flag KVM_MEM_NON_COHERENT_DMA
set no matter the value of noncoherent dma count.

Just honoring guest PATs (without honoring guest MTRRs) for memslots of
flag KVM_MEM_NON_COHERENT_DMA is because
- guest OS will ensure no page aliasing issue in guest side by honoring
  guest MTRRs in guest page table.
  Combinations like guest MTRR=WC or UC, guest PAT = WB is not allowed.
  (at least in Linux, see pat_x_mtrr_type()).
- guest device driver programs device hardware according to guest PATs in
  modern platforms.

Besides, we don't break down an EPT huge page if guest MTRRs in its range
are not consistent, because
- guest should have chosen correct guest PATs according to guest MTRRs.
- in normal platforms, small guest pages with different PATs must
  correspond to different TLBs though they are mapped in a huge page in
  EPT.

However, one condition may not be supported well by honoring guest PAT
alone -- when guest MTRR=WC, guest PAT=UC-.
By honoring guest MTRRs+PATs, the effective memory type is WC; while
by honoring guest PATs alone, the effective memory type is UC.
But it's arguable to support such a usage.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85a23765e506..99f22589fa6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7600,6 +7600,9 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
 	if (is_mmio)
 		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 
+	if (slot->flags & KVM_MEM_NON_COHERENT_DMA)
+		return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-- 
2.17.1


