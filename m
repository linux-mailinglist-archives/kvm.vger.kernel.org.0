Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949254350BA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 18:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJTQz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 12:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhJTQzz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 12:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634748821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQrYJ8/WGBhoAfAKZLzEjzcQyQS2HN+KLCNp8lSwvyI=;
        b=Mzt6P4rKzWP0a3aQ5l9ufPN1JICdcnU0dJhxVIssFyzHH+nEdMtyWzVgAjjVDG6mziOMKN
        LE4Gi9uN4Qdbd26l5xRyMEHaOIvzSmGaQFqsVChZc7BGuBP4izhKjAoDtpFTAv9gb+tUsk
        U7Q3emoFQyHjGA4VbjfxmOWudEhs/fM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-zLW1pBvqMNy1e5Z5LdAcwQ-1; Wed, 20 Oct 2021 12:53:36 -0400
X-MC-Unique: zLW1pBvqMNy1e5Z5LdAcwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF92310A8E09;
        Wed, 20 Oct 2021 16:53:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 617CF70886;
        Wed, 20 Oct 2021 16:53:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     zxwang42@gmail.com, marcorr@google.com, seanjc@google.com,
        jroedel@suse.de, varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 1/2] unify structs for GDT descriptors
Date:   Wed, 20 Oct 2021 12:53:32 -0400
Message-Id: <20211020165333.953978-2-pbonzini@redhat.com>
In-Reply-To: <20211020165333.953978-1-pbonzini@redhat.com>
References: <20211020165333.953978-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the same names and definitions (apart from the high base field)
for GDT descriptors.  gdt_entry_t is for 8-byte entries and
gdt_desc_entry_t is for when 64-bit tests should use a 16-byte
entry.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c         | 16 ++++++----------
 lib/x86/desc.h         | 36 ++++++++++++++++++++++++++----------
 x86/svm_tests.c        | 12 ++++++------
 x86/taskswitch.c       |  2 +-
 x86/vmware_backdoors.c |  8 ++++----
 5 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..3d38565 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -285,17 +285,13 @@ void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
 	int num = sel >> 3;
 
 	/* Setup the descriptor base address */
-	gdt32[num].base_low = (base & 0xFFFF);
-	gdt32[num].base_middle = (base >> 16) & 0xFF;
-	gdt32[num].base_high = (base >> 24) & 0xFF;
+	gdt32[num].base1 = (base & 0xFFFF);
+	gdt32[num].base2 = (base >> 16) & 0xFF;
+	gdt32[num].base3 = (base >> 24) & 0xFF;
 
-	/* Setup the descriptor limits */
-	gdt32[num].limit_low = (limit & 0xFFFF);
-	gdt32[num].granularity = ((limit >> 16) & 0x0F);
-
-	/* Finally, set up the granularity and access flags */
-	gdt32[num].granularity |= (gran & 0xF0);
-	gdt32[num].access = access;
+	/* Setup the descriptor limits, granularity and flags */
+	gdt32[num].limit1 = (limit & 0xFFFF);
+	gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((gran & 0xF0) << 8) | access;
 }
 
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..3aa1eca 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -164,15 +164,28 @@ typedef struct {
 } idt_entry_t;
 
 typedef struct {
-	u16 limit_low;
-	u16 base_low;
-	u8 base_middle;
-	u8 access;
-	u8 granularity;
-	u8 base_high;
-} gdt_entry_t;
-
-struct segment_desc64 {
+	uint16_t limit1;
+	uint16_t base1;
+	uint8_t  base2;
+	union {
+		uint16_t  type_limit_flags;      /* Type and limit flags */
+		struct {
+			uint16_t type:4;
+			uint16_t s:1;
+			uint16_t dpl:2;
+			uint16_t p:1;
+			uint16_t limit:4;
+			uint16_t avl:1;
+			uint16_t l:1;
+			uint16_t db:1;
+			uint16_t g:1;
+		} __attribute__((__packed__));
+	} __attribute__((__packed__));
+	uint8_t  base3;
+} __attribute__((__packed__)) gdt_entry_t;
+
+#ifdef __x86_64__
+typedef struct {
 	uint16_t limit1;
 	uint16_t base1;
 	uint8_t  base2;
@@ -193,7 +206,10 @@ struct segment_desc64 {
 	uint8_t  base3;
 	uint32_t base4;
 	uint32_t zero;
-} __attribute__((__packed__));
+} __attribute__((__packed__)) gdt_desc_entry_t;
+#else
+typedef gdt_entry_t gdt_desc_entry_t;
+#endif
 
 #define DESC_BUSY ((uint64_t) 1 << 41)
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index afdd359..014fbbf 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1876,22 +1876,22 @@ static bool reg_corruption_check(struct svm_test *test)
 static void get_tss_entry(void *data)
 {
     struct descriptor_table_ptr gdt;
-    struct segment_desc64 *gdt_table;
-    struct segment_desc64 *tss_entry;
+    gdt_entry_t *gdt_table;
+    gdt_entry_t *tss_entry;
     u16 tr = 0;
 
     sgdt(&gdt);
     tr = str();
-    gdt_table = (struct segment_desc64 *) gdt.base;
-    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
-    *((struct segment_desc64 **)data) = tss_entry;
+    gdt_table = (gdt_entry_t *) gdt.base;
+    tss_entry = &gdt_table[tr / sizeof(gdt_entry_t)];
+    *((gdt_entry_t **)data) = tss_entry;
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    struct segment_desc64 *tss_entry;
+    gdt_entry_t *tss_entry;
     int i;
 
     on_cpu(1, get_tss_entry, &tss_entry);
diff --git a/x86/taskswitch.c b/x86/taskswitch.c
index 889831e..b6b3451 100644
--- a/x86/taskswitch.c
+++ b/x86/taskswitch.c
@@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
 
 	tss.eip += 2;
 
-	gdt32[TSS_MAIN / 8].access &= ~2;
+	gdt32[TSS_MAIN / 8].type &= ~2;
 
 	set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
 }
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index b4902a9..24870d7 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -133,8 +133,8 @@ struct fault_test vmware_backdoor_tests[] = {
 static void set_tss_ioperm(void)
 {
 	struct descriptor_table_ptr gdt;
-	struct segment_desc64 *gdt_table;
-	struct segment_desc64 *tss_entry;
+	gdt_entry_t *gdt_table;
+	gdt_desc_entry_t *tss_entry;
 	u16 tr = 0;
 	tss64_t *tss;
 	unsigned char *ioperm_bitmap;
@@ -142,8 +142,8 @@ static void set_tss_ioperm(void)
 
 	sgdt(&gdt);
 	tr = str();
-	gdt_table = (struct segment_desc64 *) gdt.base;
-	tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
+	gdt_table = (gdt_entry_t *) gdt.base;
+	tss_entry = (gdt_desc_entry_t *) &gdt_table[tr / sizeof(gdt_entry_t)];
 	tss_base = ((uint64_t) tss_entry->base1 |
 			((uint64_t) tss_entry->base2 << 16) |
 			((uint64_t) tss_entry->base3 << 24) |
-- 
2.27.0


