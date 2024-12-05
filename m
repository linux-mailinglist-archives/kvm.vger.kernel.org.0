Return-Path: <kvm+bounces-33119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 914D09E50BE
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 775F716AEAD
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63421DAC9A;
	Thu,  5 Dec 2024 09:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CKpzL5Ir"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98571D5CFE
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 09:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733389584; cv=none; b=DktIsQWpbvyacCcWg6An1d37Cun5B/K5b/WbR8TIv1W+XA0CUWBXXRRDvukaCq1F+9ycmKyR3rqZmy1I9svTCM9Qo4MPou72Dh95WGIzTK5VZKT6DLUwmhE3YMu3Jkl7ACOF/FuPd+h9kgAA4oyYAOvaX1+rjYelx01sR3kClBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733389584; c=relaxed/simple;
	bh=5XQ1HXYwbTTZdTWh2utJMKfmU8iPPThgBP2pbSMhge4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1c4k6BnAnJABNZrfaOLEETjCL1m4oeJ4pOlG570RwSPdhPKMbKMI87z1JygXfT1XCesYaBdOLuaISEoxs7GHflQyTs6mzqRTfzuj2VSp9RnqwK9xhLbT9TBvHGqCBmrB7MkAQWi1IdB6FjUuNd2sbKKobz4LEh+Oq+yOXP+xHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CKpzL5Ir; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4349e4e252dso7476185e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 01:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733389580; x=1733994380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2t7W4OrRjFhEWmecg84hD7xOx3YqRZ5sVEwAFgCNS2o=;
        b=CKpzL5IrX0eIk0XVzZ8UGfVYS83tv0biAwoyaTHfbfYUYxGJiS5xbMGxd6R/prvi2q
         FKps1xaqQYTLemjXnz1/cg9KBvdAPKiFSbl9I0FU2cFb1O87Xrqn4hOz706YYuGg94c2
         WmaZr1SVx343iBUPWVkkAnqB6kAJD+OHQG5N2nutrZaqPsGLg/ZCTs3NE5fdwMPVCRJp
         wgGb2levSUdUpFSwEJlhRrRC8NFcUS+8nYm6NgcZZJt2nAGCp1Hgq5JF1Hg5D3srXcao
         kz3gy1W/FjqXLxS95y4SyNs2FbP1pBJt2FY69Im0rNGwT1oQRM9pbCndHFT6ucDZqoSi
         /atw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733389580; x=1733994380;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2t7W4OrRjFhEWmecg84hD7xOx3YqRZ5sVEwAFgCNS2o=;
        b=N2MU4XhW6RFJZFztHX/VbuH47S1sKD6hAZFtPURqFep8U7V2e6DgetDQEmH1ysUEDU
         NbGKUvQNwp2UPFc91i2eGB6oMqBK5R7fLWlnpbT1qD2lIfOd9UmNPiiCqFODxCQ0yVHr
         XS+e/G0wmwWV3qsSrqDCeeHoKwQHb2DtA/EpjidsHUMpfBtn+n95G/nUDTwbwj5Hkog2
         Z4zRck4D0AATaT5/+ISNM4yIKtIdnNLaJ5HjG2upUtsXnWsYleH59dgRiryOneuUj2Ux
         ZRwSwsH6EBX9f6t31XHH+TJi3Y01Xbi+8GQ52qwJfj+D1G30LYivgi3IH6yXXkBOK8ja
         zBRg==
X-Forwarded-Encrypted: i=1; AJvYcCWn0YQT9xDJtx3RNnatFUr+Fz0JwAepKJV+vT1L4NzNYQW3lJtidlEwF0eZBV65Wg6GGow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAMS6y4B64/ibg82NkW6Tn2pUQKtTmlxT9vRAUkepaBIX2YVwk
	Qb+GtiVNX0gS9lqT/J1fejAMvZoVGkXYri2WM5U8qLX8WIQoGJHuhVd0gVYig7g=
