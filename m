Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC524360C1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJULvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:51:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231144AbhJULvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 07:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BI/Y6LxjTJXjNe3cl8+nThqvkDQjA77tQjW9CpT4dY=;
        b=KXU09YvP31nBwOfM50fBv5oEoRSkAzR3cCQYBqO4F2GNVAmR+VBaN8UmYI1VzwBPQ87hi9
        IKJ2BLMAWQ7E50Hqi5fAd6Y8jNgRfOzO9ybN2zOWs2fgQH+kqADjfprHBuhi0o0Rlj4RF+
        9w9t5H5e5TaA2ZbdnllVa6HnA+P1Gwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-bu3cHW8VMPa1SHb97WEP5Q-1; Thu, 21 Oct 2021 07:49:17 -0400
X-MC-Unique: bu3cHW8VMPa1SHb97WEP5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAD0E100B3B7;
        Thu, 21 Oct 2021 11:49:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ADE55FC13;
        Thu, 21 Oct 2021 11:49:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     aaronlewis@google.com, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [PATCH kvm-unit-tests 6/9] x86: unify name of 32-bit and 64-bit GDT
Date:   Thu, 21 Oct 2021 07:49:07 -0400
Message-Id: <20211021114910.1347278-7-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-1-pbonzini@redhat.com>
References: <20211021114910.1347278-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no need to distinguish gdt32 and gdt64, since the same C functions
operate on both and selector numbers are mostly unified between 32-
and 64-bit versions.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c   | 12 ++++++------
 lib/x86/desc.h   |  2 +-
 x86/cstart.S     | 20 ++++++++++----------
 x86/cstart64.S   | 17 +++++++++--------
 x86/taskswitch.c |  2 +-
 x86/vmx.c        |  8 ++++----
 x86/vmx_tests.c  |  4 ++--
 7 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 2ef5aad..ac167d0 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -292,16 +292,16 @@ static char intr_alt_stack[4096];
 #ifndef __x86_64__
 void set_gdt_entry(int sel, u32 base,  u32 limit, u8 type, u8 flags)
 {
-	int num = sel >> 3;
+	gdt_entry_t *entry = &gdt[sel >> 3];
 
 	/* Setup the descriptor base address */
-	gdt32[num].base1 = (base & 0xFFFF);
-	gdt32[num].base2 = (base >> 16) & 0xFF;
-	gdt32[num].base3 = (base >> 24) & 0xFF;
+	entry->base1 = (base & 0xFFFF);
+	entry->base2 = (base >> 16) & 0xFF;
+	entry->base3 = (base >> 24) & 0xFF;
 
 	/* Setup the descriptor limits, type and flags */
-	gdt32[num].limit1 = (limit & 0xFFFF);
-	gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
+	entry->limit1 = (limit & 0xFFFF);
+	entry->type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
 }
 
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 51148d1..c0817d8 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -197,7 +197,6 @@ struct system_desc64 {
 extern idt_entry_t boot_idt[256];
 
 #ifndef __x86_64__
-extern gdt_entry_t gdt32[];
 extern tss32_t tss;
 extern tss32_t tss_intr;
 void set_gdt_task_gate(u16 tss_sel, u16 sel);
@@ -207,6 +206,7 @@ void setup_tss32(void);
 #else
 extern tss64_t tss;
 #endif
+extern gdt_entry_t gdt[];
 
 unsigned exception_vector(void);
 int write_cr4_checking(unsigned long val);
diff --git a/x86/cstart.S b/x86/cstart.S
index 4461c38..5e925d8 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -27,8 +27,8 @@ i = 0
         i = i + 1
         .endr
 
-.globl gdt32
-gdt32:
+.globl gdt
+gdt:
 	.quad 0
 	.quad 0x00cf9b000000ffff // flat 32-bit code segment
 	.quad 0x00cf93000000ffff // flat 32-bit data segment
@@ -55,7 +55,7 @@ percpu_descr:
         .rept max_cpus
         .quad 0x00cf93000000ffff // 32-bit data segment for perCPU area
         .endr
-gdt32_end:
+gdt_end:
 
 i = 0
 .globl tss
@@ -94,7 +94,7 @@ mb_cmdline = 16
 	mov %al, percpu_descr+4(,%ecx,8)
 	mov %ah, percpu_descr+7(,%ecx,8)
 
-	lea percpu_descr-gdt32(,%ecx,8), %eax
+	lea percpu_descr-gdt(,%ecx,8), %eax
 	mov %ax, %gs
 
 .endm
@@ -110,7 +110,7 @@ mb_cmdline = 16
 
 .globl start
 start:
-        lgdtl gdt32_descr
+        lgdtl gdt_descr
         setup_segments
         mov $stacktop, %esp
         setup_percpu_area
@@ -195,7 +195,7 @@ load_tss:
 	shr $16, %eax
 	mov %al, tss_descr+4(,%ebx,8)
 	mov %ah, tss_descr+7(,%ebx,8)
-	lea tss_descr-gdt32(,%ebx,8), %eax
+	lea tss_descr-gdt(,%ebx,8), %eax
 	ltr %ax
 	ret
 
@@ -224,11 +224,11 @@ sipi_entry:
 	mov %cr0, %eax
 	or $1, %eax
 	mov %eax, %cr0
-	lgdtl gdt32_descr - sipi_entry
+	lgdtl gdt_descr - sipi_entry
 	ljmpl $8, $ap_start32
 
-gdt32_descr:
-	.word gdt32_end - gdt32 - 1
-	.long gdt32
+gdt_descr:
+	.word gdt_end - gdt - 1
+	.long gdt
 
 sipi_end:
diff --git a/x86/cstart64.S b/x86/cstart64.S
index b98a0d3..46b9d9b 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -1,7 +1,8 @@
 
 #include "apic-defs.h"
 
-.globl gdt64_desc
+.globl gdt
+.globl gdt_descr
 .globl online_cpus
 .globl cpu_online_count
 
@@ -47,11 +48,11 @@ ptl5:
 
 .align 4096
 
-gdt64_desc:
-	.word gdt64_end - gdt64 - 1
-	.quad gdt64
+gdt_descr:
+	.word gdt_end - gdt - 1
+	.quad gdt
 
-gdt64:
+gdt:
 	.quad 0
 	.quad 0x00af9b000000ffff // 64-bit code segment
 	.quad 0x00cf93000000ffff // 32/64-bit data segment
@@ -75,7 +76,7 @@ tss_descr:
 	.quad 0x000089000000ffff // 64-bit avail tss
 	.quad 0                  // tss high addr
 	.endr
-gdt64_end:
+gdt_end:
 
 i = 0
 .globl tss
@@ -162,7 +163,7 @@ switch_to_5level:
 	jmpl $8, $lvl5
 
 prepare_64:
-	lgdt gdt64_desc
+	lgdt gdt_descr
 	setup_segments
 
 	xor %eax, %eax
@@ -300,7 +301,7 @@ load_tss:
 	mov %al, tss_descr+7(%rbx)
 	shr $8, %rax
 	mov %eax, tss_descr+8(%rbx)
-	lea tss_descr-gdt64(%rbx), %rax
+	lea tss_descr-gdt(%rbx), %rax
 	ltr %ax
 	ret
 
diff --git a/x86/taskswitch.c b/x86/taskswitch.c
index 0fa818d..1d6e6e2 100644
--- a/x86/taskswitch.c
+++ b/x86/taskswitch.c
@@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
 
 	tss.eip += 2;
 
-	gdt32[TSS_MAIN / 8].type &= ~DESC_BUSY;
+	gdt[TSS_MAIN / 8].type &= ~DESC_BUSY;
 
 	set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
 }
