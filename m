Return-Path: <kvm+bounces-50771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E861AE919B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 01:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45C537A4A28
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 23:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445682F430B;
	Wed, 25 Jun 2025 23:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSWVm9SU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7C2F4300
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 23:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892956; cv=none; b=omxGRJwbLSwDxVMzXEHcgq+7VrKQR54yYgjQrJtPOTWJ2tWyPFFpkKyGdmW/tFqpNxCjQk1hK0qYQf4IdWvmCsE2hmNDbzoAsW4KCDbY87jIrPgNen/5XW5SrXX4iJEB9nxYmebGHkIm6VA6wkPy1CoY7OjpkBr/iQ0BDXslAdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892956; c=relaxed/simple;
	bh=p/73LO3LXJj1ClO+n4wnK9RRgsRbB8NK7j1jyA5NKNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AuVpVvusc3LsShUQEOrD6xK7UPAoMLInHx/n/t/L4RPT5SIl+CxlBFhYs8F8Xi3ZLGdgfwyRTDaiIlxTw8cZfDxYUFfzgIzLToI6JJTNhdfgix+SxAm2uRJRq0hHQD6hvDxIxsCkXZF+hP4SDPQPNalT+0GX/BFLqRrnSiyMOHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSWVm9SU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31814efd1cso182240a12.3
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 16:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750892954; x=1751497754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p/73LO3LXJj1ClO+n4wnK9RRgsRbB8NK7j1jyA5NKNI=;
        b=bSWVm9SUFEZGcnU+F9fBjyyCL+D+FDQl0u7x/hNqDj6i8jssoWMErR6JYtnSWc5Azr
         ZluRSIhtHqXT2NQqOgsdjH+mEvPtRc2e0IHdxa9F0eoXTPS+OPz9WdYmKlzISWVML/se
         0kFUQOw0eMXyPoWtxDckANbVIuEc9hX2tQ+XfD8jtM11GUGcZm+mxTLJgQ+AikFPeXl3
         rOE88QJoEGVnS2q7FHdB/PjSGUhqu+oRfpgf2cvDyVeJadFpH8IrlW3PFjT9WTQqEADK
         YorNOQPGjBb4Eh5yBgI6DeK817DO/2aE0PMy12vjqVDfR4kjy1dgAfO37jfDBLfB2DJD
         plVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750892954; x=1751497754;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p/73LO3LXJj1ClO+n4wnK9RRgsRbB8NK7j1jyA5NKNI=;
        b=Uly/93p55tQ7TEvA+zGRz0WmIFYqNqUEe4BGk3MBqzEZmoPzGABOGNjV1pYV6AkMZ9
         /sLSH/KeL/6kHlhi7FHsDzue9c9tlha3LAB+EM9cesvLvYz5kk5Ab1q4yiTD9zLt0cct
         afW8k/X74SsxVHDpJ2B4mlpPdGJoIZgIvFQC4ZzbzHTKGzLdAP5HXSSWVZmfY+wdLROZ
         2sQW0ykAS3YM9j3yxGGa8VBB7l1ytbGXs673OWF4x9KVQDFqTOA5pJUEjmtfpl+M9jrk
         DazvJSE8n5TpGimZQqtFolBbj9516NlhzeUMll9k7W4rmibJ9pdIR/xydB8nA+zxopev
         eaIA==
X-Forwarded-Encrypted: i=1; AJvYcCVt58Lan0nFPAuvbM6AFnKJTHQfiEHbi4OFsWuMw7qzp8bC+ltZZhdRspLPRp+GocznGFo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5ho3TI3M6hMEMFP8I9/pdFow0OHhXvs3MXy6BOt5eBIoZJgJb
	6UxssxC72BTFfDBUQnAaDxJvKwjkDwlwcUyEu06wHYR0M6WsHQiolbJiXVFUi/5WXIu7j3y5twt
	1bOe5FUp9tRYRho5Gd/pETOwxXg==
