Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6C1703247
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 18:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242630AbjEOQHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 12:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242582AbjEOQHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 12:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C022A10EA
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 09:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684166754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTcjmxqtSvVPGQaZ0SXB++FKN48c2ec24jCxFpCBrLs=;
        b=BLhOLTMGGV5192XnkY57yq11OfgyNncO4assEL/TH8Tm3dpopr8JMfF91qfO2Poct9AeJc
        5+79rz8J9dQ5JxPvYnBhNPmy/qUgrgXguK8rRmXtSWwzwATxQzdoZ/dt0qvwbpyj/PvXkq
        cPGgts9GZaC01XQ4mbD12V0SkikdlFQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-QRnZstKdPvKDqMrWGTrxOw-1; Mon, 15 May 2023 12:05:50 -0400
X-MC-Unique: QRnZstKdPvKDqMrWGTrxOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC0D32812944;
        Mon, 15 May 2023 16:05:48 +0000 (UTC)
Received: from localhost (unknown [10.39.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28B2BC15BA0;
        Mon, 15 May 2023 16:05:47 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>
Subject: [PULL v2 16/16] docs/zoned-storage:add zoned emulation use case
Date:   Mon, 15 May 2023 12:05:06 -0400
Message-Id: <20230515160506.1776883-17-stefanha@redhat.com>
In-Reply-To: <20230515160506.1776883-1-stefanha@redhat.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Add the documentation about the example of using virtio-blk driver
to pass the zoned block devices through to the guest.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Message-id: 20230508051916.178322-5-faithilikerun@gmail.com
[Fix pre-formatted code syntax
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/devel/zoned-storage.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/docs/devel/zoned-storage.rst b/docs/devel/zoned-storage.rst
index da78db2783..30296d3c85 100644
--- a/docs/devel/zoned-storage.rst
+++ b/docs/devel/zoned-storage.rst
@@ -41,3 +41,22 @@ APIs for zoned storage emulation or testing.
 For example, to test zone_report on a null_blk device using qemu-io is::
 
   $ path/to/qemu-io --image-opts -n driver=host_device,filename=/dev/nullb0 -c "zrp offset nr_zones"
+
+To expose the host's zoned block device through virtio-blk, the command line
+can be (includes the -device parameter)::
+
+  -blockdev node-name=drive0,driver=host_device,filename=/dev/nullb0,cache.direct=on \
+  -device virtio-blk-pci,drive=drive0
+
+Or only use the -drive parameter::
+
+  -driver driver=host_device,file=/dev/nullb0,if=virtio,cache.direct=on
+
+Additionally, QEMU has several ways of supporting zoned storage, including:
+(1) Using virtio-scsi: --device scsi-block allows for the passing through of
+SCSI ZBC devices, enabling the attachment of ZBC or ZAC HDDs to QEMU.
+(2) PCI device pass-through: While NVMe ZNS emulation is available for testing
+purposes, it cannot yet pass through a zoned device from the host. To pass on
+the NVMe ZNS device to the guest, use VFIO PCI pass the entire NVMe PCI adapter
+through to the guest. Likewise, an HDD HBA can be passed on to QEMU all HDDs
+attached to the HBA.
-- 
2.40.1

