Return-Path: <kvm+bounces-58903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B540ABA50AE
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 22:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE3621BC6D66
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 20:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9732848AE;
	Fri, 26 Sep 2025 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9tfvTMN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CC827702A
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758917356; cv=none; b=TIlqal9Hj+ZkFzf9ocGvR3toru0Ga+GPQ3hWIiXlmE6j8F3S5GwqUWyKa93nWwUwlTXck1mvJF8RmGKs3iScxlxdZk7J6FQFyptkp71xefH09NvAMnMUIfRQCkNqVCWoxJ3vTp6ufRIQOY7dTm4tqXrz05RnqRWpvySWEMMtCv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758917356; c=relaxed/simple;
	bh=FyvS/004RKrfyaJEL1dRKLmBFhReRQ7M0riPweqLojs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tuJcYoQYg0QN3hff25+eVTnXfmpLGePwniTR9hQ/LlUK1Cn/IjOvpYUL4oERvlez07WhpOXOkKpUY6W4ZiAxoe/wlId/+Od3Jf7K7SYelTGNAg1vWz4lfr0Y/FJ7d++CWro8NSfV9tE/g4bHSZHn2qAdQb+Hd+1/NDjJl9xwwf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9tfvTMN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758917354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ib0H/rihD2sgLLUp3Mw0vWL3Rv8TdCZCaNMZP5pfwcI=;
	b=M9tfvTMNuzDLwWHHMQFedYdSQ2FO3Sy4NBKuV1cIEwmRU3UFi1jUveL7/28WgjrYLE9DDF
	UPJtKM3EgnVCv9p45AbkZhAp/RIFm2UW9igtljHUcKpPIwj2m1qHGEhujltic1AreFEko7
	tbtKA+qa24nlqBatMml6N5IzKGeOlCE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-c2OJ0VZROlmmnvN8EAyZkw-1; Fri, 26 Sep 2025 16:09:13 -0400
X-MC-Unique: c2OJ0VZROlmmnvN8EAyZkw-1
X-Mimecast-MFC-AGG-ID: c2OJ0VZROlmmnvN8EAyZkw_1758917352
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e31191379so16799275e9.3
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 13:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758917352; x=1759522152;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ib0H/rihD2sgLLUp3Mw0vWL3Rv8TdCZCaNMZP5pfwcI=;
        b=MC3cBJHViTWIVBgQ11GsRSKXd0ksQVFyycX8G1QJjj5aj4IFycsYwk76/vRApdn4Q3
         yvlS1Tnq9Q/VhduRVFSS3+sReA1o5vbm3lfPJrjlsZuVnQtTwucxe0ep3ew5FRU9J7rA
         RI9reHt8TDzB6dCX8EGGMAw+YtAOAtGN3SmfcPB73QAPbnTZLZf7nsGG92AhhXlKjFul
         G+dndzsBwGqXBQka2/Nj9Cthspf37LkpdbnKcRwum94gPMBmqOuKwo2/UuBhlu7ncLEm
         2e2axXY1K17i9qX7NpZG/KEJ47iCyh5ZjtLiNptDol7//2OGwBGqPNxNJL2jxskBgxpe
         ylEw==
X-Forwarded-Encrypted: i=1; AJvYcCXezhcDquDH4X77IeQOOSQp+UA0+2Xebfq1tFAU9Wzrr+7VEJUrDTfLw5sUkY4OkNhAea4=@vger.kernel.org
X-Gm-Message-State: AOJu0YysswWbDptfdAMWC5zdtGkAZy9Ehfj2tkNx+mQA0yQCyVyRoJd3
	0Id46Vcqw0X7ae2oVW2zssMFI8YI3wHWAETYbN1Y0OiBfxsrxpc2YAPcXty/BsVDL+j7dtNvYPA
	gu9IXZ5bdiW0HP6caX1oGb1o9Y2LmqAY+cV1kUarCEjCY+7Xr8q/VyQ==