X-Google-Smtp-Source: AGHT+IEWaSZgT7Jvqs/iwUbJhgMDnsaKnRZ2/EHFDy68wwHzlfJQ3BZSvF29+WWdlxPfYs6HfbTzzNxXeCUuRiXcGQ==
X-Received: from pjd11.prod.google.com ([2002:a17:90b:54cb:b0:314:3153:5650])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:380d:b0:312:f88d:25f9 with SMTP id 98e67ed59e1d1-316158912e3mr2570334a91.7.1750892953925;
 Wed, 25 Jun 2025 16:09:13 -0700 (PDT)
Date: Wed, 25 Jun 2025 16:09:12 -0700
In-Reply-To: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com> <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com> <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com> <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
Message-ID: <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Tue, 2025-06-24 at 16:30 -0700, Ackerley Tng wrote:
>> I see, let's call debug checking Topic 3 then, to separate it from Topic
>> 1, which is TDX indicating that it is using a page for production
>> kernels.
>>=20
>> Topic 3: How should TDX indicate use of a page for debugging?
>>=20
>> I'm okay if for debugging, TDX uses anything other than refcounts for
>> checking, because refcounts will interfere with conversions.
>
> Ok. It can be follow on work I think.
>

Yup I agree.

>>=20
>> Rick's other email is correct. The correct link should be
>> https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/.
>>=20
>> [INTERFERE WITH CONVERSIONS]
>>=20
>> To summarize, if TDX uses refcounts to indicate that it is using a page,
>> or to indicate anything else, then we cannot easily split a page on
>> private to shared conversions.
>>=20
>> Specifically, consider the case where only the x-th subpage of a huge
>> folio is mapped into Secure-EPTs. When the guest requests to convert
>> some subpage to shared, the huge folio has to be split for
>> core-mm. Core-mm, which will use the shared page, must have split folios
>> to be able to accurately and separately track refcounts for subpages.
>>=20
>> During splitting, guest_memfd would see refcount of 512 (for 2M page
>> being in the filemap) + 1 (if TDX indicates that the x-th subpage is
>> mapped using a refcount), but would not be able to tell that the 513th
>> refcount belongs to the x-th subpage. guest_memfd can't split the huge
>> folio unless it knows how to distribute the 513th refcount.
>>=20
>> One might say guest_memfd could clear all the refcounts that TDX is
>> holding on the huge folio by unmapping the entire huge folio from the
>> Secure-EPTs, but unmapping the entire huge folio for TDX means zeroing
>> the contents and requiring guest re-acceptance. Both of these would mess
>> up guest operation.
>>=20
>> Hence, guest_memfd's solution is to require that users of guest_memfd
>> for private memory trust guest_memfd to maintain the pages around and
>> not take any refcounts.
>>=20
>> So back to Topic 1, for production kernels, is it okay that TDX does not
>> need to indicate that it is using a page, and can trust guest_memfd to
>> keep the page around for the VM?
>
> I think Yan's concern is not totally invalid. But I don't see a problem i=
f we
> have a line of sight to adding debug checking as follow on work. That is =
kind of
> the path I was trying to nudge.
>
>>=20
>> > >=20
>> > > Topic 2: How to handle unmapping/splitting errors arising from TDX?
>> > >=20
>> > > Previously I was in favor of having unmap() return an error (Rick
>> > > suggested doing a POC, and in a more recent email Rick asked for a
>> > > diffstat), but Vishal and I talked about this and now I agree having
>> > > unmapping return an error is not a good approach for these reasons.
>> >=20
>> > Ok, let's close this option then.
>> >=20
>> > >=20
>> > > 1. Unmapping takes a range, and within the range there could be more
>> > > =C2=A0=C2=A0 than one unmapping error. I was previously thinking tha=
t unmap()
>> > > =C2=A0=C2=A0 could return 0 for success and the failed PFN on error.=
 Returning a
