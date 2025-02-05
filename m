Return-Path: <kvm+bounces-37297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0352AA28401
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 06:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90532188773D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 05:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69C3221D93;
	Wed,  5 Feb 2025 05:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BvLqzw+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2610C21E085
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 05:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738735123; cv=none; b=NbUzJ3jflY+yIlqOX9U2i86/j6GPvh2BhGxNwn8X4LON/yC8jx7srslUEjmnXRpJWJf2JVxgT5SDiZXOYc+4+VgDGSfXEDtCXLOAsE8nitsw3GmM0T5OIijw+VdFVXdJswZ5SI5GapA1cQAYdFNZzsV4lQ1LmCH34qNOFSwInDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738735123; c=relaxed/simple;
	bh=zz0OVo/LVKBaWF1jVNlY/E23YTVCdClcTtfsrDzbagw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h50vrPZGF7ZatjscfOgZq4cdZOBj+9lkPA3LQftSMQRywY9kL83HDiHJ7eN5+ArQIZW1S6w1HwXx6zXiSyXkHAeAMnEXtE0zW+bSQcCJxkQEK5r0yOa3roo4SuE6BExkPBRFPJrroZsHYff4CMdYBldHQSqsZNZrhBlEiemnC4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BvLqzw+h; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5401af8544bso10713e87.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 21:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738735119; x=1739339919; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LeTTgaKlabWmcuLOpAiz/mXQYniil25QIw4uiRfkkw=;
        b=BvLqzw+hGRe1DZBOYwqNm6PrJnlmAa5thTBuBrXfxzM+7LK//1yd+fi1CPOmznsO4z
         atn3fnwKZMLmkUH5TGyNkF7cOiBVzzIDWQw27wGtPeouiaiTJHPM3NTOto3K/pPrCOqh
         U0LZ8esVf5/i+zk1M9mNHwcpgNDOLD7u7qgPj4Qos+yD/VU1ghzPlhTr5cpBkreydeK3
         Hytdwi4/Ipt0M50HnafPbHUbfjHcHJlQ9QFOeAROEurgDGcMaMbZN8e+TtHIYFVWUSyp
         H0BSUNj46ItfyGLJbyvV4t/RCyphTKCDUVVs+FV+p0d8/2gXXgXrBXoqvCIpudLnsBXa
         Ezig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738735119; x=1739339919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+LeTTgaKlabWmcuLOpAiz/mXQYniil25QIw4uiRfkkw=;
        b=NUj6pVD35c+vNraYkGqujutWAfkblYhSTTycLyBVO/MTC8DREBDt8QAXo8ghX0N0xB
         e36yC8SkIWzMqiIoTes91gA9dMS8+7NOkOcCKZLqFHPTw4nQ1BlU8ejcBM45daSpNUaT
         ADagQka0Dmc4xuuq3vtS9ivsCAOc9ZR/mPifVRkHzD6Br+x8kG3IPtaCi85jG5jx2r/n
         jPPCI060Sop2+8Fnx04eIlH5ErPGkCMtzx/WmTkf78k0ahrR8FeIvANglyOIFS75Mi2E
         Olizg9CIm3IcEiNvAwqfRG0Zdeab7wcQJ0nSeWI/5TNAt57RK7MM3eXFm3vK1hjPB5Ha
         6YkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSApRkPa4vOQEMAggTgOgcg+tAHCBG8qkEBGpdlkUMODH8HnKRg6VWmbLAauQxybLVii8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIqJSvWwWitgeP7XbPdJZ4nj0kaV2yEPJ7ld6SV1MlDIZ+U3ns
	+cfbJ3O4NFT5T81VlnJJsnzGl95FExzpS//aZn3pvpCMtJTmuV6QHukoLGyzsszDzHK2jmk6Lsk
	lNi6HsxkoqN1sBeK52EhhGj6EeWdY0W3pN+jq
X-Gm-Gg: ASbGncvmSUcbhrNfR30a//6Af9FpTLcXF0StLiJJdbQmxM/IItgpHkgHSFsRlnglnog
	djgWf3HRBpANURn2lh5aF5YcYIC8PcQQNgSg6Rmf8Kt3YQCFJ4rsX6kXOoYIfKR0k+2XhrY+mc0
	7Ol4KG7/LHvEDjLyPEbq4b1MfAFfBmhA==
X-Google-Smtp-Source: AGHT+IHAeeJ7IOCbYq9qYXUedVnXfgoMiRmsjTdvV6OKC4uJyMl13U48eatWrGiG/P3Fuyq5YQO4n/2f1pmKorekP20=
X-Received: by 2002:a05:6512:b8a:b0:542:9910:b298 with SMTP id
 2adb3069b0e04-54400bfcf7bmr445446e87.7.1738735118871; Tue, 04 Feb 2025
 21:58:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGtprH-Ryn6Xqs-3_VBMkk3ew74Rf9=D8S_iHVmq2DE-YFk2-w@mail.gmail.com>
 <diqzldulovuu.fsf@ackerleytng-ctop-specialist.c.googlers.com>
