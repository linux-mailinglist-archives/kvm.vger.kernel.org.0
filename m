Return-Path: <kvm+bounces-2679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA357FC661
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 21:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDD6628635C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 20:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB9F44360;
	Tue, 28 Nov 2023 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="WmMV6ob0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D3F1FF3
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:55 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5ce8eff71e1so41753617b3.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 12:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701204594; x=1701809394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nk58INbxx30xLOHUnMGn9OdPuZubp6H+G9gT2CVk01Q=;
        b=WmMV6ob0b1iKZbSvoDEuo7Zhr3ll+0w4z7L4bxJ3VHcKNLlu5o0YWFoPZyxSpURI86
         AryOsKwrKpXAz9/uV+6M8InS3TUYbhLQ6EepJJdqbCVHqrm+yEmI1AG1cYJ0KugcQAcn
         EN5kXQYsyvjioRz7ldO0Be6gmrHvQk9moBrkJ4eeHVH3nx7XV6v1Cv+DC3BGk7Tg6hB4
         /BDMvlQgP7rL0qsZI7GNP4AM98+vlBt520FtoqV0bio4wqV+AzdxD/6G8w43CY2X6BZd
         P+xzzHPeOJc1J67081r+ZbKwRU2cygCecyiN9TvfH2d3uPx8CpNp9vq21BKfk6LLsuZZ
         WE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701204594; x=1701809394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nk58INbxx30xLOHUnMGn9OdPuZubp6H+G9gT2CVk01Q=;
        b=VH+f3LM5mOdmQcA7nRSqYjAoD5rt1l/uZktSX/t1gm6yMJs6opA2AdxwBH8rnbgxhR
         REukZ+dIgoKlzA/MCZW6KA0H8CEuW41jqtPmZudkfw7phdGFBOwG8hYmg94XAsSlJi2o
         1jNRwQ4dA5JkP6xvM2w1iPsQK0wlfwcwaCAMgPHkXk/D3HWrYVwUXeQZVMZqWQiosyxl
         XWvzhujW6va0vKew8Jk64xuDIFZHUR+Cnt85HweRNPAqwYB4SBsa+QKoaggVYDatx/li
         /8inaSntkBQxr7HGIm9E0vItjlvL48sDdGbyxQm09o/ttbuZeaWN7h4LqMSRlaWYg1fV
         1oIg==
X-Gm-Message-State: AOJu0Yx49fT9sMoG3OgIVaiHtlqg/iV95uoT81ibOlr+w+LthxpgO7fM
	Vy7vChf3JIRV5qm30FK2DHhclQ==
X-Google-Smtp-Source: AGHT+IFeRft5lu3DnWQgWnRJh58TGHHoSR4IZRyS1wE4nkLKveRfays9X3IHaY/+Xezkx1Q2h+wp9Q==
X-Received: by 2002:a81:a507:0:b0:5cb:d645:8cdf with SMTP id u7-20020a81a507000000b005cbd6458cdfmr16849996ywg.48.1701204594372;
        Tue, 28 Nov 2023 12:49:54 -0800 (PST)
Received: from soleen.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id d11-20020a0cfe8b000000b0067a56b6adfesm1056863qvs.71.2023.11.28.12.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:49:54 -0800 (PST)
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
Subject: [PATCH 14/16] iommu: account IOMMU allocated memory
Date: Tue, 28 Nov 2023 20:49:36 +0000
Message-ID: <20231128204938.1453583-15-pasha.tatashin@soleen.com>
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

In order to be able to limit the amount of memory that is allocated
by IOMMU subsystem, the memory must be accounted.

Account IOMMU as part of the secondary pagetables as it was discussed
at LPC.

The value of SecPageTables now contains mmeory allocation by IOMMU
and KVM.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 Documentation/filesystems/proc.rst      | 4 ++--
 drivers/iommu/iommu-pages.h             | 2 ++
 include/linux/mmzone.h                  | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 3f85254f3cef..e004e05a7cde 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1418,7 +1418,7 @@ PAGE_SIZE multiple when read back.
 	  sec_pagetables
 		Amount of memory allocated for secondary page tables,
 		this currently includes KVM mmu allocations on x86
-		and arm64.
+		and arm64 and IOMMU page tables.
 
 	  percpu (npn)
 		Amount of memory used for storing per-cpu kernel
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 49ef12df631b..86f137a9b66b 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1110,8 +1110,8 @@ KernelStack
 PageTables
               Memory consumed by userspace page tables
 SecPageTables
-              Memory consumed by secondary page tables, this currently
-              currently includes KVM mmu allocations on x86 and arm64.
+              Memory consumed by secondary page tables, this currently includes
+              KVM mmu and IOMMU allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 69895a355c0c..cdd257585284 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -27,6 +27,7 @@ static inline void __iommu_alloc_account(struct page *pages, int order)
 	const long pgcnt = 1l << order;
 
 	mod_node_page_state(page_pgdat(pages), NR_IOMMU_PAGES, pgcnt);
+	mod_lruvec_page_state(pages, NR_SECONDARY_PAGETABLE, pgcnt);
 }
 
 /**
@@ -39,6 +40,7 @@ static inline void __iommu_free_account(struct page *pages, int order)
 	const long pgcnt = 1l << order;
 
 	mod_node_page_state(page_pgdat(pages), NR_IOMMU_PAGES, -pgcnt);
+	mod_lruvec_page_state(pages, NR_SECONDARY_PAGETABLE, -pgcnt);
 }
 
 /**
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1a4d0bba3e8b..aaabb385663c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -199,7 +199,7 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
-	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. KVM pagetables */
+	NR_SECONDARY_PAGETABLE, /* secondary pagetables, KVM & IOMMU */
 #ifdef CONFIG_IOMMU_SUPPORT
 	NR_IOMMU_PAGES,		/* # of pages allocated by IOMMU */
 #endif
-- 
2.43.0.rc2.451.g8631bc7472-goog


