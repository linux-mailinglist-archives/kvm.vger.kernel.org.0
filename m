Return-Path: <kvm+bounces-16058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 622F18B3B14
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8628F1C2172E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 15:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6AA16F27F;
	Fri, 26 Apr 2024 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1ZsdQUI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED78F149005
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714144626; cv=none; b=mQoyWi7IYAM1XCsZe/N/tU7fitdiI1BiLswsoiO3vJahGBFp73AG7PGmykKmv2mJ5iPrBYr8nRcr/7hF5VJNQWRFyGXazixHosb90hkdiReEqLPV+joWgwzpl7tE/ZVS7Y1BdU0eu2YebqyTSTQZfJ1v/9h1TrSbX0D2nhtJkGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714144626; c=relaxed/simple;
	bh=sExsWb5L+2cv81KMgeLNdA2CdiBKuIej1UWbHKGS8JU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=InwWpck9+/zuGiMUwWxzvMVvK0w6Kmp30JqSY3eQ4tFYq4HUwsmBsfzSo9k7Qt9JDgjAsTJ74A57f+4MF4XZ5GIxByt0glH4V01lAMNFs+4FajJoAU1JLxjaqCN5MnCEtSQQdBq6fVRqX0YkK70NmEefHgMkYWJUK8yruflYQlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D1ZsdQUI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de5a8638579so1197321276.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 08:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714144624; x=1714749424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iq0GDeLIgXuKduEWgHcxOA1pcsaDeMN++CTq3MXKzgQ=;
        b=D1ZsdQUIXOa/5rpFzZ2JK0s0ElaRonM/R0lxoyCzATNBBvDMcvMXTrDBurggIk8E8W
         XkcgIKLopRVrWyebavsIktG4gVjkHfo6eF3TKkWh4lWTphuJLhScsDJTh2ONQMTJBAeQ
         z5suqnQdVTeBUn6Ee7LyenPJWjAgNKzfspDsrXe6sX+tvCuZqlbLYmEuu+qUwi8/Mkh9
         b1A0wQNpOYHDbELzJc9YDVO/MdexUvMKYFCV1XuhmmSU1KUUeAXkreZPTGSFHylAuUIe
         dt1UY+TdaqWd2MVt6+RMlMbG/HjkQOabD4JWZwkbPzRndZpWcFn/8F63nqdgBfGV9WPm
         a6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714144624; x=1714749424;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iq0GDeLIgXuKduEWgHcxOA1pcsaDeMN++CTq3MXKzgQ=;
        b=fx5B4NXf2ePnfbKGIBta2+rn63b4U76QssL1GENWNoqITCDk0p9H9GNlY/edJJQH8x
         +RiZUtm+lx4vatbewxwHtZL21KN/ov1IdWARsbmPjlmaU3tTkWmSFgI2Pa2YkgICzM0U
         hlepklXxmN4rv4QleMSha6lLgJHTgXTIBdEM5YhAnnl592p8FTYy2W9xLj90uSR/OGVJ
         /FHXeMF4YcT+P3CPYx1B7GHZJW3HM2KcL8tCpNzRkJpEa0lgAruHw5m8Sapb9jVriTL2
         1mD6rvO4tiz6PZHkwLrrHSP8UWrEzN13uEtG+SoBevNwENEQSLvptFSUdQhPqaz2naIu
         LSkw==
X-Forwarded-Encrypted: i=1; AJvYcCUL5Mj83aDF8Gm6/+PfkrU6a9toa2D0x00kmA23cN6IPY9lwQ/3ziexkhb3uPoG7e/D2NLgO19EyilfAm62pGxYqCLF
X-Gm-Message-State: AOJu0YzpP3YjrM8p67qrZjXQlOsZ2l4I1inDGaceEPEGaoUPOgYF5Udb
	PMzfqvEXpM+RRaoCKB0Ar78ujhFIS4xeJAzxBSbaLf10V94hrkWetBd//kk39Ry5UJ+QWG6SYzC
	tBQ==
X-Google-Smtp-Source: AGHT+IHJBG2fuHv7U0BwZQFtoRhkzMP/hY4f4E5az1uQuki+6mRIGr3lFS2OCpji0obgKXALsHKEjFolS8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:705:b0:dd9:1b94:edb5 with SMTP id
 k5-20020a056902070500b00dd91b94edb5mr273878ybt.10.1714144623912; Fri, 26 Apr
 2024 08:17:03 -0700 (PDT)
