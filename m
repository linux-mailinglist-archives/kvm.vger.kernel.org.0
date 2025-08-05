Return-Path: <kvm+bounces-53954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F3CB1ABF7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 03:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA37D163F99
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 01:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76F0199FB2;
	Tue,  5 Aug 2025 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t8Ji9F1g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AA2A41
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754356838; cv=none; b=C940+YpWLMUEcThfVhLjj3cPM++M56oKEdbzpIeR1eze8qWPVdAVcbEIbleV/7BRfnwJe52hlARXkTz+KoSURvchHOzSzyiO7loryNyQyufZG193jYXxylJ6xaW9y4ggQNGUHuPNTtXJuW06HDoHZIPYiSCvwWmX5ysdbdOhjUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754356838; c=relaxed/simple;
	bh=swpTiO+XH5TQq83hG6ZUZgyhocdMW7f+n5xUPvEAaRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qkPOe+C/RuzBMkq+rybV1rX1s7peCZkj1VmCQ8UIJ/1OgQUePvX4AO1OZsFxFaBAPXAo9NYgwkbxfB9Z2UJU4dgdaCGtD21YSO4+or4MF+Nzi86QRD47GxWPtzJlUdH3Xgk+GN0QbvtuA/qdBCmv+BfXfzQkEfmo3XQYYi4hdi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t8Ji9F1g; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24070dd87e4so76655ad.0
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 18:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754356836; x=1754961636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2cdGE1gGOLXCJmNC5s4I0c4oeV0J7N0veB1ToZLZSM=;
        b=t8Ji9F1gLj1NGW/C+Dja89KJ1Av+OcjkTPAFZdjFTWXHShisY1oqzleK7DCjNDXdcz
         HoDoN9+hn87lGAU81l8IEbfKhCnQoppYofz2//nfH5Q4pLLB3QFiwqag3NRNmSr3guqa
         nV4wPg68kU+5o4lZ0IY3Po1a650f3+TVKuDyk6N0mID9wkEqDSsr0sNFJOa4Jdj3YgWf
         0I/KcYxMCjEdqJm3KgirNx6WdwmyRCaDwJFHI/Av5PGgilScxgvOAo+ipvd+dL67jcHp
         MV/94b8OH799HOfacJ2RgmFqKot3rBpcxIbufSkmnQy0Ds8IY1CEbBpHfpvtzyPfwLdt
         T0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754356836; x=1754961636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2cdGE1gGOLXCJmNC5s4I0c4oeV0J7N0veB1ToZLZSM=;
        b=I80xbbHWWQ7R2bG91vPj1KrWHTw/n93/fXHztwjPThRlCmlwESTVkGJD4COHgqq2oZ
         ltWZeAi3axivP+jmfx6qDK6KbkK76S4Sh8YIfY+TlcE4Puwo2UCtnMzr5hNtW/tf/8uT
         HRCAvZLfHQzlGmBKCNttKrWyXefeW6fIE0SQF7stqoPcJos3eQxxDs9+YMtaPvo5jiLm
         1kce55p2u+5cB5fYMWxTU7YlXQlhMUxQFECIfENfDDwejlhGP5DBhYNVORpFTxzXezJr
         du0X3kyT4jaKyDFQaktX7kxQobBum1oPNtBCOTmF6mFRcr5dDyVEkrrHsSYVsw451jCD
         uB0A==
X-Forwarded-Encrypted: i=1; AJvYcCXmihAi2Z21LPPdC7TqfxbKxhPYwl/BxJszTmida2SZ6TG9dRjyPMANwdQDurN+a6Ockec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgw00CymRu+mLfBB6zysFb706QqXaWqSxc+fx3yGDy6/3yULAY
	9/0xc9xDMiDFozSABMxO1DSSGRqX1dqg/sCbylqDG7HWgxvofZfWTQvVkwh9fC4Z7ju8Qhbwi/l
	s0HmeJSvwJtlWeJdeREFF0az4uBF0O4hFkQxizekk
X-Gm-Gg: ASbGncs+mAf1pGPXZZ4YQcUEDCTTE7fZGEd37xCVZVfL6/drUJa7OyErrfn744P17H/
	8mieHFnCrwkevdhaYOAHgFJj7WNgGq/1kaf4Pmm1S+6YIDJUyvAFMRK10EAnNcpPepJqcilG2mL
	yTkCxTQRGcPIF8FysxSV/ILmEZ6kZrePgEFQwAsu29wT6SUtuxpXQdv9r93AGAikefVwnZjRFCE
	q/X/d+m3X+UPcGXZ7QRGMIDm944dPpxXs8Tbg==
