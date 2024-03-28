Return-Path: <kvm+bounces-12932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1A588F566
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC6D1C2727D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751EA1DA58;
	Thu, 28 Mar 2024 02:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gY3gcPor"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387D413ACC
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711593222; cv=none; b=DPlxw+IRJtV+MbTgN2xxDgDoQfboGUbMogls2qsDwfSBLE5S6Wsob63+nX9PGE1tMfZgilC0RAqwHZiPZ0e3+bKfPS9tZtJwelLBSaEUnvH4Tn4SDgevzqEikVGrifiN0cSPTeu19COIJ8XwCovOF2api6YOcTJryMzQcxEWguw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711593222; c=relaxed/simple;
	bh=OFojCwZ6v5ziBtsIk9oLLAj/dEaiopLScBLdXXXv8Ts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GgxQFNU5XX1vYQxF72tdIsg+M9eS8BAN6W1mduUsdm1qyJzrDWuYWzgaz5NP4+5wBs0+WUkcAmpqBfUnRsCcYa1m302mnI+V80PQgUygY3vFa7jVeDkIhqLvvqFpGs1HQS1mQfg7z5rjLV1SGSQaVHh0oan8LeYQpYZz/tcJFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gY3gcPor; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cd073522cso8796687b3.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711593220; x=1712198020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkoXrrgQLG0OC6iY0Ar2KtEiFjbb+Lcngub56vU+bHo=;
        b=gY3gcPorLVuKWGDg68knAYdwewnr/9H5T2BsL7/oYTEltCOISa/59dCnH9aMDkrR0S
         mPn7C67z0xsN6OPfFDKr0Wx6Q8GoPSmhyoZmZiJwSL88WXXeuNudMI472YnZ+uHvXdcA
         UONUCFkmVFyoyQAdsQEgD/W+rUEitzVXDm/D32RCZnrsarvbuJIxuFGKuuLK058IFOwg
         JE89JeO9N2ZSqEQL4whBNSPE2N2Pws75glf1Y1COzArgBSk9q3n+107dDJ2pN4AJTnWV
         InU67EUSPAMi9wUtsJgBtqEMo9bma6mbXp6dNtx1FDj5LE1DvKovcvpy5HMynYjrTsqF
         O+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711593220; x=1712198020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkoXrrgQLG0OC6iY0Ar2KtEiFjbb+Lcngub56vU+bHo=;
        b=njQhRQHmEha6ebVfhikQlaYb89emBgzRJEitcahK+J8bOu7A0ydPAmLWo8rwwAz5aT
         1v146Jna+rAEZgnqgJqzfAc0MLU76vKWQW5yFn5gIFIYOOqFl280ClBp7X5IWAfU+fQr
         rRJ5I51x+rZoAHOcsWOK8+JbmrPreiuLy1JvvUuMdKj0etYZVtrOOuNq9qmx23KaTa8d
         Bc3wERrCrk0ITPLWWUSLhZS8Kj3kruQ7qtektbmrQe5rxQw2j5zg+GEhXmVezoJBDMDB
         ZoPtyGdo14svN9uIdx2NZxvaYXPSZJVWOj4ADfQW4g7fjDQSDKLoEGH2W2CSen8P9KNC
         Dpdw==
X-Forwarded-Encrypted: i=1; AJvYcCUlQirk1ODTCxkkz7f3I7ro4XJ1F4LAWs8jnVD8jgcuGPjMymK77RwF2Mn94xK9fg6jFCe6DO3yd0ff7jpPzncDicR2
X-Gm-Message-State: AOJu0YziUGH25buwubzR/fktQBk3MFhDKq8Ka47jJQJlsfsHYn6PtdWA
	pFTDbuHTl06ohCOGllmYCWLbNPXfsI1UgEb7xesH658YixagOavfPAc2vx6tkUwCWnRtS6B37wo
	ycpUkq0JAFDk2CygMJk0uyA==
X-Google-Smtp-Source: AGHT+IHG+Q0Rs/vnujOAAu0Ep0Ci2zjwBo/RrccQVLVpOf2JlGdWJkUk21aGZnHKjC8iP2W+VnN97KkaXY/g7E7Z7w==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:d8f:b0:611:9268:b63a with
 SMTP id da15-20020a05690c0d8f00b006119268b63amr350712ywb.9.1711593220342;
 Wed, 27 Mar 2024 19:33:40 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:33:36 +0000
In-Reply-To: <20240314232637.2538648-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-13-seanjc@google.com>
Message-ID: <diqz4jcrm6f3.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 12/18] KVM: selftests: Allocate x86's GDT during VM creation
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

> Allocate the GDT during creation of non-barebones VMs instead of waiting
> until the first vCPU is created, as the whole point of non-barebones VMs
> is to be able to run vCPUs, i.e. the GDT is going to get allocated no
> matter what.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index f4046029f168..8547833ffa26 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -518,9 +518,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  
>  static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
>  {
> -	if (!vm->arch.gdt)
> -		vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -
>  	dt->base = vm->arch.gdt;
>  	dt->limit = getpagesize() - 1;
>  }
> @@ -644,6 +641,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	extern void *idt_handlers;
>  	int i;
>  
> +	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	/* Handlers have the same address in both address spaces.*/
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

