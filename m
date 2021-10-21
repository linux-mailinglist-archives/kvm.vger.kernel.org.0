Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB43D4360BE
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhJULvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhJULve (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HQNGkPvm5UOIpbjNPqjM9oV8BlCmKNUF2GDOIHGyeo=;
        b=CGrqqYcAqiqQgiZzWDoU8sn7u3Xo6O2pyeZzE4gwdrOcspIjbLF3If6F2F2Ae/+ZotL30L
        z5IbyxMQRYXjreL9J0fLXDeDHRKsGKLV2M7d+1PM6gw3itZapd8oURK3ckRZTJ37XnFtqW
        XyanF9FgAUfPTN2KnqhbrIU+iFaVAd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-v8Me82RZMs2KontyzKh3Tw-1; Thu, 21 Oct 2021 07:49:14 -0400
X-MC-Unique: v8Me82RZMs2KontyzKh3Tw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7964C10B3940;
        Thu, 21 Oct 2021 11:49:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF6A45FC13;
        Thu, 21 Oct 2021 11:49:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 3/9] unify field names and definitions for GDT descriptors
Date:   Thu, 21 Oct 2021 07:49:04 -0400
Message-Id: <20211021114910.1347278-4-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
References: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the same names and definitions (apart from the high base field)
for GDT descriptors in both 32-bit and 64-bit code.  The next patch
will also reuse gdt_entry_t in the 16-byte struct definition, for now
some duplication remains.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c   | 18 +++++++-----------
 lib/x86/desc.h   | 28 +++++++++++++++++++++-------
 x86/taskswitch.c |  2 +-
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index b691c9b..ba0db65 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -280,22 +280,18 @@ bool exception_rflags_rf(void)
 static char intr_alt_stack[4096];
 
 #ifndef __x86_64__
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
+void set_gdt_entry(int sel, u32 base,  u32 limit, u8 type, u8 flags)
 {
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
+	/* Setup the descriptor limits, type and flags */
+	gdt32[num].limit1 = (limit & 0xFFFF);
+	gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
 }
 
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 1755486..c339e0e 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -164,14 +164,27 @@ typedef struct {
 } idt_entry_t;
 
 typedef struct {
-	u16 limit_low;
-	u16 base_low;
-	u8 base_middle;
-	u8 access;
-	u8 granularity;
-	u8 base_high;
-} gdt_entry_t;
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
+			uint16_t limit2:4;
+			uint16_t avl:1;
+			uint16_t l:1;
+			uint16_t db:1;
+			uint16_t g:1;
+		} __attribute__((__packed__));
+	} __attribute__((__packed__));
+	uint8_t  base3;
+} __attribute__((__packed__)) gdt_entry_t;
 
+#ifdef __x86_64__
 struct system_desc64 {
 	uint16_t limit1;
 	uint16_t base1;
@@ -194,6 +207,7 @@ struct system_desc64 {
 	uint32_t base4;
 	uint32_t zero;
 } __attribute__((__packed__));
+#endif
 
 #define DESC_BUSY ((uint64_t) 1 << 41)
 
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
-- 
2.27.0


