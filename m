Return-Path: <kvm+bounces-36000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 502AAA16C33
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 630A93A529E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FABE1DFDB8;
	Mon, 20 Jan 2025 12:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ngmKHlrf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461651B6CEC
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737375332; cv=none; b=KLMSewnOMnHJD4PK6zWtVkUz0psw7gmpTSummu8cYBgKlTcdIRsZ2XHrpo2gQGlcY20iH3+qgeNuD81FYBXpxeQZXUjvXUwhYtI47N8EXF6uknFRwLTwP/s3+rmUX97DmkzIaRN5LkJ4V7ErbK1y/neXO3XFvDukWXsoWfsnlnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737375332; c=relaxed/simple;
	bh=mBBV7HAY2a4i9ZBM+OIAmCeg6ZqzwvWpFP21CwZt+7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFO1UKhLzAIAYceeFoq8VaG9bmGfkxhnW89GsSYNHyqOdtfxiK06Ec362QQVfB3jF0jkg+0H439xCetZTRe1cmYqc6I0APx3b90+O6MjdLKUXNMNMNyaUqo2K+2m9vUxSKuUf46Fsgnkc2rbR46a7fOsPenjMS1PAgl2FgqZjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ngmKHlrf; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso79645e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737375328; x=1737980128; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QWvW/3T8LwxW9ylBIaUuTKzxQTh1JV8NqskFJ9TijpQ=;
        b=ngmKHlrfnFapSmwDJQ0tCU4G0OO2KR+YfPnOjF3CvG9kSWceHgTCf4qgYWJlBymjzx
         +WWO0MoL4U074qeRsMl41HFBF2DoLzs8qfGovDwFR3gR898RT71hNPcYCCCJUDySeCoF
         P0rzo7hBZ9ukqzppwpY1/cJZ67rlV9ERUbLkq7v2pTeZZqbI4IqDcuIL9RT8eEXaBTs/
         BMcekbtRk0u6GqlQf+lOS69xycHIyAz2LfYG92Z6t9rX07Wa2XJLakoTNrwiiDiiniXU
         CfwJ4xwDSGIac/q+A5ko5KuKB+RJTLyRyweIsFAsvD2R2DjP1RX9bTARCaTpm1fFi1bz
         w0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737375328; x=1737980128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QWvW/3T8LwxW9ylBIaUuTKzxQTh1JV8NqskFJ9TijpQ=;
        b=jBVVGJtEwTlyuPhaY9bL8LlzruHYCLm1Im8GpXxTgOKdKZbn6lQMwO1hKcXyGPv1CU
         4IA9hayhU/WlxZQbgEHJKX1gihXL4XiAOt+MliEwJlXcKmXOPECbkfHaPv/Z+ZNrqDKI
         PEcBmNRLNtWiTTcYG22s2/3fWOvyfPhN+pLPaKwJaCRuk3Nsd+Z5zoY+8Haadcf85NP6
         KyJ1anKxJeE1ZU5pZAo2GWfJtSILyzMJoiF1nqTf/R7TynBVeNp+G2pl8YzUnrM5+13d
         D/AzEnam5k9IoUTFbdpRebRKJU7qh4PloNh4pzd8mQUjm/BznAll2gnpJZAZMYmrTJ6o
         /m+w==
X-Gm-Message-State: AOJu0YwuRw0a8DIjcDCYm4xIi+jNJyG4RbfxLfRC78iuozqJRpotZXz7
	uGpEENhPQmsCx7RqWbji/ODx5vsZUjoQEOlk4SnTgF+OMGYiK6xrRzWnfmqG08IMt2cGk+/0MVl
	hI7G9rGaW/+xhNwr4JbqwhmEEIjYTADx7OSHh
X-Gm-Gg: ASbGncvWQMRxz1dQgLB38eGO8d8QvJArFSBGX8AecP/1y3rz1RlHL1atEeLIWn1H5kF
	la3cTY5L7e0b4ND2q3a/ugP9IOCveXyQfbAX4X8DoyIY6J/w4gw==
X-Google-Smtp-Source: AGHT+IE3IRwz5JThPXsLvYgrKPbo7zk3RC9OByqB95gXnpdlRbvzoobzkAL3nR8dunv7BdydKSmbfXaelVImxZDQlPc=
X-Received: by 2002:a05:600c:6d8c:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-438a0f45d1bmr2345985e9.7.1737375328262; Mon, 20 Jan 2025
 04:15:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-7-tabba@google.com>
 <417ca32d-b7f3-4dc9-8d3f-dc0ba67214ad@suse.cz>
In-Reply-To: <417ca32d-b7f3-4dc9-8d3f-dc0ba67214ad@suse.cz>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 Jan 2025 12:14:50 +0000
X-Gm-Features: AbW1kvYiLYDkJccSGcIlFv6JvIp9L0_jnhdtUHGnef2nKfmhei23pDM3daO69gw
Message-ID: <CA+EHjTxrsPnVYSsc5bJ=fL_tWFUsjqiiMpJ3GURw6s4uwn810w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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

Hi Vlastimil,