Date: Fri, 26 Apr 2024 08:17:02 -0700
In-Reply-To: <CABgObfaxAd_J5ufr+rOcND=-NWrOzVsvavoaXuFw_cwDd+e9aA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com> <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com> <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com> <CABgObfaxAd_J5ufr+rOcND=-NWrOzVsvavoaXuFw_cwDd+e9aA@mail.gmail.com>
Message-ID: <ZivFbu0WI4qx8zre@google.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024, Paolo Bonzini wrote:
> On Thu, Apr 25, 2024 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Apr 25, 2024, Paolo Bonzini wrote:
> > > On Thu, Apr 25, 2024 at 3:12=E2=80=AFAM Isaku Yamahata <isaku.yamahat=
a@intel.com> wrote:
> > > > > >   get_user_pages_fast(source addr)
> > > > > >   read_lock(mmu_lock)
> > > > > >   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
> > > > > >   if the page table doesn't map gpa, error.
> > > > > >   TDH.MEM.PAGE.ADD()
> > > > > >   TDH.MR.EXTEND()
> > > > > >   read_unlock(mmu_lock)
> > > > > >   put_page()
> > > > >
> > > > > Hmm, KVM doesn't _need_ to use invalidate_lock to protect against=
 guest_memfd
> > > > > invalidation, but I also don't see why it would cause problems.
> > >
> > > The invalidate_lock is only needed to operate on the guest_memfd, but
> > > it's a rwsem so there are no risks of lock inversion.
> > >
> > > > > I.e. why not
> > > > > take mmu_lock() in TDX's post_populate() implementation?
> > > >
> > > > We can take the lock.  Because we have already populated the GFN of=
 guest_memfd,
> > > > we need to make kvm_gmem_populate() not pass FGP_CREAT_ONLY.  Other=
wise we'll
> > > > get -EEXIST.
> > >
> > > I don't understand why TDH.MEM.PAGE.ADD() cannot be called from the
> > > post-populate hook. Can the code for TDH.MEM.PAGE.ADD be shared
> > > between the memory initialization ioctl and the page fault hook in
> > > kvm_x86_ops?
> >
> > Ah, because TDX is required to pre-fault the memory to establish the S-=
EPT walk,
> > and pre-faulting means guest_memfd()
> >
> > Requiring that guest_memfd not have a page when initializing the guest =
image
> > seems wrong, i.e. I don't think we want FGP_CREAT_ONLY.  And not just b=
ecause I
> > am a fan of pre-faulting, I think the semantics are bad.
>=20
> Ok, fair enough. I wanted to do the once-only test in common code but sin=
ce
> SEV code checks for the RMP I can remove that. One less headache.

I definitely don't object to having a check in common code, and I'd be in f=
avor
of removing the RMP checks if possible, but tracking needs to be something =
more
explicit in guest_memfd.

*sigh*

I even left behind a TODO for this exact thing, and y'all didn't even wave =
at it
as you flew by :-)

        /*
         * Use the up-to-date flag to track whether or not the memory has b=
een
         * zeroed before being handed off to the guest.  There is no backin=
g
         * storage for the memory, so the folio will remain up-to-date unti=
l
         * it's removed.
         *
         * TODO: Skip clearing pages when trusted firmware will do it when =
 <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
         * assigning memory to the guest.
         */
        if (!folio_test_uptodate(folio)) {
                unsigned long nr_pages =3D folio_nr_pages(folio);
                unsigned long i;

                for (i =3D 0; i < nr_pages; i++)
                        clear_highpage(folio_page(folio, i));

                folio_mark_uptodate(folio);
        }

        if (prepare) {
                int r =3D kvm_gmem_prepare_folio(inode, index, folio);
                if (r < 0) {
                        folio_unlock(folio);
                        folio_put(folio);
                        return ERR_PTR(r);
                }
        }

Compile tested only (and not even fully as I didn't bother defining
CONFIG_HAVE_KVM_GMEM_INITIALIZE), but I think this is the basic gist.

8< --------------------------------

// SPDX-License-Identifier: GPL-2.0
#include <linux/backing-dev.h>
#include <linux/falloc.h>
#include <linux/kvm_host.h>
#include <linux/pagemap.h>
#include <linux/anon_inodes.h>

