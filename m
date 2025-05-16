Return-Path: <kvm+bounces-46847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8164DABA240
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8A1F161202
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A15B2777FD;
	Fri, 16 May 2025 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mG7GnUsT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087D27586A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747418022; cv=none; b=lBSnIum+qFwEa4Zr3aJzyew2rTOxEfDh6lQfuxohEVkVkCz9jWlI6EKKSJqeYQMtE902rbXSmRVFwHeMCW78LTwQ/zcMX6uu0B1HVhSwDE3b+gydUkf72zfSBJ0nrRGpSZ40tEh5BTzP44YfH6xayHR/Rl60IvUcsBOvaRDiBaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747418022; c=relaxed/simple;
	bh=HJfPGu9SHo5W2l3D7Ly+k/GNEpBm/EasByT5N7ysZac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GUm2o3DGqSxwHO/jN3QVzX29FpjksRg3p1a4WY4fhhqLi+ad0AaNXkO0RDJGxvK6ph1AkjxN2kW2CTNsdkda+6iV7hXC9yYtdi8bM+gGRyXEFteY8bkVbS44PfS3ZDQ5X/cG7E+lgSK6fM40tKkU9VQAGSfz8TjJQAGv/q/HOV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mG7GnUsT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7429fc0bfc8so1527548b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747418019; x=1748022819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8cF3oG0ZvlxQApliLAWy8AhC33oXxmPcmw1u1Vqb2bU=;
        b=mG7GnUsToXtW+YWIzm9HwjARtlPmALFGp58UoOIWR0XDUiiAvVPhQVDeA+s7gtJTQn
         6o9VMxY9vH5/EpB+pO706VumTrw9OXc8LkCIIctGmugQAoHgY9cONBTcArwYbHOh92Ow
         T8BZVX2yElEuKOZ/LCn3bQvVH2YXE3ZMMU4XuBlzjUxnpD7tyyjdySQWyDSsrZ+QpWcj
         tBomF7OU+NTx1YL27Dy0Az32h9G2XNjgFRSgDoGkyw1Sv4zGtXW9tw7V5IpfC+dq5jqU
         VTVwxLroNSRm8r7H92pGqdQfh4KIQ/uKmRMu2NJSV/0yAehLPihClVF2PjtTi3/mjmsL
         ByKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747418019; x=1748022819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cF3oG0ZvlxQApliLAWy8AhC33oXxmPcmw1u1Vqb2bU=;
        b=VbOV4HVVZedgFU/mrdco4rSTWaJM/fv2/6FxD+xcPHlRoZ5bMZBYoQJvo/4BKgwYv2
         CxhL7udfWBJM9fpHR+8hbHuW2119eWFBd7fOvvaxTm4Jj1qibjlCxL4iHf+FLEnEJ6yE
         IYW8+cqahX2/1dcwxmN/SwlpE4XMoXxUFGR82Hy9yv/UL7CTcRTvH3t6IQSUOgF4t4GZ
         BGfRhAGYvomyM+yoIKvrnml8DAXYF47GERv1zDiTtNnqckEzoOSQsA7seGSWrnEnZLUI
         G/v+I7hpdDyTEu12zJsj2K5uOwBubGD9VgI/bPVRYE1XGqfLOTkVpS7yc40uC5Uc/1Xx
         ClEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqnCk0qPuj3i0JslaIyo+U0jws5Xk8vuol0k1ESTFpBuXZW7Qpci6d0V6Es1hbTmqPmAI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmDb6cb+ST9861iRzVuKj/Ish0HHVPlhxuIigq+kKu+B8KgRlv
	dftndqi2OM0tpIT+Hm8arejtEaRTLUrxcBTabvRdQGgj23k32N3+3SNQhHMMpwhsL1cU/3xTpF1
	K6lvTewPnEduOm78ktq33x6uSlw==
X-Google-Smtp-Source: AGHT+IHTUNH+ccDKQDLHandSLB8Cs2YqxqxBQL8lX50pqIiEe34TWuIXzn9EkbeNJjz0gF0OHqoknNNeE+FoIqCs2g==
X-Received: from pfbmc24.prod.google.com ([2002:a05:6a00:7698:b0:740:b53a:e67f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d494:b0:215:eb10:9f13 with SMTP id adf61e73a8af0-2165f87269fmr5223554637.17.1747418018754;
 Fri, 16 May 2025 10:53:38 -0700 (PDT)
Date: Fri, 16 May 2025 10:53:37 -0700
In-Reply-To: <6825ff323cc63_337c39294e3@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com>
 <6825ff323cc63_337c39294e3@iweiny-mobl.notmuch>
Message-ID: <diqzjz6gfnmm.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
From: Ackerley Tng <ackerleytng@google.com>
To: Ira Weiny <ira.weiny@intel.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: aik@amd.com, ajones@ventanamicro.com, akpm@linux-foundation.org, 
	amoorthy@google.com, anthony.yznaga@oracle.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, bfoster@redhat.com, binbin.wu@linux.intel.com, 
	brauner@kernel.org, catalin.marinas@arm.com, chao.p.peng@intel.com, 
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com, 
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, graf@amazon.com, haibo1.xu@intel.com, 
	hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Ira Weiny <ira.weiny@intel.com> writes:

> Ackerley Tng wrote:
>
> [snip]
>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> 
>
> [snip]
>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 590932499eba..f802116290ce 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -30,6 +30,10 @@ enum shareability {
>>  };
>>  
>>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index);
>> +static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
>> +				      pgoff_t end);
>> +static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
>> +				    pgoff_t end);
>>  
>>  static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
>>  {
>> @@ -85,6 +89,306 @@ static struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t inde
>>  	return kvm_gmem_get_folio(inode, index);
>>  }
>>  
>> +/**
>> + * kvm_gmem_shareability_store() - Sets shareability to @value for range.
>> + *
>> + * @mt: the shareability maple tree.
>> + * @index: the range begins at this index in the inode.
>> + * @nr_pages: number of PAGE_SIZE pages in this range.
>> + * @value: the shareability value to set for this range.
>> + *
>> + * Unlike mtree_store_range(), this function also merges adjacent ranges that
>> + * have the same values as an optimization.
>
> Is this an optimization or something which will be required to convert
> from shared back to private and back to a huge page mapping?
>

This is an optimization.

> If this is purely an optimization it might be best to leave it out for now
> to get functionality first.
>

I see this (small) optimization as part of using maple trees.

Fuad's version [1] uses xarrays and has 1 xarray entry per page
offset. I wanted to illustrate that by using maple trees, we can share
just 1 entry for a whole range, and part of that sharing involves
merging adjacent shareability entries that have the same value.

IIUC, these other users of maple trees also do some kind of
expansion/range merging:

+ VMAs in vma_expand() [2]
+ regcache in regcache_maple_write() [3]

> I have more to review but wanted to ask this.
>
> Ira
>
> [snip]

[1] https://lore.kernel.org/all/20250328153133.3504118-4-tabba@google.com/
[2] https://elixir.bootlin.com/linux/v6.14.6/source/mm/vma.c#L1059
[3] https://elixir.bootlin.com/linux/v6.14.6/source/drivers/base/regmap/regcache-maple.c#L38

