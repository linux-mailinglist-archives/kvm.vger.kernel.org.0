Return-Path: <kvm+bounces-9778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 360CE866F7F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFDBE2883DC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD34A55C24;
	Mon, 26 Feb 2024 09:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2QeC9x/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240855C04
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708939700; cv=none; b=iGMt9pnVD/bQhlVjfMcxYB4qAeQ/zI5FSARKzljJ5myZCGSA7zv6/ziZ1L0vp7QrYJwgzt8YR+TUXYjuplE72+JK07ci71GUdbiRSb1sSgtOdSrB6PkSGglglnvuH+w2VBsveAWffLQV6e9adggIUnoWg4FU+jg/y82MW9525R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708939700; c=relaxed/simple;
	bh=2UJIICXGQwE2B22UfRJ8DMjaxvDTs17KAmtNi8diLOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TlUs3ixAneC5J9L7FKhVeDY8nvtzdywL+kB7tAdGCoY58Hm+EacL/MivID/Rkj8f2mMgQl4BZCnVUfYUREDSm1iLFSKiJeBYT0HuqODgn1OePHZdLFL1cU5SfiCLhNibm5Yh/VXU6mVDLnDP2etVGcKWnrU23pUrfz5ZS29VpdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z2QeC9x/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708939698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=elcx7WkZMgK/pgWvuMLbbcWcSNmmuLeWieK7NCgmQ2k=;
	b=Z2QeC9x/qPrT3nw3f/qR1lvOb9OubyHEHPt515Ylqa407i3Vt5ukvynu88lBKhQ9J0kdLC
	wxuHKiLnaaawjHRYhpUt1MYCA2isSMAo/rQp0GvW64Ilb2xUsobAZDRqW7xuQacP7xh3q1
	5fBWDYaUxzwkQ9QtVt1cROSMb2FRWX4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-vREyEIR9P1yEKytwjCNxSg-1; Mon, 26 Feb 2024 04:28:15 -0500
X-MC-Unique: vREyEIR9P1yEKytwjCNxSg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d308b0c76so1048752f8f.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 01:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708939695; x=1709544495;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elcx7WkZMgK/pgWvuMLbbcWcSNmmuLeWieK7NCgmQ2k=;
        b=VAr4K7wZEkamRyPyLUvNCdy6CPoyO04B6xY58glHeej/FtWIgc9wQoTNGQ3+ltGyRp
         6G54JZcCG0cR97hyuc+kB00ITj3QCm0Q6ziHCNy93F3mx40pPP+hcI9ChZI05oeVR9J8
         Bhm9s0sqnLFBeNcqI2OBuQreDTy4IrKdr5J04LoyCt8mZIaNTKJR6cmRLrI8oRhyep0w
         IqQn1+sT2mqPiDzNNl8PjTzEm7Z49aI1RtSL+o3ziZJcQRX+19NpGq4bj1COmvY7sYrV
         F2E9szUduRSwizDrmexb3rXZVyJmnLHlw2OgEp6aukhSc0b3tOAJXiDHj/YP7e8sjSHj
         s18A==
X-Forwarded-Encrypted: i=1; AJvYcCX1/gQcjPvyu/YjNOFy3xLp2lBt10oOY99ZxKcOMVi3sxQao7UD/m40RfN19sKdoKiCvbGuwHt6kif6ImvGCQaXzz3S
X-Gm-Message-State: AOJu0Yx63s8IgrjiRjh7XX8GPA5H0TtDn2itAb/F4l9rKPJd8dCbHZK6
	UYeI0NeZWfSKFab3gse+o49qS+pTsYVVnlSeu3vtYp2d9D6xUTdsFucnEkuWeR7Z9v/QGndWpwW
	9QqgsuEfK7aSyh22SJB5+KrU1kQSg6jk5LCOAmJF0B3MgmIWX/g==
X-Received: by 2002:adf:ce10:0:b0:33d:7682:49a8 with SMTP id p16-20020adfce10000000b0033d768249a8mr510148wrn.16.1708939694789;
        Mon, 26 Feb 2024 01:28:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4a5T0Zoi8hkU+OsZjGTBg4h4fN9HQzhA4VF3wIMNATDVEDz7OFGwNyVJlS8LXyMtws34Eiw==
X-Received: by 2002:adf:ce10:0:b0:33d:7682:49a8 with SMTP id p16-20020adfce10000000b0033d768249a8mr510100wrn.16.1708939694378;
        Mon, 26 Feb 2024 01:28:14 -0800 (PST)
Received: from ?IPV6:2003:cb:c72f:f700:104b:9184:1b45:1898? (p200300cbc72ff700104b91841b451898.dip0.t-ipconnect.de. [2003:cb:c72f:f700:104b:9184:1b45:1898])
        by smtp.gmail.com with ESMTPSA id m17-20020adff391000000b0033da1c4c29csm7641215wro.91.2024.02.26.01.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 01:28:13 -0800 (PST)
Message-ID: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
Date: Mon, 26 Feb 2024 10:28:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
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
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
Cc: linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZdfoR3nCEP3HTtm1@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.02.24 01:35, Matthew Wilcox wrote:
> On Thu, Feb 22, 2024 at 03:43:56PM -0800, Elliot Berman wrote:
>>> This creates the situation where access to successfully mmap()'d
>>> memory might SIGBUS at page fault. There is precedence for
>>> similar behavior in the kernel I believe, with MADV_HWPOISON and
>>> the hugetlbfs cgroups controller, which could SIGBUS at page
>>> fault time depending on the accounting limit.
>>
>> I added a test: folio_mmapped() [1] which checks if there's a vma
>> covering the corresponding offset into the guest_memfd. I use this
>> test before trying to make page private to guest and I've been able to
>> ensure that userspace can't even mmap() private guest memory. If I try
>> to make memory private, I can test that it's not mmapped and not allow
>> memory to become private. In my testing so far, this is enough to
>> prevent SIGBUS from happening.
>>
>> This test probably should be moved outside Gunyah specific code, and was
>> looking for maintainer to suggest the right home for it :)
>>
>> [1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/
> 
> You, um, might have wanted to send an email to linux-mm, not bury it in
> the middle of a series of 35 patches?
> 
> So this isn't folio_mapped() because you're interested if anyone _could_
> fault this page, not whether the folio is currently present in anyone's
> page tables.
> 
> It's like walk_page_mapping() but with a trivial mm_walk_ops; not sure
> it's worth the effort to use walk_page_mapping(), but I would defer to
> David.

First, I suspect we are not only concerned about current+future VMAs 
covering the page, we are also interested in any page pins that could 
have been derived from such a VMA?

Imagine user space mmap'ed the file, faulted in page, took a pin on the 
page using pin_user_pages() and friends, and then munmap()'ed the VMA.

You likely want to catch that as well and not allow a conversion to private?

[I assume you want to convert the page to private only if you hold all 
the folio references -- i.e., if the refcount of a small folio is 1]


Now, regarding the original question (disallow mapping the page), I see 
the following approaches:

1) SIGBUS during page fault. There are other cases that can trigger
    SIGBUS during page faults: hugetlb when we are out of free hugetlb
    pages, userfaultfd with UFFD_FEATURE_SIGBUS.

-> Simple and should get the job done.

2) folio_mmapped() + preventing new mmaps covering that folio

-> More complicated, requires an rmap walk on every conversion.

3) Disallow any mmaps of the file while any page is private

-> Likely not what you want.


Why was 1) abandoned? I looks a lot easier and harder to mess up. Why 
are you trying to avoid page faults? What's the use case?

-- 
Cheers,

David / dhildenb


