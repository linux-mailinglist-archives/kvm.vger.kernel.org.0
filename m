Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3633AB1C
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 06:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCOFio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 01:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhCOFiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 01:38:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12133C061762
        for <kvm@vger.kernel.org>; Sun, 14 Mar 2021 22:38:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x7so5855381pfi.7
        for <kvm@vger.kernel.org>; Sun, 14 Mar 2021 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dGaxNIV8NpWEN5rzIRYOvlj8jKPS9Xwy93a1pAna0qs=;
        b=PJjx4wEMvdjt9TfXtK9oth2iCFk5tg+Kbh1GQ+WL3fo3atQZvQ5soPWQeJHqZ5QysE
         rE2omph93ad6uFbzSOyMAwXh31l4Nbq3rz9wVI8AH+p6O7oKXsrivgxhgGW1OnCJfKJG
         9lE9wZGdmeBFRIEjC3pbNnwsI1khm69I7WqjgmKdQNoTTO5O2/uLv0tWCfXuJbbzIlE4
         8ns3BHiSHfRKpj+bTZwky3ZkmFTvkHLxoOjnxtkEoESRnVN6m3NNtSJqe2XVXtwsqXyp
         gjFzEITksYK5V9cts/c14OkN8y7M2ApKhgBdk9SClogu17itbKdbCHiYuFx9N1qUbvX4
         S6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGaxNIV8NpWEN5rzIRYOvlj8jKPS9Xwy93a1pAna0qs=;
        b=Mr3f2G92IxlNBWq08B7Sn8GR/xB6UupbbvPzco0/HhXHloohLlB30dAghlsZEEbtsV
         qZCKjlOYA5QLLjyM8FK9oLhhOStnXiIE+LdlslUMGrH+QIkZ1sqYV2LRgFPE86ON4RsN
         hgwkqNBJoY5+qdpZIG27OfKBikDnwATcgkAw0X6SNtW+sbzBqh8195tnOwMicE0v9OwS
         hlSBNo78TQJpv/FQgE+08bYPLpS52keS8c1qmfBRvL9k/txSfXEHad/CslEbJpbCnvbC
         IpkC0nPTDlNesS37TKye+8auqhnikIJZCNymI58h20QVa2u6sVmdPyn3I2LwTBDZpTz2
         N2sA==
X-Gm-Message-State: AOAM532MCbOQRsurCcbX1PkmJMuT8vfHQsMvz80KOZ+DvLhMKtXft3oO
        s+ueJ64y9cdcFJQkTRjU0U9s
X-Google-Smtp-Source: ABdhPJyPNDa7cApRWnHwPzbO0R8pnkLtt+6ozRigyQSdUsp4cUDhgwxNSCPM22Y5/5glVT9mNaP8BA==
X-Received: by 2002:a63:df10:: with SMTP id u16mr21733129pgg.308.1615786692602;
        Sun, 14 Mar 2021 22:38:12 -0700 (PDT)
Received: from localhost ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id r16sm12302000pfq.211.2021.03.14.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 22:38:12 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 06/11] vdpa: factor out vhost_vdpa_pa_map()
Date:   Mon, 15 Mar 2021 13:37:16 +0800
Message-Id: <20210315053721.189-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315053721.189-1-xieyongji@bytedance.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upcoming patch is going to support VA mapping. So let's
factor out the logic of PA mapping firstly to make the code
more readable.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b24ec69a374b..7c83fbf3edac 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -579,37 +579,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
 	}
 }
 
-static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
-					   struct vhost_iotlb_msg *msg)
+static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
+			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
 	unsigned long lock_limit, sz2pin, nchunks, i;
-	u64 iova = msg->iova;
+	u64 start = iova;
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
-	    msg->iova + msg->size - 1 > v->range.last)
-		return -EINVAL;
-
-	if (vhost_iotlb_itree_first(iotlb, msg->iova,
-				    msg->iova + msg->size - 1))
-		return -EEXIST;
-
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
 
-	if (msg->perm & VHOST_ACCESS_WO)
+	if (perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	npages = PAGE_ALIGN(size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
@@ -623,7 +614,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		goto unlock;
 	}
 
-	cur_base = msg->uaddr & PAGE_MASK;
+	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
 	nchunks = 0;
 
@@ -654,7 +645,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     perm);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -683,7 +674,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -702,13 +693,32 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		vhost_vdpa_unmap(v, start, size);
 	}
 unlock:
 	mmap_read_unlock(dev->mm);
 free:
 	free_page((unsigned long)page_list);
 	return ret;
+
+}
+
+static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb_msg *msg)
+{
+	struct vhost_dev *dev = &v->vdev;
+	struct vhost_iotlb *iotlb = dev->iotlb;
+
+	if (msg->iova < v->range.first ||
+	    msg->iova + msg->size - 1 > v->range.last)
+		return -EINVAL;
+
+	if (vhost_iotlb_itree_first(iotlb, msg->iova,
+				    msg->iova + msg->size - 1))
+		return -EEXIST;
+
+	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
+				 msg->perm);
 }
 
 static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
-- 
2.11.0

