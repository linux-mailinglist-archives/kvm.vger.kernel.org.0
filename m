Return-Path: <kvm+bounces-12937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E054E88F57D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 747431F2AB1C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B26B828DBF;
	Thu, 28 Mar 2024 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d1cXZtD6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6141F1A716
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594095; cv=none; b=G847JLpxFXk8K/bvhuONypu2m+RxvESja1HRzJyw64GqzP4T/NRzWHN9Xy6VyX33uzDhoFvlwbf2eTUuy/78k5IAF7XixfB5qcQAlsyIX22HHxTfVA2Zfhr2w5ciDBCNkT+00DOzpdcVL8CaNyw9oPwW46/0/1I5voQp3i81D0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594095; c=relaxed/simple;
	bh=/KyhZGeFs7mqMAPIrQoMos8Sdnyodq3lxJbPFquzhP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z3nRzmbzcs07Dol583dAYZq6UqCNxhf+N5HRa+MY9DY8kBnZ5QiSRMpXzB4+gUcXHypb2TUUoGm+NtXa33KHk2yv12wDaI7tHQNhY+x9xU/wN2MIfMGjU/vbtsmaCdBpgHH+zw05bd33V9095PoiDyBEFzvN1BcUxcp/HYyz/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d1cXZtD6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cc8d4e1a4so9259767b3.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594092; x=1712198892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X53owM0AXy0w40k+CXCDsz/LIA36JplY64ayboW/axQ=;
        b=d1cXZtD6pAUBBJLS/QjxTAvDdbG1wadwJ1JGBkC8+vNuTkdJqSf06HlePei1j67aSV
         jl/FOG9sB4xE60fz/ZWcC5fO+qRsT7w6lGrEEqwRw+g7KrWmcicLVzOp2x6EIeQ6uZKP
         7MdggDJogj+/HftA+EBWbHCdErebMB78XjYiT/tu4JFrEVymOkrV7FbvaQAhUnp74olK
         67TOUg/g1ls7PQT6k18O/fTJ2FnO1scLfrctrchzEnwbP/WpSc7cplJiqQKwSAvuZn80
         HQnTKaznGlV1X3r4ki8Q/EcrgbpsLK2Q1TGddmuC6ja7rp5tn44luvBIvrwyA9eDwIoj
         RJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594092; x=1712198892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X53owM0AXy0w40k+CXCDsz/LIA36JplY64ayboW/axQ=;
        b=Xc36UMVdiUDTlTrnMEm/Wc3OfhjVozXfI+d9eWngBxJER0SRXXc+zUo24ZGuQSVMWJ
         K6uPAtngo/Z7oc9vET3HqPOyEqUuOKs+/AlOYEn+vGlRCdWrn3zIljABsj22+L2PQemm
         sXvPSbyOtOqbA8tDeJd3/K+a6cHaH0PeCHRJd9IALz2X3z53b281n46OtQvIlIyvVAQI
         t6v8WREFPhecWRG0sSiG+LpIvUgBGk2pxZQ8xMjp1ZBnI77o9pq6H8VZaEUMtTpIUQVz
         foW/G5IKn+rD0KaF8qpozrl2QkwNi3xcLgV3afSXe8VnzZ/vwkXNesWLghzzIqbbJwjR
         iYig==
X-Forwarded-Encrypted: i=1; AJvYcCWl6Dve62KVzz4G9RNk+xr4ifpTIuH2W/0nbS3vk7mBuFumGuJTqbd50WG6GssUyF5S+reI3ApZGfCBLPeENJ8V4njw
X-Gm-Message-State: AOJu0YxqggPpQv4x4ligfrG6XJ3qrw71O4NHuIqHksmGDGnHohGQbdZA
	/7j/RHx0Hs/Bj18oK4pFgDnkiG7t3KD7JnfERihwlKq/SkTlPSfwdMspeUAcyuCqitvcuosUOtY
	M4mDUJZ7/6oKTEjbT5lXS4g==
X-Google-Smtp-Source: AGHT+IHemBOmZzBj11UU0KC0nluKXTSfglIgOeQ+gPV+l80SSzWOVj5Tc0CUw88owyE2SFGESkvSyqXJHEPRm8GAYg==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:2290:b0:dc7:48ce:d17f with
 SMTP id dn16-20020a056902229000b00dc748ced17fmr499185ybb.10.1711594092566;
 Wed, 27 Mar 2024 19:48:12 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:48:08 +0000
