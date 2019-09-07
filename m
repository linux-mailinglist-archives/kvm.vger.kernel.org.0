Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF434AC81D
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436599AbfIGR0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:26:07 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40910 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436572AbfIGR0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:26:06 -0400
Received: by mail-oi1-f195.google.com with SMTP id b80so7545793oii.7;
        Sat, 07 Sep 2019 10:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AHQp5tHq/YPoexLkCIK7ZDm0IJf6l4a1w2EjvR3aV6g=;
        b=ecBEnwAa8jcMm3IeC8TnBic2IinopWGcdT+gykKq8NN/pNR/UsFniW4E6oZ4LvNXJ+
         0ftCG8IxxKLzYezZvy3li5JCrUPcS+E9lHb+WgrXsLFwwchEoydNBBzlWqyG8cynU1L7
         nl8DE1tAfOZ6CdK2q+uf/OirvdrfNAmR8TGHZvB+DC6f/f3HySEmRUqEM/yBc9sJ1z5p
         mM4klXYndf/6IWVBtaTtXYSktQRC54sBy8s2djTgAxvWxzQa3CEI0XqpNho+lPEf9M1n
         /RpDq0HSOomk55lg3gjG5JihpeUBs672XU4jUHcmv+sGTj8Znrr57lBBzvXWiRji5QJZ
         M0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AHQp5tHq/YPoexLkCIK7ZDm0IJf6l4a1w2EjvR3aV6g=;
        b=WA2wRa0S4qFWwYMrp6a0LZcnx7ZnhHB4ocWSxD6zJK+Da5OT5OgfTjQYo81CLl3xLA
         lAWng4lcIOZgAKJDskGIzTeR7QKwmUmhFSiJG4Z8Dd9N4/M253h6PjevV2ISHorqx8Fw
         S9fqH7BaLaAKptaAXO9n65N+aoYCCSlHHoYNDDyQVIu0xLjHv8Is5NHw6KNs1jo9j9jm
         eOC+lj4lTMJCxCZIBkBQQanZQgacM0wWLFSQUe2nz9tuSTIzIBVLfnq+7xJEyMB/wD1n
         +aItCFxD4nReh32qGS1EN16cOCPucL+9QVDUE39cUgUs/Lbvq4GsLOgvgF9lZC9WAsz9
         HB0Q==
X-Gm-Message-State: APjAAAWMyLc1G9XdwLwU6goHBCNciVxJ0s0t5yYoLtlLcBxwArfo3G1L
        HT4fv0HId2aePECp1cFzNpI=
X-Google-Smtp-Source: APXvYqx37YQNiv2UtvALkUbv8/xd5ft3XRlho7zJo2uonh25aEKOd4lYhlhEds/sSnzEvGkPn61A0A==
X-Received: by 2002:aca:fccb:: with SMTP id a194mr1637514oii.52.1567877165507;
        Sat, 07 Sep 2019 10:26:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 19sm3109533oin.36.2019.09.07.10.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:26:05 -0700 (PDT)
Subject: [PATCH v9 7/8] virtio-balloon: Pull page poisoning config out of
 free page hinting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:26:01 -0700
Message-ID: <20190907172601.10910.95355.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
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

