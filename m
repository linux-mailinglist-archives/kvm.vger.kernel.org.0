Return-Path: <kvm+bounces-12944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A74D488F594
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 340671F30685
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFD12C6AA;
	Thu, 28 Mar 2024 02:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ztI2NMIK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8D52BAEA
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594366; cv=none; b=dWituyCLjTicSD7VHV46FRc2AuhZ+G6tFKpxLRX/I4ekDbWfdnicpJKwTitB4I98ok8xYpak1cHDk/QoafdUcN/s1ogtAcqAkAsgA38z79CL1nVnlnr7JEUxW9kwj6QN3ls+u2wlJtg81EdCtpCFxf76kKhd3trQtKVs+ekM11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594366; c=relaxed/simple;
	bh=ykf7Ad9a1dePCbqY5SnqMxWyPGzdcdR0pVcX9fx1Jrc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CvNORA/2pT2zWHI97xa7C7kHOv7KPdMobck2TY9EMLueFCi5GM8qkLK6s7OcGlVHfjZ/80iTv/P5uEr0DmrT4KUP+NcjRZZxnnnD7qMtm3FfHAEVIxAZb3TOnecImltHxr34h+uHXoGbha8HBCoiaP4PVmdMHSeeKj0MwuaRQFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ztI2NMIK; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so732664276.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594364; x=1712199164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1Koe+Yskb8UPW0Ibn6wgFaDBKMELyCNXaqBSGpiIg=;
        b=ztI2NMIKKwj4DLNtW4ha6EML8VNQJlOS9ooC0VIYhiwuV4XKmRQPl+V9NMhbEJTYTb
         okZ8poGii5QPsqM73G3095IKpns9YMxu2ow2UKYKsM7PGkwNDpYIBwSulgJXULN59gKY
         N3ig6rKqvZeIMzvbmn5N49WMQlCDO2zbJ27RLx5eIimLeO8Xftzbk6hUma5ExJCo7umO
         gnkonbH9HFCpq0idGVoKwDamsPmH3/4X2KUPhCOaJ3R/CZO9lq88+GBb6Xl0w/p+6//D
         BT1n1VY+8eNgGOd/cXaH59w0kgSR+afdyfRHfmrnjLinTZ7gXUou4lfWOZMz45Ykz64q
         ilUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594364; x=1712199164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1Koe+Yskb8UPW0Ibn6wgFaDBKMELyCNXaqBSGpiIg=;
        b=Nvzz0iRRjQluQ1lFRrmvzTSPgMjhHiwsKRTqv2KM0g5DGnvq+whykYHPrEjYj1BtsS
         mB18Ys/+mO3A9DbaI84APg4FwE5hGV1+bY6jW/CGLXGpO/T8SUH8ysGGa9NmS93qpxCG
         xTrRPuON0qlMDE4sYJIzwWhA5kPmYsdh2Oye0S06Z8gaUFyMiJfdUA6aULIYk85DFH/Q
         Y+XhDC18pkPHYWqVciSa/3Q+9k1GXLemCXDuULa9Yk0fpjXdHMUiOngZEJadclw/53M0
         ZfGZ8hfOjuuCwwVaq3dGmjkvb4uIBND3GQ1QmZvuRI4sgTew2BM7XNGKg2Tj+VOm4xr5
         LrrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyFmY26wapM33KapQDkQ+hIWJeJqmVinySX+naIESE2Qe1XTKv1Q4oBjvREwJfZpR42nm8w6DgjUrLrxzsHZPzlqRs
X-Gm-Message-State: AOJu0YyxY5ImV+XsvPhJf1OiBRHwYMyULTgBeOOJfAhQHKD0QYCsBpF4
	ZDdHFetmUgMv8tVgT8xe9PcCrBNTHLZyG6cX2QH4djBU5RjWBgpme4ObT6fp42WUX8+udTZy+F5
	koDkToIMm6ycBvx1ZuR40HA==
X-Google-Smtp-Source: AGHT+IGamct0CFbVaOo18kFqPCJIWWo6VB9ZmUglKKzir5OBthVLSFpJRBv0Ez69oxdAsU/6PDiZ+aH4G55jCyDSpg==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:124c:b0:dcc:8be2:7cb0 with
 SMTP id t12-20020a056902124c00b00dcc8be27cb0mr125722ybu.0.1711594363911; Wed,
 27 Mar 2024 19:52:43 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:52:39 +0000
In-Reply-To: <20240314232637.2538648-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-17-seanjc@google.com>
Message-ID: <diqz4jcrkqyw.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 16/18] KVM: selftests: Add macro for TSS selector, rename
 up code/data macros
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

> Add a proper #define for the TSS selector instead of open coding 0x18 and
> hoping future developers don't use that selector for something else.
>
> Opportunistically rename the code and data selector macros to shorten the
> names, align the naming with the kernel's scheme, and capture that they
> are *kernel* segments.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 03b9387a1d2e..67235013f6f9 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -15,8 +15,9 @@
>  #define NUM_INTERRUPTS 256
>  #endif
>  
> -#define DEFAULT_CODE_SELECTOR 0x8
> -#define DEFAULT_DATA_SELECTOR 0x10
> +#define KERNEL_CS	0x8
> +#define KERNEL_DS	0x10
> +#define KERNEL_TSS	0x18
>  
>  #define MAX_NR_CPUID_ENTRIES 100
>  
> @@ -547,11 +548,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> -	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> -	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> -	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> -	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> -	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
> +	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
> +	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
> +	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> @@ -620,8 +621,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
> -		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -			DEFAULT_CODE_SELECTOR);
> +		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

