Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADF04350B9
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhJTQzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 12:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhJTQzx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 12:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634748818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ll4n7s3dexrayjfesujflmbcY+o7If+yA1iz+Bm2Ca0=;
        b=Y/IznajXgwzFAWzGQuTv3rK8CMkmpv9LFcdMOtQbtoGDOqbnPf1KB1JRFuZoEuF7O3jygl
        /7sOpKm5TLMonIQOvUEHEf8Hn+KlyKEDk71XizcQGHpnqIlpMT9is1xeCHu+XWLPTuWAzi
        0gMXm9bAV4Nv/MdXSVK7Odzq1OuYpmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-tnejkAF9MeGH1yjyaWFkXg-1; Wed, 20 Oct 2021 12:53:36 -0400
X-MC-Unique: tnejkAF9MeGH1yjyaWFkXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ADD01006AA3;
        Wed, 20 Oct 2021 16:53:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 058E560936;
        Wed, 20 Oct 2021 16:53:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     zxwang42@gmail.com, marcorr@google.com, seanjc@google.com,
        jroedel@suse.de, varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 2/2] replace tss_descr global with a function
Date:   Wed, 20 Oct 2021 12:53:33 -0400
Message-Id: <20211020165333.953978-3-pbonzini@redhat.com>
In-Reply-To: <20211020165333.953978-1-pbonzini@redhat.com>
References: <20211020165333.953978-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tss_descr is declared as a struct descriptor_table_ptr but it is actualy
pointing to an _entry_ in the GDT.  Also it is different per CPU, but
tss_descr does not recognize that.  Fix both by reusing the code
(already present e.g. in the vmware_backdoors test) that extracts
the base from the GDT entry; and also provide a helper to retrieve
the limit, which is needed in vmx.c.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c         | 10 ++++++++++
 lib/x86/desc.h         | 22 +++++++++++++++++++++-
 x86/cstart64.S         |  1 -
 x86/svm_tests.c        | 15 +++------------
 x86/vmware_backdoors.c | 20 +++++---------------
 x86/vmx.c              |  9 +++++----
 6 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 3d38565..ec06a53 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -409,3 +409,13 @@ void __set_exception_jmpbuf(jmp_buf *addr)
 {
 	exception_jmpbuf = addr;
 }
+
+gdt_desc_entry_t *get_tss_descr(void)
+{
+	struct descriptor_table_ptr gdt_ptr;
+	u8 *gdt;
+
+	sgdt(&gdt_ptr);
+	gdt = (u8 *)gdt_ptr.base;
+	return (gdt_desc_entry_t *) (gdt + (str() & ~7));
+}
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 3aa1eca..cd4d2e7 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -211,7 +211,7 @@ typedef struct {
 typedef gdt_entry_t gdt_desc_entry_t;
 #endif
 
-#define DESC_BUSY ((uint64_t) 1 << 41)
+#define DESC_BUSY 2
 
 extern idt_entry_t boot_idt[256];
 
@@ -255,4 +255,16 @@ static inline void *get_idt_addr(idt_entry_t *entry)
 	return (void *)addr;
 }
 
+extern gdt_desc_entry_t *get_tss_descr(void);
+
+static inline unsigned long get_gdt_entry_base(gdt_desc_entry_t *entry)
+{
+	unsigned long base;
+	base = entry->base1 | ((u32)entry->base2 << 16) | ((u32)entry->base3 << 24);
+#ifdef __x86_64__
+	base |= (u64)entry->base4 << 32;
+#endif
+	return base;
+}
+
 #endif
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..cf38bae 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -4,7 +4,6 @@
 .globl boot_idt
 
 .globl idt_descr
