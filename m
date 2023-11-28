Return-Path: <kvm+bounces-2678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D077FC65C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 21:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16A51286213
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 20:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F05961FDB;
	Tue, 28 Nov 2023 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="o/IjtgFT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B1C1FE6
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:54 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-67a34fbaf12so18843206d6.3
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701204593; x=1701809393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B42Ompk/0S+0FHWlF0c0WCUF97rKJOKtrfjrMLAbFqA=;
        b=o/IjtgFTQohEBhw0MZJjxpDFsK8WY+R+3BTtTpGQII2P13f/+ALn1Hy1IXvWVdR/nD
         Lyiof2gy8t2RhxKCEUsyu+xMdiXK9kYoEk+4v/CzcoYIytWDzr1xFcYGEzHNgNcaBdW9
         tAiqsBj6qw9GXtEYKNQ3ooHJ55Nu1ClGh5bpzyliIBIGe95+K6f79uK9JvgU43Zf242q
         YUzxqt31PfSpVlffh94ObQZfG9yu2J2ns0gk6IUz4N8Hc3yMSYkUSuadexgr0Wxx3uG4
         KbnpHLUoQoop5xVrJz/cc1zQDMyzBUmrrcZvilPxHWSaUgC8vcdRE67dlaDeWTafMnNd
         QAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701204593; x=1701809393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B42Ompk/0S+0FHWlF0c0WCUF97rKJOKtrfjrMLAbFqA=;
        b=mtxIbe7wodygj5zKqdoYlzvszpJAEl8CEMBYL22bkTj/orgw3Zdv7jhdg5jXNoE3IN
         yKkME7xVI9qn8yZB7LfCO3bHjCgnzVEAUrgssk9WnUB0IMraBs0wk67OvH1QeoNyJ6ci
         idUM6AgbsK2o3gEGekX6eOXd3vGcUpYwkH+zOYcyjKVOZOzsHMtV1irGKkiBRC0F4L8n
         /y7M6QnisDrcY4EcDywp5elPY+azRpJUFl7In0JoDqBBCtysaneO768I3gnOBDAa8oDZ
         MMV7rg0QDjMwsQkXOgKM6zI2ppDSxJfVK+39nQ6KjZVjIi5aCViJBavgHc1+J+m1rkeD
         26kg==
X-Gm-Message-State: AOJu0Yx6v3fy+4GcdlOhilWEL6jbCgb+FWuHnU3/Hjw4Rczuffx2GYUK
	k0Tfy/szwJvn/uXWo630+UFCDw==
X-Google-Smtp-Source: AGHT+IEnkegi/uFQPrDyc6H7OPo4j0lB/ryXbrV4xgswOmTSvbgLDCpwj8bvXcZGxvDXiQNLdJDbew==
X-Received: by 2002:ad4:4a6f:0:b0:67a:5ae8:d346 with SMTP id cn15-20020ad44a6f000000b0067a5ae8d346mr3075756qvb.62.1701204593484;
        Tue, 28 Nov 2023 12:49:53 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id d11-20020a0cfe8b000000b0067a56b6adfesm1056863qvs.71.2023.11.28.12.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:49:53 -0800 (PST)
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
Subject: [PATCH 13/16] iommu: observability of the IOMMU allocations
Date: Tue, 28 Nov 2023 20:49:35 +0000
Message-ID: <20231128204938.1453583-14-pasha.tatashin@soleen.com>
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

Add NR_IOMMU_PAGES into node_stat_item that counts number of pages
that are allocated by the IOMMU subsystem.

The allocations can be view per-node via:
/sys/devices/system/node/nodeN/vmstat.

For example:

$ grep iommu /sys/devices/system/node/node*/vmstat
/sys/devices/system/node/node0/vmstat:nr_iommu_pages 106025
/sys/devices/system/node/node1/vmstat:nr_iommu_pages 3464

The value is in page-count, therefore, in the above example
the iommu allocations amount to ~428M.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/iommu/iommu-pages.h | 30 ++++++++++++++++++++++++++++++
 include/linux/mmzone.h      |  3 +++
 mm/vmstat.c                 |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 2332f807d514..69895a355c0c 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -17,6 +17,30 @@
  * state can be rather large, i.e. multiple gigabytes in size.
  */
 
+/**
+ * __iommu_alloc_account - account for newly allocated page.
+ * @pages: head struct page of the page.
+ * @order: order of the page
+ */
+static inline void __iommu_alloc_account(struct page *pages, int order)
+{
+	const long pgcnt = 1l << order;
+
+	mod_node_page_state(page_pgdat(pages), NR_IOMMU_PAGES, pgcnt);
+}
+
+/**
+ * __iommu_free_account - account a page that is about to be freed.
+ * @pages: head struct page of the page.
+ * @order: order of the page
+ */
+static inline void __iommu_free_account(struct page *pages, int order)
+{
+	const long pgcnt = 1l << order;
+
+	mod_node_page_state(page_pgdat(pages), NR_IOMMU_PAGES, -pgcnt);
+}
+
 /**
  * __iommu_alloc_pages_node - allocate a zeroed page of a given order from
  * specific NUMA node.
@@ -35,6 +59,8 @@ static inline struct page *__iommu_alloc_pages_node(int nid, gfp_t gfp,
 	if (!pages)
 		return NULL;
 
+	__iommu_alloc_account(pages, order);
+
 	return pages;
 }
 
@@ -53,6 +79,8 @@ static inline struct page *__iommu_alloc_pages(gfp_t gfp, int order)
 	if (!pages)
 		return NULL;
 
+	__iommu_alloc_account(pages, order);
+
 	return pages;
 }
 
@@ -89,6 +117,7 @@ static inline void __iommu_free_pages(struct page *pages, int order)
 	if (!pages)
 		return;
 
+	__iommu_free_account(pages, order);
 	__free_pages(pages, order);
 }
 
@@ -192,6 +221,7 @@ static inline void iommu_free_pages_list(struct list_head *pages)
 		struct page *p = list_entry(pages->prev, struct page, lru);
 
 		list_del(&p->lru);
+		__iommu_free_account(p, 0);
 		put_page(p);
 	}
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3c25226beeed..1a4d0bba3e8b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -200,6 +200,9 @@ enum node_stat_item {
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. KVM pagetables */
+#ifdef CONFIG_IOMMU_SUPPORT
+	NR_IOMMU_PAGES,		/* # of pages allocated by IOMMU */
+#endif
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 359460deb377..801b58890b6c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1242,6 +1242,9 @@ const char * const vmstat_text[] = {
 #endif
 	"nr_page_table_pages",
 	"nr_sec_page_table_pages",
+#ifdef CONFIG_IOMMU_SUPPORT
+	"nr_iommu_pages",
+#endif
 #ifdef CONFIG_SWAP
 	"nr_swapcached",
 #endif
-- 
2.43.0.rc2.451.g8631bc7472-goog


