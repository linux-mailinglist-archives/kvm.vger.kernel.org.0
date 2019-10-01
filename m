Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF52BC390B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbfJAP3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:29:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46010 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfJAP3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:29:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id q7so9868466pgi.12;
        Tue, 01 Oct 2019 08:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=Y+MwPM0PwyoQs6gNC+lR1Q5jB5E8k4nKxYlTqXp7RB0DriL/eunD9PtWjyD13XHLb5
         PSjMcjNm4wTs/EsWyHr508chLopFHQy/Rr5L5sw+D1EHEyhOD05WhTyZPVgFU7LqdZam
         u6S0n5sGijNBUI27TPTXFGxH8GW7E4Ja7mvxvWAk8lcrel2TJJDk/p6EJrGUcpznoz6e
         VvMWNVdO2RINsTcVtYHT5uW+lM53GGdYkU0CD9FNd+OFrLsxIBj2vPmmDGpe98NnwZVh
         Cty1NRgNY1eJSRAZHdmKCezLgdIH74lf77h6TpGH2DJi1KJCQsDPfx0ylqaYeVOL+/1E
         8pSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=N9Z1ngnVRbzmLHfGsisSnry0Ruz5WGpyKi3N3dHVM7idu5HLXiNrTYi5mNL4qrKgkp
         HoE1OGzK5846qEtVsy3Uk4ZziQBfX4l6wRK3xur/W5CDRA0Jz7F35KNY7TndxloLe7XG
         7J50L97LMZ6Db766V6TLhVE/zwWCRsrS2C6kL4Y3qCJWcV0xw0Gr3FQsDU/xxekJdM8Q
         7KBkZKVF54GdLQMpN4lHYvCAVoZkim7sZeDqObph/jb5RWcOs92rGjddT7cgBdeQ2LsX
         SeKa5v3uxd6//zjKkRrA/txu1ePPtK6WduggEwW+dv3wfP5hMZuSVnOaw2HfPwnKzouj
         FNMw==
X-Gm-Message-State: APjAAAUPzgkF5dSGtaPaVOQTf+L3g+DDb/JJzHrDg9LKgoPXnSCqav7w
        F3pi6SfybfSN/wDnv0t4fd0=
X-Google-Smtp-Source: APXvYqwd/kCnyEC2V2itCDr9rRprR6IlLzz9BlpPrfcMUabGpgkedv6UUvLcNR7Y0XMtl684QLFcWw==
X-Received: by 2002:a65:6488:: with SMTP id e8mr2541462pgv.192.1569943789337;
        Tue, 01 Oct 2019 08:29:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id j22sm5658829pgg.16.2019.10.01.08.29.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:29:48 -0700 (PDT)
Subject: [PATCH v11 5/6] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Tue, 01 Oct 2019 08:29:48 -0700
Message-ID: <20191001152947.27008.56645.stgit@localhost.localdomain>
In-Reply-To: <20191001152441.27008.99285.stgit@localhost.localdomain>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
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

