Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F61145B0E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgAVRnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:43:49 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44563 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAVRnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:43:49 -0500
Received: by mail-pg1-f195.google.com with SMTP id x7so3878165pgl.11;
        Wed, 22 Jan 2020 09:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Pr2kODxaPLGmgprwPHuwhg6EJV5sUEFrp6dpPZx5d4Y=;
        b=r06i+r4+ns1Nij7Jud5k3jkr1Lp149CmBPwI4oIsYLFCQoCX1kG4MEAX8kt+gCFvma
         CqUGqJmbRbWJHsNsbPXZXyz2jwkGHzaHu54BICdVqVJLtUb4lRzAwK8JRy+6uEFYymrU
         3C65ZPxwnLKkqxafYyGJW58Ds+vBCQvPyL7Z5iURgXkjvpbHQyn3ONE+C4y9yhWArAnp
         xIMypBa9iCxQlcnD3Md8nQP7STocS7AN92W4v9CVWloc9O3PPLq4wOktxRq6+62ZVN0K
         E1Tp46wzYbJ3WeFLoaKRYjEEu6gO5skf+e8KtyAYMzSEEzNWgD6nBMoelagtqicutBaA
         MenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Pr2kODxaPLGmgprwPHuwhg6EJV5sUEFrp6dpPZx5d4Y=;
        b=fhnlFvPNBCnr6J2ja6F1XrRGUvip4pOcDaYvGuvuahXDt1OhuF0jS8MZHz6SZYpAg7
         LjCaoHUH50D3EF46Wz6s3XEGKafabzPPJC2g/M1/5Lu0zzigsYFLYwGlRh0l5zxqy73L
         +AXsuxmMw5/fFY8MiNo9XqcuZLN5g6xhpNBSIZZaUCSloMroQJHU6tc+AE4Gm4eWN5e5
         USNO7KfwSxs3z1iCHAbpu6D2QjQd57ih3M+pxGEHHEPD62opoVdbDwBuHh+8Sq+4ZlSB
         +NjwjoBPn5sGGPOcQCFw8jlx3fkyGP6jwLVvsv8DyC28KhrfERuyMvABaLbqye59zh82
         l+Pw==
X-Gm-Message-State: APjAAAU5m/6G+vZBWwAiMA8UKLfZkPI/rHu9uPrBzGySUIy0XJ0MOk4x
        sHyApNdooMLyR8hXGnX0d9Q=
X-Google-Smtp-Source: APXvYqxYXbhngPLmNjtLhK5GlVP+T+ywf3LYDTQ43SC6KO+la+EEwJLN71hNV2azKvrEkqas/pW2ww==
X-Received: by 2002:a63:3483:: with SMTP id b125mr3910339pga.186.1579715028172;
        Wed, 22 Jan 2020 09:43:48 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c184sm47042646pfa.39.2020.01.22.09.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:43:47 -0800 (PST)
Subject: [PATCH v16.1 6/9] virtio-balloon: Add support for providing free
 page reports to host
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
Date:   Wed, 22 Jan 2020 09:43:47 -0800
Message-ID: <20200122174347.6142.92803.stgit@localhost.localdomain>
In-Reply-To: <20200122173040.6142.39116.stgit@localhost.localdomain>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for the page reporting feature provided by virtio-balloon.
Reporting differs from the regular balloon functionality in that is is
much less durable than a standard memory balloon. Instead of creating a
list of pages that cannot be accessed the pages are only inaccessible
while they are being indicated to the virtio interface. Once the
interface has acknowledged them they are placed back into their respective
free lists and are once again accessible by the guest system.

Unlike a standard balloon we don't inflate and deflate the pages. Instead
we perform the reporting, and once the reporting is completed it is
assumed that the page has been dropped from the guest and will be faulted
back in the next time the page is accessed.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/Kconfig              |    1 +
 drivers/virtio/virtio_balloon.c     |   64 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_balloon.h |    1 +
 3 files changed, 66 insertions(+)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 078615cf2afc..4b2dd8259ff5 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -58,6 +58,7 @@ config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
 	select MEMORY_BALLOON
+	select PAGE_REPORTING
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 40bb7693e3de..a07b9e18a292 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/magic.h>
 #include <linux/pseudo_fs.h>
+#include <linux/page_reporting.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -47,6 +48,7 @@ enum virtio_balloon_vq {
 	VIRTIO_BALLOON_VQ_DEFLATE,
 	VIRTIO_BALLOON_VQ_STATS,
 	VIRTIO_BALLOON_VQ_FREE_PAGE,
+	VIRTIO_BALLOON_VQ_REPORTING,
 	VIRTIO_BALLOON_VQ_MAX
 };
 
@@ -114,6 +116,10 @@ struct virtio_balloon {
 
 	/* To register a shrinker to shrink memory upon memory pressure */
 	struct shrinker shrinker;
+
+	/* Free page reporting device */
+	struct virtqueue *reporting_vq;
+	struct page_reporting_dev_info pr_dev_info;
 };
 
 static struct virtio_device_id id_table[] = {
@@ -153,6 +159,33 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 }
 
+int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
+				   struct scatterlist *sg, unsigned int nents)
+{
+	struct virtio_balloon *vb =
+		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
+	struct virtqueue *vq = vb->reporting_vq;
+	unsigned int unused, err;
+
+	/* We should always be able to add these buffers to an empty queue. */
+	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT | __GFP_NOWARN);
+
+	/*
+	 * In the extremely unlikely case that something has occurred and we
+	 * are able to trigger an error we will simply display a warning
+	 * and exit without actually processing the pages.
+	 */
+	if (WARN_ON_ONCE(err))
+		return err;
+
+	virtqueue_kick(vq);
+
+	/* When host has read buffer, this completes via balloon_ack */
+	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+
+	return 0;
+}
+
 static void set_page_pfns(struct virtio_balloon *vb,
 			  __virtio32 pfns[], struct page *page)
 {
@@ -479,6 +512,7 @@ static int init_vqs(struct virtio_balloon *vb)
 	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
 	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
@@ -490,6 +524,11 @@ static int init_vqs(struct virtio_balloon *vb)
 		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
 	}
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
+		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
+	}
+
 	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
 					 vqs, callbacks, names, NULL, NULL);
 	if (err)
@@ -522,6 +561,9 @@ static int init_vqs(struct virtio_balloon *vb)
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
+
 	return 0;
 }
 
@@ -952,12 +994,31 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		if (err)
 			goto out_del_balloon_wq;
 	}
+
+	vb->pr_dev_info.report = virtballoon_free_page_report;
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
+		unsigned int capacity;
+
+		capacity = virtqueue_get_vring_size(vb->reporting_vq);
+		if (capacity < PAGE_REPORTING_CAPACITY) {
+			err = -ENOSPC;
+			goto out_unregister_shrinker;
+		}
+
+		err = page_reporting_register(&vb->pr_dev_info);
+		if (err)
+			goto out_unregister_shrinker;
+	}
+
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
 
+out_unregister_shrinker:
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		virtio_balloon_unregister_shrinker(vb);
 out_del_balloon_wq:
 	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
@@ -986,6 +1047,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
 
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		page_reporting_unregister(&vb->pr_dev_info);
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		virtio_balloon_unregister_shrinker(vb);
 	spin_lock_irq(&vb->stop_update_lock);
@@ -1058,6 +1121,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
+	VIRTIO_BALLOON_F_REPORTING,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index a1966cd7b677..19974392d324 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12