X-Gm-Gg: ASbGncuyvQnY8/w1AWDM9jOOwEgkQvEbBwEDoGy87tc7qiqqkTQKeNWgc4AvluzXUQ6
	Ivekt+WQ/DwID299YjXh5eODvNwj5frTc9PeDdUuXJ3mZ1/aFLAkt3Kx2oO3Iy0sVsTXlcc0rms
	ujxEmmBDhA5SWpnKpgnQECflF1ua80Jpi/GqoSsQKGP5dDwkqd0BYeq2ezaztKeXz9rxw8xFITX
	Hzafeh3bRibczXbSjB+Q+rOGR8ocWks/1gSghSoY6GHWNZhX4MjyDUejM3Hvk3s/JQfV/DSi0U=
X-Google-Smtp-Source: AGHT+IE1W5whVS1H/s6P2CDbG6g4KdyVwl+f7pWy6cAjeTZPQLXiw15uiJrpsamNn8FKlX2vxkufWw==
X-Received: by 2002:a05:600c:3b24:b0:431:3933:1d30 with SMTP id 5b1f17b1804b1-434d346df9amr69721745e9.5.1733389579936;
        Thu, 05 Dec 2024 01:06:19 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.217.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da113508sm16760695e9.35.2024.12.05.01.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 01:06:19 -0800 (PST)
Message-ID: <62539c75-8f4e-4e12-bcb4-55c46cdf646d@suse.com>
Date: Thu, 5 Dec 2024 11:06:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
To: Mike Rapoport <rppt@kernel.org>, Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
 peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
 mingo@redhat.com, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 rafael@kernel.org, david@redhat.com, dan.j.williams@intel.com,
 len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
 ying.huang@intel.com, chao.gao@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
 sagis@google.com, imammedo@redhat.com
References: <cover.1699527082.git.kai.huang@intel.com>
 <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>
 <Z1Fc8g47vfpz9EVW@kernel.org>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <Z1Fc8g47vfpz9EVW@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5.12.24 г. 9:57 ч., Mike Rapoport wrote:
> Hi,
> 
> I've been auditing for_each_mem_pfn_range() users and it's usage in TDX is
> dubious for me.
> 
> On Fri, Nov 10, 2023 at 12:55:45AM +1300, Kai Huang wrote:
>>
>> As TDX-usable memory is a fixed configuration, take a snapshot of the
>> memory configuration from memblocks at the time of module initialization
>> (memblocks are modified on memory hotplug).  This snapshot is used to
> 
> AFAUI this could happen long after free_initmem() which discards all
> memblock data on x86.
 > >> enable TDX support for *this* memory configuration only.  Use a memory
>> hotplug notifier to ensure that no other RAM can be added outside of
>> this configuration.
>   
> ...
> 
>> +/*
>> + * Ensure that all memblock memory regions are convertible to TDX
>> + * memory.  Once this has been established, stash the memblock
>> + * ranges off in a secondary structure because memblock is modified
>> + * in memory hotplug while TDX memory regions are fixed.
>> + */
>> +static int build_tdx_memlist(struct list_head *tmb_list)
>> +{
>> +	unsigned long start_pfn, end_pfn;
>> +	int i, ret;
>> +
>> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> 
> Unles ARCH_KEEP_MEMBLOCK is defined this won't work after free_initmem()

TDX_HOST actually selects ARCH_KEEP_MEMBLOCK:

   6 config INTEL_TDX_HOST 

    5         bool "Intel Trust Domain Extensions (TDX) host support" 

    4         depends on CPU_SUP_INTEL 

    3         depends on X86_64 

    2         depends on KVM_INTEL 

    1         depends on X86_X2APIC 

1980         select ARCH_KEEP_MEMBLOCK 

    1         depends on CONTIG_ALLOC 

    2         depends on !KEXEC_CORE 

    3         depends on X86_MCE


<snip>


