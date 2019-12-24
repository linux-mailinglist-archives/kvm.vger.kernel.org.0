Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBBB129E8A
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 08:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLXHq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 02:46:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:49687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfLXHqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 02:46:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 23:46:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="223177088"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2019 23:46:22 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 6/9] iommu/vt-d: Make first level IOVA canonical
Date:   Tue, 24 Dec 2019 15:44:59 +0800
Message-Id: <20191224074502.5545-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191224074502.5545-1-baolu.lu@linux.intel.com>
References: <20191224074502.5545-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First-level translation restricts the input-address to a canonical
address (i.e., address bits 63:N have the same value as address
bit [N-1], where N is 48-bits with 4-level paging and 57-bits with
5-level paging). (section 3.6 in the spec)

This makes first level IOVA canonical by using IOVA with bit [N-1]
always cleared.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 54db6bc0b281..1ebf5ed460cf 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3505,8 +3505,21 @@ static unsigned long intel_alloc_iova(struct device *dev,
 {
 	unsigned long iova_pfn;
 
-	/* Restrict dma_mask to the width that the iommu can handle */
-	dma_mask = min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw), dma_mask);
+	/*
+	 * Restrict dma_mask to the width that the iommu can handle.
+	 * First-level translation restricts the input-address to a
+	 * canonical address (i.e., address bits 63:N have the same
+	 * value as address bit [N-1], where N is 48-bits with 4-level
+	 * paging and 57-bits with 5-level paging). Hence, skip bit
+	 * [N-1].
+	 */
+	if (domain_use_first_level(domain))
+		dma_mask = min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw - 1),
+				 dma_mask);
+	else
+		dma_mask = min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw),
+				 dma_mask);
+
 	/* Ensure we reserve the whole size-aligned region */
 	nrpages = __roundup_pow_of_two(nrpages);
 
-- 
2.17.1

