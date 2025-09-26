Return-Path: <kvm+bounces-58856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA08BA3163
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87B617A77E8
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 09:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D0429ACD8;
	Fri, 26 Sep 2025 09:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bocV8BtD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811142848A0
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758878090; cv=none; b=d4FWZ3GUVgwY4e73TpVgwJUQjdZhya0JYhiajuBkKbi7GxpIvliHAeUrf9+TfTNCWbiM1b9VDf1sn4AXz3UrPAA8sJ1+txSz9eEaI+E7f7GXo2Gg5VRW1OoVo4iJHxHHNcCJPCBKMtm/Z93/DnEgLEtxAZBSApXMzrBy74K7d8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758878090; c=relaxed/simple;
	bh=JN5UOjmwCjSWTIKExKcOZm8/p1QSiZU0RREtd47LKHE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=aurcHdVPUvAvvpLMZ3y61EEkG+J/fPOuHJ/ZWZCNbArVTchumIRUfp8CG43KlCu4s73EUnuGArWYX82Lz528/HKyNYvufM3epspP6t/70mVwsPicNCmx/Yp9/t1/MH2sXPcSj/Wn4dBNNDTaU++0OBkRZcdfrRSSrymw+6FkGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bocV8BtD; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-272ed8c106eso13444965ad.2
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 02:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758878088; x=1759482888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xzlecSBlGNy5Hb7DuTGlXytPmBFktseBO6e58xwE2NU=;
        b=bocV8BtDjVbArEnht0kkGNFV30VS1S8O9gk6DTTmJu8KNksSxE1Mu2Jm2nlwvOX7pf
         z7oxApv8G+UqkrU45im+74MRECGMx3ayI2zagbK+vE2HlmkkHhB82kLvIt66Vk+OZsw1
         Iu2jKi0++jd0De6C2Cyc4Tt2tviqYFF5BhONuZG1dFRjGpMq4S3k9mp3AwcLzPPiyfGR
         KrRPiESOGRbDrQ6TBJzdENN7Czrop5Q3g9ZcOlSsNfP7BxiwBB4BiPEl/FVV9cM9aENo
         WMtLM5ieZybLxgrHX9TxX10WDYAIbc16HbvsY1RtBRnbWqgUI/fDwPiWW1523mYL6Acm
         ZCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758878088; x=1759482888;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xzlecSBlGNy5Hb7DuTGlXytPmBFktseBO6e58xwE2NU=;
        b=jCeTkqSfd2EptX7ceaBmcgqrLHNqO2guHM9zxhPRuvnzk156wlE/97PfP0Xls9hP8y
         U9P6TLlbJbh2hZbxCVYr0uf9dTZwQooaYAwlH6tvUFwYvVmRMPSb7f2amy7XZpy8ldXP
         Ss+W3Zet8JwIpsysLKLnzvSRpErY+YmXtEwU3i6NUXSw2qGJJ0976HbQRENrjJh5Uwvm
         kzSHsZiR6Z0NC+cyqyWogLGWzw4129HFHhmToINcQgcWwVbxca2GU+V1jXGCFrZ/bR87
         Fr3oOEsJIqec3/Gd2BEelfDYdSRDuzzsW0JJ7vD177KhdQFJGkaIMc2wPNILRHc/d5ZF
         thTw==
X-Gm-Message-State: AOJu0YzgKSXHSywBIEJZ33svyyIS1QLZaHvoKkH8Da9Evd5O/MHbveXl
	bBlClWUkceVoj6HeprYl20FxT/c3PAHeMZM3dJ88fZMSPx65f7cMaXEzRXxQ5ebDMv7UsenRt9z
	aMhkjvKSHbOt7rs60L9z0rfOOTA==
