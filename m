Return-Path: <kvm+bounces-38617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C70A3CDAD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F6B97A7BB5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906361DE4EF;
	Wed, 19 Feb 2025 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m9ShCMhr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C6E25E467
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740008011; cv=none; b=QQ3hh14mzORUucSt1gGpPCYDalIs0awkkP4bPUljbFf/UViHn5KnX7Gi5rCjlmG2keaX8OVhwPeyLgWx28iV5KvmemIBvct3swE3Fij9dvQwOHBbVedngQpgAtBYB8C0ZkmL3C9Nbax6S4+WwA9eoLl+fn0w299+1lfIGT1w9VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740008011; c=relaxed/simple;
	bh=pxhWed/dJiJhA0/QCRcxM+HWEyI5huTedOpWQFzRbOQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nRbg5jsDDO20ny71Di5BBNOFjoPHUHdKQ1JvxMNh+rkmIV4oPh7E4coC9bRqE/WLNUW22UlQOFnA2/vgNomKgVGQkxT5kLKCjlU69fEhbPAoNRA+VFELXVdKit2pJf7CSWDMMrJk3Qxx22qgIU3ZAMOwm6XEfU7Ffi1jHc9gIYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m9ShCMhr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso629084a91.2
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 15:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740008009; x=1740612809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2DJ4izjEgjCUkVhwsanRv74q/a9BPlRBLaxGR4w5Rtg=;
        b=m9ShCMhrs0kTR33rmfuGuVPvV70SVrNNHpft8QRDIazdwIAfXr6a0PQNVmBDKgNWJ3
         vQVAMX6SERqm1X+6DsTZXodrzRGmwtDYnJGbt//OmngFktLJJh7/T8ceYChmLVAy481b
         ZHjHcry9VTYHtf679eeKZwzFOnfr9K5aJK+YIyEXQOZ171Rnk4CNslUz38vtMb//QOvT
         mFPptAfMcwphHGM6xf1CRGJsenBVbzdg3wHlInC9nQMNXN7y3+DIU0/U2sO7sXvy+amP
         pDG1SQ2WXbZkDJ0Ny3Fio1NMW7108EKZMpaLMOYia3fAKOoP7YCTluipFJu8Zd36w4lq
         cGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740008009; x=1740612809;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DJ4izjEgjCUkVhwsanRv74q/a9BPlRBLaxGR4w5Rtg=;
        b=g7iHetVXsW3cagZtVE4imF5xpsQsY5A7ZzNi7WiCUv5UC6Qb+/EOxgg5w0ufqJEr0Y
         9fWs1UNEg8Ff4dYKYg4ZMxAIRvsT9IMtgScBoIHfs4iOHLuulKRsQ7CsW0XQ1rwfxWmK
         x3yI8gD7M8H08wqSqvMHZMKAf0LG3a4kJbVL3QiLRCHcC0BHOvLOp6OUglX4lKVy2kjq
         ZButaPq18GJy7a98UYqnVHZl+jxOvVBhZOtSGMPczD3q8tfo4KDjCpcKouknMYQuTEp6
         vdyH1WkXlQ2Xk+H09suM7Ka1LmoJWcAECHjfnwN/sRx0thHN9e3Px3XnSniqkQ3Y62Nv
         wnGw==
X-Gm-Message-State: AOJu0YznzApikz0Oi3HR9jk9E4RPTQZKq3S4dgb8R3DuZEr9KBz0Q/S6
	PsBQad9+QdACPuflv+xGRENytCnYvGCypnxQF18y80exfHBTY7Hv3YMn57Culp/jwKymRxqgUV6
	d7PVzyGLT5yx/7mt6qica7Q==
X-Google-Smtp-Source: AGHT+IEA9plpwCt1DpgufppGTOelrxd9+ehj77DBbE2MXuFhuysJKOX+DxJ0fO6BC6dr9p7RYFtSnpVQNc/t6/sErQ==
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:2fb:fac8:f45b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5201:b0:2f6:dcc9:38e0 with SMTP id 98e67ed59e1d1-2fcd0b645bemr605803a91.0.1740008009352;
 Wed, 19 Feb 2025 15:33:29 -0800 (PST)
Date: Wed, 19 Feb 2025 23:33:28 +0000
In-Reply-To: <20250117163001.2326672-6-tabba@google.com> (message from Fuad
 Tabba on Fri, 17 Jan 2025 16:29:51 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzzfih8q7r.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 05/15] KVM: guest_memfd: Folio mappability states
 and functions that manage their transition
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

