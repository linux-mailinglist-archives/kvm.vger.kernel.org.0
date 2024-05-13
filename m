Return-Path: <kvm+bounces-17350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 929FF8C484D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C6C2832CB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 20:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22207824A4;
	Mon, 13 May 2024 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sJBERe9V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A8E7F499
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715632593; cv=none; b=AZjzbOweynDsu4TmV13sMRs1Jp11laGxOHA03NhetK3bwaf+ndF3gqCpzY1E2k1mJHIFDNKdciZarqwJK0b0dEXLsNAAuUmQCBfkvGx8q9uPZnbMO1gz+8rz6jqf8L2xsd6/wjd/Cw2gjW8bhOPw+rt0lQnVRxmessrUGR/Jf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715632593; c=relaxed/simple;
	bh=n4F/ACuUR8nsDfvt1OJ0kqef8cheGQHpaP6RjXXyhBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLZm/EXJFlrwqOT70qEY3HIZU6X9MVsbW2dJmzbLw0ok6p0zZrCBOB9Apv/HQ5cKj6HL+mpYJsv1qHtbBeSOmgPGc504H+D2Ol/gYjGu70aCPTFBRyOAXTE2QIoMrCwRPuHfqFEPY7RxAcQiATJRW7xmQW3urTpQ05cUwlZQoVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sJBERe9V; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee6d17bf14so3734001276.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 13:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715632591; x=1716237391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTqdF/Fyy9v2rp3elmPXvaESz+kmdh+eg2ABVOfbt3w=;
        b=sJBERe9V3vJZ7XHCr1K9SglmEjVcgbHmafKbNaXjy/S3iQK7jqOSrAB71nSK0EouBs
         aa9H9s6SFAKhDBg9FMgxp+XqOeIHy8fR7SBpfziqgp+4kmx+zRbLgjnPYJ0kz010wB37
         kZM4UP+GABCfpp75sO0a2fc+AEF/oHkK3RNNuISvgmoEOIdBKDcskeaHLq37EfX3KJvb
         WdmhiGTUUAEwpXUxvHHGks/pPBlhuNlXDbirKTnYH22NYTrzpdzuCUgHjXiHUcsjPpza
         9uplkZTxK/UNlZHqcYJAtyxZgHi2zXO6z712zvUzSsiAB8vyAHFZh85IoNiC5Bhie0TK
         xkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715632591; x=1716237391;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RTqdF/Fyy9v2rp3elmPXvaESz+kmdh+eg2ABVOfbt3w=;
        b=UMia8eWsckwJhD16nNu+NEMFTanYNToMX3+EBzLpVSm0evTIvl36zMEkp3SY8XyTpq
         M/MUvPHH1UYWkHvOjjmek9ZT8kEq/4HenSL1pJaL71lxZHvVSOscg7+19Ztvs+DTiN5d
         Nmb/pGWuPF9hV/mfaY6UPLhRvku8ize6S0eGxCgEMCMuaKZgjTOkhgjcQc/Npnun9V/6
         dOX7yrfFgakrSA73sfeJqb8ku5zDFNszwy4q7Pz/JxwH7guWHBh5u6+24K5DyzMGzZ2v
         Dmrz7Kp2rAghMyjO4XLoB4f8iH4clEGrGY3rqByFRCmScbNgtb0vHMVG5LOSZDt6Nwy5
         GIyA==
X-Gm-Message-State: AOJu0YxwE8gxFW0lFkdIhTHIPdF8bzAGnkGeDp3kzxOcOLenaFfjJogT
	A809j6iPtLjjVOp9jZaXE0TLdHFITje3Vbq5VP2xkgtJtcYEVvYyGlPSd9u0JjXrFeJzTi9EnAm
	UqQ==
X-Google-Smtp-Source: AGHT+IFxSaf5ALbxAjGJ4irStP0T4VQiFrWgBxguuMjd3vTUy8dpIf11/Kw31vWLIOru5J9yUqNrB2dHqIA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120d:b0:dee:690f:af35 with SMTP id
 3f1490d57ef6-dee690fbad4mr609613276.8.1715632590827; Mon, 13 May 2024
 13:36:30 -0700 (PDT)
Date: Mon, 13 May 2024 13:36:29 -0700
In-Reply-To: <f880d0187e2d482bc8a8095cf5b7404ea9d6fb03.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org>
 <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk> <ZkI0SCMARCB9bAfc@google.com>
 <aaf684b5eb3a3fe9cfbb6205c16f0973c6f8bb07.camel@amazon.com>
 <ZkJFIpEHIQvfuzx1@google.com> <f880d0187e2d482bc8a8095cf5b7404ea9d6fb03.camel@amazon.com>
Message-ID: <ZkJ37uwNOPis0EnW@google.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
From: Sean Christopherson <seanjc@google.com>
To: James Gowans <jgowans@amazon.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Nikita Kalyazin <kalyazin@amazon.co.uk>, 
	"rppt@kernel.org" <rppt@kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	Patrick Roy <roypat@amazon.co.uk>, "somlo@cmu.edu" <somlo@cmu.edu>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Alexander Graf <graf@amazon.de>, Derek Manwaring <derekmn@amazon.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "lstoakes@gmail.com" <lstoakes@gmail.com>, 
	"mst@redhat.com" <mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024, James Gowans wrote:
