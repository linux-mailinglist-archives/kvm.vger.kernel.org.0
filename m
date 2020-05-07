Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C51C8C97
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 15:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEGNkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 09:40:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3897 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725969AbgEGNkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 09:40:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E53868DD50292E4B1F94;
        Thu,  7 May 2020 21:40:17 +0800 (CST)
Received: from huawei.com (10.151.151.243) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 21:40:09 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <imammedo@redhat.com>, <mst@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <peter.maydell@linaro.org>,
        <shannon.zhaosl@gmail.com>, <pbonzini@redhat.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
CC:     <gengdongjiu@huawei.com>, <zhengxiang9@huawei.com>,
        <Jonathan.Cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [PATCH v26 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common macro
Date:   Thu, 7 May 2020 21:41:56 +0800
Message-ID: <20200507134205.7559-2-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507134205.7559-1-gengdongjiu@huawei.com>
References: <20200507134205.7559-1-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.151.151.243]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The little end UUID is used in many places, so make
NVDIMM_UUID_LE to a common macro to convert the UUID
to a little end array.

Reviewed-by: Xiang Zheng <zhengxiang9@huawei.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
Change since v25:
1. Address Peter's comments to add a proper doc-comment comment for
   UUID_LE macros.
---
 hw/acpi/nvdimm.c    | 10 +++-------
 include/qemu/uuid.h | 26 ++++++++++++++++++++++++++
 slirp               |  2 +-
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
index fa7bf8b..9316d12 100644
--- a/hw/acpi/nvdimm.c
+++ b/hw/acpi/nvdimm.c
@@ -27,6 +27,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/uuid.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/aml-build.h"
 #include "hw/acpi/bios-linker-loader.h"
@@ -34,18 +35,13 @@
 #include "hw/mem/nvdimm.h"
 #include "qemu/nvdimm-utils.h"
 
-#define NVDIMM_UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
-   { (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
-     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
-     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }
-
 /*
  * define Byte Addressable Persistent Memory (PM) Region according to
  * ACPI 6.0: 5.2.25.1 System Physical Address Range Structure.
  */
 static const uint8_t nvdimm_nfit_spa_uuid[] =
-      NVDIMM_UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
-                     0x18, 0xb7, 0x8c, 0xdb);
+      UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
+              0x18, 0xb7, 0x8c, 0xdb);
 
 /*
  * NVDIMM Firmware Interface Table
diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
index 129c45f..2d17a90 100644
--- a/include/qemu/uuid.h
+++ b/include/qemu/uuid.h
@@ -34,6 +34,32 @@ typedef struct {
     };
 } QemuUUID;
 
+/**
+ * @time_low: The low field of the timestamp
+ * @time_mid: The middle field of the timestamp
+ * @time_hi_and_version: The high field of the timestamp
+ *                       multiplexed with the version number
+ * @clock_seq_hi_and_reserved: The high field of the clock
+ *                             sequence multiplexed with the variant
+ * @clock_seq_low: The low field of the clock sequence
+ * @node0: The spatially unique node0 identifier
+ * @node1: The spatially unique node1 identifier
+ * @node2: The spatially unique node2 identifier
+ * @node3: The spatially unique node3 identifier
+ * @node4: The spatially unique node4 identifier
+ * @node5: The spatially unique node5 identifier
+ *
+ * This macro converts the fields of UUID to little-endian array
+ */
+#define UUID_LE(time_low, time_mid, time_hi_and_version, \
+  clock_seq_hi_and_reserved, clock_seq_low, node0, node1, node2, \
+  node3, node4, node5) \
+  { (time_low) & 0xff, ((time_low) >> 8) & 0xff, ((time_low) >> 16) & 0xff, \
+    ((time_low) >> 24) & 0xff, (time_mid) & 0xff, ((time_mid) >> 8) & 0xff, \
+    (time_hi_and_version) & 0xff, ((time_hi_and_version) >> 8) & 0xff, \
+    (clock_seq_hi_and_reserved), (clock_seq_low), (node0), (node1), (node2),\
+    (node3), (node4), (node5) }
+
 #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
                  "%02hhx%02hhx-%02hhx%02hhx-" \
                  "%02hhx%02hhx-" \
diff --git a/slirp b/slirp
index 2faae0f..55ab21c 160000
--- a/slirp
+++ b/slirp
@@ -1 +1 @@
-Subproject commit 2faae0f778f818fadc873308f983289df697eb93
+Subproject commit 55ab21c9a36852915b81f1b41ebaf3b6509dd8ba
-- 
1.8.3.1

