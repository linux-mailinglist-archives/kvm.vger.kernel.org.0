Return-Path: <kvm+bounces-34214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7149F9167
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 12:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DD5E16C1C7
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 11:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9761BD00A;
	Fri, 20 Dec 2024 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xijkpdxh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274F41C232D
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734694294; cv=none; b=NQsopBRnKGQmhqp9Y+0dteLhkKYlG+IfSLzo41C/gDp8jgT+we9OBVjpwwjsrZLVWOYvCuB+H2CrZ+d6Cxn0BPi25JYgX/R0f31qWmCeZ9B3KfOhSNP7ICQtXF2asUtKpj0FvW++UrpsAX5S/ngs+3ZdlowMDEZcJd4zqNU73Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734694294; c=relaxed/simple;
	bh=C+aMtK6U56/hye4enDalblPwM+gYpyUbWCtFiLj8XWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URDrddu2cg8Wxgyt187IR0hebt2GZveQDOp9Rdlha/HiznyNmC7gQ6U3hUl7+gJi1j+MyZ3dXCjo3xcLwSpsq92hWNvOPzxp3gc8joMX0HMfenBMA/YCzeWzN/wQM6HVIIJPHzvyfqtKGbuLZQJcwV7jU9cEV3fFhD4qu9JRN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xijkpdxh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734694291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qbRIsTIMECERPEPKHhHKtMdpQYdvE+CKuw6BVTfBEVk=;
	b=Xijkpdxh8mMXYcKNx2UGD0I0puyZtUZjSnnc+aQXtciR7dRV3oV1esdVs2/j5zqh7y+9jB
	WAMpT+yrUBghOOK1hjqqyf5gbanSuqW1OsNZCSwEtSyiHCifp37lFCNjAObHThJsOJASCD
	7eREJfjs+lOGup8HjwYh2wgF71HVTNE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-tz0G10A8MGO6LlGba8lcBw-1; Fri, 20 Dec 2024 06:31:29 -0500
X-MC-Unique: tz0G10A8MGO6LlGba8lcBw-1
X-Mimecast-MFC-AGG-ID: tz0G10A8MGO6LlGba8lcBw
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38639b4f19cso1230294f8f.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 03:31:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734694288; x=1735299088;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qbRIsTIMECERPEPKHhHKtMdpQYdvE+CKuw6BVTfBEVk=;
        b=pqsPBnQc7uvvzgzwJ69By4nopzikXx5fTcCZgw78JXF2bRlndj+9FJwQ6YJCtK+rXA
         IfqdH2opSfDSoCsc86t2hlLsryKtHuIB+6OyF0dY/TgoRvQ00D4fvjq/OH8ucVE7zEH/
         /pzbkghxVs3XvWICEi4+rzjqIC9EpRbrZfps4yoHho2fHekTA5IbhOS34vSxoWBiEILU
         a4jJ7tbch8joWKh4DayOve+E5n99KGUxDBHoC4M8lJ33nz+3K1uRXgQ8tLAWdkd/rA2q
         op2iBh9icrr1I5pXdLIzvjfdvPxe5tQpvUcmH44PiRKNCL+gZc+o+Y38Hb9V3B5/Uijt
         eNMw==
X-Forwarded-Encrypted: i=1; AJvYcCUH+pLfVMSQAYpVMaYSx6iYifujgHTh0vABUds7zoO65ZyKU3xdaHmaNAGefZh3fupdANk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRCgQOA0Uz69pr0XK7DYuGFKPJGh6Q1Wm6IrxjOkp4jGz9yNtL
	Ji4aVSdKnDhCVklWcDZPXypujTDDl4fjNem1gGDXX8Ho5IJaPaRnGhF19AyDelQSxJyTpaMXGVD
	RgKt4pO1jjrfviwPrjHSScSWPBkBcIEXJVafBsz0aVVjLC8Ur8A==
