Return-Path: <kvm+bounces-37468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1DC0A2A50A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 352851888CA9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6124E226866;
	Thu,  6 Feb 2025 09:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f0WATB7y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C2122654E
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738835279; cv=none; b=GWISkUeYmnJ5vmEzjfOkMu9WQq92l8lWW8Jw32cz+ZsX6Z+QgGsbOCtaEzYx96rqJBR4++5WUe6Gg9zFpGtKgH2bqnArw/+e61rJU/b7fGgNlinBVnzudOUQnkbD/hJMXb1oNR3CLEcAnSvApXVqmnmNMNsA3ug88JvgWdl9Q20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738835279; c=relaxed/simple;
	bh=CJXXj89u8MApNW9Ge6KcavC3gNPuVFKXTr48arVRo2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QnIO1/mmzGNVz3zucyRvttZuIEugenMc9JdrzOpBtyCeqaUrQMolyQGMWn6fezTfCVeKmbeON8L0ZhIoPAJ14rwrULAHSy0X1FG7hmR3xnCf3kmWtUcj2tbzWzRpUEP7ag2rUzJwkI4gaucI8cMFcEicOz0yzfk5AlWjjoJ8U2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f0WATB7y; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4678c9310afso143321cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738835276; x=1739440076; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v6IYTK3nh6GBIDdKkLoNwhq9MdnRnCbo7ufzWqCaI98=;
        b=f0WATB7yCTKG0n4awq3uz+Au4Uck7TjUmLZHjFGqvNeiTvfi6/ne0f3vYG1eYgO6Z0
         m3OxAgmHXCu5U/WGQ6VBetxuadp+2uAzGdqF324kZo0hhQoWjHxXDWHvT7TEVQdORpMA
         aQ0zDpSsg2BfwwIQ1yXVKzri8ZpNS+umjKBkgk/XUD7FuNltYujqKRBwpK+d6B02b0IA
         wua1O2if8eV0rbNykQH2RypwsVommVPGnfL39BZR0xk6bPSleUm5h90ZnTYCyEY0PHTE
         jCu/uSdAHooz0URJzMoT1OoojGGQx/SbItZGRO/1kfTApAfhVrJ2G7A1THnJBdfuAGn3
         WzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738835276; x=1739440076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6IYTK3nh6GBIDdKkLoNwhq9MdnRnCbo7ufzWqCaI98=;
        b=Gvc63tzp8dh/h3+CpqdRGqzqXdrwGFf0bMomhH/BXwd1z1E5n9KrUJXzMWmu4g8nhC
         eCQ5xGhXPwUB6hGZoz+2ae4rQu6d6Z/iENBOeKwKUh4FZ3jQZETvsPwljPkVnQvqmjoY
         /7jBusFcGoYfLSP7rQESyEexjRP/4//YekAC72HMVP4nBG7a6hZdBeJcxxR1rSj+6O4b
         t3DbeONaKzoZrayD0yHUewI2UTDnwRTwP1TAb1A1icjptkOr3FyGRlxYyk/UR8qtHSRv
         zjDPN07mCN6sbZusuxOykK4PwmmBi8tbGwnOmr7ys6BItFI8QQ7OGmbnnFwl3vH6BhpU
         bz1A==
X-Forwarded-Encrypted: i=1; AJvYcCWL8N7qMWn1FEPrV7Q5YzlgYefVqkInJhr8j6sgYKbk7Pd/Fak+2vQ25Fs78c7tPLmdFVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwLGZy7m2kZd4QAMTM+B1GWSQl4P7neSeFX0z3DdGIvW5xx1E8
	f6Bb7bPxEsYxPmlCG9I1pjFQ4D70iUFIuEnZzpMbBeBzi76kshprbR8pWLKZ2FlR3nyF3TRX2I4
	kae/DjervPc5rV8OnuLqo6cVHW4Xe7AMyGD4M
X-Gm-Gg: ASbGnctMZN1St1XCPULA/d6sEZzolf0K95rbI//l4eu7GfBk6x8IBb+QsQSW/T6QCpw
	acDNuqkeYpUVKxRCyj10zKWcacshIIyc/dZaxBkBrcGtQEDLwPORcx7BChbcZHp3NLi+Y0iO2g5
	0gy5iDEf/z4H4pu2P1f2aq7cy1jA==
