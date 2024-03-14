Return-Path: <kvm+bounces-11866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8863987C672
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1CE1C20E68
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CE559B78;
	Thu, 14 Mar 2024 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PDU6SjHL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1859158128
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458833; cv=none; b=dUVvYnSzlMWXbxzkhSAoXR6A1MeFt5K3Ud6+AvLB1/ftXkP+WT91b+yjSinFspdK14u/jLTEwcpj/I+HzcsLWnkfkNm3WqztvtW79naa9gIPjTvO75WKExEvfEipnmcPxUKHpKK9Hie5ftse0LxhABV5tatFG/DgeaN6kuy30sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458833; c=relaxed/simple;
	bh=qWhpgLuBEkNbF4sWd8Qyyuj/eXZbAUhHOG7QIgE936U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WqIU55RxlrkvSE0UyLibaIIeLg67v5QJaSQXvV75t426GgBqlTfzH9mfvuBHW0GV6NRCDT58cviMkKKPif057Kqqh01c/JHubuSHR8LXifZ+7vwMlirNLAi913fmlpRrdbWGmHCKT2bvVr6NXtkKCXmjrW3pBc3x2eQxxCrO/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PDU6SjHL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6d3768d06so1015539b3a.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458831; x=1711063631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IJnvo3GlUCWm+9Z87DTK6fPvvH2dyec9Q+4IWGvi0gE=;
        b=PDU6SjHLYonkolyLRZFT6/z+e5ZIXkCgyiHaR2Ez7hDE6uAfaeEqzwlkqvUVsYLID1
         Sj0RtNcMYTYDeHDfpv7LugM1cSMd2WMHxAbbH/4Ad76pGNRiOLQaj9pezQLQ1MRtVtnU
         /L7urqhEFS2cAQeIuPZgmNSG5FNQOPUKjZ+ANCfIkO3luBZnrfG9JcjdxCWE9z2Fk/GS
         r2dZQ6pKpLSXqco/+XmQOGmUY4vBrPgH/aUC/2nwzeUPMKcr23voLGTRH6N4es/10WxD
         Mq7ESRdGbLDQe/B6DjGMTQWGSIHJQxkbkwCLXQBySckvrKZ55PcCsK+Nk15ln2asWTH6
         zqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458831; x=1711063631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IJnvo3GlUCWm+9Z87DTK6fPvvH2dyec9Q+4IWGvi0gE=;
        b=eJAZtlGYRnWehfO68UDrc97tI1mXQVhQS2AGMEZ58sqDz3a9qjxI9vGGj8xu8r6dcQ
         3nbSQ8zB/g3YtHdGoY1Jqf9dl2YVXlV91hL2CftZnhkHFkVwzHKfSVCgAzo8Kfs4CZOE
         cYNc8kyy0Qm4K+LHHnKa3djjmzuW0NFx/9pqehpwFUbR5qFW5QpgtpOr3ORBKc9TBIjn
         +rpJ28Glysk6gHO+bVx2TdyqkHYw8Nlyr9Ueu+IqtGiPVyy4ZSGcYt3B2FRreJ36CmbU
         /d6JcT6/fcmqGt2g0utiv8h6EAkApjjXjt/aCJELnr4N1724vIt9J/hBnoPCoDs8Iusc
         qO/A==
X-Forwarded-Encrypted: i=1; AJvYcCWVZlxI+XUJ9qPLxEYQIWlVkc3ylYeXXavUvZhVw0pRGratL9mUR5cAB/LAwrBRuYF6nZBUuJ7XdwSPzYnlQ6MuGpm3
X-Gm-Message-State: AOJu0YxCBRznX+TjdK3YxS2nJXxxioszkss3BS/A8Mn55z3NDFq5403L
	RkUBm9ysmIK6oUNaOHQgx2dKtPATQHwOOlgPMr73pkABvIYJeFnoF2QH0GBjvWszqHx4DiAnANa
	+NA==
X-Google-Smtp-Source: AGHT+IFXKsJZcktPEDJdv6TjhHXL21Zrt9AN04hKeTmJyyHIm5kk/8ldZSE0dO0H/MtumtcqHIdX1BiKE5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:234c:b0:6e6:c38e:e9e3 with SMTP id
 j12-20020a056a00234c00b006e6c38ee9e3mr134457pfj.4.1710458831465; Thu, 14 Mar
 2024 16:27:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:36 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-18-seanjc@google.com>
Subject: [PATCH 17/18] KVM: selftests: Init x86's segments during VM creation
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Initialize x86's various segments in the GDT during creation of relevant
VMs instead of waiting until vCPUs come along.  Re-installing the segments
for every vCPU is both wasteful and confusing, as is installing KERNEL_DS
multiple times; NOT installing KERNEL_DS for GS is icing on the cake.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 68 ++++++-------------
 1 file changed, 20 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 67235013f6f9..dab719ee7734 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -438,24 +438,7 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
 		desc->base3 = segp->base >> 32;
 }
 
-
-/*
- * Set Long Mode Flat Kernel Code Segment
- *
- * Input Args:
- *   vm - VM whose GDT is being filled, or NULL to only write segp
- *   selector - selector value
- *
- * Output Args:
- *   segp - Pointer to KVM segment
- *
- * Return: None
- *
- * Sets up the KVM segment pointed to by @segp, to be a code segment
- * with the selector value given by @selector.
- */
-static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
-	struct kvm_segment *segp)
+static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->selector = selector;
@@ -467,27 +450,9 @@ static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
 	segp->g = true;
 	segp->l = true;
 	segp->present = 1;
-	if (vm)
-		kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-/*
- * Set Long Mode Flat Kernel Data Segment
- *
- * Input Args:
- *   vm - VM whose GDT is being filled, or NULL to only write segp
- *   selector - selector value
- *
- * Output Args:
- *   segp - Pointer to KVM segment
- *
- * Return: None
- *
- * Sets up the KVM segment pointed to by @segp, to be a data segment
- * with the selector value given by @selector.
- */
-static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
-	struct kvm_segment *segp)
+static void kvm_seg_set_kernel_data_64bit(uint16_t selector, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->selector = selector;
@@ -498,8 +463,6 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 					  */
 	segp->g = true;
 	segp->present = true;
-	if (vm)
-		kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
@@ -517,16 +480,15 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
-static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-				int selector)
+static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp,
+				  int selector)
 {
 	memset(segp, 0, sizeof(*segp));
-	segp->base = vm->arch.tss;
+	segp->base = base;
 	segp->limit = 0x67;
 	segp->selector = selector;
 	segp->type = 0xb;
 	segp->present = 1;
-	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
 static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -548,11 +510,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
-	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
-	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
-	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
-	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
-	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
+	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.es);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.gs);
+	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr, KERNEL_TSS);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
@@ -612,6 +574,7 @@ void route_exception(struct ex_regs *regs)
 static void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	extern void *idt_handlers;
+	struct kvm_segment seg;
 	int i;
 
 	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
@@ -624,6 +587,15 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+
+	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &seg);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
+
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &seg);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
+
+	kvm_seg_set_tss_64bit(vm->arch.tss, &seg, KERNEL_TSS);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.44.0.291.gc1ea87d7ee-goog


