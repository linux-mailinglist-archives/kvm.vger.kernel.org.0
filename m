Return-Path: <kvm+bounces-65235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C93CA0BC2
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E2BE33002500
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 18:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AD6341056;
	Wed,  3 Dec 2025 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pb9hld4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2033F388
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764784898; cv=none; b=kNA9j3rEU097I2MnQEE/uPgAwEo40ZwhBtEZWBXKSM3BW4nqtNtZywBoY/fgrVJdi5jCbDUj1gh0+VejYe0Z/B2O/QgNKZtpO1xJH+ei0eaxVw2CmknXVvrfnLDPCVI94zMiFV9aY57md8w8OUuCDEUTmMFFpLr0ibpR06TM+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764784898; c=relaxed/simple;
	bh=7gZgN4hUIvhIVsPl0mwoLPCQC2w0HuG8muQomyUiL8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ARrmsdv2AshOyYozOe154zO4gn23XPqHs5LeBn7zOPXeJGhWFgC4sto9LAh27SgOaOAFEwKGEVjnBn1mZJho5MXe8DdkKMEtk4rLeK2P7IkBZJyO3VKEEOcqgu8g3AshbQdz23HmRolBTUJzrHPzilkgzDXW4TnlcmHqotIZLV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pb9hld4Z; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-645ed666eceso312a12.1
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 10:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764784895; x=1765389695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQ4P8LC+51Vcj7CKWx2AULySwQLuwp7ItbWzoUGLq3c=;
        b=pb9hld4Zs4YGntjad/9YcY8BdpF/ldVMD46pne3LDGjcIigpa8tTBLU7VB80RdfPx2
         XWQMisrLUMDMBhSi4NZbWv8wk9ZjQo8zgRp7IuTWoniFUIcuIigiESvSYGadDycWUpqT
         DmiW9t2TbDTPj7LBUm9togDbSP8HHXOFXMMKqUMCAop4ITKbkGmFIzvNaV+bctl5XyEJ
         KNiu9bCqkZadXbawfQ2IGHbDaS+1pKI1sz9kMAnGcABIoEspRNggA1k/CPAK9kMF2NZa
         rAhFe8njleDAb3ERhYWS5uLblOsNfjl1hnUP6g7u/tmUjevEXAqF5q2cW33jZ3Cgfdih
         T9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784895; x=1765389695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oQ4P8LC+51Vcj7CKWx2AULySwQLuwp7ItbWzoUGLq3c=;
        b=XP+V2lppoghQHpVY5sA5q8cayHhD+PaROWhDU1DAU+2ePQN+x2J6NwzbLI6m9+Rv+2
         VzeHTg/tR4rvEtvA72sdeYJPPcewQTYjd9Gv56rFluEPXqSe2A9wTc+2JimDvtuEwxdt
         mR5qLLtb2C4xzivemtKtExjs2z9Zkd/uc6SjKpEodtcWFJA6UpCYqaMxMTeSblrb9n6A
         sYlK9BDIY9BAbm0mPq6teHat8aX1Clv4ZibADrZx/GfUqoY9PE9TIW/1dc0wbg+Vu+QH
         0Egx3uD7Vi57Z1z4HwuIu10j2QfrF0TUyCLYfmrlbAULmdQtRb2853QLxhBlX8hjTPng
         vmKA==
X-Forwarded-Encrypted: i=1; AJvYcCXS+UEJ7rzT20KVCqrZI0SPMHCsdatiqBCtCuCJk/gLNE2lLzIu4mnTkkDC8MOFfaC4+lM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx54gnRzMuexbcjEDwaoT4A1FwLYMvJQVm6eHT3QSbh50YeXcrg
	9ltCAgG0OyPiNuzH6aavk1AjoUMVvFSHS+oBMTlLYygnMEjkbFgj2iK1f4pLqrJCUXUpS7l+ffc
	ZiN9wPB6jHHrMNNBu0SIQencQemk0Z7KDtKwGX6Jx