In-Reply-To: <20240314232637.2538648-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-4-seanjc@google.com>
Message-ID: <diqzo7azkr6f.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 03/18] KVM: selftests: Move GDT, IDT, and TSS fields to
 x86's kvm_vm_arch
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Now that kvm_vm_arch exists, move the GDT, IDT, and TSS fields to x86's
> implementation, as the structures are firmly x86-only.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  3 ---
>  .../kvm/include/x86_64/kvm_util_arch.h        |  6 +++++
>  .../selftests/kvm/lib/x86_64/processor.c      | 22 +++++++++----------
>  .../kvm/x86_64/svm_nested_shutdown_test.c     |  2 +-
>  .../kvm/x86_64/svm_nested_soft_inject_test.c  |  2 +-
>  5 files changed, 19 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index acdcddf78e3f..58d6a4d6ce4f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -94,9 +94,6 @@ struct kvm_vm {
>  	bool pgd_created;
>  	vm_paddr_t ucall_mmio_addr;
>  	vm_paddr_t pgd;
> -	vm_vaddr_t gdt;
> -	vm_vaddr_t tss;
> -	vm_vaddr_t idt;
>  	vm_vaddr_t handlers;
>  	uint32_t dirty_ring_size;
>  	uint64_t gpa_tag_mask;
> diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
> index 9f1725192aa2..b14ff3a88b4a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
> @@ -5,7 +5,13 @@
>  #include <stdbool.h>
>  #include <stdint.h>
>  
> +#include "kvm_util_types.h"
> +
>  struct kvm_vm_arch {
> +	vm_vaddr_t gdt;
> +	vm_vaddr_t tss;
> +	vm_vaddr_t idt;
> +
>  	uint64_t c_bit;
>  	uint64_t s_bit;
>  	int sev_fd;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 74a4c736c9ae..45f965c052a1 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -417,7 +417,7 @@ static void kvm_seg_set_unusable(struct kvm_segment *segp)
>  
>  static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
>  {
> -	void *gdt = addr_gva2hva(vm, vm->gdt);
> +	void *gdt = addr_gva2hva(vm, vm->arch.gdt);
>  	struct desc64 *desc = gdt + (segp->selector >> 3) * 8;
>  
>  	desc->limit0 = segp->limit & 0xFFFF;
> @@ -518,21 +518,21 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  
>  static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
>  {
> -	if (!vm->gdt)
> -		vm->gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	if (!vm->arch.gdt)
> +		vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  
> -	dt->base = vm->gdt;
> +	dt->base = vm->arch.gdt;
>  	dt->limit = getpagesize();
>  }
>  
>  static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  				int selector)
>  {
> -	if (!vm->tss)
> -		vm->tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	if (!vm->arch.tss)
> +		vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  
>  	memset(segp, 0, sizeof(*segp));
> -	segp->base = vm->tss;
> +	segp->base = vm->arch.tss;
>  	segp->limit = 0x67;
>  	segp->selector = selector;
>  	segp->type = 0xb;
> @@ -1091,7 +1091,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
>  			  int dpl, unsigned short selector)
>  {
>  	struct idt_entry *base =
> -		(struct idt_entry *)addr_gva2hva(vm, vm->idt);
> +		(struct idt_entry *)addr_gva2hva(vm, vm->arch.idt);
>  	struct idt_entry *e = &base[vector];
>  
>  	memset(e, 0, sizeof(*e));
> @@ -1144,7 +1144,7 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	extern void *idt_handlers;
>  	int i;
>  
> -	vm->idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
> @@ -1158,9 +1158,9 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	struct kvm_sregs sregs;
>  
>  	vcpu_sregs_get(vcpu, &sregs);
> -	sregs.idt.base = vm->idt;
> +	sregs.idt.base = vm->arch.idt;
>  	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
> -	sregs.gdt.base = vm->gdt;
> +	sregs.gdt.base = vm->arch.gdt;
>  	sregs.gdt.limit = getpagesize() - 1;
>  	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
>  	vcpu_sregs_set(vcpu, &sregs);
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> index d6fcdcc3af31..f4a1137e04ab 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> @@ -53,7 +53,7 @@ int main(int argc, char *argv[])
>  
>  	vcpu_alloc_svm(vm, &svm_gva);
>  
> -	vcpu_args_set(vcpu, 2, svm_gva, vm->idt);
> +	vcpu_args_set(vcpu, 2, svm_gva, vm->arch.idt);
>  
>  	vcpu_run(vcpu);
>  	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> index 0c7ce3d4e83a..2478a9e50743 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> @@ -166,7 +166,7 @@ static void run_test(bool is_nmi)
>  
>  		idt_alt_vm = vm_vaddr_alloc_page(vm);
>  		idt_alt = addr_gva2hva(vm, idt_alt_vm);
> -		idt = addr_gva2hva(vm, vm->idt);
> +		idt = addr_gva2hva(vm, vm->arch.idt);
>  		memcpy(idt_alt, idt, getpagesize());
>  	} else {
>  		idt_alt_vm = 0;
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

