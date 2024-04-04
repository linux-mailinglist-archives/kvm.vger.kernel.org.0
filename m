Return-Path: <kvm+bounces-13594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 911EA898DDB
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 433BC283A36
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97926130A65;
	Thu,  4 Apr 2024 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CaItbT5t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334FC130485
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712255030; cv=none; b=Qg7RR/zB3gxLkBf3zlvvkc9W8u0rsTasb1wonoJliWjLCOvLZ2030W/HM5uKRFYxWluYBrOuibwJQTm8X/+NkJsBWqyi1Xhj2VVWjVkKYO69E4eFyZ6csQegADod6EEK084iqIfjHvaRWD1GpqGyvaR7rbpuALeDoJLP74rGRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712255030; c=relaxed/simple;
	bh=FDRLSaZ4Bfk06GmAs1QpfTtlBBrx0Z0fIAFfyLXCR0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=We96yHd6aPNh0SRPzSo0KvYWy6IivVHo8wTppHdG8FRHCZWLYXr5ScKb8jszBpNH07XbTx0PcAQMApRG5s8TZiLE9edSPcG0tsdFJH/24rHdtoq3Aur5/szqMBD/NxXk/j07qJwzlAtRw93I4uvmdO5BXm4zn92B1em1l5OcdW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CaItbT5t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712255028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=osZUMx3CD6uxERiHrcdXifX+vl+p+oisHDar5m0G6LY=;
	b=CaItbT5tIlhyGeCRfMkRRoimhWJor9QEIRXT4sB09ynyRSN6YknN7uDydry21OxK8fBLEc
	4VUeo9aEjeXt+JEiafM8bPJt1L4TRLtDO6DNSJIzC4h0N91QV9sew0aoaWAPqOMc7/kH9o
	nFde8EHu9NTlMCy+EPLdw8f191SOkqg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-6x0T5NI_P2-TXT7eSteGUQ-1; Thu, 04 Apr 2024 14:23:47 -0400
X-MC-Unique: 6x0T5NI_P2-TXT7eSteGUQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d81d7b2f00so11321321fa.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 11:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712255025; x=1712859825;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osZUMx3CD6uxERiHrcdXifX+vl+p+oisHDar5m0G6LY=;
        b=koe7QvY7SchsPO95aF5gkJXE4fgN1NSTov+TLRVc05gMlwSLm3g+PZLCx6CCl+sWhZ
         +C1orBuKfeBrPSYnimiWV/L6au3MfpUQsMZd3fPBUejuGGnoVnNMERG8AfrUnh5KHvb4
         VGMZvbLdq180Kz1mcuG2s8wyBeZEOhPaqYOJVMP5x6yxVXa/WNJYrkDyHlm3uznqtnw2
         4MWfkhbbU/+eMeHCs9B+xvqzvy1jjQ0DXAN8UwwEX7eWNWP1h+uY3Cm96dMVxcu4s963
         BN52iz/e9zExCg8lvvHG1UGYJH6LlUDJt8RFOf2AP1sTI3H98621AMLoMQEBy+S7bckg
         il/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5+jcaAXba7lnOiLi3DH+AxcmaeM9JiiqaGkBzRkCWjEnI9IEHm/ZSOIHxcM6cv5WivkKUS2IjjL+riuzFZsNTa0xp
X-Gm-Message-State: AOJu0YxqHsbYTAO1SnA1/1AjkeeK1Q7SkPBX3nJYpykjMiYD8AzcXjr4
	/CHgEurGnuGh8OyoYK12gigkvNHYwVEgYGJ3NPxt5I8c0eH5V4ndTzBZ2d+cj5S4pZINpcuyTPs
	+dkunCeyKPqJbCaaXWE+nBNgnQCOWKcWdQL4E72j3DlWRnoGc6Q==
X-Received: by 2002:a2e:8804:0:b0:2d4:7532:92f2 with SMTP id x4-20020a2e8804000000b002d4753292f2mr2367391ljh.45.1712255025149;
        Thu, 04 Apr 2024 11:23:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwhIM94bRxD1bosPHrwuTlesX51tzJFoEVOBlhbyLHcRKjIAQIzW9090jx3OW83tRlaiNs5Q==
X-Received: by 2002:a2e:8804:0:b0:2d4:7532:92f2 with SMTP id x4-20020a2e8804000000b002d4753292f2mr2367379ljh.45.1712255024690;
        Thu, 04 Apr 2024 11:23:44 -0700 (PDT)
Received: from ?IPV6:2003:cb:c743:de00:7030:120f:d1c9:4c3c? (p200300cbc743de007030120fd1c94c3c.dip0.t-ipconnect.de. [2003:cb:c743:de00:7030:120f:d1c9:4c3c])
        by smtp.gmail.com with ESMTPSA id 5-20020a05600c024500b004161b59e230sm14271wmj.41.2024.04.04.11.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 11:23:44 -0700 (PDT)
Message-ID: <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com>
Date: Thu, 4 Apr 2024 20:23:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios
 dirty/accessed
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
References: <20240320005024.3216282-1-seanjc@google.com>
 <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
 <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com>
 <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com>
 <Zg7j2D6WFqcPaXFB@google.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zg7j2D6WFqcPaXFB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.04.24 19:31, Sean Christopherson wrote:
> On Thu, Apr 04, 2024, David Hildenbrand wrote:
>> On 04.04.24 00:19, Sean Christopherson wrote:
>>> Hmm, we essentially already have an mmu_notifier today, since secondary MMUs need
>>> to be invalidated before consuming dirty status.  Isn't the end result essentially
>>> a sane FOLL_TOUCH?
>>
>> Likely. As stated in my first mail, FOLL_TOUCH is a bit of a mess right now.
>>
>> Having something that makes sure the writable PTE/PMD is dirty (or
>> alternatively sets it dirty), paired with MMU notifiers notifying on any
>> mkclean would be one option that would leave handling how to handle dirtying
>> of folios completely to the core. It would behave just like a CPU writing to
>> the page table, which would set the pte dirty.
>>
>> Of course, if frequent clearing of the dirty PTE/PMD bit would be a problem
>> (like we discussed for the accessed bit), that would not be an option. But
>> from what I recall, only clearing the PTE/PMD dirty bit is rather rare.
> 
> And AFAICT, all cases already invalidate secondary MMUs anyways, so if anything
> it would probably be a net positive, e.g. the notification could more precisely
> say that SPTEs need to be read-only, not blasted away completely.
> 

As discussed, I think at least madvise_free_pte_range() wouldn't do 
that. Notifiers would only get called later when actually zapping the 
folio. So at least for some time, you would have the PTE not dirty, but 
the SPTE writable or even dirty. So you'd have to set the page dirty 
when zapping the SPTE ... and IMHO that is what we should maybe try to 
avoid :)

-- 
Cheers,

David / dhildenb