X-Google-Smtp-Source: AGHT+IEx8E9cWhlfu1Vxq2AQuNomZgiEGJpm7W9AMx7sfDI2/uhsc96oawFywv4yb5EYZvdHJHPDXZqYAh60qO9vkw==
X-Received: from plxq5.prod.google.com ([2002:a17:902:dac5:b0:268:eb:3b3b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef09:b0:276:76e1:2e84 with SMTP id d9443c01a7336-27ed4a06b49mr70346315ad.3.1758878087498;
 Fri, 26 Sep 2025 02:14:47 -0700 (PDT)
Date: Fri, 26 Sep 2025 09:14:45 +0000
In-Reply-To: <aDfT35EsYP/Byf7Z@yzhao56-desk.sh.intel.com> (message from Yan
 Zhao on Thu, 29 May 2025 11:26:23 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzcy7d60e2.fsf@google.com>
Subject: Re: [RFC PATCH v2 39/51] KVM: guest_memfd: Merge and truncate on fallocate(PUNCH_HOLE)
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
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
	xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, May 28, 2025 at 09:39:35AM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> > On Wed, May 14, 2025 at 04:42:18PM -0700, Ackerley Tng wrote:
>> >> Merge and truncate on fallocate(PUNCH_HOLE), but if the file is being
>> >> closed, defer merging to folio_put() callback.
>> >> 
>> >> Change-Id: Iae26987756e70c83f3b121edbc0ed0bc105eec0d
>> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> >> ---
>> >>  virt/kvm/guest_memfd.c | 76 +++++++++++++++++++++++++++++++++++++-----
>> >>  1 file changed, 68 insertions(+), 8 deletions(-)
>> >> 
>> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> >> index cb426c1dfef8..04b1513c2998 100644
>> >> --- a/virt/kvm/guest_memfd.c
>> >> +++ b/virt/kvm/guest_memfd.c
>> >> @@ -859,6 +859,35 @@ static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
>> >>  	return ret;
>> >>  }
>> >>  
>> >> +static long kvm_gmem_merge_truncate_indices(struct inode *inode, pgoff_t index,
>> >> +					   size_t nr_pages)
>> >> +{
>> >> +	struct folio *f;
>> >> +	pgoff_t unused;
>> >> +	long num_freed;
>> >> +
>> >> +	unmap_mapping_pages(inode->i_mapping, index, nr_pages, false);
>> >> +
>> >> +	if (!kvm_gmem_has_safe_refcount(inode->i_mapping, index, nr_pages, &unused))
>> 
>> Yan, thank you for your reviews!
>> 

Thanks again for your reviews. I would like to respond to this since I'm
finally getting back to this part.

>> > Why is kvm_gmem_has_safe_refcount() checked here, but not in
>> > kvm_gmem_zero_range() within kvm_gmem_truncate_inode_range() in patch 33?
>> >
>> 
>> The contract for guest_memfd with HugeTLB pages is that if holes are
>> punched in any ranges less than a full huge page, no pages are removed
>> from the filemap. Those ranges are only zeroed.
>> 
>> In kvm_gmem_zero_range(), we never remove any folios, and so there is no
>> need to merge. If there's no need to merge, then we don't need to check
>> for a safe refcount, and can just proceed to zero.
> However, if there are still extra ref count to a shared page, its content will
> be zeroed out.
>

I believe this topic is kind of overtaken by events. IIUC the current
upstream stance is that for guest_memfd we're not allowing hole-punching
of pages for huge pages, so once a HugeTLB guest_memfd is requested,
hole punching of less than the requested HugeTLB size will result in
-EINVAL being returned to userspace.

>> 
>> kvm_gmem_merge_truncate_indices() is only used during hole punching and
>> not when the file is closed. Hole punch vs file closure is checked using
>> mapping_exiting(inode->i_mapping).
>> 
>> During a hole punch, we will only allow truncation if there are no
>> unexpected refcounts on any subpages, hence this
>> kvm_gmem_has_safe_refcount() check.
> Hmm, I couldn't find a similar refcount check in hugetlbfs_punch_hole().
> Did I overlook it?
>
> So, why does guest_memfd require this check when punching a hole?
>

There's no equivalent check in HugeTLBfs.

For guest_memfd, we want to defer merging to the kernel worker as little
as possible, hence we want to merge before truncating. Checking for
elevated refcounts is a prerequisite for merging, not directly for hole
punching.

>> >> +		return -EAGAIN;
>> >> +
>> >
>> > Rather than merging the folios, could we simply call kvm_gmem_truncate_indices()
>> > instead?
>> >
>> > num_freed = kvm_gmem_truncate_indices(inode->i_mapping, index, nr_pages);
>> > return num_freed;
>> >
>> 
>> We could do this too, but then that would be deferring the huge page
>> merging to the folio_put() callback and eventually the kernel worker
>> thread.
> With deferring the huge page merging to folio_put(), a benefit is that
> __kvm_gmem_filemap_add_folio() can be saved for the merged folio. This function
> is possible to fail and is unnecessary for punch hole as the folio will be
> removed immediately from the filemap in truncate_inode_folio().
>
>

That is a good point! Definitely sounds good to defer this to folio_put().

>> My goal here is to try to not to defer merging and freeing as much as
>> possible so that most of the page/memory operations are
>> synchronous, because synchronous operations are more predictable.
>> 
>> As an example of improving predictability, in one of the selftests, I do
>> a hole punch and then try to allocate again. Because the merging and
>> freeing of the HugeTLB page sometimes takes too long, the allocation
>> sometimes fails: the guest_memfd's subpool hadn't yet received the freed
>> page back. With a synchronous truncation, the truncation may take
>> longer, but the selftest predictably passes.
> Maybe check if guestmem_hugetlb_handle_folio_put() is invoked in the
> interrupt context, and, if not, invoke the guestmem_hugetlb_cleanup_folio()
> synchronously?
>
>

I think this is a good idea. I would like to pursue this in a future
revision of a patch series.

It seems like the use of in_atomic() is strongly discouraged, do you
have any tips on how to determine if folio_put() is being called from
atomic context?

>> 
>> [...snip...]
>> 

