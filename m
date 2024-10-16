Return-Path: <kvm+bounces-28992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A46D9A08D8
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DBB21C22974
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 11:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1142120896C;
	Wed, 16 Oct 2024 11:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SdFyHkHW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933C208213
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079682; cv=none; b=EzeEVe7SDiLMlW3AjppKISt/YAJDSSRFPRRVBaMnmIq61vNUejJ8QHT22NO+C9IKepYwQT4sTU4skHP3nb9zK90Qsc7MCMTneSGlam2YLhHLXfDrjbV2C3yywvPHgv/tvuoyOMH4PfVaRzNtvZ+WoZrHhVKrOvwoC/DzZF/Ploc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079682; c=relaxed/simple;
	bh=GQCzQpBqYhwAkzMJQINgNLnJrAw9aVSQemy8hHyPBuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DYrDs/0o40f++ZrBet38UoWimGDAiwUXCi7SG26vubJrg4/SYzXvztj8cJTPQfBEy+TNC+Y6hThT4l1/eh7FIPEkXRu4GUVkMfX1Y9LnK02TvGRIAChY81G42a1sv8D5/eBaXMAY6lENxInaZi1L51dMQnxSfUTbykMCeird2Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SdFyHkHW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729079679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+kEzzKAq1Xr+RfOrdE1dZbEj8+FSiphV2ulu+9sQs2s=;
	b=SdFyHkHWPNdQ2Fi1AxjUUhsmDYnt1Hd8O4zJkCa2SwJgPC4B+i26uiL13KvSbDsOqEoaNg
	LGiJV+qGthTz8A0YksFXpqFQs6QWK5Jzz5Bb/UaTry2k3QIDVCD82uOtjCFX+v+d9CiJBA
	2xbhY3idfkq9lULH6RzMs9b3D1hER3M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-Z5BRKRa1M4m3awRoQpPhIw-1; Wed, 16 Oct 2024 07:54:36 -0400
X-MC-Unique: Z5BRKRa1M4m3awRoQpPhIw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d4d51b4efso2521662f8f.3
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 04:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729079675; x=1729684475;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+kEzzKAq1Xr+RfOrdE1dZbEj8+FSiphV2ulu+9sQs2s=;
        b=iybD8yuEj+WGESoIjFYkshHHQnoAbeq5GalUWJY+MqEotZHRm4dDdDP/k63X7XNxN4
         6vxI/i02bAD8iZyYCkdVOv6igm2U2MlczexFLmgKxZ5ks397RJacDd+NUq7DWRDhbjDv
         0mm4OzflktMvc8OS8INPrhwHbLzLd68mfxSMztf9OmnT59Y/yqPWhZ3xx+OFq4O8QCWX
         9Gvvbr8iCbXjSzwVfPjhg7OEQPmCPtPb/6fiHr7WH8AXVyxFKmH1kl0YZ+ZgqHWR5kiY
         ug+RALGYajSBfRy75FXaMPNaDQTTFyj1fGbjlAcg1EEswflVzEDjEbidtDIauXo5jrQC
         fqIA==
X-Forwarded-Encrypted: i=1; AJvYcCXz9B4MET2CbsXFBnUiPeQ4Mcp8zPbPmrmhB9KVJCxIi8zB27GdpHkwecBRBxH8b4yBVWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxNBS82Tw9Z8HuQMvD7jeIQKClucu1AhbjhDjUi4j4Yqrst9v6
	ewxdObPhzzdceRxuQaIX0miHfI8UeotbRWmKGGM7f4lP49f+sgFxyU9goGTAiqplBoaklY2TDsq
	GENfssfelDfZhnGRKYkphPOH1SsTkHwm/7Gx/A9XAWxXaOmquMQ==
X-Received: by 2002:a5d:5051:0:b0:37d:4fab:c194 with SMTP id ffacd0b85a97d-37d86bd59b0mr2442136f8f.25.1729079675460;
        Wed, 16 Oct 2024 04:54:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpzpphMSA1vqW8xPU2T5T6gdp6f0pi/o+tw4r1TPbhVimozDJNRmBvXrolYTlTKYAFZDGJaw==
