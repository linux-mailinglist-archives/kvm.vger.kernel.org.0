Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EBE7D4A9E
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjJXImF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbjJXImC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:42:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B83128;
        Tue, 24 Oct 2023 01:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698136920; x=1729672920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CyUeeVJUyOdoCnKoCMDJ4OfDnN41FQE7poIYURZrFJw=;
  b=XqjFE8bDrNJOQr+ER6l5cEh9vS5rgGqbYdKAeshAc/6fqN9nHUGAfKH0
   wHg7B130kkkWcgJabA2ERqvmWsxglsTy6jrBGFDNUPcZw8zWiKDCcOcmx
   GaugJB1Yn7M9BlXMnBBzqK4cLPad8GJ62hp8Rg8nT20sIKAB1cf6Wrn3a
   Rfyxb9ND9LQ1N6VR3Nb3WwHbi/eC94nuaAhBKluPsXdLiltQDQ9CGZaRK
   Hveve7+W8Xco80b8J913+ZRBwsKhto47DDSFpPz1QDzFF33J5VT+sQWJ8
   11SiofG6hxBnhMQifzB+VbMpLbN8PGruxPJATz8747gk9weEvF8BGeyWt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="389860364"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="389860364"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="849062190"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="849062190"
Received: from b49691a74c3c.jf.intel.com ([10.165.59.100])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Oct 2023 01:41:56 -0700
From:   Huang Jiaqing <jiaqing.huang@intel.com>
To:     joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc:     jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, jiaqing.huang@intel.com
Subject: [PATCH 2/2] iommu/vt-d: Adopt new helper for looking up pci device
Date:   Tue, 24 Oct 2023 01:41:24 -0700
Message-Id: <20231024084124.11155-2-jiaqing.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231024084124.11155-1-jiaqing.huang@intel.com>
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adopt the new iopf_queue_find_pdev func() to look up PCI device
for better efficiency and avoid the CPU stuck issue with parallel
heavy dsa_test.

Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
---
 drivers/iommu/intel/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 659de9c16024..0f1018b76557 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -672,7 +672,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 		if (unlikely(req->lpig && !req->rd_req && !req->wr_req))
 			goto prq_advance;
 
-		pdev = pci_get_domain_bus_and_slot(iommu->segment,
+		pdev = iopf_queue_find_pdev(iommu->iopf_queue,
 						   PCI_BUS_NUM(req->rid),
 						   req->rid & 0xff);
 		/*
@@ -688,7 +688,6 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 			trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
 					 req->priv_data[0], req->priv_data[1],
 					 iommu->prq_seq_number++);
-		pci_dev_put(pdev);
 prq_advance:
 		head = (head + sizeof(*req)) & PRQ_RING_MASK;
 	}
-- 
2.31.1

