Return-Path: <kvm+bounces-27701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D32E598AAE9
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 19:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 638831F21F57
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCBE1957F4;
	Mon, 30 Sep 2024 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f50r3ayZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CAE273FD
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727716677; cv=none; b=ZixE22ZcTUBFVGrdWXeHw21etAwQKuCu7onDU9H1OP2eiaSvmC3lSiXL7Z0BQYYaSBJgOCA148DgaZMhqExA7DVW3UBCT0Npe4yBK9vz7z5yPpYm/LE638SHKv1HqGJi1uPuCc7ghoXeOjXHSNAkxEp2r9GlfgJMgnVr6+ziqZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727716677; c=relaxed/simple;
	bh=NvPBwyfXuKXWiV7WztrR3/MoDQYRIo2q+HCemDNtZBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HCr+cxOOr0tANovNmjExQhwvHWRe1ZbggixdpDCfDeIbUKIh09tjo3CECrOnh4+ESEj/F1KNOaWJknqFlleivShikrXMkIyvD3H3ubQBdnWHsklJ/gyPUEfL6wj2BiAJAcqq3oQpAKMX9MgtA8Ix+/PLxXVqRvmPXk3Ky9NgpV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f50r3ayZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727716674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XelBiNVf3qEnPLGuRSPY0Kckuvuub64gIAfIBwRaWcM=;
	b=f50r3ayZBkqnQCAY9Yfr4dyaqVANA7W84dh8di7PZkzKJHAfBBJT4LbYF4lzrJQEOVNWam
	PfbZDhlW0VN7+KAUwrO1IegNjy5DPrwYn2lTjq80awDbkInGdiHc6OjSj84GJbln6bU4P3
	dNRrRc7WRay0Tj5lQrvA+2lUTqzhRbQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-2bEP6mI6Pj2vKz26JJWPfQ-1; Mon, 30 Sep 2024 13:17:53 -0400
X-MC-Unique: 2bEP6mI6Pj2vKz26JJWPfQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb808e9fcso28631825e9.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 10:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727716672; x=1728321472;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XelBiNVf3qEnPLGuRSPY0Kckuvuub64gIAfIBwRaWcM=;
        b=BB9E/V5q+H07nn+SYDMb9+EiohPIb7sDnUUMqDJtPc5mKgpspVEAAy2daKKi5fYHOw
         pBWjmQcGGuoGfwzackCGlczSxz4pSR7RVSZpfWNJ2GGpGPODgz/W7FGQh4u5NPSJSaao
         s5ovUWUYquf10ISoaOLRq/sF4XPqMMOBmSsgr1ublCP0mGRGzjBKZQiFQimifUAScORH
         8n5Km8r3eGPe11XwI6CUdoXfC5IcrhBH7WJ0qtdP648qLN/Tnws9kEY79x5anX2roRSm
         IQ1UUlkd3ihvER8kbmyH2P8lLbgCSa+rgTfuX1ak537w9BtpDlFavbZ8wXtV8cyG6rMi
         V2EA==
X-Forwarded-Encrypted: i=1; AJvYcCU5xF1AkSWsW78NfjLMKhsTcoiI3l0aivdGyCUwr0i3oHvMZWS35I72d99gpdP8mcw5D7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR8EPFsyOe1wsuifgd8KC7XPJbQvhPj2SnjzG7ku4IRN6hXQUc
	wTkIRBH5msDKhnZ3UP0udEuj2sN15wf7yE85dZhns6GyHl2Z8rJZJsHild1HY2KgiaKQZ2+G2RP
	Vz7ngIwHqcglOFLbMACHFS9c6C3b0FsOjF3udHKkWP17zyMdmKg==
X-Received: by 2002:a05:600c:4515:b0:428:10ec:e5ca with SMTP id 5b1f17b1804b1-42f584160b6mr94431705e9.14.1727716672054;
        Mon, 30 Sep 2024 10:17:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEU2xwDc0Ap4WXKeAzUiUdjfNfK9b2yJ4SYTzwEhkrbpYdpY4QjKEvH4BAcgpH1AioHmiJTlg==
X-Received: by 2002:a05:600c:4515:b0:428:10ec:e5ca with SMTP id 5b1f17b1804b1-42f584160b6mr94431555e9.14.1727716671636;
        Mon, 30 Sep 2024 10:17:51 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.43.71])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42f57e13944sm109836835e9.30.2024.09.30.10.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 10:17:51 -0700 (PDT)
