Return-Path: <kvm+bounces-35964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9F9A169B4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B811B1638DE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318C219F40B;
	Mon, 20 Jan 2025 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haRbdh1u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F5A189B91
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737365811; cv=none; b=jQLrYYkEumCe3HRckbj+mnVAdenjtDlyu+RW1kGQMgMMrd/uVMRBnUkva+zsrTgo59oQ/A0knktS9lCDSRJuQcwG9wc0cwCg/PFV88UQTiy+YmgBL0RmnqurP2xhYfI9s+kYeyRmf4RfJ6CKTuV3X4f7xvJnH9QbGkYWPCituB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737365811; c=relaxed/simple;
	bh=23Kf015An1Fan6/UvXAQGQ+mwej8Fwp9q6KD5aNCEA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aaAWbPUrBEw9VvWAkkV20ZhUFAtY6XclExuJelIpVjh4RwRUcEoqG1Rz5Mlu+GXnLVwVL90atCxHkUfleo9DaLBcYimLyCsCXFsRevodQA4piX3OBbik8LLwD52YVLoXD8OaJ6g1KTI/pS/afeRWlV8GanwkzbN8K8fmBAtOr7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=haRbdh1u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737365808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ldmgrsMiqHT+HGEQTFsUnj3a6/bVnZQe/bjJTNIQxGw=;
	b=haRbdh1u5GWegrMy9ylN1U1V+LYwqT8wQw9SqBNhNsU4I/CAMmwPLtBEqSKOwkR+RqMepG
	FbF2NbhaTSJqFcWFU+a12eWnPy7APCJIIEfj3FRe3FlUhX8ZQnTe/4oS/d72Pw8e86FLDA
	+bzJqENUfHi/Rj5KtHryN62HRCUiIpo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-XLtVO7ejOz68PLV7FMkz9w-1; Mon, 20 Jan 2025 04:36:46 -0500
X-MC-Unique: XLtVO7ejOz68PLV7FMkz9w-1
X-Mimecast-MFC-AGG-ID: XLtVO7ejOz68PLV7FMkz9w
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385d52591d6so1754027f8f.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737365806; x=1737970606;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ldmgrsMiqHT+HGEQTFsUnj3a6/bVnZQe/bjJTNIQxGw=;
        b=MljrDtR6Z/6VJ19u/kTJHL1kTYb6mHO40kXo+TagYtfuszmcXKSfAV6n/Gv/LVkY7X
         zRGTvXlQj2UBSfkFh5rlG0sHZzFJls+sp0Q6JctE9eVB6yhw1fsdTVo7OkLNOolBINhL
         daWyt3otQMhvKQhEodDRHbYrYkfJoSA3Sz0qlDh6aqGHnE/Y6pDNw5aCC5LurCZcL41y
         z44miSngcHSIN/3Aw7pXaHJ2loZKHLQcdK0AShzMwoF+pcCV9rcj4Ubd7tBBKa6NtrNN
         rt9nh9EC2H0tsrt17xTx7jAILvGQEzWmYeQhEI6galWtFZst7erlO7P0VQ414lSLRSJB
         rAJA==
X-Gm-Message-State: AOJu0Yx5hErHbc1jEdvevXQZeGzt07pqJv2nbreZ+qdlFOJZeGga59vt
	om2eP2K1BCEGh5LVAydOHAX/5CeVenKl/LlAp+zGPJ36cy1B/oDBKMAAhtZu+LKMIPJ/0I/5cqz
	mbM0MS+Cp/HrsN5VhFh4iD3DG3EnOwemFzcv3Xfv4evzZZmC26w==
X-Gm-Gg: ASbGncugCXxv8HSkwxLY6v7fFu5ylj/Klpl4h94US2JYEGxpMSGG84G0MIsFGYCiBVS
	Od0HijAFw9gwasx/TfiGH8k5NCjRz9Xyw/hmdc2exxsnfcoYKkznNIRBV4+cAPkV+60u2ic1vfw
	kbNwu7PO7jQztHhZuk6yHA9+IiKGDUu/mVye4tL+AVqPHL5y+GJKdRG54m9IRNZBcS1/J5wHCAF
	QuSQkwOd+I5xH0/9U5UiA6q6DctX89cEJjyxd+gjzsV5hR+Q769d00QjzkZCTnBweXJTmcqoWHP
	j2aRlli3eD5xwmAd9EfnZEiEZC4d/xEzkrENH+47mDgBrbSLenSi2vcy1/3lCZpzyV/OY7iWhqq
	E76RsUsG2vPNrWBzmthfskg==
