Return-Path: <kvm+bounces-14219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1228D8A09E1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95245B28DB4
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B23813E3EA;
	Thu, 11 Apr 2024 07:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OnYo9f6F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B4413E051
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712820861; cv=none; b=hR0Z1a7974NeYdwwL6RIc8FvIP27irT9/iydXl0ubzKZPdiHTOM6tgqK2WdTrPp3DtFK8pHkOjfu1WI2wHqvFfOMUjouDo4lxxqHY/VIT78SLbXxLoN98aEAf/l3shlw1UgQ7V/4l+1IG2OfgJJ8zKF/Uw1rJhHsFPNAeqs6uvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712820861; c=relaxed/simple;
	bh=ojroZZ6DK7sZCL3Rb//I2pRRil1byCEGJX57QkfGfBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ri5u0h7sL352X35bMp1nCQvKD8Ox81v4LB9Gw4DL8FnbjQkmZYsTBcPvY2R7nFjpLKys0RawO7J2PNCvMz+gpYxrBtTd4GVGSD4/sA0PaUnXdDgA5dYri3UGSmYg6on7BdzMWF+Oriy5SLS/HbuOrMtOJtw8RjuwpcWIvz3UJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OnYo9f6F; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d485886545so132077031fa.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712820857; x=1713425657; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ziH5rU/CBu+qmF3mhBPcBiduQQEPNVJWeJxnp4JBd6g=;
        b=OnYo9f6FQG3i4PfbqiMx5PMKJ94wTjfLsE8gASwMKJook9TpM+5jGZaIkE4fI7kAmo
         8q0Ad87xD6Sc+ofadepZ7kBBl71OAmhXY33RlCQw441HRJF1errQ1uiubPu/P5KzI9wi
         OykF0hHmSGWSWEClxkq20DJcQqRzSM3rlKxlAce9jXeNYMhpJLzX/eWaet5xm+cSR//J
         Av7yIJcTCAdw4KQx6mhEx6Gfq7OI8L5WuCDMFwzTMupX5uteDpDWRxE+UjnWsj1EeFMs
         VPzriqm/7HlvpDmwzrJlfisIM8dGKAm9Cw05MyP2KZ2AFluurKS2QXSIp2SdDrJYHQuC
         a1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712820857; x=1713425657;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziH5rU/CBu+qmF3mhBPcBiduQQEPNVJWeJxnp4JBd6g=;
        b=a8v4pwtIDNpY/0yiJGCd6L2CsHoRYl8ClYZR5RyT/eFseje9Lj7Tn+5cTLhlqcMAZQ
         TP8159Tqb+SajkBMuQ9hZiX6QMpRLrsfNPeLNREE38T+HDbJbTB9DcvhpY9C+rz2Dt+q
         QtL+fe/w972R6BwE0NaYNqn3dTUxWnStZUaBdmBfzJUTpdqMXEvEmA5ViqO1BiVR8Qmi
         pYss82yQ/C4hQno81dALUhUMABxXYzQPOdfAP0vQpIykQuo4uc52aF34TAdCctegIfl6
         ievlT9IAfvLc2tFUAIH+5qwDInzTrwIpae7ZxlXx8Z27mUDrcYTDeDRcRk0dfBD45Vnf
         z+xA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ7y8H5NGRy+MAIw3OLANuxY/0w/9RAcnfm4lmZAorRfZGtK5j26lw8pEVzPPGQA2o9dcQ3cQOBL5pfYDjIM3CjFZh
X-Gm-Message-State: AOJu0YxYkZm2s3bbduEYGNE++UUd4WgXQUbhKSVorkgM8rYDIXIJZqep
	4R5MhAb38mPwILQ10h/p8Ok/+6ukE5HvMJv6GfyuGhy8PG+w5aOi9Bwee9tWBRA=
X-Google-Smtp-Source: AGHT+IHxcJSU7rAqjYfI01R/MpR//jFPN2akwpN1LcKcRRVFCmhMFUjwJ9ixqbhpRJzSwgDyuhm1BQ==
X-Received: by 2002:a05:651c:2c1:b0:2d8:2d0a:7b9b with SMTP id f1-20020a05651c02c100b002d82d0a7b9bmr4251909ljo.14.1712820857304;
        Thu, 11 Apr 2024 00:34:17 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7318:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7318:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id bi8-20020a05600c3d8800b00417e184dacbsm394768wmb.25.2024.04.11.00.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 00:34:17 -0700 (PDT)
Message-ID: <18b29bd6-5eb5-4344-b80f-f6a55c18b8ba@suse.com>
Date: Thu, 11 Apr 2024 10:34:15 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240411072445.522731-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.04.24 г. 10:24 ч., Alexandre Chartre wrote:
> When a system is not affected by the BHI bug then KVM should
> configure guests with BHI_NO to ensure they won't enable any
> BHI mitigation.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>   arch/x86/kvm/x86.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 984ea2089efc..f43d3c15a6b7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>   	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>   		data |= ARCH_CAP_GDS_NO;
>   
> +	if (!boot_cpu_has_bug(X86_BUG_BHI))
> +		data |= ARCH_CAP_BHI_NO;
> +

But this is already handled since ARCH_CAP_BHI_NO is added to 
KVM_SUPPORTED_ARCH_CAP so when the host caps are read that bit is going 
to be set there, if it's set for the physical cpu of course.
>   	return data;
>   }
>   

