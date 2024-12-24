Return-Path: <kvm+bounces-34353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B879FBCE8
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 12:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A14163896
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 11:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995251B4153;
	Tue, 24 Dec 2024 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJjwDsPA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89061B2192
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 11:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735039663; cv=none; b=NQEC1o65f4xp0wD2/OKT+cElkj+D/q6nBbHpogmZ5cV/NVyPKrLwnc14xIlcPqUiHm9z/ORr5o9dM895lg2Og18xFaZxifXPJUaEha8ITsdUa5SxyKazmjQ1Fox05iiMx5f5EstBRVwkrT+JVe0qdRAlh3PimD8qxsORz0madt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735039663; c=relaxed/simple;
	bh=UN4/jIruCRlS7xOU6AqGYHUFKE0unPvvcrhmvaDmovc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nCeEdY1e84EqL0ypdch4VY5X2VgiHpgDZDHkzJfsDhU44nZI6oLTTpiBbmZG5jGEMhI/N/FJwZKfv5EXyPSy47qtjW3J52DA6VtTGEgJkk/y9dreLyZqIPyNKdPo2ipwyD9ABSvv5TUYAbRs47PAMVtpHnKDq+FDfHEIlRQupwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJjwDsPA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735039660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6FMB8h6XQ7wLfkg2ADGWAcnweaxoT94bFHCCnfiyr5M=;
	b=MJjwDsPA6LmL6lT7eaLHI56tmC9jia+2rPBTQGRGxueK8ZzsDGwYx/m0ccL74gTGvj5EVl
	v+2pG0qBHcHjJJXAUM36arIeC5EQmLYhS7Yw/E7e6xqZXm7CC4w8iG3GAqPq+FKg6cj/eT
	SLtAPif5Csh7L9a43UaM9ccmK6c/IbU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-Uc2mVoG5NV--XJaKdy13Gg-1; Tue, 24 Dec 2024 06:27:37 -0500
X-MC-Unique: Uc2mVoG5NV--XJaKdy13Gg-1
X-Mimecast-MFC-AGG-ID: Uc2mVoG5NV--XJaKdy13Gg
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436723db6c4so20928875e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 03:27:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735039656; x=1735644456;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6FMB8h6XQ7wLfkg2ADGWAcnweaxoT94bFHCCnfiyr5M=;
        b=iNlZ6R+zXpctT35evKBCL+3lvZlLLQBYyA4eSkffXhYHyZhNPUHMd4vvVcQTxk8/Kc
         nHXxy/HrwRpQCJP2bqdXpiPL1eowYWS3NAJD+v20iJWOu9VT6SskH90xK+/mukRO5pXx
         CGQ14npx/fWOOF0s/5sXH7CfH1mML47UMxAUllmeZrMTaAGehIYVR/lgR7bqS12xg9yI
         XH7egImfI9QzOPHdwX3PyCozsKksNUf3uYMlRFAQHEsmwuP8VEumdhsjevY1GmrPbLr1
         SHpZNp8I94/+nMEDfqWwkCZu9JB4Al48OZ3AbJ0TW301QGPKgVJvxIFqTq3mrquUJZIz
         LShw==
X-Forwarded-Encrypted: i=1; AJvYcCWb8RLyiSGvKhwa/1+grymynv/xzPFj2RT0CKK6dPNydepmXWFOUAgw3iAk9KZbw8SyCSw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsPFKJKgXj958KS2kDDJVuCP4ucrtO8dVXCjmrPQXuqdxP/yuO
	WkVhJIAVvit8VaKCewIEdSyO1pygjpOnR4ElHn6jja/UeNN5HhUXzhrffl8zi6aw0KT/M8Lbexl
	Lpv6LoFO6wA3hfKu3j+LEJJOJduXCFWsn//94pVic6zk1+lC6ew==
