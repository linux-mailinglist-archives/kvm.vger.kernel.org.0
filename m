Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB46E93D5
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbjDTMLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjDTMLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EE94EC6
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 05:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681992633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrFpVAN6JVD0pfkfnDSKx7XSwcNvFBzPVVBfVtgxg3Q=;
        b=BxVRQ/TjxZMCX8//FVLQquvxz1d/4o61tJLA/AiKA9v86e506bRuL1kIyIx3jONMqE3HL8
        1MBnVcrtScMqScKKAZO/7yypik3l1EtxKRF9F1HuuKHqWdzQByzuNs5MfHsfoJwmXCXrH+
        +u/0C5KMS6JwW4n3fU6Xgii/5hxe3xI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-LWG6yLJgMoiquaLYconLfg-1; Thu, 20 Apr 2023 08:10:28 -0400
X-MC-Unique: LWG6yLJgMoiquaLYconLfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7E62811E7C;
        Thu, 20 Apr 2023 12:10:27 +0000 (UTC)
Received: from localhost (unknown [10.39.193.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E036492B05;
        Thu, 20 Apr 2023 12:10:26 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Sam Li <faithilikerun@gmail.com>
Subject: [PULL 13/20] qemu-iotests: test zone append operation
Date:   Thu, 20 Apr 2023 08:09:41 -0400
Message-Id: <20230420120948.436661-14-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

The patch tests zone append writes by reporting the zone wp after
the completion of the call. "zap -p" option can print the sector
offset value after completion, which should be the start sector
where the append write begins.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230407081657.17947-4-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 qemu-io-cmds.c                     | 75 ++++++++++++++++++++++++++++++
 tests/qemu-iotests/tests/zoned     | 16 +++++++
 tests/qemu-iotests/tests/zoned.out | 16 +++++++
 3 files changed, 107 insertions(+)

diff --git a/qemu-io-cmds.c b/qemu-io-cmds.c
index f35ea627d7..3f75d2f5a6 100644
--- a/qemu-io-cmds.c
+++ b/qemu-io-cmds.c
@@ -1874,6 +1874,80 @@ static const cmdinfo_t zone_reset_cmd = {
     .oneline = "reset a zone write pointer in zone block device",
 };
 
+static int do_aio_zone_append(BlockBackend *blk, QEMUIOVector *qiov,
+                              int64_t *offset, int flags, int *total)
+{
+    int async_ret = NOT_DONE;
+
+    blk_aio_zone_append(blk, offset, qiov, flags, aio_rw_done, &async_ret);
+    while (async_ret == NOT_DONE) {
+        main_loop_wait(false);
+    }
+
+    *total = qiov->size;
+    return async_ret < 0 ? async_ret : 1;
+}
+
+static int zone_append_f(BlockBackend *blk, int argc, char **argv)
+{
+    int ret;
+    bool pflag = false;
+    int flags = 0;
+    int total = 0;
+    int64_t offset;
+    char *buf;
+    int c, nr_iov;
+    int pattern = 0xcd;
+    QEMUIOVector qiov;
+
+    if (optind > argc - 3) {
+        return -EINVAL;
+    }
+
+    if ((c = getopt(argc, argv, "p")) != -1) {
+        pflag = true;
+    }
+
+    offset = cvtnum(argv[optind]);
+    if (offset < 0) {
+        print_cvtnum_err(offset, argv[optind]);
+        return offset;
+    }
+    optind++;
+    nr_iov = argc - optind;
+    buf = create_iovec(blk, &qiov, &argv[optind], nr_iov, pattern,
+                       flags & BDRV_REQ_REGISTERED_BUF);
+    if (buf == NULL) {
+        return -EINVAL;
+    }
+    ret = do_aio_zone_append(blk, &qiov, &offset, flags, &total);
+    if (ret < 0) {
+        printf("zone append failed: %s\n", strerror(-ret));
+        goto out;
+    }
+
+    if (pflag) {
+        printf("After zap done, the append sector is 0x%" PRIx64 "\n",
+               tosector(offset));
+    }
+
+out:
+    qemu_io_free(blk, buf, qiov.size,
+                 flags & BDRV_REQ_REGISTERED_BUF);
+    qemu_iovec_destroy(&qiov);
+    return ret;
+}
+
+static const cmdinfo_t zone_append_cmd = {
+    .name = "zone_append",
+    .altname = "zap",
+    .cfunc = zone_append_f,
+    .argmin = 3,
+    .argmax = 4,
+    .args = "offset len [len..]",
+    .oneline = "append write a number of bytes at a specified offset",
+};
+
 static int truncate_f(BlockBackend *blk, int argc, char **argv);
 static const cmdinfo_t truncate_cmd = {
     .name       = "truncate",
@@ -2672,6 +2746,7 @@ static void __attribute((constructor)) init_qemuio_commands(void)
     qemuio_add_command(&zone_close_cmd);
     qemuio_add_command(&zone_finish_cmd);
     qemuio_add_command(&zone_reset_cmd);
+    qemuio_add_command(&zone_append_cmd);
     qemuio_add_command(&truncate_cmd);
     qemuio_add_command(&length_cmd);
     qemuio_add_command(&info_cmd);
diff --git a/tests/qemu-iotests/tests/zoned b/tests/qemu-iotests/tests/zoned
index 56f60616b5..3d23ce9cc1 100755
--- a/tests/qemu-iotests/tests/zoned
+++ b/tests/qemu-iotests/tests/zoned
@@ -82,6 +82,22 @@ echo "(5) resetting the second zone"
 $QEMU_IO $IMG -c "zrs 268435456 268435456"
 echo "After resetting a zone:"
 $QEMU_IO $IMG -c "zrp 268435456 1"
+echo
+echo
+echo "(6) append write" # the physical block size of the device is 4096
+$QEMU_IO $IMG -c "zrp 0 1"
+$QEMU_IO $IMG -c "zap -p 0 0x1000 0x2000"
+echo "After appending the first zone firstly:"
+$QEMU_IO $IMG -c "zrp 0 1"
+$QEMU_IO $IMG -c "zap -p 0 0x1000 0x2000"
+echo "After appending the first zone secondly:"
+$QEMU_IO $IMG -c "zrp 0 1"
+$QEMU_IO $IMG -c "zap -p 268435456 0x1000 0x2000"
+echo "After appending the second zone firstly:"
+$QEMU_IO $IMG -c "zrp 268435456 1"
+$QEMU_IO $IMG -c "zap -p 268435456 0x1000 0x2000"
+echo "After appending the second zone secondly:"
+$QEMU_IO $IMG -c "zrp 268435456 1"
 
 # success, all done
 echo "*** done"
diff --git a/tests/qemu-iotests/tests/zoned.out b/tests/qemu-iotests/tests/zoned.out
index b2d061da49..fe53ba4744 100644
--- a/tests/qemu-iotests/tests/zoned.out
+++ b/tests/qemu-iotests/tests/zoned.out
@@ -50,4 +50,20 @@ start: 0x80000, len 0x80000, cap 0x80000, wptr 0x100000, zcond:14, [type: 2]
 (5) resetting the second zone
 After resetting a zone:
 start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80000, zcond:1, [type: 2]
+
+
+(6) append write
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x0, zcond:1, [type: 2]
+After zap done, the append sector is 0x0
+After appending the first zone firstly:
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x18, zcond:2, [type: 2]
+After zap done, the append sector is 0x18
+After appending the first zone secondly:
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x30, zcond:2, [type: 2]
+After zap done, the append sector is 0x80000
+After appending the second zone firstly:
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80018, zcond:2, [type: 2]
+After zap done, the append sector is 0x80018
+After appending the second zone secondly:
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80030, zcond:2, [type: 2]
 *** done
-- 
2.39.2

