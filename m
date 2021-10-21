Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AD14360BF
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhJULvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhJULvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CC7pSnjT0MwNGEy4m2Tuc7yoNJ72PfE6tCN9v956HuI=;
        b=bDDYgeFRJBXb1LCQ5by4aOK2wuONoQbz4mHfjqJ4krsVg6t9+erN+0xX/oJY5V9ve3WLEB
        Z32MxG3P6ATwZCe5GR5WmD+zU+L6Tka1hm38+SZUPIdF3wCPQuYGnQqI6ZeNyFPahyNm9k
        cIKF/5ZwwOP5bOhpKlbqw9SDq5ztwIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-bnk1OyYDP9WNAUGmLQMCYg-1; Thu, 21 Oct 2021 07:49:16 -0400
X-MC-Unique: bnk1OyYDP9WNAUGmLQMCYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0237110B3948;
        Thu, 21 Oct 2021 11:49:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586C95FC13;
        Thu, 21 Oct 2021 11:49:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 5/9] x86: Move IDT to desc.c
Date:   Thu, 21 Oct 2021 07:49:06 -0400
Message-Id: <20211021114910.1347278-6-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
References: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the IDT data structures from x86/cstart.S and x86/cstart64.S to
lib/x86/desc.c, so that the follow-up UEFI support commits can reuse
these definitions, without re-defining them in UEFI's boot up assembly
code.

Extracted by a patch by Zixuan Wang <zxwang42@gmail.com> and ported
to 32-bit too.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c | 10 ++++++++++
 x86/cstart.S   | 11 -----------
 x86/cstart64.S | 14 --------------
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 94f0ddb..2ef5aad 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -3,6 +3,16 @@
 #include "processor.h"
 #include <setjmp.h>
 
+/* Boot-related data structures */
+
+/* IDT and IDT descriptor */
+idt_entry_t boot_idt[256] = {0};
+
+struct descriptor_table_ptr idt_descr = {
+	.limit = sizeof(boot_idt) - 1,
+	.base = (unsigned long)boot_idt,
+};
+
 #ifndef __x86_64__
 __attribute__((regparm(1)))
 #endif
diff --git a/x86/cstart.S b/x86/cstart.S
index bcf7218..4461c38 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -1,7 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl boot_idt
 .global online_cpus
 
 ipi_vector = 0x20
@@ -28,12 +27,6 @@ i = 0
         i = i + 1
         .endr
 
-boot_idt:
-	.rept 256
-	.quad 0
-	.endr
-end_boot_idt:
-
 .globl gdt32
 gdt32:
 	.quad 0
@@ -78,10 +71,6 @@ tss:
         .endr
 tss_end:
 
-idt_descr:
-	.word end_boot_idt - boot_idt - 1
-	.long boot_idt
-
 .section .init
 
 .code32
diff --git a/x86/cstart64.S b/x86/cstart64.S
index cf38bae..b98a0d3 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,9 +1,6 @@
 
 #include "apic-defs.h"
 
-.globl boot_idt
-
-.globl idt_descr
 .globl gdt64_desc
 .globl online_cpus
 .globl cpu_online_count
@@ -50,13 +47,6 @@ ptl5:
 
 .align 4096
 
-boot_idt:
-	.rept 256
-	.quad 0
-	.quad 0
-	.endr
-end_boot_idt:
-
 gdt64_desc:
 	.word gdt64_end - gdt64 - 1
 	.quad gdt64
@@ -290,10 +280,6 @@ setup_5level_page_table:
 lvl5:
 	retq
 
-idt_descr:
-	.word end_boot_idt - boot_idt - 1
-	.quad boot_idt
-
 online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
-- 
2.27.0


