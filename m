Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A063D9EA9
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 09:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhG2Hg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 03:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbhG2Hgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 03:36:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB082C0617A5
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k1so5919121plt.12
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Luhm9TAVP2wsLg1TvJFQP9kHuyEtOYvhVNQ1V8OHfQ0=;
        b=wFCV4SBCXk5621fdFr55sUuwMMbmIgTgY/rtUdXbW3xvNzAaZ2rL+ez1VeGAW96pA3
         wTub1rEunVnzrVZ+QhEgGsPZyDe6h1lwSFhkPHV7txnkJkEaxRGzEd7qlgM6+KrU54RC
         RIABMezMY+9/7jd4fFE6hAZGKYA/7DgtLjBpuNMPXH81H18MjVxlBG/RJJh3gk6Yr4qS
         TE6Amax82kmf6u0GMsZvZBRonygQ0ViZrAJ4IKBjmuhMU5deWYzHZ1HebLjzHXDoWbcN
         xK/THnoSQtI9V5WWj2+phY/JzTjnobU+hrzH2icQzEbd7QDXO2gvO2nH2Dm7fln7p90e
         5rWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Luhm9TAVP2wsLg1TvJFQP9kHuyEtOYvhVNQ1V8OHfQ0=;
        b=Xo0lzPXHmJr5s9oQhpl+LS0+rFzt48E8Kw2wh8bxLJlknC2vLRL20GsgAwmOCCvnUd
         td4Kzb4QMp0WRokRRmvdDtB+3mC6aTDVkIg5mqV7YlfM4U5tZ018hY2ORR1Tw1I7pPec
         gUwDQyjxhY/T40a23+BdjPR0D87/Qh6tw9PXqtG8CYwy2szEy4PdV96o/oXvG7qxp811
         IDjjeVrUT61KMV2IZp8Rjwysp8OddsYJKC4ofE3J/J0fLDYgGkPCVVmjsS+DJgnBfzV/
         r6oSF+84J36ikABw4nyYPySq9Ocep7hdXXX3daIA2kyBxpLaHkxZbinfmc2+QN+LYsvN
         zt/g==
X-Gm-Message-State: AOAM5330tr2zkX7CASynTbL0Du8RPp6UgiXFId5Lrnym0M6icpQWxIGd
        a4smB5pUAT42kh0Y4pTmXNZA
X-Google-Smtp-Source: ABdhPJy55TZBFCrNFJg4WwvBWq2FhbimstBp0qiEjol4+eO0MEa2OTmyjosxt7zxacNnQd7bldoYCQ==
X-Received: by 2002:a17:903:31c3:b029:ed:6f74:49c7 with SMTP id v3-20020a17090331c3b02900ed6f7449c7mr3508604ple.12.1627544194419;
        Thu, 29 Jul 2021 00:36:34 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id y35sm2412706pfa.34.2021.07.29.00.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:33 -0700 (PDT)
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
Subject: [PATCH v10 07/17] virtio: Don't set FAILED status bit on device index allocation failure
Date:   Thu, 29 Jul 2021 15:34:53 +0800
Message-Id: <20210729073503.187-8-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need to set FAILED status bit on device index allocation
failure since the device initialization hasn't been started yet.
This doesn't affect runtime, found in code review.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..a15beb6b593b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device *dev)
 	/* Assign a unique device index and hence name. */
 	err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out;
+		return err;
 
 	dev->index = err;
 	dev_set_name(&dev->dev, "virtio%u", dev->index);
-- 
2.11.0