In-Reply-To: <diqzldulovuu.fsf@ackerleytng-ctop-specialist.c.googlers.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Feb 2025 21:58:27 -0800
X-Gm-Features: AWEUYZm7U7NIsnnFeQDWA3MGWHf8AoWjaeLXKlqts6ZNxbpqML3Ghho8NZkbTlo
Message-ID: <CAGtprH_TL=KD2zcJFyC+=Ox_v46+bCiNmkjgncUwUOEo-LPOzw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 8:31=E2=80=AFPM Ackerley Tng <ackerleytng@google.com=
> wrote:
>
> Vishal Annapurve <vannapurve@google.com> writes:
>
> > On Thu, Jan 23, 2025 at 1:51=E2=80=AFAM Fuad Tabba <tabba@google.com> w=
rote:
> >>
> >> On Wed, 22 Jan 2025 at 22:16, Ackerley Tng <ackerleytng@google.com> wr=
ote:
> >> >
> >> > Fuad Tabba <tabba@google.com> writes:
> >> >
> >> > Hey Fuad, I'm still working on verifying all this but for now this i=
s
> >> > one issue. I think this can be fixed by checking if the folio->mappi=
ng
> >> > is NULL. If it's NULL, then the folio has been disassociated from th=
e
> >> > inode, and during the dissociation (removal from filemap), the
> >> > mappability can also either
> >> >
> >> > 1. Be unset so that the default mappability can be set up based on
> >> >    GUEST_MEMFD_FLAG_INIT_MAPPABLE, or
> >> > 2. Be directly restored based on GUEST_MEMFD_FLAG_INIT_MAPPABLE
> >>
> >> Thanks for pointing this out. I hadn't considered this case. I'll fix
> >> in the respin.
> >>
> >
> > Can the below scenario cause trouble?
> > 1) Userspace converts a certain range of guest memfd as shared and
> > grabs some refcounts on shared memory pages through existing kernel
> > exposed mechanisms.
> > 2) Userspace converts the same range to private which would cause the
> > corresponding mappability attributes to be *MAPPABILITY_NONE.
> > 3) Userspace truncates the range which will remove the page from pageca=
che.
> > 4) Userspace does the fallocate again, leading to a new page getting
> > allocated without freeing the older page which is still refcounted
> > (step 1).
> >
> > Effectively this could allow userspace to keep allocating multiple
> > pages for the same guest_memfd range.
>
> I'm still verifying this but for now here's the flow Vishal described in
> greater detail:
>
> + guest_memfd starts without GUEST_MEMFD_FLAG_INIT_MAPPABLE
>     + All new pages will start with mappability =3D GUEST
> + guest uses a page
>     + Get new page
>     + Add page to filemap
> + guest converts page to shared
>     + Mappability is now ALL
> + host uses page
> + host takes transient refcounts on page
>     + Refcount on the page is now (a) filemap's refcount (b) vma's refcou=
nt
>       (c) transient refcount
> + guest converts page to private
>     + Page is unmapped
>         + Refcount on the page is now (a) filemap's refcount (b) transien=
t
>           refcount
>     + Since refcount is elevated, the mappabilities are left as NONE
>     + Filemap's refcounts are removed from the page
>         + Refcount on the page is now (a) transient refcount
> + host punches hole to deallocate page
>     + Since mappability was NONE, restore filemap's refcount
>         + Refcount on the page is now (a) transient refcount (b) filemap'=
s
>           refcount
>     + Mappabilities are reset to GUEST for truncated range
>     + Folio is removed from filemap
>         + Refcount on the page is now (a) transient refcount
>     + Callback remains registered so that when the transient refcounts ar=
e
>       dropped, cleanup can happen - this is where merging will happen
>       with 1G page support
> + host fallocate()s in the same address range
>     + will get a new page
>
> Though the host does manage to get a new page while the old one stays
> around, I think this is working as intended, since the transient
> refcounts are truly holding the old folio around. When the transient
> refcounts go away, the old folio will still get cleaned up (with 1G page
> support: merged and returned) to as expected. The new page will also be
> freed at some point later.
>
> If the userspace program decides to keep taking transient refcounts to ho=
ld
> pages around, then the userspace program is truly leaking memory and it
> shouldn't be guest_memfd's bug.

I wouldn't call such references transient. But a similar scenario is
applicable for shmem files so it makes sense to call out this behavior
as WAI.