X-Gm-Gg: ASbGncs/nnZiZMDVbYGTLhjLTHxyj7ELEPCyr3pkxWfz9rbEnbl9x5Y9lM7P/JKAuFv
	ctmdc68iBD0y9bpFAGca77H8c4kQceotKQeQ70R19fZtiRcXAKgpwmkevYXNXiBduPanHW+M89s
	FxHI0z89Tw5Wk7Pva5myzrsiPn6UoutkHrYQOQuTp6BKfyn1EOdbKEN4wdb+VCb02XW4nE04Odk
	aUFU/bNzpDsknu554awKpKOWbjdQ87txO6S2a2S7cu5qsBcqVlFQytrt8UfkQDcOZqimLPSl4Je
	qn5AAplviC5RhDGM0hULH3agTGFHw1DF1IUrwHiFhlk1npNipsn2a0ug5J+Vv0tsnpsgFku0UwO
	QPUGe4uyk
X-Received: by 2002:a5d:6d84:0:b0:382:46ea:113f with SMTP id ffacd0b85a97d-38a221e2799mr2602278f8f.10.1734694288574;
        Fri, 20 Dec 2024 03:31:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHoRYR/1VwIi7QfakSFo/NWyJACrPP012uFQXWIOTcWd1FRqXLOVCIk0Ucp7JGYdhAwdz3wzA==