Message-ID: <34b68d1e-7982-48e0-8d8a-5d3e0737ab42@redhat.com>
Date: Mon, 30 Sep 2024 19:17:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
To: Sean Christopherson <seanjc@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
 Farrah Chen <farrah.chen@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240928153302.92406-1-pbonzini@redhat.com>
 <CAHk-=wiQ2m+zkBUhb1m=m6S-H1syAgWmCHzit9=5y7XsriKFvw@mail.gmail.com>
 <a402dec0-c8f5-4f10-be5d-8d7263789ba1@redhat.com>
 <ZvrXbRLzAThvpoj4@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZvrXbRLzAThvpoj4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/24 18:53, Sean Christopherson wrote:
> On Mon, Sep 30, 2024, Paolo Bonzini wrote:
>> On Sun, Sep 29, 2024 at 7:36 PM Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> The culprit is commit 590b09b1d88e ("KVM: x86: Register "emergency
>>> disable" callbacks when virt is enabled"), and the reason seems to be
>>> this:
>>>
>>>    #if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>>>    void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
>>>    ...
>>>
>>> ie if you have a config with KVM enabled, but neither KVM_INTEL nor
>>> KVM_AMD set, you don't get that callback thing.
>>>
>>> The fix may be something like the attached.
>>
>> Yeah, there was an attempt in commit 6d55a94222db ("x86/reboot:
>> Unconditionally define cpu_emergency_virt_cb typedef") but that only
>> covers the headers and the !CONFIG_KVM case; not the !CONFIG_KVM_INTEL
>> && !CONFIG_KVM_AMD one that you stumbled upon.
>>
>> Your fix is not wrong, but there's no point in compiling kvm.ko if
>> nobody is using it.
>>
>> This is what I'll test more and submit:
>>
>> ------------------ 8< ------------------
>> From: Paolo Bonzini <pbonzini@redhat.com>
>> Subject: [PATCH] KVM: x86: leave kvm.ko out of the build if no vendor module is requested
>> kvm.ko is nothing but library code shared by kvm-intel.ko and kvm-amd.ko.
>> It provides no functionality on its own and it is unnecessary unless one
>> of the vendor-specific module is compiled.  In particular, /dev/kvm is
>> not created until one of kvm-intel.ko or kvm-amd.ko is loaded.
>> Use CONFIG_KVM to decide if it is built-in or a module, but use the
>> vendor-specific modules for the actual decision on whether to build it.
>> This also fixes a build failure when CONFIG_KVM_INTEL and CONFIG_KVM_AMD
>> are both disabled.  The cpu_emergency_register_virt_callback() function
>> is called from kvm.ko, but it is only defined if at least one of
>> CONFIG_KVM_INTEL and CONFIG_KVM_AMD is provided.
>>
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index 4287a8071a3a..aee054a91031 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -17,8 +17,8 @@ menuconfig VIRTUALIZATION
>>   if VIRTUALIZATION
>> -config KVM
>> -	tristate "Kernel-based Virtual Machine (KVM) support"
>> +config KVM_X86_COMMON
>> +	def_tristate KVM if KVM_INTEL || KVM_AMD
>>   	depends on HIGH_RES_TIMERS
>>   	depends on X86_LOCAL_APIC
>>   	select KVM_COMMON
>> @@ -46,6 +47,9 @@ config KVM
>>   	select KVM_GENERIC_HARDWARE_ENABLING
>>   	select KVM_GENERIC_PRE_FAULT_MEMORY
>>   	select KVM_WERROR if WERROR
>> +
>> +config KVM
>> +	tristate "Kernel-based Virtual Machine (KVM) support"
> 
> I like the idea, but allowing users to select KVM=m|y but not building any parts
> of KVM seems like it will lead to confusion.  What if we hide KVM entirely, and
> autoselect m/y/n based on the vendor modules?  AFAICT, this behaves as expected.

Showing the KVM option is useful anyway as a grouping for other options 
(e.g. SW-protected VMs, Xen, etc.).  I can play with reordering 
everything and using "select" to group these options, but I doubt it
will be better/more user-friendly than the above minimal change.

And also...

> Not having documentation for kvm.ko is unfortunate, but explaining how kvm.ko
> interacts with kvm-{amd,intel}.ko probably belongs in Documentation/virt/kvm/?
> anyways.

... documentation changes can wait for 6.13 anyway, unlike fixing
the build (even if in a rare config that would mostly be hit by
randconfig).

> If you haven't already, can you also kill off KVM_COMMON?  The only usage is in
> scripts/gdb/linux/constants.py.in, to print Intel's posted interrupt IRQs in
> scripts/gdb/linux/interrupts.py, which is quite ridiculous.

Sure.

Paolo


