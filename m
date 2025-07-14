Return-Path: <kvm+bounces-52344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDDE2B044A9
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 17:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 341821888787
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C85125CC75;
	Mon, 14 Jul 2025 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciNU5kgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140AD258CF1
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752508022; cv=none; b=qt2xAYOD20p8ejRz4zdX8Xjq5GczIN2pZj1vSmck+yepNLIL3z5Mlpr31lAm/LyC4k8COaJjvNgaxPLnZgmvtzVteuJ/C/+H8rgTHSwJxJmxUgoNM+HWAgEuglAtYNYzoVWtGHeY/D+LloaGYFEnQS6fg9FF2kSF94zT5tkAdTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752508022; c=relaxed/simple;
	bh=HLqpQgnXCt5R5jCRQgf7gHVzF6nqzmxv52TkY/rVIdY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IXDHYkBBte8LYL3sce6Os1fjS1jp1LRvTTPltM4/ANRUgZnDN9XsK0pvJKGnYZGUwEw6LG98HNwmbouMP5bMo4imhRsDN6lIRhpokLU6WHFlGTI8UgSp3J6axzu7Ey5TwV94/UsF2GYmC9swQtsgZQrf2+jRY2RsldB+IOnfwXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciNU5kgF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3184712fd8so3617985a12.3
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752508020; x=1753112820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ip9t0x4/3FNLLNvz+wHbRbiM0nrlhqfHzpLLV/dpYr8=;
        b=ciNU5kgFGRdlaZSZH2ZyMyYSuj7KkTZkpHt2B/AmY4GbX43XG2/FKp+UcCyx3UVvR7
         d7ro/q2BBbTTRLFluKW7odfh25ai7n47RLE3jLd+rgL93ghtGZDUObhvbIzn7GmWRp5+
         l2tkxePcuLr/ZHlwRGCAzwTQEJj61dttVfyHkBo6ug3C5RyZgnCIvxcHy9xIVU73HQfO
         1UT/crhBghclljrEQMo3oUkZ5Z7zop1iIsliqcDdftdx9ZxJJ/n+iURcZK6ijVWBfWLL
         vBipx7U7Ep5bsy7gGtSF5tWfznN6pcWda6pC/Cgh57vBSxi5uEdiUy4YxsDHtlrY/41j
         gYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752508020; x=1753112820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ip9t0x4/3FNLLNvz+wHbRbiM0nrlhqfHzpLLV/dpYr8=;
        b=lGiYlT7ql5QpW2/htDauOhL2R32Q3zn5FfAecSS26arIJ3bU6uRjhmG1yIA12564m1
         5BoeOPCPrBlka2ycV+6LopPu88M9UY5MHvElGjdApd3Qwwz08awjg1uKx6qqWzFmXmzc
         gwaR5nRuuiZbQl3haUr2aMvjXGT0YLQjUZ0v2QGQlSe19HZXSTqeiRxWqhzWl5eUZk+S
         TeG+6gnkbMy4qgITwqaGp9ZF/ZU6hDey3PDvK5r3Z8BM967wD5ZosB6eyBVHp5EjJqau
         GrYXbRYZl3h1BkR8izjbKCmLk9nGKRVtSxnOeobfahnIEgeo0RDO3gzlUnlun1nQUEO/
         4jSA==
X-Forwarded-Encrypted: i=1; AJvYcCXpLwNQBGQy1zi7Jt+FX2TfVqusBQYNMmiJVtcRoeEiyhP/R2LW+xtMcBxsBqulUaYsWG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk2DuUI3fGKGA2vleJNEiEhRibpsonYliYoZyFbu9RFObjSMWs
	muaXY9UUSLv5THTMSmZPGdsV4VWDVRayjssqFTHOQScqTJ24xW2/IEGQcp5aOgbjgOTI3dg7h1V
	wJzQCFA==