-.globl tss_descr
 .globl gdt64_desc
 .globl online_cpus
 .globl cpu_online_count
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 014fbbf..b663c5e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1875,23 +1875,14 @@ static bool reg_corruption_check(struct svm_test *test)
 
 static void get_tss_entry(void *data)
 {
-    struct descriptor_table_ptr gdt;
-    gdt_entry_t *gdt_table;
-    gdt_entry_t *tss_entry;
-    u16 tr = 0;
-
-    sgdt(&gdt);
-    tr = str();
-    gdt_table = (gdt_entry_t *) gdt.base;
-    tss_entry = &gdt_table[tr / sizeof(gdt_entry_t)];
-    *((gdt_entry_t **)data) = tss_entry;
+    *((gdt_desc_entry_t **)data) = get_tss_descr();
 }
 
 static int orig_cpu_count;
 
 static void init_startup_prepare(struct svm_test *test)
 {
-    gdt_entry_t *tss_entry;
+    gdt_desc_entry_t *tss_entry;
     int i;
 
     on_cpu(1, get_tss_entry, &tss_entry);
@@ -1905,7 +1896,7 @@ static void init_startup_prepare(struct svm_test *test)
 
     --cpu_online_count;
 
-    *(uint64_t *)tss_entry &= ~DESC_BUSY;
+    tss_entry->type &= ~DESC_BUSY;
 
     apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
 
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index 24870d7..85b7c09 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -132,23 +132,13 @@ struct fault_test vmware_backdoor_tests[] = {
  */
 static void set_tss_ioperm(void)
 {
-	struct descriptor_table_ptr gdt;
-	gdt_entry_t *gdt_table;
 	gdt_desc_entry_t *tss_entry;
-	u16 tr = 0;
 	tss64_t *tss;
 	unsigned char *ioperm_bitmap;
-	uint64_t tss_base;
-
-	sgdt(&gdt);
-	tr = str();
-	gdt_table = (gdt_entry_t *) gdt.base;
-	tss_entry = (gdt_desc_entry_t *) &gdt_table[tr / sizeof(gdt_entry_t)];
-	tss_base = ((uint64_t) tss_entry->base1 |
-			((uint64_t) tss_entry->base2 << 16) |
-			((uint64_t) tss_entry->base3 << 24) |
-			((uint64_t) tss_entry->base4 << 32));
-	tss = (tss64_t *)tss_base;
+	u16 tr = str();
+
+	tss_entry = get_tss_descr();
+	tss = (tss64_t *)get_gdt_entry_base(tss_entry);
 	tss->iomap_base = sizeof(*tss);
 	ioperm_bitmap = ((unsigned char *)tss+tss->iomap_base);
 
@@ -157,7 +147,7 @@ static void set_tss_ioperm(void)
 		1 << (RANDOM_IO_PORT % 8);
 	ioperm_bitmap[VMWARE_BACKDOOR_PORT / 8] |=
 		1 << (VMWARE_BACKDOOR_PORT % 8);
-	*(uint64_t *)tss_entry &= ~DESC_BUSY;
+	tss_entry->type &= ~DESC_BUSY;
 
 	/* Update TSS */
 	ltr(tr);
diff --git a/x86/vmx.c b/x86/vmx.c
index 20dc677..bfa05ce 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -75,7 +75,6 @@ union vmx_ept_vpid  ept_vpid;
 
 extern struct descriptor_table_ptr gdt64_desc;
 extern struct descriptor_table_ptr idt_descr;
-extern struct descriptor_table_ptr tss_descr;
 extern void *vmx_return;
 extern void *entry_sysenter;
 extern void *guest_entry;
@@ -1275,7 +1274,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_SEL_FS, KERNEL_DS);
 	vmcs_write(HOST_SEL_GS, KERNEL_DS);
 	vmcs_write(HOST_SEL_TR, TSS_MAIN);
-	vmcs_write(HOST_BASE_TR, tss_descr.base);
+	vmcs_write(HOST_BASE_TR, get_gdt_entry_base(get_tss_descr()));
 	vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
@@ -1291,6 +1290,8 @@ static void init_vmcs_host(void)
 
 static void init_vmcs_guest(void)
 {
+	gdt_desc_entry_t *tss_descr = get_tss_descr();
+
 	/* 26.3 CHECKING AND LOADING GUEST STATE */
 	ulong guest_cr0, guest_cr4, guest_cr3;
 	/* 26.3.1.1 */
@@ -1331,7 +1332,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_BASE_DS, 0);
 	vmcs_write(GUEST_BASE_FS, 0);
 	vmcs_write(GUEST_BASE_GS, 0);
-	vmcs_write(GUEST_BASE_TR, tss_descr.base);
+	vmcs_write(GUEST_BASE_TR, get_gdt_entry_base(tss_descr));
 	vmcs_write(GUEST_BASE_LDTR, 0);
 
 	vmcs_write(GUEST_LIMIT_CS, 0xFFFFFFFF);
@@ -1341,7 +1342,7 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_LIMIT_FS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_GS, 0xFFFFFFFF);
 	vmcs_write(GUEST_LIMIT_LDTR, 0xffff);
-	vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
+	vmcs_write(GUEST_LIMIT_TR, 0x67);
 
 	vmcs_write(GUEST_AR_CS, 0xa09b);
 	vmcs_write(GUEST_AR_DS, 0xc093);
-- 
2.27.0

