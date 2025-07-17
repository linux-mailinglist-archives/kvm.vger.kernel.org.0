Return-Path: <kvm+bounces-52750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7E5B090A7
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C21DB4A6F9A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2658D2F8C5C;
	Thu, 17 Jul 2025 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hKyow3X9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BF1E572F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766397; cv=none; b=fWkIKVhC2i+9kjMuOrFMrI2nP+nHCd7S91aOXHvbVtFprVL2zqX8vayMC8o1LK1HGRXaeTcIOhpDn+wpuTPIAxLZ4RRB6Uc53Ek0n0ywOWoA//LqEaREofLpkRJFr1q8FVzXsZUI5qW+/WS/kIjEQ+aBn1TvHDLAhSXsSIGrsvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766397; c=relaxed/simple;
	bh=HDxfFlOGFn9CFDmRQhVsbQ+v7z0qiqG8JGKHslmmxuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQIljVZ9GpgOuBIBIkZv/6M/+dFHnuf5umtclgZNwXByaEuzbRYkIO3wdSxYQdUBMLrpP1AEAPJDbAPbRnKMaShJ6IVmEOvbJYXdiosgtXHZMnzUtbtuNphMDmp2aDdu8CFlfneCDQmeABjixIhPMyHgmjhBhj1JRc934EytpI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hKyow3X9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752766394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9u3jkQmKaVC8b7M30nAox3a177snAGY8jpNVGHawZuk=;
	b=hKyow3X9FPNrJHqeHKPcHjoTQ8U3aV7Z7ErHShoOxJe52bAfywvqkODA9or3aTRXw6jPhk
	CaXQsnDIUcRP26VmoJLi5DFsH6l1wAufrihuDwAKX84cByGcFfByFSvEu2Hc3xTqZ1YsUf
	UNIaN5Du72Uvx/LgFEHM8KZF4DJefos=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-m5QdqDETNLWZF0WN-ataNw-1; Thu, 17 Jul 2025 11:33:12 -0400
X-MC-Unique: m5QdqDETNLWZF0WN-ataNw-1
X-Mimecast-MFC-AGG-ID: m5QdqDETNLWZF0WN-ataNw_1752766391
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b604541741so771351f8f.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752766391; x=1753371191;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9u3jkQmKaVC8b7M30nAox3a177snAGY8jpNVGHawZuk=;
        b=Z6RJVnkE3Wgnrb73oYXqYBefvjgfxOEuKL4cZsn++cbFD2l0Z5Lpt/c2ZCRAX/7PhJ
         0fLCOpnuHHeOghav5MLL1Tez5cS9Y+qupgoUToUa5rQa85U/sAHqGoatqd3RM3jEtd9B
         tIR3oEif6b1UrQCd5kUBWEsIafHV7Ug7EMWvw/1lkDOAoS8NA8uKqnOMNmy61AZjeb34
         IG29BGuBq/6gtOVTR8fJb1hUJdVzXiGZ/Bt5dKNPp+aTX7P8BYgmNZtTmzoDo93P3aL9
         iGhmFOOvp1iLKL/+Bzf4Q0iiUY5zpyoefk0u6VkD4OyXFCY4gsDi1jYBpkfy837yGMrN
         PBCw==
X-Gm-Message-State: AOJu0YyP2pW75pW+8Mnr9sCIKZQwsqKzWRoeC5WFLnzoXICC8xVmrnKP
	w7OEqyVeciUl4cxz42PfScEJf1CJYW3nAz8POBDdIqCpqY8yU1mw0w/cmB6uqLjJG1wWwOgynQ5
	DD0tnoP/Fo066ZshBMFKXuZ4TVznLGFofu4oYck5fIpMTBl95Fn07hQ==
X-Gm-Gg: ASbGnctK+D0cTE1vQ7SRhw3gkrL4vm9OFfFYz6I1eXfAh2pXFAao5hr/jo5I/Usaic4
	EDHKVAeZAZNnor23XymCeG5V+6q/YXUd4dl84iRdymc4hU5VdBkQ4mpPVgfB/0qBP2ZH4i3W5yM
	sZ9jE5WPmHmtO5IOcPBqWGUFoXiwbUSM/+cm+VCRBqu6sA1TU0JjeeHmO+EgetFI5CUwZmLdXSD
	4C7wCDm8UDSGP6apD8K3W6/GojyPH2WHLp+xAN2b+vP7O/JyDNyikSDYsIxEn3r0Kk7mKyf2Mi7
	K4jovZbiXK14ucNFAyKX6AvYl1kE8HaIgsWA9Nc2hnY=
X-Received: by 2002:a5d:6f19:0:b0:3a4:fa09:d13b with SMTP id ffacd0b85a97d-3b60e54aa5fmr5473590f8f.59.1752766391250;
        Thu, 17 Jul 2025 08:33:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHv8T6LhzO2ho2iDiU2DAqnJRJ77W3HHDa1h+oPF1DiEVcnbc+uMFWcDWXrY7P76nKz7xa25g==
X-Received: by 2002:a5d:6f19:0:b0:3a4:fa09:d13b with SMTP id ffacd0b85a97d-3b60e54aa5fmr5473562f8f.59.1752766390743;
        Thu, 17 Jul 2025 08:33:10 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.73.155])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-45634f5ea01sm25459335e9.14.2025.07.17.08.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 08:33:10 -0700 (PDT)
Message-ID: <dc295c30-a695-4dde-b1ab-0871fd576f4e@redhat.com>
Date: Thu, 17 Jul 2025 17:33:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Don't report base TDVMCALLs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250717022010.677645-1-xiaoyao.li@intel.com>
 <CAGtprH_fNofCjJH1hWKoPwd-wT7QmyXvS7d9xpRNYxBznNUY+w@mail.gmail.com>
 <3d62aeb993d9a81a64985a8354b87ffedd35514e.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <3d62aeb993d9a81a64985a8354b87ffedd35514e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/17/25 17:24, Edgecombe, Rick P wrote:
> On Thu, 2025-07-17 at 05:25 -0700, Vishal Annapurve wrote:
>> On Wed, Jul 16, 2025 at 7:28 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index f31ccdeb905b..ea1261ca805f 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -173,7 +173,6 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
>>>           tdx_clear_unsupported_cpuid(entry);
>>>    }
>>>
>>> -#define TDVMCALLINFO_GET_QUOTE                         BIT(0)
>>>    #define TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT      BIT(1)
>>
>> I am struggling to find the patch that adds support for
>> TDVMCALLINFO_SETUP_EVENT_NOTIFY_INTERRUPT. Can you help point out the
>> series that adds this support?
> 
> This was the last version of the series posted:
> https://lore.kernel.org/kvm/20250619180159.187358-1-pbonzini@redhat.com/#t

Yep, I didn't send the patches for SetupEventNotifyInterrupt to the KVM 
mailing list.

I hadn't even noticed until now that I hadn't sent them because, when I 
came back from vacation, I found the matching QEMU patches in my inbox. 
So when git reported them to be in the next pull request I didn't think 
of double checking.  Of course the blame is mine---thanks Xiaoyao for 
writing the QEMU side.

They are:
- commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5
   KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities

- commit 4580dbef5ce0f95a4bd8ac2d007bc4fbf1539332
   KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt

Sorry about that.

Paolo


