Return-Path: <kvm+bounces-53989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94557B1B40F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B36273A6A09
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF24C2737E7;
	Tue,  5 Aug 2025 13:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZAatlC+h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E54026C39F
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399130; cv=none; b=KYegJOiS1rxRFoON9v39pS1bHjluCcokjzKtviJEylzjCrHfQwm8rud/O4IExD4s05uyn6DkSuQBb7mHA+BymMMtaqMYYp0GFS9YFrZoqS/D2ZwtrYl20SZKm0dbiXKHFWDPXtT/0NlpapmPsqS6y5ogICy+Fhx4YfEo1NvzAFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399130; c=relaxed/simple;
	bh=lLy8C4BbGZEDEBw2DX5YjAkFxWdfvpdmKKHFpkJlcgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azkz2a/AzAdCNkZvbzhcRfSHGSDjE/GW4sACm35qkIwzFdlsVuk1F//SiGPJuBq1iWlC9//7FaQMBtoT2rK76/0tsmJYI/+XxPbG2AkofZCQt1OrV1cS6NcBsqYd0Uw5Bc/IMMUUqJTqCghRzbsPmQ9wkJcK1orP239ZechmSTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZAatlC+h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754399127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W6Rju1n+AML1qrS8l5KyJDltE8wD0h/zu85tVti0m7U=;
	b=ZAatlC+haAhshQVjXHOTWELLTvu21fySiq4AdOtFdKxLA3321hytsDGh0jt0P0vU9z9GsG
	IeN/wAutwv2Ea/jtW99JMlwjuRwodTGzd48dTC2utzwd9FRW/zQ7rVTeNz10Anf+Vhv4R2
	dZWcdoetXbXDkN8kT2hi9dxhdxx2eQs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-WQI5wLk_Mw-nkM8geU1Qfg-1; Tue, 05 Aug 2025 09:05:26 -0400
X-MC-Unique: WQI5wLk_Mw-nkM8geU1Qfg-1
X-Mimecast-MFC-AGG-ID: WQI5wLk_Mw-nkM8geU1Qfg_1754399125
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7882c0992so1923666f8f.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754399125; x=1755003925;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W6Rju1n+AML1qrS8l5KyJDltE8wD0h/zu85tVti0m7U=;
        b=M7J3MX2JmsHILPAyZKJ3JFJHw/wUNLyab4hTzuQ3bei6UvVGbZfHoaBD5MoU0JdMiA
         dTahaA9SkrOLPO5J3VYaqRO4DD2GUviKRRBfjcG1ZPEv5bYN7FFBs6KLNbQ+JGDeHSbJ
         rV4/CCMp77T0wn9mVzUma8bZZaXKz3tM1dRl7MLikbcVStwIiuyBGkSp+L8tviQDAxz9
         Xjg2/jmEQNJUeEmITZSHwt946mkDCXm4IXRqm1H2JuUye9h9LRaRRsQCwZbGW6TliOXZ
         XVfSptAJiwvcz+VvhtAsIE1jrM0dXn6FEykyOLvCyxVp7s0jbC3JSA4xh3YeZLSqNZA5
         yG7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtRM9csssacZz3sqGo3rU0g0mXV8llBdto3HhgFVC5Nm1igA2LcuNbdJObpCsS+6En5B8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRbdgzEogj5UglhoYcR8GHh0beuAykH4OB86WTn5Dv8oFkAGvL
	atjs6HW8ttEhllwhryyw/t+hNX3RC1X/mkSWXgaW2XOqoP5u1s8DScuIuGDr+oguKuV0vURIfaN
	1Ivo0hWj959l1OBBSMu0gtwUq2sYIAj0DECkbgMbRu+5Ri8Jm59cYlw==
X-Gm-Gg: ASbGncuvArFx2/L6q8J5/8bhUdx6Wpy9DklL3wYVdvnX5h/ah2Mv2RfgnJOsRAnjpey
	VWA8MNZpPS2tAQ4FMc+mWK+771/kl64wSpbtK0WeCnNqEjk3kZnxILUOC2/BMwHmZDvBGcZYExL
	Lp42/8vOpZus6/MoFv4wxSKejyW5RUBE2J+urSEHCKWhNRMNIQrt18nJ5F1vsRZDPoBwXn72so+
	Zd2DnsxMJj+h+4egDFrrdlyOnIB68o5zhCzxyPcoV1ORupP/VVrueCZqS0UPAsHAv1kFNoE0Zoc
	Yrl4fO/5pxgjWEqpnPp5C9351Xck8tV3/xuVCuHCWiKfI+NO3/obrM23+TmPhgBQK404WXY=
X-Received: by 2002:a05:6000:290c:b0:3b7:97c8:da97 with SMTP id ffacd0b85a97d-3b8d94baa99mr10948150f8f.43.1754399124707;
        Tue, 05 Aug 2025 06:05:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqRUrHFBVFdCNj8zCr+8JpLiu2W+lX9LXGjfiFr2g548EtuR0S/rzGvVUSKtAjssV9ysvwAg==
X-Received: by 2002:a05:6000:290c:b0:3b7:97c8:da97 with SMTP id ffacd0b85a97d-3b8d94baa99mr10948108f8f.43.1754399124263;
        Tue, 05 Aug 2025 06:05:24 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459ded356b9sm59914875e9.12.2025.08.05.06.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:05:23 -0700 (PDT)
Message-ID: <a18a9b55-b3f0-466f-abc8-39b231c04bb1@redhat.com>
Date: Tue, 5 Aug 2025 15:05:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
 <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
 <20250805123858.GJ184255@nvidia.com>
 <db30f547-ba98-490c-aaf7-6b141bb1b52a@redhat.com>
 <20250805125643.GK184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805125643.GK184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 14:56, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 02:41:38PM +0200, David Hildenbrand wrote:
>> On 05.08.25 14:38, Jason Gunthorpe wrote:
>>> On Tue, Aug 05, 2025 at 02:07:49PM +0200, David Hildenbrand wrote:
>>>> I don't see an easy way to guarantee that. E.g., populate_section_memmap
>>>> really just does a kvmalloc_node() and
>>>> __populate_section_memmap()->memmap_alloc() a memblock_alloc().
>>>
>>> Well, it is really easy, if you do the kvmalloc_node and you get the
>>> single unwanted struct page value, then call it again and free the
>>> first one. The second call is guarenteed to not return the unwanted
>>> value because the first call has it allocated.
>>
>> So you want to walk all existing sections to check that? :)
> 
> We don't need to walk, compute the page-1 and carefully run that
> through page_to_pfn algorithm.

You have to test if first_page-1 and last_page+1 are used as the memmap 
for another section.

So yeah, it could be done by some page_to_pfn + pfn_to_page trickery I 
think.

Not that I would like that "allocate until you find something that 
works" approach.

> 
>> That's the kind of approach I would describe with the words Linus used.
> 
> Its some small boot time nastyness, we do this all the time messing up
> the slow path so the fast paths can be simple

nth_page won't go away. If it would go away, I would be sold on almost 
any idea. nth_page is the real problem.

So I don't like the idea of micro-optimizing num_pages_contiguous() by 
adding weird tweaks to the core for that.

-- 
Cheers,

David / dhildenb