X-Received: by 2002:a5d:5051:0:b0:37d:4fab:c194 with SMTP id ffacd0b85a97d-37d86bd59b0mr2442105f8f.25.1729079674971;
        Wed, 16 Oct 2024 04:54:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:d000:3a9:de5c:9ae6:ccb3? (p200300cbc74bd00003a9de5c9ae6ccb3.dip0.t-ipconnect.de. [2003:cb:c74b:d000:3a9:de5c:9ae6:ccb3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a256sm4127405f8f.14.2024.10.16.04.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 04:54:34 -0700 (PDT)
Message-ID: <a31b66f2-1f4d-4826-bd57-2600603d5e0c@redhat.com>
Date: Wed, 16 Oct 2024 13:54:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Peter Xu <peterx@redhat.com>,
 tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
 jgg@nvidia.com, rientjes@google.com, fvdl@google.com, jthoughton@google.com,
 seanjc@google.com, pbonzini@redhat.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, isaku.yamahata@intel.com,
 muchun.song@linux.dev, erdemaktas@google.com, qperret@google.com,
 jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org,
 brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev,
 pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com,
 anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com,
 vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com,
 oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <cover.1726009989.git.ackerleytng@google.com>
 <bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com>
 <Zwf7k1wmPqEEaRxz@x1n> <diqz8quunrlw.fsf@ackerleytng-ctop.c.googlers.com>
 <Zw7f3YrzqnH-iWwf@x1n> <diqz1q0hndb3.fsf@ackerleytng-ctop.c.googlers.com>
 <9abab5ad-98c0-48bb-b6be-59f2b3d3924a@redhat.com>
 <CAGtprH_AiVJAd4rxKZBC9372swf2hW8kFfWG2y7zBdzCmpLRUw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CAGtprH_AiVJAd4rxKZBC9372swf2hW8kFfWG2y7zBdzCmpLRUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16.10.24 12:48, Vishal Annapurve wrote:
> On Wed, Oct 16, 2024 at 2:20 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>>> I also don't know how you treat things like folio_test_hugetlb() on
>>>> possible assumptions that the VMA must be a hugetlb vma.  I'd confess I
>>>> didn't yet check the rest of the patchset yet - reading a large series
>>>> without a git tree is sometimes challenging to me.
>>>>
>>>
>>> I'm thinking to basically never involve folio_test_hugetlb(), and the
>>> VMAs used by guest_memfd will also never be a HugeTLB VMA. That's
>>> because only the HugeTLB allocator is used, but by the time the folio is
>>> mapped to userspace, it would have already have been split. After the
>>> page is split, the folio loses its HugeTLB status. guest_memfd folios
>>> will never be mapped to userspace while they still have a HugeTLB
>>> status.
>>
>> We absolutely must convert these hugetlb folios to non-hugetlb folios.
>>
>> That is one of the reasons why I raised at LPC that we should focus on
>> leaving hugetlb out of the picture and rather have a global pool, and
>> the option to move folios from the global pool back and forth to hugetlb
>> or to guest_memfd.
>>
>> How exactly that would look like is TBD.
>>
>> For the time being, I think we could add a "hack" to take hugetlb folios
>> from hugetlb for our purposes, but we would absolutely have to convert
>> them to non-hugetlb folios, especially when we split them to small
>> folios and start using the mapcount. But it doesn't feel quite clean.
> 
> As hugepage folios need to be split up in order to support backing
> CoCo VMs with hugepages, I would assume any folio based hugepage
> memory allocation will need to go through split/merge cycles through
> the guest memfd lifetime.

Yes, that's my understanding as well.

> 
> Plan through next RFC series is to abstract out the hugetlb folio
> management within guest_memfd so that any hugetlb specific logic is
> cleanly separated out and allows guest memfd to allocate memory from
> other hugepage allocators in the future.

Yes, that must happen. As soon as a hugetlb folio would transition to 
guest_memfd, it must no longer be a hugetlb folio.

> 
>>
>> Simply starting with a separate global pool (e.g., boot-time allocation
>> similar to as done by hugetlb, or CMA) might be cleaner, and a lot of
>> stuff could be factored out from hugetlb code to achieve that.
> 
> I am not sure if a separate global pool necessarily solves all the
> issues here unless we come up with more concrete implementation
> details. One of the concerns was the ability of implementing/retaining
> HVO while transferring memory between the separate global pool and
> hugetlb pool i.e. whether it can seamlessly serve all hugepage users
> on the host.

Likely should be doable. All we need is the generalized concept of a 
folio with HVO, and a way to move these folios between owners (e.g., 
global<->hugetlb, global<->guest_memfd).

Factoring the HVO optimization out shouldn't be too crazy I believe. 
Famous last words :)

> Another question could be whether the separate
> pool/allocator simplifies the split/merge operations at runtime.

The less hugetlb hacks we have to add, the better :)

-- 
Cheers,

David / dhildenb


