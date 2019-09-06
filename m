Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6BABB7A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405669AbfIFOyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:54:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36296 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfIFOyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:54:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so4666024pfr.3;
        Fri, 06 Sep 2019 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AHQp5tHq/YPoexLkCIK7ZDm0IJf6l4a1w2EjvR3aV6g=;
        b=bPPkGTOwMShliBXTYkGU+Y7gS2k5f6GuxSKDdDImp0r+6cm/SGw3Z9il2cozNyQD4A
         rrkMvw01sUNMbTaCgO5v7bidEsODr7WobPfVj2CFPf+LowvEF739obAgFrhzani+HO0Z
         oUqRc/ypQrZW5Lxjrh3ZWHvNqSYVUwnVnAosL50TJ8FPneWm2NcmF7TMO8Anh0nFWxKX
         lBT8bPCfp4GIbfcPizDQzQcJScX2zMMK5yCNv4i4+ziVXOSB84HVTPXfrk0ErxLhZ/jA
         xYTRQFQXm2n7IADPk928Uk39UhO6FsNvDgDiZglUYhH+fRDAoZyHgmBZjyeECQNZD7At
         CMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AHQp5tHq/YPoexLkCIK7ZDm0IJf6l4a1w2EjvR3aV6g=;
        b=pifjEg+MM0O5RvDfEK/2jyIn2+M32DnR4lrQJzADU3IVxKiPTrESD17umtLseEEqdk
         zeWpPfn37UJFV2o9683Wvs3W9B4dpuTkU6Xp9qunSMfSz/VZ8AXBnsJKiW971K4UlNSi
         ibqj+91Kyg8zjRfbjSmCX3x7cbJzBW8l/dimxxmx0epBZcnqUGqTM5oOuCHoHmpMGypb
         Qvt2DMDbgbz9pkXZ+CaAaMOLgmHiF6wkrB27MzFmD3l7t4iSWir6h16UKYTW49yj7nKK
         lYSmvo5pThe24/KuOE7Ez564doVvxr/+SvTtW2lmQOoBlB98gYG5voJvMexASGsKutmm
         NBAw==
X-Gm-Message-State: APjAAAUf+oZPTzI5fD5TsZJ7Tdj3RV/OQzHPWKFmvF10ejCNT7ZccOre
        O+vR+ECYpN0gzVkLm3Y54t8=
X-Google-Smtp-Source: APXvYqyR88QaZW39OsZnSfUJNlZNz+FucCLSQWJ+wyogMMJFeT5wM5gYNUWyTeVyXc2YZ1Dse/fCOQ==
X-Received: by 2002:a62:2603:: with SMTP id m3mr11436590pfm.163.1567781640326;
        Fri, 06 Sep 2019 07:54:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z4sm5219331pgp.80.2019.09.06.07.53.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:53:59 -0700 (PDT)
Subject: [PATCH v8 6/7] virtio-balloon: Pull page poisoning config out of
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
Date:   Fri, 06 Sep 2019 07:53:58 -0700
Message-ID: <20190906145358.32552.1155.stgit@localhost.localdomain>
In-Reply-To: <20190906145213.32552.30160.stgit@localhost.localdomain>
References: <20190906145213.32552.30160.stgit@localhost.localdomain>
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
 drivers/virtio/virtio_balloon.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 226fbb995fb0..d2547df7de93 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -842,7 +842,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -909,11 +908,18 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
+		__u32 poison_val;
+
+		/*
+		 * Let hypervisor know that we are expecting a specific
+		 * value to be written back in unused pages.
+		 */
+		memset(&poison_val, PAGE_POISON, sizeof(poison_val));
+
+		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
+			      poison_val, &poison_val);
 	}
 	/*
 	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
@@ -1014,7 +1020,9 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Notify host if we care about poison value */
+	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	    !page_poisoning_enabled())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

