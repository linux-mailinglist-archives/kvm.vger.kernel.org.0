Return-Path: <kvm+bounces-12802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D63DE88DC7C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ED231F27232
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC14074BFB;
	Wed, 27 Mar 2024 11:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WZ/rCmi2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F574423
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538835; cv=none; b=c93NSS7LyxOXSwkKBcp5Aji9iuKux7KSuOxATWcGDT9GK0y0zOVhVBpb7YsDEelsyXJO1OhJ+vHx8G2PFCPUK9WkT6FuJxkVt6YAfRne9OSmrM8X3pOQmBPWx674QkfOpCkWuu5d3VMyYtkfCwXQttj366v8Z7LTIFwWllLvDM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538835; c=relaxed/simple;
	bh=iprutDx41Q3NfOe2YKSdXMTBr7OXdcbQ6k1LZ3bwVVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jpomIKK9BFSBFxiZZramJpfxiA/jfxa6/7CMe/Hw8JT7wG7Za3uESZ4Ra7/d/1LL+mxxK5rCkgC6wWyyOu4Q0u8THDvuPCSUJrYkpxVzqNFJ/QtLUFSXKCoggA91tJkL2EfTElFuy5J2Ds+r5VvGY4ej3SZsCGhqqbdgH6ZJ9/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WZ/rCmi2; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-515a97846b5so3917405e87.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 04:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711538831; x=1712143631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q154uudQ4KvUvBgRzHkbCTAp37wtdIGKs9YPutsHUGM=;
        b=WZ/rCmi26wMTXyIY+fc6VuV+O0oJCZOP8pVFgvDI+WXdDgiinvBNXPoGZslkmO3ych
         P1Rqyxa4EMOBvO0+IgmDWAgqC3GX/eyquEX5pFAcP4PItkB9ym5Qb1pzB19k06hwUtbu
         pHz63FCrNWK0XpEoeq4l49ioDWUhmO7Laxb9BMvui/320D1Axlv0fwpHkgcKYb7Gx7Gg
         JmHX2+CrzpkE4nITiSK83ajkHblmt4b5fjF3Utc5r+bvZ+hSOkzDLsUG2N89no4FTw9A
         T+/h2YNVcEWdxIXfGljcIZUSaEIeDQRxfPkQGpngxfsaXv9c9p6ehRzjoe5ptqer7b6j
         eqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711538831; x=1712143631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q154uudQ4KvUvBgRzHkbCTAp37wtdIGKs9YPutsHUGM=;
        b=ZITelmsnFpM3nu/uChLkK//1nZ87yODs/qoPEl9G3L0Y5Ck9DkmNC/YvWCesJyxbeX
         TgrvSmYMcRTgtyax6gcC7NeBhfEESW7exfziuxEgpmqFK8uO3N1jrUO2OYCC6fWZdT3M
         pF0dlbZqTgmsmPGCCcdwalgzJzitGAJ7iZVJeME8TypzNr9Gd6drciqR9eCaq6Ce+ibR
         iHKS/Z4uWNOk7fD4PpXRIJs9zhSTWTCGDdqmsSBDTbXVX0xZiV9xyx9sDnnnW4H/SvfO
         6WBNlgx98yHURBCFfQ72pCMnFZoc9i+8K4jqdWcA0Gr6dSYEpY8kEE0ND1XYW1e4SeP4
         nw0g==
X-Gm-Message-State: AOJu0Yy+Fz5ke47r0Fk0WLKgETMKRkqx0QN195vN+y8Dv1JT0lTpw3A0
	uTRpCPZbaCmRIjdLRIPCPGwO8Dehn08lPKQ5gqW5U4ydGJBAH/n6WUk0VCSEAOI=
X-Google-Smtp-Source: AGHT+IGkzq2+zNUDZqOyrAAckLGG2m6DUeiGor8Ou4StZpUDOjJ4DIJ5I6eNzjQgBiSzMQ+GEZyKOQ==
X-Received: by 2002:ac2:59c9:0:b0:515:be75:c999 with SMTP id x9-20020ac259c9000000b00515be75c999mr699203lfn.33.1711538831070;
        Wed, 27 Mar 2024 04:27:11 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id w17-20020a170906385100b00a46d8e5a031sm5299769ejc.209.2024.03.27.04.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 04:27:10 -0700 (PDT)
Date: Wed, 27 Mar 2024 12:27:09 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, shuah@kernel.org, nikunj@amd.com, 
	thomas.lendacky@amd.com
Subject: Re: [PATCH v1 2/3] KVM: selftests: Change __vm_create() to create a
 vm without in-kernel APIC
Message-ID: <20240327-7ffafaa84cf972c38cc5f33c@orel>
References: <20240327054255.24626-1-manali.shukla@amd.com>
 <20240327054255.24626-3-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327054255.24626-3-manali.shukla@amd.com>

On Wed, Mar 27, 2024 at 05:42:54AM +0000, Manali Shukla wrote:
...
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4a40b332115d..00e37c376cf3 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -879,7 +879,7 @@ static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>   */
>  struct kvm_vm *____vm_create(struct vm_shape shape);
>  struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
> -			   uint64_t nr_extra_pages);
> +			   uint64_t nr_extra_pages, bool is_in_kernel_apic);

Adding boolean flag parameters to functions, which will 99% of the time be
called with the same value set for them, is not nice.

...
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index adc51b0712ca..9c2a9e216d80 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -354,7 +354,7 @@ static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
>  }
>  
>  struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
> -			   uint64_t nr_extra_pages)
> +			   uint64_t nr_extra_pages, bool is_in_kernel_apic)
>  {
>  	uint64_t nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
>  						 nr_extra_pages);
> @@ -382,7 +382,12 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
>  	slot0 = memslot2region(vm, 0);
>  	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
>  
> -	kvm_arch_vm_post_create(vm);
> +	if (is_in_kernel_apic) {
> +		kvm_arch_vm_post_create(vm);
> +	} else {
> +		sync_global_to_guest(vm, host_cpu_is_intel);
> +		sync_global_to_guest(vm, host_cpu_is_amd);
> +	}

__vm_create() is shared with other architectures, and duplicating part of
kvm_arch_vm_post_create() here is not a good approach, even if the
framework was only for x86.

I suggest:

 1. Extend vm_shape to include a flags field and create a flag called
    NO_IRQCHIP

 2. Add a flags member to kvm_vm and set it to the value of vm_shape.flags
    in ____vm_create()

 3. Check !(vm.flags & NO_IRQCHIP) in x86's kvm_arch_vm_post_create()
    before calling vm_create_irqchip()
    
Then, in your tests, you'll create your vm shape with the NO_IRQCHIP flag
set.

Thanks,
drew

