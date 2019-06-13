Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95E7437DC
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbfFMPBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732542AbfFMOfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:35:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA27030BC599;
        Thu, 13 Jun 2019 14:35:37 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A4F51001B16;
        Thu, 13 Jun 2019 14:35:32 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 04/20] hw/i386/pc: Add the E820Type enum type
Date:   Thu, 13 Jun 2019 16:34:30 +0200
Message-Id: <20190613143446.23937-5-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 13 Jun 2019 14:35:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This ensure we won't use an incorrect value.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
v2: Do not cast the enum (Li)
---
 hw/i386/pc.c         |  4 ++--
 include/hw/i386/pc.h | 16 ++++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 5a7cffbb1a..86ba554439 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -872,7 +872,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
     x86_cpu_set_a20(cpu, level);
 }
 
-ssize_t e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type)
 {
     unsigned int index = le32_to_cpu(e820_reserve.count);
     struct e820_entry *entry;
@@ -906,7 +906,7 @@ size_t e820_get_num_entries(void)
     return e820_entries;
 }
 
-bool e820_get_entry(unsigned int idx, uint32_t type,
+bool e820_get_entry(unsigned int idx, E820Type type,
                     uint64_t *address, uint64_t *length)
 {
     if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index c56116e6f6..7c07185dd5 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -282,12 +282,16 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
                        const CPUArchIdList *apic_ids, GArray *entry);
 
-/* e820 types */
-#define E820_RAM        1
-#define E820_RESERVED   2
-#define E820_ACPI       3
-#define E820_NVS        4
-#define E820_UNUSABLE   5
+/**
+ * E820Type: Type of the e820 address range.
+ */
+typedef enum {
+    E820_RAM        = 1,
+    E820_RESERVED   = 2,
+    E820_ACPI       = 3,
+    E820_NVS        = 4,
+    E820_UNUSABLE   = 5
+} E820Type;
 
 ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
 size_t e820_get_num_entries(void);
-- 
2.20.1

