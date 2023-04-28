Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2966F1831
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346081AbjD1MlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346039AbjD1MlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:41:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B894C0E
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682685617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ASo/M27XEwJQrnB/OXsHap/SXpK8mavLaKAWB+uxFUs=;
        b=EyeYKH/4FSlC7bHM4XL+f/w/2tlYgd78veAKe0iyVdktnUk/Kix4ebHwU8aH833EeyQ2sb
        G3GZaWwNSuguRAuUcncxbmVYE1ObIbhLgG8RLFrev2jGIqNC7dyUH1RvyqyTYfmM9KfTKG
        TIkVPZZDYWWiNEhYixSB9aQMVnQMHEI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-kklycAtNP5GuhxUKQEmhKw-1; Fri, 28 Apr 2023 08:40:14 -0400
X-MC-Unique: kklycAtNP5GuhxUKQEmhKw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6569A800047;
        Fri, 28 Apr 2023 12:40:13 +0000 (UTC)
Received: from localhost (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD44F2027043;
        Fri, 28 Apr 2023 12:40:12 +0000 (UTC)
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
        Sam Li <faithilikerun@gmail.com>
Subject: [PULL 06/17] iotests: test new zone operations
Date:   Fri, 28 Apr 2023 08:39:43 -0400
Message-Id: <20230428123954.179035-7-stefanha@redhat.com>
In-Reply-To: <20230428123954.179035-1-stefanha@redhat.com>
References: <20230428123954.179035-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The new block layer APIs of zoned block devices can be tested by:
$ tests/qemu-iotests/check zoned
Run each zone operation on a newly created null_blk device
and see whether it outputs the same zone information.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230427172019.3345-7-faithilikerun@gmail.com
Message-id: 20230324090605.28361-7-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org>.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tests/qemu-iotests/tests/zoned     | 89 ++++++++++++++++++++++++++++++
 tests/qemu-iotests/tests/zoned.out | 53 ++++++++++++++++++
 2 files changed, 142 insertions(+)
 create mode 100755 tests/qemu-iotests/tests/zoned
 create mode 100644 tests/qemu-iotests/tests/zoned.out

diff --git a/tests/qemu-iotests/tests/zoned b/tests/qemu-iotests/tests/zoned
new file mode 100755
index 0000000000..56f60616b5
--- /dev/null
+++ b/tests/qemu-iotests/tests/zoned
@@ -0,0 +1,89 @@
+#!/usr/bin/env bash
+#
+# Test zone management operations.
+#
+
+seq="$(basename $0)"
+echo "QA output created by $seq"
+status=1 # failure is the default!
+
+_cleanup()
+{
+  _cleanup_test_img
+  sudo -n rmmod null_blk
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ../common.rc
+. ../common.filter
+. ../common.qemu
+
+# This test only runs on Linux hosts with raw image files.
+_supported_fmt raw
+_supported_proto file
+_supported_os Linux
+
+sudo -n true || \
+    _notrun 'Password-less sudo required'
+
+IMG="--image-opts -n driver=host_device,filename=/dev/nullb0"
+QEMU_IO_OPTIONS=$QEMU_IO_OPTIONS_NO_FMT
+
+echo "Testing a null_blk device:"
+echo "case 1: if the operations work"
+sudo -n modprobe null_blk nr_devices=1 zoned=1
+sudo -n chmod 0666 /dev/nullb0
+
+echo "(1) report the first zone:"
+$QEMU_IO $IMG -c "zrp 0 1"
+echo
+echo "report the first 10 zones"
+$QEMU_IO $IMG -c "zrp 0 10"
+echo
+echo "report the last zone:"
+$QEMU_IO $IMG -c "zrp 0x3e70000000 2" # 0x3e70000000 / 512 = 0x1f380000
+echo
+echo
+echo "(2) opening the first zone"
+$QEMU_IO $IMG -c "zo 0 268435456"  # 268435456 / 512 = 524288
+echo "report after:"
+$QEMU_IO $IMG -c "zrp 0 1"
+echo
+echo "opening the second zone"
+$QEMU_IO $IMG -c "zo 268435456 268435456" #
+echo "report after:"
+$QEMU_IO $IMG -c "zrp 268435456 1"
+echo
+echo "opening the last zone"
+$QEMU_IO $IMG -c "zo 0x3e70000000 268435456"
+echo "report after:"
+$QEMU_IO $IMG -c "zrp 0x3e70000000 2"
+echo
+echo
+echo "(3) closing the first zone"
+$QEMU_IO $IMG -c "zc 0 268435456"
+echo "report after:"
+$QEMU_IO $IMG -c "zrp 0 1"
+echo
+echo "closing the last zone"
+$QEMU_IO $IMG -c "zc 0x3e70000000 268435456"
+echo "report after:"
+$QEMU_IO $IMG -c "zrp 0x3e70000000 2"
+echo
+echo
+echo "(4) finishing the second zone"
+$QEMU_IO $IMG -c "zf 268435456 268435456"
+echo "After finishing a zone:"
+$QEMU_IO $IMG -c "zrp 268435456 1"
+echo
+echo
+echo "(5) resetting the second zone"
+$QEMU_IO $IMG -c "zrs 268435456 268435456"
+echo "After resetting a zone:"
+$QEMU_IO $IMG -c "zrp 268435456 1"
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
diff --git a/tests/qemu-iotests/tests/zoned.out b/tests/qemu-iotests/tests/zoned.out
new file mode 100644
index 0000000000..b2d061da49
--- /dev/null
+++ b/tests/qemu-iotests/tests/zoned.out
@@ -0,0 +1,53 @@
+QA output created by zoned
+Testing a null_blk device:
+case 1: if the operations work
+(1) report the first zone:
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x0, zcond:1, [type: 2]
+
+report the first 10 zones
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x0, zcond:1, [type: 2]
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80000, zcond:1, [type: 2]
+start: 0x100000, len 0x80000, cap 0x80000, wptr 0x100000, zcond:1, [type: 2]
+start: 0x180000, len 0x80000, cap 0x80000, wptr 0x180000, zcond:1, [type: 2]
+start: 0x200000, len 0x80000, cap 0x80000, wptr 0x200000, zcond:1, [type: 2]
+start: 0x280000, len 0x80000, cap 0x80000, wptr 0x280000, zcond:1, [type: 2]
+start: 0x300000, len 0x80000, cap 0x80000, wptr 0x300000, zcond:1, [type: 2]
+start: 0x380000, len 0x80000, cap 0x80000, wptr 0x380000, zcond:1, [type: 2]
+start: 0x400000, len 0x80000, cap 0x80000, wptr 0x400000, zcond:1, [type: 2]
+start: 0x480000, len 0x80000, cap 0x80000, wptr 0x480000, zcond:1, [type: 2]
+
+report the last zone:
+start: 0x1f380000, len 0x80000, cap 0x80000, wptr 0x1f380000, zcond:1, [type: 2]
+
+
+(2) opening the first zone
+report after:
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x0, zcond:3, [type: 2]
+
+opening the second zone
+report after:
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80000, zcond:3, [type: 2]
+
+opening the last zone
+report after:
+start: 0x1f380000, len 0x80000, cap 0x80000, wptr 0x1f380000, zcond:3, [type: 2]
+
+
+(3) closing the first zone
+report after:
+start: 0x0, len 0x80000, cap 0x80000, wptr 0x0, zcond:1, [type: 2]
+
+closing the last zone
+report after:
+start: 0x1f380000, len 0x80000, cap 0x80000, wptr 0x1f380000, zcond:1, [type: 2]
+
+
+(4) finishing the second zone
+After finishing a zone:
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x100000, zcond:14, [type: 2]
+
+
+(5) resetting the second zone
+After resetting a zone:
+start: 0x80000, len 0x80000, cap 0x80000, wptr 0x80000, zcond:1, [type: 2]
+*** done
-- 
2.40.0

