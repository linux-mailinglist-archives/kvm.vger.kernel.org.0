Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660BE5EFE60
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiI2UFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiI2UFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:05:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A94F9620
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:39 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TJIjmW011159
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=AoyPjajIpyVidAzljD0XY/jKYrambGL1LiJyA48EaKo=;
 b=fAgipyfXhA5JnXgmU/lynv9UAAzXV37Di8cw8H6hxmmCULzz3gf8bhxgaVE27RzeL1TX
 2XaVMZnkyoD2ihl8j2YrB+L2zNWTzKT7fBVjs9wIgotzymmZmiCC2q9owF9ugywHMw+g
 aThIthapExAsONzj18r2qfYK5KpMB1fb79ejEJAoMUMy/Ykat5FF5GJuaTrBv8phwQ3P
 IhfIKF4nNoA+AxfMtG9h6V0Yvi0ZjfJXwv3mUDI99AUkgBr5BQTUTYsAhJrFaHkjjsU/
 XSRN/384polgxvP4rZ+NEa7YYEyMPWYTRsOgvdo4hq61EE/39ZvhcQeqjgzh1cKjG8ZJ rQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jw6yc5fde-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:05:38 -0700
Received: from twshared8247.08.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 13:05:36 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 40BDC930500A; Thu, 29 Sep 2022 13:05:24 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <qemu-block@nongnu.org>, Kevin Wolf <kwolf@redhat.com>,
        <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/2] block: move bdrv_qiov_is_aligned to file-posix
Date:   Thu, 29 Sep 2022 13:05:22 -0700
Message-ID: <20220929200523.3218710-2-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929200523.3218710-1-kbusch@meta.com>
References: <20220929200523.3218710-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 8A2s2HoQtVNyQJjg5By-8XJ7hFUJ7Pqk
X-Proofpoint-ORIG-GUID: 8A2s2HoQtVNyQJjg5By-8XJ7hFUJ7Pqk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_11,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

There is only user of bdrv_qiov_is_aligned(), so move the alignment
function to there and make it static.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/file-posix.c       | 21 +++++++++++++++++++++
 block/io.c               | 21 ---------------------
 include/block/block-io.h |  1 -
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/block/file-posix.c b/block/file-posix.c
index 48cd096624..e3f3de2780 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -2061,6 +2061,27 @@ static int coroutine_fn raw_thread_pool_submit(Blo=
ckDriverState *bs,
     return thread_pool_submit_co(pool, func, arg);
 }
=20
+/*
+ * Check if all memory in this vector is sector aligned.
+ */
+static bool bdrv_qiov_is_aligned(BlockDriverState *bs, QEMUIOVector *qio=
v)
+{
+    int i;
+    size_t alignment =3D bdrv_min_mem_align(bs);
+    IO_CODE();
+
+    for (i =3D 0; i < qiov->niov; i++) {
+        if ((uintptr_t) qiov->iov[i].iov_base % alignment) {
+            return false;
+        }
+        if (qiov->iov[i].iov_len % alignment) {
+            return false;
+        }
+    }
+
+    return true;
+}
+
 static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset=
,
                                    uint64_t bytes, QEMUIOVector *qiov, i=
nt type)
 {
diff --git a/block/io.c b/block/io.c
index 0a8cbefe86..96edc7f7cb 100644
--- a/block/io.c
+++ b/block/io.c
@@ -3236,27 +3236,6 @@ void *qemu_try_blockalign0(BlockDriverState *bs, s=
ize_t size)
     return mem;
 }
=20
-/*
- * Check if all memory in this vector is sector aligned.
- */
-bool bdrv_qiov_is_aligned(BlockDriverState *bs, QEMUIOVector *qiov)
-{
-    int i;
-    size_t alignment =3D bdrv_min_mem_align(bs);
-    IO_CODE();
-
-    for (i =3D 0; i < qiov->niov; i++) {
-        if ((uintptr_t) qiov->iov[i].iov_base % alignment) {
-            return false;
-        }
-        if (qiov->iov[i].iov_len % alignment) {
-            return false;
-        }
-    }
-
-    return true;
-}
-
 void bdrv_io_plug(BlockDriverState *bs)
 {
     BdrvChild *child;
diff --git a/include/block/block-io.h b/include/block/block-io.h
index fd25ffa9be..492f95fc05 100644
--- a/include/block/block-io.h
+++ b/include/block/block-io.h
@@ -150,7 +150,6 @@ void *qemu_blockalign(BlockDriverState *bs, size_t si=
ze);
 void *qemu_blockalign0(BlockDriverState *bs, size_t size);
 void *qemu_try_blockalign(BlockDriverState *bs, size_t size);
 void *qemu_try_blockalign0(BlockDriverState *bs, size_t size);
-bool bdrv_qiov_is_aligned(BlockDriverState *bs, QEMUIOVector *qiov);
=20
 void bdrv_enable_copy_on_read(BlockDriverState *bs);
 void bdrv_disable_copy_on_read(BlockDriverState *bs);
--=20
2.30.2

