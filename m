Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4F6F1835
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346089AbjD1MlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbjD1MlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:41:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EBA172A
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dh7nqtTKz7RJ73ICCMHEvPvnB0LG2OqGywI2wyppfro=;
        b=bUD3GFoIgIDmLbWkaqk9BXu4+FGW7xPzYYRlmEuvrBgzw6xez4U0Hthjg4211BnMDT51SJ
        +JaLlJMvF6NduKEYYzc7Vsg8lNSeT6vAHGNLn6/wliFqllIjYhRU+zRhfY56ql4U48miyb
        zcnaAB5p+224ASZfczv+x18nUxEYkm0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-wPXY4N5sMwe8vxg8zF5Fdg-1; Fri, 28 Apr 2023 08:40:29 -0400
X-MC-Unique: wPXY4N5sMwe8vxg8zF5Fdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D46F8185A78B;
        Fri, 28 Apr 2023 12:40:28 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39DC12027045;
        Fri, 28 Apr 2023 12:40:27 +0000 (UTC)
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
Subject: [PULL 12/17] block: add some trace events for zone append
Date:   Fri, 28 Apr 2023 08:39:49 -0400
Message-Id: <20230428123954.179035-13-stefanha@redhat.com>
In-Reply-To: <20230428123954.179035-1-stefanha@redhat.com>
References: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230427172339.3709-5-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 block/file-posix.c | 3 +++
 block/trace-events | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/block/file-posix.c b/block/file-posix.c
index 8fca0eab7b..2d776efa71 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -2517,6 +2517,8 @@ out:
             if (!BDRV_ZT_IS_CONV(*wp)) {
                 if (type & QEMU_AIO_ZONE_APPEND) {
                     *s->offset = *wp;
+                    trace_zbd_zone_append_complete(bs, *s->offset
+                        >> BDRV_SECTOR_BITS);
                 }
                 /* Advance the wp if needed */
                 if (offset + bytes > *wp) {
@@ -3558,6 +3560,7 @@ static int coroutine_fn raw_co_zone_append(BlockDriverState *bs,
         len += iov_len;
     }
 
+    trace_zbd_zone_append(bs, *offset >> BDRV_SECTOR_BITS);
     return raw_co_prw(bs, *offset, len, qiov, QEMU_AIO_ZONE_APPEND);
 }
 #endif
diff --git a/block/trace-events b/block/trace-events
index 3f4e1d088a..32665158d6 100644
--- a/block/trace-events
+++ b/block/trace-events
@@ -211,6 +211,8 @@ file_hdev_is_sg(int type, int version) "SG device found: type=%d, version=%d"
 file_flush_fdatasync_failed(int err) "errno %d"
 zbd_zone_report(void *bs, unsigned int nr_zones, int64_t sector) "bs %p report %d zones starting at sector offset 0x%" PRIx64 ""
 zbd_zone_mgmt(void *bs, const char *op_name, int64_t sector, int64_t len) "bs %p %s starts at sector offset 0x%" PRIx64 " over a range of 0x%" PRIx64 " sectors"
+zbd_zone_append(void *bs, int64_t sector) "bs %p append at sector offset 0x%" PRIx64 ""
+zbd_zone_append_complete(void *bs, int64_t sector) "bs %p returns append sector 0x%" PRIx64 ""
 
 # ssh.c
 sftp_error(const char *op, const char *ssh_err, int ssh_err_code, int sftp_err_code) "%s failed: %s (libssh error code: %d, sftp error code: %d)"
-- 
2.40.0

