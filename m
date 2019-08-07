Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929ED855FD
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 00:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfHGWmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 18:42:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36398 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbfHGWmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 18:42:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so42901474pfl.3;
        Wed, 07 Aug 2019 15:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ee1mc4VxnFFfQeQcZzbu/0JmrNIJIkJCiHbNbTiM9tQ=;
        b=r8JTp1EZK6OewkxZ8F+auXR18QN902AIqN0vePsif429O7Lq1avQFEozAWWPhbBC9B
         Q9LrzH1hVnA8Tuytm9wyTDaPe2zY89WCnOGZ+pmOgCSFL0FfcUlG86M+YIKKRTuLggiL
         6a3p5U1HW3Ics5uUYZHYDvdHKCG8SGNS9YoTjADP6wdCGmzP4vQe8EwOTA78fFKT/Yrm
         IQe3D3oxce6LDsVEss9rrkHamPvBurz9AguWf5yuxH/xJjMpuTsoRGPGsIoVB6ZG5jWU
         gR4O33MmIUVJ/jUHWmGeBwFfXD56gNpy593tW446eui/cfRgMlcJc88tGxIODG0qgKia
         BHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ee1mc4VxnFFfQeQcZzbu/0JmrNIJIkJCiHbNbTiM9tQ=;
        b=GdAeWXPHl4SAuffKMQ6zJDDDnQZguRplgAksUl2NolyOeRZoMYGcET74fICxK1miyM
         cyNf2/MBKvAVuN1RYCAiUaC2Bl/MwBNbKRkClbeszBN9KSLfVfrA9wjGWCxVXBDqxrpX
         ipX0+jPjTjvawdTNXvq9H7lfv2rVU7M9OoGehlUmrZ87CC3da2D9KkzIrvJe+kiwRP6H
         KCS1z9QFsGnKlNaer4X1dogilRfGgjwDpZ0aqATdXa2EqX4J7L9dESb3yHQMDFeh++cX
         GvX10yt8sbofOnY3mBqBpKOcjQIMEHdaHMe+lPG6rWnxLVuB5PMZWA0wxFpE8avo1p9s
         uyZg==
X-Gm-Message-State: APjAAAUHPAg3aWnIsjODYOzBWhCw602X8qU4KXcZBJAdvEfo7QzdxsCn
        Ym0BAhY6dQyuSMuQLrVR3BY=
X-Google-Smtp-Source: APXvYqzDgU1Eu3TfqN8qYWP+6kqzZlo0qvhlv0y+xOqs55iUCb5VENOWMnPojOI+y+v9CnUzrfywew==
X-Received: by 2002:a17:90a:8a17:: with SMTP id w23mr681830pjn.139.1565217734198;
        Wed, 07 Aug 2019 15:42:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id v184sm90677862pfb.82.2019.08.07.15.42.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:42:13 -0700 (PDT)
Subject: [PATCH v4 5/6] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Wed, 07 Aug 2019 15:42:13 -0700
Message-ID: <20190807224213.6891.38062.stgit@localhost.localdomain>
In-Reply-To: <20190807224037.6891.53512.stgit@localhost.localdomain>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
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
 mm/page_reporting.c             |    8 ++++----
 2 files changed, 17 insertions(+), 10 deletions(-)

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
index ae26dd77bce9..68dccfc7d629 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -250,7 +250,7 @@ void __page_reporting_free_stats(struct zone *zone)
 
 void page_reporting_shutdown(struct page_reporting_dev_info *phdev)
 {
-	mutex_lock(page_reporting_mutex);
+	mutex_lock(&page_reporting_mutex);
 
 	if (rcu_access_pointer(ph_dev_info) == phdev) {
 		/* Disable page reporting notification */
@@ -266,7 +266,7 @@ void page_reporting_shutdown(struct page_reporting_dev_info *phdev)
 		phdev->sg = NULL;
 	}
 
-	mutex_unlock(page_reporting_mutex);
+	mutex_unlock(&page_reporting_mutex);
 }
 EXPORT_SYMBOL_GPL(page_reporting_shutdown);
 
@@ -275,7 +275,7 @@ int page_reporting_startup(struct page_reporting_dev_info *phdev)
 	struct zone *zone;
 	int err = 0;
 
-	mutex_lock(page_reporting_mutex);
+	mutex_lock(&page_reporting_mutex);
 
 	/* nothing to do if already in use */
 	if (rcu_access_pointer(ph_dev_info)) {
@@ -305,7 +305,7 @@ int page_reporting_startup(struct page_reporting_dev_info *phdev)
 	/* enable page reporting notification */
 	static_key_slow_inc(&page_reporting_notify_enabled);
 err_out:
-	mutex_unlock(page_reporting_mutex);
+	mutex_unlock(&page_reporting_mutex);
 
 	return err;
 }

