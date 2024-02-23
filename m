Return-Path: <kvm+bounces-9482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D93860BC8
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76B211C2282A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E3B17560;
	Fri, 23 Feb 2024 08:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxQbWT/l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D09168A4
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708675775; cv=none; b=AWd28arkxIJ+COAdkTz/r46uQxje1bY5b1t8qnLadcl7S5PFUygpYK37A3If9EeU3i7VNz6e2o2TwV341exA9YLiVPzo3jbGnvQpkLEDFepxKamybtIijmVSCNV7+oUd0K9pyWpUmdFVNN0Tv8VLjbXK7qbr/vVmdSPGRHvn+8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708675775; c=relaxed/simple;
	bh=QWW84p5GrQgATfuG70OvAo8L8jzVA1JWtK1J++PSMH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVPQTsLOeFr8HtsnIPkA7vHy85Gm4BQKbKHYenKoP6AHgFsu6dQPp+EicZ9pZ1SmuZ/CiiTItPQcvTBckk6+jECJcT5OZsxPnzInpIdlaINQeiGnl/oMRjFUKD0CFAch+lqDw3G1nLydAhbl25EZhn97FKPSXS95k1Un7pPxFdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxQbWT/l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708675772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pFxByzoRant9Vdp1TGccSpGo02fM+inJwhaMGEbTZEs=;
	b=bxQbWT/lOLIC8Feq4yfbiJPuHOTtnb+HdC9stS3Byk3zkefnFFzYzO/yG2s1AVnx7RscGE
	PwWWWCCnJqJKvUC62qR7Jeh9pm80CsOl9y7kwLcfzS0pw1klg3V2tq+7JorxGYnRGb8XFi
	DNc/zFeRTSBfa/NlcMcgYDg/Px73FLU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-Ps9p5Xk3PrKOUGgW6VRYgw-1; Fri, 23 Feb 2024 03:09:30 -0500
X-MC-Unique: Ps9p5Xk3PrKOUGgW6VRYgw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3fc1f1805bso18660466b.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708675769; x=1709280569;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFxByzoRant9Vdp1TGccSpGo02fM+inJwhaMGEbTZEs=;
        b=KPy6PgfUE1kiRqRWCFisVnYmU4kahSLN+5CUyY55aqEjFt7dv7UffrBcvrZstyfrjp
         6zP7szWyPrbqptmdhVHGx/Z2jIgQTgY5k1OjUmfEImQliW4HvCxRtZw+8F2LF/C4oD8/
         5yhdlSNMhChgmox4HHMef3hbRjohIUIccfi0gUaGMj4Whc5fX5wDvFBHsZTy9M4v55Wh
         a/GEs+e9jJR7SBPfoa7fjZSonvqwxxJw1HeWsU28dbcAVEkDb0Hpt1ycuccuX9UNUMMu
         JEHS8da4u3uFQYXWNYRCj7sP2jOKgnWvVZE2tJp7Eu035kVCI/n8Xm6MRIKFA25H2EXX
         C7xA==
X-Gm-Message-State: AOJu0YzkpSMPW2J078YNE3fbtaTHSDKBXKB4bphHWeGNDJ2TwCoyXmal
	tyR5qn/lwTh9Mx/Af06VyUA3a7UUP9ijY6SmJGIKe5qdvWeD6HmasPqXvPtBlAqxTTKFLej/xnm
	SQEqdfDiguz7bkRC2isCELqLUDtLmvi+RUG/lxX3Lolr8WemFIg==
X-Received: by 2002:a17:906:4ec8:b0:a3f:2632:40ea with SMTP id i8-20020a1709064ec800b00a3f263240eamr705084ejv.46.1708675769670;
        Fri, 23 Feb 2024 00:09:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXzg5Do72JIRxxqVaF3roNYjyn1Qlf8rcNaAAPRCpdlDGU5jKnpFIJVy0y8Tou8baKciT5sQ==
X-Received: by 2002:a17:906:4ec8:b0:a3f:2632:40ea with SMTP id i8-20020a1709064ec800b00a3f263240eamr705062ejv.46.1708675769225;
        Fri, 23 Feb 2024 00:09:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id lf17-20020a170906ae5100b00a3eac4fc956sm4495688ejb.150.2024.02.23.00.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 00:09:28 -0800 (PST)
Message-ID: <34504abb-ff58-4a83-9a63-87f22841adc7@redhat.com>
Date: Fri, 23 Feb 2024 09:09:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] KVM: x86/mmu: Fix a *very* theoretical race in
 kvm_mmu_track_write()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
References: <20240203002343.383056-1-seanjc@google.com>
 <20240203002343.383056-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240203002343.383056-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/24 01:23, Sean Christopherson wrote:
> Add full memory barriers in kvm_mmu_track_write() and account_shadowed()
> to plug a (very, very theoretical) race where kvm_mmu_track_write() could
> miss a 0->1 transition of indirect_shadow_pages and fail to zap relevant,
> *stale* SPTEs.

Ok, so we have

emulator_write_phys
   overwrite PTE
   kvm_page_track_write
     kvm_mmu_track_write
       // memory barrier missing here
       if (indirect_shadow_pages)
         zap();

and on the other side

   FNAME(page_fault)
     FNAME(fetch)
       kvm_mmu_get_child_sp
         kvm_mmu_get_shadow_page
           __kvm_mmu_get_shadow_page
             kvm_mmu_alloc_shadow_page
               account_shadowed
                 indirect shadow pages++
                 // memory barrier missing here
       if (FNAME(gpte_changed)) // reads PTE
         goto out

If you can weave something like this in the commit message the sequence 
would be a bit clearer.

> In practice, this bug is likely benign as both the 0=>1 transition and
> reordering of this scope are extremely rare occurrences.

I wouldn't call it benign, it's more that it's unobservable in practice 
but the race is real.  However...
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c193b096b45..86b85060534d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -830,6 +830,14 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>   	struct kvm_memory_slot *slot;
>   	gfn_t gfn;
>   
> +	/*
> +	 * Ensure indirect_shadow_pages is elevated prior to re-reading guest
> +	 * child PTEs in FNAME(gpte_changed), i.e. guarantee either in-flight
> +	 * emulated writes are visible before re-reading guest PTEs, or that
> +	 * an emulated write will see the elevated count and acquire mmu_lock
> +	 * to update SPTEs.  Pairs with the smp_mb() in kvm_mmu_track_write().
> +	 */
> +	smp_mb();

... this memory barrier needs to be after the increment (the desired 
ordering is store-before-read).

Paolo

>   	kvm->arch.indirect_shadow_pages++;
>   	gfn = sp->gfn;
>   	slots = kvm_memslots_for_spte_role(kvm, sp->role);
> @@ -5747,10 +5755,15 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>   	bool flush = false;
>   
>   	/*
> -	 * If we don't have indirect shadow pages, it means no page is
> -	 * write-protected, so we can exit simply.
> +	 * When emulating guest writes, ensure the written value is visible to
> +	 * any task that is handling page faults before checking whether or not
> +	 * KVM is shadowing a guest PTE.  This ensures either KVM will create
> +	 * the correct SPTE in the page fault handler, or this task will see
> +	 * a non-zero indirect_shadow_pages.  Pairs with the smp_mb() in
> +	 * account_shadowed().
>   	 */
> -	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> +	smp_mb();
> +	if (!vcpu->kvm->arch.indirect_shadow_pages)
>   		return;
>   
>   	write_lock(&vcpu->kvm->mmu_lock);


