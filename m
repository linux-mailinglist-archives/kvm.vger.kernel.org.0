Return-Path: <kvm+bounces-12935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E5A88F576
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:47:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E647AB227D3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D28F282E1;
	Thu, 28 Mar 2024 02:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4b79sfYy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE420DF7
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594031; cv=none; b=I9xRK5FFpwjoWMne2PQXwBh+D7hAXNoUvn2xCgY/jBxmZM7TcyIX14ymkvmZtXEk3heqhd57x5J40sm4oJGejYy1/DQeMntZ3Nxc6cXaJjj+iO5x5tQM/wu4IexlIL+ODyWaGO9x+nrGOQDnyx8+Lrbdi8WUmVvXqT9oKa4HRVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594031; c=relaxed/simple;
	bh=84H+cJFr0cL9Knja7weHauqkI7JHjb4wcobAfHN1EMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mUtZOsNkeO7ftM+XpSCHSFgHzMvulRA57r8dnvtwdVAw5OJfeozmfixzAYPD0jUFNvKihiEx2mrJ47b28Tywf6OJJr8ePU1vvFaqgiqOKf/BdZf720cNJPPFzZkJFsGQEsEzFhxBWT3MpO+RcNm5zJTt0ZjwfSYexBjUJvkJlfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4b79sfYy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a03635590so9977197b3.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594029; x=1712198829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zwKAKqKSkPlBh99CpC5Ho4X+oKbKwu1UgbqAZ4JZV3w=;
        b=4b79sfYymoScQAu7/7eJoVIjBxHjWn729jowcuWP2zjtW8rHPGlp3vwhlnWPWYwOUt
         W8PMM4rT8FfVXwbWuoKqyOr3YbJUbrq4LFXnKHH3zATOYJgPhpky12vO6Ff6mo60xG6p
         8CZ7Wtw4c1UFHiM+TOWEenZln0v945G6sUViHGnY5dK1z9/FTpk+LmuYyLouWT1jfU1A
         sA9ooNbRIlJwKG387WHXaJacO286tnB1WBGiuANtWaFLSCBYQlfNgeSIhnWpuC+sWRQ3
         BX1j/a5RqHNBVqjy5e5JGGwmgsV1MnF2zn8xqDbVG3/FQdev+ZfTuKf3ViTJHiEt+fft
         RPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594029; x=1712198829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwKAKqKSkPlBh99CpC5Ho4X+oKbKwu1UgbqAZ4JZV3w=;
        b=F/zXVHETXEOOHRV66M17/igWEJ27flbVRskb4N/tnwlnfGMXqfuC5I4m10iolg9ec9
         zsBlkDZPEjTfGpkrVsFXsgb2TVHqk/Kg35ESM3GfgBGLEP5XhF1Y5ES2fWvDvvd7LXW5
         AaElPHyb0q7Mqson8kJtup39ExVr46H3Nfhqb2jHalw7cctHy0QbsdgO7aENH6bEDtMT
         BnB4XVdaRShoT8HOxrfS39Y2lBFMGOtTtFdOOA8KvJSH54NiCxCD43MgpbnFqCrJuKtp
         Ab3v4S3saGZAKo4VmVH7EX+hKy3VhLr1+U6sp5aVkIU1b6slbF3RZM3a68X3IkIAVmsm
         JUNA==
X-Forwarded-Encrypted: i=1; AJvYcCXAGoVj0TK24o9V9TERTGgGZJf33EOdg1jCjtM7l47awssGbSaH6WvKG4Xwxr7U/Ing+f+wtMFcJTgujQ2NZhhuTPRg
X-Gm-Message-State: AOJu0YygdNtKP96Uz3RmvNwBcih5rYAmgkNmgLSVpbvJmzvTH/YRYzsr
	AZYf959eO62To/Nm4ye1URUq7GbUtXt1ub0giHZRBwx1+v8DUv+TvVEfRtivw4O95jQeY13Z5H6
	w582CD0XYKJTWwotT95+B+A==
X-Google-Smtp-Source: AGHT+IFuDAD4wtNUkP/2UEse7mwv3qapG5IVIY191z0pQp8MOjMKC9JPX6Ry++6lYE8vhg/RF4vUjCFCzCP7/uR5QA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:30c:b0:610:c400:9e8a with
 SMTP id bg12-20020a05690c030c00b00610c4009e8amr207011ywb.2.1711594029051;
 Wed, 27 Mar 2024 19:47:09 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:47:05 +0000
In-Reply-To: <20240314232637.2538648-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-10-seanjc@google.com>
Message-ID: <diqzttkrkr86.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
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

> Rename vcpu_setup() to be more descriptive and precise, there is a whole
> lot of "setup" that is done for a vCPU that isn't in said helper.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 3640d3290f0a..d6bfe96a6a77 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -555,7 +555,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
> -static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sregs sregs;
>  
> @@ -716,7 +716,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  
>  	vcpu = __vm_vcpu_add(vm, vcpu_id);
>  	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
> -	vcpu_setup(vm, vcpu);
> +	vcpu_init_sregs(vm, vcpu);
>  
>  	/* Setup guest general purpose registers */
>  	vcpu_regs_get(vcpu, &regs);
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

