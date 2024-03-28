Return-Path: <kvm+bounces-12936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EAE88F57A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE5ACB23911
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9108328DD0;
	Thu, 28 Mar 2024 02:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uN+lVx9r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6922555B
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594051; cv=none; b=eKkbfzM65SIC9woCgN3HX7B3+CP1yJErHrqnyDAiSSWFTAyJUM959fLLVMqohF6sXzEHoUQZ+JEJajYJC2v/+iQyTnPPzTsbxt91zQHC4r8GvaP+MQtD5QzYq2MMDIQMV8LXAADtDHH3i/aNaqKA8kQz0byaIcoTrT+3HZhoKSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594051; c=relaxed/simple;
	bh=uTn/hDm6rRTF0x1fCZTXyKoh4iOHnT5MFqKU6DRKUkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y3hsmlpzUCvMlMHcS5nEDHAuLAi41xrBYS++cbtEHA+dBEohN2YNbuiFqRGV0N/nemDFfR4VxpQpN4UasdC2CpwpauDoK5pELPT1lI2FunsMk/Ku9RgFVqCmKydKzjXNX5npOiDbWO6Oe7S1TB5s41dElwnTt9o/9HxUwVzuIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uN+lVx9r; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso830909276.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594047; x=1712198847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yqOjNlVyt9f+dZUymfqOg4Iq2ntY8mdLHefZitivNvA=;
        b=uN+lVx9rgiwnW9I4aDI4oRtcZh1vdu8Q60xxrMwYyOb6/UWP4VtyNUxyDLrAE30jV1
         D7FxCAQKvOXq/YOJEQ0m3OtyIxGY9FqfGV+nxml559PEYSgM+qNoNOIpGNUQGq7edB7w
         R3XQqVVHs5S8lJfeE5EP5fufS4/9w8J61GRmswkgvHT/icPUi+Uh0MuKGKu9ZmFwwlc6
         wmixI0xCYMi3cvK/h9gBoUACah6oOtoXC4ZTGMzCtkuqrdc64Hng17EV/iUYCneSHRNp
         HnqokuPzZJax0AQnNLK40F0yY3i4x5Ic2B4GuGk3vpzBUe7sVxzmnRElWa1sSm/sZIqR
         5ZLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594047; x=1712198847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yqOjNlVyt9f+dZUymfqOg4Iq2ntY8mdLHefZitivNvA=;
        b=iPrZT/C8ER1kQ8ZmafeC2AQ8qpLnDqiCnosmU6xqYSTpzVZnJ1Jx/XN5iRktM3aQPH
         wKb/MkTPXuo3jigymJXcwHSvWskVbeJco2+JqT3AGj2mamqY+Q5hfPSpWTJ/fmUeE7Nr
         k5KWjBtXk+aKySiHZJ4lt962sz6GVKlpiv2DbbTxx40CKAVnMZCevMUGPEYt+J4RYn33
         /DJ1UgCm4bcJfJJE8dxZHk0up/2a6fwRRqbXlP4pPKgPfvZxJvZU5dRMwX4vtgwGfY3l
         REbEGVFUr1vjT5+nZjlBxmmi9k7EsNCu8Ic3QXG8qfYApwwJKAjtd1yNuKfXsc8gqMFG
         HZbg==
X-Forwarded-Encrypted: i=1; AJvYcCXim+9XLNvHrCUWGTN1W0ECYiCPx9eWSMqXPXT6IOfnI0MvPTXue2XoWSLWLaZgo+DzOXg++AS239Is8DkiN+bBsu0+
X-Gm-Message-State: AOJu0Ywr7in8XifjSGXztjythviDNNBwLbA8DM84vCniEgGxNmk2eFmP
	8z5bLTHgDZDtyiGZSjeZw8vrenyya82b7rN+1J2GovupPUXvlF+WAHa6wxMo27D3E8Vh3OEeJgu
	d9kUrL9RQml4gNn/X21jllw==
X-Google-Smtp-Source: AGHT+IE29x7m+ZxCuBonRETTmQLNnZSrvQxvnruw/vCAylXmb5W1DxrhrZLZqb2+UAORn2Eg1cm0Cyzjivbt2c8E0g==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1b06:b0:dcc:94b7:a7a3 with
 SMTP id eh6-20020a0569021b0600b00dcc94b7a7a3mr157767ybb.12.1711594047236;
 Wed, 27 Mar 2024 19:47:27 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:47:23 +0000
In-Reply-To: <20240314232637.2538648-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-9-seanjc@google.com>
Message-ID: <diqzr0fvkr7o.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 08/18] KVM: selftests: Move x86's descriptor table helpers
 "up" in processor.c
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