> On Mon, 2024-05-13 at 10:09 -0700, Sean Christopherson wrote:
> > On Mon, May 13, 2024, James Gowans wrote:
> > > On Mon, 2024-05-13 at 08:39 -0700, Sean Christopherson wrote:
> > > > > Sean, you mentioned that you envision guest_memfd also supporting=
 non-CoCo VMs.
> > > > > Do you have some thoughts about how to make the above cases work =
in the
> > > > > guest_memfd context?
> > > >=20
> > > > Yes.=C2=A0 The hand-wavy plan is to allow selectively mmap()ing gue=
st_memfd().=C2=A0 There
> > > > is a long thread[*] discussing how exactly we want to do that.=C2=
=A0 The TL;DR is that
> > > > the basic functionality is also straightforward; the bulk of the di=
scussion is
> > > > around gup(), reclaim, page migration, etc.
> > >=20
> > > I still need to read this long thread, but just a thought on the word
> > > "restricted" here: for MMIO the instruction can be anywhere and
> > > similarly the load/store MMIO data can be anywhere. Does this mean th=
at
> > > for running unmodified non-CoCo VMs with guest_memfd backend that we'=
ll
> > > always need to have the whole of guest memory mmapped?
> >=20
> > Not necessarily, e.g. KVM could re-establish the direct map or mremap()=
 on-demand.
> > There are variation on that, e.g. if ASI[*] were to ever make it's way =
upstream,
> > which is a huge if, then we could have guest_memfd mapped into a KVM-on=
ly CR3.
>=20
> Yes, on-demand mapping in of guest RAM pages is definitely an option. It
> sounds quite challenging to need to always go via interfaces which
> demand map/fault memory, and also potentially quite slow needing to
> unmap and flush afterwards.=20
>=20
> Not too sure what you have in mind with "guest_memfd mapped into KVM-
> only CR3" - could you expand?

Remove guest_memfd from the kernel's direct map, e.g. so that the kernel at=
-large
can't touch guest memory, but have a separate set of page tables that have =
the
direct map, userspace page tables, _and_ kernel mappings for guest_memfd.  =
On
KVM_RUN (or vcpu_load()?), switch to KVM's CR3 so that KVM always map/unmap=
 are
free (literal nops).

That's an imperfect solution as IRQs and NMIs will run kernel code with KVM=
's
page tables, i.e. guest memory would still be exposed to the host kernel.  =
And
of course we'd need to get buy in from multiple architecturs and maintainer=
s,
etc.

> > > I guess the idea is that this use case will still be subject to the
> > > normal restriction rules, but for a non-CoCo non-pKVM VM there will b=
e
> > > no restriction in practice, and userspace will need to mmap everythin=
g
> > > always?
> > >=20
> > > It really seems yucky to need to have all of guest RAM mmapped all th=
e
> > > time just for MMIO to work... But I suppose there is no way around th=
at
> > > for Intel x86.
> >=20
> > It's not just MMIO.=C2=A0 Nested virtualization, and more specifically =
shadowing nested
> > TDP, is also problematic (probably more so than MMIO).=C2=A0 And there =
are more cases,
> > i.e. we'll need a generic solution for this.=C2=A0 As above, there are =
a variety of
> > options, it's largely just a matter of doing the work.=C2=A0 I'm not sa=
ying it's a
> > trivial amount of work/effort, but it's far from an unsolvable problem.
>=20
> I didn't even think of nested virt, but that will absolutely be an even
> bigger problem too. MMIO was just the first roadblock which illustrated
> the problem.
> Overall what I'm trying to figure out is whether there is any sane path
> here other than needing to mmap all guest RAM all the time. Trying to
> get nested virt and MMIO and whatever else needs access to guest RAM
> working by doing just-in-time (aka: on-demand) mappings and unmappings
> of guest RAM sounds like a painful game of whack-a-mole, potentially
> really bad for performance too.

It's a whack-a-mole game that KVM already plays, e.g. for dirty tracking, p=
ost-copy
demand paging, etc..  There is still plenty of room for improvement, e.g. t=
o reduce
the number of touchpoints and thus the potential for missed cases.  But KVM=
 more
or less needs to solve this basic problem no matter what, so I don't think =
that
guest_memfd adds much, if any, burden.

> Do you think we should look at doing this on-demand mapping, or, for
> now, simply require that all guest RAM is mmapped all the time and KVM
> be given a valid virtual addr for the memslots?

I don't think "map everything into userspace" is a viable approach, precise=
ly
because it requires reflecting that back into KVM's memslots, which in turn
means guest_memfd needs to allow gup().  And I don't think we want to allow=
 gup(),
because that opens a rather large can of worms (see the long thread I linke=
d).

Hmm, a slightly crazy idea (ok, maybe wildly crazy) would be to support map=
ping
all of guest_memfd into kernel address space, but as USER=3D1 mappings.  I.=
e. don't
require a carve-out from userspace, but do require CLAC/STAC when access gu=
est
memory from the kernel.  I think/hope that would provide the speculative ex=
ecution
mitigation properties you're looking for?

Userspace would still have access to guest memory, but it would take a trul=
y
malicious userspace for that to matter.  And when CPUs that support LASS co=
me
along, userspace would be completely unable to access guest memory through =
KVM's
magic mapping.

This too would require a decent amount of buy-in from outside of KVM, e.g. =
to
carve out the virtual address range in the kernel.  But the performance ove=
rhead
would be identical to the status quo.  And there could be advantages to bei=
ng
able to identify accesses to guest memory based purely on kernel virtual ad=
dress.