X-Gm-Gg: ASbGncuARl0fvqI5tN/Srr8Z3e674YVn6lqlP20bJ6QzVSmkZBoBDwF6Qsmsv3HXWee
	1OSrzolHJrkOESkwSuuCSXKUoHAX0VklMkUv/E6Zgy5mh5oDyXcxF2Sh7IeA6LwFNIGRHcnrXZE
	kPmkkOwI+SC6cOVWFeDeOmfTcCcmEy9QufT2r6BF/dRjYDwKlJVNsi354EjyWA4+7xoHyfkiZuF
	FppIcSrPDq0bvBJyjBan9lG5le1NvkDihqBTxP4Tinwiw004A+SAxRdD2w3At0aXi5Duu+0u2xc
	6KqRZg0HcPNolZgE7sXaDhrUltz1kRmk8FljWgRlvbaDcWbXZhK8hpGLIMouhbtaylsl1xUOuHI
	wPFyOTTMl
X-Received: by 2002:a5d:59ab:0:b0:385:fd31:ca31 with SMTP id ffacd0b85a97d-38a223fd39fmr18037789f8f.53.1735039656351;
        Tue, 24 Dec 2024 03:27:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTsBBAOHLHVRvbW+Q7P3Y2vp14B374OUvcCGZ+g9p7tmbmw7Y0qOWnpTeii8Y42OoLbPwYNg==
X-Received: by 2002:a5d:59ab:0:b0:385:fd31:ca31 with SMTP id ffacd0b85a97d-38a223fd39fmr18037765f8f.53.1735039655950;
        Tue, 24 Dec 2024 03:27:35 -0800 (PST)
Received: from ?IPV6:2003:cb:c72a:da00:e63f:f575:6b1a:df4e? (p200300cbc72ada00e63ff5756b1adf4e.dip0.t-ipconnect.de. [2003:cb:c72a:da00:e63f:f575:6b1a:df4e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366127c488sm163896265e9.27.2024.12.24.03.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:27:35 -0800 (PST)
Message-ID: <82c53460-a550-4236-a65a-78f292814edb@redhat.com>
Date: Tue, 24 Dec 2024 12:27:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
To: Alexey Kardashevskiy <aik@amd.com>, Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>, Fuad Tabba <tabba@google.com>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <ZzRBzGJJJoezCge8@intel.com>
 <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
 <ZzVgFGBEUO7sU3E4@intel.com> <d6b74ccd-47d3-4fd6-96e7-3027dd13faa0@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <d6b74ccd-47d3-4fd6-96e7-3027dd13faa0@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.12.24 05:21, Alexey Kardashevskiy wrote:
> On 14/11/24 13:27, Chao Gao wrote:
>>>> With in-place conversion, QEMU can map shared memory and supply the virtual
>>>> address to VFIO to set up DMA mappings. From this perspective, in-place
>>>> conversion doesn't change or require any changes to the way QEMU interacts
>>>> with VFIO. So, the key for device assignment remains updating DMA mappings
>>>> accordingly during shared/private conversions. It seems that whether in-place
>>>> conversion is in use (i.e., whether shared memory is managed by guest_memfd or
>>>> not) doesn't require big changes to that proposal. Not sure if anyone thinks
>>>> otherwise. We want to align with you on the direction for device assignment
>>>> support for guest_memfd.
>>>> (I set aside the idea of letting KVM manage the IOMMU page table in the above
>>>>     analysis because we probably won't get that support in the near future)
>>>
>>> Right. So devices would also only be to access "shared" memory.
>>
>> Yes, this is the situation without TDX-Connect support. Even when TDX-Connect
>> comes into play, devices will initially be attached in shared mode and later
>> converted to private mode. From this perspective, TDX-Connect will be built on
>> this shared device assignment proposal.
>>
>>>
>>>>
>>>> Could you please add this topic to the agenda?
>>>
>>> Will do. But I'm afraid the agenda for tomorrow is pretty packed, so we might
>>> not get to talk about it in more detail before the meeting in 2 weeks.
>>
>> Understood. is there any QEMU patch available for in-place conversion? we would
>> like to play with it and also do some experiments w/ assigned devices. This
>> might help us identify more potential issues for discussion.
> 
> 
> Have you found out if there are patches, somewhere? I am interested too.

I remember that so far only Kernel patches are available [1], I assume 
because Google focuses on other user space than QEMU. So I suspect the 
QEMU integration is still TBD.


[1] https://lkml.kernel.org/r/20241213164811.2006197-1-tabba@google.com

-- 
Cheers,

David / dhildenb


