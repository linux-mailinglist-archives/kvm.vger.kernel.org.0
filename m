Return-Path: <kvm+bounces-36302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4157A19ADA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE29B166D0E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2201D1CAA66;
	Wed, 22 Jan 2025 22:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tZOQKpBB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83721C5D6E
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 22:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737584695; cv=none; b=ZPwmfrCu6plkw65mPyhJIzRSYi+znrbaVizoDc5ue5twgcH1eKIApHE3Yq9AftqAhhpZmXmQX255P23FDOvXO4YzJdzSZ4PHMIRJmbbPnOr279Oqf0SutIAFZYvpLFv1G6yrG9Ald2+yoiVO5V0BBn/uZ6mvu1xavH/uhlta3ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737584695; c=relaxed/simple;
	bh=6p+3gAc1dPxPwnzC46noXXLUPO7tsu485vOhmappwXg=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=unCC20GopOQAsO94Jomdf9aLxor/2nRMTdw2mqK+JWK4W7qXVsXDwJk+Wxs658Tbsk9ftq01viqKoHfAMWUuQ8Q1rs77dyBRaYvdo4jLKJg3k/3zPCW1OzKYLMBIK+haaFSWri3lCdeKHMHXDRkkpJwtWsdfvd4FYy9U9EF/CPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tZOQKpBB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so849427a91.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737584693; x=1738189493; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CMwXY/JjkJ3lg0HRTO0H7XKfXOhFwAMvwIMtHu9bFGE=;
        b=tZOQKpBB4E7OKq68s8aofHRT6tJG+fT0MTYkNhW2k3mJzktH1AOJIw9MJ4uRJi38zP
         b6ZIVJDlpC2bkF3mvAWZ9Kk8q5zhpN1aAyAVJt1TxOoLhEnADQUGTVhINZaF+yG9xuYp
         Nyp917C411PiE1thvoA+0V4TAFcNp37N2nGHedcw2cjBdtGamgqDt+ETY1LbRjWTCQzp
         hw+LXj4YKy64NGyBQzNQbEjFS8b/LKDxKXG//+pMAbgnqMHBevAY7uSq69Ob7lDdHXcZ
         fHYyHfU2vWfEClmhx37HKBSkr0qZqxr7BGIZJnDfLS+idna7Er0qw3qDoP4S4h3Qhbje
         b3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737584693; x=1738189493;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CMwXY/JjkJ3lg0HRTO0H7XKfXOhFwAMvwIMtHu9bFGE=;
        b=wa2SVeWQCQZ9vxyRxHx3czN2oPbTYUuVK3mVQjAq/kut6NNYbWX2Qclb+OsvggdVBm
         P1eTbb5WeY+LRz4dtOSaVvH1dMZPDWvrBmSf0GtHTXv5w8mqQhQ/ahtQ82o/8eDY0A4y
         OBaVT1aun9M4xFk5hg3gA/u1dwBdCbfk5cbohDw0QLqLPjccY09dvrADsO4m9i2JwIWH
         Ss1yIF25yGHQn08MP710jCJczLaP1bNxWGpMbpm9OQWAa0aTsVZBF4tv+BmfnLACHMe1
         ZJ/+Y1EW5EYi3SL5v/IHMEdnEKe8E+NcfG7nYjGHTYbc7e/ypZ/O7Vmr1q18ZOj+tuQm
         Ax3Q==
X-Forwarded-Encrypted: i=1; AJvYcCURjXeVzCC2c6S1EawoRU0E8v0rAswl5TM4jp3iPwcAf57niCrV06Dn2bJkgVDyrQMNsP0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3AV2N9Wvz39WADX2NiwstR7XPGGZlRo8Qa2+Mo4yMSWfjwc0N
	t71Nq50xsmt1kTNnEoH9OpTbhOIk812OHo+h+o60nn+kgPsPCKOa+S9xw9aeOKS8OfhtBYiDSBa
	H0GbnQYz5E7yrGCxRjuqzGA==
