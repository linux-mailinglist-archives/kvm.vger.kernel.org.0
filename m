Return-Path: <kvm+bounces-50412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4AD0AE4E16
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AE6F189E873
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC002D543B;
	Mon, 23 Jun 2025 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WIZpVVKn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB41F5617
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750710169; cv=none; b=NmbLUS5DqDg0HCXfCygx3PrrkCLi4TIa94XGzSxmpJmI6QT2bmMIiklcnZu0CfUvYHyIWEyp1aT16QHEncN1054eTdtPIVOLNTH5XsiaEUPj56yCtNmlEjqnmKlyqdKkaCw+LX5byNm/RIsOIFtXlQSi+7o6YNJGKY3AL1p28mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750710169; c=relaxed/simple;
	bh=QbK2F7d7TS1UuL/vOQNI0dCt+1mtnyHhpwoJxf5gAL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h8wbzF3eED42OykXDDLiUEjI048nO06VYt43taIQMR0WbfDsSpL3AgB5gj8AvoPqeu6PTflBEDFisY+dPJyQzK8bMa1Yp6eJLofzo/a159xRuTW+G3LO4P7QjMCuyNLXb5I4QCrMfvPXygDqEdvHwRyWCm7trOWcmfaNTTM795k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WIZpVVKn; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-237f270513bso11705ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750710167; x=1751314967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3mqaLb4lMwuk5Dxo08DB8mhksK7Q2tt9b+1KHSKaiQ=;
        b=WIZpVVKnZ8HAvT+ZalpaxGhMlKuoGvZiBEeflR1h/pvMr8sgFsCeG9p+h4TcUCoHZI
         mualSvACkU5EbWnNj3/4tYByUsImzlfMCvUMv44L2MK7szulLyySv+v0cYGxixtY4AOI
         7jlcfQBeQ9lXhd6jxDCSHaCN/8QF9oaco9OnkpIBwlibCPiunjwxEBP4jOJOP2xtbzbV
         jw47rRnh0MTv6bWPdsDx1eNZgE1cEvcdj8OcpCx7l4lmyd6RYB8rkmRmdVSlQBLFW9Fi
         U4dqDohgT2zW8xKUtaE+MVwKL7K0S9HCqGpGrjsSh4bYOyA8d+M8aP9PVQmbtGK2hwYr
         uRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750710167; x=1751314967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3mqaLb4lMwuk5Dxo08DB8mhksK7Q2tt9b+1KHSKaiQ=;
        b=FCbN2L9XlZWtMpNAp7LUfR0wKoU6pnEETSwSAO1rat/tY9t95ib79cFJB/pKjaRxy5
         aDbycOZIqtGtx7oFJZynAZ4RjewkTqHOL6JW1mudIqttVyOEKJZJpSqjaWmCL6/z4Jbo
         L9IJHV0N0xUI1bfdSpRoQ63EUUYRDU6Mscel03TfzQrO/EzpO4Mp5/QWtvu9cz1IWVG1
         1KOmhEsZHyXo44xKoCY6IRBXrX40HTvxWTBZuNWex3ApHRhLC0plhz6yCqFPOria+kVB
         BoLQmU6B/eNGWE0qZlJGyuYImexIz3Y4wewUCrvlrcdGJTygvvxal+qC/9Vp6+kfjKJs
         QZxA==
X-Forwarded-Encrypted: i=1; AJvYcCXxIiWNJfybUo6bt9PddRrXwVJpIyB0DKav6XOQFJbmOlUokLK6DShW/dG6SxErHDin7eY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbPeR1RM/1YJv0m7t8ZpzPnK0+KxalSTzpc/26oyItRpYFeuDs
	l6lmEPcindAMkLuQlbgupfJFlgk2REwCI8vQIjZXrgxHui1nCOobU069MHcQTQiBLjZvBJIFBqK
	GhyYOhkt7lfYFRHkt0cV3DiVhDXAbZKpuDLJyd0+v
X-Gm-Gg: ASbGncuv7TbiS+DoHTWY//KuysP5GwMoM2MaRZGFbptA209vvqpHBxavoetPxYX8Ive
	31D7WurRiO/BvdnuWyR15VRN2aOlt1G5ljGBFXHwJhufWp6MyTaRW9J36ZdnEa2cT151kGMfpMh
	/rUk5gul2aGFzE3WflBbV7Zhh39NMzwT6+PorZdpvsUwuLXwrs6MD+nmS8NPPKAdGcUAvEeHWK
