Return-Path: <kvm+bounces-48429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6CCACE283
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B54F5189C29C
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6731F4626;
	Wed,  4 Jun 2025 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFfAVAv2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529AB1EB5C2
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749056091; cv=none; b=qjFDHH1QFnoH497Yzbe3wOvbmYItr7XpxuUtmV5fCq2q0n/mGo2oy02+3JxRPYNcB0rsjkdVmD9FdXYeaAkuJhvx733k73+WV0uYiB9MNtfpV6vLjdvG7MTbG+WcnR+ngGbiLAIFTjUCNF9Oo9rcWUDOWZUf9xcYiruuCcRcJnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749056091; c=relaxed/simple;
	bh=4DKEyF4tpd5LE4WYj/Ecz1SQwUxE88FvS29eKBTxUcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKNbdDCuUtUvrpWwVIkOEgG0gSZ06yo9BfPNGHzMIZRwcT7nev+eLhxhPoGPdSCcapQLSxX7+R06O3a5EoQmq0MkTG309CQZPu6ql9jBA1Xx5w13aRJCjliua+jOLdcMnK6jjIAIhit3QnyF1UW1RfZY8DCceGqPVG+UvsxOx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFfAVAv2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749056089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Mcu2aJZ7tNizCqp+CAr0S3BB27I77lxIBXbe3cEyD/k=;
	b=iFfAVAv2uz0iBRg+2VSXGPaYsM0Ar6tZJWRukjn+wSRTXS7JHSVORGsGAWLW/8wltGYetJ
	LkuEbPfp8UJt6CtRbY2KYn2SwWRjfF9ZpwwSdH08d9O+GAJYaTMBgAcZSGpRoNSCsOHFXR
	pGGobanLpIQySItxtF9SDZMbm7Pw6js=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-animi7DEPH242n1zGgMf0w-1; Wed, 04 Jun 2025 12:54:47 -0400
X-MC-Unique: animi7DEPH242n1zGgMf0w-1
X-Mimecast-MFC-AGG-ID: animi7DEPH242n1zGgMf0w_1749056087
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a503f28b09so58604f8f.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749056087; x=1749660887;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mcu2aJZ7tNizCqp+CAr0S3BB27I77lxIBXbe3cEyD/k=;
        b=dwiRw936rVhskWAI6QECbqClzEYRvOLxe0NZTIMnRkVxueSCf4IdOJ5bzd5U5AGVRM
         stNsBA4RM1SucpcOGpnSmkqG4hzB8cF1arTFte56vc709713K9vbbUtL2kRXWhHec5zf
         KgwekJNOr47tQ5mVLinNlkwQ7iK9XNb/X27lNNoDO64dGXEqBntKNO+LaTNQRLFJOA0f
         yudRRE5P/4l78YStiXBcABu/i0HDHKaAPRtjlYmyMGsA/amqBHXnbV2JmReH2eYBWOSm
         qyomNicR/NxLrDgkDr36hYcmfk375HHV1QSh19p8LUrh7X+0y5FbmQ1lXQEkhTV5hCA/
         4hmQ==
X-Gm-Message-State: AOJu0Yxnn6sCR03iETjML7ReFdmUhc22ut6BJVYRuZTT7dxPNkWwXz4J
	J4Ov4c4/UuHY5sxhgHkeAJD15tgoyKVjB+Suq25VxHrThSWQ9DORneoojOCjagBtdPq0hHbt8v9
	lLVYG83tzYCxK0Eh56cIkEdNFr+8h7C59P8cO150SazBkYReIZKG95g==
X-Gm-Gg: ASbGncs1FT44J9jaF+mh0PjQ62KrjgwfFTp1CbWAeJDFclFClrdClMTd6E3+z98xtA/
	LbJnQ8hmEr5rRv32oH0YdBRRD94kA0ubKUIrrnwwOuS1zo32Ds2yCslfSSiBFeymzjCIpFnl8B0
	F+KtIGngYePgZ98eB/AdkR9ihiz9MndkFDPrW/3AKwZVY3x8oPs1yr2yi42x+ZxX/yXy2UiVoHk
	6Jmpp1zPFyeyCLd877HIX79fs2uDEn2XP72ePLhS4Nw75llTu+yzqVVvIzPwTIhtc8WVUt5Oniq
	zHttouM4rC+fWw==
