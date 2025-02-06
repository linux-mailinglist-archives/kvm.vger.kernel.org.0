Return-Path: <kvm+bounces-37424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6C7A29F60
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 04:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 180E6166621
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 03:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AF6156669;
	Thu,  6 Feb 2025 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="azzcDBHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DBC14A627
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738812483; cv=none; b=ecnONKt3IH/RbKvuA7COGJOimHBJ5iPD3QKJTaeZdB6mFrFBI3Pu1ysSCgYgYmf6uHv8Yar1CeqkJV7Tq0/GVYJ/pSrptzdP3ylidRFECbgm9dYI7brhKM1BZRD5QHroJ9f1XADpQHgtJOWT7iXOIZj64o2KWkeUhR/eJhp/7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738812483; c=relaxed/simple;
	bh=h+MLPWhIAMvwOiv0vuo+4FISoS7wVvZQbwB2GT+DW+I=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DE1tB3rq3mNtjtr2TCmoMH8Qci8efmkoctfWc//zDKO5vnNmtztLjc8sMBlqLhObXCRLzuzqsxlA37DZP6iBPFCbMuNEe84BBSi086tvvA6tTsyX5MSj/HINJVthtjbfjjKeZ0KJ3DLPcWxdZZeyiYFh1Me6ncxvOdjTHSMogG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=azzcDBHC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso1321475a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 19:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738812481; x=1739417281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f86QKI54VzReRntSvKH8Sw9ugqYuvTu09svLm+2ooYY=;
        b=azzcDBHCgf4DeVEIk4gRfmVlnpEKvRxeUwxlJghuWWOPA0piSiGgYFyOkHyltw917u
         iRgpW9T5vtCZMi/g49YqWmzXABpsQFMeHOCwD34r62G+764ivkbd84JwNKWo0Y6I6f3X
         TRzHAm+OUQ/Vqpo59RmrR0Oqui2dfk/PoVDU7m38LQYsLUn7gYQhOy3feKT2m8Z/bSPW
         oU4nixTnp9DO2FBKMZSJYpKnL/kYYlGJf+h/5Zz8aRmqdCdQW3GCWEz29QYJq3mp1WrU
         usFLeadaAfdOb/l2u6LNXBy5o/QNYr9oHEGrnbSVGU/YS3Mz/LtGNlO2ybCQUjEkX52E
         5BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738812481; x=1739417281;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f86QKI54VzReRntSvKH8Sw9ugqYuvTu09svLm+2ooYY=;
        b=QnYQjTxpkGfazcah8aVJGsa9ZfbVUTbwN/2z7d7dJ7c9roQcgu7Lj4zTPo39RbhrrK
         3hqgY+uuDxBlfk4zL2XncOlZa5QFyToP5e8nWsGQJfqVVaq+rZnzbxvfvwbiynDX8MQV
         ZWAesDV9euGXJG3LUfqw46i7w4wrf75lwHLINsT83gb5socctUQr7UgKJEeNU2OLfAVe
         mT1097GMWUbPLEDdDzuxrFUjEF2Y19NcpvPiH/EG5GFvc5/FicvFSENspGJbuVXBPM88
         VL1kzKwHJ487a7AiHMcw9v+oOUQgnFEzgjzIIrJxMih4V9/6UKDiXrjlzcZ9hg4qz/3C
         2OYg==
X-Forwarded-Encrypted: i=1; AJvYcCVEghhP2zx20ITml2YP6Zt0YQDzy+67CARF+BPcsEipdN2puUDtrCNSJ+Z8nTg8IluyvV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhtiDJxYx+HMzrlApDLaN71Dcocn+vRUPBlZtI21+yDVLy6BIS
	wNYo2uyepFcpDgurztze3w5Jn3IfE4LtL7zcLf3YRN6IJXrCSbRES37f7kXflJFuYLu3q5hbg3G
	IdHsZvyAQ/h87H4ePKmlBvA==