#include "kvm_mm.h"

struct kvm_gmem {
	struct kvm *kvm;
	struct xarray bindings;
	struct list_head entry;
};

static int kvm_gmem_initialize_folio(struct kvm *kvm, struct folio *folio,
				     pgoff_t index, void __user *src,
				     void *opaque)
{
#ifdef CONFIG_HAVE_KVM_GMEM_INITIALIZE
	return kvm_arch_gmem_initialize(kvm, folio, index, src, opaque);
#else
	unsigned long nr_pages =3D folio_nr_pages(folio);
	unsigned long i;

	if (WARN_ON_ONCE(src))
		return -EIO;

	for (i =3D 0; i < nr_pages; i++)
		clear_highpage(folio_file_page(folio, index + i));
#endif
	return 0;
}


static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
{
	return gfn - slot->base_gfn + slot->gmem.pgoff;
}


static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
{
	/*
	 * Do not return slot->gmem.file if it has already been closed;
	 * there might be some time between the last fput() and when
	 * kvm_gmem_release() clears slot->gmem.file, and you do not
	 * want to spin in the meanwhile.
	 */
	return get_file_active(&slot->gmem.file);
}

static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t inde=
x)
{
	fgf_t fgp_flags =3D FGP_LOCK | FGP_ACCESSED | FGP_CREAT;
	struct folio *folio;

	/*
	 * The caller is responsible for managing the up-to-date flag (or not),
	 * as the memory doesn't need to be initialized until it's actually
	 * mapped into the guest.  Waiting to initialize memory is necessary
	 * for VM types where the memory can be initialized exactly once.
	 *
	 * Ignore accessed, referenced, and dirty flags.  The memory is
	 * unevictable and there is no storage to write back to.
	 *
	 * TODO: Support huge pages.
	 */
	folio =3D __filemap_get_folio(inode->i_mapping, index, fgp_flags,
				    mapping_gfp_mask(inode->i_mapping));

	if (folio_test_hwpoison(folio)) {
		folio_unlock(folio);
		return ERR_PTR(-EHWPOISON);
	}
	return folio;
}

static struct folio *kvm_gmem_get_folio(struct file *file,
					struct kvm_memory_slot *slot,
					gfn_t gfn)
{
	pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
	struct kvm_gmem *gmem =3D file->private_data;
	struct inode *inode;

	if (file !=3D slot->gmem.file) {
		WARN_ON_ONCE(slot->gmem.file);
		return ERR_PTR(-EFAULT);
	}

	gmem =3D file->private_data;
	if (xa_load(&gmem->bindings, index) !=3D slot) {
		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
		return ERR_PTR(-EIO);
	}

	inode =3D file_inode(file);

	/*
	 * The caller is responsible for managing the up-to-date flag (or not),
	 * as the memory doesn't need to be initialized until it's actually
	 * mapped into the guest.  Waiting to initialize memory is necessary
	 * for VM types where the memory can be initialized exactly once.
	 *
	 * Ignore accessed, referenced, and dirty flags.  The memory is
	 * unevictable and there is no storage to write back to.
	 *
	 * TODO: Support huge pages.
	 */
	return __kvm_gmem_get_folio(inode, index);
}

int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
{
	pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
	struct file *file =3D kvm_gmem_get_file(slot);
	struct folio *folio;
	struct page *page;

	if (!file)
		return -EFAULT;

	folio =3D kvm_gmem_get_folio(file, slot, gfn);
	if (IS_ERR(folio))
		goto out;

	if (!folio_test_uptodate(folio)) {
		kvm_gmem_initialize_folio(kvm, folio, index, NULL, NULL);
		folio_mark_uptodate(folio);
	}

	page =3D folio_file_page(folio, index);

	*pfn =3D page_to_pfn(page);
	if (max_order)
		*max_order =3D 0;

out:
	fput(file);
	return IS_ERR(folio) ? PTR_ERR(folio) : 0;
}
EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);

