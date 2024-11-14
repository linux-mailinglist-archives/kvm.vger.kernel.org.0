Return-Path: <kvm+bounces-31832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A384A9C801D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 02:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 684F42817F1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A219F1E3DF2;
	Thu, 14 Nov 2024 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sswXhWm9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5B01CD1EA
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731548516; cv=none; b=tSLrkBryfNGTOE0qhtGJEXKPyBscnT/mckfm1kxHNVSBmR2tQN4YbXNGZSCKzWNguZTOh8USsAPftRat7BAR+8oe9X7rW199VpMxxRXzVHSYskJHo/SWo69l8PCUODG+6YahoiWduiSFkwS9rrmKS1e0Fe6kKkwpfKTK4x+ZVIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731548516; c=relaxed/simple;
	bh=sCZijQldNddnJqIRYCxQ+IuTp4D+2BMidbKlbBsoKU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IYE0Y9FN9bsHIa3AKJ+iy96s5H6UxFW1Odv9lY+/5BUvkG2YpwDQQO4UlRrwg01VmNoEVIymno0PsynE7ZiUmpbAS5+QpXrGtctbhEFiWZfvHEh7hAiXclwmYIdh8+uqhoP/9CF71ueBzag4rMDsqWjIjW5VkZ1Gh4oRmEFO8ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sswXhWm9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e35e0e88973so98314276.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 17:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731548514; x=1732153314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2IQEQSrvxNS5k9+sCTXCAkRA5erN7PfoAPhF92B1Jgs=;
        b=sswXhWm9oj1o5kCKsFPz5UYtad0tnhQvjkO46kUG8GyvZF03rUy7ALQhVmQryMMaAQ
         3O7vLcmex7306kElD6Mn/m+6I1CnOrYASe5+XZrXE7hrGSGZyh/ipuxtgOWdKThpRlYS
         RsbwtMOH3/B58Mvgz7HuVxofi940nrC0kqunmYJM7b1u4kEBiACDQfE0S/O+Tl/O4UZO
         xB9It/clTaSz2zG3CCdV9t5GDPHOJ7FKSqklTQmh5078HrUE5K/e9vf5MlSHO23/EQwO
         LDogtnpeFpwlDKlMvOd2lrm8DGr+/LxqKUyUcFyRZxd3cIdHbsm6GfqAAKvA79DVcMWO
         9TZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731548514; x=1732153314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2IQEQSrvxNS5k9+sCTXCAkRA5erN7PfoAPhF92B1Jgs=;
        b=UYdXilQp6fYHGrzD6E1t8Vnn3kxuA5BmLfFOkQ4gGkQvWJGYfQ5ESWnxcKCW8LzWEK
         9Nyz9acU3KdfL2stF9nOpupPQ0ych4Mop9jSKnpUzSSqXEmOEmz3QDYtk1pZzkn/82bC
         I7jzvtOxpXgq1wHXzsh0UPP8E5VG79eJCNA6XsvoeLVEKVmuIqaWAauvKDoE47Jqsu0D
         JvCBXujDgV+/iQPI/7zfoeII8ruroaVLw6DuPfOAmlGDq12DnlW90FsPYOjPwYpx2NFJ
         K8zPOKwMW5vQk09lu8lpwfL6JI7/NsuOEviZvHIQ+9C7yC/Lz0fTyf6u/qQBgx1oGWlA
         gVBA==
X-Forwarded-Encrypted: i=1; AJvYcCWneHTboelH2W188km5sw6JSre/DtiDNzMFYzyZvxOHk7Leims+QTSFLpgcbmLF7Xphyzo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtcLjbJG5MNd3arNmPaDakQrVrc6NcEYfheLjtwjT2+Pbtk6wp
	8brnoaFE0Rs1K8Azj8Gv1j8/vYicNS3AsrzuxQ2wJXmicIuFv2T9jmn5bf2WjNu1gmZ7s8dr6U6
	UxQ==
