Return-Path: <kvm+bounces-67462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1A2D06046
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BE58303D69A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E6032ED27;
	Thu,  8 Jan 2026 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KdR1+tQz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F4F32ED42
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903406; cv=none; b=DoaYPfHvW2hJhY4uHNeHh9qSo9Hd/FRDPZt+ftTx0kMWVNrOfh14YpKNW8SaM2VpU3HDGy9VTMLzBYtElsx6O2a0KIT3/U5pV+mySJoxCgyr1XOQG1S+q8y0dSSmuFro6IaU3viJ+HKMn6TCDulc6tTbZwBaon9Oo3rL1MRh6co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903406; c=relaxed/simple;
	bh=UyJforULdsPfvHYd6phrKebsHLrPiuSV4mjwSGUDB9I=;
	h=MIME-Version:Date:In-Reply-To:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FnhtDcFmUOdqSWAU2xcKswMbYKSsHkHLnYSnITVOnfnMmK7lXfwRBv/4quyIDYpn0inLLf09RLeCFqasrqEU6X0W0ptPEE+owTYlvQo8lPF58Z3DW8VmcBGNnQh9FG65GvGH81CFKlpn0/qfHkK9AXlNUKIg2TsReED8/7oDKx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KdR1+tQz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c2f670a06so4207530a91.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 12:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767903401; x=1768508201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :in-reply-to:date:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uvc3mwVCdRwPfGNOHunJTh1FEaoJ2AbsGfyR//kXHw0=;
        b=KdR1+tQzQJKJM21nCB2bIi0dfjKmus6ji44QGMg9EcZXuLOLrUtP+Y3N4n8EzwMPEz
         EOWCiD6G8dBw2HwNsL8MEBxlDN5KsZzP1aOIhqlFZ22SIVS7BW1CLyhN4MKOMG0nV3Dg
         lb7pOSnraIkwAA44km22iXLxImSMKN89A1MWqtb3gGMnXJx9LYmP+iDg3xBIsBmoywS+
         RqGDfpTCqp/t3TT3YU3dv0R0Ptla6n/SIW4iDJ5VTdD2joQJQXvKQywOtRgXL1m2eQOg
         yLCrX63YJZ7c+hDRvm0YTPaEMZMautAvGPKVcJzHwN8QZM602cEBP4n4TzO6rNYaEdqQ
         Esvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767903401; x=1768508201;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Uvc3mwVCdRwPfGNOHunJTh1FEaoJ2AbsGfyR//kXHw0=;
        b=rH7sxrOjhAGJgPt1XYhwi+la9aacB6oUiV8tRTDTYyex1Qm83L2wYlpNEMun/AQMkw
         fxL7OX2xOCM9P/oALheMggZjIWjJUnteS80k1je5E2ilaM7RdEZrhQ0h2cEBjNMeZNQI
         QPNoQHDhfVMZ6Oonu1uKj2prH5Omya+DzSupiTaq5je3QScWrSSMGEDyr9NynJF12oy9
         +wuudobBJDKO3hsxTDi3KaPcFzPWD6KjfXXzr9JWZ52Q2PJNbCSUi4RRooYnLkn9qUPM
         MOk2wbACONQ2845pugpvIZct6uHt8RGnOl+Rvm8Ldi4+Z7xIf7wDFTBiLZROlDi1NaiG
         Zb5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVmd75AZu62oNweMsTS2By9OxQ84aYQ/818SoPZZ/IwlUTagfw67GFpwQnAbYzTMrCvqDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YytaefHPuxpR9eEO18+1MFH3tJ1hgug/nP82xMOvQNE8Wgsw22M
	6eZLsWNBi+V/2wmQIogxuKgcje+16peIROaTUjHdwODNx5nvomFI0poKEmw7dyq4SRk/vM0Ia6C
	Qcpbg3Bkcad+YORurTQum7U76SQ==
