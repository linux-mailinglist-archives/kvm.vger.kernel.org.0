Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D410A368D64
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 08:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbhDWGyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 02:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240743AbhDWGyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 02:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619160827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YXcaDNtwz3ucxJL+QAv1pl2x/JuMrGE4EhM2LwyjCSc=;
        b=SY9NwrA48EXHZNsC03qXWCEQsBeQKHQgCUphSVcK4tvbVR49I4Uj42QqtQi+poGO1BiHHg
        gkNSKjae9qiSw0piu6GnSeDQZ4qoIsn++VXtbjg/8u8kN3CynBr2YEMsG17DIDTd2fgF/C
        Gf9b8Oj5jAtfenfCvfkh+DMxP+9XlGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-D7xAQQpiPn2L_dZvxmilZw-1; Fri, 23 Apr 2021 02:53:44 -0400
X-MC-Unique: D7xAQQpiPn2L_dZvxmilZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E86343A2;
        Fri, 23 Apr 2021 06:53:43 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DEED10016FE;
        Fri, 23 Apr 2021 06:53:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Subject: [PATCH kvm-unit-tests] x86/cstart: Don't use MSR_GS_BASE in 32-bit boot code
Date:   Fri, 23 Apr 2021 02:53:42 -0400
Message-Id: <20210423065342.1701726-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add per-cpu selectors to the GDT, and set GS_BASE by
loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
code works only because 32-bit KVM VMX incorrectly disables interception
of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
i.e. the MSR exists in hardware and so everything "works".

32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
the tests have never worked on 32-bit SVM.

While at it, tweak the TSS setup to look like the percpu setup; both
are setting up the address field of the descriptor.

Fixes: dfe6cb6 ("Add 32 bit smp initialization code")
Reported-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422030504.3488253-2-seanjc@google.com>
[Patch rewritten, keeping Sean's commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c |  3 ++-
 lib/x86/desc.h |  5 +++--
 x86/cstart.S   | 35 ++++++++++++++++++++++-------------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 983d4d8..2672e02 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -333,7 +333,8 @@ void setup_tss32(void)
 	tss_intr.esp = tss_intr.esp0 = tss_intr.esp1 = tss_intr.esp2 =
 		(u32)intr_alt_stack + 4096;
 	tss_intr.cs = 0x08;
-	tss_intr.ds = tss_intr.es = tss_intr.fs = tss_intr.gs = tss_intr.ss = 0x10;
+	tss_intr.ds = tss_intr.es = tss_intr.fs = tss_intr.ss = 0x10;
+	tss_intr.gs = read_gs();
 	tss_intr.iomap_base = (u16)desc_size;
 	set_gdt_entry(TSS_INTR, (u32)&tss_intr, desc_size - 1, 0x89, 0x0f);
 }
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 0fe5cbf..77b2c59 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -103,8 +103,9 @@ typedef struct  __attribute__((packed)) {
  * 0x38 (0x3b)  ring-3 code segment (32-bit)  same
  * 0x40 (0x43)  ring-3 data segment (32-bit)  ring-3 data segment (32/64-bit)
  * 0x48 (0x4b)  **unused**                    ring-3 code segment (64-bit)
- * 0x50--0x78   free to use for test cases    same
- * 0x80         primary TSS (CPU 0)           same
+ * 0x50-0x78    free to use for test cases    same
+ * 0x80-0x870   primary TSS (CPU 0..254)      same
+ * 0x878-0x1068 percpu area (CPU 0..254)      not used
  *
  * Note that the same segment can be used for 32-bit and 64-bit data segments
  * (the L bit is only defined for code segments)
diff --git a/x86/cstart.S b/x86/cstart.S
index 489c561..bcf7218 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -58,6 +58,10 @@ tss_descr:
         .rept max_cpus
         .quad 0x000089000000ffff // 32-bit avail tss
         .endr
+percpu_descr:
+        .rept max_cpus
+        .quad 0x00cf93000000ffff // 32-bit data segment for perCPU area
+        .endr
 gdt32_end:
 
 i = 0
@@ -89,13 +93,21 @@ mb_flags = 0x0
 	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
 mb_cmdline = 16
 
-MSR_GS_BASE = 0xc0000101
-
 .macro setup_percpu_area
 	lea -4096(%esp), %eax
-	mov $0, %edx
-	mov $MSR_GS_BASE, %ecx
-	wrmsr
+
+	/* fill GS_BASE in the GDT, do not clobber %ebx (multiboot info) */
+	mov (APIC_DEFAULT_PHYS_BASE + APIC_ID), %ecx
+	shr $24, %ecx
+	mov %ax, percpu_descr+2(,%ecx,8)
+
+	shr $16, %eax
+	mov %al, percpu_descr+4(,%ecx,8)
+	mov %ah, percpu_descr+7(,%ecx,8)
+
+	lea percpu_descr-gdt32(,%ecx,8), %eax
+	mov %ax, %gs
+
 .endm
 
 .macro setup_segments
@@ -184,20 +196,17 @@ load_tss:
 	lidt idt_descr
 	mov $16, %eax
 	mov %ax, %ss
-	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-	mov (%eax), %eax
+	mov (APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	shr $24, %eax
 	mov %eax, %ebx
-	shl $3, %ebx
 	mov $((tss_end - tss) / max_cpus), %edx
 	imul %edx
 	add $tss, %eax
-	mov %ax, tss_descr+2(%ebx)
+	mov %ax, tss_descr+2(,%ebx,8)
 	shr $16, %eax
-	mov %al, tss_descr+4(%ebx)
-	shr $8, %eax
-	mov %al, tss_descr+7(%ebx)
-	lea tss_descr-gdt32(%ebx), %eax
+	mov %al, tss_descr+4(,%ebx,8)
+	mov %ah, tss_descr+7(,%ebx,8)
+	lea tss_descr-gdt32(,%ebx,8), %eax
 	ltr %ax
 	ret
 
-- 
2.26.2

