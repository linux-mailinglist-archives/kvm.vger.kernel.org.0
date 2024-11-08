Return-Path: <kvm+bounces-31243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 559A19C18C7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67DA4B23AF2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0213D1E0DFE;
	Fri,  8 Nov 2024 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jMQhL9Il"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EBD1E00AC
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056887; cv=none; b=l48i2iacJsOB3wCHdt4DsA5b1jE3s0ZFoidYroeb6LhvcuxkbC/H6h/pAgN9Xnh3yRsoj4ZnfvweGKR/u+1biz+lCaPnbMju4/JsUNnCC9RqCII9LJaWs+xRevTuqDfLWHa3Wka3ngPQVLGJMmuxyYZ35coqRkUzVYiQYQG+xj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056887; c=relaxed/simple;
	bh=rji1NgSEnYG766seny/oF7vzi/0rqzl71uSHuI2ayVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mH2GAIswzlhcDni5wVkQd4NWJnDsdQ/8V18On/pD5ult6fU6UA3e78Fx2Sq/0Z6WIa4imG7qkX7DoxamDyuUVGgZVSmQBOxm52k6Hl0uOYvL239JldvVDI3LwyyVfLLgXcMKgO6ilBPZvcyjOybB3oN7YSS+SdfZsB/+aoC7gcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jMQhL9Il; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pXJT4fvshfkZ9WGr4kVPztJYZRbyLmUyPApislAWUUw=;
	b=jMQhL9IlKU/eCvq+Bc3hY6oRwBp99gikgiwDZRGuuFBirSG0LliPqJgbkIPSd4M9aTmPJv
	yIx0cEz08OO1YkEWBuPOKJR+zgrO6HiWwLIf/epCuGPAKlA0mSzCgIrF/L05LkZMXlMmqZ
	0Dp49FnGqOfaQanXzleAtA0cpPjPRZY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-Ycw1Kk8UM_eDJXj3ahxNkw-1; Fri, 08 Nov 2024 04:08:02 -0500
X-MC-Unique: Ycw1Kk8UM_eDJXj3ahxNkw-1
X-Mimecast-MFC-AGG-ID: Ycw1Kk8UM_eDJXj3ahxNkw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314f1e0f2bso13746805e9.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 01:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056880; x=1731661680;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXJT4fvshfkZ9WGr4kVPztJYZRbyLmUyPApislAWUUw=;
        b=Xk8YBc3Z4av/3kSaVxOLoEmlHzeyq1K7FdkmJ0dgqOiGZadwKSnItLqe+X/rmCDM2A
         /NlhS/ru3v/MM7Wz4KglJsrHh1T4UvRbdpSezQQ6zc6hN29+TK7X0FFWsPhJOOeRhklm
         pzH09yuMZe1bSFv8QyH5N/JQJk4VrKUxIE/sLbuoo5UntSxa9d/dZZPe5vXtpc+q+23i
         Rz1mh3/SV0oMPizSuFXMhk+zvEr+8jHmAUqEAX3yxhEjKGdwvu7oKC2DjdSpnR0M8OQ/
         Pd2XTrn9HdYMRuENKbGDfVUq+stpmh2mB4gy1aF9OAbTWKGhZ2k4LXbI4KfqeAVV2f3z
         K2ZQ==
X-Gm-Message-State: AOJu0YynuWBMmhJ53sfRxGPA8HAh6mOKgiB0XJy2p1gbnklrf7gR+q3i
	AHhpYdZp/5Io5zQm4C459oYUkounkb3W3bpQ2nVwHZDV9jTTIfDiCVLXItQzjG9+M5VphCXXu5e
	6pomquJLg6iOqA/EdKwrLL87Pwa8TyVAslkqsosdyDTIJNznmIfum8hzMKb+y
X-Received: by 2002:a05:600c:a42:b0:42f:8fcd:486c with SMTP id 5b1f17b1804b1-432b751f5f8mr14620135e9.33.1731056880631;
        Fri, 08 Nov 2024 01:08:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGUvT8AVR9wC5DZNJzYXbfHT1WEe0sZH4euqeeNl3BRR3mGOctibneYjQL/yXyjBjT68UOUQ==
X-Received: by 2002:a05:600c:a42:b0:42f:8fcd:486c with SMTP id 5b1f17b1804b1-432b751f5f8mr14619965e9.33.1731056880222;
        Fri, 08 Nov 2024 01:08:00 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-381ed97ce27sm3968972f8f.29.2024.11.08.01.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 01:07:59 -0800 (PST)
Message-ID: <dfd53dc4-f62e-4923-b2d1-6b24fa37959e@redhat.com>
Date: Fri, 8 Nov 2024 10:07:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host
 mode) behind CONFIG_BROKEN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20241101185031.1799556-1-seanjc@google.com>
 <20241101185031.1799556-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241101185031.1799556-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 19:50, Sean Christopherson wrote:
> Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
> for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
> myriad bugs in the implementation, some of which are fatal to the guest,
> and others which put the stability and health of the host at risk.
> 
> For guest fatalities, the most glaring issue is that KVM fails to ensure
> tracing is disabled, and *stays* disabled prior to VM-Enter, which is
> necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
> is enabled (enforced via a VMX consistency check).  Per the SDM:
> 
>    If the logical processor is operating with Intel PT enabled (if
>    IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>    IA32_RTIT_CTL" VM-entry control must be 0.
> 
> On the host side, KVM doesn't validate the guest CPUID configuration
> provided by userspace, and even worse, uses the guest configuration to
> decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
> guest CPUID to enumerate more address ranges than are supported in hardware
> will result in KVM trying to passthrough, save, and load non-existent MSRs,
> which generates a variety of WARNs, ToPA ERRORs in the host, a potential
> deadlock, etc.
> 
> Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
> Cc: stable@vger.kernel.org
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ed801ffe33f..087504fb1589 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
>   static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
>   module_param(ple_window_max, uint, 0444);
>   
> -/* Default is SYSTEM mode, 1 for host-guest mode */
> +/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
>   int __read_mostly pt_mode = PT_MODE_SYSTEM;
> +#ifdef CONFIG_BROKEN
>   module_param(pt_mode, int, S_IRUGO);
> +#endif
>   
>   struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
>   

Applied, thanks.

Paolo


