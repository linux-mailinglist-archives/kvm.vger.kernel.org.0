Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2721B648
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfEMMqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:46:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39506 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729753AbfEMMqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 08:46:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 45F5B95B4F46855B7575;
        Mon, 13 May 2019 20:46:43 +0800 (CST)
Received: from ros.huawei.com (10.143.28.118) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 13 May 2019 20:46:35 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: [PATCH v16 04/10] acpi: add build_append_ghes_generic_data() helper for Generic Error Data Entry
Date:   Mon, 13 May 2019 05:43:02 -0700
Message-ID: <1557751388-27063-5-git-send-email-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com>
References: <1557751388-27063-1-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.143.28.118]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It will help to add Generic Error Data Entry to ACPI tables
without using packed C structures and avoid endianness
issues as API doesn't need explicit conversion.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 hw/acpi/aml-build.c         | 32 ++++++++++++++++++++++++++++++++
 include/hw/acpi/aml-build.h |  6 ++++++
 2 files changed, 38 insertions(+)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index fb53f21..102a288 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -296,6 +296,38 @@ void build_append_ghes_notify(GArray *table, const uint8_t type,
         build_append_int_noprefix(table, error_threshold_window, 4);
 }
 
+/* Generic Error Data Entry
+ * ACPI 4.0: 17.3.2.6.1 Generic Error Data
+ */
+void build_append_ghes_generic_data(GArray *table, const char *section_type,
+                                    uint32_t error_severity, uint16_t revision,
+                                    uint8_t validation_bits, uint8_t flags,
+                                    uint32_t error_data_length, uint8_t *fru_id,
+                                    uint8_t *fru_text, uint64_t time_stamp)
+{
+    int i;
+
+    for (i = 0; i < 16; i++) {
+        build_append_int_noprefix(table, section_type[i], 1);
+    }
+
+    build_append_int_noprefix(table, error_severity, 4);
+    build_append_int_noprefix(table, revision, 2);
+    build_append_int_noprefix(table, validation_bits, 1);
+    build_append_int_noprefix(table, flags, 1);
+    build_append_int_noprefix(table, error_data_length, 4);
+
+    for (i = 0; i < 16; i++) {
+        build_append_int_noprefix(table, fru_id[i], 1);
+    }
+
+    for (i = 0; i < 20; i++) {
+        build_append_int_noprefix(table, fru_text[i], 1);
+    }
+
+    build_append_int_noprefix(table, time_stamp, 8);
+}
+
 /*
  * Build NAME(XXXX, 0x00000000) where 0x00000000 is encoded as a dword,
  * and return the offset to 0x00000000 for runtime patching.
diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
index 90c8ef8..a71db2f 100644
--- a/include/hw/acpi/aml-build.h
+++ b/include/hw/acpi/aml-build.h
@@ -419,6 +419,12 @@ void build_append_ghes_notify(GArray *table, const uint8_t type,
                               uint32_t error_threshold_value,
                               uint32_t error_threshold_window);
 
+void build_append_ghes_generic_data(GArray *table, const char *section_type,
+                                    uint32_t error_severity, uint16_t revision,
+                                    uint8_t validation_bits, uint8_t flags,
+                                    uint32_t error_data_length, uint8_t *fru_id,
+                                    uint8_t *fru_text, uint64_t time_stamp);
+
 void build_srat_memory(AcpiSratMemoryAffinity *numamem, uint64_t base,
                        uint64_t len, int node, MemoryAffinityFlags flags);
 
-- 
1.8.3.1

