Return-Path: <kvm+bounces-2671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8D67FC61E
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 21:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BE551C225F0
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 20:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E1157330;
	Tue, 28 Nov 2023 20:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="Lov+Wi6P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C921BEB
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:48 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-d9caf5cc948so5416672276.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701204588; x=1701809388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jRGmXGqyJzQ9dzCxzy8J7vcwlH74KXpuX5+P/ckDUHQ=;
        b=Lov+Wi6PraKvRis1bszdfdT0CGBn6/32ZpM5rSVgJwaQp05JwdvS0bimH1FHdJZgkj
         b+CgFqGST9/FPl87aGAhqPVhYSRTd5scTGnMJu/cEldKws+ZBbcvIEff+e0fzlKxbgcU
         hV4fT6D7BuVcZp9t+gYKWikT8yjfYr+6ekLd4zyDuu9ZQm0Loq63qpD9vbUuqwVnWX4C
         qPSdhqs7qISvXYwc7nmf0I9y5a2IXr7yzfHEXxPeb75DSecGStkGPoCyINZOplZE14QB
         z0RikNQVs6E3whmr05d3DNwd/tEc7H1R43u3QdSJrcubQewc7emccwGezcQkMK7Bngyx
         pJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701204588; x=1701809388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jRGmXGqyJzQ9dzCxzy8J7vcwlH74KXpuX5+P/ckDUHQ=;
        b=KuBIwrM8PkUeEH3nuplwwTeEj6Nr5U22nBQxUsVWUPvnrAcsbEEY61VyFm50pUc15A
         EIB5pyqVeaFRhBf9hE2uEhhJKtWhb/1P6nYrAIlG1EfyOb9Qx+/MHFX1fiNFJtQs3TDx
         OOU51tbO/kky84ZPtteZimLZk9J57Q7ANloIrUkNI8qXMTZi2QBY/Enj9qJwvGZ8PzpH
         uVq62qzRJgfxl/2fykIr1WGcUQEsZHiK2GgwUntSBhgrk1E6jIQ2XqGQPAUszieYAnsU
         r/s0mpp+NfUSgKl/nWXNahDdzwyadLJFB7CcSnz5MME4H0m8WFZVzodfQ6b2YxoHzYjr
         GzNA==
X-Gm-Message-State: AOJu0Yw8FfL02NiCr996je1REfR5sb3lHJtgBoyu7aj8Dw0IADS+6lh5
	cvX5MUtdqi0Zy4a8190cceG6Sw==
X-Google-Smtp-Source: AGHT+IE78UUsr3+phF/56bFMU/5eN5UKiQDczVpHvT25XLH3DszV1HuF5Eb6PvW6XiPusog1uQd9qQ==
X-Received: by 2002:a05:6902:20f:b0:da0:c615:e4a6 with SMTP id j15-20020a056902020f00b00da0c615e4a6mr16658576ybs.24.1701204587831;
        Tue, 28 Nov 2023 12:49:47 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id d11-20020a0cfe8b000000b0067a56b6adfesm1056863qvs.71.2023.11.28.12.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:49:47 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	alim.akhtar@samsung.com,
	alyssa@rosenzweig.io,
	asahi@lists.linux.dev,
	baolu.lu@linux.intel.com,
	bhelgaas@google.com,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	david@redhat.com,
	dwmw2@infradead.org,
	hannes@cmpxchg.org,
	heiko@sntech.de,
	iommu@lists.linux.dev,
	jasowang@redhat.com,
	jernej.skrabec@gmail.com,
	jgg@ziepe.ca,
	jonathanh@nvidia.com,
	joro@8bytes.org,
	kevin.tian@intel.com,
	krzysztof.kozlowski@linaro.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	lizefan.x@bytedance.com,
	marcan@marcan.st,
	mhiramat@kernel.org,
	mst@redhat.com,
	m.szyprowski@samsung.com,
	netdev@vger.kernel.org,
	pasha.tatashin@soleen.com,
	paulmck@kernel.org,
	rdunlap@infradead.org,
	robin.murphy@arm.com,
	samuel@sholland.org,
	suravee.suthikulpanit@amd.com,
	sven@svenpeter.dev,
	thierry.reding@gmail.com,
	tj@kernel.org,
	tomas.mudrunka@gmail.com,
	vdumpa@nvidia.com,
	virtualization@lists.linux.dev,
	wens@csie.org,
	will@kernel.org,
	yu-cheng.yu@intel.com
Subject: [PATCH 07/16] iommu/exynos: use page allocation function provided by iommu-pages.h
Date: Tue, 28 Nov 2023 20:49:29 +0000
Message-ID: <20231128204938.1453583-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231128204938.1453583-1-pasha.tatashin@soleen.com>
References: <20231128204938.1453583-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert iommu/exynos-iommu.c to use the new page allocation functions
provided in iommu-pages.h.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/iommu/exynos-iommu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 2c6e9094f1e9..3eab0ae65a4f 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -22,6 +22,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
+#include "iommu-pages.h"
+
 typedef u32 sysmmu_iova_t;
 typedef u32 sysmmu_pte_t;
 static struct iommu_domain exynos_identity_domain;
@@ -900,11 +902,11 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	if (!domain)
 		return NULL;
 
-	domain->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
+	domain->pgtable = iommu_alloc_pages(GFP_KERNEL, 2);
 	if (!domain->pgtable)
 		goto err_pgtable;
 
-	domain->lv2entcnt = (short *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	domain->lv2entcnt = iommu_alloc_pages(GFP_KERNEL, 1);
 	if (!domain->lv2entcnt)
 		goto err_counter;
 
@@ -930,9 +932,9 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	return &domain->domain;
 
 err_lv2ent:
-	free_pages((unsigned long)domain->lv2entcnt, 1);
+	iommu_free_pages(domain->lv2entcnt, 1);
 err_counter:
-	free_pages((unsigned long)domain->pgtable, 2);
+	iommu_free_pages(domain->pgtable, 2);
 err_pgtable:
 	kfree(domain);
 	return NULL;
@@ -973,8 +975,8 @@ static void exynos_iommu_domain_free(struct iommu_domain *iommu_domain)
 					phys_to_virt(base));
 		}
 
-	free_pages((unsigned long)domain->pgtable, 2);
-	free_pages((unsigned long)domain->lv2entcnt, 1);
+	iommu_free_pages(domain->pgtable, 2);
+	iommu_free_pages(domain->lv2entcnt, 1);
 	kfree(domain);
 }
 
-- 
2.43.0.rc2.451.g8631bc7472-goog


