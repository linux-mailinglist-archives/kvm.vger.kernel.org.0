Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9692D102E87
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfKSVqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 16:46:50 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39491 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfKSVqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 16:46:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id t103so3200824pjb.6;
        Tue, 19 Nov 2019 13:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=pxHhZu6cyx/hOc9XQfd0RH8sE6fpU4bg1PhE5z4/1qLYjOYH4pPFcn5Iahqjcxhrmf
         EGYTAAAIUhEWUGJ/omefmLI4MVoLiY+Yc4Vc5SYNJzlEvcg1Fr2KglaI4g2DH9p8xsai
         heoQHkxrzpXw30oc8Bvp42uax2Ussoqe2kcf2qXInTKvFbHen4FbELczriXQtdWTQnpv
         TAPGE1qzUFAOM9uGBfNf5hcGo23ViWYoCwF+hQALqTHQT4ti4gV1iFJBPT+HU7jpu7xL
         I0RGBdAdLc3AwI3RHelzGSTwhPbPb9IsJe4JORInCMmFgxFESwgTmMiRLAuYtrHC5bpc
         W9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=AMig1+CMuJoptmF8n1svPDGqhb+DyWfkvrtAwtxUj6k56w/e8+YhLuBn00vCsLjqB8
         Jw0Wx+8hlYLvmK75xn4xz14bpLNzYeVQLgU8GeFtCE0ZtFK36vWFFdUQ96gBtnVl7qsY
         WrDRBWGn2jIIoPqkvPY3YXZu6hB8v8/6UiAPjc0cb8Aua8+DQCUsfGOwjsSMPVWFKBKf
         M27k32Z4xJnqUMUJDY87mpBZgam0hBb8q9KPS/vfEFYUItDiZ7jZDA6M07WSGyL/n6DI
         Dqw8uTnd1ZyV0oS0UKzAEjGaOaX6xL7vD5fo5ZkeiY0d/x2Pj66ekGT/mf4ziHMwItAG
         Os7w==
X-Gm-Message-State: APjAAAXWsrB/w/0a9ZRo8QCcpeh+gw58QeYEjn6d0Sc2ZTYwDvNd2Mrs
        dUt5VK1bIeH8BMchGtwkrB8=
X-Google-Smtp-Source: APXvYqxFK2Vu0e0bo6UitPkTzzsCxgzjvP87HVX5pvRsVUzKM9ajgMGgfK4P/v1sppq4BQhkiuqL8g==
X-Received: by 2002:a17:90a:a405:: with SMTP id y5mr9474836pjp.102.1574200008280;
        Tue, 19 Nov 2019 13:46:48 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e17sm28317575pgt.89.2019.11.19.13.46.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:46:47 -0800 (PST)
Subject: [PATCH v14 5/6] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 19 Nov 2019 13:46:46 -0800
Message-ID: <20191119214646.24996.20325.stgit@localhost.localdomain>
In-Reply-To: <20191119214454.24996.66289.stgit@localhost.localdomain>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Currently the page poisoning setting wasn't being enabled unless free page
hinting was enabled. However we will need the page poisoning tracking logic
as well for unused page reporting. As such pull it out and make it a
separate bit of config in the probe function.

In addition we need to add support for the more recent init_on_free feature
which expects a behavior similar to page poisoning in that we expect the
page to be pre-zeroed.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/virtio_balloon.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 226fbb995fb0..92099298bc16 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -842,7 +842,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -909,11 +908,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
 						  VIRTIO_BALLOON_CMD_ID_STOP);
 		spin_lock_init(&vb->free_page_list_lock);
 		INIT_LIST_HEAD(&vb->free_page_list);
-		if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+	}
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+		/* Start with poison val of 0 representing general init */
+		__u32 poison_val = 0;
+
+		/*
+		 * Let the hypervisor know that we are expecting a
+		 * specific value to be written back in unused pages.
+		 */
+		if (!want_init_on_free())
 			memset(&poison_val, PAGE_POISON, sizeof(poison_val));
-			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
-				      poison_val, &poison_val);
-		}
+
+		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
+			      poison_val, &poison_val);
 	}
 	/*
 	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
@@ -1014,7 +1022,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