This question should not block merging of this series since performance
can be improved in a separate series:

> <snip>
>
> +
> +/*
> + * Marks the range [start, end) as mappable by both the host and the guest.
> + * Usually called when guest shares memory with the host.
> + */
> +static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval = xa_mk_value(KVM_GMEM_ALL_MAPPABLE);
> +	pgoff_t i;
> +	int r = 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	for (i = start; i < end; i++) {

Were any alternative data structures considered, or does anyone have
suggestions for alternatives? Doing xa_store() in a loop here will take
a long time for large ranges.

I looked into the following:

Option 1: (preferred) Maple trees

Maple tree has a nice API, though it would be better if it can combine
ranges that have the same value.

I will have to dig into performance, but I'm assuming that even large
ranges are stored in a few nodes so this would be faster than iterating
over indices in an xarray.

void explore_maple_tree(void)
{
	DEFINE_MTREE(mt);

	mt_init_flags(&mt, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);

	mtree_store_range(&mt, 0, 16, xa_mk_value(0x20), GFP_KERNEL);
	mtree_store_range(&mt, 8, 24, xa_mk_value(0x32), GFP_KERNEL);
	mtree_store_range(&mt, 5, 10, xa_mk_value(0x32), GFP_KERNEL);

	{
		void *entry;
		MA_STATE(mas, &mt, 0, 0);

		mas_for_each(&mas, entry, ULONG_MAX) {
			pr_err("[%ld, %ld]: 0x%lx\n", mas.index, mas.last, xa_to_value(entry));
		}
	}

	mtree_destroy(&mt);
}

stdout:

[0, 4]: 0x20
[5, 10]: 0x32
[11, 24]: 0x32

Option 2: Multi-index xarray

The API is more complex than maple tree's, and IIUC multi-index xarrays
are not generalizable to any range, so the range can't be 8 1G pages + 1
4K page for example. The size of the range has to be a power of 2 that
is greater than 4K.

Using multi-index xarrays would mean computing order to store
multi-index entries. This can be computed from the size of the range to
be added, but is an additional source of errors.

Option 3: Interval tree, which is built on top of red-black trees

The API is set up at a lower level. A macro is used to define interval
trees, the user has to deal with nodes in the tree directly and
separately define functions to override sub-ranges in larger ranges.

> +		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> +		if (r)
> +			break;
> +	}
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +/*
> + * Marks the range [start, end) as not mappable by the host. If the host doesn't
> + * have any references to a particular folio, then that folio is marked as
> + * mappable by the guest.
> + *
> + * However, if the host still has references to the folio, then the folio is
> + * marked and not mappable by anyone. Marking it is not mappable allows it to
> + * drain all references from the host, and to ensure that the hypervisor does
> + * not transition the folio to private, since the host still might access it.
> + *
> + * Usually called when guest unshares memory with the host.
> + */
> +static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +	void *xval_none = xa_mk_value(KVM_GMEM_NONE_MAPPABLE);
> +	pgoff_t i;
> +	int r = 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	for (i = start; i < end; i++) {
> +		struct folio *folio;
> +		int refcount = 0;
> +
> +		folio = filemap_lock_folio(inode->i_mapping, i);
> +		if (!IS_ERR(folio)) {
> +			refcount = folio_ref_count(folio);
> +		} else {
> +			r = PTR_ERR(folio);
> +			if (WARN_ON_ONCE(r != -ENOENT))
> +				break;
> +
> +			folio = NULL;
> +		}
> +
> +		/* +1 references are expected because of filemap_lock_folio(). */
> +		if (folio && refcount > folio_nr_pages(folio) + 1) {
> +			/*
> +			 * Outstanding references, the folio cannot be faulted
> +			 * in by anyone until they're dropped.
> +			 */
> +			r = xa_err(xa_store(mappable_offsets, i, xval_none, GFP_KERNEL));
> +		} else {
> +			/*
> +			 * No outstanding references. Transition the folio to
> +			 * guest mappable immediately.
> +			 */
> +			r = xa_err(xa_store(mappable_offsets, i, xval_guest, GFP_KERNEL));
> +		}
> +
> +		if (folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
> +		if (WARN_ON_ONCE(r))
> +			break;
> +	}
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
>
> <snip>