> Move x86's various descriptor table helpers in processor.c up above
> kvm_arch_vm_post_create() and vcpu_setup() so that the helpers can be
> made static and invoked from the aforementioned functions.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 191 +++++++++---------
>  1 file changed, 95 insertions(+), 96 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index eaeba907bb53..3640d3290f0a 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -540,6 +540,21 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  	kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
> +void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vm *vm = vcpu->vm;
> +	struct kvm_sregs sregs;
> +
> +	vcpu_sregs_get(vcpu, &sregs);
> +	sregs.idt.base = vm->arch.idt;
> +	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
> +	sregs.gdt.base = vm->arch.gdt;
> +	sregs.gdt.limit = getpagesize() - 1;
> +	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> +	vcpu_sregs_set(vcpu, &sregs);
> +	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
> +}
> +
>  static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sregs sregs;
> @@ -572,6 +587,86 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	vcpu_sregs_set(vcpu, &sregs);
>  }
>  
> +static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
> +			  int dpl, unsigned short selector)
> +{
> +	struct idt_entry *base =
> +		(struct idt_entry *)addr_gva2hva(vm, vm->arch.idt);
> +	struct idt_entry *e = &base[vector];
> +
> +	memset(e, 0, sizeof(*e));
> +	e->offset0 = addr;
> +	e->selector = selector;
> +	e->ist = 0;
> +	e->type = 14;
> +	e->dpl = dpl;
> +	e->p = 1;
> +	e->offset1 = addr >> 16;
> +	e->offset2 = addr >> 32;
> +}
> +
> +static bool kvm_fixup_exception(struct ex_regs *regs)
> +{
> +	if (regs->r9 != KVM_EXCEPTION_MAGIC || regs->rip != regs->r10)
> +		return false;
> +
> +	if (regs->vector == DE_VECTOR)
> +		return false;
> +
> +	regs->rip = regs->r11;
> +	regs->r9 = regs->vector;
> +	regs->r10 = regs->error_code;
> +	return true;
> +}
> +
> +void route_exception(struct ex_regs *regs)
> +{
> +	typedef void(*handler)(struct ex_regs *);
> +	handler *handlers = (handler *)exception_handlers;
> +
> +	if (handlers && handlers[regs->vector]) {
> +		handlers[regs->vector](regs);
> +		return;
> +	}
> +
> +	if (kvm_fixup_exception(regs))
> +		return;
> +
> +	ucall_assert(UCALL_UNHANDLED,
> +		     "Unhandled exception in guest", __FILE__, __LINE__,
> +		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
> +		     regs->vector, regs->rip);
> +}
> +
> +void vm_init_descriptor_tables(struct kvm_vm *vm)
> +{
> +	extern void *idt_handlers;
> +	int i;
> +
> +	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	/* Handlers have the same address in both address spaces.*/
> +	for (i = 0; i < NUM_INTERRUPTS; i++)
> +		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> +			DEFAULT_CODE_SELECTOR);
> +}
> +
> +void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> +			       void (*handler)(struct ex_regs *))
> +{
> +	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
> +
> +	handlers[vector] = (vm_vaddr_t)handler;
> +}
> +
> +void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
> +		REPORT_GUEST_ASSERT(uc);
> +}
> +
>  void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  {
>  	vm_create_irqchip(vm);
> @@ -1087,102 +1182,6 @@ void kvm_init_vm_address_properties(struct kvm_vm *vm)
>  	}
>  }
>  
> -static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
> -			  int dpl, unsigned short selector)
> -{
> -	struct idt_entry *base =
> -		(struct idt_entry *)addr_gva2hva(vm, vm->arch.idt);
> -	struct idt_entry *e = &base[vector];
> -
> -	memset(e, 0, sizeof(*e));
> -	e->offset0 = addr;
> -	e->selector = selector;
> -	e->ist = 0;
> -	e->type = 14;
> -	e->dpl = dpl;
> -	e->p = 1;
> -	e->offset1 = addr >> 16;
> -	e->offset2 = addr >> 32;
> -}
> -
> -
> -static bool kvm_fixup_exception(struct ex_regs *regs)
> -{
> -	if (regs->r9 != KVM_EXCEPTION_MAGIC || regs->rip != regs->r10)
> -		return false;
> -
> -	if (regs->vector == DE_VECTOR)
> -		return false;
> -
> -	regs->rip = regs->r11;
> -	regs->r9 = regs->vector;
> -	regs->r10 = regs->error_code;
> -	return true;
> -}
> -
> -void route_exception(struct ex_regs *regs)
> -{
> -	typedef void(*handler)(struct ex_regs *);
> -	handler *handlers = (handler *)exception_handlers;
> -
> -	if (handlers && handlers[regs->vector]) {
> -		handlers[regs->vector](regs);
> -		return;
> -	}
> -
> -	if (kvm_fixup_exception(regs))
> -		return;
> -
> -	ucall_assert(UCALL_UNHANDLED,
> -		     "Unhandled exception in guest", __FILE__, __LINE__,
> -		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
> -		     regs->vector, regs->rip);
> -}
> -
> -void vm_init_descriptor_tables(struct kvm_vm *vm)
> -{
> -	extern void *idt_handlers;
> -	int i;
> -
> -	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -	/* Handlers have the same address in both address spaces.*/
> -	for (i = 0; i < NUM_INTERRUPTS; i++)
> -		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -			DEFAULT_CODE_SELECTOR);
> -}
> -
> -void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_vm *vm = vcpu->vm;
> -	struct kvm_sregs sregs;
> -
> -	vcpu_sregs_get(vcpu, &sregs);
> -	sregs.idt.base = vm->arch.idt;
> -	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
> -	sregs.gdt.base = vm->arch.gdt;
> -	sregs.gdt.limit = getpagesize() - 1;
> -	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> -	vcpu_sregs_set(vcpu, &sregs);
> -	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
> -}
> -
> -void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> -			       void (*handler)(struct ex_regs *))
> -{
> -	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
> -
> -	handlers[vector] = (vm_vaddr_t)handler;
> -}
> -
> -void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> -{
> -	struct ucall uc;
> -
> -	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
> -		REPORT_GUEST_ASSERT(uc);
> -}
> -
>  const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
>  					       uint32_t function, uint32_t index)
>  {
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

