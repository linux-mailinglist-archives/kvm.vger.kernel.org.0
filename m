Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F314D159C7E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgBKWqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:46:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44294 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbgBKWqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:46:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so14557877wrx.11;
        Tue, 11 Feb 2020 14:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fX2vIOR1jwQ3OQ5AzWWpQmc9VHtoWCtjgAnEJ0fhs8c=;
        b=RwymI6ITtquMApO+YinDpcxNP7VBbFm7WEPDVC010pMz407lNC/c5KX+1s7zSRJh4t
         dqaXB5EE4z8HfBg+4hv7SJGV509TyeB9T+KzVsk9dBVzdebV3rHytA+Gc4jUbB7y3VAQ
         msCbtIOP67GnvmP0K5s1/QDrvDIvu3VCPh/UmEipij+qVVxvxw/LATHN+eZum4L4Gcy0
         SOsMlwT+G2EpkeTDwJRC/g3qN5HFNjFPaDxdpkIAZKDm0kUYH6Z+0yHseFMzX0ZKkVr7
         XO6lRoellSAN9ZQ7sy38xzUFOmKKl4D39nVOqvs+U/6eu+Dfae4dO97a2Dg4NA06hTje
         lWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fX2vIOR1jwQ3OQ5AzWWpQmc9VHtoWCtjgAnEJ0fhs8c=;
        b=pmktc6cVEtwWE8hDNq3+MU9z/FPyY15NHSqxHBCu+LdPKgZKjB3Sy0yG+mIvCBNG4/
         vKUI+yPdL2bZi04ry3sd475MmBS8gWrfhdl31sftbeyCdGKFh2bzAsPnjNXDFNM8WTPS
         cDbMwbecVOI4ByvBuvfLlBPG9xprI5GHBV4riUzuU0FPK0eJBDwjuXhz0WVH9Qw9ijIS
         UIn20N2yTQJoGJfIsJMp3CWhomslaBbdUquhM04Q1JRXOlFSg9Zhz0seL3nlGSdwPyaq
         gQ7QUDRyFp7ATMKWCDQ8TBP5x7a+xHv7fnDorWqSd04ReLDvV4MKkoQgEbRVOnKvqs77
         Se9g==
X-Gm-Message-State: APjAAAWITvPdwrCE11MRupK9mN77fiHoNdKW6z/z6dPA9A9j1UaS5GfZ
        LjhYMIdCUAt8oEJRePd9/WI=
X-Google-Smtp-Source: APXvYqyTg3p7MDpQ7yThpeq3f81QFXZv92cPDlZzYpxO1HW5ALCSu0tYc3vtEO7T3KnHxsXgxP6m0g==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr11024664wrt.100.1581461212483;
        Tue, 11 Feb 2020 14:46:52 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x14sm5379650wmj.42.2020.02.11.14.46.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:46:51 -0800 (PST)
Subject: [PATCH v17 5/9] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:46:46 -0800
Message-ID: <20200211224646.29318.695.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
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
index 7bfe365d9372..98d09825f2e2 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -864,7 +864,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -930,11 +929,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
@@ -1045,7 +1053,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

