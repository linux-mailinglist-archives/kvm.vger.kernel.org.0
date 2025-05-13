Return-Path: <kvm+bounces-46288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E291AB4A50
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 06:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD008C1B66
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 03:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702951E00B4;
	Tue, 13 May 2025 04:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lIzzXDsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC05A1DFDB9
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 04:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747108805; cv=none; b=HdTSTFugCePznZnMwFpxuN/WyXEurPALWTXIblPYYKmCAxWVqleF2M9YcS40qm42KTUVKWipVd9+L8XCW9TEDBkHa7nTo0NP7H6txx93//vuxZwo+bBieZgXBY5RrpofTMb4Ep6NWqILZqNcvVGTUIU/2Pi+ZDy7Wo+Y/+C8aEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747108805; c=relaxed/simple;
	bh=rzks3wkUnLf+6qfz2WP3nqrT3TFPFhieC+o6l4ZsTVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WuG2ENVdllFHuWcwXq9BhroH9qrbvIwVZLlj1hj2+sQuylTx731U5x7Dfm7WghspAy84RobxVoLCoCpKHjc+EJD2AevpeMPrCxtKZWsgHrI0pWRqQwfXdgXOgBpsp9LCj1hNDdnvGq4WouFpIKTiwcY3Mkk3D9vw/9qvSGcewmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lIzzXDsB; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22e09f57ed4so64328425ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747108803; x=1747713603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/gdTvcfAWXkwUQEOSCNN9+8zrnQzItlUJAzqD2wmz+E=;
        b=lIzzXDsBx+XqdpRMautAB61bob0Vt2yD4lA7bpxi8IhDk6Q2wO3vAbvc9rh85vJQKA
         zDQ32ZU7TCiycDMulGZKO/2+XiWgnTYFRxAegFsEP+LaxM6bA7w86KdiBL3D/E89AwR1
         bZg+VXdaKVerKqFAKUFvCS3Wduk3wvUnWpPbrQAnHPtvLAnvaXLBG4IJ7DXxwMJcA8+I
         1tz6zbVUhyLN27N+q2SLe7oD2wNhaGCSzLTzQNI9kJOY06OdQNiGt1nNwQ5P6N8ll4n2
         WxW1+568GmSnH8fAtzO3YVgzIGIflG4lCUSpSMKVtZkmb8sNKmL4/Us2Mk9yCNDg7sa7
         Ml9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747108803; x=1747713603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/gdTvcfAWXkwUQEOSCNN9+8zrnQzItlUJAzqD2wmz+E=;
        b=G7m8sQ7VqBcXhmMCaCptZgo59nonCbLeXWQQdRL/FzWMcsGBSDMpPQxiGvSVn6qizI
         KE9moQrZpIJeUt2GUyBrVdbXUpwjInc40qCsUCe6ENpUEhOaICwBPdlELI6Remk7GD3u
         R2hjunYg8EElrCpXG/MnvLNfiPCvlwv7PfMNHPGgOia+9f5plm90adzF5zuHo7kNWMkv
         u+DYSSw+Yz8kEtG1p91Xsw8AYRWIy47/VakjtJnIWI0mfywrif3b5mRTGkjQ81wfKZnk
         HAFYR8D8SkrBqb8KgQ1/MBXs+wo3IDkbjMgS3nVvPbK8GroEU1aIjIOwTnsNefV+JcZ5
         V5Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUD/q0INVI1OI/5gjwhJTaPhnhSaZfKXU51xpJctu3++cckvhj1r4IY+yq8cWwgi44ZUqk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxl+ucRcxeF03hLKY3X3cC14aO90ZR24w2kED5KrYC6lKsMHCI
	JqZ2K8WT02xf1Yvt6QvxDmztt4lCtS6fcm00V07AeO79/nB7rHWcp7wybpLVu30=
X-Gm-Gg: ASbGncufYxTqVFLqFjB3j5RwgNDcAW8kmCs6+uCiXpG4kxSjw60XwY87+UBA0NQuP8r
	2PSuxQ5BlUj/GhkSAxrw/74WH8Ba6XTfOJR8phuikHEh7j/Fn7RDCUrfEV/Tz8+5adI0KfU96DY
	VoR/Mpm24DWiI5eQ5JiNy47Hk15MIs/7uAFx473wLT0ytduaqOb6JVhTPcbCfB17hLU9WnF6YK0
	WUoMn0prScmaCdugxV0uw0JHkjOYzGmKpXXxsXlJ0CEewvSdfpuM2PUreL1u1VVcXVlQl3VYlDh
	bwkjtrQv1Tt7kDG20xlApHsCVQZGXi0bn5M=
X-Google-Smtp-Source: AGHT+IFqyunXW2Qn+DGBfVnG0/oobrE4llwuiyed02E6Cy0NHv/lsNmYSzpnwlSbbP0qxQ7qQXjisA==
X-Received: by 2002:a17:903:32d1:b0:223:807f:7f92 with SMTP id d9443c01a7336-2317cb4f087mr24910615ad.20.1747108800729;
        Mon, 12 May 2025 21:00:00 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc829eb27sm70292695ad.208.2025.05.12.20.59.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 May 2025 21:00:00 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: lizhe.67@bytedance.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH] vfio/type1: optimize vfio_pin_pages_remote() for hugetlbfs folio
Date: Tue, 13 May 2025 11:57:30 +0800
Message-ID: <20250513035730.96387-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_pin_pages_remote() is called with a range of addresses that
includes hugetlbfs folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

This patch optimize this process by batching the statistics counting
operations.

The performance test results for completing the 8G VFIO IOMMU DMA mapping,
obtained through trace-cmd, are as follows. In this case, the 8G virtual
address space has been mapped to physical memory using hugetlbfs with
pagesize=2M.

Before this patch:
funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();

After this patch:
funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f..bafa7f8c4cc6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -337,6 +337,30 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+/*
+ * Find a random vfio_pfn that belongs to the range
+ * [iova, iova + PAGE_SIZE * npage)
+ */
+static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
+		dma_addr_t iova, unsigned long npage)
+{
+	struct vfio_pfn *vpfn;
+	struct rb_node *node = dma->pfn_list.rb_node;
+	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
+
+	while (node) {
+		vpfn = rb_entry(node, struct vfio_pfn, node);
+
+		if (end_iova <= vpfn->iova)
+			node = node->rb_left;
+		else if (iova > vpfn->iova)
+			node = node->rb_right;
+		else
+			return vpfn;
+	}
+	return NULL;
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -670,6 +694,31 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				iova += (PAGE_SIZE * ret);
 				continue;
 			}
+
+		}
+		/* Handle hugetlbfs page */
+		if (likely(!disable_hugepages) &&
+				folio_test_hugetlb(page_folio(batch->pages[batch->offset]))) {
+			if (pfn != *pfn_base + pinned)
+				goto out;
+
+			if (!rsvd && !vfio_find_vpfn_range(dma, iova, batch->size)) {
+				if (!dma->lock_cap &&
+				    mm->locked_vm + lock_acct + batch->size > limit) {
+					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
+						__func__, limit << PAGE_SHIFT);
+					ret = -ENOMEM;
+					goto unpin_out;
+				}
+				pinned += batch->size;
+				npage -= batch->size;
+				vaddr += PAGE_SIZE * batch->size;
+				iova += PAGE_SIZE * batch->size;
+				lock_acct += batch->size;
+				batch->offset += batch->size;
+				batch->size = 0;
+				continue;
+			}
 		}
 
 		/*
-- 
2.20.1


