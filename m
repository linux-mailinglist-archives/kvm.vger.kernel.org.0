Return-Path: <kvm+bounces-3235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BDA801BE4
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3960281C23
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1771428B;
	Sat,  2 Dec 2023 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWHszJLN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F7AD50;
	Sat,  2 Dec 2023 01:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510832; x=1733046832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=DNvEQ5Df+enLLKlvPpgNl8iSMA8LDSmYdeB3/CStJvw=;
  b=eWHszJLNQJpKxhmd4cOBWfgH2FcceSsLHm0/+Eaq7DmcxmUaU6zWQ2q5
   TLTcyJ7S6IfQBGW7ZtE0dyHDUES+kgi6i7EJIEpB9zQCqz/yUIyjkWWzz
   6hh/V8edrecTCYxVNMcCUs9yFJz/ha51H6ZmgRVbVOEuAYkPXeP/lfFYt
   QUTOQIMyaynYXcfJ5pY3Eouv4Y7AOD1WTlQX55Pq7DqZ5ydrnF1vfnKl6
   PkZhw6+Qg9ZHBBb37EbYvdxo9iqKZLHfcbBeU9j7OuT40g8KyWXEkWokb
   OLVjRywITAeACNkHF06HGplHt263b+U5MPggfldLqw1osDXEW/YZxCoke
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="625567"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="625567"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:53:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="719780723"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="719780723"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:53:47 -0800
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
Subject: [RFC PATCH 19/42] iommu/vt-d: Set bit PGSNP in PASIDTE if domain cache coherency is enforced
Date: Sat,  2 Dec 2023 17:24:52 +0800
Message-Id: <20231202092452.14581-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Set bit PGSNP (Page Snoop, bit 88) in PASIDTE when attaching device to a
domain whose cache coherency is enforced.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/intel/pasid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 74e8e4c17e814..a42955b5e666f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -679,10 +679,11 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	pasid_set_address_width(pte, agaw);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
 	pasid_set_fault_enable(pte);
+	if (domain->force_snooping)
+		pasid_set_pgsnp(pte);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
 	if (domain->dirty_tracking)
 		pasid_set_ssade(pte);
-
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
 
-- 
2.17.1