X-Google-Smtp-Source: AGHT+IFxdvTrZA3CZy+mFaunOLUU1xw7TZSMYDmKQSmmM+M3pWKqzWdwJwdvNkL8tPyNAEF3shgLFcY/3Cju7ABPBA==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pjbqo8.prod.google.com ([2002:a17:90b:3dc8:b0:34c:3239:171f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b8d:b0:340:f05a:3ed3 with SMTP id 98e67ed59e1d1-34f68c02462mr7703524a91.17.1767903400616;
 Thu, 08 Jan 2026 12:16:40 -0800 (PST)
Date: Thu, 08 Jan 2026 12:11:14 -0800
In-Reply-To: <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
Message-ID: <diqzqzrzdfvh.fsf@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
>> On Tue, Jan 06, 2026, Ackerley Tng wrote:
>> > Sean Christopherson <seanjc@google.com> writes:
>> >
>> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
>> > >> Vishal Annapurve <vannapurve@google.com> writes:
>> > >>
>> > >> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel=
.com> wrote:
>> > >> >>
>> > >> >> - EPT mapping size and folio size
>> > >> >>
>> > >> >>   This series is built upon the rule in KVM that the mapping siz=
e in the
>> > >> >>   KVM-managed secondary MMU is no larger than the backend folio =
size.
>> > >> >>
>> > >>
>> > >> I'm not familiar with this rule and would like to find out more. Wh=
y is
>> > >> this rule imposed?
>> > >
>> > > Because it's the only sane way to safely map memory into the guest? =
:-D
>> > >
>> > >> Is this rule there just because traditionally folio sizes also defi=
ne the
>> > >> limit of contiguity, and so the mapping size must not be greater th=
an folio
>> > >> size in case the block of memory represented by the folio is not co=
ntiguous?
>> > >
>> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size w=
as (and still
>> > > is) strictly bound by the host mapping size.  That's handles contigu=
ous addresses,
>> > > but it _also_ handles contiguous protections (e.g. RWX) and other at=
tributes.
>> > >
>> > >> In guest_memfd's case, even if the folio is split (just for refcoun=
t
>> > >> tracking purposese on private to shared conversion), the memory is =
still
>> > >> contiguous up to the original folio's size. Will the contiguity add=
ress
>> > >> the concerns?
>> > >
>> > > Not really?  Why would the folio be split if the memory _and its att=
ributes_ are
>> > > fully contiguous?  If the attributes are mixed, KVM must not create =
a mapping
>> > > spanning mixed ranges, i.e. with multiple folios.
>> >
>> > The folio can be split if any (or all) of the pages in a huge page ran=
ge
>> > are shared (in the CoCo sense). So in a 1G block of memory, even if th=
e
>> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
>> > would be split, and the split folios are necessary for tracking users =
of
>> > shared pages using struct page refcounts.
>>
>> Ahh, that's what the refcounting was referring to.  Gotcha.
>>
>> > However the split folios in that 1G range are still fully contiguous.
>> >
>> > The process of conversion will split the EPT entries soon after the
>> > folios are split so the rule remains upheld.

Correction here: If we go with splitting from 1G to 4K uniformly on
sharing, only the EPT entries around the shared 4K folio will have their
page table entries split, so many of the EPT entries will be at 2M level
though the folios are 4K sized. This would be last beyond the conversion
process.

> Overall, I don't think allowing folios smaller than the mappings while
> conversion is in progress brings enough benefit.
>

I'll look into making the restructuring process always succeed, but off
the top of my head that's hard because

1. HugeTLB Vmemmap Optimization code would have to be refactored to
   use pre-allocated pages, which is refactoring deep in HugeTLB code

2. If we want to split non-uniformly such that only the folios that are
   shared are 4K, and the remaining folios are as large as possible (PMD
   sized as much as possible), it gets complex to figure out how many
   pages to allocate ahead of time.

So it's complex and will probably delay HugeTLB+conversion support even
more!

> Cons:
> (1) TDX's zapping callback has no idea whether the zapping is caused by a=
n
>     in-progress private-to-shared conversion or other reasons. It also ha=
s no
>     idea if the attributes of the underlying folios remain unchanged duri=
ng an
>     in-progress private-to-shared conversion. Even if the assertion Acker=
ley
>     mentioned is true, it's not easy to drop the sanity checks in TDX's z=
apping
>     callback for in-progress private-to-shared conversion alone (which wo=
uld
>     increase TDX's dependency on guest_memfd's specific implementation ev=
en if
>     it's feasible).
>
>     Removing the sanity checks entirely in TDX's zapping callback is conf=
using
>     and would show a bad/false expectation from KVM -- what if a huge fol=
io is
>     incorrectly split while it's still mapped in KVM (by a buggy guest_me=
mfd or
>     others) in other conditions? And then do we still need the check in T=
DX's
>     mapping callback? If not, does it mean TDX huge pages can stop relyin=
g on
>     guest_memfd's ability to allocate huge folios, as KVM could still cre=
ate
>     huge mappings as long as small folios are physically contiguous with
>     homogeneous memory attributes?
>
> (2) Allowing folios smaller than the mapping would require splitting S-EP=
T in
>     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argue th=
at the
>     invalidate lock held in __kvm_gmem_set_attributes() could guard again=
st
>     concurrent kvm_gmem_error_folio(), it still doesn't seem clean and lo=
oks
>     error-prone. (This may also apply to kvm_gmem_migrate_folio() potenti=
ally).
>

I think the central question I have among all the above is what TDX
needs to actually care about (putting aside what KVM's folio size/memory
contiguity vs mapping level rule for a while).

I think TDX code can check what it cares about (if required to aid
debugging, as Dave suggested). Does TDX actually care about folio sizes,
or does it actually care about memory contiguity and alignment?

Separately, KVM could also enforce the folio size/memory contiguity vs
mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
the check is deemed necessary, it still shouldn't be in TDX code, I
think.

> Pro: Preventing zapping private memory until conversion is successful is =
good.
>
> However, could we achieve this benefit in other ways? For example, is it
> possible to ensure hugetlb_restructuring_split_folio() can't fail by ensu=
ring
> split_entries() can't fail (via pre-allocation?) and disabling hugetlb_vm=
emmap
> optimization? (hugetlb_vmemmap conversion is super slow according to my
> observation and I always disable it).

HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
huge VM, multiplied by a large number of hosts, this is not a trivial
amount of memory. It's one of the key reasons why we are using HugeTLB
in guest_memfd in the first place, other than to be able to get high
level page table mappings. We want this in production.

> Or pre-allocation for
> vmemmap_remap_alloc()?
>

Will investigate if this is possible as mentioned above. Thanks for the
suggestion again!

> Dropping TDX's sanity check may only serve as our last resort. IMHO, zapp=
ing
> private memory before conversion succeeds is still better than introducin=
g the
> mess between folio size and mapping size.
>
>> > I guess perhaps the question is, is it okay if the folios are smaller
>> > than the mapping while conversion is in progress? Does the order matte=
r
>> > (split page table entries first vs split folios first)?
>>
>> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogen=
ous is
>> conceptually totally fine, i.e. I'm not totally opposed to adding suppor=
t for
>> mapping multiple guest_memfd folios with a single hugepage.   As to whet=
her we
>> do (a) nothing, (b) change the refcounting, or (c) add support for mappi=
ng
>> multiple folios in one page, probably comes down to which option provide=
s "good
>> enough" performance without incurring too much complexity.

