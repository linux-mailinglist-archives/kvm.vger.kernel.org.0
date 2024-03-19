Return-Path: <kvm+bounces-12139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF2787FE8A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568F01F22A8A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778EC80BEB;
	Tue, 19 Mar 2024 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gd84Hvm1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBAC80BF4
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710854386; cv=none; b=WrR1djtCoIKLUgkpEsc2ngEWtCr30hNrpyO2ftgLl+1EzlDc4hkoMo7Y7fcsPRCQx4fIeGERxSLO/5Y12ibXAsaAQXFGWOugY6L+1jmvznQxpqXKr2QCzzXEgBO6N3K0WpFdbK/uSXsqvSu2mLutR3xCB965WKWRSvPlJVZujTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710854386; c=relaxed/simple;
	bh=pqLK5r+6glGRViAulW3S3Y5ve9BzKiH6gJ4YPllNek0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ClzqGCg7VKwbgmqCrjPUAe1snzOBBBEnEsMa+XFjOlhSmlVNlMe8/DGvK2Kyn8dEnM0xjxCCQ1j6UCZxWooRRDSEccDmEA02CctfvUR8RJuFu2TggV8N3DVY+A2BC5J71TaYg9OEBbm5aMyC/L/rd+YW6813Ag/WLQJPdcWtG6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gd84Hvm1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710854384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pUA4jyYPpyLWZ5GdB21IaWHY0bnpxN+yp5QXHB7m1nw=;
	b=gd84Hvm1qhFCDHpBQsScGlY35yVL/16A6eF64jN3VCvzbtQsrCfuD5kUG9G/uwB67AOxIx
	TRBfk/nw7+nnt8MkTKWNSBULBK/oy7pc83H1/MEVFGCwujrxYhCpG79cqvfVWpTp/vDaBI
	hDFfvCI6+RCKR/5T8cMAeKjSng+H/y0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-48NCowcjNdqG8FclrMpLsQ-1; Tue, 19 Mar 2024 09:19:42 -0400
X-MC-Unique: 48NCowcjNdqG8FclrMpLsQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41401f598cfso18562335e9.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 06:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710854381; x=1711459181;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:from:content-language:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pUA4jyYPpyLWZ5GdB21IaWHY0bnpxN+yp5QXHB7m1nw=;
        b=P+p5mEfD4F3t6qwqb/xp/GwtMQ3bl7JuP2wq261wDM71ScO58OH3tIANaAHD6RJqym
         +GvlF6esqMddoiIx7OPlfWhWgkNjh3oYigvegLLc7y+qwrJOgqlkzWvzeEjQTo/Nl5Im
         YyMN5sXTjiI+MCbBMjNrW3EnR7eIyApOEJ3c6fe7Ot35z8yFsuBWvPDXFfhnbnb8rTUL
         vK4Y4becQ71FirZIwsbMhQKzj0OHZy1AOcfBFU6S+BuYlW4j60BE5eWOpzj3LJzodrxi
         58VydvrRnGP4Z+P3oNp7k5Q902ZQ7d6JDXW7islyU2YlDlssw4CCLvzqgFej9NFeEB3t
         /RbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnRONEKoAg6ygbVdz7nUEkSvp2gXGH91j+HONCdEA6zUTYVcYtbG5mGNeMdpOiA9IRznx3MkF/Noffapwi2fFHOidX
X-Gm-Message-State: AOJu0YwrORTpJ1h5L/0xCeIrEuM+QbvwH41JtFoB+yu1TLbL2O9TxNYz
	cUrzCQaThD1Ad8ggFLF/yoqYMJRJnN9Ncj3Ne4aToeqG2kMtA1tQhPZX1N5dQ2ccaJvaIfZiGCt
	wVzGa5i4Q2EghF9UKdIVMZ54Njr7HPe0qb5zg5Gz92Ztr3uiObg==
X-Received: by 2002:a05:600c:1d0e:b0:413:3941:d9ae with SMTP id l14-20020a05600c1d0e00b004133941d9aemr10729855wms.31.1710854381273;
        Tue, 19 Mar 2024 06:19:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQggSEygSN3zjaUeleSU2az0Hn2tbOnGs4AaLWZpa++FmT1PitVXiZZMyXBncQjc3UEteHOA==
