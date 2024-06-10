Return-Path: <kvm+bounces-19268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA06902C8F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 733DC1C2177D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 23:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6A3152533;
	Mon, 10 Jun 2024 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nLCZN5Ju"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276762110F
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 23:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718062856; cv=none; b=ZuVPlS9xKPtRTwUvJZDFgOXodD/3uOSK93D8M/x7tOXCImLgwgEbECErdlTaX0XKNjqOqDhXCUaHexO+bkDrVZewSd9aBnkWRRn+oEkTBNGvyxRMo7qB51xXmAraEuEZIzbuLk2X47/N7vHBuWpyWBHF4PrSMnNgmhDnDWCge+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718062856; c=relaxed/simple;
	bh=az8iAxY1+IX8BluLFMbVS7wpU2m8WrFvmMATqq5V84E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nA+9YeZr23YmKPup0quNO9tbZ0T9vrJqWPbsdQgq9Sxc45wlbXKxc7Aa5KKbv5350/jJ/YtDsxdH0sz9jfxC1dCvPxwzzUPS5gH07I6bPiffDzk+voFQpwST6uIScOZCcCPbDTfXqLaedDATTlHaaz8sNm5JaQ/R/pM4kJOiGRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nLCZN5Ju; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-681877855adso4130439a12.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718062854; x=1718667654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0zaitEACw+zYcor2/0Rz63A8WWn/XjClt8MhVkc46Y=;
        b=nLCZN5Ju+6AUxoZytuEEQXuKGR8RQKZT7MZ/agBSpjTVDm90ya1fvy8QzdfWQFBH1r
         0NbM3TtEBvq2xy46SZPng+LSWMB/Eha7NQms6fUgudiK07nlQ+5ndyWi+Jerz9pwZk++
         TMXGOHyvx2hLXydbm1KcbcPH3YgMuFUeYfUSHUCr+5W7tqtt+s0IdqPiKy4rpeLaRMih
         cFYzQwsDyHw2bGIrsm2zYZ9XRo0IAXjD2LulOtuhfDjPmn2BryLZ6sZUhoyTMUWtCUtM
         lQbTwuiYEZ0HyHP8YbzDcW1FkO/pkBus0F8riVm0eYakzMSRRe6KJJ9jVRKko3e7Wbts
         DywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718062854; x=1718667654;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w0zaitEACw+zYcor2/0Rz63A8WWn/XjClt8MhVkc46Y=;
        b=KR/PBoUO7emb0Pvr4/euVEmKcyjdqxN6DG3vXo4S6yCfukNsHutFrT811bM6eQc+a5
         rfHMGd0M58BTwdlD3apNK0K9bFe9V0+bcduD0Yi5iuWcWFrnb7K2KX7QIrGUh2NqP4Xv
         PG0pJCjI1VegC41azDwXyI13KMzDXiehd6iKD6Cz1+N107Vo2mQX0X25mN8WE61pDAIJ
         O/KIdTTHXPc8Qa6zN500sw6hpFumsrUYF9KreLe+0vIRRQOUtho9zSWK012Hq98qSo/i
         w4/i6t1zOmE01kylxS+cxHneuGCVNZaJfdxFFUjjfX4rGxBOmeDn436gCyhcamBocz6f
         vN4A==
X-Forwarded-Encrypted: i=1; AJvYcCW2UliXe0odb8528468xtqFuGEmsvw1K7u9U2XuLfPhyrCe4dcNjJYUtxC9aKTALiUWsdwydL43NmOYfsLzgAMYvE7B
X-Gm-Message-State: AOJu0YxHIPxKV62QGs2RIQs+NA5itzQiLURfCxeGA9EC/c3UCZR+xB8M
	Fjo74+63izMuR/k7pMQg0reRzU4C7Fyn1/YL4LVKa6I/oDX6Sa3F/BRaHGk0tDsOQCGJNJtx87l
	7mg==
X-Google-Smtp-Source: AGHT+IHn3PVo41lnRCr7yJNb++zw7O+lmmijXcsB4djuICc4as6iKySBrYpuSDDjxEXLbtREqHnQRFzq5ug=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:482:b0:6e5:ef07:5922 with SMTP id
 41be03b00d2f7-6e5ef075a4cmr24462a12.1.1718062854162; Mon, 10 Jun 2024
 16:40:54 -0700 (PDT)
Date: Mon, 10 Jun 2024 16:40:52 -0700
In-Reply-To: <de1b0bbc-b781-4372-88ad-81f26c9152c2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423235013.GO3596705@ls.amr.corp.intel.com>
 <ZimGulY6qyxt6ylO@google.com> <20240425011248.GP3596705@ls.amr.corp.intel.com>
 <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
 <Zip-JsAB5TIRDJVl@google.com> <CABgObfaxAd_J5ufr+rOcND=-NWrOzVsvavoaXuFw_cwDd+e9aA@mail.gmail.com>
 <ZivFbu0WI4qx8zre@google.com> <ZmORqYFhE73AdQB6@google.com>
 <CABgObfYD+RaLwGgC_nhkP81OMy3-NvLVqu9MKFM3LcNzc7MCow@mail.gmail.com> <de1b0bbc-b781-4372-88ad-81f26c9152c2@redhat.com>
