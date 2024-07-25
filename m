Return-Path: <kvm+bounces-22238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B739693C37E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E25DF1C20F70
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBC419AD7D;
	Thu, 25 Jul 2024 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZ1XX2sB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0BB1EB2F
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721916261; cv=none; b=WmlDTxELAvQBgiPjK3vp2WkLvcT/zMM6GerxTMlQ1x9A/Pxkqnwnr3ELHoN4wUXk0ZZLD5PwCPrFcrjbPw1QZJYcQ4ys2v/npj0lFWgMj9u+DEQKL3S8Ra91I5cJawHTHqpzBeVLZ+85zZ5JhKfRXrM82O/Wmst/TiqAOPNI2Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721916261; c=relaxed/simple;
	bh=wnvWwTI8UI5zdt63UKG5U8bOPfbWCffgnsGbwg7FB+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6YP8HOZMVHEveg0LQNJqy5SvYeU9dbFpyt2izAs1Yq18L8lFs5ZSHYdG5f3S2ye4Q34cYKs/cFX+QmPvCAUgyj1z6PhvDz4Cw7o0+DvZ5QRGeUo8Q7TxAksadVwU8JM3CF7U6RqzAWtFDQ2UIHCEbpaof9GI7jk0vBeS/r+mm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZ1XX2sB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721916258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=saCgkOZn0HdWWcQvpvi9Ls19Rjizl57+Xq/J8ZaLQ4s=;
	b=LZ1XX2sBGTQAO2HEtxjgKRkSYvWBGegQLv7xqrQ+TEIw8bOMNk/UeSEVO9Bqq/9sJR24YB
	JxGigyt8rNKGgTR7O96uyZA9qlpZveIar+PyR+SsRZDa6CkWudaiOX86pKp9PTTChIwp/f
	Ex8aaDRVniXqcZFAaVEoyYW5WRZCO80=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-kGan9LpRNeWlrZY_YhEdWA-1; Thu, 25 Jul 2024 10:04:17 -0400
X-MC-Unique: kGan9LpRNeWlrZY_YhEdWA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-428072eb4c8so5101175e9.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721916256; x=1722521056;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=saCgkOZn0HdWWcQvpvi9Ls19Rjizl57+Xq/J8ZaLQ4s=;
        b=usaRk8CURyIeG3FVaWzJqbs9bPLLXByg5QfV1qlszY3S8S4Kfdxkz6FBmk8ATDYgNy
         18Wq3v5aM8GKkr9pYfSH14pRVvqDQnkKcJKjMtzNgG/93YiG+xPb2ZpdNApH4H3N4qtp
         tC59E8pg/re+M0/JXraBZ/zF9o4RvmoDjc59Ty6Dja0ALNL94qTMZfElW6fVCZXHJarw
         0wibrdCFYjWr2lht+hW5f+09RUaniTLwJ75dPsuJQjhEERxgYhpG6kTqbwiFmNnz2ddi
         u2FN+D43dH7gw9JYUzCjwQovRaX/ZDXsLY1vTo6cyfWxh799W1OjK3evYBAraaarxv0m
         kmIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs8lUYgdtXxTnJZD3yIfpiHKQQSPFiTUjs7Zzc2YeoYfEXTt/YvqyvA0OoOMWeVekuYPx5hGszBm+aPGorD/21zhC/
X-Gm-Message-State: AOJu0YzF7j6GaitTxHDPqUAQjEsDWJB3teCOyMlEmx2rbEQBOSVhY0Fj
	S0PEkLaBQipx4OYvBJs3HfJQ6iLydKMEQZKXZTyU3/zZsLJin6tbvVlXr8C4AwHERgvvHtWqsKf
	PDSRII/qpNDv62hT6rcV44HkE9vl1Bj0a2y7yNrDlan4N21ywkw==
X-Received: by 2002:a5d:45cf:0:b0:367:2945:4093 with SMTP id ffacd0b85a97d-36b36404e69mr1510673f8f.40.1721916255791;
        Thu, 25 Jul 2024 07:04:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwL6wrZtpBw6QykADbooPfXaToyq8nHUEXSGuRQ7THzhdQbwNo8165LXTsYIxsVMkYgkaBuA==