long kvm_gmem_populate(struct kvm *kvm, gfn_t base_gfn, void __user *base_s=
rc,
		       long npages, void *opaque)
{
	struct kvm_memory_slot *slot;
	struct file *file;
	int ret =3D 0, max_order;
	long i;

	lockdep_assert_held(&kvm->slots_lock);
	if (npages < 0)
		return -EINVAL;

	slot =3D gfn_to_memslot(kvm, base_gfn);
	if (!kvm_slot_can_be_private(slot))
		return -EINVAL;

	file =3D kvm_gmem_get_file(slot);
	if (!file)
		return -EFAULT;

	filemap_invalidate_lock(file->f_mapping);

	npages =3D min_t(ulong, slot->npages - (base_gfn - slot->base_gfn), npages=
);
	for (i =3D 0; i < npages; i +=3D (1 << max_order)) {
		void __user *src =3D base_src + i * PAGE_SIZE;
		gfn_t gfn =3D base_gfn + i;
		pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
		struct folio *folio;

		folio =3D kvm_gmem_get_folio(file, slot, gfn);
		if (IS_ERR(folio)) {
			ret =3D PTR_ERR(folio);
			break;
		}

		if (folio_test_uptodate(folio)) {
			folio_put(folio);
			ret =3D -EEXIST;
			break;
		}

		kvm_gmem_initialize_folio(kvm, folio, index, src, opaque);
		folio_unlock(folio);
		folio_put(folio);
	}

	filemap_invalidate_unlock(file->f_mapping);

	fput(file);
	return ret && !i ? ret : i;
}
EXPORT_SYMBOL_GPL(kvm_gmem_populate);

static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
				      pgoff_t end)
{
	bool flush =3D false, found_memslot =3D false;
	struct kvm_memory_slot *slot;
	struct kvm *kvm =3D gmem->kvm;
	unsigned long index;

	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
		pgoff_t pgoff =3D slot->gmem.pgoff;

		struct kvm_gfn_range gfn_range =3D {
			.start =3D slot->base_gfn + max(pgoff, start) - pgoff,
			.end =3D slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
			.slot =3D slot,
			.may_block =3D true,
		};

		if (!found_memslot) {
			found_memslot =3D true;

			KVM_MMU_LOCK(kvm);
			kvm_mmu_invalidate_begin(kvm);
		}

		flush |=3D kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
	}

	if (flush)
		kvm_flush_remote_tlbs(kvm);

	if (found_memslot)
		KVM_MMU_UNLOCK(kvm);
}

static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
				    pgoff_t end)
{
	struct kvm *kvm =3D gmem->kvm;

	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
		KVM_MMU_LOCK(kvm);
		kvm_mmu_invalidate_end(kvm);
		KVM_MMU_UNLOCK(kvm);
	}
}

static long __kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_=
t len)
{
	struct list_head *gmem_list =3D &inode->i_mapping->i_private_list;
	pgoff_t start =3D offset >> PAGE_SHIFT;
	pgoff_t end =3D (offset + len) >> PAGE_SHIFT;
	struct kvm_gmem *gmem;
	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_begin(gmem, start, end);

	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);

	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_end(gmem, start, end);

	return 0;
}

static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t =
len)
{
	int r;

	/*
	 * Bindings must be stable across invalidation to ensure the start+end
	 * are balanced.
	 */
	filemap_invalidate_lock(inode->i_mapping);
	r =3D __kvm_gmem_punch_hole(inode, offset, len);
	filemap_invalidate_unlock(inode->i_mapping);
	return r;
}

static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t le=
n)
{
	struct address_space *mapping =3D inode->i_mapping;
	pgoff_t start, index, end;
	int r;

	/* Dedicated guest is immutable by default. */
	if (offset + len > i_size_read(inode))
		return -EINVAL;

	filemap_invalidate_lock_shared(mapping);

	start =3D offset >> PAGE_SHIFT;
	end =3D (offset + len) >> PAGE_SHIFT;

	r =3D 0;
	for (index =3D start; index < end; ) {
		struct folio *folio;

		if (signal_pending(current)) {
			r =3D -EINTR;
			break;
		}

		folio =3D __kvm_gmem_get_folio(inode, index);
		if (IS_ERR(folio)) {
			r =3D PTR_ERR(folio);
			break;
		}

		index =3D folio_next_index(folio);

		folio_unlock(folio);
		folio_put(folio);

		/* 64-bit only, wrapping the index should be impossible. */
		if (WARN_ON_ONCE(!index))
			break;

		cond_resched();
	}

	filemap_invalidate_unlock_shared(mapping);

	return r;
}