>> > > =C2=A0=C2=A0 single PFN on error is okay-ish but if there are more e=
rrors it could
>> > > =C2=A0=C2=A0 get complicated.
>> > >=20
>> > > =C2=A0=C2=A0 Another error return option could be to return the foli=
o where the
>> > > =C2=A0=C2=A0 unmapping/splitting issue happened, but that would not =
be
>> > > =C2=A0=C2=A0 sufficiently precise, since a folio could be larger tha=
n 4K and we
>> > > =C2=A0=C2=A0 want to track errors as precisely as we can to reduce m=
emory loss due
>> > > =C2=A0=C2=A0 to errors.
>> > >=20
>> > > 2. What I think Yan has been trying to say: unmap() returning an err=
or
>> > > =C2=A0=C2=A0 is non-standard in the kernel.
>> > >=20
>> > > I think (1) is the dealbreaker here and there's no need to do the
>> > > plumbing POC and diffstat.
>> > >=20
>> > > So I think we're all in support of indicating unmapping/splitting is=
sues
>> > > without returning anything from unmap(), and the discussed options a=
re
>> > >=20
>> > > a. Refcounts: won't work - mostly discussed in this (sub-)thread
>> > > =C2=A0=C2=A0 [3]. Using refcounts makes it impossible to distinguish=
 between
>> > > =C2=A0=C2=A0 transient refcounts and refcounts due to errors.
>> > >=20
>> > > b. Page flags: won't work with/can't benefit from HVO.
>> >=20
>> > As above, this was for the purpose of catching bugs, not for guestmemf=
d to
>> > logically depend on it.
>> >=20
>> > >=20
>> > > Suggestions still in the running:
>> > >=20
>> > > c. Folio flags are not precise enough to indicate which page actuall=
y
>> > > =C2=A0=C2=A0 had an error, but this could be sufficient if we're wil=
ling to just
>> > > =C2=A0=C2=A0 waste the rest of the huge page on unmapping error.
>> >=20
>> > For a scenario of TDX module bug, it seems ok to me.
>> >=20
>> > >=20
>> > > d. Folio flags with folio splitting on error. This means that on
>> > > =C2=A0=C2=A0 unmapping/Secure EPT PTE splitting error, we have to sp=
lit the
>> > > =C2=A0=C2=A0 (larger than 4K) folio to 4K, and then set a flag on th=
e split folio.
>> > >=20
>> > > =C2=A0=C2=A0 The issue I see with this is that splitting pages with =
HVO applied
>> > > =C2=A0=C2=A0 means doing allocations, and in an error scenario there=
 may not be
>> > > =C2=A0=C2=A0 memory left to split the pages.
>> > >=20
>> > > e. Some other data structure in guest_memfd, say, a linked list, and=
 a
>> > > =C2=A0=C2=A0 function like kvm_gmem_add_error_pfn(struct page *page)=
 that would
>> > > =C2=A0=C2=A0 look up the guest_memfd inode from the page and add the=
 page's pfn to
>> > > =C2=A0=C2=A0 the linked list.
>> > >=20
>> > > =C2=A0=C2=A0 Everywhere in guest_memfd that does unmapping/splitting=
 would then
>> > > =C2=A0=C2=A0 check this linked list to see if the unmapping/splittin=
g
>> > > =C2=A0=C2=A0 succeeded.
>> > >=20
>> > > =C2=A0=C2=A0 Everywhere in guest_memfd that allocates pages will als=
o check this
>> > > =C2=A0=C2=A0 linked list to make sure the pages are functional.
>> > >=20
>> > > =C2=A0=C2=A0 When guest_memfd truncates, if the page being truncated=
 is on the
>> > > =C2=A0=C2=A0 list, retain the refcount on the page and leak that pag=
e.
>> >=20
>> > I think this is a fine option.
>> >=20
>> > >=20
>> > > f. Combination of c and e, something similar to HugeTLB's
>> > > =C2=A0=C2=A0 folio_set_hugetlb_hwpoison(), which sets a flag AND add=
s the pages in
>> > > =C2=A0=C2=A0 trouble to a linked list on the folio.
>> > >=20
>> > > g. Like f, but basically treat an unmapping error as hardware poison=
ing.
>> > >=20
>> > > I'm kind of inclined towards g, to just treat unmapping errors as
>> > > HWPOISON and buying into all the HWPOISON handling requirements. Wha=
t do
>> > > yall think? Can a TDX unmapping error be considered as memory poison=
ing?
>> >=20
>> > What does HWPOISON bring over refcounting the page/folio so that it ne=
ver
>> > returns to the page allocator?
>>=20
>> For Topic 2 (handling TDX unmapping errors), HWPOISON is better than
>> refcounting because refcounting interferes with conversions (see
>> [INTERFERE WITH CONVERSIONS] above).
>
> I don't know if it quite fits. I think it would be better to not pollute =
the
> concept if possible.
>

