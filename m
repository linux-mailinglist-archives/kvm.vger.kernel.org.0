Return-Path: <kvm+bounces-14028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D453789E3A5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 21:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BE4B1F23FA8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8108615749E;
	Tue,  9 Apr 2024 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VjDmaZhp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2689615699E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712691316; cv=none; b=DCTpY2nSrEBmq4psJzz/+gK2ThXhJsZMdAc9qc2EvN4Ufir4gyF1G3JfjsW+EQFJFunMIDJY4xCIdI2C/Ji2wnoOF0mmcS2Qu2VX+Hx6nNrGrlctXrhd6L+zEkRKM8ulxKMNPTYDENTLMOLneNQ4aQbK/fo1yUFTxf9gqkGBM+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712691316; c=relaxed/simple;
	bh=skYp5aRr2KhYDAGwT1PxdUTnvoEjTAwvzoHKlIEWxp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWY7AY1LNY5XUM3jfi4iF2+AlITUhj4rYTcni8GnNHJmgnlH6Ynfjh+bD8jR6ssFSHdiyXEJPVy7Ls+vAQio5k+BQDaFm+miPgATAByOjS/MOmlVrFxhuUGlp8IvV2Yl2IJw/yT8qiYT8/CltGwz8MGDWa7H4U5cwbuGpck503g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VjDmaZhp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712691314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U/UlR7zqufR1BMiNRAFjOCRhGVziWAD38sAXso6PqdU=;
	b=VjDmaZhpTujRNbhWem4FrEIEU7T7E36HwLzBEGJmXAbKLWRr4T8iPOtC6W2Asem/2gIsMv
	+c3aTVAU6TqXHoBQ+S9tPFKVPrGPVgH3qM8gMYDGUxcfguxxzMwfLB/vhcv4rtwi0lFIDH
	ls9ZCKxiNYHd936iybKHmNPyjWsrl1c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-wzcWvCMmMnOmMoUgqR76Fg-1; Tue, 09 Apr 2024 15:35:12 -0400
X-MC-Unique: wzcWvCMmMnOmMoUgqR76Fg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-414aa7bd274so34872305e9.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 12:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712691311; x=1713296111;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/UlR7zqufR1BMiNRAFjOCRhGVziWAD38sAXso6PqdU=;
        b=Q5JOokvvx+CvyvhtOk8ZX4jD/1jkXZ4nXxeg4T1kTLGpTHaY6UmeBqDO7sYiPMgsJq
         xGi0bhHDwH9Et2gtafZbzsHtEVEhhKd+U11+3I2BaHZnd1MLBuXPdKLIg4lD4lUMqGrB
         monE9swNQ0/4m2ifHqszWYupukxiTMYv6B1O+4CogHxZoYcBWwbRkeMXzdgy/qafI/Ln
         JoP02mOOo6rhX2sp0dQPcSwjE2PV/fGix1xm/Xrve5e5H+476NOpO4HwiFSyTfliHLf/
         j7RQLToiMnrp10e1xQP18C3ZKHw6BACiVi9vGPRqviPTbHkWk63gJ2rPP+bTInvgNC9E
         /ftQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwvMoj6WYxZcwYWRfOMYuVD4KLtYAuQDm77DgNsdBnEKE8iCfKClhQleQHRNLQIEPhcq9BOhtsuPO4hIFJrK79gf1o
X-Gm-Message-State: AOJu0Yy0hGR41kPVuvP+FQ93Etny/VSbLJnxgYMTy9UCCmB3sjuTII3w
	6J7h59f39dP9epBsqsFDzRP8WfKlbky5nWN/j7h4+57vH6jQ7BDYXLPk3wMwxX1s3CPTsw0jF+I
	PiKz/Ia1rG+Gh5YV8w6yKeOiv12addPLyExunkwPIB1b8mRXj7A==
X-Received: by 2002:a05:600c:1f92:b0:415:6dae:7759 with SMTP id je18-20020a05600c1f9200b004156dae7759mr434772wmb.19.1712691311525;
        Tue, 09 Apr 2024 12:35:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNK/MSHbN2SOo+EhWsKeacokFDTkm+sVzbxSuwMhF8cnl50vWF4+UkJdupyoUUGPHLwwFqbQ==
X-Received: by 2002:a05:600c:1f92:b0:415:6dae:7759 with SMTP id je18-20020a05600c1f9200b004156dae7759mr434745wmb.19.1712691311075;
        Tue, 09 Apr 2024 12:35:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:be00:a285:bc76:307d:4eaa? (p200300cbc70abe00a285bc76307d4eaa.dip0.t-ipconnect.de. [2003:cb:c70a:be00:a285:bc76:307d:4eaa])
        by smtp.gmail.com with ESMTPSA id je6-20020a05600c1f8600b0041496734318sm21939446wmb.24.2024.04.09.12.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 12:35:10 -0700 (PDT)
