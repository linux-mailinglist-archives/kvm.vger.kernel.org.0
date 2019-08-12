Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B968A96B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfHLVdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:33:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44276 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfHLVdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:33:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so1345210pfc.11;
        Mon, 12 Aug 2019 14:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=N1FHoD6ZMNB/7wrUWG2IW6DScPoWU0//Swe9DNcA3ZM=;
        b=tcfg65azcnEOcAutLjCvNZczVJUNMSDMM22VOiQH6xAp2XF9FMR39o5JF5QZ+k3fZN
         UsYAExWzvam4SnvfjYbjqR5Os9bPK8cLarFAT2zfnVRIkUZHkoGBPnuemqxkOcZ+uODy
         LMqNJomcnrG8mTyJ5LG1xdc+WTAfaIliYA1eakM2CCpO1/yy4rP74lkJFkmjNFJBQCzV
         mDD77KiPxIz6bW8/WeTWXo+PHg/i0fvAcOqg7HSDkxhW963eneZxINqg7uqCV+GQPpS2
         s2Mo2ErQ1ShcUV1Mg59dGDPgozPyqZqurNkonaPeNTf4sjwmwtRl6vaGtk4wvVbZO2o8
         uk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=N1FHoD6ZMNB/7wrUWG2IW6DScPoWU0//Swe9DNcA3ZM=;
        b=VYbDI//HAI541XokDVAuf5zuXm4I8tTsIiJeb0ne55k15Rbta+2tvmrORddkVpwxTh
         f0O6ftGwGe9nBd1OpoR2V7Km8EfPZjAe4tVZbPrpjcMwYN9PEPsNjxAcCb4tm7LedvuR
         rmgb7WCYUnTM9Xg8Ki3j+i82nd0tTVTX+TnEdBu9cbt1+mm6+YiW2mNBi/MJe/yldIaF
         0XsZv19EVDS8bpieVULsRJRfm0UZH5ccIOZsJph4cAT4A3k+3m+qAf8nI+j6GKJnFIqO
         feFxuncm5BK81PYFAtPYyGcFwSM9VgldeIJ9R83gJxTjKO0tVVmS9frRkvNIkZToudFZ
         QmDA==
X-Gm-Message-State: APjAAAVisolBS5BD25a0io/7rsPJyNpDb6VvYE6rW7RTkV3tA8wxlaAb
        2u1DUGPzIMZhCjhzOqvw35Q=
X-Google-Smtp-Source: APXvYqy1oXUYIem6XzmDVe884Ah62EAzXq+JkK2Hx/bJix7QTYC22HN51FBb8N05a72ad6sHl3Ne+g==
X-Received: by 2002:a17:90a:bb01:: with SMTP id u1mr1186109pjr.92.1565645631259;
        Mon, 12 Aug 2019 14:33:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 185sm116118013pfa.170.2019.08.12.14.33.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:33:50 -0700 (PDT)
Subject: [PATCH v5 5/6] virtio-balloon: Pull page poisoning config out of
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
Date:   Mon, 12 Aug 2019 14:33:50 -0700
Message-ID: <20190812213350.22097.3322.stgit@localhost.localdomain>
In-Reply-To: <20190812213158.22097.30576.stgit@localhost.localdomain>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
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
 1 file changed, 13 insertions(+), 6 deletions(-)

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