X-Google-Smtp-Source: AGHT+IH2kNovjjTMjexpacUe+GJCihFf0EH6lWEtv2ZG7xpTLVuPcxkrF5CQiQscN7rUc6TK6bBKq+QdNr3Yq+jW6tc=
X-Received: by 2002:a05:622a:1311:b0:46c:791f:bf2f with SMTP id
 d75a77b69052e-47106bf403bmr1991231cf.1.1738835276192; Thu, 06 Feb 2025
 01:47:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EHjTyToQEHoKOQLgDxdjTCCvawrtS8czsZYLehRO1N_Ph2EQ@mail.gmail.com>
 <diqz4j17sqf3.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz4j17sqf3.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Feb 2025 09:47:19 +0000
X-Gm-Features: AWEUYZlPwv3dT-XNtR8vcSj1WxKNk3oUMwXJf-eGk9uS-zbbUk_RuCmnuO5yF_w
Message-ID: <CA+EHjTycQQ1Bx323n=w=Apzrr1Y9qk4dxQkcsKWKCfqRNF+Z4A@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Ackerley Tng <ackerleytng@google.com>
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

On Thu, 6 Feb 2025 at 03:28, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > On Wed, 22 Jan 2025 at 22:24, Ackerley Tng <ackerleytng@google.com> wrote:
> >>
> >> Fuad Tabba <tabba@google.com> writes:
> >>
> >> >> > <snip>
> >> >> >
> >> >> > +/*
> >> >> > + * Registers a callback to __folio_put(), so that gmem knows that the host does
> >> >> > + * not have any references to the folio. It does that by setting the folio type
> >> >> > + * to guestmem.
> >> >> > + *
> >> >> > + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
> >> >> > + * has references, and the callback has been registered.
> >> >>
> >> >> Note this comment.
> >> >>
> >> >> > + *
> >> >> > + * Must be called with the following locks held:
> >> >> > + * - filemap (inode->i_mapping) invalidate_lock
> >> >> > + * - folio lock
> >> >> > + */
> >> >> > +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
> >> >> > +{
> >> >> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> >> >> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> >> >> > +     int refcount;
> >> >> > +
> >> >> > +     rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> >> >> > +     WARN_ON_ONCE(!folio_test_locked(folio));
> >> >> > +
> >> >> > +     if (folio_mapped(folio) || folio_test_guestmem(folio))
> >> >> > +             return -EAGAIN;
> >> >>
> >> >> But here we return -EAGAIN and no callback was registered?
> >> >
> >> > This is intentional. If the folio is still mapped (i.e., its mapcount
> >> > is elevated), then we cannot register the callback yet, so the
> >> > host/vmm needs to unmap first, then try again. That said, I see the
> >> > problem with the comment above, and I will clarify this.
> >> >
> >> >> > +
> >> >> > +     /* Register a callback first. */
> >> >> > +     __folio_set_guestmem(folio);
> >> >> > +
> >> >> > +     /*
> >> >> > +      * Check for references after setting the type to guestmem, to guard
> >> >> > +      * against potential races with the refcount being decremented later.
> >> >> > +      *
> >> >> > +      * At least one reference is expected because the folio is locked.
> >> >> > +      */
> >> >> > +
> >> >> > +     refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> >> >> > +     if (refcount == 1) {
> >> >> > +             int r;
> >> >> > +
> >> >> > +             /* refcount isn't elevated, it's now faultable by the guest. */
> >> >>
> >> >> Again this seems racy, somebody could have just speculatively increased it.
> >> >> Maybe we need to freeze here as well?
> >> >
> >> > A speculative increase here is ok I think (famous last words). The
> >> > callback was registered before the check, therefore, such an increase
> >> > would trigger the callback.
> >> >
> >> > Thanks,
> >> > /fuad
> >> >
> >> >
> >>
> >> I checked the callback (kvm_gmem_handle_folio_put()) and agree with you
> >> that the mappability reset to KVM_GMEM_GUEST_MAPPABLE is handled
> >> correctly (since kvm_gmem_handle_folio_put() doesn't assume anything
> >> about the mappability state at callback-time).
> >>
> >> However, what if the new speculative reference writes to the page and
> >> guest goes on to fault/use the page?
> >
> > I don't think that's a problem. At this point the page is in a
> > transient state, but still shared from the guest's point of view.
> > Moreover, no one can fault-in the page at the host at this point (we
> > check in kvm_gmem_fault()).
> >
> > Let's have a look at the code:
> >
> > +static int __gmem_register_callback(struct folio *folio, struct inode
> > *inode, pgoff_t idx)
> > +{
> > +       struct xarray *mappable_offsets =
> > &kvm_gmem_private(inode)->mappable_offsets;
> > +       void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +       int refcount;
> >
> > At this point the guest still perceives the page as shared, the state
> > of the page is KVM_GMEM_NONE_MAPPABLE (transient state). This means
> > that kvm_gmem_fault() doesn't fault-in the page at the host anymore.
> >
> > +       rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> > +       WARN_ON_ONCE(!folio_test_locked(folio));
> > +
> > +       if (folio_mapped(folio) || folio_test_guestmem(folio))
> > +               return -EAGAIN;
> > +
> > +       /* Register a callback first. */
> > +       __folio_set_guestmem(folio);
> >
> > This (in addition to the state of the NONE_MAPPABLE), also ensures
> > that kvm_gmem_fault() doesn't fault-in the page at the host anymore.
> >
> > +       /*
> > +        * Check for references after setting the type to guestmem, to guard
> > +        * against potential races with the refcount being decremented later.
> > +        *
> > +        * At least one reference is expected because the folio is locked.
> > +        */
> > +
> > +       refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> > +       if (refcount == 1) {
> > +               int r;
> >
> > At this point we know that guest_memfd has the only real reference.
> > Speculative references AFAIK do not access the page itself.
> > +
> > +               /* refcount isn't elevated, it's now faultable by the guest. */
> > +               r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets,
> > idx, xval_guest, GFP_KERNEL)));
> >
> > Now it's safe so let the guest know that it can map the page.
> >
> > +               if (!r)
> > +                       __kvm_gmem_restore_pending_folio(folio);
> > +
> > +               return r;
> > +       }
> > +
> > +       return -EAGAIN;
> > +}
> >
> > Does this make sense, or did I miss something?
>
> Thanks for explaining! I don't know enough to confirm/deny this but I agree
> that if speculative references don't access the page itself, this works.
>
> What if over here, we just drop the refcount, and let setting mappability to
> GUEST happen in the folio_put() callback?