X-Received: by 2002:a5d:6d84:0:b0:382:46ea:113f with SMTP id ffacd0b85a97d-38a221e2799mr2602225f8f.10.1734694288115;
        Fri, 20 Dec 2024 03:31:28 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:9d00:edd9:835b:4bfb:2ce3? (p200300cbc7089d00edd9835b4bfb2ce3.dip0.t-ipconnect.de. [2003:cb:c708:9d00:edd9:835b:4bfb:2ce3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c847714sm3862810f8f.54.2024.12.20.03.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 03:31:26 -0800 (PST)
Message-ID: <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
Date: Fri, 20 Dec 2024 12:31:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jroedel@suse.de, thomas.lendacky@amd.com,
 pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com,
 pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com,
 vannapurve@google.com, ackerleytng@google.com, quic_eberman@quicinc.com
References: <20241212063635.712877-1-michael.roth@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241212063635.712877-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.12.24 07:36, Michael Roth wrote:
> This patchset is also available at:
> 
>    https://github.com/amdese/linux/commits/snp-prepare-thp-rfc1
> 
> and is based on top of Paolo's kvm-coco-queue-2024-11 tag which includes
> a snapshot of his patches[1] to provide tracking of whether or not
> sub-pages of a huge folio need to have kvm_arch_gmem_prepare() hooks issued
> before guest access:
> 
>    d55475f23cea KVM: gmem: track preparedness a page at a time
>    64b46ca6cd6d KVM: gmem: limit hole-punching to ranges within the file
>    17df70a5ea65 KVM: gmem: add a complete set of functions to query page preparedness
>    e3449f6841ef KVM: gmem: allocate private data for the gmem inode
> 
>    [1] https://lore.kernel.org/lkml/20241108155056.332412-1-pbonzini@redhat.com/
> 
> This series addresses some of the pending review comments for those patches
> (feel free to squash/rework as-needed), and implements a first real user in
> the form of a reworked version of Sean's original 2MB THP support for gmem.
> 
> It is still a bit up in the air as to whether or not gmem should support
> THP at all rather than moving straight to 2MB/1GB hugepages in the form of
> something like HugeTLB folios[2] or the lower-level PFN range allocator
> presented by Yu Zhao during the guest_memfd call last week. The main
> arguments against THP, as I understand it, is that THPs will become
> split over time due to hole-punching and rarely have an opportunity to get
> rebuilt due to lack of memory migration support for current CoCo hypervisor
> implementations like SNP (and adding the migration support to resolve that
> not necessarily resulting in a net-gain performance-wise). The current
> plan for SNP, as discussed during the first guest_memfd call, is to
> implement something similar to 2MB HugeTLB, and disallow hole-punching
> at sub-2MB granularity.
> 
> However, there have also been some discussions during recent PUCK calls
> where the KVM maintainers have some still expressed some interest in pulling
> in gmem THP support in a more official capacity. The thinking there is that
> hole-punching is a userspace policy, and that it could in theory avoid
> holepunching for sub-2MB GFN ranges to avoid degradation over time.
> And if there's a desire to enforce this from the kernel-side by blocking
> sub-2MB hole-punching from the host-side, this would provide similar
> semantics/behavior to the 2MB HugeTLB-like approach above.
> 
> So maybe there is still some room for discussion about these approaches.
> 
> Outside that, there are a number of other development areas where it would
> be useful to at least have some experimental 2MB support in place so that
> those efforts can be pursued in parallel, such as the preparedness
> tracking touched on here, and exploring how that will intersect with other
> development areas like using gmem for both shared and private memory, mmap
> support, guest_memfd library, etc., so my hopes are that this approach
> could be useful for that purpose at least, even if only as an out-of-tree
> stop-gap.
> 
> Thoughts/comments welcome!

Sorry for the late reply, it's been a couple of crazy weeks, and I'm 
trying to give at least some feedback on stuff in my inbox before even 
more will pile up over Christmas :) . Let me summarize my thoughts:

THPs in Linux rely on the following principle:

(1) We try allocating a THP, if that fails we rely on khugepaged to fix
     it up later (shmem+anon). So id we cannot grab a free THP, we
     deffer it to a later point.

(2) We try to be as transparent as possible: punching a hole will
     usually destroy the THP (either immediately for shmem/pagecache or
     deferred for anon memory) to free up the now-free pages. That's
     different to hugetlb, where partial hole-punching will always zero-
     out the memory only; the partial memory will not get freed up and
     will get reused later.

     Destroying a THP for shmem/pagecache only works if there are no
     unexpected page references, so there can be cases where we fail to
     free up memory. For the pagecache that's not really
     an issue, because memory reclaim will fix that up at some point. For
     shmem, there  were discussions to do scan for 0ed pages and free
     them up during memory reclaim, just like we do now for anon memory
      as well.

(3) Memory compaction is vital for guaranteeing that we will be able to
     create THPs the longer the system was running,


With guest_memfd we cannot rely on any daemon to fix it up as in (1) for 
us later (would require page memory migration support).

We use truncate_inode_pages_range(), which will split a THP into small 
pages if you partially punch-hole it, so (2) would apply; splitting 
might fail as well in some cases if there are unexpected references.

I wonder what would happen if user space would punch a hole in private 
memory, making truncate_inode_pages_range() overwrite it with 0s if 
splitting the THP failed (memory write to private pages under TDX?). 
Maybe something similar would happen if a private page would get 0-ed 
out when freeing+reallocating it, not sure how that is handled.


guest_memfd currently actively works against (3) as soon as we (A) 
fallback to allocating small pages or (B) split a THP due to hole 
punching, as the remaining fragments cannot get reassembled anymore.

I assume there is some truth to "hole-punching is a userspace policy", 
but this mechanism will actively work against itself as soon as you 
start falling back to small pages in any way.



So I'm wondering if a better start would be to (A) always allocate huge 
pages from the buddy (no fallback) and (B) partial punches are either 
disallowed or only zero-out the memory. But even a sequence of partial 
punches that cover the whole huge page will not end up freeing all parts 
if splitting failed at some point, which I quite dislike ...

But then we'd need memory preallocation, and I suspect to make this 
really useful -- just like with 2M/1G "hugetlb" support -- in-place 
shared<->private conversion will be a requirement. ... at which point 
we'd have reached the state where it's almost the 2M hugetlb support.


This is not a very strong push back, more a "this does not quite sound 
right to me" and I have the feeling that this might get in the way of 
in-place shared<->private conversion; I might be wrong about the latter 
though.

With memory compaction working for guest_memfd, it would all be easier.

Note that I'm not quite sure about the "2MB" interface, should it be a 
"PMD-size" interface?

-- 
Cheers,

David / dhildenb


