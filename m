Return-Path: <kvm+bounces-12942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F15FA88F58B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7A3729C46D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3EF28DD1;
	Thu, 28 Mar 2024 02:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ie+dgLo9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AB8249F7
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594283; cv=none; b=Ew0ikKdanbmtpucmi9XC2w+OZU2N55u0P3THP8Jfy6jB2RMb7/hXe30bXreIwVb5h+PpM7ziTGPLRIaET1EHnh963Vphk2WCB7LxCrehxcSKqsB/oLyRKjKUuKLk639KsecgERx9koqLLG0QDEmtou3qxNC23fXj+31DHuYH8bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594283; c=relaxed/simple;
	bh=XIZ4f6D2msngrjo5E1BaCoNab5/MCdBimgyNp63AH30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mx9MAWqjyvyht4zGC/CaMcDW7eD8K0VmCHpFimUAN/e1/1iV83EOhcHsxi75/Mcy229g258B6L7K7mTK+nf/8idMy/b82q+OAeN/D9vnSEIJ/y6fDgL2v8+EVwIYssgszfItdSuwtqz0wn5Cgucy7VuM6oSzPPguXSZ3RJ5AyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ie+dgLo9; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609fe93b5cfso8859777b3.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594280; x=1712199080; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4Ns6gaSo4Qq0IcoiML7N509X1eCvl6xcmeeJxScUyE=;
        b=ie+dgLo9oTxbhMW+OplILQRF5YTpxG0aKIijgQ14PdvFen1mdDDzJ+G1GCnXWWImqm
         Rkq1zs0ZOmtLQr8VVFgINUAG7Un2zxCMZQs4+pJlswiQqteQQEpxVFkbsH1nZ92pdUz7
         AnqNzFQso5IWFwmkcNdbnUuxmcAr2FcJmQAvhnosezGr9Menbr+axzuAf4vIkns/4rNM
         sDczgVwgNiu9i/IcwKfiUBq7bR5qpoft8P6hw74f//d+zVwzrTqDCCR3c9hVWvuNodQU
         HwtMXrJXjwSMkLWVmnb4xuYiolWlQIfbM4lhZ+wm0jtHKaOBDB8GGe4dpc7/ESEIpgvq
         wNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594280; x=1712199080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4Ns6gaSo4Qq0IcoiML7N509X1eCvl6xcmeeJxScUyE=;
        b=BVtrQxc/xIvQdihEGwd8x4zaDev9qge3l/m24lGjosa6bQbPL7FX8KUTRQgZFaAmBR
         3SGlcxdurTdhMu1HtI/ralypfgWoLDw6FCN9Lj/GY7qmsL4gfdx1k4P+SQzmHA8YLw0G
         Win+blpjkcxmLWQROQuC3z5ffuMi6XlIHdLeKTCEB07RpK7jGTPYRnHFqsVHmDGnOtXu
         6BZDj0TZclB74KYAY1GqO1k2TwJqKOg87CuZLF9qiACz5Ayxyz8g0I5AheVs2QfzdqFl
         bpBkb7o0+OoOQBvWnBiJeEs4jfUs0Hd2mA+xBmZK/I9RyjxcGHk8AiGDwSfy6djp/d2n
         RLtA==
X-Forwarded-Encrypted: i=1; AJvYcCUbYM6Wbs7ZFqV2VIqF2/Yu6nLw4a6+MK+yIqEx45tSXMI6tS6ZCDXc2r9d+Y87AZH+yJZtE0CnA1MaqYbaWmOXlL4m
X-Gm-Message-State: AOJu0YylTokBWNQ/fYi6YxDKX9OmEjJOvVZ82wAXWDPFeNImsHRqHF1V
	QubYWA/h3oBn3tfIugWkVwQFRVWKFed29bntIf7aczpi2t2NlmBtjObWWgxWOSbagpfEU/OcbDu
	yrYvKKm1gDbhve4fYA24b0w==
X-Google-Smtp-Source: AGHT+IFq6RvNgKKDrmQGX8FbWbPutEMqrYZ/mRuBwk+vhXh9Fho0CVv4hcycTp/A4TYnzMSkOeSkeap9+3BP7uh0Rw==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a81:6d43:0:b0:611:7358:6fa9 with SMTP
 id i64-20020a816d43000000b0061173586fa9mr298635ywc.0.1711594279878; Wed, 27
 Mar 2024 19:51:19 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:51:15 +0000
In-Reply-To: <20240314232637.2538648-19-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-19-seanjc@google.com>
Message-ID: <diqza5mjkr18.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 18/18] KVM: selftests: Drop @selector from segment helpers
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

> Drop the @selector from the kernel code, data, and TSS builders and
> instead hardcode the respective selector in the helper.  Accepting a
> selector but not a base makes the selector useless, e.g. the data helper
> can't create per-vCPU for FS or GS, and so loading GS with KERNEL_DS is
> the only logical choice.
>
> And for code and TSS, there is no known reason to ever want multiple
> segments, e.g. there are zero plans to support 32-bit kernel code (and
> again, that would require more than just the selector).
>
> If KVM selftests ever do add support for per-vCPU segments, it'd arguably
> be more readable to add a dedicated helper for building/setting the
> per-vCPU segment, and move the common data segment code to an inner
> helper.
>
> Lastly, hardcoding the selector reduces the probability of setting the
> wrong selector in the vCPU versus what was created by the VM in the GDT.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 29 +++++++++----------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index dab719ee7734..6abd50d6e59d 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -438,10 +438,10 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
>  		desc->base3 = segp->base >> 32;
>  }
>  
> -static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_code_64bit(struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
> -	segp->selector = selector;
> +	segp->selector = KERNEL_CS;
>  	segp->limit = 0xFFFFFFFFu;
>  	segp->s = 0x1; /* kTypeCodeData */
>  	segp->type = 0x08 | 0x01 | 0x02; /* kFlagCode | kFlagCodeAccessed
> @@ -452,10 +452,10 @@ static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment
>  	segp->present = 1;
>  }
>  
> -static void kvm_seg_set_kernel_data_64bit(uint16_t selector, struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
> -	segp->selector = selector;
> +	segp->selector = KERNEL_DS;
>  	segp->limit = 0xFFFFFFFFu;
>  	segp->s = 0x1; /* kTypeCodeData */
>  	segp->type = 0x00 | 0x01 | 0x02; /* kFlagData | kFlagDataAccessed
> @@ -480,13 +480,12 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
>  }
>  
> -static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp,
> -				  int selector)
> +static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
>  	segp->base = base;
>  	segp->limit = 0x67;
> -	segp->selector = selector;
> +	segp->selector = KERNEL_TSS;
>  	segp->type = 0xb;
>  	segp->present = 1;
>  }
> @@ -510,11 +509,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> -	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &sregs.cs);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.ds);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.es);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.gs);
> -	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr, KERNEL_TSS);
> +	kvm_seg_set_kernel_code_64bit(&sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(&sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(&sregs.es);
> +	kvm_seg_set_kernel_data_64bit(&sregs.gs);
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> @@ -588,13 +587,13 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  
> -	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &seg);
> +	kvm_seg_set_kernel_code_64bit(&seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &seg);
> +	kvm_seg_set_kernel_data_64bit(&seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  
> -	kvm_seg_set_tss_64bit(vm->arch.tss, &seg, KERNEL_TSS);
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  }
>  
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

