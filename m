Return-Path: <kvm+bounces-52179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B26B02098
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D58F4A4445
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E002ED16C;
	Fri, 11 Jul 2025 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/jMWBDZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6D12EA484
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752248402; cv=none; b=kN3tQpKTveTCbRqTSyJoVvCt6cQRJHfwynAEs5Bq5gPrldijYxAYakX/Wo1tW/1zYcpB4E01oUiVvIfzpl3zCFb+NVf2cVgeryNOZaj9G5+xcN2Xob/3rLVnXsrMvsTprXah4g4L6uSd0MiCG4sF8jrLtrFO16q/QlZVXr7KVDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752248402; c=relaxed/simple;
	bh=awESprVhew4kSmDa2kR0oS13/qs3PDd2SwyjUZfd2x8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sVF1AUOcQAlx/y0AjHVQ7JP3FbfHZxCzIXe8cqfqCB8/EhC2HuEs+0z+stQsbZ3GWAlRBmb96E7OGSBt9uGpEhvCr42wVROZK8hBsyTOIHriwK+L/V7AysdUNH/sdQgHDIqjUkpqZYhhKyJDedyWstB/Gw9w06enFSZH8aTQR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E/jMWBDZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234fedd3e51so21734965ad.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752248401; x=1752853201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fn40LpJUU3LdWkylyg01Pxkvo0K0KUfHBLAV1tZ0MCI=;
        b=E/jMWBDZjwen7wg1lh7ucJ4kpFoEnjtNTILUEQECgVqKFtPJzHqUzppdOATIK8wV79
         A0Nswm9TahTWFJol1DlFvO5BpFd9i43M4kour9H4I+EEDYPHTa3oZH3SKtDaCKpUbtj0
         DceJUTCDolGFOu71REue2C3hTV3/QkfRnpT+dj8iP8mSowTE3NgSuJfRuUW1zUhGcqIm
         58T5ZxW2WMaqG74L+Qb8+2RjIbaYzeWQHu3XvGRZp8o1JSeC6VTOMv1ykUurlt+1LmOJ
         WUbdLTZ/s3R6c0ae0Y6cGTkSl+zBr/2QDwlNvSve0UpKpdE3UBubR1b/c70+bdIOI6bo
         hprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752248401; x=1752853201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fn40LpJUU3LdWkylyg01Pxkvo0K0KUfHBLAV1tZ0MCI=;
        b=Uu2+tFdlRf/+UCgNZ1OtZttf17f9s2LeamjEawrgnoqHlwb0SKMLltZwJX95VLHMzO
         FsupaXfUhoKVcHOtDe6PDhPSQ6ojXmF+HnNpNMY0lQLpKUfMDHYTQYqOAVuedho4qgUM
         f94NQ9rRGkde9uzf3OfwH3Fzpmd3TfAYOOs9MF3mdjvz+TxR1A8SfzNBgFdqGSGKLACi
         Guod3fqb8KRQBoyLU+2mwZ3m1wgVPcENIVVEFPTSeGIdRP2lQrUDu/ZIWuGzZS/Ft6L9
         LxJ9+U3zCxusMlSKsZk0TC8FjGE2xDFmZu3757+kqnA4FMohOchcFR75RAO2tuhWHXsX
         iqtg==
X-Forwarded-Encrypted: i=1; AJvYcCW2IkfL13sXeIfao0MLVWnBKQRLBEPwowQB3+nJdeeKviFnzRf6DYRo1nlhyghbo/RquR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxBrMqj7BD5aNrjDSuwqFMYlgkjYPOVXCvfCgzVP22DsL5cIO8
	b7tFHiibbg8wJ760Pcfc8GfgpPUUP3F/l7TG548DHHQg/SemSiJfEd2Cmp4yrmAj9LTm+FAsSoz
	6Fmcbbw==
