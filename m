Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EC57E5C3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 00:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389784AbfHAWiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 18:38:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38476 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389778AbfHAWiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 18:38:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so34890311pfn.5;
        Thu, 01 Aug 2019 15:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=N1FHoD6ZMNB/7wrUWG2IW6DScPoWU0//Swe9DNcA3ZM=;
        b=XFfZZnwAZZwn1mNo4698+qwwq8EWUR8tD+MEvMVS1YxxOJ+XaCbvSDrhXzU0UpPFXt
         RI/tHQXreDa0C0u5/FRzOf7Ug4Gp+Dfi0A/iJfMkpLXdYHW985Tq1ipt6OfuszPSmJrc
         aMEZqE1BEwMU5oPUjvvBzFEX5vwAXakovlY1Jw7sLoIPPOa3ZYA5Gy2T0TfiutLvftMN
         8pfMqm7nhNgrxb+HGgE41icZettMyX9/2/v5b4NXkh7jXBXDn/TvBwD2TX2cgIEOEkeu
         hGXc/K0dQgRhXWUSlw/lE2KpV4Xfw33Jv1WT5XpLWQsyrWaXreinbBozR89Df1egnto3
         yDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=N1FHoD6ZMNB/7wrUWG2IW6DScPoWU0//Swe9DNcA3ZM=;
        b=gbicQls9gNXzePFloebMQ1rXOomf5L6+P/EuS4KAFTB6htzIBFdLudyBGjsv3XYE30
         PS2nV4IlKRz3+N+tXeTP5O/h2G/F2I7J9EoNpKHOgqezQyw7p9ZPtEuXsi7B6UPlv/1U
         9TGml02Nfrvi20HSUk7QJssZ9YCKuURCXf+x4KWIy+O8r5tMhKS2OWghBzcg4YR4Hvsf
         t6AJPGZRnnxJKrwLsb6VQZkEJmjyeQ/Knme5XRZKBZyvpqo6itrDysMPTSHiJLTCEtKQ
         1skmtSAzVmsg13FhtvTlqBdrW3eM9zJqEMXtqIrifq7dtXcK6beyw0WYDRqvZq+PXuN4
         nJwQ==
X-Gm-Message-State: APjAAAWzHhMpiHhWC9SdVZiGfH0CYpBB0prUR5pDa9Vegsfbc44hQ4Tr
        Jzx1wcLyH7RR3LX22vVj3FpM1Wxr
X-Google-Smtp-Source: APXvYqzw8ShusbndySzoosJElpXX2Y+WlAECKmosIb2kCuPU1zdsy0LGNncMH17fmwy0VtCJ4X3n/w==
X-Received: by 2002:a65:6284:: with SMTP id f4mr64617613pgv.416.1564699104593;
        Thu, 01 Aug 2019 15:38:24 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id a3sm72677006pfc.70.2019.08.01.15.38.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 15:38:24 -0700 (PDT)
Subject: [PATCH v3 5/6] virtio-balloon: Pull page poisoning config out of
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
Date:   Thu, 01 Aug 2019 15:36:14 -0700
Message-ID: <20190801223614.22190.40937.stgit@localhost.localdomain>
In-Reply-To: <20190801222158.22190.96964.stgit@localhost.localdomain>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
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

