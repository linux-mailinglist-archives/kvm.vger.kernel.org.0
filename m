Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E834145B0C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAVRnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:43:43 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40589 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:43:42 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so3893392pgt.7;
        Wed, 22 Jan 2020 09:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fC8BMEakMR3GReeSfdwhKXM9BaYT1gHFYVPBpmBNfng=;
        b=ZS9t478FcpjQhPXyyPhEXLPJL4jUkaxGHmh3mdPi9pvHbaIkuE84B0LX66N4zdB5qO
         dd0hPnklYTHs3Ohgam48ACFcCfPlBrooSbJlTttkLP/7prQQfv8rE1C6TMbTi78eNr7M
         p+dUbuLUI7+RU4qzo4jl4+1s27hQ0gvUEoZS/I11MkT1akuMWJ79epj+fDBj5H9NJOjt
         Sv8iquZF/bqfGAGm+5X7bCPAQ+pBuH4boAWferhqvZvz4YCJ4aR2Prpszol88VdfQ23H
         PMXuGotwrbR4L/j4K1W6/2lVOVB6hVahqpVmILbGxY+NSeAkKidocsABCXJXUoDgquxa
         jueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fC8BMEakMR3GReeSfdwhKXM9BaYT1gHFYVPBpmBNfng=;
        b=s6Y4Spl7dIOqCL5bnTN1oaGT5DSOkODuX0+GlZlxC42LjroNeZUgfJRGb4+DtQaWBE
         Js31DNt4JKKb539cepIOOfG7hg37Y0rELMaL28187TwataUFqJuVkOiVaGAmHi117lOb
         TVNCk/INSXk0VRuEEgNBljt8mofrJ65KWaVrDXNSV5//R2d1/bdpwv07LifRWdpDPH83
         H7WTra6prVwIRgLKP0NYVFH6TFFEjX/bd2yYBd0xmHs4JroUB6Lg5C4G/8a4hLucYt1y
         h3j15uxuYo53M8QDxjglYAlUR5CLGlPR/ufVirxp84y+CTIMmtXp9vqLyTfllOCCGPj4
         NnSA==
X-Gm-Message-State: APjAAAUB/Re9hW8xfnAhzb00ZVj6vzoDvNXaQGtA8B9GMxcfkxBxkmYk
        x3md12PAF8XqrOyN2VVg5cM=
X-Google-Smtp-Source: APXvYqzKjCEX7ZBjs4hUYDLWzH2kTOno88iLkYoFk9VQTGNAJ92L0ikYKeR8jyL7h09ccoP14A5lSA==
X-Received: by 2002:a62:382:: with SMTP id 124mr3679365pfd.11.1579715022042;
        Wed, 22 Jan 2020 09:43:42 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r13sm3565632pgp.73.2020.01.22.09.43.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:43:41 -0800 (PST)
Subject: [PATCH v16.1 5/9] virtio-balloon: Pull page poisoning config out of
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
Date:   Wed, 22 Jan 2020 09:43:41 -0800
Message-ID: <20200122174341.6142.61622.stgit@localhost.localdomain>
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
index 8e400ece9273..40bb7693e3de 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -862,7 +862,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	__u32 poison_val;
 	int err;
 
 	if (!vdev->config->get) {
@@ -929,11 +928,20 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
@@ -1034,7 +1042,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
-	if (!page_poisoning_enabled())
+	/* Tell the host whether we care about poisoned pages. */
+	if (!want_init_on_free() &&
+	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
+	     !page_poisoning_enabled()))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 
 	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