X-Gm-Gg: ASbGncsLOf12ANZtMMEmZ0ydvkvF2uhwwrjTJJRl8Uec1sS8akpFfO+8NNisxYdwudW
	MhPJjESDQKty78QyCWuZJC3WvsvA4g/aWC6YRlQo+j+JgfZDWNfJpCefMaJnRzvWN8sKpgiSrFl
	AG9nGPGNXfzzpy84SLFdBOcrfXIA1FucqbtJmPgoi3+L+gBiXyTjiJ70bnl6Ydz9E/5+6vN+EAU
	OY+XROFZo3/HItMfT2OFku+6ufSMJPfzFXmixP3f/OODyivrwAG0IIylYaUebG/aluYSorU
X-Google-Smtp-Source: AGHT+IEq5GU7JSJAD9NSFFTRdVafRqGeePEnDnbLwoGqXLyw0X5hyqRrQVNf0XDjg2zuGyBpzHfDgCdEQ6erVOBfoCw=
X-Received: by 2002:aa7:c057:0:b0:643:6975:5381 with SMTP id
 4fb4d7f45d1cf-6479f73071bmr21488a12.15.1764784894352; Wed, 03 Dec 2025
 10:01:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203063004.185182-1-gourry@gourry.net> <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
In-Reply-To: <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 3 Dec 2025 10:01:20 -0800
X-Gm-Features: AWmQ_bm9jnHUGZVMHvCiQBBD_zjOFaR4rqaOnzbPbdd4tEkA041SCnA3fwsyYVM
Message-ID: <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, 
	kas@kernel.org, dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, 
	muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, x86@kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Wei Yang <richard.weiyang@gmail.com>, David Rientjes <rientjes@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 9:53=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
> > On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
> > > -           if (PageHuge(page))
> > > -                   return false;
> > > +           /*
> > > +            * Only consider ranges containing hugepages if those pag=
es are
> > > +            * smaller than the requested contiguous region.  e.g.:
> > > +            *     Move 2MB pages to free up a 1GB range.
> >
> > This one makes sense to me.
> >
> > > +            *     Don't move 1GB pages to free up a 2MB range.
> >
> > This one I might be missing something. We don't use cma for 2M pages,
> > so I don't see how we can end up in this path for 2M allocations.
> >
>
> I used 2MB as an example, but the other users (listed in the changelog)
> would run into these as well.  The contiguous order size seemed
> different between each of the 4 users (memtrace, tx, kfence, thp debug).
>
> > The reason I'm bringing this up is because this function overall looks
> > kind of unnecessary. Page isolation checks all of these conditions
> > already, and arbitrates huge pages on hugepage_migration_supported() -
> > which seems to be the semantics you also desire here.
> >
> > Would it make sense to just remove pfn_range_valid_contig()?
>
> This seems like a pretty clear optimization that was added at some point
> to prevent incurring the cost of starting to isolate 512MB of pages and
> then having to go undo it because it ran into a single huge page.
>
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(gfp_mask), nodemask) {
>
>                 spin_lock_irqsave(&zone->lock, flags);
>                 pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
>                 while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>                         if (pfn_range_valid_contig(zone, pfn, nr_pages)) =
{
>
>                                 spin_unlock_irqrestore(&zone->lock, flags=
);
>                                 ret =3D __alloc_contig_pages(pfn, nr_page=
s,
>                                                         gfp_mask);
>                                 spin_lock_irqsave(&zone->lock, flags);
>
>                         }
>                         pfn +=3D nr_pages;
>                 }
>                 spin_unlock_irqrestore(&zone->lock, flags);
>         }
>
> and then
>
> __alloc_contig_pages
>         ret =3D start_isolate_page_range(start, end, mode);
>
> This is called without pre-checking the range for unmovable pages.
>
> Seems dangerous to remove without significant data.
>
> ~Gregory

Yeah, the function itself makes sense: "check if this is actually a
contiguous range available within this zone, so no holes and/or
reserved pages".

The PageHuge() check seems a bit out of place there, if you just
removed it altogether you'd get the same results, right? The isolation
code will deal with it. But sure, it does potentially avoid doing some
unnecessary work.

- Frank

