Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF2A3A8281
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhFOOUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhFOOSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:18:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1695C06115D
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:14:16 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e20so11596281pgg.0
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/FJesSbjdD3ax6QLZHwWomAg+hmA/0XqmQi+5t3uBts=;
        b=QAmzB4gHG7Cy4ZN45ovZfpN6L1SILefQ0L+NxivAp0a6ufJ3shF5BHnlp4wRjjtevl
         Z7kY9HIEZPuiRINzUexcDU0nWp6ZF+CkmwLIjH/F4xTYMpgJqWG4JL36Su/+tnFQyM38
         PQsbmnUUSs6LfqFK6Y5pWTfk0aWhWAYKWk3g51/NT9lXSx9FY82ucMbd7x4whRd3GnDT
         SNV/a9nSjTPjAT1DTDg/fOVFZMXcOzmVcwqxnUn+YWCFSPuFh8NDIbjMsRQ/k+L1hbNc
         Fp6wCNh2LQAkqhTBA8ShNGsEatOTf0DgYL0PYQmlXjFQUADRCb0aB401iUdLw5ezIe7M
         6dwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/FJesSbjdD3ax6QLZHwWomAg+hmA/0XqmQi+5t3uBts=;
        b=EL0Kq28GC8WW4cLnPRkzqFPL1NlR7td785zK/HRjT0RjTwMP+2DEZrjoJzMjVkUjYi
         F7ji5KaT6Fbk1A9FAs5jbDnsdC6nH/vWmxcApFWTCcwF2oEoVliuj1qDdH7cAXYRI2DI
         8lxrJff2mCtVDGCs9s+f4m6YqImD/6HnPJo6u+aEToS8VxlKXmcq7527XL0gAKr1MND8
         BKE2kp6UQ9UJlXB5HV1u607jCuLXVzhZjW1ycfNspjOvqRjoYjPqWt0iYlTMAP0xaXKZ
         oGE+3/u+WsadpDf7io98wsPjMglcIS8X3kVPgThmGILzRH1B7xXkbOyz68NQt+2t2hFm
         8dmw==
X-Gm-Message-State: AOAM533ixXbwJzPOKaKmAJhI14g0QSrftjy0Q8k/QwUJFQCS24p3DQSX
        EHAYEbk+mHcn+z0ge9Txs2wi
X-Google-Smtp-Source: ABdhPJyjoOKdYN6iIafASuxZ0lb8ce4AFMzIucMsE/2yfL6/wOtvuhzP/4QXvpNfGDsqISSeoNQjLg==
X-Received: by 2002:a62:1d0e:0:b029:2d8:30a3:687f with SMTP id d14-20020a621d0e0000b02902d830a3687fmr4531470pfd.17.1623766456186;
        Tue, 15 Jun 2021 07:14:16 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id h8sm2255456pgc.60.2021.06.15.07.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:14:15 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 05/10] vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
Date:   Tue, 15 Jun 2021 22:13:26 +0800
Message-Id: <20210615141331.407-6-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an opaque pointer for DMA mapping.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 6 +++---
 drivers/vhost/vdpa.c             | 2 +-
 include/linux/vdpa.h             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 98f793bc9376..efd0cb3d964d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -542,14 +542,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 }
 
 static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
-			   u64 pa, u32 perm)
+			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
-				    perm);
+	ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
+					pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..1d5c5c6b6d5d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -565,7 +565,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index f311d227aa1b..281f768cb597 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -245,7 +245,7 @@ struct vdpa_config_ops {
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm);
+		       u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
 
 	/* Free device resources */
-- 
2.11.0