X-Google-Smtp-Source: AGHT+IGny/ahIaHLhfGDMFBH8s+87+rJDqnReE6Qarm33JtTuAS7FXf81z1qgVp9GHi0Sc6XCHS/z/HSfVxK0lzYXg==
X-Received: from pfjx27.prod.google.com ([2002:aa7:9a5b:0:b0:72a:bcc3:4c9a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fd3:b0:72a:8461:d172 with SMTP id d2e1a72fcca58-72daf9becfamr37134850b3a.3.1737584692988;
 Wed, 22 Jan 2025 14:24:52 -0800 (PST)
Date: Wed, 22 Jan 2025 22:24:51 +0000
In-Reply-To: <CA+EHjTxrsPnVYSsc5bJ=fL_tWFUsjqiiMpJ3GURw6s4uwn810w@mail.gmail.com>
 (message from Fuad Tabba on Mon, 20 Jan 2025 12:14:50 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzfrlasczw.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: vbabka@suse.cz, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

>> > <snip>
>> >
>> > +/*
>> > + * Registers a callback to __folio_put(), so that gmem knows that the host does
>> > + * not have any references to the folio. It does that by setting the folio type
>> > + * to guestmem.
>> > + *
>> > + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
>> > + * has references, and the callback has been registered.
>>
>> Note this comment.
>>
>> > + *
>> > + * Must be called with the following locks held:
>> > + * - filemap (inode->i_mapping) invalidate_lock
>> > + * - folio lock
>> > + */
>> > +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
>> > +{
>> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
>> > +     int refcount;
>> > +
>> > +     rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
>> > +     WARN_ON_ONCE(!folio_test_locked(folio));
>> > +
>> > +     if (folio_mapped(folio) || folio_test_guestmem(folio))
>> > +             return -EAGAIN;
>>
>> But here we return -EAGAIN and no callback was registered?
>
> This is intentional. If the folio is still mapped (i.e., its mapcount
> is elevated), then we cannot register the callback yet, so the
> host/vmm needs to unmap first, then try again. That said, I see the
> problem with the comment above, and I will clarify this.
>
>> > +
>> > +     /* Register a callback first. */
>> > +     __folio_set_guestmem(folio);
>> > +
>> > +     /*
>> > +      * Check for references after setting the type to guestmem, to guard
>> > +      * against potential races with the refcount being decremented later.
>> > +      *
>> > +      * At least one reference is expected because the folio is locked.
>> > +      */
>> > +
>> > +     refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
>> > +     if (refcount == 1) {
>> > +             int r;
>> > +
>> > +             /* refcount isn't elevated, it's now faultable by the guest. */
>>
>> Again this seems racy, somebody could have just speculatively increased it.
>> Maybe we need to freeze here as well?
>
> A speculative increase here is ok I think (famous last words). The
> callback was registered before the check, therefore, such an increase
> would trigger the callback.
>
> Thanks,
> /fuad
>
>

I checked the callback (kvm_gmem_handle_folio_put()) and agree with you
that the mappability reset to KVM_GMEM_GUEST_MAPPABLE is handled
correctly (since kvm_gmem_handle_folio_put() doesn't assume anything
about the mappability state at callback-time).

However, what if the new speculative reference writes to the page and
guest goes on to fault/use the page?

>> > +             r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
>> > +             if (!r)
>> > +                     __kvm_gmem_restore_pending_folio(folio);
>> > +
>> > +             return r;
>> > +     }
>> > +
>> > +     return -EAGAIN;
>> > +}
>> > +
>> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
>> > +{
>> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
>> > +     struct inode *inode = file_inode(slot->gmem.file);
>> > +     struct folio *folio;
>> > +     int r;
>> > +
>> > +     filemap_invalidate_lock(inode->i_mapping);
>> > +
>> > +     folio = filemap_lock_folio(inode->i_mapping, pgoff);
>> > +     if (WARN_ON_ONCE(IS_ERR(folio))) {
>> > +             r = PTR_ERR(folio);
>> > +             goto out;
>> > +     }
>> > +
>> > +     r = __gmem_register_callback(folio, inode, pgoff);
>> > +
>> > +     folio_unlock(folio);
>> > +     folio_put(folio);
>> > +out:
>> > +     filemap_invalidate_unlock(inode->i_mapping);
>> > +
>> > +     return r;
>> > +}
>> > +
>> > +/*
>> > + * Callback function for __folio_put(), i.e., called when all references by the
>> > + * host to the folio have been dropped. This allows gmem to transition the state
>> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
>> > + * transitioning its state to private, since the host cannot attempt to access
>> > + * it anymore.
>> > + */
>> > +void kvm_gmem_handle_folio_put(struct folio *folio)
>> > +{
>> > +     struct xarray *mappable_offsets;
>> > +     struct inode *inode;
>> > +     pgoff_t index;
>> > +     void *xval;
>> > +
>> > +     inode = folio->mapping->host;
>> > +     index = folio->index;
>> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
>> > +
>> > +     filemap_invalidate_lock(inode->i_mapping);
>> > +     __kvm_gmem_restore_pending_folio(folio);
>> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
>> > +     filemap_invalidate_unlock(inode->i_mapping);
>> > +}
>> > +
>> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
>> >  {
>> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>>

