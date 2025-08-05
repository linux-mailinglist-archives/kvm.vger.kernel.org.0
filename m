Return-Path: <kvm+bounces-54002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D91B1B4F5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7927E3BE03D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B193C277017;
	Tue,  5 Aug 2025 13:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IOcwC01o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDE4275B0D
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400837; cv=none; b=LOcT8vKQOwX+Yr8CxZcu9P1ArK2xmg3jlMFW7lCW22YsD+hIbz54TYTKcZSKbBpHdPbGSl1MPnrmCRSYzAfMtx/RmMb0hTDtqn6O7WPszt2rjw1dFE4rXeSkJaPkRkjZmf3QcO5VFVkbiGiJKllmNbKXryP9RVh9j6MkCBIu2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400837; c=relaxed/simple;
	bh=QMpDNaL5WJ1RE/MaPb56ilN7pYjhlTdQtZWwmUFMRmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cad4o/R6zmWvHhrv8GI3rcM4VemsUeQEwnylCYbdFu0jl5VK5Zc6OeuERvHR6BEu0gzd+KDF0LCrzGei5o9n50pBeOc2Z4wjhPfrwMk/i18i/oxzaonsA8RA/2eBnzzMUP4uWMzrOlLFRf7/zB+fqJmGRWEO6L4361hNrNrm3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IOcwC01o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754400835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+WYt6rd9/T+z0v/X9j3zOniisBmkObJHDVlt8TFvSZI=;
	b=IOcwC01oeZ06+nJXfGks770MNEZGeNIDGvS/ycsNFEifOCCSZ/97NEs83/596qe8j07Vxa
	13Kn0DPjHfBdgvLAXVuoI41d2iEWdzUNv9oQriF0fTZT5oSm0yUo4CoowLA//aXDgFp0fv
	p8VO/jEeUL5pK49oBEeOuEndz/NS5kE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-8Pasu5jQPheV1jpM2nBvDg-1; Tue, 05 Aug 2025 09:33:53 -0400
X-MC-Unique: 8Pasu5jQPheV1jpM2nBvDg-1
X-Mimecast-MFC-AGG-ID: 8Pasu5jQPheV1jpM2nBvDg_1754400831
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so2287472f8f.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400831; x=1755005631;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+WYt6rd9/T+z0v/X9j3zOniisBmkObJHDVlt8TFvSZI=;
        b=nBj7zQwL8ptRslTyDsatmCsifCK5OxQglpRh6wqWbFqj0Yb5IKD9Em8m5TOBrx7vXr
         QSDS/qTJIdmJudLqL6cuooHUBkknkfDxTHek2wkY8WkNygyoSqIrTKt5jKBgxObM01Xt
         NkUgNkVJuxN33/gj0wAWZG/vd1SfS5VNypQQGI1CwSchAVQxb9kGUy6wOTcT284otveJ
         /Sh658U3vlFG24ykHew4p2CXgJTrhXHKQMEjwtk+7+udNzl56AUE+Tid9nqeL/9Rx7S7
         C4rxyR+AaIx1feJaEO60xNSx5oZDGwOroYmpNiSqGFuhN9vVSayo5JVWTQxma5fOJl0D
         Y3Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWudAIvgg8KEpfcLFjLyrJmH6BeqALIHvFpZ9j/TEs2QlqoIz8OP4mJRSGYyPoge0rYkJM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb8bJsRgXac7v8OydZBB1a9sTkTOcjkEXqq6cs/ZDCB1+2I28U
	uWJB8I73luekfNFS7lufBQCiQHkPpxEG86CUz2VmK7CTv89DvDvc33RTZlF9Xp+Fg4ET8tz6pce
	MpFA/RfqhSvMYehT8Hp3LVw3C/TcLRY2+rcP0WJqfFwP8b2jl34LHIA==
X-Gm-Gg: ASbGnct2WpOWvnuvSQjsy8cXc7I6MBYcBxakEZGpEHAFfuHHwSASs79sA6lmNwLhTqa
	QCdVPDb4fTcHN4NUhvCPMOcjcPxU00fYad13X735B5nNKfusFJRh5sR3DiMSIXEgS4HbuGRwvD2
	BxrwNqxFPLIUcnrySJ8Z6f6RoTorpf7RYeZQGxcLxVNPGds1z5TTw01WWnElf9xfZ5KhVjvMi/5
	j1ZMRiVorgAraipnWA9gGGddeYtNfCezNvCbxq4+EAZ8ykq2Z+Vw9liks4SJV9+eBHDxwnuTG1m
	I9J4RulVcJIRFfnqf+OgaUQtzGAhrNvybOGaXEcnIdRU3+Ghm9seYPYLk9seTrxOqz628AwBIdv
	V4o1fVWpRkhaVF3wSzvngiByW1WAzrXOftS4CrkXm89vLb1d7HLSSUcXwE5bFYR3xFco=
X-Received: by 2002:a05:6000:188c:b0:3b7:9bd2:7ae7 with SMTP id ffacd0b85a97d-3b8d94ca755mr10078638f8f.57.1754400831229;
        Tue, 05 Aug 2025 06:33:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIObB8DRyB3S0rfwdWzVl32HGpVvH72r3KyaA9Fl/4UDRL54Gjavxvd60hUeleCboLn+7h5A==
X-Received: by 2002:a05:6000:188c:b0:3b7:9bd2:7ae7 with SMTP id ffacd0b85a97d-3b8d94ca755mr10078617f8f.57.1754400830774;
        Tue, 05 Aug 2025 06:33:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48a05bsm19380753f8f.69.2025.08.05.06.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:33:50 -0700 (PDT)
Message-ID: <00999740-d762-488a-a946-0c10589df146@redhat.com>
Date: Tue, 5 Aug 2025 15:33:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805132558.GA365447@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:25, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 04:00:53PM +0300, Linus Torvalds wrote:
>> On Tue, 5 Aug 2025 at 10:47, David Hildenbrand <david@redhat.com> wrote:
>>>
>>> The concern is rather false positives, meaning, you want consecutive
>>> PFNs (just like within a folio), but -- because the stars aligned --
>>> you get consecutive "struct page" that do not translate to consecutive PFNs.
>>
>> So I don't think that can happen with a valid 'struct page', because
>> if the 'struct page's are in different sections, they will have been
>> allocated separately too.
> 
> This is certainly true for the CONFIG_SPARSEMEM_VMEMMAP case, but in
> the other cases I thought we end up with normal allocations for struct
> page? This is what David was talking about.
> 
> So then we are afraid of this:
> 
>    a = kvmalloc_array(nelms_a);
>    b = kvmalloc_array(nelms_b);
> 
>    assert(a + nelms_a != b)
> 
> I thought this was possible with our allocator, especially vmemmap?
> 
> David, there is another alternative to prevent this, simple though a
> bit wasteful, just allocate a bit bigger to ensure the allocation
> doesn't end on an exact PAGE_SIZE boundary?

:/ in particular doing that through the memblock in sparse_init_nid(), I 
am not so sure that's a good idea.

I prefer Linus' proposal and avoids the one nth_page(), unless any other 
approach can help us get rid of more nth_page() usage -- and I don't 
think your proposal could, right?

-- 
Cheers,

David / dhildenb


