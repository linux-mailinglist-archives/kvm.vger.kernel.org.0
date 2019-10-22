Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE13AE0E31
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389048AbfJVW22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:28:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44823 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732831AbfJVW22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:28:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id q15so9018675pll.11;
        Tue, 22 Oct 2019 15:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=bKmBMz41cTRdKc/INg53FasCyx40afrLNllqO8vkbkqN4RLZ+1fzwiA31cNrkqwAuf
         rua+dD+20SHGPPDjvYSNzdkVP/Me7v6NpuQtp2VLUQxBAAFEdTQUi7HMagbpyODe8Dov
         zqq/SXgtqx2/9mbH/sgUUo8MD1icuXa+2qmn2EETyIckOmOhDl2+chToia1aAqL+SNUB
         rV5DHJofo55eWgrjaREKmQ6hl7CG64o+ELDEMSC2BWlPiKhugOmwTpr1zR17ZLsCxnqo
         VkbM/UiEaY6t0A8pkYNS4I48f7ZbQwWsL8DPBoky0hAzYz7+mTZ49gFqydOENHN+y/xV
         Xkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ywjGGrMf/PJ6pRbEzUf6NoarQ8dqbT7Q7Zl+POuvcuU=;
        b=IBY522VHfPLfMXrO9yQazOMSu4HmMp8JM+2bzjyCPukpjUgAYk+NI0mWHChBDk98fk
         SxbFLvAM7AuAEJkQAovEvXirZ8wR1m9PnKrOjDvNqKCZTJZzEG6HZD70uW5Xnw1s2rga
         wX/TS0p/VsqTKRYal+1wcPwP3iXSB0cjcUqtU3EZP+237kUauDIuwDtcWbdsxEIWoLeB
         6Sf4aKPLww9Bnp1BqVSvkpJd+8h70XiGSaK72yH6au43ZS1vzWj1ZdQbYTN22aAaeZ6b
         2UVcCZ5zje3QN/phRmjL1DP9uf7JzWTzDhS0hVnSeztfGjz6HrAiDvUz/uKLF8kF7o36
         ZMCw==
X-Gm-Message-State: APjAAAXDRNMjxYzTuDFSgNctf1OCy6Gn+BkQQMj34NYBsD8Pae9fSMzn
        eGd9Lf9LvfunaWNAQMQMJzw=
X-Google-Smtp-Source: APXvYqxICsjUwSw825/WInQLWh8pygA3SctYEMbRRAvYTrpcoC4majybbgDYBar+oSN4A3Cds75XjQ==
X-Received: by 2002:a17:902:bf43:: with SMTP id u3mr275420pls.339.1571783306835;
        Tue, 22 Oct 2019 15:28:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id m34sm18502040pgb.91.2019.10.22.15.28.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:28:26 -0700 (PDT)
Subject: [PATCH v12 5/6] virtio-balloon: Pull page poisoning config out of
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
Date:   Tue, 22 Oct 2019 15:28:25 -0700
Message-ID: <20191022222825.17338.31295.stgit@localhost.localdomain>
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
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

