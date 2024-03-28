Return-Path: <kvm+bounces-12933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4569E88F569
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06A0298FD9
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6441DA5E;
	Thu, 28 Mar 2024 02:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BNqa5zBC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457E61A716
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711593350; cv=none; b=pH4aurFmpbSvDsTJPS2VpnNj8Q/p2zQvA/hNE8w6lBl9h+9O8UUBJR+xLouZ/sv3Qhk5hVR0fCP7Ju/94CosW5o7X9piME1BG2Z3cc6OyD/PmZQHKsU6cRd5OqcSBQQryTIOx4lOSAvhbC6vQd+TUg/Ig4HdMlbSzA+mpEeWGhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711593350; c=relaxed/simple;
	bh=0R24u452LaT2qzR1G87IGAYBRmr17XS5Gu2jDvqLnd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k3MMGZHplbOkvY5ZUJt91ndcx2vqIwEtg+/gRtc7q9GM6E5AgD8CRZJxqf8Chs8Ex6DBKO0lyXs2JnROMMoaUG2o4df9FphlOck2N39FH25hNCcIMiJ9CNs3L+e1sP+vNilqMerYu7zxSFKTpWBHhaqS1BfsahWnOvpwgnU014w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BNqa5zBC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cd041665bso10144357b3.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711593348; x=1712198148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1V7cT0/uugUJxaDzYA8tibaw31zbYQ1co3qQTHee4=;
        b=BNqa5zBCrXe42lqqvJGwD+94kl/rrRid6gMz8sj9UGEl/gV66mvS+gbUBbPI9EqbCV
         q6Bn5ooPkrul3xSV5fZPoTV8AqN89nj1G/Nlj1FZgpftgv5P+yQQkpFWcBq/7OE1jKaQ
         +DwUzsduPhXoQZTj+62gUzy9LepE6jU3csgroXLT5C/YurnTjg69YjUDzrFbF/Gi9z4h
         xJ+a3nGK2EUrb7wMJsM0B/VDSpDE2fnsGhdcZADgN/YvwhKD0g4DobdNrvQs3oNH/N24
         cqCGU0Bs7o5tUPvOGc0sNl9nHVh+8Rdyc275Ng2TAMYkNSnJ3jxyzYbTeBUGdNkSLIAc
         dRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711593348; x=1712198148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1V7cT0/uugUJxaDzYA8tibaw31zbYQ1co3qQTHee4=;
        b=QI3gXAMfYZsy3OuT1i5yJIpYJsJV/DQI42jrf/Ky8rr5MOvsaD96pfyPfDZEQdjsW7
         7oSbm9UbAlzrZ0dBWSpysikSRmtt826zajZlLsnTrwu9+x0zD9gdXne4aU4cesVaiC8j
         hXycj/VItQ15dWX7uwfLUN8+3/Y7U1TwOlueL6gOWS38xz7zqp9WLxg8f9ZtAejBck8z
         J6TBTL4H9zpo37LqM7eiCxqYaGhqooRRsO3j1F4OnR0PtRYYi+MSNRXAFmIG80DMi6xi
         +DDPHVlbkfxyEPbuur5WetZWxj8dRG2xP3JB1ET9bZrjvsuVU574Vd6m3jEbvTWpiab2
         Lrcw==
X-Forwarded-Encrypted: i=1; AJvYcCVFRYvBjnaN8ED0L64GCVJcQ0RgZCUAxwo5BSdNIoZqpaq6FbNKg36RtAKXGt9sUQIDEYXV3BNCTDVlY/An7JiQk9Yr
X-Gm-Message-State: AOJu0YzYH5RD8kQtjwZrCy46X95ip1dS9W+ZNXJ9eobrrXMLYWC/Yswk
	reWm/+wj6hoxLBr0HRjS7caLzUOCFkiBzx+GI0Km3xUlR9hBMDW24759T3bJ7QxgSdLwr4cPiLm
	mQa0mHxK7ESWL2potpBwJZA==
X-Google-Smtp-Source: AGHT+IFmu/wyvjPJ86C2YpqmMzCjCxqoKynwb/5895KHOEbiGTXB3f51zjw8tqW3FQ608rm4NQTJd4dFZkDKVH6OPw==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1007:b0:dcd:ad52:6932 with
 SMTP id w7-20020a056902100700b00dcdad526932mr540194ybt.5.1711593348331; Wed,
 27 Mar 2024 19:35:48 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:35:44 +0000
In-Reply-To: <20240314232637.2538648-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-12-seanjc@google.com>
Message-ID: <diqz1q7vm6bj.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 11/18] KVM: selftests: Map x86's exception_handlers at VM
 creation, not vCPU setup
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

> Map x86's exception handlers at VM creation, not vCPU setup, as the
> mapping is per-VM, i.e. doesn't need to be (re)done for every vCPU.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 5813d93b2e7c..f4046029f168 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -552,7 +552,6 @@ static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	sregs.gdt.limit = getpagesize() - 1;
>  	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
>  	vcpu_sregs_set(vcpu, &sregs);
> -	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
>  static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> @@ -651,6 +650,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
>  			DEFAULT_CODE_SELECTOR);
> +
> +	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
>  void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