X-Google-Smtp-Source: AGHT+IE9O4C39pAH9Ofqerpd+uPD0mxUhbBaJsCEpsGxUKxvzqB4j7sPlFcbvMQYVY35N3LkUHU7f1aXv2s=
X-Received: from plblm6.prod.google.com ([2002:a17:903:2986:b0:236:9738:9180])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce07:b0:238:2990:6382
 with SMTP id d9443c01a7336-23dedbb4ademr45200695ad.0.1752248400686; Fri, 11
 Jul 2025 08:40:00 -0700 (PDT)
Date: Fri, 11 Jul 2025 08:39:59 -0700
In-Reply-To: <20250711151719.goee7eqti4xyhsqr@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk> <20250711151719.goee7eqti4xyhsqr@amd.com>
Message-ID: <aHEwT4X0RcfZzHlt@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, ira.weiny@intel.com, vannapurve@google.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Michael Roth wrote:
> On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > log:
> > 
> > Problem
> > ===
> > ...
> > (2)
> > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > - filemap invalidation lock --> mm->mmap_lock
> > 
> > However, in future code, the shared filemap invalidation lock will be held
> > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > - mm->mmap_lock --> filemap invalidation lock
> 
> I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).

Irrespective of shared faults, I think the API could do with a bit of cleanup
now that TDX has landed, i.e. now that we can see a bit more of the picture.

As is, I'm pretty sure TDX is broken with respect to hugepage support, because
kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever deals
with one page at a time.  So that needs to be changed.  I assume it's already
address in one of the many upcoming series, but it still shows a flaw in the API.

Hoisting the retrieval of the source page outside of filemap_invalidate_lock()
seems pretty straightforward, and would provide consistent ABI for all vendor
flavors.  E.g. as is, non-struct-page memory will work for SNP, but not TDX.  The
obvious downside is that struct-page becomes a requirement for SNP, but that

The below could be tweaked to batch get_user_pages() into an array of pointers,
but given that both SNP and TDX can only operate on one 4KiB page at a time, and
that hugepage support doesn't yet exist, trying to super optimize the hugepage
case straightaway doesn't seem like a pressing concern.

static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
				struct file *file, gfn_t gfn, void __user *src,
				kvm_gmem_populate_cb post_populate, void *opaque)
{
	pgoff_t index = kvm_gmem_get_index(slot, gfn);
	struct page *src_page = NULL;
	bool is_prepared = false;
	struct folio *folio;
	int ret, max_order;
	kvm_pfn_t pfn;

	if (src) {
		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
		if (ret < 0)
			return ret;
		if (ret != 1)
			return -ENOMEM;
	}

	filemap_invalidate_lock(file->f_mapping);

	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
		ret = -EINVAL;
		goto out_unlock;
	}

	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
	if (IS_ERR(folio)) {
		ret = PTR_ERR(folio);
		goto out_unlock;
	}

	folio_unlock(folio);

	if (is_prepared) {
		ret = -EEXIST;
		goto out_put_folio;
	}

	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
	if (!ret)
		kvm_gmem_mark_prepared(folio);

out_put_folio:
	folio_put(folio);
out_unlock:
	filemap_invalidate_unlock(file->f_mapping);

	if (src_page)
		put_page(src_page);
	return ret;
}

long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
		       kvm_gmem_populate_cb post_populate, void *opaque)
{
	struct file *file;
	struct kvm_memory_slot *slot;
	void __user *p;
	int ret = 0;
	long i;

	lockdep_assert_held(&kvm->slots_lock);
	if (npages < 0)
		return -EINVAL;

	slot = gfn_to_memslot(kvm, start_gfn);
	if (!kvm_slot_can_be_private(slot))
		return -EINVAL;

	file = kvm_gmem_get_file(slot);
	if (!file)
		return -EFAULT;

	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
	for (i = 0; i < npages; i ++) {
		if (signal_pending(current)) {
			ret = -EINTR;
			break;
		}

		p = src ? src + i * PAGE_SIZE : NULL;

		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, p,
					  post_populate, opaque);
		if (ret)
			break;
	}

	fput(file);
	return ret && !i ? ret : i;
}