X-Google-Smtp-Source: AGHT+IH0DhkGpMKRUFBfTEJ4n7ZfzHdfgibyH/6sTUAKCmbFrQGBXGYU070tEmkqKMXdvIZELc0Lez0AxeRJeaX27g==
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2f5:63a:4513])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b4a:b0:2ea:7cd5:4ad6 with SMTP id 98e67ed59e1d1-2f9e0851384mr6953905a91.32.1738812481234;
 Wed, 05 Feb 2025 19:28:01 -0800 (PST)
Date: Thu, 06 Feb 2025 03:28:00 +0000
In-Reply-To: <CA+EHjTyToQEHoKOQLgDxdjTCCvawrtS8czsZYLehRO1N_Ph2EQ@mail.gmail.com>
 (message from Fuad Tabba on Thu, 23 Jan 2025 11:00:28 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz4j17sqf3.fsf@ackerleytng-ctop.c.googlers.com>
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

> On Wed, 22 Jan 2025 at 22:24, Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> Fuad Tabba <tabba@google.com> writes:
>>
>> >> > <snip>
>> >> >
>> >> > +/*
>> >> > + * Registers a callback to __folio_put(), so that gmem knows that the host does
>> >> > + * not have any references to the folio. It does that by setting the folio type
>> >> > + * to guestmem.
>> >> > + *
>> >> > + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
>> >> > + * has references, and the callback has been registered.
>> >>
>> >> Note this comment.
>> >>
>> >> > + *
>> >> > + * Must be called with the following locks held:
>> >> > + * - filemap (inode->i_mapping) invalidate_lock
>> >> > + * - folio lock
>> >> > + */
>> >> > +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
>> >> > +{
>> >> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>> >> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
>> >> > +     int refcount;
>> >> > +
>> >> > +     rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
>> >> > +     WARN_ON_ONCE(!folio_test_locked(folio));
>> >> > +
>> >> > +     if (folio_mapped(folio) || folio_test_guestmem(folio))
>> >> > +             return -EAGAIN;
>> >>
>> >> But here we return -EAGAIN and no callback was registered?
>> >
>> > This is intentional. If the folio is still mapped (i.e., its mapcount
>> > is elevated), then we cannot register the callback yet, so the
>> > host/vmm needs to unmap first, then try again. That said, I see the
>> > problem with the comment above, and I will clarify this.
>> >
>> >> > +
>> >> > +     /* Register a callback first. */
>> >> > +     __folio_set_guestmem(folio);
>> >> > +
>> >> > +     /*
>> >> > +      * Check for references after setting the type to guestmem, to guard
>> >> > +      * against potential races with the refcount being decremented later.
>> >> > +      *
>> >> > +      * At least one reference is expected because the folio is locked.
>> >> > +      */
>> >> > +
>> >> > +     refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
>> >> > +     if (refcount == 1) {
>> >> > +             int r;
>> >> > +
>> >> > +             /* refcount isn't elevated, it's now faultable by the guest. */
>> >>
>> >> Again this seems racy, somebody could have just speculatively increased it.
>> >> Maybe we need to freeze here as well?
>> >
>> > A speculative increase here is ok I think (famous last words). The
>> > callback was registered before the check, therefore, such an increase
>> > would trigger the callback.
>> >
>> > Thanks,
>> > /fuad
>> >
>> >
>>
>> I checked the callback (kvm_gmem_handle_folio_put()) and agree with you
>> that the mappability reset to KVM_GMEM_GUEST_MAPPABLE is handled
>> correctly (since kvm_gmem_handle_folio_put() doesn't assume anything
>> about the mappability state at callback-time).
>>
>> However, what if the new speculative reference writes to the page and
>> guest goes on to fault/use the page?
>
> I don't think that's a problem. At this point the page is in a
> transient state, but still shared from the guest's point of view.
> Moreover, no one can fault-in the page at the host at this point (we
> check in kvm_gmem_fault()).
>
> Let's have a look at the code:
>
> +static int __gmem_register_callback(struct folio *folio, struct inode
> *inode, pgoff_t idx)
> +{
> +       struct xarray *mappable_offsets =
> &kvm_gmem_private(inode)->mappable_offsets;
> +       void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +       int refcount;
>
> At this point the guest still perceives the page as shared, the state
> of the page is KVM_GMEM_NONE_MAPPABLE (transient state). This means
> that kvm_gmem_fault() doesn't fault-in the page at the host anymore.
>
> +       rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> +       WARN_ON_ONCE(!folio_test_locked(folio));
> +
> +       if (folio_mapped(folio) || folio_test_guestmem(folio))
> +               return -EAGAIN;
> +
> +       /* Register a callback first. */
> +       __folio_set_guestmem(folio);
>
> This (in addition to the state of the NONE_MAPPABLE), also ensures
> that kvm_gmem_fault() doesn't fault-in the page at the host anymore.
>
> +       /*
> +        * Check for references after setting the type to guestmem, to guard
> +        * against potential races with the refcount being decremented later.
> +        *
> +        * At least one reference is expected because the folio is locked.
> +        */
> +
> +       refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> +       if (refcount == 1) {
> +               int r;
>
> At this point we know that guest_memfd has the only real reference.
> Speculative references AFAIK do not access the page itself.
> +
> +               /* refcount isn't elevated, it's now faultable by the guest. */
> +               r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets,
> idx, xval_guest, GFP_KERNEL)));
>
> Now it's safe so let the guest know that it can map the page.
>
> +               if (!r)
> +                       __kvm_gmem_restore_pending_folio(folio);
> +
> +               return r;
> +       }
> +
> +       return -EAGAIN;
> +}
>
> Does this make sense, or did I miss something?

