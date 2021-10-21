Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812FF435CDF
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhJUIbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhJUIbY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 04:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634804948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csNBW+SL+Tkhi5Lrul1i7on2JECHfvEBYSvmf9oCWXQ=;
        b=gbjMRRB7b1789QPn+h3Ci7mAjJkRLV634GIanLAuJwR5+SpHXptODJC4hGEYqsMWtK/Xiw
        BRItcd2IaMr5iVUStNYLhedg/G4uFqZLtDM2dyDfgfgny/Yr0PRzozYi3s6PorsaeWAmoc
        LdolRWndOpKcUAABdH32AqcbwSTyENQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-CXYE45ErONesE7XpKkbuXg-1; Thu, 21 Oct 2021 04:29:04 -0400
X-MC-Unique: CXYE45ErONesE7XpKkbuXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C26D189CD39;
        Thu, 21 Oct 2021 08:29:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A185B19D9F;
        Thu, 21 Oct 2021 08:29:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com,
        aaronlewis@google.com
Subject: [PATCH kvm-unit-tests 1/4] x86: cleanup handling of 16-byte GDT descriptors
Date:   Thu, 21 Oct 2021 04:28:57 -0400
Message-Id: <20211021082900.997844-2-pbonzini@redhat.com>
In-Reply-To: <20211021082900.997844-1-pbonzini@redhat.com>
References: <20211021082900.997844-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Look them up using a gdt_entry_t pointer, so that the address of
the descriptor is correct even for "odd" selectors (e.g. 0x98).
Rename the struct from segment_desc64 to system_desc64,
highlighting that it is only used in the case of S=0 (system
descriptor).  Rename the "limit" bitfield to "limit2", matching
the convention used for the various parts of the base field.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.h         |  4 ++--
 x86/svm_tests.c        | 12 ++++++------
 x86/vmware_backdoors.c |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..1755486 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -172,7 +172,7 @@ typedef struct {
 	u8 base_high;
 } gdt_entry_t;
 
-struct segment_desc64 {
+struct system_desc64 {
 	uint16_t limit1;
 	uint16_t base1;
 	uint8_t  base2;
@@ -183,7 +183,7 @@ struct segment_desc64 {
 			uint16_t s:1;
 			uint16_t dpl:2;
 			uint16_t p:1;
-			uint16_t limit:4;
+			uint16_t limit2:4;
 			uint16_t avl:1;
 			uint16_t l:1;
 			uint16_t db:1;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index afdd359..2fdb0dc 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1876,22 +1876,22 @@ static bool reg_corruption_check(struct svm_test *test)
 static void get_tss_entry(void *data)
 {
     struct descriptor_table_ptr gdt;
-    struct segment_desc64 *gdt_table;
-    struct segment_desc64 *tss_entry;
+    gdt_entry_t *gdt_table;
+    struct system_desc64 *tss_entry;
     u16 tr = 0;
 
     sgdt(&gdt);
     tr = str();
-    gdt_table = (struct segment_desc64 *) gdt.base;
-    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
-    *((struct segment_desc64 **)data) = tss_entry;
+    gdt_table = (gdt_entry_t *) gdt.base;
+    tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
+    *((struct system_desc64 **)data) = tss_entry;
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    struct segment_desc64 *tss_entry;
+    struct system_desc64 *tss_entry;
     int i;
 
     on_cpu(1, get_tss_entry, &tss_entry);
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index b4902a9..b1433cd 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -133,8 +133,8 @@ struct fault_test vmware_backdoor_tests[] = {
 static void set_tss_ioperm(void)
 {
 	struct descriptor_table_ptr gdt;
-	struct segment_desc64 *gdt_table;
-	struct segment_desc64 *tss_entry;
+	gdt_entry_t *gdt_table;
+	struct system_desc64 *tss_entry;
 	u16 tr = 0;
 	tss64_t *tss;
 	unsigned char *ioperm_bitmap;
@@ -142,8 +142,8 @@ static void set_tss_ioperm(void)
 
 	sgdt(&gdt);
 	tr = str();
-	gdt_table = (struct segment_desc64 *) gdt.base;
-	tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
+	gdt_table = (gdt_entry_t *) gdt.base;
+	tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
 	tss_base = ((uint64_t) tss_entry->base1 |
 			((uint64_t) tss_entry->base2 << 16) |
 			((uint64_t) tss_entry->base3 << 24) |
-- 
2.27.0


