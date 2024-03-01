Return-Path: <kvm+bounces-10622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D370B86DFCF
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3ACE1C21F11
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A476BFD9;
	Fri,  1 Mar 2024 11:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmwnfFr2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55E6A8D9
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709291172; cv=none; b=AiWvXJv69y0S85JtLRLQRzvbjI/FoFIfnHOcAFd9OiWLY52GuJJwawPh6Bghjz6fck1J+tSUArckwO78uouZYtiIdLpy8RrmPofftXK0pC5Z9+gZNPmdg+Yqb1V2q5/2bSL9j6+Tlg2HsAcN1YebC5qgzz7chy0ak6Cbe90B928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709291172; c=relaxed/simple;
	bh=op/dcZNAdhYlhoEh45q8h+j9w0m7hwMJuIawygV6gKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4qOUTSkUil72GVl6mjL4tpFO2WZTaoh7+eJ+Ey0TyTgvkqWJ0Kbn0S7PEIvp2D7t45tHLt529vKBsnPmcbI8q+tf6ALH6N2OiuzLu6UiuMgdqM8tNsj5GkgSp97nK/6WykU2B6SQJU5p9tG+9sDH5tfnilVwDjOOXMGt0FpevU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmwnfFr2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709291170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OTu9yQAz/Bq5q8qJRpL1GEaCaOVasim4Cds/yT3hKoY=;
	b=ZmwnfFr2clSE5rY1a+B0FAig8Ae5C2LIYM77oN9PpN+WppwVm1lxuwd52XvN99SkMLU5mK
	0Jmkay92YVd2E7LBSQNDq4rUdtyrToy3T5mZb2/6aYGTtiUBqx5JBPWfhWPG2Oqfi0aOMH
	QHjm32Zo39Bn9dKShRwjgXw0lx38Vpw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-kH_bLyPbNWuRmXy-o9facw-1; Fri, 01 Mar 2024 06:06:09 -0500
X-MC-Unique: kH_bLyPbNWuRmXy-o9facw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412c9e3c9b9so1688815e9.0
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:06:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709291168; x=1709895968;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTu9yQAz/Bq5q8qJRpL1GEaCaOVasim4Cds/yT3hKoY=;
        b=hj3vb46wsk/Gyy7IcRUsyDzs+B3kw2/zbu2t88vBd7PTmIdKsfftih2G9DICx5CwWc
         yvZLH2+kA6CKCyh80GhdO7TxLJ+FVgisbr2gxxr2YLj/bWXpjQdnRx6pBzLaVxIc20Za
         9r1LUy+dGrPv1oHPTogvZw/D0mq/g5QuEFqWB1lkodIbTwfzR27k0mb8sebkm+g3OuPr
         2TBy3JvbmlUNz8ax80FxcjFUBCttLOAJsMhVX8ltZauET0zaRRLifsjnO4pfjfu+lyoS
         ADaEQYfLERp4RVR+n5lAG2LjMmD1Ww1UOG7UULbxeYojhyjAaL25aw/L2oN3csOtv20s
         ChRg==
X-Forwarded-Encrypted: i=1; AJvYcCUkZpbgd+SFV5oHoknSKXklAb+2HVDblDjJYI0nstYVgJuFXkHm4qgrWoSSIM+Qj7lBXaqNzJDyOYkzbfIO2MUr4qSf
X-Gm-Message-State: AOJu0YwCc/mhvla733yuogy8zS7jHU90BKZ3kUst1433rMNGz+iMJxbi
	mGaYi1TJbbnkCqDKyyafojgFoheE67B/5LZ6P+PxWeMS8VtkIfVecGbel8ZCTIX/bhb9mz/VOEo
	j7HTiU+zHXzV59Y2EQp+AhjbZw+adWGHaLYdfvRs4xSlw0bgtdQ==
X-Received: by 2002:a05:600c:1d21:b0:412:bcca:751d with SMTP id l33-20020a05600c1d2100b00412bcca751dmr1521272wms.11.1709291167630;
        Fri, 01 Mar 2024 03:06:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWiHz7xg2JWGvWqpFUD5KHhM2g2oWKiybeNQjejSi0p04jASbNX1ljtzsf3Azwu4vHoKz6Sg==