Similar to what I mentioned in the other thread, the common case
should be that the mapcount and refcount are not elevated, therefore,
I think it's better not to go through the callback route unless it's
necessary for correctness.

Cheers,
/fuad

> >
> > Thanks!
> > /fuad
> >
> >> >> > +             r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
> >> >> > +             if (!r)
> >> >> > +                     __kvm_gmem_restore_pending_folio(folio);
> >> >> > +
> >> >> > +             return r;
> >> >> > +     }
> >> >> > +
> >> >> > +     return -EAGAIN;
> >> >> > +}
> >> >> > +
> >> >> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> >> >> > +{
> >> >> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> >> >> > +     struct inode *inode = file_inode(slot->gmem.file);
> >> >> > +     struct folio *folio;
> >> >> > +     int r;
> >> >> > +
> >> >> > +     filemap_invalidate_lock(inode->i_mapping);
> >> >> > +
> >> >> > +     folio = filemap_lock_folio(inode->i_mapping, pgoff);
> >> >> > +     if (WARN_ON_ONCE(IS_ERR(folio))) {
> >> >> > +             r = PTR_ERR(folio);
> >> >> > +             goto out;
> >> >> > +     }
> >> >> > +
> >> >> > +     r = __gmem_register_callback(folio, inode, pgoff);
> >> >> > +
> >> >> > +     folio_unlock(folio);
> >> >> > +     folio_put(folio);
> >> >> > +out:
> >> >> > +     filemap_invalidate_unlock(inode->i_mapping);
> >> >> > +
> >> >> > +     return r;
> >> >> > +}
> >> >> > +
> >> >> > +/*
> >> >> > + * Callback function for __folio_put(), i.e., called when all references by the
> >> >> > + * host to the folio have been dropped. This allows gmem to transition the state
> >> >> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
> >> >> > + * transitioning its state to private, since the host cannot attempt to access
> >> >> > + * it anymore.
> >> >> > + */
> >> >> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> >> >> > +{
> >> >> > +     struct xarray *mappable_offsets;
> >> >> > +     struct inode *inode;
> >> >> > +     pgoff_t index;
> >> >> > +     void *xval;
> >> >> > +
> >> >> > +     inode = folio->mapping->host;
> >> >> > +     index = folio->index;
> >> >> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> >> >> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> >> >> > +
> >> >> > +     filemap_invalidate_lock(inode->i_mapping);
> >> >> > +     __kvm_gmem_restore_pending_folio(folio);
> >> >> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> >> >> > +     filemap_invalidate_unlock(inode->i_mapping);
> >> >> > +}
> >> >> > +
> >> >> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> >> >> >  {
> >> >> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> >> >>

