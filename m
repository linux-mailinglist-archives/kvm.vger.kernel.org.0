Return-Path: <kvm+bounces-45598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E23E0AAC79B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 040689809E9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAA722D790;
	Tue,  6 May 2025 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VzYhpzvD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A3C280006
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540921; cv=none; b=JDPD7LmcEB8zP/wfEX2Y0LlZ9D0mQbjuEbfts1tPfAQ0u8zSyl2QlSSA+1OyKGhHLKvJYHk4yyCcFww5SA6wCiHZjt9TajdRByDdNqnYo1D1c5edPml2JSbyigS19ziquKP9IBD82VrQ7cNKhXllkdD6AX8mnguHT6B1ih/31NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540921; c=relaxed/simple;
	bh=KXhLrXstZ270xbaX23H7LhAxp9pzzvl5arekRXqG/50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bn3iozHz/A6KwwdlgfVvRql6EHxwwfKqx9q9qSYlcOUsoXFTrH0Jh7pXW4YnuRLRUj6kOaQy3EHV4RdzxczZtNmazDJ7RkQNOijS2e33O18fCDeab3Jawbi5Y5v+Q90/Ho1VH+COr5ZWr9UduSKgvSPy2y/Wryb4uCzMpSCylAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VzYhpzvD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746540918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4APN7dnMnAt5QkvYolpeUiJNpxoUhPNfZxfp6a9qlkA=;
	b=VzYhpzvDtT1O0MB6TckMCaMvasekBV/z/9EN+jJ/Oa/MucwFjM1EWTT1HPpTf7jBmD2EmT
	4TcXn7f5FZOWXQQ1I+Gqui+DZ1g6nNI8kjfhB+L3CEmEIhznQfeu5UE2kIWFQIz0QXbr1H
	dhCRJBsOyG0VmVSS35zejZBe0cWW6Hk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-VA9QnG_FMueH46heKoedvA-1; Tue, 06 May 2025 10:15:17 -0400
X-MC-Unique: VA9QnG_FMueH46heKoedvA-1
X-Mimecast-MFC-AGG-ID: VA9QnG_FMueH46heKoedvA_1746540916
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39ee57e254aso3094896f8f.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746540916; x=1747145716;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4APN7dnMnAt5QkvYolpeUiJNpxoUhPNfZxfp6a9qlkA=;
        b=wmI+Y+YaTZpw2SsrQ/qbdJiq7+wJ5DdCYdasMcxn+uXTLGDLal5rtdVyz+CSvfPzXh
         RAajsMGfNvyu8HKI6TU2htOcGow0RlXLM+PM802OnsKNvn1fmqm2WsAhSXqUQJNTtpkf
         lzm5t/huwjoYh3jCs0oOjuvJN3tX17NcKfmp10YHcxEjHyjrKn9XoB0iO9OC89GSxh1L
         GfR2IKTtvYgAQIaakEmPpuADtnX5asbmmEbw1GRQ9jTZQb3o5FSwY0jpzC6AeDs2981v
         OSW/1iUIMr9Px4qp1TNM2zpSMHeSGpdk/locA2ELDX422Stu0d9zlOpcRWcZ7Zn9hYo5
         G8gg==
X-Forwarded-Encrypted: i=1; AJvYcCWd9LzUlnTa+TOOGzYOB/hHK37lhcvl6wZpaW5Gub05jmbr6Ieql1hPBJuot1iinBq4XCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Xt9AG6UyaYhspNX2cCSAfVesaKi6yKmZrkw9ANwpTX8y0eQn
	UCh/rBudQtp9YPmAEAum2Do16gDLVCK1sN0ndHY+JTEG92n0iW0phKCRq6c1liTrRJ5/TbsIyo3
	B1HKEuNuQ1zyEgYE6amr4y7VzyzZ7EeBGI/AaJQLDPWxeNRLFaQ==
