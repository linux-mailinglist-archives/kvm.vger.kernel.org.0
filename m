Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45866A4D70
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjB0Vlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjB0Vle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:41:34 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A21ABEB
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 13:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677534093; x=1709070093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5wnJ1Z7C8ZgfhrFhylj3bD2ZDIO5SaRzfsMBJ/57TjA=;
  b=IPjiLyZ/M8GBL28SBAD0nu7oC3qwUhjwiWjMX6yw+f0IH4KIW74TVxJ/
   JTorgINdzldEIDIi2rAg01V47mixzZpp30B3NlQss9As2lHlYsyi3MkhP
   VKAMT/ozUx531CqlVjNcUDvNoPbxH+pu2GC9mzsqO5bc6h2h+Ic1cFp+l
   nbrP/ZMJrghxaDn7fhLbaetimrlNj9L7rWPZBhFzlw6COkz5NUtZfyu5E
   QJNCwMwci2Zn70z30fcgHKU3HVkrPsL6Q3rR+r1VqIK8diDAFZz9JDQ6E
   DOAKKQr9Ha67etHi8/0A4QvPupA1sNTo5xxX9hIzPn2L7QBvfa+0JINiF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="331448953"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="331448953"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 13:41:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="667194622"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="667194622"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 13:41:32 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] vhost: use struct_size and size_add to compute flex array sizes
Date:   Mon, 27 Feb 2023 13:41:27 -0800
Message-Id: <20230227214127.3678392-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vhost_get_avail_size and vhost_get_used_size functions compute the size
of structures with flexible array members with an additional 2 bytes if the
VIRTIO_RING_F_EVENT_IDX feature flag is set. Convert these functions to use
struct_size() and size_add() instead of coding the calculation by hand.

This ensures that the calculations will saturate at SIZE_MAX rather than
overflowing.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
---

I found this using a coccinelle patch I developed and submitted at [1].

[1]: https://lore.kernel.org/all/20230227202428.3657443-1-jacob.e.keller@intel.com/

 drivers/vhost/vhost.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f11bdbe4c2c5..43fa626d4e44 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -436,8 +436,7 @@ static size_t vhost_get_avail_size(struct vhost_virtqueue *vq,
 	size_t event __maybe_unused =
 	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
 
-	return sizeof(*vq->avail) +
-	       sizeof(*vq->avail->ring) * num + event;
+	return size_add(struct_size(vq->avail, ring, num), event);
 }
 
 static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
@@ -446,8 +445,7 @@ static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
 	size_t event __maybe_unused =
 	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
 
-	return sizeof(*vq->used) +
-	       sizeof(*vq->used->ring) * num + event;
+	return size_add(struct_size(vq->used, ring, num), event);
 }
 
 static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
-- 
2.39.1.405.gd4c25cc71f83

