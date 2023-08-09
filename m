Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E99776AAC
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjHIVEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 17:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjHIVEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 17:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297EB1BF7
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 14:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691615024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9pYnh9AZiLo/QufdQ00bPfQxtHLj4posydlYcWhbRmM=;
        b=O+2hFfbCCb1wZeoBpGOv0EzfBn6ayyQdArzS8PuafmqjBRZGgskqM7ja2WTurMLqGIw/PX
        pOxn4G2TcPI50GCFinmkdNcONGZMfwFM+rGX4ldq87yZNGv0m/Vg/0KEoVrFz2P2WM7UHu
        KkBXMbtjUz1fAWaq5wbdjnTawyxIeoY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-vVAOG69QMN2a86L0HEy8cg-1; Wed, 09 Aug 2023 17:03:43 -0400
X-MC-Unique: vVAOG69QMN2a86L0HEy8cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA971380673C;
        Wed,  9 Aug 2023 21:03:41 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20376C15BAE;
        Wed,  9 Aug 2023 21:03:40 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 4/4] vfio: use __aligned_u64 in struct vfio_device_ioeventfd
Date:   Wed,  9 Aug 2023 17:02:48 -0400
Message-ID: <20230809210248.2898981-5-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-1-stefanha@redhat.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
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

The memory layout of struct vfio_device_ioeventfd is
architecture-dependent due to a u64 field and a struct size that is not
a multiple of 8 bytes:
- On x86_64 the struct size is padded to a multiple of 8 bytes.
- On x32 the struct size is only a multiple of 4 bytes, not 8.
- Other architectures may vary.

Use __aligned_u64 to make memory layout consistent. This reduces the
chance of holes that result in an information leak and the chance that
32-bit userspace on a 64-bit kernel breakage.

This patch increases the struct size on x32 but this is safe because of
the struct's argsz field. The kernel may grow the struct as long as it
still supports smaller argsz values from userspace (e.g. applications
compiled against older kernel headers).

The code that uses struct vfio_device_ioeventfd already works correctly
when the struct size grows, so only the struct definition needs to be
changed.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0b5786ec50d8..d61269765bf8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -794,9 +794,10 @@ struct vfio_device_ioeventfd {
 #define VFIO_DEVICE_IOEVENTFD_32	(1 << 2) /* 4-byte write */
 #define VFIO_DEVICE_IOEVENTFD_64	(1 << 3) /* 8-byte write */
 #define VFIO_DEVICE_IOEVENTFD_SIZE_MASK	(0xf)
-	__u64	offset;			/* device fd offset of write */
-	__u64	data;			/* data to be written */
+	__aligned_u64	offset;		/* device fd offset of write */
+	__aligned_u64	data;		/* data to be written */
 	__s32	fd;			/* -1 for de-assignment */
+	__u32	reserved;
 };
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
-- 
2.41.0