X-Google-Smtp-Source: AGHT+IHoGln+nl/FJBCGfeuyumyroLaM5HvSz457gpDjG5nE2SZikVrNTnjMNkRuSQfpjMdg4bJ7hab+N8/lf0qaVDw=
X-Received: by 2002:a17:902:d50b:b0:223:ff93:322f with SMTP id
 d9443c01a7336-2428e9b08e0mr353115ad.2.1754356835453; Mon, 04 Aug 2025
 18:20:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aHEwT4X0RcfZzHlt@google.com> <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com> <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com> <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
 <aJFOt64k2EFjaufd@google.com>
In-Reply-To: <aJFOt64k2EFjaufd@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 4 Aug 2025 18:20:22 -0700
X-Gm-Features: Ac12FXxp8MXYPovS7CHmH7yGaGLLp8dqnCHVsUqeh69FkNZnKElDWeFkrxjVNjM
Message-ID: <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Sean Christopherson <seanjc@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 4, 2025 at 5:22=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > > > > IIUC, the suggestion in the link is to abandon kvm_gmem_populate(=
).
> > > > > For TDX, it means adopting the approach in this RFC patch, right?
> > > > Yes, IMO this RFC is following the right approach as posted.
>
> I don't think we want to abandon kvm_gmem_populate().  Unless I'm missing=
 something,
> SNP has the same AB-BA problem as TDX.  The copy_from_user() on @src can =
trigger
> a page fault, and resolving the page fault may require taking mm->mmap_lo=
ck.
>
> Fundamentally, TDX and SNP are doing the same thing: copying from source =
to guest
> memory.  The only differences are in the mechanics of the copy+encrypt, e=
verything
> else is the same.  I.e. I don't expect that we'll find a magic solution t=
hat works
> well for one and not the other.
>
> I also don't want to end up with wildly different ABI for SNP vs. everyth=
ing else.
> E.g. cond_resched() needs to be called if the to-be-initialzied range is =
large,
> which means dropping mmu_lock between pages, whereas kvm_gmem_populate() =
can
> yield without dropping invalidate_lock, which means that the behavior of =
populating
> guest_memfd memory will be quite different with respect to guest_memfd op=
erations.

I would think that TDX/CCA VMs [1] will run into the similar behavior
of needing to simulate stage2 faults i.e. KVM will end up picking up
and dropping mmu_lock for each page anyways at least for these two
platforms.

[1] https://lore.kernel.org/kvm/20250611104844.245235-5-steven.price@arm.co=
m/
(rmi_rtt_create())

>
> Pulling in the RFC text:
>
> : I think the only different scenario is SNP, where the host must write
> : initial contents to guest memory.
> :
> : Will this work for all cases CCA/SNP/TDX during initial memory
> : population from within KVM:
> : 1) Simulate stage2 fault
> : 2) Take a KVM mmu read lock
>
> Doing all of this under mmu_lock is pretty much a non-starter.
>
> : 3) Check that the needed gpa is mapped in EPT/NPT entries
>
> No, KVM's page tables are not the source of truth.  S-EPT is a special sn=
owflake,
> and I'd like to avoid foisting the same requirements on NPT.

I agree this would be a new requirement.

>
> : 4) For SNP, if src !=3D null, make the target pfn to be shared, copy
> : contents and then make the target pfn back to private.
>
> Copying from userspace under spinlock (rwlock) is illegal, as accessing u=
serspace
> memory might_fault() and thus might_sleep().

I would think that a combination of get_user_pages() and
kmap_local_pfn() will prevent this situation of might_fault().

>
> : 5) For TDX, if src !=3D null, pass the same address for source and
> : target (likely this works for CCA too)
> : 6) Invoke appropriate memory encryption operations
> : 7) measure contents
> : 8) release the KVM mmu read lock
> :
> : If this scheme works, ideally we should also not call RMP table
> : population logic from guest_memfd, but from KVM NPT fault handling
> : logic directly (a bit of cosmetic change).
>
> LOL, that's not a cosmetic change.  It would be a non-trivial ABI change =
as KVM's
> ABI (ignoring S-EPT) is that userspace can delete and recreate memslots a=
t will.

Ack, this is not a cosmetic change once we start thinking about how
memory ownership should be tied to memslots/NPT operations.

>
> : Ideally any outgoing interaction from guest_memfd to KVM should be only=
 via
>   invalidation notifiers.
>
> Why?  It's all KVM code.  I don't see how this is any different than e.g.=
 common
> code, arch code, and vendor code all calling into one another.  Artificia=
lly
> limiting guest_memfd to a super generic interface pretty much defeats the=
 whole
> purpose of having KVM provide a backing store.

Inline with what we discussed on another thread, it makes sense to
think of guest_memfd as not a super generic interface, but at least
the one that has a very well defined role of supplying memory to KVM
guests (so to userspace and IOMMU) and taking away the memory when
needed. Memory population in my opinion is best solved either by users
asserting ownership of the memory and writing to it directly or by
using guest_memfd (to be) exposed APIs to populate memory ranges given
a source buffer. IMO kvm_gmem_populate() is doing something different
than both of these options.

