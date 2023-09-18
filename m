Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921F27A5496
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 22:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjIRU5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 16:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjIRU50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 16:57:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA43B12A
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695070592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLsvJ8l6b+MBG1WK2YqkwTaPRwUV38lxkQNhQoUhHr4=;
        b=E19Fx/avvbvCqdn2/JGbe7KJ8j8mJ0OAtWY3sHEUCv/xqTdG+50+FQBKGiZkLHTAeo2cJc
        vgMXsEC0TuiuEP3xRIoIph3gsICIALWlo2gOluErIkDc6umCm9MIqR8RcuT5S19YmDGs3G
        Y7HzgGeYWN2nsIenMXz+gVA9AbuX3tY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-udjHwg-TN4W0iNphIn-i9w-1; Mon, 18 Sep 2023 16:56:27 -0400
X-MC-Unique: udjHwg-TN4W0iNphIn-i9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8338A3C11A00;
        Mon, 18 Sep 2023 20:56:26 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02F621C5BB;
        Mon, 18 Sep 2023 20:56:24 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 3/3] vfio: use __aligned_u64 in struct vfio_device_ioeventfd
Date:   Mon, 18 Sep 2023 16:56:17 -0400
Message-ID: <20230918205617.1478722-4-stefanha@redhat.com>
In-Reply-To: <20230918205617.1478722-1-stefanha@redhat.com>
References: <20230918205617.1478722-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
chance that 32-bit userspace on a 64-bit kernel breakage.

This patch increases the struct size on x32 but this is safe because of
the struct's argsz field. The kernel may grow the struct as long as it
still supports smaller argsz values from userspace (e.g. applications
compiled against older kernel headers).

The code that uses struct vfio_device_ioeventfd already works correctly
when the struct size grows, so only the struct definition needs to be
changed.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ee98b6d4a112..049ce8065a32 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -864,9 +864,10 @@ struct vfio_device_ioeventfd {
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

