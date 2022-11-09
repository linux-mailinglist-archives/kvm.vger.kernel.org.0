Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7365F622F44
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 16:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiKIPnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 10:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKIPnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 10:43:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7A011C00
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 07:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668008539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uBVk1nqDlUO1v7VnKX9niZ4LQDEatQ7W082F8JoznKQ=;
        b=Qk1YM57xTbs9SXSHfW0xPEtOtcVF9iIebLHMmxMoFi18tsdqjScq6JeBvIu+0bUdWmYAzA
        bDl6C0YJ2K59ZyzC2IK0PD6wXwh+l/lRx5tC3IX6vGdAxPqNoV2qDBXXcwi/sLWzQywjrR
        VwnuvAuHj50NfabMWeZ47GKThi604kg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-56-EJz1gP-vPbeCAYxdKIxphA-1; Wed, 09 Nov 2022 10:42:17 -0500
X-MC-Unique: EJz1gP-vPbeCAYxdKIxphA-1
Received: by mail-wm1-f72.google.com with SMTP id l1-20020a7bc341000000b003bfe1273d6cso736106wmj.4
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 07:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBVk1nqDlUO1v7VnKX9niZ4LQDEatQ7W082F8JoznKQ=;
        b=JDCMiei6UvMKlSU5DfQFdfaZBoCcg8lYoq3M8rEnBBYEqzplxXqEqO2ytz+J0pEufh
         Cm1DhD34IAqQ+CxcjI8/qhKlNfsQHnX9+9ZkqaHfa5Lf7QMWLzHKKGMQvbroDcchHG1K
         JSjAiw7tV9wtcnuAjYalWxBcAEbDmhRMCBjDvIQdCS3gIbwi96KOoatIBZ3/JKLcWC/9
         1ftvKt9wrcfcseQCsLdqn0+YHaIsu/KnXK6O+JSLp2gX9+BRordWQLRMsGaFQ5CD2miB
         ZXYBYidoNkmJnVtdtWP6gL3OrGSsxyfbLb90UuQ2d6ev9IsaIKmNeQjJw0oCgwg5lvh0
         EylA==
X-Gm-Message-State: ACrzQf0/un8FCySif/mbQYzmgobnXeXyuIXaKM9vO8JrL+p8aMPDHHTl
        tryWR5bTiPmFw1xQm957QLXEaAG63bcN2Mx2U27Gb/Dq5PEdZp4CQTyEXGePB+mv8nggMFgzUn9
        ae8nWcdkiNYsI
X-Received: by 2002:a5d:4acc:0:b0:236:6665:b471 with SMTP id y12-20020a5d4acc000000b002366665b471mr40056298wrs.633.1668008535788;
        Wed, 09 Nov 2022 07:42:15 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6Nup3xHjcr5VxzgJQLxU3Z8kDbx4kIJ2rHrJiE2B1Op4/F3Uk6ha1/jqX1LnJByU9gSr8umQ==
X-Received: by 2002:a5d:4acc:0:b0:236:6665:b471 with SMTP id y12-20020a5d4acc000000b002366665b471mr40056289wrs.633.1668008535575;
        Wed, 09 Nov 2022 07:42:15 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id i18-20020adfe492000000b002345cb2723esm13696712wrm.17.2022.11.09.07.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:42:14 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: fix potential memory leak during the release
Date:   Wed,  9 Nov 2022 16:42:13 +0100
Message-Id: <20221109154213.146789-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
we call vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during the
release to free all the resources allocated when processing user IOTLB
messages through vhost_vdpa_process_iotlb_update().
That commit changed the handling of IOTLB a bit, and we accidentally
removed some code called during the release.

We partially fixed with commit 037d4305569a ("vhost-vdpa: call
vhost_vdpa_cleanup during the release") but a potential memory leak is
still there as showed by kmemleak if the application does not send
VHOST_IOTLB_INVALIDATE or crashes:

  unreferenced object 0xffff888007fbaa30 (size 16):
    comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
    hex dump (first 16 bytes):
      40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
    backtrace:
      [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
      [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
      [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
      [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
      [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
      [<00000000a2850200>] ksys_write+0x71/0xf0
      [<00000000de8e720b>] __x64_sys_write+0x19/0x20
      [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
      [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Let's fix calling vhost_vdpa_iotlb_unmap() on the whole range in
vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
on the whole range removes all the entries.

The kmemleak log reported was observed with a vDPA device that has `use_va`
set to true (e.g. VDUSE). This patch has been tested with both types of
devices.

Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..b08e07fc7d1f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -65,6 +65,10 @@ static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
+				   struct vhost_iotlb *iotlb,
+				   u64 start, u64 last);
+
 static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
 {
 	struct vhost_vdpa_as *as = container_of(iotlb, struct
@@ -135,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 		return -EINVAL;
 
 	hlist_del(&as->hash_link);
-	vhost_iotlb_reset(&as->iotlb);
+	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
 	kfree(as);
 
 	return 0;
@@ -1162,14 +1166,14 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 	struct vhost_vdpa_as *as;
 	u32 asid;
 
-	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
-
 	for (asid = 0; asid < v->vdpa->nas; asid++) {
 		as = asid_to_as(v, asid);
 		if (as)
 			vhost_vdpa_remove_as(v, asid);
 	}
+
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
-- 
2.38.1

