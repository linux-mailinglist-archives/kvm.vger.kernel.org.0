Return-Path: <kvm+bounces-22505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B13393F6B4
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BA6B1C21824
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D238149015;
	Mon, 29 Jul 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idDnY1Ef"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD68C06
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722259868; cv=none; b=oQjcUPZrd+PRfDT9RziyfAJtnlHw4jk1lRyXlYy1FXoZZ5yWlqAwKJIUeRd8nP3/j8zey0O4vkd9sgJL+8Y1ICu4CtmquYZYQff1JsG1K8u6MMTRksvgGlrQkVh8CnmhDB6PcpezCw90mdkhlimhxQ1XyxLt3rfLiJ1fuZO86sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722259868; c=relaxed/simple;
	bh=XsHOodkGVugeYBKiy3NN35QUunVskHzFOlmmNRL11kM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AeFI7FuOdZxN6yekBgw4IJm4+jemwgnGPbHlDvAPC2lj3NJaZPzNcUgO+bsm2PPm1E72xJEKe3/MhGnYW7jnj62MweeWPml8PwrbehGJ3FfCcbQS070mMZJt9FqDZZRQJ5ncN/7Fp+eKFO1CrBT9njHtMOEZNvvGG8Kgsa07zck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=idDnY1Ef; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722259865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BlLuGikkUGKCvXsXriKTsyTsgVOTK7WyWyEUec7ttEo=;
	b=idDnY1EfJ2WTrG8jfs3NOpr3pyECgVdao9N1oQYvMdcibpNTqcrJErY99mmV/h5PhfBphS
	zeO0q54NKb/8uFEftmuiGY8CkkHm3dEn3UW9/9DECEfWsJJdIYh0sKQxydVZwuPxR30KJi
	78jompMRylc49giNgN/PnioXWfgqU0s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575--5Vnpgh2MMOaRoM-cl4iCA-1; Mon, 29 Jul 2024 09:31:03 -0400
X-MC-Unique: -5Vnpgh2MMOaRoM-cl4iCA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4280291f739so17868305e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 06:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722259862; x=1722864662;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BlLuGikkUGKCvXsXriKTsyTsgVOTK7WyWyEUec7ttEo=;
        b=m61ph6Ac3NJtGrH1HIoR1Ni69MHCwGZiGJ+xdHp1ZI1C8zojTrHndrTS5CdAn9tMG7
         Dznp9pnbcnHHlpgVufiGtIEmfh+OfD2sz79WLpxgb3WoHgdyXwHGiW4cXftewA2BijGT
         tzqfVWHGrZJv1d4VNctMUKt4t7HQQfGPxlUMETL9rweK3N+gWUOnfApyGZwkhAw+KVVP
         VXWuZfFr8bnvQSKUwwm5Za+6TuKH75T2OvhriyvhoRluqwMVaJOe5kzDy8zMP/jzkq+u
         lmKiEZdk0d3hGHib1mgdcbOt91C8rLXgz/D5mvv3gF2FrXg+qqOHD3HCCRpnsP+ZbvzW
         iR3w==
X-Gm-Message-State: AOJu0YzF0/2GAYarleH5rxL2jlzdnNBUGieV7AxejsD8HTdvmbPzPp4E
	aIs30pKPq94kluE2Y1f2BRfuKKISmRFMu9aF/nnCIYJQjBfxR+vQahgvsGnUoYbS+FeoPj0vvV0
	CIYggj4TwznMD1zq+zwLni9uOAW1MlKtsrXWIilwxaVEZWZsyPg==
X-Received: by 2002:a05:600c:4b1a:b0:426:64f4:7793 with SMTP id 5b1f17b1804b1-42811da7dd3mr53752745e9.22.1722259862383;
        Mon, 29 Jul 2024 06:31:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMndcFYOEWtmUpK603jitEUzAiFadBmIa0FTnXJv33+nbkyn2Th00kSMWmDtDaf3Zoy7ZjjQ==
X-Received: by 2002:a05:600c:4b1a:b0:426:64f4:7793 with SMTP id 5b1f17b1804b1-42811da7dd3mr53752525e9.22.1722259861832;
        Mon, 29 Jul 2024 06:31:01 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36858148sm12306885f8f.72.2024.07.29.06.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 06:31:01 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>, Sean Christopherson
 <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [BUG] arch/x86/kvm/vmx/vmx_onhyperv.h:109:36: error:
 dereference of NULL =?utf-8?B?4oCYMOKAmQ==?=
In-Reply-To: <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
 <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
Date: Mon, 29 Jul 2024 15:31:00 +0200
Message-ID: <87a5i05nqj.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mirsad Todorovac <mtodorovac69@gmail.com> writes:

> On 7/19/24 20:53, Sean Christopherson wrote:
>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>> Hi, all!
>>>
>>> Here is another potential NULL pointer dereference in kvm subsystem of linux
>>> stable vanilla 6.10, as GCC 12.3.0 complains.
>>>
>>> (Please don't throw stuff at me, I think this is the last one for today :-)
>>>
>>> arch/x86/include/asm/mshyperv.h
>>> -------------------------------
>>>   242 static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
>>>   243 {
>>>   244         if (!hv_vp_assist_page)
>>>   245                 return NULL;
>>>   246 
>>>   247         return hv_vp_assist_page[cpu];
>>>   248 }
>>>
>>> arch/x86/kvm/vmx/vmx_onhyperv.h
>>> -------------------------------
>>>   102 static inline void evmcs_load(u64 phys_addr)
>>>   103 {
>>>   104         struct hv_vp_assist_page *vp_ap =
>>>   105                 hv_get_vp_assist_page(smp_processor_id());
>>>   106 
>>>   107         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>>   108                 vp_ap->nested_control.features.directhypercall = 1;
>>>   109         vp_ap->current_nested_vmcs = phys_addr;
>>>   110         vp_ap->enlighten_vmentry = 1;
>>>   111 }
>>>

...

>
> GCC 12.3.0 appears unaware of this fact that evmcs_load() cannot be called with hv_vp_assist_page() == NULL.
>
> This, for example, silences the warning and also hardens the code against the "impossible" situations:
>
> -------------------><------------------------------------------------------------------
> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
> index eb48153bfd73..8b0e3ffa7fc1 100644
> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
> @@ -104,6 +104,11 @@ static inline void evmcs_load(u64 phys_addr)
>         struct hv_vp_assist_page *vp_ap =
>                 hv_get_vp_assist_page(smp_processor_id());
>  
> +       if (!vp_ap) {
> +               pr_warn("BUG: hy_get_vp_assist_page(%d) returned NULL.\n", smp_processor_id());
> +               return;
> +       }
> +
>         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>                 vp_ap->nested_control.features.directhypercall = 1;
>         vp_ap->current_nested_vmcs = phys_addr;

As Sean said, this does not seem to be possible today but I uderstand
why the compiler is not able to infer this. If we were to fix this, I'd
suggest we do something like "BUG_ON(!vp_ap)" (with a comment why)
instead of the suggested patch:
- pr_warn() is not ratelimited
- 'return' from evmcs_load does not propagate the error so the VM is
going to misbehave somewhere else.

-- 
Vitaly


