Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3A78CC11
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 20:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbjH2S2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 14:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbjH2S2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 14:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4C6110
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 11:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693333667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pwehxhOym2b97cUzNHHP/AdY/GNWxdUPfReXsBParb4=;
        b=TduY/UHcTkdfc2nm9pNGdq43Se0dpsQ0mLyQQIE39YaNPbiFOKcdjWdYQU+h3nMiXwzTOV
        FXlafrWk4hNiE6BYUNNl7fCJTI19ka8d5ktz0UvEy+dz38e6bR8cUZSK/Y9xDAklcpC5ZN
        QDSkqj/jXHjQi+oRJx4m7/XI8jBb9UY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-686-7Tl68PKKP52A0cEdy-NXtQ-1; Tue, 29 Aug 2023 14:27:43 -0400
X-MC-Unique: 7Tl68PKKP52A0cEdy-NXtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EBDE823D60;
        Tue, 29 Aug 2023 18:27:42 +0000 (UTC)
Received: from localhost (unknown [10.39.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4793C15BAE;
        Tue, 29 Aug 2023 18:27:41 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 2/3] vfio: use __aligned_u64 in struct vfio_device_gfx_plane_info
Date:   Tue, 29 Aug 2023 14:27:19 -0400
Message-ID: <20230829182720.331083-3-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-1-stefanha@redhat.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h        | 3 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c | 4 +++-
 samples/vfio-mdev/mbochs.c       | 6 ++++--
 samples/vfio-mdev/mdpy.c         | 4 +++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 94007ca348ed..777374dd7725 100644
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
index 9cd9e9da60dd..813cfef23453 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1382,7 +1382,7 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
 		intel_gvt_reset_vgpu(vgpu);
 		return 0;
 	} else if (cmd == VFIO_DEVICE_QUERY_GFX_PLANE) {
-		struct vfio_device_gfx_plane_info dmabuf;
+		struct vfio_device_gfx_plane_info dmabuf = {};
 		int ret = 0;
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
@@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
 		if (dmabuf.argsz < minsz)
 			return -EINVAL;
 
+		minsz = min(dmabuf.argsz, sizeof(dmabuf));
+
 		ret = intel_vgpu_query_plane(vgpu, &dmabuf);
 		if (ret != 0)
 			return ret;
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 3764d1911b51..78aa977ae597 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1262,7 +1262,7 @@ static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
 
 	case VFIO_DEVICE_QUERY_GFX_PLANE:
 	{
-		struct vfio_device_gfx_plane_info plane;
+		struct vfio_device_gfx_plane_info plane = {};
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
 				    region_index);
@@ -1273,11 +1273,13 @@ static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
+		outsz = min_t(unsigned long, plane.argsz, sizeof(plane));
+
 		ret = mbochs_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
-		if (copy_to_user((void __user *)arg, &plane, minsz))
+		if (copy_to_user((void __user *)arg, &plane, outsz))
 			return -EFAULT;
 
 		return 0;
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 064e1c0a7aa8..f5c2effc1cec 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -591,7 +591,7 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 
 	case VFIO_DEVICE_QUERY_GFX_PLANE:
 	{
-		struct vfio_device_gfx_plane_info plane;
+		struct vfio_device_gfx_plane_info plane = {};
 
 		minsz = offsetofend(struct vfio_device_gfx_plane_info,
 				    region_index);
@@ -602,6 +602,8 @@ static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
+		minsz = min_t(unsigned long, plane.argsz, sizeof(plane));
+
 		ret = mdpy_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
-- 
2.41.0

