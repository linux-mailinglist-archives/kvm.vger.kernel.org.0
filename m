Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55C06F182E
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345939AbjD1MlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346073AbjD1MlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF41268E
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Or9qr1HLWkScxj5wpH0XQKCXfRV2RkdYmJOkEJYXowI=;
        b=gBP6PfcFv0sf6hymHJkQ6FxD45WKlTwrnm+FRjt++hkIUNaBrXZa8JljAMp9GbO3ym09Ww
        PAN75ENUBtGBLDP0sEeWTt0h9TmKB/mgLRCZGplEIKE58tje+t1Qvslo6N/6CLojZb22f1
        vu+CD1O2fCL92OT1sMOwdNOIbqfUTUQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-t754b5QUMd-jew8RkTwIrA-1; Fri, 28 Apr 2023 08:40:16 -0400
X-MC-Unique: t754b5QUMd-jew8RkTwIrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FF32887406;
        Fri, 28 Apr 2023 12:40:15 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0714E35443;
        Fri, 28 Apr 2023 12:40:14 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Julia Suvorova <jusual@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        qemu-block@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Sam Li <faithilikerun@gmail.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PULL 07/17] block: add some trace events for new block layer APIs
Date:   Fri, 28 Apr 2023 08:39:44 -0400
Message-Id: <20230428123954.179035-8-stefanha@redhat.com>
In-Reply-To: <20230428123954.179035-1-stefanha@redhat.com>
References: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230427172019.3345-8-faithilikerun@gmail.com
Message-id: 20230324090605.28361-8-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 block/file-posix.c | 3 +++
 block/trace-events | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/block/file-posix.c b/block/file-posix.c
index 67d4ec6ac5..701acddbca 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -3271,6 +3271,7 @@ static int coroutine_fn raw_co_zone_report(BlockDriverState *bs, int64_t offset,
         },
     };
 
+    trace_zbd_zone_report(bs, *nr_zones, offset >> BDRV_SECTOR_BITS);
     return raw_thread_pool_submit(handle_aiocb_zone_report, &acb);
 }
 #endif
@@ -3337,6 +3338,8 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
         },
     };
 
+    trace_zbd_zone_mgmt(bs, op_name, offset >> BDRV_SECTOR_BITS,
+                        len >> BDRV_SECTOR_BITS);
     ret = raw_thread_pool_submit(handle_aiocb_zone_mgmt, &acb);
     if (ret != 0) {
         error_report("ioctl %s failed %d", op_name, ret);
diff --git a/block/trace-events b/block/trace-events
index 48dbf10c66..3f4e1d088a 100644
--- a/block/trace-events
+++ b/block/trace-events
@@ -209,6 +209,8 @@ file_FindEjectableOpticalMedia(const char *media) "Matching using %s"
 file_setup_cdrom(const char *partition) "Using %s as optical disc"
 file_hdev_is_sg(int type, int version) "SG device found: type=%d, version=%d"
 file_flush_fdatasync_failed(int err) "errno %d"
+zbd_zone_report(void *bs, unsigned int nr_zones, int64_t sector) "bs %p report %d zones starting at sector offset 0x%" PRIx64 ""
+zbd_zone_mgmt(void *bs, const char *op_name, int64_t sector, int64_t len) "bs %p %s starts at sector offset 0x%" PRIx64 " over a range of 0x%" PRIx64 " sectors"
 
 # ssh.c
 sftp_error(const char *op, const char *ssh_err, int ssh_err_code, int sftp_err_code) "%s failed: %s (libssh error code: %d, sftp error code: %d)"
-- 
2.40.0