Message-ID: <ZmeOxAtwfTsDCi1x@google.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024, Paolo Bonzini wrote:
> On 6/10/24 23:48, Paolo Bonzini wrote:
> > On Sat, Jun 8, 2024 at 1:03=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > SNP folks and/or Paolo, what's the plan for this?  I don't see how wh=
at's sitting
> > > in kvm/next can possibly be correct without conditioning population o=
n the folio
> > > being !uptodate.
> >=20
> > I don't think I have time to look at it closely until Friday; but
> > thanks for reminding me.
>=20
> Ok, I'm officially confused.  I think I understand what you did in your
> suggested code.  Limiting it to the bare minimum (keeping the callback
> instead of CONFIG_HAVE_KVM_GMEM_INITIALIZE) it would be something
> like what I include at the end of the message.
>=20
> But the discussion upthread was about whether to do the check for
> RMP state in sev.c, or do it in common code using folio_mark_uptodate().
> I am not sure what you mean by "cannot possibly be correct", and
> whether it's referring to kvm_gmem_populate() in general or the
> callback in sev_gmem_post_populate().

Doing fallocate() before KVM_SEV_SNP_LAUNCH_UPDATE will cause the latter to=
 fail.
That likely works for QEMU, at least for now, but it's unnecessarily restri=
ctive
and IMO incorrect/wrong.

E.g. a more convoluted, fallocate() + PUNCH_HOLE + KVM_SEV_SNP_LAUNCH_UPDAT=
E will
work (I think?  AFAICT adding and removing pages directly to/from the RMP d=
oesn't
affect SNP's measurement, only pages that are added via SNP_LAUNCH_UPDATE a=
ffect
the measurement).

Punting the sanity check to vendor code is also gross and will make it hard=
er to
provide a consistent, unified ABI for all architectures.  E.g. SNP returns =
-EINVAL
if the page is already assigned, which is quite misleading.

> The change below looks like just an optimization to me, which
> suggests that I'm missing something glaring.

I really dislike @prepare.  There are two paths that should actually initia=
lize
the contents of the folio, and they are mutually exclusive and have meaning=
fully
different behavior.  Faulting in memory via kvm_gmem_get_pfn() explicitly z=
eros
the folio _if necessary_, whereas kvm_gmem_populate() initializes the folio=
 with
user-provided data _and_ requires that the folio be !uptodate.

If we fix the above oddity where fallocate() initializes memory, then there=
's
no need to try and handle the initialization in a common chokepoint as the =
two
relevant paths will naturally have unique code.

The below is also still suboptimal for TDX, as KVM will zero the memory and=
 then
TDX-module will also zero memory on PAGE.AUGA.

And I find SNP to be the odd one.  IIUC, the ASP (the artist formerly known=
 as
the PSP) doesn't provide any guarantees about the contents of a page that i=
s
assigned to a guest without bouncing through SNP_LAUNCH_UPDATE.  It'd be ni=
ce to
explicitly document that somewhere in the SNP code. E.g. if guest_memfd inv=
okes
a common kvm_gmem_initialize_folio() or whatever, then SNP's implementation=
 can
clearly capture that KVM zeros the page to protect the _host_ data.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d4206e53a9c81..a0417ef5b86eb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -52,37 +52,39 @@ static int kvm_gmem_prepare_folio(struct inode *inode=
, pgoff_t index, struct fol
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t ind=
ex, bool prepare)
>  {
>  	struct folio *folio;
> +	int r;
>  	/* TODO: Support huge pages. */
>  	folio =3D filemap_grab_folio(inode->i_mapping, index);
>  	if (IS_ERR(folio))
>  		return folio;
> -	/*
> -	 * Use the up-to-date flag to track whether or not the memory has been
> -	 * zeroed before being handed off to the guest.  There is no backing
> -	 * storage for the memory, so the folio will remain up-to-date until
> -	 * it's removed.
> -	 *
> -	 * TODO: Skip clearing pages when trusted firmware will do it when
> -	 * assigning memory to the guest.
> -	 */
> -	if (!folio_test_uptodate(folio)) {
> -		unsigned long nr_pages =3D folio_nr_pages(folio);
> -		unsigned long i;
> +	if (prepare) {
> +		/*
> +		 * Use the up-to-date flag to track whether or not the memory has
> +		 * been handed off to the guest.  There is no backing storage for
> +		 * the memory, so the folio will remain up-to-date until it's
> +		 * removed.
> +		 *
> +		 * Take the occasion of the first prepare operation to clear it.
> +		 */
> +		if (!folio_test_uptodate(folio)) {
> +			unsigned long nr_pages =3D folio_nr_pages(folio);
> +			unsigned long i;
> -		for (i =3D 0; i < nr_pages; i++)
> -			clear_highpage(folio_page(folio, i));
> +			for (i =3D 0; i < nr_pages; i++)
> +				clear_highpage(folio_page(folio, i));
> +		}
> +
> +		r =3D kvm_gmem_prepare_folio(inode, index, folio);
> +		if (r < 0)
> +			goto err_unlock_put;
>  		folio_mark_uptodate(folio);
> -	}
> -
> -	if (prepare) {
> -		int r =3D	kvm_gmem_prepare_folio(inode, index, folio);
> -		if (r < 0) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			return ERR_PTR(r);
> +	} else {
> +		if (folio_test_uptodate(folio)) {
> +			r =3D -EEXIST;
> +			goto err_unlock_put;
>  		}
>  	}