X-Received: by 2002:a05:600c:1d21:b0:412:bcca:751d with SMTP id l33-20020a05600c1d2100b00412bcca751dmr1521238wms.11.1709291167154;
        Fri, 01 Mar 2024 03:06:07 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3200:77d:8652:169f:b5f7? (p200300cbc7133200077d8652169fb5f7.dip0.t-ipconnect.de. [2003:cb:c713:3200:77d:8652:169f:b5f7])
        by smtp.gmail.com with ESMTPSA id jp16-20020a05600c559000b00412a482cd90sm4910036wmb.25.2024.03.01.03.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 03:06:06 -0800 (PST)
Message-ID: <80348181-016a-47ee-b4f0-51d8fe092138@redhat.com>
Date: Fri, 1 Mar 2024 12:06:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>, Matthew Wilcox
 <willy@infradead.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.02.24 20:01, Fuad Tabba wrote:
> Hi David,
> 
> ...
> 

Hi!

>>>>> "mmap() the whole thing once and only access what you are supposed to
>>>    (> > > access" sounds reasonable to me. If you don't play by the rules, you get a
>>>>>> signal.
>>>>>
>>>>> "... you get a signal, or maybe you don't". But yes I understand your
>>>>> point, and as per the above there are real benefits to this approach so
>>>>> why not.
>>>>>
>>>>> What do we expect userspace to do when a page goes from shared back to
>>>>> being guest-private, because e.g. the guest decides to unshare? Use
>>>>> munmap() on that page? Or perhaps an madvise() call of some sort? Note
>>>>> that this will be needed when starting a guest as well, as userspace
>>>>> needs to copy the guest payload in the guestmem file prior to starting
>>>>> the protected VM.
>>>>
>>>> Let's assume we have the whole guest_memfd mapped exactly once in our
>>>> process, a single VMA.
>>>>
>>>> When setting up the VM, we'll write the payload and then fire up the VM.
>>>>
>>>> That will (I assume) trigger some shared -> private conversion.
>>>>
>>>> When we want to convert shared -> private in the kernel, we would first
>>>> check if the page is currently mapped. If it is, we could try unmapping that
>>>> page using an rmap walk.
>>>
>>> I had not considered that. That would most certainly be slow, but a well
>>> behaved userspace process shouldn't hit it so, that's probably not a
>>> problem...
>>
>> If there really only is a single VMA that covers the page (or even mmaps
>> the guest_memfd), it should not be too bad. For example, any
>> fallocate(PUNCHHOLE) has to do the same, to unmap the page before
>> discarding it from the pagecache.
> 
> I don't think that we can assume that only a single VMA covers a page.
> 
>> But of course, no rmap walk is always better.
> 
> We've been thinking some more about how to handle the case where the
> host userspace has a mapping of a page that later becomes private.
> 
> One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
> to the host with a meaningful exit reason) until the host unmaps that
> page, and check for the refcount to the page as you mentioned earlier.
> This is essentially what the RFC I sent does (minus the bugs :) ) .

:)

> 
> The other idea is to use the rmap walk as you suggested to zap that
> page. If the host tries to access that page again, it would get a
> SIGBUS on the fault. This has the advantage that, as you'd mentioned,
> the host doesn't need to constantly mmap() and munmap() pages. It
> could potentially be optimised further as suggested if we have a
> cooperating VMM that would issue a MADV_DONTNEED or something like
> that, but that's just an optimisation and we would still need to have
> the option of the rmap walk. However, I was wondering how practical
> this idea would be if more than a single VMA covers a page?

A few VMAs won't make a difference I assume. Any idea how many "sharers" 
you'd expect in a sane configuration?

> 
> Also, there's the question of what to do if the page is gupped? In
> this case I think the only thing we can do is refuse to run the guest
> until the gup (and all references) are released, which also brings us
> back to the way things (kind of) are...

Indeed. There is no way you could possibly make progress.

-- 
Cheers,

David / dhildenb


