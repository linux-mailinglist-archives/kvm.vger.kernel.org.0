Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DBB78CC0E
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 20:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbjH2S2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 14:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbjH2S2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 14:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758D410E
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 11:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693333666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhi2uFlmUXZCsw01PH/d6XQV/U4JpYNvRVMtZqbnhiQ=;
        b=R0c/+hRK2soG4qLxTPIv9DJIrAryXjoRgOoivW+jUvMXolkoVhVjbLmtRAoFPPu27acTwM
        FE8uk7gN/S4TL1FG6I7ZjhO9AfvvQmAuaFSEllod34eUaTiZL14ra3//t97GsJRfE3EDbV
        fwDUiUQ52K8d47IcXOgJn44DUPz+M7Q=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-awnYdX2IOkqEnHT6zEosng-1; Tue, 29 Aug 2023 14:27:44 -0400
X-MC-Unique: awnYdX2IOkqEnHT6zEosng-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0037E2808B29;
        Tue, 29 Aug 2023 18:27:44 +0000 (UTC)
Received: from localhost (unknown [10.39.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 794641678B;
        Tue, 29 Aug 2023 18:27:43 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 3/3] vfio: use __aligned_u64 in struct vfio_device_ioeventfd
Date:   Tue, 29 Aug 2023 14:27:20 -0400
Message-ID: <20230829182720.331083-4-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-1-stefanha@redhat.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 777374dd7725..032e41b56506 100644
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