X-Google-Smtp-Source: AGHT+IFCHdEssTyN26kbPfUSHvKtSB8lshflrEHG+IPNc3pgDCqXhZe7d0YTYBYAVNK7FHjN3BPlIjwRdJA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:6888:0:b0:e29:9c5:5fcb with SMTP id
 3f1490d57ef6-e380e241492mr35279276.4.1731548514280; Wed, 13 Nov 2024 17:41:54
 -0800 (PST)
Date: Wed, 13 Nov 2024 17:41:52 -0800
In-Reply-To: <ZzVTDCwLTMB_fagq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108155056.332412-1-pbonzini@redhat.com> <20241108155056.332412-4-pbonzini@redhat.com>
 <ZzVTDCwLTMB_fagq@google.com>
Message-ID: <ZzVVYCNFkH3cpGY-@google.com>
Subject: Re: [PATCH 3/3] KVM: gmem: track preparedness a page at a time
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 13, 2024, Sean Christopherson wrote:
> On Fri, Nov 08, 2024, Paolo Bonzini wrote:
> >  static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, struct folio *folio)
> >  {
> > -	folio_mark_uptodate(folio);
> > +	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)file->f_inode->i_private;
> > +	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
> > +	unsigned long npages = folio_nr_pages(folio);
> > +
> > +	/* Folios must be naturally aligned */
> > +	WARN_ON_ONCE(index & (npages - 1));
> > +	index &= ~(npages - 1);
> > +
> > +	/* Clear page before updating bitmap.  */
> > +	smp_wmb();
> > +
> > +	if (npages < BITS_PER_LONG) {
> > +		bitmap_set_atomic_word(p, index, npages);
> > +	} else {
> > +		BUILD_BUG_ON(BITS_PER_LONG != 64);
> > +		memset64((u64 *)p, ~0, BITS_TO_LONGS(npages));
> 
> More code that could be deduplicated (unprepared path below).
> 
> But more importantly, I'm pretty sure the entire lockless approach is unsafe.
> 
> Callers of kvm_gmem_get_pfn() do not take any locks that protect kvm_gmem_mark_prepared()
> from racing with kvm_gmem_mark_range_unprepared().  kvm_mmu_invalidate_begin()
> prevents KVM from installing a stage-2 mapping, i.e. from consuming the PFN, but
> it doesn't prevent kvm_gmem_mark_prepared() from being called.  And
> sev_handle_rmp_fault() never checks mmu_notifiers, which is probably fine?  But
> sketchy.
> 
> Oof.  Side topic.  sev_handle_rmp_fault() is suspect for other reasons.  It does
> its own lookup of the PFN, and so could see an entirely different PFN than was
> resolved by kvm_mmu_page_fault().  And thanks to KVM's wonderful 0/1/-errno
> behavior, sev_handle_rmp_fault() is invoked even when KVM wants to retry the
> fault, e.g. due to an active MMU invalidation.
> 
> Anyways, KVM wouldn't _immediately_ consume bad data, as the invalidation
> would block the current page fault.  But clobbering i_gmem->prepared would result
> in a missed "prepare" phase if the hole-punch region were restored.
> 
> One idea would be to use a rwlock to protect updates to the bitmap (setters can
> generally stomp on each other).  And to avoid contention whenever possible in
> page fault paths, only take the lock if the page is not up-to-date, because again
> kvm_mmu_invalidate_{begin,end}() protects against UAF, it's purely updates to the
> bitmap that need extra protection.

Actually, there's no point in having a rwlock, because readers are serialized on
the folio's lock.  And KVM absolutely relies on that already, because otherwise
multiple vCPUs could see an unprepared folio, and clear_highpage() could end up
racing with writes from the vCPU.

> Note, using is mmu_invalidate_retry_gfn() is unsafe, because it must be called
> under mmu_lock to ensure it doesn't get false negatives.

