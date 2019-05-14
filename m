Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF11C7B3
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 13:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfENLWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 07:22:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbfENLWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 07:22:02 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3790D76FB4572CE937D8;
        Tue, 14 May 2019 19:22:00 +0800 (CST)
Received: from ros.huawei.com (10.143.28.118) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 14 May 2019 19:21:51 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: [PATCH v17 03/10] acpi: add build_append_ghes_notify() helper for Hardware Error Notification
Date:   Tue, 14 May 2019 04:18:16 -0700
Message-ID: <1557832703-42620-4-git-send-email-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.143.28.118]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It will help to add Hardware Error Notification to ACPI tables
without using packed C structures and avoid endianness
issues as API doesn't need explicit conversion.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 hw/acpi/aml-build.c         | 22 ++++++++++++++++++++++
 include/hw/acpi/aml-build.h |  8 ++++++++
 2 files changed, 30 insertions(+)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 555c24f..fb53f21 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -274,6 +274,28 @@ void build_append_gas(GArray *table, AmlAddressSpace as,
     build_append_int_noprefix(table, address, 8);
 }
 
+/* Hardware Error Notification
+ * ACPI 4.0: 17.3.2.7 Hardware Error Notification
+ */
+void build_append_ghes_notify(GArray *table, const uint8_t type,
+                              uint8_t length, uint16_t config_write_enable,
+                              uint32_t poll_interval, uint32_t vector,
+                              uint32_t polling_threshold_value,
+                              uint32_t polling_threshold_window,
+                              uint32_t error_threshold_value,
+                              uint32_t error_threshold_window)
+{
+        build_append_int_noprefix(table, type, 1); /* type */
+        build_append_int_noprefix(table, length, 1);
+        build_append_int_noprefix(table, config_write_enable, 2);
+        build_append_int_noprefix(table, poll_interval, 4);
+        build_append_int_noprefix(table, vector, 4);
+        build_append_int_noprefix(table, polling_threshold_value, 4);
+        build_append_int_noprefix(table, polling_threshold_window, 4);
+        build_append_int_noprefix(table, error_threshold_value, 4);
+        build_append_int_noprefix(table, error_threshold_window, 4);
+}
+
 /*
  * Build NAME(XXXX, 0x00000000) where 0x00000000 is encoded as a dword,
  * and return the offset to 0x00000000 for runtime patching.
diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
index 1a563ad..90c8ef8 100644
--- a/include/hw/acpi/aml-build.h
+++ b/include/hw/acpi/aml-build.h
@@ -411,6 +411,14 @@ build_append_gas_from_struct(GArray *table, const struct AcpiGenericAddress *s)
                      s->access_width, s->address);
 }
 
+void build_append_ghes_notify(GArray *table, const uint8_t type,
+                              uint8_t length, uint16_t config_write_enable,
+                              uint32_t poll_interval, uint32_t vector,
+                              uint32_t polling_threshold_value,
+                              uint32_t polling_threshold_window,
+                              uint32_t error_threshold_value,
+                              uint32_t error_threshold_window);
+
 void build_srat_memory(AcpiSratMemoryAffinity *numamem, uint64_t base,
                        uint64_t len, int node, MemoryAffinityFlags flags);
 
-- 
1.8.3.1