static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
			       loff_t len)
{
	int ret;

	if (!(mode & FALLOC_FL_KEEP_SIZE))
		return -EOPNOTSUPP;

	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
		return -EOPNOTSUPP;

	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
		return -EINVAL;

	if (mode & FALLOC_FL_PUNCH_HOLE)
		ret =3D kvm_gmem_punch_hole(file_inode(file), offset, len);
	else
		ret =3D kvm_gmem_allocate(file_inode(file), offset, len);

	if (!ret)
		file_modified(file);
	return ret;
}

static int kvm_gmem_release(struct inode *inode, struct file *file)
{
	struct kvm_gmem *gmem =3D file->private_data;
	struct kvm_memory_slot *slot;
	struct kvm *kvm =3D gmem->kvm;
	unsigned long index;

	/*
	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
	 * reference to the file and thus no new bindings can be created, but
	 * dereferencing the slot for existing bindings needs to be protected
	 * against memslot updates, specifically so that unbind doesn't race
	 * and free the memslot (kvm_gmem_get_file() will return NULL).
	 */
	mutex_lock(&kvm->slots_lock);

	filemap_invalidate_lock(inode->i_mapping);

	xa_for_each(&gmem->bindings, index, slot)
		rcu_assign_pointer(slot->gmem.file, NULL);

	synchronize_rcu();

	/*
	 * All in-flight operations are gone and new bindings can be created.
	 * Zap all SPTEs pointed at by this file.  Do not free the backing
	 * memory, as its lifetime is associated with the inode, not the file.
	 */
	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
	kvm_gmem_invalidate_end(gmem, 0, -1ul);

	list_del(&gmem->entry);

	filemap_invalidate_unlock(inode->i_mapping);

	mutex_unlock(&kvm->slots_lock);

	xa_destroy(&gmem->bindings);
	kfree(gmem);

	kvm_put_kvm(kvm);

	return 0;
}

static struct file_operations kvm_gmem_fops =3D {
	.open		=3D generic_file_open,
	.release	=3D kvm_gmem_release,
	.fallocate	=3D kvm_gmem_fallocate,
};

void kvm_gmem_init(struct module *module)
{
	kvm_gmem_fops.owner =3D module;
}

static int kvm_gmem_migrate_folio(struct address_space *mapping,
				  struct folio *dst, struct folio *src,
				  enum migrate_mode mode)
{
	WARN_ON_ONCE(1);
	return -EINVAL;
}

static int kvm_gmem_error_folio(struct address_space *mapping, struct folio=
 *folio)
{
	struct list_head *gmem_list =3D &mapping->i_private_list;
	struct kvm_gmem *gmem;
	pgoff_t start, end;

	filemap_invalidate_lock_shared(mapping);

	start =3D folio->index;
	end =3D start + folio_nr_pages(folio);

	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_begin(gmem, start, end);

	/*
	 * Do not truncate the range, what action is taken in response to the
	 * error is userspace's decision (assuming the architecture supports
	 * gracefully handling memory errors).  If/when the guest attempts to
	 * access a poisoned page, kvm_gmem_get_pfn() will return -EHWPOISON,
	 * at which point KVM can either terminate the VM or propagate the
	 * error to userspace.
	 */

	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_end(gmem, start, end);

	filemap_invalidate_unlock_shared(mapping);

	return MF_DELAYED;
}

#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
static void kvm_gmem_free_folio(struct folio *folio)
{
	struct page *page =3D folio_page(folio, 0);
	kvm_pfn_t pfn =3D page_to_pfn(page);
	int order =3D folio_order(folio);

	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
}
#endif

static const struct address_space_operations kvm_gmem_aops =3D {
	.dirty_folio =3D noop_dirty_folio,
	.migrate_folio	=3D kvm_gmem_migrate_folio,
	.error_remove_folio =3D kvm_gmem_error_folio,
#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
	.free_folio =3D kvm_gmem_free_folio,
#endif
};

static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *pat=
h,
			    struct kstat *stat, u32 request_mask,
			    unsigned int query_flags)
{
	struct inode *inode =3D path->dentry->d_inode;

	generic_fillattr(idmap, request_mask, inode, stat);
	return 0;
}

static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
			    struct iattr *attr)
{
	return -EINVAL;
}
static const struct inode_operations kvm_gmem_iops =3D {
	.getattr	=3D kvm_gmem_getattr,
	.setattr	=3D kvm_gmem_setattr,
};