X-Received: by 2002:a05:6000:2c13:b0:3a4:ed9a:7016 with SMTP id ffacd0b85a97d-3a526e1d833mr225603f8f.26.1749056086589;
        Wed, 04 Jun 2025 09:54:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGyE8OyvTcTRJ+Ojy5kNOLlEVm5dxXrNtoBkm4cJYtYHAXG13nNuoW0OzHVyL762PpnSHlww==
X-Received: by 2002:a05:6000:2c13:b0:3a4:ed9a:7016 with SMTP id ffacd0b85a97d-3a526e1d833mr225575f8f.26.1749056086177;
        Wed, 04 Jun 2025 09:54:46 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-450d800658csm203489145e9.27.2025.06.04.09.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:54:45 -0700 (PDT)
Message-ID: <2667fad4-3635-413b-87a9-26cb6102ffab@redhat.com>
Date: Wed, 4 Jun 2025 18:54:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "vkuznets@redhat.com" <vkuznets@redhat.com>
References: <20250519232808.2745331-1-seanjc@google.com>
 <20250519232808.2745331-12-seanjc@google.com>
 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
 <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
 <aDhvs1tXH6pv8MxN@google.com>
 <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
 <aDjo16EcJiWx9Nfa@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aDjo16EcJiWx9Nfa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 01:08, Sean Christopherson wrote:
> On Thu, May 29, 2025, Kai Huang wrote:
>> On Thu, 2025-05-29 at 07:31 -0700, Sean Christopherson wrote:
>>> On Thu, May 29, 2025, Kai Huang wrote:
>>>> On Thu, 2025-05-29 at 23:55 +1200, Kai Huang wrote:
>>>>> Do they only support userspace IRQ chip, or not support any IRQ chip at all?
>>>
>>> The former, only userspace I/O APIC (and associated devices), though some VM
>>> shapes, e.g. TDX, don't provide an I/O APIC or PIC.
>>
>> Thanks for the info.
>>
>> Just wondering what's the benefit of using userspace IRQCHIP instead of
>> emulating in the kernel?
> 
> Reduced kernel attack surface (this was especially true years ago, before KVM's
> I/O APIC emulation was well-tested) and more flexibility (e.g. shipping userspace
> changes is typically easier than shipping new kernels.  I'm pretty sure there's
> one more big one that I'm blanking on at the moment.

Feature-wise, the big one is support for IRQ remapping which is not 
implemented in the in-kernel IOAPIC.

>>>> Forgot to ask:
>>>>
>>>> Since this new Kconfig option is not only for IOAPIC but also includes PIC and
>>>> PIT, is CONFIG_KVM_IRQCHIP a better name?
>>>
>>> I much prefer IOAPIC, because IRQCHIP is far too ambiguous and confusing, e.g.
>>> just look at KVM's internal APIs, where these:
>>>
>>>    irqchip_in_kernel()
>>>    irqchip_kernel()
>>>
>>> are not equivalent.  In practice, no modern guest kernel is going to utilize the
>>> PIC, and the PIT isn't an IRQ chip, i.e. isn't strictly covered by IRQCHIP either.
>>
>> Right.
>>
>> Maybe it is worth to further have dedicated Kconfig for PIC, PIT and IOAPIC?
> 
> Nah.  PIC and I/O APIC can't be split (without new uAPI and non-trivial complexity),
> and I highly doubt there is any use case that would want an in-kernel I/O APIC
> with a userspace PIT.  I.e. in practice, the three almost always come as a group;
> either a setup wants all, or a setup wants none.

Without "almost", even.  I think it's okay to make it CONFIG_KVM_IOAPIC, 
it's not super accurate but there's no single word that convey "IOAPIC, 
PIC and PIT".

>> Btw, I also find irqchip_in_kernel() and irqchip_kernel() confusing.  I am not
>> sure the value of having irqchip_in_kernel() in fact.  The guest should always
>> have an in-kernel APIC for modern guests.  I am wondering whether we can get rid
>> of it completely (the logic will be it is always be true), or we can have a
>> Kconfig to only build it when user truly wants it.

irqchip_kernel() can be renamed to irqchip_full().

> For better or worse, an in-kernel local APIC is still optional.  I do hope/want
> to make it mandatory, but that's not a small ABI change.

I am pretty sure that some users (was it DOSBox? or maybe even gVisor?) 
would break.

Paolo