X-Google-Smtp-Source: AGHT+IGDQj8ItVReLWtVU9OwwwoVsN7EIusky6EKmAOOeb5Xtm0p72rl+/LEHWyktm+n2x1XXnSPnZddVkmB1AZY4To=
X-Received: by 2002:a17:902:e5c1:b0:236:9402:a610 with SMTP id
 d9443c01a7336-23802bfd45cmr798555ad.22.1750710166944; Mon, 23 Jun 2025
 13:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com> <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
 <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
 <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
 <CAGtprH9RXM8RGj_GtxjHMQcWcvUPa_FJWXOu7LTQ00C7N5pxiQ@mail.gmail.com> <2c04ba99e403a277c3d6b9ce0d6a3cb9f808caef.camel@intel.com>
In-Reply-To: <2c04ba99e403a277c3d6b9ce0d6a3cb9f808caef.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 23 Jun 2025 13:22:35 -0700
X-Gm-Features: AX0GCFuvLPdD-PxtX8yRCsTXOPv54UJMeVan4R2OC26g-1YzmB_aFLIRUp58JpM
Message-ID: <CAGtprH-rUuk=9shX9bsP4K=UPVvG1cUJCiXBfW07mZ1cjtkcQw@mail.gmail.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025 at 9:23=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2025-06-20 at 20:00 -0700, Vishal Annapurve wrote:
> > Can you provide enough information to evaluate how the whole problem is=
 being
> > > solved? (it sounds like you have the full solution implemented?)
> > >
> > > The problem seems to be that rebuilding a whole TD for reboot is too =
slow. Does
> > > the S-EPT survive if the VM is destroyed? If not, how does keeping th=
e pages in
> > > guestmemfd help with re-faulting? If the S-EPT is preserved, then wha=
t happens
> > > when the new guest re-accepts it?
> >
> > SEPT entries don't survive reboots.
> >
> > The faulting-in I was referring to is just allocation of memory pages
> > for guest_memfd offsets.
> >
> > >
> > > >
> > > > >
> > > > > The series Vishal linked has some kind of SEV state transfer thin=
g. How is
> > > > > it
> > > > > intended to work for TDX?
> > > >
> > > > The series[1] unblocks intrahost-migration [2] and reboot usecases.
> > > >
> > > > [1] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@googl=
e.com/#t
> > > > [2] https://lore.kernel.org/lkml/cover.1749672978.git.afranji@googl=
e.com/#t
> > >
> > > The question was: how was this reboot optimization intended to work f=
or TDX? Are
> > > you saying that it works via intra-host migration? Like some state is=
 migrated
> > > to the new TD to start it up?
> >
> > Reboot optimization is not specific to TDX, it's basically just about
> > trying to reuse the same physical memory for the next boot. No state
> > is preserved here except the mapping of guest_memfd offsets to
> > physical memory pages.
>
> Hmm, it doesn't sound like much work, especially at the 1GB level. I wond=
er if
> it has something to do with the cost of zeroing the pages. If they went t=
o a
> global allocator and back, they would need to be zeroed to make sure data=
 is not
> leaked to another userspace process. But if it stays with the fd, this co=
uld be
> skipped?

A simple question I ask to myself is that if a certain memory specific
optimization/feature is enabled for non-confidential VMs, why it can't
be enabled for Confidential VMs. I think as long as we cleanly
separate memory management from RMP/SEPT management for CVMs, there
should ideally be no major issues with enabling such optimizations for
Confidential VMs.

Just memory allocation without zeroing, even with hugepages takes time
for large VM shapes and I don't really see a valid reason for the
userspace VMM to repeat the freeing and allocation cycles.

> For TDX though, hmm, we may not actually need to zero the private pages b=
ecause
> of the transition to keyid 0. It would be beneficial to have the differen=
t VMs
> types work the same. But, under this speculation of the real benefit, the=
re may
> be other ways to get the same benefits that are worth considering when we=
 hit
> frictions like this. To do that kind of consideration though, everyone ne=
eds to
> understand what the real goal is.
>
> In general I think we really need to fully evaluate these optimizations a=
s part
> of the upstreaming process. We have already seen two post-base series TDX
> optimizations that didn't stand up under scrutiny. It turned out the exis=
ting
> TDX page promotion implementation wasn't actually getting used much if at=
 all.
> Also, the parallel TD reclaim thing turned out to be misguided once we lo=
oked

For a ~700G guest memory, guest shutdown times:
1) Parallel TD reclaim + hugepage EPT mappings  : 30 secs
2) TD shutdown with KVM_TDX_TERMINATE_VM + hugepage EPT mappings: 2 mins
3) Without any optimization: ~ 30-40 mins

KVM_TDX_TERMINATE_VM for now is a very good start and is much simpler
to upstream.

> into the root cause. So if we blindly incorporate optimizations based on =
vague
> or promised justification, it seems likely we will end up maintaining som=
e
> amount of complex code with no purpose. Then it will be difficult to prov=
e later
> that it is not needed, and just remain a burden.
>
> So can we please start explaining more of the "why" for this stuff so we =
can get
> to the best upstream solution?

