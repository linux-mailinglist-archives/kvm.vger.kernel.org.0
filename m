Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680A8F08EC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387515AbfKEWCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:02:35 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40886 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbfKEWCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:02:34 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so17011400pfl.7;
        Tue, 05 Nov 2019 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=ZcjJyrfbHpGdSzw0fMcVtY6dAGJVjVQ64InSz8eLMKB6ovogAqXpONXi4Eee3gXE8b
         jmKVDunGxHJM+IlV4O7dKGQs3izhRuZx5JZ+/E9Wpc62AGlPJZPXozkIXYqPiYozzY1l
         TFav01mtDjNsSgor58gdVLE00KHtxPpNvRmm0x/Db9h7ahXguFLETHdH7NQrFFtgw8aI
         xXDXyxakiXQkzvcEw8Bnav3q7Us9F+OGmShwtFPINHjYTJ4qudcgzkdrQGfpq3LburAU
         JW0tBSL/6GJcU04yyFv0cOCfUi07kZgMJ34YcPZhyEl5K9yfYEVeJbFhEwqmpAgLr6v0
         PnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=gUMnArpVjly7oG/UHT3oSnh5t3gRbHZz74jDRYaaToYRf5Ee7BdXua7XCY1xkLgMIQ
         rqjWBHVKNk4X0C/U+JC9RUVb7nCqzD1e5YPFc0q/Jrbk10TjLvqgZuy1fGfmCTz/H6fJ
         xgxRzXJdewH3vtqha6u5YgL/IgGhwyLCcT9xgKu+adKDIFs/DrVuGhB3IP1SH9pNdn0s
         YptxKJErwGdG0djzUocou/hbp+QSirhVMxaPm/4OILBMOORoC/uhQKKVtbQQResE14cB
         EduXQiMzdZX74aGEKvskJdizEC8+AR21pq7cZCF3ifRsXBqU6JH8PO6YTI6RW4M3cumD
         gPvg==
X-Gm-Message-State: APjAAAWlmzQPYbmY9noCgdeIrnTbcDfEfp1PAkWbH5CWy8nhxudMhYP1
        8n6cjDEagREu80LlXTVcSvo=
X-Google-Smtp-Source: APXvYqwHXu65OWELUssr4NHAfxdsjZ+PbrdYq4vR6BtT+cUd1rHcRikPmpfN1UNwOebs3arOU9r/ZA==
X-Received: by 2002:a62:2b55:: with SMTP id r82mr39206559pfr.56.1572991353063;
        Tue, 05 Nov 2019 14:02:33 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r5sm16691859pfh.179.2019.11.05.14.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:02:32 -0800 (PST)
Subject: [PATCH v13 5/6] virtio-balloon: Pull page poisoning config out of
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
Date:   Tue, 05 Nov 2019 14:02:32 -0800
Message-ID: <20191105220232.15144.81991.stgit@localhost.localdomain>
In-Reply-To: <20191105215940.15144.65968.stgit@localhost.localdomain>
References: <20191105215940.15144.65968.stgit@localhost.localdomain>
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