X-Received: by 2002:a5d:45cf:0:b0:367:2945:4093 with SMTP id ffacd0b85a97d-36b36404e69mr1510624f8f.40.1721916255277;
        Thu, 25 Jul 2024 07:04:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:2c00:5f6:3120:375a:3e4? (p200300cbc7062c0005f63120375a03e4.dip0.t-ipconnect.de. [2003:cb:c706:2c00:5f6:3120:375a:3e4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428057b6dbbsm38355795e9.44.2024.07.25.07.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 07:04:14 -0700 (PDT)
Message-ID: <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
Date: Thu, 25 Jul 2024 16:04:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Edgecombe Rick P <rick.p.edgecombe@intel.com>,
 Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>,
 Gao Chao <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> Open
> ====
> Implementing a RamDiscardManager to notify VFIO of page conversions
> causes changes in semantics: private memory is treated as discarded (or
> hot-removed) memory. This isn't aligned with the expectation of current
> RamDiscardManager users (e.g. VFIO or live migration) who really
> expect that discarded memory is hot-removed and thus can be skipped when
> the users are processing guest memory. Treating private memory as
> discarded won't work in future if VFIO or live migration needs to handle
> private memory. e.g. VFIO may need to map private memory to support
> Trusted IO and live migration for confidential VMs need to migrate
> private memory.

"VFIO may need to map private memory to support Trusted IO"

I've been told that the way we handle shared memory won't be the way 
this is going to work with guest_memfd. KVM will coordinate directly 
with VFIO or $whatever and update the IOMMU tables itself right in the 
kernel; the pages are pinned/owned by guest_memfd, so that will just 
work. So I don't consider that currently a concern. guest_memfd private 
memory is not mapped into user page tables and as it currently seems it 
never will be.

Similarly: live migration. We cannot simply migrate that memory the 
traditional way. We even have to track the dirty state differently.

So IMHO, treating both memory as discarded == don't touch it the usual 
way might actually be a feature not a bug ;)

> 
> There are two possible ways to mitigate the semantics changes.
> 1. Develop a new mechanism to notify the page conversions between
> private and shared. For example, utilize the notifier_list in QEMU. VFIO
> registers its own handler and gets notified upon page conversions. This
> is a clean approach which only touches the notifier workflow. A
> challenge is that for device hotplug, existing shared memory should be
> mapped in IOMMU. This will need additional changes.
> 
> 2. Extend the existing RamDiscardManager interface to manage not only
> the discarded/populated status of guest memory but also the
> shared/private status. RamDiscardManager users like VFIO will be
> notified with one more argument indicating what change is happening and
> can take action accordingly. It also has challenges e.g. QEMU allows
> only one RamDiscardManager, how to support virtio-mem for confidential
> VMs would be a problem. And some APIs like .is_populated() exposed by
> RamDiscardManager are meaningless to shared/private memory. So they may
> need some adjustments.

Think of all of that in terms of "shared memory is populated, private 
memory is some inaccessible stuff that needs very special way and other 
means for device assignment, live migration, etc.". Then it actually 
quite makes sense to use of RamDiscardManager (AFAIKS :) ).

> 
> Testing
> =======
> This patch series is tested based on the internal TDX KVM/QEMU tree.
> 
> To facilitate shared device assignment with the NIC, employ the legacy
> type1 VFIO with the QEMU command:
> 
> qemu-system-x86_64 [...]
>      -device vfio-pci,host=XX:XX.X
> 
> The parameter of dma_entry_limit needs to be adjusted. For example, a
> 16GB guest needs to adjust the parameter like
> vfio_iommu_type1.dma_entry_limit=4194304.

But here you note the biggest real issue I see (not related to 
RAMDiscardManager, but that we have to prepare for conversion of each 
possible private page to shared and back): we need a single IOMMU 
mapping for each 4 KiB page.

Doesn't that mean that we limit shared memory to 4194304*4096 == 16 GiB. 
Does it even scale then?


There is the alternative of having in-place private/shared conversion 
when we also let guest_memfd manage some shared memory. It has plenty of 
downsides, but for the problem at hand it would mean that we don't 
discard on shared/private conversion.

But whenever we want to convert memory shared->private we would 
similarly have to from IOMMU page tables via VFIO. (the in-place 
conversion will only be allowed if any additional references on a page 
are gone -- when it is inaccessible by userspace/kernel).

Again, if IOMMU page tables would be managed by KVM in the kernel 
without user space intervention/vfio this would work with device 
assignment just fine. But I guess it will take a while until we actually 
have that option.

-- 
Cheers,

David / dhildenb