If there's something we know for sure doesn't fit, and that we're
overloading/polluting the concept of HWpoison, then we shouldn't
proceed, but otherwise, is it okay to go with HWpoison as a first cut? I
replied Yan's email with reasons why I think we should give HWpoison a
try, at least for the next RFC.

>>=20
>> > We are bugging the TD in these cases.
>>=20
>> Bugging the TD does not help to prevent future conversions from being
>> interfered with.
>>=20
>> 1. Conversions involves unmapping, so we could actually be in a
>> =C2=A0=C2=A0 conversion, the unmapping is performed and fails, and then =
we try to
>> =C2=A0=C2=A0 split and enter an infinite loop since private to shared co=
nversions
>> =C2=A0=C2=A0 assumes guest_memfd holds the only refcounts on guest_memfd=
 memory.
>>=20
>> 2. The conversion ioctl is a guest_memfd ioctl, not a VM ioctl, and so
>> =C2=A0=C2=A0 there is no check that the VM is not dead. There shouldn't =
be any
>> =C2=A0=C2=A0 check on the VM, because shareability is a property of the =
memory and
>> =C2=A0=C2=A0 should be changeable independent of the associated VM.
>
> Hmm, they are both about unlinking guestmemfd from a VM lifecycle then. I=
s that
> a better way to put it?
>

Unmapping during conversions doesn't take memory away from a VM, it just
forces the memory to be re-faulted as shared, so unlinking memory from a
VM lifecycle isn't quite accurate, if I understand you correctly.

>>=20
>> > Ohhh... Is
>> > this about the code to allow gmem fds to be handed to new VMs?
>>=20
>> Nope, it's not related to linking. The proposed KVM_LINK_GUEST_MEMFD
>> ioctl [4] also doesn't check if the source VM is dead. There shouldn't
>> be any check on the source VM, since the memory is from guest_memfd and
>> should be independently transferable to a new VM.
>
> If a page is mapped in the old TD, and a new TD is started, re-mapping th=
e same
> page should be prevented somehow, right?
>

Currently I'm thinking that if we go with HWpoison, the new TD will
still get the HWpoison-ed page. The new TD will get the SIGBUS when it
next faults the HWpoison-ed page.

Are you thinking that the HWpoison-ed page should be replaced with a
non-poisoned page for the new TD to run?

Or are you thinking that

* the handing over should be blocked, or
* mapping itself should be blocked, or
* faulting should be blocked?

If handing over should be blocked, could we perhaps scan for HWpoison
when doing the handover and block it there?

I guess I'm trying to do as little as possible during error discovery
(hoping to just mark HWpoison), error handling (just unmap from guest
page tables, like guest_memfd does now), and defer handling to
fault/conversion/perhaps truncation time.

> It really does seem like guestmemfd is the right place to keep the the "s=
tuck
> page" state. If guestmemfd is not tied to a VM and can be re-used, it sho=
uld be
> the one to decide whether they can be mapped again.

Yup, guest_memfd should get to decide.

> Refcounting on error is
> about preventing return to the page allocator but that is not the only pr=
oblem.
>

guest_memfd, or perhaps the memory_failure() handler for guest_memfd,
should prevent this return.

> I do think that these threads have gone on far too long. It's probably ab=
out
> time to move forward with something even if it's just to have something t=
o
> discuss that doesn't require footnoting so many lore links. So how about =
we move
> forward with option e as a next step. Does that sound good Yan?
>

Please see my reply to Yan, I'm hoping y'all will agree to something
between option f/g instead.

> Ackerley, thank you very much for pulling together this summary.

Thank you for your reviews and suggestions!