Message-ID: <226a222d-4273-4304-ab73-39b2f8f060b5@redhat.com>
Date: Tue, 9 Apr 2024 21:35:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm: Add a bitmap into
 mmu_notifier_{clear,test}_young
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
 David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
 Ricardo Koller <ricarkol@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, David Rientjes <rientjes@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-2-jthoughton@google.com>
 <cce476f7-2f52-428a-8ae4-fc5dec714666@redhat.com>
 <CADrL8HVPEjdAs3PoTa3sPCvQpimZJG6pP9wbiLjnF5cROxfapA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CADrL8HVPEjdAs3PoTa3sPCvQpimZJG6pP9wbiLjnF5cROxfapA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09.04.24 20:31, James Houghton wrote:
> Ah, I didn't see this in my inbox, sorry David!

No worries :)

> 
> On Thu, Apr 4, 2024 at 11:52 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 02.04.24 01:29, James Houghton wrote:
>>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>>> index f349e08a9dfe..daaa9db625d3 100644
>>> --- a/include/linux/mmu_notifier.h
>>> +++ b/include/linux/mmu_notifier.h
>>> @@ -61,6 +61,10 @@ enum mmu_notifier_event {
>>>
>>>    #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
>>>
>>> +#define MMU_NOTIFIER_YOUNG                   (1 << 0)
>>> +#define MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE (1 << 1)
>>
>> Especially this one really deserves some documentation :)
> 
> Yes, will do. Something like
> 
>      MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE indicates that the passed-in
> bitmap either (1) does not accurately represent the age of the pages
> (in the case of test_young), or (2) was not able to be used to
> completely clear the age/access bit (in the case of clear_young).

Make sense. I do wonder what the expected reaction from the caller is :)

> 
>>
>>> +#define MMU_NOTIFIER_YOUNG_FAST                      (1 << 2)
>>
>> And that one as well.
> 
> Something like
> 
>     Indicates that (1) passing a bitmap ({test,clear}_young_bitmap)
> would have been supported for this address range.
> 
> The name MMU_NOTIFIER_YOUNG_FAST really comes from the fact that KVM
> is able to harvest the access bit "fast" (so for x86, locklessly, and
> for arm64, with the KVM MMU read lock), "fast" enough that using a
> bitmap to do look-around is probably a good idea.

Is that really the right way to communicate that ("would have been 
supported") -- wouldn't we want to sense support differently?

> 
>>
>> Likely best to briefly document all of them, and how they are
>> supposed to be used (return value for X).
> 
> Right. Will do.
> 
>>
>>> +
>>>    struct mmu_notifier_ops {
>>>        /*
>>>         * Called either by mmu_notifier_unregister or when the mm is
>>> @@ -106,21 +110,36 @@ struct mmu_notifier_ops {
>>>         * clear_young is a lightweight version of clear_flush_young. Like the
>>>         * latter, it is supposed to test-and-clear the young/accessed bitflag
>>>         * in the secondary pte, but it may omit flushing the secondary tlb.
>>> +      *
>>> +      * If @bitmap is given but is not supported, return
>>> +      * MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
>>> +      *
>>> +      * If the walk is done "quickly" and there were young PTEs,
>>> +      * MMU_NOTIFIER_YOUNG_FAST is returned.
>>>         */
>>>        int (*clear_young)(struct mmu_notifier *subscription,
>>>                           struct mm_struct *mm,
>>>                           unsigned long start,
>>> -                        unsigned long end);
>>> +                        unsigned long end,
>>> +                        unsigned long *bitmap);
>>>
>>>        /*
>>>         * test_young is called to check the young/accessed bitflag in
>>>         * the secondary pte. This is used to know if the page is
>>>         * frequently used without actually clearing the flag or tearing
>>>         * down the secondary mapping on the page.
>>> +      *
>>> +      * If @bitmap is given but is not supported, return
>>> +      * MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
>>> +      *
>>> +      * If the walk is done "quickly" and there were young PTEs,
>>> +      * MMU_NOTIFIER_YOUNG_FAST is returned.
>>>         */
>>>        int (*test_young)(struct mmu_notifier *subscription,
>>>                          struct mm_struct *mm,
>>> -                       unsigned long address);
>>> +                       unsigned long start,
>>> +                       unsigned long end,
>>> +                       unsigned long *bitmap);
>>
>> What does "quickly" mean (why not use "fast")? What are the semantics, I
>> don't find any existing usage of that in this file.
> 
> "fast" means fast enough such that using a bitmap to scan adjacent
> pages (e.g. with MGLRU) is likely to be beneficial. I'll write more in
> this comment. Perhaps I should just rename it to
> MMU_NOTIFIER_YOUNG_BITMAP_SUPPORTED and drop the whole "likely to be
> beneficial" thing -- that's for MGLRU/etc. to decide really.

Yes!

> 
>>
>> Further, what is MMU_NOTIFIER_YOUNG you introduce used for?
> 
> MMU_NOTIFIER_YOUNG is the return value when the page was young, but we
> (1) didn't use a bitmap, and (2) the "fast" access bit harvesting
> wasn't possible. In this case we simply return 1, which is
> MMU_NOTIFIER_YOUNG. I'll make kvm_mmu_notifier_test_clear_young()
> properly return MMU_NOTIFIER_YOUNG instead of relying on the fact that
> it will be 1.

Yes, that will clarify it!

-- 
Cheers,

David / dhildenb