On Mon, 20 Jan 2025 at 11:37, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 1/17/25 17:29, Fuad Tabba wrote:
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, and uses
> > that to register a callback that informs the guest_memfd
> > subsystem when the last reference is dropped, therefore knowing
> > that the host doesn't have any remaining references.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > The function kvm_slot_gmem_register_callback() isn't used in this
> > series. It will be used later in code that performs unsharing of
> > memory. I have tested it with pKVM, based on downstream code [*].
> > It's included in this RFC since it demonstrates the plan to
> > handle unsharing of private folios.
> >
> > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v5-pkvm
>
> <snip>
>
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -387,6 +387,28 @@ enum folio_mappability {
> >       KVM_GMEM_NONE_MAPPABLE  = 0b11, /* Not mappable, transient state. */
> >  };
> >
> > +/*
> > + * Unregisters the __folio_put() callback from the folio.
> > + *
> > + * Restores a folio's refcount after all pending references have been released,
> > + * and removes the folio type, thereby removing the callback. Now the folio can
> > + * be freed normaly once all actual references have been dropped.
> > + *
> > + * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
> > + * Must also have exclusive access to the folio: folio must be either locked, or
> > + * gmem holds the only reference.
> > + */
> > +static void __kvm_gmem_restore_pending_folio(struct folio *folio)
> > +{
> > +     if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
> > +             return;
> > +
> > +     WARN_ON_ONCE(!folio_test_locked(folio) && folio_ref_count(folio) > 1);
>
> Similar to Kirill's objection on the other patch, I think there might be a
> speculative refcount increase (i.e. from a pfn scanner) as long as we have
> refcount over 1. Probably not a problem here if we want to restore refcount
> anyway? But the warning would be spurious.
>
> > +
> > +     __folio_clear_guestmem(folio);
> > +     folio_ref_add(folio, folio_nr_pages(folio));
> > +}
> > +
> >  /*
> >   * Marks the range [start, end) as mappable by both the host and the guest.
> >   * Usually called when guest shares memory with the host.
> > @@ -400,7 +422,31 @@ static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> >
> >       filemap_invalidate_lock(inode->i_mapping);
> >       for (i = start; i < end; i++) {
> > +             struct folio *folio = NULL;
> > +
> > +             /*
> > +              * If the folio is NONE_MAPPABLE, it indicates that it is
> > +              * transitioning to private (GUEST_MAPPABLE). Transition it to
> > +              * shared (ALL_MAPPABLE) immediately, and remove the callback.
> > +              */
> > +             if (xa_to_value(xa_load(mappable_offsets, i)) == KVM_GMEM_NONE_MAPPABLE) {
> > +                     folio = filemap_lock_folio(inode->i_mapping, i);
> > +                     if (WARN_ON_ONCE(IS_ERR(folio))) {
> > +                             r = PTR_ERR(folio);
> > +                             break;
> > +                     }
> > +
> > +                     if (folio_test_guestmem(folio))
> > +                             __kvm_gmem_restore_pending_folio(folio);
> > +             }
> > +
> >               r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> > +
> > +             if (folio) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +             }
> > +
> >               if (r)
> >                       break;
> >       }
> > @@ -473,6 +519,105 @@ static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> >       return r;
> >  }
> >
> > +/*
> > + * Registers a callback to __folio_put(), so that gmem knows that the host does
> > + * not have any references to the folio. It does that by setting the folio type
> > + * to guestmem.
> > + *
> > + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
> > + * has references, and the callback has been registered.
>
> Note this comment.
>
> > + *
> > + * Must be called with the following locks held:
> > + * - filemap (inode->i_mapping) invalidate_lock
> > + * - folio lock
> > + */
> > +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +     int refcount;
> > +
> > +     rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> > +     WARN_ON_ONCE(!folio_test_locked(folio));
> > +
> > +     if (folio_mapped(folio) || folio_test_guestmem(folio))
> > +             return -EAGAIN;
>
> But here we return -EAGAIN and no callback was registered?

This is intentional. If the folio is still mapped (i.e., its mapcount
is elevated), then we cannot register the callback yet, so the
host/vmm needs to unmap first, then try again. That said, I see the
problem with the comment above, and I will clarify this.

> > +
> > +     /* Register a callback first. */
> > +     __folio_set_guestmem(folio);
> > +
> > +     /*
> > +      * Check for references after setting the type to guestmem, to guard
> > +      * against potential races with the refcount being decremented later.
> > +      *
> > +      * At least one reference is expected because the folio is locked.
> > +      */
> > +
> > +     refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> > +     if (refcount == 1) {
> > +             int r;
> > +
> > +             /* refcount isn't elevated, it's now faultable by the guest. */
>
> Again this seems racy, somebody could have just speculatively increased it.
> Maybe we need to freeze here as well?

A speculative increase here is ok I think (famous last words). The
callback was registered before the check, therefore, such an increase
would trigger the callback.

Thanks,
/fuad


> > +             r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
> > +             if (!r)
> > +                     __kvm_gmem_restore_pending_folio(folio);
> > +
> > +             return r;
> > +     }
> > +
> > +     return -EAGAIN;
> > +}
> > +
> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> > +     struct inode *inode = file_inode(slot->gmem.file);
> > +     struct folio *folio;
> > +     int r;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +
> > +     folio = filemap_lock_folio(inode->i_mapping, pgoff);
> > +     if (WARN_ON_ONCE(IS_ERR(folio))) {
> > +             r = PTR_ERR(folio);
> > +             goto out;
> > +     }
> > +
> > +     r = __gmem_register_callback(folio, inode, pgoff);
> > +
> > +     folio_unlock(folio);
> > +     folio_put(folio);
> > +out:
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +/*
> > + * Callback function for __folio_put(), i.e., called when all references by the
> > + * host to the folio have been dropped. This allows gmem to transition the state
> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
> > + * transitioning its state to private, since the host cannot attempt to access
> > + * it anymore.
> > + */
> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     struct xarray *mappable_offsets;
> > +     struct inode *inode;
> > +     pgoff_t index;
> > +     void *xval;
> > +
> > +     inode = folio->mapping->host;
> > +     index = folio->index;
> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     __kvm_gmem_restore_pending_folio(folio);
> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +}
> > +
> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> >  {
> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>