static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
{
	const char *anon_name =3D "[kvm-gmem]";
	struct kvm_gmem *gmem;
	struct inode *inode;
	struct file *file;
	int fd, err;

	fd =3D get_unused_fd_flags(0);
	if (fd < 0)
		return fd;

	gmem =3D kzalloc(sizeof(*gmem), GFP_KERNEL);
	if (!gmem) {
		err =3D -ENOMEM;
		goto err_fd;
	}

	file =3D anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
					 O_RDWR, NULL);
	if (IS_ERR(file)) {
		err =3D PTR_ERR(file);
		goto err_gmem;
	}

	file->f_flags |=3D O_LARGEFILE;

	inode =3D file->f_inode;
	WARN_ON(file->f_mapping !=3D inode->i_mapping);

	inode->i_private =3D (void *)(unsigned long)flags;
	inode->i_op =3D &kvm_gmem_iops;
	inode->i_mapping->a_ops =3D &kvm_gmem_aops;
	inode->i_mapping->flags |=3D AS_INACCESSIBLE;
	inode->i_mode |=3D S_IFREG;
	inode->i_size =3D size;
	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
	mapping_set_unmovable(inode->i_mapping);
	/* Unmovable mappings are supposed to be marked unevictable as well. */
	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));

	kvm_get_kvm(kvm);
	gmem->kvm =3D kvm;
	xa_init(&gmem->bindings);
	list_add(&gmem->entry, &inode->i_mapping->i_private_list);

	fd_install(fd, file);
	return fd;

err_gmem:
	kfree(gmem);
err_fd:
	put_unused_fd(fd);
	return err;
}

int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
{
	loff_t size =3D args->size;
	u64 flags =3D args->flags;
	u64 valid_flags =3D 0;

	if (flags & ~valid_flags)
		return -EINVAL;

	if (size <=3D 0 || !PAGE_ALIGNED(size))
		return -EINVAL;

	return __kvm_gmem_create(kvm, size, flags);
}

int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
		  unsigned int fd, loff_t offset)
{
	loff_t size =3D slot->npages << PAGE_SHIFT;
	unsigned long start, end;
	struct kvm_gmem *gmem;
	struct inode *inode;
	struct file *file;
	int r =3D -EINVAL;

	BUILD_BUG_ON(sizeof(gfn_t) !=3D sizeof(slot->gmem.pgoff));

	file =3D fget(fd);
	if (!file)
		return -EBADF;

	if (file->f_op !=3D &kvm_gmem_fops)
		goto err;

	gmem =3D file->private_data;
	if (gmem->kvm !=3D kvm)
		goto err;

	inode =3D file_inode(file);

	if (offset < 0 || !PAGE_ALIGNED(offset) ||
	    offset + size > i_size_read(inode))
		goto err;

	filemap_invalidate_lock(inode->i_mapping);

	start =3D offset >> PAGE_SHIFT;
	end =3D start + slot->npages;

	if (!xa_empty(&gmem->bindings) &&
	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
		filemap_invalidate_unlock(inode->i_mapping);
		goto err;
	}

	/*
	 * No synchronize_rcu() needed, any in-flight readers are guaranteed to
	 * be see either a NULL file or this new file, no need for them to go
	 * away.
	 */
	rcu_assign_pointer(slot->gmem.file, file);
	slot->gmem.pgoff =3D start;

	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
	filemap_invalidate_unlock(inode->i_mapping);

	/*
	 * Drop the reference to the file, even on success.  The file pins KVM,
	 * not the other way 'round.  Active bindings are invalidated if the
	 * file is closed before memslots are destroyed.
	 */
	r =3D 0;
err:
	fput(file);
	return r;
}

void kvm_gmem_unbind(struct kvm_memory_slot *slot)
{
	unsigned long start =3D slot->gmem.pgoff;
	unsigned long end =3D start + slot->npages;
	struct kvm_gmem *gmem;
	struct file *file;

	/*
	 * Nothing to do if the underlying file was already closed (or is being
	 * closed right now), kvm_gmem_release() invalidates all bindings.
	 */
	file =3D kvm_gmem_get_file(slot);
	if (!file)
		return;

	gmem =3D file->private_data;

	filemap_invalidate_lock(file->f_mapping);
	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
	rcu_assign_pointer(slot->gmem.file, NULL);
	synchronize_rcu();
	filemap_invalidate_unlock(file->f_mapping);

	fput(file);
}