X-Gm-Gg: ASbGnct7ThHxwkujg7EgX4HfJihaWc8u8AWqhSf8luFu3p6gtjVc9AlJ9CQG9ydU5kL
	NoTze+tbKaClpQaOXBXBEleOOF5JgcZZn5NmxFsZQfVt0zzJbSnKx0R/OT1BVYmkuTQNxwb6jm7
	D04RVK7RswS0x0D40u4JkDmouWCnPKA823bMpc7b/BrzvjpQsP8U3qOpBRs3bPckyqFbRX1CDQL
	KaSdA8Ko0NWJISb972q+Gm2NUheXhFatTm6QJiMqdh9u1dXnZ5yR3bkwZyCIpsBQVRen0HkD0Xq
	j3H0SpGwUSEtsBC98sDQughJap/RaEXelu7y7OjAGAWUD+UqQr4=
X-Received: by 2002:a5d:584d:0:b0:3a0:7fd4:2848 with SMTP id ffacd0b85a97d-3a0ac3eb15bmr2870821f8f.52.1746540916207;
        Tue, 06 May 2025 07:15:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgitA+znSrs1vXUCKq97PQplFmwCrP3rkC+yS96yyi2Pokh/Euka5gxglHWGpKYjq6Epu4HA==
X-Received: by 2002:a5d:584d:0:b0:3a0:7fd4:2848 with SMTP id ffacd0b85a97d-3a0ac3eb15bmr2870751f8f.52.1746540915674;
        Tue, 06 May 2025 07:15:15 -0700 (PDT)
Received: from ?IPV6:2a01:599:915:8911:b13f:d972:e237:7fe2? ([2a01:599:915:8911:b13f:d972:e237:7fe2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b0f18accsm1745424f8f.41.2025.05.06.07.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 07:15:15 -0700 (PDT)
Message-ID: <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
Date: Tue, 6 May 2025 16:15:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com>
 <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com>
 <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com>
 <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
 <aBoVbJZEcQ2OeXhG@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aBoVbJZEcQ2OeXhG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06.05.25 15:58, Sean Christopherson wrote:
> On Mon, May 05, 2025, Vishal Annapurve wrote:
>> On Mon, May 5, 2025 at 10:17 PM Vishal Annapurve <vannapurve@google.com> wrote:
>>>
>>> On Mon, May 5, 2025 at 3:57 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>> ...
>>>>> And not worry about lpage_infor for the time being, until we actually do
>>>>> support larger pages.
>>>>
>>>> I don't want to completely punt on this, because if it gets messy, then I want
>>>> to know now and have a solution in hand, not find out N months from now.
>>>>
>>>> That said, I don't expect it to be difficult.  What we could punt on is
>>>> performance of the lookups, which is the real reason KVM maintains the rather
>>>> expensive disallow_lpage array.
>>>>
>>>> And that said, memslots can only bind to one guest_memfd instance, so I don't
>>>> immediately see any reason why the guest_memfd ioctl() couldn't process the
>>>> slots that are bound to it.  I.e. why not update KVM_LPAGE_MIXED_FLAG from the
>>>> guest_memfd ioctl() instead of from KVM_SET_MEMORY_ATTRIBUTES?
>>>
>>> I am missing the point here to update KVM_LPAGE_MIXED_FLAG for the
>>> scenarios where in-place memory conversion will be supported with
>>> guest_memfd. As guest_memfd support for hugepages comes with the
>>> design that hugepages can't have mixed attributes. i.e. max_order
>>> returned by get_pfn will always have the same attributes for the folio
>>> range.
> 
> Oh, if this will naturally be handled by guest_memfd, then do that.  I was purely
> reacting to David's suggestion to "not worry about lpage_infor for the time being,
> until we actually do support larger pages".
> 
>>> Is your suggestion around using guest_memfd ioctl() to also toggle
>>> memory attributes for the scenarios where guest_memfd instance doesn't
>>> have in-place memory conversion feature enabled?
>>
>> Reading more into your response, I guess your suggestion is about
>> covering different usecases present today and new usecases which may
>> land in future, that rely on kvm_lpage_info for faster lookup. If so,
>> then it should be easy to modify guest_memfd ioctl to update
>> kvm_lpage_info as you suggested.
> 
> Nah, I just missed/forgot that using a single guest_memfd for private and shared
> would naturally need to split the folio and thus this would Just Work.

Yeah, I ignored that fact as well. So essentially, this patch should be 
mostly good for now.

Only kvm_mmu_hugepage_adjust() must be taught to not rely on 
fault->is_private.

Once we support large folios in guest_memfd, only the "alignment" 
consideration might have to be taken into account.

Anything else?

-- 
Cheers,

David / dhildenb


