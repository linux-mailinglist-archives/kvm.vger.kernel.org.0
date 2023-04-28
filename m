Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223176F182C
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346060AbjD1Mk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346068AbjD1Mk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC0610E7
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W0udrCJv7r8lAynaFcJv3pPNEBbKHvfiYakeUszKD0Y=;
        b=PnElJ0klsHm5DI7Gy86KQIUKvlI4AYrfpxcDPtEahFAkG+5kn6ox8TWNS8lQhKC6+JchlH
        ztpX1KGG8TpGc2A3/Rq072FmsGGWcwQ6aCsFM8RmS2ymPRhB1GaeIUN6fuKCqyJHN18oS8
        HUsY2Zu78OfMMfAwPgugTbA9Yk/EloQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-FO8xTO4SMsuocpXusj82lQ-1; Fri, 28 Apr 2023 08:40:04 -0400
X-MC-Unique: FO8xTO4SMsuocpXusj82lQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C054887412;
        Fri, 28 Apr 2023 12:40:02 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7301035443;
        Fri, 28 Apr 2023 12:40:01 +0000 (UTC)
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
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PULL 02/17] block/file-posix: introduce helper functions for sysfs attributes
Date:   Fri, 28 Apr 2023 08:39:39 -0400
Message-Id: <20230428123954.179035-3-stefanha@redhat.com>
In-Reply-To: <20230428123954.179035-1-stefanha@redhat.com>
References: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Message-id: 20230427172019.3345-3-faithilikerun@gmail.com
Message-id: 20230324090605.28361-3-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org>.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block_int-common.h |   3 +
 block/file-posix.c               | 139 ++++++++++++++++++++++---------
 2 files changed, 104 insertions(+), 38 deletions(-)

diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index 013d419444..150dc6f68f 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -861,6 +861,9 @@ typedef struct BlockLimits {
      * an explicit monitor command to load the disk inside the guest).
      */
     bool has_variable_length;
+
+    /* device zone model */
+    BlockZoneModel zoned;
 } BlockLimits;
 
 typedef struct BdrvOpBlocker BdrvOpBlocker;
diff --git a/block/file-posix.c b/block/file-posix.c
index c7b723368e..ba15b10eee 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1202,15 +1202,93 @@ static int hdev_get_max_hw_transfer(int fd, struct stat *st)
 #endif
 }
 
-static int hdev_get_max_segments(int fd, struct stat *st)
+/*
+ * Get a sysfs attribute value as character string.
+ */
+static int get_sysfs_str_val(struct stat *st, const char *attribute,
+                             char **val) {
+#ifdef CONFIG_LINUX
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
+#else
+    return -ENOTSUP;
+#endif
+}
+
+static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
+{
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
+static long get_sysfs_long_val(struct stat *st, const char *attribute)
 {
 #ifdef CONFIG_LINUX
-    char buf[32];
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
+#else
+    return -ENOTSUP;
+#endif
+}
+
+static int hdev_get_max_segments(int fd, struct stat *st)
+{
+#ifdef CONFIG_LINUX
     int ret;
-    int sysfd = -1;
-    long max_segments;
 
     if (S_ISCHR(st->st_mode)) {
         if (ioctl(fd, SG_GET_SG_TABLESIZE, &ret) == 0) {
@@ -1218,44 +1296,27 @@ static int hdev_get_max_segments(int fd, struct stat *st)
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
@@ -1297,6 +1358,8 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
             bs->bl.max_hw_iov = ret;
         }
     }
+
+    raw_refresh_zoned_limits(bs, &st, errp);
 }
 
 static int check_for_dasd(int fd)
-- 
2.40.0

