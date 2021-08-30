Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC353FB7F5
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhH3OWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 10:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbhH3OWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 10:22:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAEFC061760
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 07:21:58 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t1so13606358pgv.3
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 07:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VYKP4BtY52G/QfxOL4ci9LsSwqIuUiAxga6ojIUWhM=;
        b=rX/n04t3hwSmIEK5sY0o788rpIpjsNj/ric5w+RL9Y5fd/jrKYfgCowq9OT4EPJXpk
         WSehnR/Xk3PPjq51bpOHzx0/XcgTsukhRVdAIRbRcmIJAPf8qutfloXIY/3jQ53FkcVL
         uwGwFmQP21tYDGlvAxMdHr7T41mY372Mjmfup9xPngYq8Z43+grlgY7MS7s1iD4/p0Te
         +8mY7L2idpk4uVCt/dNg0r1w6tzsrVR+1eRlwcIdxQ3ekrh6djsf+qArQ9r5h2HE9vv5
         jsSLq/DZd1qxkCzIjIlZR4dqRACGMiEOp+BtamDSNL5nugEl97bDkHPo0M8LPanXAhNC
         JTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VYKP4BtY52G/QfxOL4ci9LsSwqIuUiAxga6ojIUWhM=;
        b=Mu6ywgd6DpVGlW81w/0eyI3UVImJ9KyATW7Cqe4ARRBrl6RSz5f0cg2GkYrAKLLYoC
         JKuhNxP9NfYbRfG/+6ppnLFGIwJBpId7l7haqjx6V7Cu0wHyxJNWw6c2WoqIfYsuMaSf
         CVNJSHyopckgnqXatIYTzJS4vh60vomQTPEjCpEhANoMddKiTClyoCyugvhP7BtTLM3x
         qB0+PGlWDlw7+WPOpRACarRl6fmmGqsok95gkiAya2LaqJaTvcWeecSfn7K3RrRIINXh
         17rI/bZ7O1zaMIuDjUMdbbvn52ON364E5M7+XGzxXnI46xh2Yl3xfx2EmcoMASFIVDsV
         AeAg==
X-Gm-Message-State: AOAM533/SGVS0yECuOZ1siOqPXcNIbmYT0bfpPNUctK/X7+MmKWzH7EB
        40E5GuDXgMX46fJixT0C6wIS
X-Google-Smtp-Source: ABdhPJxsbkcgJHKC9l8Nzp6aGuWpGOLQSR5SX63hdPPAsp+Np9TJgCk3tFS4YemV8vWYWRm1YrsWxw==
X-Received: by 2002:a63:4cd:: with SMTP id 196mr22087854pge.239.1630333317896;
        Mon, 30 Aug 2021 07:21:57 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id gc20sm10539505pjb.17.2021.08.30.07.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:21:57 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/13] iova: Export alloc_iova_fast() and free_iova_fast()
Date:   Mon, 30 Aug 2021 22:17:25 +0800
Message-Id: <20210830141737.181-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
References: <20210830141737.181-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export alloc_iova_fast() and free_iova_fast() so that
some modules can make use of the per-CPU cache to get
rid of rbtree spinlock in alloc_iova() and free_iova()
during IOVA allocation.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
---
 drivers/iommu/iova.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index b6cf5f16123b..3941ed6bb99b 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 
 	return new_iova->pfn_lo;
 }
+EXPORT_SYMBOL_GPL(alloc_iova_fast);
 
 /**
  * free_iova_fast - free iova pfn range into rcache
@@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
 
 	free_iova(iovad, pfn);
 }
+EXPORT_SYMBOL_GPL(free_iova_fast);
 
 #define fq_ring_for_each(i, fq) \
 	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)
-- 
2.11.0

