Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010FC1144B6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfLEQWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 11:22:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40194 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbfLEQWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 11:22:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id a137so3806877qkc.7;
        Thu, 05 Dec 2019 08:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cIarFzQcMyJw/7KWJfpJ/QIbaZPaRS1aw472xHqzr6c=;
        b=X/tyVSPTBcypDAVdP2FzfeTs11F32VK2gfbvmJDSRmZAiHcFzrjTbRcVFlTZWy51sf
         lAkny7DkCya5zNJFVE3Hf0ncjYrjGUomebRr4pTPRfo+xwGK2kK7FRhIWiElu9MQf8zt
         R/ltj8gAVRhRFkD/geHEgZH5Ub6DcDr/WpDLDPNXnpfZ1BPrFBjRuZs4X+hL4I4zrbaH
         FVrngPRVPrm4qmcbwApw7qHgHaeI8fjxtAK4m3vesi4IzzImvKMF2zAfBvcuEI5rhQAP
         6V7ieqRv66928hJNLQjLnbsWVnvb4NPdtmZbc7+AJ4ZZR00Z0tR+OIFrqc3PVSTPyDIV
         3H0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cIarFzQcMyJw/7KWJfpJ/QIbaZPaRS1aw472xHqzr6c=;
        b=FPdXQvbMQcyJV8K1+ovcrUOtgq2FdIPd2/jVtCrJ7n+hlwqQXEmhy8aUwALBn0W/UI
         XWJKtmYE46DGbgagOAVKxV9LjZyIy1SSKSe0+VbzJStEQo4xouDakT1lOwGqEfewJNgc
         Fw/s+Y4XiLM7McXQrZr+RoMglfVO+fYsJ/4NSq06C9Hs30XMJKEOWIHIdsMxmDwhVPK7
         DDwgI5e6YiJ2divwynwffFllU3OCoJwyu3KmHLu6eqDwHmi5RZP1MyARyDQ+8p46nSpo
         67uvTNQjHFJqBrxZzSth2wUoYPza+AP4oFzNkbemYZtEVTL8ZWwRJVjTpF9rqzuQ2az8
         7B2g==
X-Gm-Message-State: APjAAAWZGkPgzdspV64Fds32JEk7jpgT36caGI+2KeDxD0A/M+H88nlJ
        GV56/EjJwWiAqawwrR89Lro=
X-Google-Smtp-Source: APXvYqyH5JuZqQdwhLUYnTAbM5VtI0q894ZCvsmzmmsW70OLBLQtAw3147EFn4uEB+DTIWk1qD7+iQ==
X-Received: by 2002:a05:620a:13c4:: with SMTP id g4mr9099268qkl.305.1575562970708;
        Thu, 05 Dec 2019 08:22:50 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x8sm5323438qts.82.2019.12.05.08.22.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 08:22:50 -0800 (PST)
Subject: [PATCH v15 5/7] virtio-balloon: Pull page poisoning config out of
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
Date:   Thu, 05 Dec 2019 08:22:47 -0800
Message-ID: <20191205162247.19548.38842.stgit@localhost.localdomain>
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
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

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/virtio_balloon.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 15b7f1d8c334..252591bc7e01 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -849,7 +849,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -916,11 +915,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
@@ -1021,7 +1029,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

