Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F01A8959
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbfIDPK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:10:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46215 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbfIDPK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:10:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so5576738pfg.13;
        Wed, 04 Sep 2019 08:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=a9JLCD+N47WGSevm0eqWEulferysYaSEfj9S9aPQvrI=;
        b=nmOaUpH/ykU4cFAsJmoOqXn+UroP/oU86Y8mhkfil2o7LWvAm4WE0YLyvQI4VO1ORy
         h39Bhoa24FWPev3fB+Y+J9XpSXPmZsFuaTbYqjE1CjQHhmjE8LxCMDOUgp5zSEAzAHLK
         0EUHZIekH26htxtTdQzf3mp9Ckgic9Ifh2wHcNj/Q9Dc/MhCLol4b2ScqdHAdOra8Iwe
         rnWFasJ88VUddg9nPuAmviyHibWx5lok1YwI8Zw0PctF6RlrnFbMY9ZHyYfz0ceaXcXY
         ZU2l6frjXjPQmcqRHuSfZP/2iUpxzNV/G0k5Lc+8Khq9oFwn/JL8yzky1bbTqQX1fgdm
         j/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=a9JLCD+N47WGSevm0eqWEulferysYaSEfj9S9aPQvrI=;
        b=JZXK+Ae00cbySASSsyTyPjKF6aXEa9PERc52mW3NRQ90QI/UtQ1wD5y8fXTn2wjGQY
         b1UCo71LTx/AzOzIzWxUsMLN5HYKuKOUsl1TtwHk47Y8MdUaNh9OJmpV694FeZWrIu8W
         fgnXbxJ+1jH4/ZhqBQAWdtsATv29suQxrVWqCK9sEZNKkJyMPU2B58xA/y/o5eQbmW2D
         kzGB38DaaAAZ27OXKTe49yEFvzL135VPMA63lR09+SHqlgx/cwujhrzn7mFjuqwL5zFx
         IDDLaMBkMheAq18U0E7D1RmiHwCuAc2FGFNmVhUeiSccxhF2ZQNuGS1xpBs/LrJkj/pW
         CqCg==
X-Gm-Message-State: APjAAAUcS0cFXY8Smr9AssoJhzCxf8uIW2/ynO9WUCcTwSAwC+QypDwi
        f8wWzTAxOD3zJ4qREfjtF3g=
X-Google-Smtp-Source: APXvYqxGGmqwei0WAtvbXjiPExmCWNY7phXiBmilQm4KstzLL9T4+E0J7nifs514GPv+iy6oVDXasw==
X-Received: by 2002:a63:d210:: with SMTP id a16mr1663388pgg.77.1567609856886;
        Wed, 04 Sep 2019 08:10:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r28sm23072333pfg.62.2019.09.04.08.10.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:10:56 -0700 (PDT)
Subject: [PATCH v7 5/6] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 04 Sep 2019 08:10:55 -0700
Message-ID: <20190904151055.13848.27351.stgit@localhost.localdomain>
In-Reply-To: <20190904150920.13848.32271.stgit@localhost.localdomain>
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
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

In addition we can actually wrap the code in a check for NO_SANITY. If we
don't care what is actually in the page we can just default to 0 and leave
it there.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/virtio_balloon.c |   19 +++++++++++++------
 mm/page_reporting.c             |    4 ++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 226fbb995fb0..2c19457ab573 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -842,7 +842,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -909,11 +908,19 @@ static int virtballoon_probe(struct virtio_device *vdev)
 						  VIRTIO_BALLOON_CMD_ID_STOP);
 		spin_lock_init(&vb->free_page_list_lock);
 		INIT_LIST_HEAD(&vb->free_page_list);
-		if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
-			memset(&poison_val, PAGE_POISON, sizeof(poison_val));
-			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
-				      poison_val, &poison_val);
-		}
+	}
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
+		__u32 poison_val = 0;
+
+#if !defined(CONFIG_PAGE_POISONING_NO_SANITY)
+		/*
+		 * Let hypervisor know that we are expecting a specific
+		 * value to be written back in unused pages.
+		 */
+		memset(&poison_val, PAGE_POISON, sizeof(poison_val));
+#endif
+		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
+			      poison_val, &poison_val);
 	}
 	/*
 	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 5006b08d5eec..35c0fe4c4471 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -299,6 +299,10 @@ int page_reporting_startup(struct page_reporting_dev_info *phdev)
 	struct zone *zone;
 	int err = 0;
 
+	/* No point in enabling this if it cannot handle any pages */
+	if (!phdev->capacity)
+		return -EINVAL;
+
 	mutex_lock(&page_reporting_mutex);
 
 	/* nothing to do if already in use */

