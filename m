Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E1712FE37
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgACVQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:16:48 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39240 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgACVQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:16:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so16507839plp.6;
        Fri, 03 Jan 2020 13:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vHnJ25hiopScSvzKvTkXEmD6+64R/VseLeElW32hnVg=;
        b=t53IHZGmEgX9YjlcOJRzkA5sC8hxtOfQ5r4K36DaKIdwKRpWrlw6xUA7KtJ/N+4WFA
         1GmTnundDTnYX3kQFavCI+lXTHXJQNqnDQryR3yBwggyPWfFPC4znSePcUJqWWTnol01
         vT2fReiplgNwlQlOnhcYv/aXuKwLRgb3I9sTLDICYPK+CRHX2sF08brQgVoj/kr4W2Wf
         o11TPQXsyenK9r1FVFNfWyp4BdegxclJvRLDQftbuULIlLf0/hvFuP4SRAjpZWhUgppR
         pdEfp89FHjsTHFqEByWNb8FWauxbQxU7ImzKWKl2eiafLtGij0zcZn++HDGLoSX0ML1s
         +gtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vHnJ25hiopScSvzKvTkXEmD6+64R/VseLeElW32hnVg=;
        b=EALHdlk4oIjPVpdb7Co2yFFVD5eHRE1H2Ak8StsaewMnTbU+Q1SyH/chfDaJ+wH7es
         Y5qWqWJq/xgfIdhllgE84A+3NWdqmPSqmCEZEFJYFxvlB5206bMsJHyoUZOAYoIYS0XO
         j3OTjMmJCn0geqLTruULyx2PLtgKI/SnKe+p5Rx3/WOUr+Ev39paCRBKgvdp0agc0hec
         Aup2mrCkfbYd5gyVHloOeNgQplmi+TzhJx0dvZ0Jt7NwM5PvMe59ZYAUNMWJJK/3/1dn
         0cMkGRcHyTOllz05Bzd0O6roFhkveDZuJDyVQnGzmLhHIosx0wZLXIqvKplAlC+40UqN
         bIFg==
X-Gm-Message-State: APjAAAXQkwylvgDNHbFJHq65gzeR1Lq2WEC+ZNYYErRM1lx5+fxBdIth
        Mgrr0fNJALcFkQ9HyDm7Nwg=
X-Google-Smtp-Source: APXvYqyIwhMfT8gkotRykocjUamFEQI2CeeGZ0bUEVUCIYEWsu9cdQy9mvbieF3fJE3VCTrs32qtlQ==
X-Received: by 2002:a17:90a:d34c:: with SMTP id i12mr29093260pjx.18.1578086206769;
        Fri, 03 Jan 2020 13:16:46 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id a17sm16449218pjv.6.2020.01.03.13.16.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:16:46 -0800 (PST)
Subject: [PATCH v16 5/9] virtio-balloon: Pull page poisoning config out of
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
Date:   Fri, 03 Jan 2020 13:16:45 -0800
Message-ID: <20200103211645.29237.24462.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
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
as well for free page reporting. As such pull it out and make it a separate
bit of config in the probe function.

In addition we need to add support for the more recent init_on_free feature
which expects a behavior similar to page poisoning in that we expect the
page to be pre-zeroed.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/virtio_balloon.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 93f995f6cf36..04a1e4b8e11d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -860,7 +860,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -927,11 +926,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
+		 * specific value to be written back in balloon pages.
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
@@ -1032,7 +1040,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