X-Google-Smtp-Source: AGHT+IFY2NgFhRjN9PGIVOp9BWGAVuSX9NaJdtJo9InKm3qgjHFYFHo5G7SVt9DLtZkRBzbBwizV4byUFw8=
X-Received: from pjbpq9.prod.google.com ([2002:a17:90b:3d89:b0:311:1a09:11ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7d1:b0:311:2f5:6b1
 with SMTP id 98e67ed59e1d1-31c4ccddbd8mr21035595a91.22.1752508020404; Mon, 14
 Jul 2025 08:47:00 -0700 (PDT)
Date: Mon, 14 Jul 2025 08:46:59 -0700
In-Reply-To: <aHSgdEJpY/JF+a1f@yzhao56-desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com> <aHSgdEJpY/JF+a1f@yzhao56-desk>
Message-ID: <aHUmcxuh0a6WfiVr@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, ira.weiny@intel.com, vannapurve@google.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 14, 2025, Yan Zhao wrote:
> On Fri, Jul 11, 2025 at 08:39:59AM -0700, Sean Christopherson wrote:
> > On Fri, Jul 11, 2025, Michael Roth wrote:
> > > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > > > log:
> > > > 
> > > > Problem
> > > > ===
> > > > ...
> > > > (2)
> > > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > > > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > > > - filemap invalidation lock --> mm->mmap_lock
> > > > 
> > > > However, in future code, the shared filemap invalidation lock will be held
> > > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > > - mm->mmap_lock --> filemap invalidation lock
> > > 
> > > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).
> > 
> > Irrespective of shared faults, I think the API could do with a bit of cleanup
> > now that TDX has landed, i.e. now that we can see a bit more of the picture.
> > 
> > As is, I'm pretty sure TDX is broken with respect to hugepage support, because
> > kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever deals
> > with one page at a time.  So that needs to be changed.  I assume it's already
> In TDX RFC v1, we deals with multiple pages at a time :)
> https://lore.kernel.org/all/20250424030500.32720-1-yan.y.zhao@intel.com/
> 
> > address in one of the many upcoming series, but it still shows a flaw in the API.
> > 
> > Hoisting the retrieval of the source page outside of filemap_invalidate_lock()
> > seems pretty straightforward, and would provide consistent ABI for all vendor
> > flavors.  E.g. as is, non-struct-page memory will work for SNP, but not TDX.  The
> > obvious downside is that struct-page becomes a requirement for SNP, but that
> > 
> > The below could be tweaked to batch get_user_pages() into an array of pointers,
> > but given that both SNP and TDX can only operate on one 4KiB page at a time, and
> > that hugepage support doesn't yet exist, trying to super optimize the hugepage
> > case straightaway doesn't seem like a pressing concern.
> 
> > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > 				struct file *file, gfn_t gfn, void __user *src,
> > 				kvm_gmem_populate_cb post_populate, void *opaque)
> > {
> > 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > 	struct page *src_page = NULL;
> > 	bool is_prepared = false;
> > 	struct folio *folio;
> > 	int ret, max_order;
> > 	kvm_pfn_t pfn;
> > 
> > 	if (src) {
> > 		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
> get_user_pages_fast()?
> 
> get_user_pages() can't pass the assertion of mmap_assert_locked().

Oh, I forgot get_user_pages() requires mmap_lock to already be held.  I would
prefer to not use a fast variant, so that userspace isn't required to prefault
(and pin?) the source.

So get_user_pages_unlocked()?

> 
> > 		if (ret < 0)
> > 			return ret;
> > 		if (ret != 1)
> > 			return -ENOMEM;
> > 	}
> > 
> > 	filemap_invalidate_lock(file->f_mapping);
> > 
> > 	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> > 					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > 					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> if (kvm_mem_is_private(kvm, gfn)) ? where
> 
> static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> {
>         struct kvm_memory_slot *slot;
> 
>         if (!IS_ENABLED(CONFIG_KVM_GMEM))
>                 return false;
> 
>         slot = gfn_to_memslot(kvm, gfn);
>         if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot))
>                 return kvm_gmem_is_private(slot, gfn);
> 
>         return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> }
> 
> 
> > 		ret = -EINVAL;
> > 		goto out_unlock;
> > 	}
> > 
> > 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> GFN+1 will return is_prepared == true.

I don't see any reason to try and make the current code truly work with hugepages.
Unless I've misundertood where we stand, the correctness of hugepage support is
going to depend heavily on the implementation for preparedness.  I.e. trying to
make this all work with per-folio granulartiy just isn't possible, no?

