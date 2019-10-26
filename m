Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056C3E584B
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 05:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfJZDZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 23:25:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbfJZDZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 23:25:24 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6E7ECAA8A3404B96ADC1;
        Sat, 26 Oct 2019 11:25:22 +0800 (CST)
Received: from HGHY4Z004218071.china.huawei.com (10.133.224.57) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 26 Oct 2019 11:25:12 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <zhengxiang9@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: [PATCH v20 2/5] docs: APEI GHES generation and CPER record description
Date:   Sat, 26 Oct 2019 11:24:44 +0800
Message-ID: <20191026032447.20088-3-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
In-Reply-To: <20191026032447.20088-1-zhengxiang9@huawei.com>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

Add APEI/GHES detailed design document

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 docs/specs/acpi_hest_ghes.rst | 95 +++++++++++++++++++++++++++++++++++
 docs/specs/index.rst          |  1 +
 2 files changed, 96 insertions(+)
 create mode 100644 docs/specs/acpi_hest_ghes.rst

diff --git a/docs/specs/acpi_hest_ghes.rst b/docs/specs/acpi_hest_ghes.rst
new file mode 100644
index 0000000000..348825f9d3
--- /dev/null
+++ b/docs/specs/acpi_hest_ghes.rst
@@ -0,0 +1,95 @@
+APEI tables generating and CPER record
+======================================
+
+..
+   Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
+
+   This work is licensed under the terms of the GNU GPL, version 2 or later.
+   See the COPYING file in the top-level directory.
+
+Design Details
+--------------
+
+::
+
+         etc/acpi/tables                                 etc/hardware_errors
+      ====================                      ==========================================
+  + +--------------------------+            +-----------------------+
+  | | HEST                     |            |    address            |            +--------------+
+  | +--------------------------+            |    registers          |            | Error Status |
+  | | GHES1                    |            | +---------------------+            | Data Block 1 |
+  | +--------------------------+ +--------->| |error_block_address1 |----------->| +------------+
+  | | .................        | |          | +---------------------+            | |  CPER      |
+  | | error_status_address-----+-+ +------->| |error_block_address2 |--------+   | |  CPER      |
+  | | .................        |   |        | +---------------------+        |   | |  ....      |
+  | | read_ack_register--------+-+ |        | |    ..............   |        |   | |  CPER      |
+  | | read_ack_preserve        | | |        +-----------------------+        |   | +------------+
+  | | read_ack_write           | | | +----->| |error_block_addressN |------+ |   | Error Status |
+  + +--------------------------+ | | |      | +---------------------+      | |   | Data Block 2 |
+  | | GHES2                    | +-+-+----->| |read_ack_register1   |      | +-->| +------------+
+  + +--------------------------+   | |      | +---------------------+      |     | |  CPER      |
+  | | .................        |   | | +--->| |read_ack_register2   |      |     | |  CPER      |
+  | | error_status_address-----+---+ | |    | +---------------------+      |     | |  ....      |
+  | | .................        |     | |    | |  .............      |      |     | |  CPER      |
+  | | read_ack_register--------+-----+-+    | +---------------------+      |     +-+------------+
+  | | read_ack_preserve        |     |   +->| |read_ack_registerN   |      |     | |..........  |
+  | | read_ack_write           |     |   |  | +---------------------+      |     | +------------+
+  + +--------------------------|     |   |                                 |     | Error Status |
+  | | ...............          |     |   |                                 |     | Data Block N |
+  + +--------------------------+     |   |                                 +---->| +------------+
+  | | GHESN                    |     |   |                                       | |  CPER      |
+  + +--------------------------+     |   |                                       | |  CPER      |
+  | | .................        |     |   |                                       | |  ....      |
+  | | error_status_address-----+-----+   |                                       | |  CPER      |
+  | | .................        |         |                                       +-+------------+
+  | | read_ack_register--------+---------+
+  | | read_ack_preserve        |
+  | | read_ack_write           |
+  + +--------------------------+
+
+(1) QEMU generates the ACPI HEST table. This table goes in the current
+    "etc/acpi/tables" fw_cfg blob. Each error source has different
+    notification types.
+
+(2) A new fw_cfg blob called "etc/hardware_errors" is introduced. QEMU
+    also needs to populate this blob. The "etc/hardware_errors" fw_cfg blob
+    contains an address registers table and an Error Status Data Block table.
+
+(3) The address registers table contains N Error Block Address entries
+    and N Read Ack Register entries. The size for each entry is 8-byte.
+    The Error Status Data Block table contains N Error Status Data Block
+    entries. The size for each entry is 4096(0x1000) bytes. The total size
+    for the "etc/hardware_errors" fw_cfg blob is (N * 8 * 2 + N * 4096) bytes.
+    N is the number of the kinds of hardware error sources.
+
+(4) QEMU generates the ACPI linker/loader script for the firmware. The
+    firmware pre-allocates memory for "etc/acpi/tables", "etc/hardware_errors"
+    and copies blob contents there.
+
+(5) QEMU generates N ADD_POINTER commands, which patch addresses in the
+    "error_status_address" fields of the HEST table with a pointer to the
+    corresponding "address registers" in the "etc/hardware_errors" blob.
+
+(6) QEMU generates N ADD_POINTER commands, which patch addresses in the
+    "read_ack_register" fields of the HEST table with a pointer to the
+    corresponding "address registers" in the "etc/hardware_errors" blob.
+
+(7) QEMU generates N ADD_POINTER commands for the firmware, which patch
+    addresses in the "error_block_address" fields with a pointer to the
+    respective "Error Status Data Block" in the "etc/hardware_errors" blob.
+
+(8) QEMU defines a third and write-only fw_cfg blob which is called
+    "etc/hardware_errors_addr". Through that blob, the firmware can send back
+    the guest-side allocation addresses to QEMU. The "etc/hardware_errors_addr"
+    blob contains a 8-byte entry. QEMU generates a single WRITE_POINTER command
+    for the firmware. The firmware will write back the start address of
+    "etc/hardware_errors" blob to the fw_cfg file "etc/hardware_errors_addr".
+
+(9) When QEMU gets a SIGBUS from the kernel, QEMU formats the CPER right into
+    guest memory, and then injects platform specific interrupt (in case of
+    arm/virt machine it's Synchronous External Abort) as a notification which
+    is necessary for notifying the guest.
+
+(10) This notification (in virtual hardware) will be handled by the guest
+     kernel, guest APEI driver will read the CPER which is recorded by QEMU and
+     do the recovery.
diff --git a/docs/specs/index.rst b/docs/specs/index.rst
index 984ba44029..3019b9c976 100644
--- a/docs/specs/index.rst
+++ b/docs/specs/index.rst
@@ -13,3 +13,4 @@ Contents:
    ppc-xive
    ppc-spapr-xive
    acpi_hw_reduced_hotplug
+   acpi_hest_ghes
-- 
2.19.1


