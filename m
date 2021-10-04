Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9244218A8
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhJDUvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbhJDUve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4F3C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:45 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u7so15511016pfg.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LyBROeWt+x+Gb0k2+3naYdgZzhJi/mL+4noCZQs+mh0=;
        b=ZrxK42UXUj443Q+DL5rOArC+4H/EuCu8Iumk9HDsDVX+7uw9OJWCu2Yp6o5JGjXu85
         1xKvSJ5eh1k6gV26nywxIOqjTh5bjxGT46+FO6v7HNVqBtA8CguXdfZxj8U6y+bOHwqy
         NbhhA2Sg/9K1HXuu/22D4nEmJVgpeRzNhjdWgtBzg+EW4tn6EwUBOf+H6pTcftbudc75
         B4G8XIC3uHEL+nXJlLbM9Oc5f5D7HUIoz6Wp8uh6oqhLYVJbqWd5TknVWCSs1Ail0zLl
         gLtOXthoXU+yxDa3O2hXry7vJ3LbMelVPtCHB4rQp+/OgVVy8VTTcMgTGl+1ZCXhY0M1
         ZsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LyBROeWt+x+Gb0k2+3naYdgZzhJi/mL+4noCZQs+mh0=;
        b=fIK+WfcSAWMrSoC/YhQDgRE7Jqlf71l7uYVtPQUpztpfYyRuGkuw6J6f4SHsqdM04A
         /Hq+xdZuPXUBhsODPCS+uk/uBuBbTqQRNLN8Eti3413XyswctfgSQy+WRNtYtF/0dJj/
         fwrGvFRFynPPMsFs3R3eQ8rz8eB7FFngvVTgg+roRx76hOAVRUaXbuJT179tiy2ZoG6Z
         hNLgsjhT6on0+vrYwkYUBhD/9JAAui9fy/uToW7bnaZZGp7Lzs/GrFH+fQkN0Z489DMg
         S8uGMEk/NR3uZMYOpCTPDYzdkIEFknS66eTJf0GQwOaDc/9Y1T9KbLiuOG4Kl9BzeBT9
         QonA==
X-Gm-Message-State: AOAM530LMicW0Z3tVXglIZDQwREo7/aa4xqMREZlqbiSleYdWrNPL0qp
        6ss2RFWdp77zXlZ7vIQZxSPkV6ooe0+xHw==
X-Google-Smtp-Source: ABdhPJyKYy/qr1ghfGRzeW66V9Uj6dipSk23RgdWkP3yLGYh/woDhyqGtVSuMTsRQCAVrdHGu4lp/g==
X-Received: by 2002:a63:1444:: with SMTP id 4mr5591667pgu.251.1633380584385;
        Mon, 04 Oct 2021 13:49:44 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:43 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 07/17] x86 UEFI: Load GDT and TSS after UEFI boot up
Date:   Mon,  4 Oct 2021 13:49:21 -0700
Message-Id: <20211004204931.1537823-8-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

Global Descriptor Table (GDT) defines x86 memory areas, e.g. memory area
for data or code. UEFI has a different GDT compared to KVM-Unit-Tests,
e.g., in UEFI, 3rd GDT entry defines a code segment, while in
KVM-Unit-Tests, 3rd GDT entry is data segment.

Without loading KVM-Unit-Tests GDT, the UEFI GDT is used and is
incompatible with KVM-Unit-Tests. This causes QEMU to silently crash
when a test case changes segments.

This commit fixes this issue by loading KVM-Unit-Tests GDT to replace
UEFI GDT. And since Task State Segment (TSS) is tightly coupled with
GDT, this commit also loads TSS on boot-up.

In this commit, x86/debug.c can run in UEFI and pass all sub-tests.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c      | 10 ++++++++++
 x86/efi/efistart64.S | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 8606fe8..f4f9e1b 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -165,10 +165,20 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 /* From x86/efi/efistart64.S */
 extern void load_idt(void);
+extern void load_gdt_tss(size_t tss_offset);
+
+static void setup_gdt_tss(void)
+{
+	size_t tss_offset;
+
+	tss_offset = setup_tss();
+	load_gdt_tss(tss_offset);
+}
 
 void setup_efi(void)
 {
 	reset_apic();
+	setup_gdt_tss();
 	setup_idt();
 	load_idt();
 	mask_pic_interrupts();
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 41e9185..57299a5 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -1,7 +1,22 @@
 /* Startup code and pre-defined data structures */
 
+#include "apic-defs.h"
+#include "asm-generic/page.h"
 #include "crt0-efi-x86_64.S"
 
+.globl ring0stacktop
+.globl ring0stacksize
+
+max_cpus = MAX_TEST_CPUS
+ring0stacksize = PAGE_SIZE
+
+.bss
+
+.globl ring0stacktop
+	. = . + ring0stacksize * max_cpus
+	.align 16
+ring0stacktop:
+
 .section .init
 .code64
 .text
@@ -10,3 +25,30 @@
 load_idt:
 	lidtq idt_descr(%rip)
 	retq
+
+.globl load_gdt_tss
+load_gdt_tss:
+	/* Load GDT */
+	lgdt gdt64_desc(%rip)
+
+	/* Load TSS */
+	mov %rdi, %rax
+	ltr %ax
+
+	/* Update data segments */
+	mov $0x10, %ax /* 3rd entry in gdt64: 32/64-bit data segment */
+	mov %ax, %ds
+	mov %ax, %es
+	mov %ax, %fs
+	mov %ax, %gs
+	mov %ax, %ss
+
+	/*
+	 * Update the code segment by putting it on the stack before the return
+	 * address, then doing a far return: this will use the new code segment
+	 * along with the address.
+	 */
+	popq %rdi
+	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
+	pushq %rdi
+	lretq
-- 
2.33.0