X-Received: by 2002:a05:600c:1d0e:b0:413:3941:d9ae with SMTP id l14-20020a05600c1d0e00b004133941d9aemr10729813wms.31.1710854380767;
        Tue, 19 Mar 2024 06:19:40 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:2200:2adc:9a8d:ae91:2e9f? (p200300cbc74122002adc9a8dae912e9f.dip0.t-ipconnect.de. [2003:cb:c741:2200:2adc:9a8d:ae91:2e9f])
        by smtp.gmail.com with ESMTPSA id fj14-20020a05600c0c8e00b00413385ec7e6sm21514330wmb.47.2024.03.19.06.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 06:19:40 -0700 (PDT)
Message-ID: <0b1e1054-012f-4cc3-9d25-1147fa8cd6f0@redhat.com>
Date: Tue, 19 Mar 2024 14:19:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Quentin Perret <qperret@google.com>, Matthew Wilcox
 <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> I had started a discussion for this [2] using an RFC series.
>>
>> David is talking about the host side of things, AFAICT you're talking about the
>> guest side...
>>
>>> challenge here remain:
>>> 1) Unifying all the conversions under one layer
>>> 2) Ensuring shared memory allocations are huge page aligned at boot
>>> time and runtime.
>>>
>>> Using any kind of unified shared memory allocator (today this part is
>>> played by SWIOTLB) will need to support huge page aligned dynamic
>>> increments, which can be only guaranteed by carving out enough memory
>>> at boot time for CMA area and using CMA area for allocation at
>>> runtime.
>>>      - Since it's hard to come up with a maximum amount of shared memory
>>> needed by VM, especially with GPUs/TPUs around, it's difficult to come
>>> up with CMA area size at boot time.
>>
>> ...which is very relevant as carving out memory in the guest is nigh impossible,
>> but carving out memory in the host for systems whose sole purpose is to run VMs
>> is very doable.
>>
>>> I think it's arguable that even if a VM converts 10 % of its memory to
>>> shared using 4k granularity, we still have fewer page table walks on
>>> the rest of the memory when using 1G/2M pages, which is a significant
>>> portion.
>>
>> Performance is a secondary concern.  If this were _just_ about guest performance,
>> I would unequivocally side with David: the guest gets to keep the pieces if it
>> fragments a 1GiB page.
>>
>> The main problem we're trying to solve is that we want to provision a host such
>> that the host can serve 1GiB pages for non-CoCo VMs, and can also simultaneously
>> run CoCo VMs, with 100% fungibility.  I.e. a host could run 100% non-CoCo VMs,
>> 100% CoCo VMs, or more likely, some sliding mix of the two.  Ideally, CoCo VMs
>> would also get the benefits of 1GiB mappings, that's not the driving motiviation
>> for this discussion.
> 
> Supporting 1 GiB mappings there sounds like unnecessary complexity and
> opening a big can of worms, especially if "it's not the driving motivation".
> 
> If I understand you correctly, the scenario is
> 
> (1) We have free 1 GiB hugetlb pages lying around
> (2) We want to start a CoCo VM
> (3) We don't care about 1 GiB mappings for that CoCo VM, but hguetlb
>       pages is all we have.
> (4) We want to be able to use the 1 GiB hugetlb page in the future.
> 
> With hugetlb, it's possible to reserve a CMA area from which to later
> allocate 1 GiB pages. While not allocated, they can be used for movable
> allocations.
> 
> So in the scenario above, free the hugetlb pages back to CMA. Then,
> consume them as 4K pages for the CoCo VM. When wanting to start a
> non-CoCo VM, re-allocate them from CMA.
> 
> One catch with that is that
> (a) CMA pages cannot get longterm-pinned: for obvious reasons, we
>       wouldn't be able to migrate them in order to free up the 1 GiB page.
> (b) guest_memfd pages are not movable and cannot currently end up on CMA
>       memory.
> 
> But maybe that's not actually required in this scenario and we'd like to
> have slightly different semantics: if you were to give the CoCo VM the 1
> GiB pages, they would similarly be unusable until that VM quit and freed
> up the memory!
> 
> So it might be acceptable to get "selected" unmovable allocations (from
> guest_memfd) on selected (hugetlb) CMA area, that the "owner" will free
> up when wanting to re-allocate that memory. Otherwise, the CMA
> allocation will simply fail.
> 
> If we need improvements in that area to support this case, we can talk.
> Just an idea to avoid HGM and friends just to make it somehow work with
> 1 GiB pages ...


Thought about that some more and some cases can also be tricky (avoiding 
fragmenting multiple 1 GiB pages ...).

It's all tricky, especially once multiple (guest_)memfds are involved 
and we really want to avoid most waste. Knowing that large mappings for 
CoCo are rather "optional" and that the challenge is in "reusing" large 
pages is valuable, though.

-- 
Cheers,

David / dhildenb


