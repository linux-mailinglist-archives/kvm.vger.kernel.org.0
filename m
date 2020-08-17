Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5012478BA
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 23:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgHQVUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 17:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgHQVUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 17:20:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C51C061342
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 14:20:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f10so8168951plj.8
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 14:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tcd-ie.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6SU4e7qioZa1MSGn21iWR1ma/iTKUTYpUuysCGcy14=;
        b=tQ0FE9hLvaMYPBTVoFLMvapqE3NmtNzvVLom8ama2749kqs+FHz9nxs7AHIJO7mDBv
         K8Q+pQ4G/b4TMv1DEEAJUykFiG2bIYGrU3nC3oR7j6f2NPSzKfCcVFaY4kOAcXUttSVT
         FcQd5pxyrvBzc1oQk+/2JMAu6G+p7dtknI9bruysURWXuQybraU9AWYk41P2rQ/Ugs1V
         KCxO0AsJuqMRVrwiHYTBB1bwM8dzGrwTw+I2FuHbRzUP2Mdhb2OLUMXYWcNu2LS9HUSM
         o/iArU0Mr099iYvhHaRGgPLkM2XevIGWNnpUQKOQ1d+f4UwWeBsVd7zpHvgp1Gst8iud
         sCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6SU4e7qioZa1MSGn21iWR1ma/iTKUTYpUuysCGcy14=;
        b=pBeXt33GtD6cnfoHTa/jnnF9X+5RuhkUmL4lUb+ytQuNBqdkTBMSiIyM0RoEoL5Nbc
         1S/JKRvrdgwpq3tu7Zc/dZkUnj+A5s17f+4zCBQrBIkHnbjaXBu0wUhucb7Xm1jUjlcN
         3cw3xbvOqdBAhRQLHfTVdZi0cCEuqgueDqeZZu79LK9eO+Pvi8dfixw0kHFajLvBU+Bh
         +vqCvMXUq75pMva2VUJXidyUYyOn9C1US3ZQyKWC2mpcTOP657N6B5R/+0nd9ehGRkN/
         iGTjettfBg58vRZDhGzlo3rL31tjL+L7f8/cf8dzZoR3/p+n3RGzcvqfUBiuscl3oget
         3vbA==
X-Gm-Message-State: AOAM532N37ojR/OFj80AxX34pSkKvaaQ5SmFsqvcOMV1GJweyYouXKBs
        bezZrxPRknd0hYS7xap4LwtPtQ==
X-Google-Smtp-Source: ABdhPJxLpxYOD9HqJyjPsE+aMSLqEST9f99mfp5IwRRr6pkeOH6GEyp42pRMo63jP9uxCJQN7toCzQ==
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr14318007pjb.66.1597699202157;
        Mon, 17 Aug 2020 14:20:02 -0700 (PDT)
Received: from localhost.localdomain (S0106ac17c8c0ce82.vc.shawcable.net. [24.87.214.6])
        by smtp.googlemail.com with ESMTPSA id q10sm20733468pfs.75.2020.08.17.14.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 14:20:01 -0700 (PDT)
From:   Tom Murphy <murphyt7@tcd.ie>
To:     iommu@lists.linux-foundation.org
Cc:     Tom Murphy <murphyt7@tcd.ie>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] Handle init_iova_flush_queue failure in dma-iommu path
Date:   Mon, 17 Aug 2020 22:19:50 +0100
Message-Id: <20200817211951.14794-2-murphyt7@tcd.ie>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200817211951.14794-1-murphyt7@tcd.ie>
References: <20200817211951.14794-1-murphyt7@tcd.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

init_iova_flush_queue can fail if we run out of memory. Fall back to no
flush queue if it fails.

Signed-off-by: Tom Murphy <murphyt7@tcd.ie>
---
 drivers/iommu/dma-iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7433f74d921a..5445e2be08b5 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -356,9 +356,11 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 
 	if (!cookie->fq_domain && !iommu_domain_get_attr(domain,
 			DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) && attr) {
-		cookie->fq_domain = domain;
-		init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
-				iommu_dma_entry_dtor);
+		if (init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
+				iommu_dma_entry_dtor))
+			pr_warn("iova flush queue initialization failed\n");
+		else
+			cookie->fq_domain = domain;
 	}
 
 	if (!dev)
-- 
2.20.1

