Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396C3D9E8A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 09:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhG2HgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbhG2HgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 03:36:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BE1C0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso7955254pjf.4
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omwDqSVrMraB8zPCmbagpNybYhuwUgLxPSaQSPVKs0I=;
        b=naBlQMPkB/0DkelUJr1LWVocrdIW6Peexm/f7/BA/529HP7dXnwA1mEQRpxsTu/nyt
         5tSNHUAPj0I23nUM3cEaLX7W0FcfFZ/nIw/hTE0AbmJOLKU6x4Our6Q4VO6WxlOJJCEK
         v75eCTZ2rkY4QZ4y+7yLjNGET7/dDbliCxmVK70acQ5r5hI7NYOBP6q5q2H55CRB27Yw
         JgDWvRBoG8Q2BXzdSiM0/OI45aNpXQyYEVdGOMn/e2B4DUPsbSxolGo9ZcFYLJ9z3d2g
         n1NF1lN2f4dqSTn2d4cGD5EJW0DwNvhKakHLHdWUFAi1yGntoi8qBSZfWJo845VSX0hW
         z1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omwDqSVrMraB8zPCmbagpNybYhuwUgLxPSaQSPVKs0I=;
        b=lCrxARNjytY7y7TKHGII4hTtdalNMDm3Jgbgw1keziyDo7nSArvVPRzog/FsjZgux3
         6xhnPBjR9CukBk1+bc9+g0IdB4+z3w4UXyVsMqd97fm6tU5zU2iu+YT3HiLR2MscQok3
         1gwg4nPeLbm+qhs6IChao+1x9fTwvL2ftPbgvGYg4/0YslDxt+bMws/gn2EsI+qGkEuL
         A9JSBrUUqHiSALywwutPsCjla2MzdGNmrkjjnwldNaJobI0v7VH7aMUB+R7HBr+wueX8
         3i/ccAdI+fH5vZ/hMJDcsSj7X1rw5iXJDvEchFwe7rMJFRYlXiOspM0PbXCJ4w3vPzsK
         CR5w==
X-Gm-Message-State: AOAM533SxGGMhHXU30y3hbNjtO8F2JXO5ZYeFoCTw/UM3Igh5qjjzQ52
        jm9BR+who+ibBkzC6YFGIWR7
X-Google-Smtp-Source: ABdhPJxHbuy/f6Ntcbrd8G6sqB1/UuTPykG+LdmRwbmQ8qaXm3ieni6kdT8Dl8Ys4/OxQN2NjqkIeA==
X-Received: by 2002:aa7:9a4e:0:b029:32b:34a7:2e4e with SMTP id x14-20020aa79a4e0000b029032b34a72e4emr3941364pfj.20.1627544163282;
        Thu, 29 Jul 2021 00:36:03 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id k198sm2457702pfd.148.2021.07.29.00.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:02 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 01/17] iova: Export alloc_iova_fast() and free_iova_fast()
Date:   Thu, 29 Jul 2021 15:34:47 +0800
Message-Id: <20210729073503.187-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export alloc_iova_fast() and free_iova_fast() so that
some modules can use it to improve iova allocation efficiency.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
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