Thanks for explaining! I don't know enough to confirm/deny this but I agree
that if speculative references don't access the page itself, this works.

What if over here, we just drop the refcount, and let setting mappability to
GUEST happen in the folio_put() callback?

>
> Thanks!
> /fuad
>
>> >> > +             r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
>> >> > +             if (!r)
>> >> > +                     __kvm_gmem_restore_pending_folio(folio);
>> >> > +
>> >> > +             return r;
>> >> > +     }
>> >> > +
>> >> > +     return -EAGAIN;
>> >> > +}
>> >> > +
>> >> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
>> >> > +{
>> >> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
>> >> > +     struct inode *inode = file_inode(slot->gmem.file);
>> >> > +     struct folio *folio;
>> >> > +     int r;
>> >> > +
>> >> > +     filemap_invalidate_lock(inode->i_mapping);
>> >> > +
>> >> > +     folio = filemap_lock_folio(inode->i_mapping, pgoff);
>> >> > +     if (WARN_ON_ONCE(IS_ERR(folio))) {
>> >> > +             r = PTR_ERR(folio);
>> >> > +             goto out;
>> >> > +     }
>> >> > +
>> >> > +     r = __gmem_register_callback(folio, inode, pgoff);
>> >> > +
>> >> > +     folio_unlock(folio);
>> >> > +     folio_put(folio);
>> >> > +out:
>> >> > +     filemap_invalidate_unlock(inode->i_mapping);
>> >> > +
>> >> > +     return r;
>> >> > +}
>> >> > +
>> >> > +/*
>> >> > + * Callback function for __folio_put(), i.e., called when all references by the
>> >> > + * host to the folio have been dropped. This allows gmem to transition the state
>> >> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
>> >> > + * transitioning its state to private, since the host cannot attempt to access
>> >> > + * it anymore.
>> >> > + */
>> >> > +void kvm_gmem_handle_folio_put(struct folio *folio)
>> >> > +{
>> >> > +     struct xarray *mappable_offsets;
>> >> > +     struct inode *inode;
>> >> > +     pgoff_t index;
>> >> > +     void *xval;
>> >> > +
>> >> > +     inode = folio->mapping->host;
>> >> > +     index = folio->index;
>> >> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>> >> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
>> >> > +
>> >> > +     filemap_invalidate_lock(inode->i_mapping);
>> >> > +     __kvm_gmem_restore_pending_folio(folio);
>> >> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
>> >> > +     filemap_invalidate_unlock(inode->i_mapping);
>> >> > +}
>> >> > +
>> >> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
>> >> >  {
>> >> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
>> >>

