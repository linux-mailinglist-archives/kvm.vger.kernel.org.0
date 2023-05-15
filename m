Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63770322C
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbjEOQGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242508AbjEOQGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 12:06:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C87E26A3
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 09:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684166716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fHIz0h3FWaTgMpl3H8preMnJ4gVhxX+URbxC7lRgBb0=;
        b=Ii00M1whZMa1F3dMD/yPm0lSbNdL2AG4upR/ayJyXqXtX6MUv2+yeJ2x6lN2tf/yiW2J5d
        5yxY6CQK6eFB4jTupLXytD9PgieroM5XU8BpVFhhM1cFjfDjeH7r4VFZ5MYIATmzSO2UqF
        p9Y8pS/JtrHMPNKa45bwymGOUc1R7Xc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-N9aGrHkHNK-6h93yzg_XdQ-1; Mon, 15 May 2023 12:05:13 -0400
X-MC-Unique: N9aGrHkHNK-6h93yzg_XdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ECA687DC02;
        Mon, 15 May 2023 16:05:12 +0000 (UTC)
Received: from localhost (unknown [10.39.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06C5214152F6;
        Mon, 15 May 2023 16:05:11 +0000 (UTC)
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
        Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PULL v2 02/16] block/file-posix: introduce helper functions for sysfs attributes
Date:   Mon, 15 May 2023 12:04:52 -0400
Message-Id: <20230515160506.1776883-3-stefanha@redhat.com>
In-Reply-To: <20230515160506.1776883-1-stefanha@redhat.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sam Li <faithilikerun@gmail.com>

Use get_sysfs_str_val() to get the string value of device
zoned model. Then get_sysfs_zoned_model() can convert it to
BlockZoneModel type of QEMU.

Use get_sysfs_long_val() to get the long value of zoned device
information.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230508045533.175575-3-faithilikerun@gmail.com
Message-id: 20230324090605.28361-3-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org>.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block_int-common.h |   3 +
 block/file-posix.c               | 135 ++++++++++++++++++++++---------
 2 files changed, 100 insertions(+), 38 deletions(-)

diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index 4909876756..c7ca5a83e9 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -862,6 +862,9 @@ typedef struct BlockLimits {
      * an explicit monitor command to load the disk inside the guest).
      */
     bool has_variable_length;
+
+    /* device zone model */
+    BlockZoneModel zoned;
 } BlockLimits;
 
 typedef struct BdrvOpBlocker BdrvOpBlocker;
diff --git a/block/file-posix.c b/block/file-posix.c
index c7b723368e..97c597a2a0 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1202,15 +1202,89 @@ static int hdev_get_max_hw_transfer(int fd, struct stat *st)
 #endif
 }
 
-static int hdev_get_max_segments(int fd, struct stat *st)
+/*
+ * Get a sysfs attribute value as character string.
+ */
+#ifdef CONFIG_LINUX
+static int get_sysfs_str_val(struct stat *st, const char *attribute,
+                             char **val) {
+    g_autofree char *sysfspath = NULL;
+    int ret;
+    size_t len;
+
+    if (!S_ISBLK(st->st_mode)) {
+        return -ENOTSUP;
+    }
+
+    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/%s",
+                                major(st->st_rdev), minor(st->st_rdev),
+                                attribute);
+    ret = g_file_get_contents(sysfspath, val, &len, NULL);
+    if (ret == -1) {
+        return -ENOENT;
+    }
+
+    /* The file is ended with '\n' */
+    char *p;
+    p = *val;
+    if (*(p + len - 1) == '\n') {
+        *(p + len - 1) = '\0';
+    }
+    return ret;
+}
+#endif
+
+static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
 {
+    g_autofree char *val = NULL;
+    int ret;
+
+    ret = get_sysfs_str_val(st, "zoned", &val);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (strcmp(val, "host-managed") == 0) {
+        *zoned = BLK_Z_HM;
+    } else if (strcmp(val, "host-aware") == 0) {
+        *zoned = BLK_Z_HA;
+    } else if (strcmp(val, "none") == 0) {
+        *zoned = BLK_Z_NONE;
+    } else {
+        return -ENOTSUP;
+    }
+    return 0;
+}
+
+/*
+ * Get a sysfs attribute value as a long integer.
+ */
 #ifdef CONFIG_LINUX
-    char buf[32];
+static long get_sysfs_long_val(struct stat *st, const char *attribute)
+{
+    g_autofree char *str = NULL;
     const char *end;
-    char *sysfspath = NULL;
+    long val;
+    int ret;
+
+    ret = get_sysfs_str_val(st, attribute, &str);
+    if (ret < 0) {
+        return ret;
+    }
+
+    /* The file is ended with '\n', pass 'end' to accept that. */
+    ret = qemu_strtol(str, &end, 10, &val);
+    if (ret == 0 && end && *end == '\0') {
+        ret = val;
+    }
+    return ret;
+}
+#endif
+
+static int hdev_get_max_segments(int fd, struct stat *st)
+{
+#ifdef CONFIG_LINUX
     int ret;
-    int sysfd = -1;
-    long max_segments;
 
     if (S_ISCHR(st->st_mode)) {
         if (ioctl(fd, SG_GET_SG_TABLESIZE, &ret) == 0) {
@@ -1218,44 +1292,27 @@ static int hdev_get_max_segments(int fd, struct stat *st)
         }
         return -ENOTSUP;
     }
-
-    if (!S_ISBLK(st->st_mode)) {
-        return -ENOTSUP;
-    }
-
-    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/max_segments",
-                                major(st->st_rdev), minor(st->st_rdev));
-    sysfd = open(sysfspath, O_RDONLY);
-    if (sysfd == -1) {
-        ret = -errno;
-        goto out;
-    }
-    ret = RETRY_ON_EINTR(read(sysfd, buf, sizeof(buf) - 1));
-    if (ret < 0) {
-        ret = -errno;
-        goto out;
-    } else if (ret == 0) {
-        ret = -EIO;
-        goto out;
-    }
-    buf[ret] = 0;
-    /* The file is ended with '\n', pass 'end' to accept that. */
-    ret = qemu_strtol(buf, &end, 10, &max_segments);
-    if (ret == 0 && end && *end == '\n') {
-        ret = max_segments;
-    }
-
-out:
-    if (sysfd != -1) {
-        close(sysfd);
-    }
-    g_free(sysfspath);
-    return ret;
+    return get_sysfs_long_val(st, "max_segments");
 #else
     return -ENOTSUP;
 #endif
 }
 
+static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat *st,
+                                     Error **errp)
+{
+    BlockZoneModel zoned;
+    int ret;
+
+    bs->bl.zoned = BLK_Z_NONE;
+
+    ret = get_sysfs_zoned_model(st, &zoned);
+    if (ret < 0 || zoned == BLK_Z_NONE) {
+        return;
+    }
+    bs->bl.zoned = zoned;
+}
+
 static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
 {
     BDRVRawState *s = bs->opaque;
@@ -1297,6 +1354,8 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
             bs->bl.max_hw_iov = ret;
         }
     }
+
+    raw_refresh_zoned_limits(bs, &st, errp);
 }
 
 static int check_for_dasd(int fd)
-- 
2.40.1

