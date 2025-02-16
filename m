Return-Path: <kvm+bounces-38321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0775A37694
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 19:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A22BC16D7E4
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 18:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D632B19E96D;
	Sun, 16 Feb 2025 18:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+JJulZP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADC5154C05
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739730403; cv=none; b=Q2mSHPRyapsfMwPSwn1Zgk4lIWSYuc0Igln8pKmAxd40VnyEJQWkgT6Miibtr7mn9iSODqh/eFRN8sJV4MkPxL391whqqDs6EOak7iJMjtdAMWK2VuKiKcmJD/1HHi4SF7hIWUPJLyO1drDfu2AJ7eR093C376P6MphlLvToG+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739730403; c=relaxed/simple;
	bh=Y/LuZ+y1LHMMuqQJizlowi3f8Sz0wsZbNk/mZuwrRyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WCGK/ENfiC1dKdrQ8fMmxeZInEjAC9kkJBViCYVig9Zsg7ZXLFTipPGiGRkrnupgYTe9G8ccqho2pUCj9rtBXwwD2ulzKrfovZNjgDH180fhlxeSwxS86slhmgX8VhjUNjvETBbDq4BnK9rCnyMNPcGU5/HHSiv1xv7RAmXYBlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+JJulZP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739730400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0qUnpIEotEDFzC8jwR5Z3hGPfKph5TWJ9N2byfk13X8=;
	b=V+JJulZPZVfZc0EE+aHs9yzIVCkd3KmCOqlZKIX7eM+jUcY865XYTc2MI6+lPEq0Es8o+R
	Q5gIDRF+PtfaBfF78HGukksJ+tBVt8SMtpCBak91m6dRgngdWOSfwzi6yv8/R5EHiIMrDr
	32pDxuQS+jC6qx2TWsh4IQIdWepT/MU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-mKUzYdfFOICAwja0zTgFBA-1; Sun, 16 Feb 2025 13:26:38 -0500
X-MC-Unique: mKUzYdfFOICAwja0zTgFBA-1
X-Mimecast-MFC-AGG-ID: mKUzYdfFOICAwja0zTgFBA_1739730397
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4395b5d6f8fso20054175e9.0
        for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 10:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739730397; x=1740335197;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0qUnpIEotEDFzC8jwR5Z3hGPfKph5TWJ9N2byfk13X8=;
        b=lB2nYFCJRO2MGftGEs2Ts7aV4Ofbobp7jpveMc7rxeNpnzWiScY0V457M3gnIcUE6L
         q76xKJH7CoEPlX4FUwpv/2jNArFKawJQFHeNwiCwZQckvc9iuQKKIQOPJgZJDGUmjL0s
         QHtlFnQkAr8MkaBI3K4LeEo3eiGJ+jFHct9VpFkOjEij9/8QcsIr5Dpdw6vZX1iSx0SK
         rQkbfvoEZbW6qyhF3szBX6hPA5Y7g5lTUxTNqRE3D/qOTgWgJFCsTmsjfK01Gn38bwob
         iSCLmSL2YZMflj8GqiuCBAJKILf7tkFJNcg2Ux9pQ/zUhIaWuM/KcuajheVvK87WlGob
         AKZg==
X-Gm-Message-State: AOJu0YwcGVCglG2ayxQt0Pp6VTPF++4hiHL+o7KDkqZeyzWS4Uvu9bM9
	CE4gEZDtE/k8/6B2AcfIcgwpvcX1a2cUzJFs6hgIi6okN1FLXn2hx8einL8ikD1ZZYuilmM4cVa
	z3wDZq6efXOV1ax4DOyGqzed/+X68LxGVeR7EkAabJREl4at1ow==
X-Gm-Gg: ASbGncsycngdjYbZs7T02nlB/xfe6NjYr4gs7vQT/b688dqlwmec7nUjmlC2VM3uoRK
	RgwTyODQKe+0tJvz46cNOpU4nITfiK++iUpuEpqT3sq298J0kMhM/lXfIWjD97KRd2Nob1zKVec
	W5L85IBt6v4oddgRagyFFInpalsCj4R7cBurdPqD7BXYOS/Zm4Dj8031xgv5uOxpYuIZX9ifx5p
	ebKa6E+MNNQT1B017EpSc2Mntc/cuV2x9n37g0JxPdi+quQs1GMPY0IYOPKpNQXd+DVs83XcHJd
	Tdu+gPbWCQ8=
X-Received: by 2002:a05:6000:1b02:b0:38f:2bee:e112 with SMTP id ffacd0b85a97d-38f341708a2mr5846753f8f.45.1739730397159;
        Sun, 16 Feb 2025 10:26:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHU852ANofr7l6L4LfZEnPNpkucPJmxoYAM56W5GbeuwuCrVeNqnARgV7I8xoIvOnMq1BplTw==
X-Received: by 2002:a05:6000:1b02:b0:38f:2bee:e112 with SMTP id ffacd0b85a97d-38f341708a2mr5846738f8f.45.1739730396776;
        Sun, 16 Feb 2025 10:26:36 -0800 (PST)
Received: from [192.168.10.48] ([176.206.122.109])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38f258f5efdsm10053303f8f.43.2025.02.16.10.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2025 10:26:36 -0800 (PST)
Message-ID: <0c2bb665-93ee-4f46-ac28-5dbd1dd2b9a2@redhat.com>
Date: Sun, 16 Feb 2025 19:26:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/12] x86/virt/tdx: Make tdh_vp_enter() noinstr
To: Adrian Hunter <adrian.hunter@intel.com>, seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com,
 weijiang.yang@intel.com, dave.hansen@linux.intel.com, x86@kernel.org
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-2-adrian.hunter@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250129095902.16391-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/25 10:58, Adrian Hunter wrote:
> Make tdh_vp_enter() noinstr because KVM requires VM entry to be noinstr
> for 2 reasons:
>   1. The use of context tracking via guest_state_enter_irqoff() and
>      guest_state_exit_irqoff()
>   2. The need to avoid IRET between VM-exit and NMI handling in order to
>      avoid prematurely releasing NMI inhibit.
> 
> Consequently make __seamcall_saved_ret() noinstr also. Currently
> tdh_vp_enter() is the only caller of __seamcall_saved_ret().
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

This can be squashed into "x86/virt/tdx: Add SEAMCALL wrapper to 
enter/exit TDX guest"; I did that in kvm-coco-queue.

Paolo

> ---
> TD vcpu enter/exit v2:
>   - New patch
> ---
>   arch/x86/virt/vmx/tdx/seamcall.S | 3 +++
>   arch/x86/virt/vmx/tdx/tdx.c      | 2 +-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> index 5b1f2286aea9..6854c52c374b 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.S
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -41,6 +41,9 @@ SYM_FUNC_START(__seamcall_ret)
>   	TDX_MODULE_CALL host=1 ret=1
>   SYM_FUNC_END(__seamcall_ret)
>   
> +/* KVM requires non-instrumentable __seamcall_saved_ret() for TDH.VP.ENTER */
> +.section .noinstr.text, "ax"
> +
>   /*
>    * __seamcall_saved_ret() - Host-side interface functions to SEAM software
>    * (the P-SEAMLDR or the TDX module), with saving output registers to the
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4a010e65276d..1515c467dd86 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1511,7 +1511,7 @@ static void tdx_clflush_page(struct page *page)
>   	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>   }
>   
> -u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
> +noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
>   {
>   	args->rcx = tdx_tdvpr_pa(td);
>   


