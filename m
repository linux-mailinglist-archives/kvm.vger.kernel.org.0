Return-Path: <kvm+bounces-12940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6039888F584
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FD9F29ADFA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CD728DDE;
	Thu, 28 Mar 2024 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ziOEoNn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFEF1EB55
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594240; cv=none; b=oX53y17Ffibi6y7/pmUd5KiRfqBC6IfpYZXQ71vk3Cv4j0zzV0nBQ8GXxBe3qk3sBGnlSSxgHv5dtZ4jbBXwT8yuDlYdvSevslOiseC6WELxQJliD3tUWBwstrXugM3LrSVvlXCCrbuRjRhcjso2ei7yrH5E0BM8HczaW2DFETs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594240; c=relaxed/simple;
	bh=TgtHBQv7hWFFUsdNLEi5j9zVB+0hOvbL0vOMOT5yYkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1hervb5oCCcwkMP2ZBXZDqx2j6SkNg7isUkS8eVyYTZtnUVWkFTmJ5OljWXb6ZWnSs/l4y2EXz4sCWEjYgJf6ympeAIrGHgZPbi2RZVXgH49mxFGcdDh95Lre/UwNY6tD5rJ3GluOl9buElEsVJ8UKFwQMiuSp7UwdAgdDkd2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ziOEoNn/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso763066276.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594237; x=1712199037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GVStFLbB5MSlLHegIF/51zA+Fjr+PzwwtmvLYBB03HM=;
        b=ziOEoNn/p+OQCmTX/hKzlwbl63OmCvGDAAZ+Z9dUipB7FYlSLoQDF6ObmyKrGYkR9Q
         jNSIT7Kk5h3k+2PBSfFiyilUQw5cW0p/SVLH7c1UgWVIv6ULdJca5IzXIZ4G2xvG5fqy
         pi+rWOwY4nqlUc5VIi0ghpiU1J227ZBjx/VFcmYFrfIfwQTz4ac7Bvae1h9pdsKjX1cq
         qd/nnS6ZKJ6GCBr36SHaienBv4CZQu7VyX7YajrmmXwwCw5BhPCwsm3ZxPdtAnMfnwOx
         0lGRbHmplBe0zhNK6SEkHT2NkCZfuvruMtExEhT8vVbRPYthdD5fPMhaSoDCa3B6rDVW
         /W2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594237; x=1712199037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVStFLbB5MSlLHegIF/51zA+Fjr+PzwwtmvLYBB03HM=;
        b=f6I+YWlC0J8u2IKAGHGYZrpQdRUKUL0oBVklwN+r7EoHcSHDQHcCAtOK3FN54EJLOn
         DIsvPH5lpxhe4mkkQ+libtiBeccOw1ewH2JlO8E2nNFk9bSG2uzrDkREQ3EjgoEyZdXr
         rwFuUuvG5WW2p6UAlU6T71HzJjP6FjSCSkPC4bttRrdzRN+lqjAJwlKZa+SR1bUcQ0IV
         NtvuF4Q+gV6Dxt8c/Ectl14QwsvVJD49RcU5mb0KcJzXBSAmEpVTNisMYXnfJGu/s12X
         g0vVHxDcU7VwnZwXLIhPGSSlCe1dVRv0WrwY3ZIcZBxAywSh75EHpLGqYN/tVMXWu0Ng
         5ohQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+/5926J6bScGPK/AEeGKoSJeoipJY4nRw/uuwK3eUk2YkKJnEciG91OQmbBkdlp8HGnO82qIHnKCkmwhDmPGVxCAI
X-Gm-Message-State: AOJu0YzADE8+o8PpRD3i3EfBlZO9XHL0EbQK0zR0Sg3ljXVxtU4zQFer
	tGjHT9zXOi9SpiITu6rlm5uq/ALM6QvgwgEl3HL4OMLXM3gpzZwmUK4+UgPD9uArt5Oo64mc/+t
	+wnob93kyDWAocUtgzP+ZUQ==
X-Google-Smtp-Source: AGHT+IFMg1NFvhaztQY4Xe+ltR0SInGvBShM16M6WwX62q2RGNWNPZfAstK1O/zQ6kdEG7DNPdBNlgqWvpvw1rlnNQ==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1009:b0:ddd:7581:13ac with
 SMTP id w9-20020a056902100900b00ddd758113acmr522745ybt.2.1711594236913; Wed,
 27 Mar 2024 19:50:36 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:50:32 +0000
In-Reply-To: <20240314232637.2538648-15-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-15-seanjc@google.com>
Message-ID: <diqzfrwbkr2f.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 14/18] KVM: selftests: Fold x86's descriptor tables
 helpers into vcpu_init_sregs()
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

> Now that the per-VM, on-demand allocation logic in kvm_setup_gdt() and
> vcpu_init_descriptor_tables() is gone, fold them into vcpu_init_sregs().
>
> Note, both kvm_setup_gdt() and vcpu_init_descriptor_tables() configured the
> GDT, which is why it looks like kvm_setup_gdt() disappears.
>
> Opportunistically delete the pointless zeroing of the IDT limit (it was
> being unconditionally overwritten by vcpu_init_descriptor_tables()).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 32 ++++---------------
>  1 file changed, 6 insertions(+), 26 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 561c0aa93608..5cf845975f66 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -516,12 +516,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
>  }
>  
> -static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
> -{
> -	dt->base = vm->arch.gdt;
> -	dt->limit = getpagesize() - 1;
> -}
> -
>  static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  				int selector)
>  {
> @@ -537,32 +531,19 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  	kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
> -static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
> +static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vm *vm = vcpu->vm;
>  	struct kvm_sregs sregs;
>  
> +	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
> +
> +	/* Set mode specific system register values. */
>  	vcpu_sregs_get(vcpu, &sregs);
> +
>  	sregs.idt.base = vm->arch.idt;
>  	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
>  	sregs.gdt.base = vm->arch.gdt;
>  	sregs.gdt.limit = getpagesize() - 1;
> -	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> -	vcpu_sregs_set(vcpu, &sregs);
> -}
> -
> -static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_sregs sregs;
> -
> -	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
> -
> -	/* Set mode specific system register values. */
> -	vcpu_sregs_get(vcpu, &sregs);
> -
> -	sregs.idt.limit = 0;
> -
> -	kvm_setup_gdt(vm, &sregs.gdt);
>  
>  	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
>  	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> @@ -572,12 +553,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
>  	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
>  	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> +	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
>  	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> -
> -	vcpu_init_descriptor_tables(vcpu);
>  }
>  
>  static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

