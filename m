Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3B7A5492
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjIRU5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 16:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjIRU5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 16:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265D6111
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695070586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQDD0pkq9/UtADo9UYzkWMKduX2RKacPnCgn9XTsyXU=;
        b=PqKP0v+Oa15AecbqrU6RtYUY9gWn1R4i4jght/vVVbCxqeVniEJ6XWXC3u/uA1V5E0Y7F/
        v6/D9FnO8l1yQ9u2vwT+O1EK64WSSOldl8dQKOk9GTGG8RlocfhkSwm1Fum9hBbvL/djYh
        1tzYfFp9FJPypcj4IsdyUDDh4Q/t/kE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-a0vd4XBkPZaB3qrBnjW9Nw-1; Mon, 18 Sep 2023 16:56:23 -0400
X-MC-Unique: a0vd4XBkPZaB3qrBnjW9Nw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7456E101A585;
        Mon, 18 Sep 2023 20:56:23 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E01D0492B16;
        Mon, 18 Sep 2023 20:56:22 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 2/3] vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
Date:   Mon, 18 Sep 2023 16:56:16 -0400
Message-ID: <20230918205617.1478722-3-stefanha@redhat.com>
In-Reply-To: <20230918205617.1478722-1-stefanha@redhat.com>
References: <20230918205617.1478722-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory layout of struct vfio_device_gfx_plane_info is
architecture-dependent due to a u64 field and a struct size that is not
a multiple of 8 bytes:
- On x86_64 the struct size is padded to a multiple of 8 bytes.
- On x32 the struct size is only a multiple of 4 bytes, not 8.
- Other architectures may vary.

Use __aligned_u64 to make memory layout consistent. This reduces the
chance of 32-bit userspace on a 64-bit kernel breakage.

This patch increases the struct size on x32 but this is safe because of
the struct's argsz field. The kernel may grow the struct as long as it
still supports smaller argsz values from userspace (e.g. applications
compiled against older kernel headers).

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h        | 3 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 samples/vfio-mdev/mbochs.c       | 2 +-
 samples/vfio-mdev/mdpy.c         | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4dc0182c6bcb..ee98b6d4a112 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -816,7 +816,7 @@ struct vfio_device_gfx_plane_info {
 	__u32 drm_plane_type;	/* type of plane: DRM_PLANE_TYPE_* */
 	/* out */
 	__u32 drm_format;	/* drm format of plane */
-	__u64 drm_format_mod;   /* tiled mode */
+	__aligned_u64 drm_format_mod;   /* tiled mode */
 	__u32 width;	/* width of plane */
 	__u32 height;	/* height of plane */
 	__u32 stride;	/* stride of plane */
@@ -829,6 +829,7 @@ struct vfio_device_gfx_plane_info {
 		__u32 region_index;	/* region index */
 		__u32 dmabuf_id;	/* dma-buf id */
 	};
+	__u32 reserved;
 };
 
 #define VFIO_DEVICE_QUERY_GFX_PLANE _IO(VFIO_TYPE, VFIO_BASE + 14)
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 42ce20e72db7..faf21be724c3 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1379,7 +1379,7 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
 		intel_gvt_reset_vgpu(vgpu);
 		return 0;
 	} else if (cmd == VFIO_DEVICE_QUERY_GFX_PLANE) {
-		struct vfio_device_gfx_plane_info dmabuf;
+		struct vfio_device_gfx_plane_info dmabuf = {};
 		int ret = 0;
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 3764d1911b51..93405264ff23 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1262,7 +1262,7 @@ static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
 
 	case VFIO_DEVICE_QUERY_GFX_PLANE:
 	{
-		struct vfio_device_gfx_plane_info plane;
+		struct vfio_device_gfx_plane_info plane = {};
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
 				    region_index);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 064e1c0a7aa8..72ea5832c927 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -591,7 +591,7 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 
 	case VFIO_DEVICE_QUERY_GFX_PLANE:
 	{
-		struct vfio_device_gfx_plane_info plane;
+		struct vfio_device_gfx_plane_info plane = {};
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
 				    region_index);
-- 
2.41.0