X-Received: by 2002:a05:6000:1869:b0:38a:5d7d:4bd6 with SMTP id ffacd0b85a97d-38bf5b0aa37mr12039383f8f.25.1737365805668;
        Mon, 20 Jan 2025 01:36:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0E9CUT29svEJmXx/7AZEXIsb6reL3Fit+w065iTZ35U5QvjnXudB5eErXd1/HETWI9txW6Q==
X-Received: by 2002:a05:6000:1869:b0:38a:5d7d:4bd6 with SMTP id ffacd0b85a97d-38bf5b0aa37mr12039345f8f.25.1737365805208;
        Mon, 20 Jan 2025 01:36:45 -0800 (PST)
Received: from ?IPV6:2003:d8:2f22:1000:d72d:fd5f:4118:c70b? (p200300d82f221000d72dfd5f4118c70b.dip0.t-ipconnect.de. [2003:d8:2f22:1000:d72d:fd5f:4118:c70b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf327df79sm10028340f8f.91.2025.01.20.01.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:36:44 -0800 (PST)
Message-ID: <ef53e99b-862d-4285-b86b-908fd60070c3@redhat.com>
Date: Mon, 20 Jan 2025 10:36:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
To: Vlastimil Babka <vbabka@suse.cz>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <CA+EHjTzcx=eXSERSANMByhcgRRAbUL3kPAYkeu-uUgd0nPBPPA@mail.gmail.com>
 <diqzh65zzjc9.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwXqUHoEp8oqiNDcWqXxCBLHU1+jAdEN8J-pHZjxKnM+A@mail.gmail.com>
 <e49e3e78-1fb9-44b8-af11-69f7c39f5820@suse.cz>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e49e3e78-1fb9-44b8-af11-69f7c39f5820@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.01.25 10:26, Vlastimil Babka wrote:
> On 1/16/25 10:19, Fuad Tabba wrote:
>> Hi Ackerley,
>>
>> On Thu, 16 Jan 2025 at 00:35, Ackerley Tng <ackerleytng@google.com> wrote:
>>>
>>> Registration of the folio_put() callback only happens if the VMM
>>> actually tries to do vcpu_run(). For 4K folios I think this is okay
>>> since the 4K folio can be freed via the transition state K -> state I,
>>> but for hugetlb folios that have been split for sharing with userspace,
>>> not getting a folio_put() callback means never putting the hugetlb folio
>>> together. Hence, relying on vcpu_run() to add the folio_put() callback
>>> leaves a way that hugetlb pages can be removed from the system.
>>>
>>> I think we should try and find a path forward that works for both 4K and
>>> hugetlb folios.
>>
>> I agree, this could be an issue, but we could find other ways to
>> trigger the callback for huge folios. The important thing I was trying
>> to get to is how to have the callback and be able to register it.
>>
>>> IIUC page._mapcount and page.page_type works as a union because
>>> page_type is only set for page types that are never mapped to userspace,
>>> like PGTY_slab, PGTY_offline, etc.
>>
>> In the last guest_memfd sync, David Hildenbrand mentioned that that
>> would be a temporary restriction since the two structures would
>> eventually be decoupled, work being done by Matthew Wilcox I believe.
> 
> Note the "temporary" might be few years still, it's a long-term project.

Right, nobody knows how long it will actually take. Willy thinks the 
part that would be required here might be feasible in the nearer future: 
"'d like to lay out some goals for the coming year. I think we can 
accomplish a big goal this year" [1]

[1] https://lore.kernel.org/all/Z37pxbkHPbLYnDKn@casper.infradead.org/T/#u

-- 
Cheers,

David / dhildenb