diff --git a/x86/vmx.c b/x86/vmx.c
index d45c6de..7a2f7a3 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -73,7 +73,7 @@ union vmx_ctrl_msr ctrl_exit_rev;
 union vmx_ctrl_msr ctrl_enter_rev;
 union vmx_ept_vpid  ept_vpid;
 
-extern struct descriptor_table_ptr gdt64_desc;
+extern struct descriptor_table_ptr gdt_descr;
 extern struct descriptor_table_ptr idt_descr;
 extern void *vmx_return;
 extern void *entry_sysenter;
@@ -1275,7 +1275,7 @@ static void init_vmcs_host(void)
 	vmcs_write(HOST_SEL_GS, KERNEL_DS);
 	vmcs_write(HOST_SEL_TR, TSS_MAIN);
 	vmcs_write(HOST_BASE_TR, get_gdt_entry_base(get_tss_descr()));
-	vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
+	vmcs_write(HOST_BASE_GDTR, gdt_descr.base);
 	vmcs_write(HOST_BASE_IDTR, idt_descr.base);
 	vmcs_write(HOST_BASE_FS, 0);
 	vmcs_write(HOST_BASE_GS, 0);
@@ -1354,9 +1354,9 @@ static void init_vmcs_guest(void)
 	vmcs_write(GUEST_AR_TR, 0x8b);
 
 	/* 26.3.1.3 */
-	vmcs_write(GUEST_BASE_GDTR, gdt64_desc.base);
+	vmcs_write(GUEST_BASE_GDTR, gdt_descr.base);
 	vmcs_write(GUEST_BASE_IDTR, idt_descr.base);
-	vmcs_write(GUEST_LIMIT_GDTR, gdt64_desc.limit);
+	vmcs_write(GUEST_LIMIT_GDTR, gdt_descr.limit);
 	vmcs_write(GUEST_LIMIT_IDTR, idt_descr.limit);
 
 	/* 26.3.1.4 */
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ac2b0b4..9ee6653 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -797,8 +797,8 @@ asm(
 	"insn_wbinvd: wbinvd;ret\n\t"
 	"insn_cpuid: mov $10, %eax; cpuid;ret\n\t"
 	"insn_invd: invd;ret\n\t"
-	"insn_sgdt: sgdt gdt64_desc;ret\n\t"
-	"insn_lgdt: lgdt gdt64_desc;ret\n\t"
+	"insn_sgdt: sgdt gdt_descr;ret\n\t"
+	"insn_lgdt: lgdt gdt_descr;ret\n\t"
 	"insn_sidt: sidt idt_descr;ret\n\t"
 	"insn_lidt: lidt idt_descr;ret\n\t"
 	"insn_sldt: sldt %ax;ret\n\t"
-- 
2.27.0