X-Gm-Gg: ASbGnctG1AKeAqEChA1dH02Au7RaV9mNa8RN3VLQR5k4GFzkw6SkQdqMt/UmEVMA2+Z
	eXC5Rtxi2oxvC1/owYi+MXYM1TOoSGWlSF5ZZ3tEojH+iLqrk1GairCuGJ2hWe+gILUx6g01aPW
	NeEtbPmPvk9PsI3J1wNEvdioLEnot34Hr7iQRwYptZyGThrprMtP/5UzHJC/0LwK8xWgb8uJ4hi
	1oMaD5MAcu1SJX8oYRMcxoA5+o+0LOM5E7lotlqrBKHU9AkQXLti1/gRzGn6LQI9T9UsNXKp0yC
	6VQxiBwX1lX1SNt+AqDNtTmjmiyXlWsC57tFcPLqJK3VBEKC5uwd3tA3Ov9qTvX9feeCXnqA0Gc
	163HbdUrk7Wu9YYc0oI9xCBaxUqmQIsvp5NdJ5eBvO8RW4wy3SHVzvIX8GlRRxnwHs6FE
X-Received: by 2002:a05:600c:5290:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e394b4b1emr54828135e9.11.1758917351697;
        Fri, 26 Sep 2025 13:09:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNmDiaYasC7MFzibBACE1MH2JcQe6qYBv0mKRAkGRcQH1a13pl7qsNitna301n0FxceVAOrA==
X-Received: by 2002:a05:600c:5290:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e394b4b1emr54827625e9.11.1758917351118;
        Fri, 26 Sep 2025 13:09:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:c100:5d3c:50c0:398a:3ac9? (p200300d82f34c1005d3c50c0398a3ac9.dip0.t-ipconnect.de. [2003:d8:2f34:c100:5d3c:50c0:398a:3ac9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996d7dsm136681855e9.4.2025.09.26.13.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 13:09:10 -0700 (PDT)
Message-ID: <5d11b5f7-3208-4ea8-bbff-f535cf62d576@redhat.com>
Date: Fri, 26 Sep 2025 22:09:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: Will Deacon <will@kernel.org>, Patrick Roy <patrick.roy@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick"
 <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
 <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
 <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
 <aNZwmPFAxm_HRYpC@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNZwmPFAxm_HRYpC@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.09.25 12:53, Will Deacon wrote:
> On Fri, Sep 26, 2025 at 10:46:15AM +0100, Patrick Roy wrote:
>>
>>
>> On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
>>> On 25.09.25 21:59, Dave Hansen wrote:
>>>> On 9/25/25 12:20, David Hildenbrand wrote:
>>>>> On 25.09.25 20:27, Dave Hansen wrote:
>>>>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>>>>> Add an option to not perform TLB flushes after direct map manipulations.
>>>>>>
>>>>>> I'd really prefer this be left out for now. It's a massive can of worms.
>>>>>> Let's agree on something that works and has well-defined behavior before
>>>>>> we go breaking it on purpose.
>>>>>
>>>>> May I ask what the big concern here is?
>>>>
>>>> It's not a _big_ concern.
>>>
>>> Oh, I read "can of worms" and thought there is something seriously problematic :)
>>>
>>>> I just think we want to start on something
>>>> like this as simple, secure, and deterministic as possible.
>>>
>>> Yes, I agree. And it should be the default. Less secure would have to be opt-in and documented thoroughly.
>>
>> Yes, I am definitely happy to have the 100% secure behavior be the
>> default, and the skipping of TLB flushes be an opt-in, with thorough
>> documentation!
>>
>> But I would like to include the "skip tlb flushes" option as part of
>> this patch series straight away, because as I was alluding to in the
>> commit message, with TLB flushes this is not usable for Firecracker for
>> performance reasons :(
> 
> I really don't want that option for arm64. If we're going to bother
> unmapping from the linear map, we should invalidate the TLB.

Reading "TLB flushes result in a up to 40x elongation of page faults in
guest_memfd (scaling with the number of CPU cores), or a 5x elongation
of memory population,", I can understand why one would want that 
optimization :)

@Patrick, couldn't we use fallocate() to preallocate memory and batch 
the TLB flush within such an operation?

That is, we wouldn't flush after each individual direct-map modification 
but after multiple ones part of a single operation like fallocate of a 
larger range.

Likely wouldn't make all use cases happy.

-- 
Cheers

David / dhildenb


