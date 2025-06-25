Return-Path: <kvm+bounces-50770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9DADAE915C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1DE63AB66E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F88F2F3C0C;
	Wed, 25 Jun 2025 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yy1h14tB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B644F1EA7EC
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892088; cv=none; b=VlOFrdTl0VgPh36N7LK8idnWoXtGPMKp8EGlcFuTL8oLglFY9vlYptrQWO+jsN2xT6iDWS7g/2w0SKNHK2E3+sOkVhu51Pv4aq1poVRSdtiljs9Ykt+pzIN6KcZ4U0BYgiQ9JWbC+qsoOpIhOd3mYuAd7/j4N09SH9XSzXT5dLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892088; c=relaxed/simple;
	bh=HEfJPWdCSSFS+ASivH78C0lg7gqi/7RDBA+T2IZ3uo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ugKlPGpTuTG6jxG/P0d2VhlCpj6rSa4SusLcF8RT9Je1zgNwyxBnZp21UCA9K5z4lSoI2m3x7FhyDC2Pg5Ncg2+AXrmxsAkXQ00Yzq6h5Xf37MX4UrAWOO6QmzMqtwWx/+t/k0NGxUwmIJdi3BhbEf1fw5tYcjHotM3iqjDx+Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yy1h14tB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-749177ad09fso146335b3a.2
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750892086; x=1751496886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jVxFMBb/sntNrVg4iPMTgUrHj+NwKt88HjNTcpkE/WA=;
        b=Yy1h14tBMsi+mv0AQVkX/wIFfsNoB1xWHE6KfPqKqXVGuA8gvtfPCuQsUhnHrs/h5J
         7RyT/VJgw5p9SSXSX7FVceKHPUpunWbcD33p7rNIdT8hi/fWCW4S/T2D0nLii7dN9gth
         dcyX5Ly+CRAT3U2hP9uZAsqb1aihdPEPhwz4BvRr8tkqRyPH18l2750xO6gLL0nC5R4u
         ktHjVwQBwwGA4te+QkuawJYRc9z4lZ+FDmcU6+8OHPyoYCyw5K6q6d+2iSEQtslk8wBZ
         MUDnN02rB3zdTpEIw433U/tJy38W6bfLIxMxxXegqijzRXWwuaMN7D3/7ew9lmg6fKFE
         VLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750892086; x=1751496886;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jVxFMBb/sntNrVg4iPMTgUrHj+NwKt88HjNTcpkE/WA=;
        b=Yh7oO998JMJfBy/eeHC+hwbfU3U0Iyan4n6PpBcLs76vjEtveE86Oco5LipmWsuMvD
         GQ5IBuybRu6yCCNLqNoBmt8Rz968l6LE+zc9ohbEgM30Mo84m1yB/FWd9MpV3SP4VMCu
         s8452R2dHOU4JmbP79SVUA+JFbFKpca7HieiSh+3f/Cn3VOFDK+hCe6xJwI5aKIfSCCq
         whw2NQvIcmnnwVqrTjsmzJ/hM4HQ4C5k4ZR6f7nxkgKhlIsSTISx+mPGtISADxHBbDS7
         BwyC4bmobxmxxVWUeYiHnUY/iM01rx9prrtNetIXfuZZkFQZUyeJsKkq/ajewloADdg7
         imwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2cGEnrocjSO1QXuMeGAUFoDzUoQgjdxcc0JlC0PCf1bogmfTkfZRqoA1vNrES6UVMD9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOPjp4d7+l/IOi4DyITX6csr8ZT295y4sEmgCQ8aOxsr5q2ZRm
	JGYdLTCJ1uwqb0lwghGsbDWcO52fCUDM5sZ4rEqpIvwikjLdBcJL0nN2dh1o+O3YRFUb9qeW2QO
	waDqoWLGCtm5hMhmlGcB2d2YJIg==
X-Google-Smtp-Source: AGHT+IF0Vs1oph1wvu7WrIfD42vnAsw01GJuRYxL+r6kkTUnsEXAv69JKOmRzT9QMp88/AiomiMLd3SmuWFWtrX8PA==
X-Received: from pfbdh9.prod.google.com ([2002:a05:6a00:4789:b0:747:abae:78e8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6b0a:b0:21f:86f1:e2dd with SMTP id adf61e73a8af0-2207f1c4c56mr6857359637.11.1750892086023;
 Wed, 25 Jun 2025 15:54:46 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:54:44 -0700
In-Reply-To: <aFugbDVJJDrK4n9V@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com> <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com> <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com> <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <aFugbDVJJDrK4n9V@yzhao56-desk.sh.intel.com>
Message-ID: <diqzplerjutn.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Du, Fan" <fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, Jun 24, 2025 at 04:30:57PM -0700, Ackerley Tng wrote:
>> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
>>=20
>> > On Mon, 2025-06-23 at 15:48 -0700, Ackerley Tng wrote:
>> >> Let me try and summarize the current state of this discussion:
>> >>=20
>> >> Topic 1: Does TDX need to somehow indicate that it is using a page?
>> >>=20
>> >> This patch series uses refcounts to indicate that TDX is using a page=
,
>> >> but that complicates private-to-shared conversions.
>> >>=20
>> >> During a private-to-shared conversion, guest_memfd assumes that
>> >> guest_memfd is trusted to manage private memory. TDX and other users
>> >> should trust guest_memfd to keep the memory around.
>> >>=20
>> >> Yan's position is that holding a refcount is in line with how IOMMU
>> >> takes a refcount when a page is mapped into the IOMMU [1].
>> >>=20
>> >> Yan had another suggestion, which is to indicate using a page flag [2=
].
>> >>=20
>> >> I think we're in agreement that we don't want to have TDX hold a
>> >> refcount while the page is mapped into the Secure EPTs, but taking a
>> >> step back, do we really need to indicate (at all) that TDX is using a
>> >> page?
>> >>=20
>> >> In [3] Yan said
>> >>=20
>> >> > If TDX does not hold any refcount, guest_memfd has to know that whi=
ch
>> >> > private
>> >> > page is still mapped. Otherwise, the page may be re-assigned to oth=
er
>> >> > kernel
>> >> > components while it may still be mapped in the S-EPT.
>> >>=20
>> >> If the private page is mapped for regular VM use as private memory,
>> >> guest_memfd is managing that, and the same page will not be re-assign=
ed
>> >> to any other kernel component. guest_memfd does hold refcounts in
>> >> guest_memfd's filemap.
>> >>=20
>> >> If the private page is still mapped because there was an unmapping
>> >> failure, we can discuss that separately under error handling in Topic=
 2.
>> >>=20
>> >> With this, can I confirm that we are in agreement that TDX does not n=
eed
>> >> to indicate that it is using a page, and can trust guest_memfd to kee=
p
>> >> the page around for the VM?
>> >
>> > Minor correction here. Yan was concerned about *bugs* happening when f=
reeing
>> > pages that are accidentally still mapped in the S-EPT. My opinion is t=
hat this
>> > is not especially risky to happen here vs other similar places, but it=
 could be
>> > helpful if there was a way to catch such bugs. The page flag, or page_=
ext
>> > direction came out of a discussion with Dave and Kirill. If it could r=
un all the
>> > time that would be great, but if not a debug config could be sufficien=
t. For
>> > example like CONFIG_PAGE_TABLE_CHECK. It doesn't need to support vmemm=
ap
>> > optimizations because the debug checking doesn't need to run all the t=
ime.
>> > Overhead for debug settings is very normal.
>> >
>>=20
>> I see, let's call debug checking Topic 3 then, to separate it from Topic
>> 1, which is TDX indicating that it is using a page for production
>> kernels.
>>=20
>> Topic 3: How should TDX indicate use of a page for debugging?
>>=20
>> I'm okay if for debugging, TDX uses anything other than refcounts for
>> checking, because refcounts will interfere with conversions.
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
> In my POC, https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh=
.intel.com/
> kvm_gmem_private_has_safe_refcount() was introduce to check the folio ref=
 count.
> It rejects private-to-shared conversion after splitting and unmapping KVM=
's
> secondary page tables if the refcount exceeds a valid threshold.
>
> Though in
> https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/, =
we
> agreed that "EAGAIN is not the right code in case of "extra" refcounts he=
ld by
> TDX", this does not imply that rejecting the conversion itself is incorre=
ct.
>
> This is why we are exploring alternative solutions instead of having TDX =
hold
> the page refcount.
>
> So, either a per-page flag, per-folio flag or solutions e,f,g should be g=
ood.
>
> IMO, regardless of the final choice, guest_memfd needs to identify proble=
matic
> folios to:
> - reject the private-to-shared conversion
> - prevent further recycling after kvm_gmem_free_folio()
>

Agreed!

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
> If the "TDX does not need to indicate that it is using a page" means "do =
not
> take page refcount", I'm ok.
>

Yes, I was trying to generalize "do not take page refcount" to "TDX does
not need to indicate that it is using a page", but I guess TDX can
indicate that it is using a page for debugging as long as it doesn't
use refcounts or otherwise interfere with conversions. So I believe we
are in agreement on Topic 1 :)

>> >>=20
>> >> Topic 2: How to handle unmapping/splitting errors arising from TDX?
>> >>=20
>> >> Previously I was in favor of having unmap() return an error (Rick
>> >> suggested doing a POC, and in a more recent email Rick asked for a
>> >> diffstat), but Vishal and I talked about this and now I agree having
>> >> unmapping return an error is not a good approach for these reasons.
>> >
>> > Ok, let's close this option then.
>> >
>> >>=20
>> >> 1. Unmapping takes a range, and within the range there could be more
>> >> =C2=A0=C2=A0 than one unmapping error. I was previously thinking that=
 unmap()
>> >> =C2=A0=C2=A0 could return 0 for success and the failed PFN on error. =
Returning a
>> >> =C2=A0=C2=A0 single PFN on error is okay-ish but if there are more er=
rors it could
>> >> =C2=A0=C2=A0 get complicated.
>> >>=20
>> >> =C2=A0=C2=A0 Another error return option could be to return the folio=
 where the
>> >> =C2=A0=C2=A0 unmapping/splitting issue happened, but that would not b=
e
>> >> =C2=A0=C2=A0 sufficiently precise, since a folio could be larger than=
 4K and we
>> >> =C2=A0=C2=A0 want to track errors as precisely as we can to reduce me=
mory loss due
>> >> =C2=A0=C2=A0 to errors.
>> >>=20
>> >> 2. What I think Yan has been trying to say: unmap() returning an erro=
r
>> >> =C2=A0=C2=A0 is non-standard in the kernel.
>> >>=20
>> >> I think (1) is the dealbreaker here and there's no need to do the
>> >> plumbing POC and diffstat.
>> >>=20
>> >> So I think we're all in support of indicating unmapping/splitting iss=
ues
>> >> without returning anything from unmap(), and the discussed options ar=
e
>> >>=20
>> >> a. Refcounts: won't work - mostly discussed in this (sub-)thread
>> >> =C2=A0=C2=A0 [3]. Using refcounts makes it impossible to distinguish =
between
>> >> =C2=A0=C2=A0 transient refcounts and refcounts due to errors.
>> >>=20
>> >> b. Page flags: won't work with/can't benefit from HVO.
>> >
>> > As above, this was for the purpose of catching bugs, not for guestmemf=
d to
>> > logically depend on it.
>> >
>> >>=20
>> >> Suggestions still in the running:
>> >>=20
>> >> c. Folio flags are not precise enough to indicate which page actually
>> >> =C2=A0=C2=A0 had an error, but this could be sufficient if we're will=
ing to just
>> >> =C2=A0=C2=A0 waste the rest of the huge page on unmapping error.
>> >
>> > For a scenario of TDX module bug, it seems ok to me.
>> >
>> >>=20
>> >> d. Folio flags with folio splitting on error. This means that on
>> >> =C2=A0=C2=A0 unmapping/Secure EPT PTE splitting error, we have to spl=
it the
>> >> =C2=A0=C2=A0 (larger than 4K) folio to 4K, and then set a flag on the=
 split folio.
>> >>=20
>> >> =C2=A0=C2=A0 The issue I see with this is that splitting pages with H=
VO applied
>> >> =C2=A0=C2=A0 means doing allocations, and in an error scenario there =
may not be
>> >> =C2=A0=C2=A0 memory left to split the pages.
>> >>=20
>> >> e. Some other data structure in guest_memfd, say, a linked list, and =
a
>> >> =C2=A0=C2=A0 function like kvm_gmem_add_error_pfn(struct page *page) =
that would
>> >> =C2=A0=C2=A0 look up the guest_memfd inode from the page and add the =
page's pfn to
>> >> =C2=A0=C2=A0 the linked list.
>> >>=20
>> >> =C2=A0=C2=A0 Everywhere in guest_memfd that does unmapping/splitting =
would then
>> >> =C2=A0=C2=A0 check this linked list to see if the unmapping/splitting
>> >> =C2=A0=C2=A0 succeeded.
>> >>=20
>> >> =C2=A0=C2=A0 Everywhere in guest_memfd that allocates pages will also=
 check this
>> >> =C2=A0=C2=A0 linked list to make sure the pages are functional.
>> >>=20
>> >> =C2=A0=C2=A0 When guest_memfd truncates, if the page being truncated =
is on the
>> >> =C2=A0=C2=A0 list, retain the refcount on the page and leak that page=
.
>> >
>> > I think this is a fine option.
>> >
>> >>=20
>> >> f. Combination of c and e, something similar to HugeTLB's
>> >> =C2=A0=C2=A0 folio_set_hugetlb_hwpoison(), which sets a flag AND adds=
 the pages in
>> >> =C2=A0=C2=A0 trouble to a linked list on the folio.
>> >>=20
>> >> g. Like f, but basically treat an unmapping error as hardware poisoni=
ng.
>> >>=20
>> >> I'm kind of inclined towards g, to just treat unmapping errors as
>> >> HWPOISON and buying into all the HWPOISON handling requirements. What=
 do
>> >> yall think? Can a TDX unmapping error be considered as memory poisoni=
ng?
>> >
>> > What does HWPOISON bring over refcounting the page/folio so that it ne=
ver
>> > returns to the page allocator?
>>=20
>> For Topic 2 (handling TDX unmapping errors), HWPOISON is better than
>> refcounting because refcounting interferes with conversions (see
>> [INTERFERE WITH CONVERSIONS] above).
>>=20
>> > We are bugging the TD in these cases.
>>=20
>> Bugging the TD does not help to prevent future conversions from being
>> interfered with.
>>=20
>> 1. Conversions involves unmapping, so we could actually be in a
>>    conversion, the unmapping is performed and fails, and then we try to
>>    split and enter an infinite loop since private to shared conversions
>>    assumes guest_memfd holds the only refcounts on guest_memfd memory.
> We should bail out conversion even with the HWPOISON.
> e.g.,
> 1. user triggers private-to-shared ioctl to convert 4K page A within a 2M=
B folio
>    B to shared.
> 2. kvm_gmem_convert_should_proceed() executes kvm_gmem_split_private() an=
d
>    kvm_gmem_zap().
> 3. kvm_gmem_convert_should_proceed() checks kvm_gmem_has_invalid_folio()
>    (Suppose TDX sets HWPOISON to page A or folio B after kvm_gmem_zap(), =
then
>      kvm_gmem_has_invalid_folio() should return true).
> 4. Return -EFAULT.
>
> If we allow the actual conversion to proceed after step 3, folio B will b=
e split
> into 4KB folios, with page A being converted to a shared 4KB folio, which
> becomes accessible by userspace.
>
> This could cause a machine check (#MC) on certain platforms. We should av=
oid
> this scenario when possible.
>
>

Thanks for pointing this out. This is a good point and will definitely
have to be handled separately under "what to do when there was some
issue on a page (possibly caused by unmapping)", or as Yan pointed out
above, what to do when "handling problematic folios".

Regarding handling errors, or recording errors, or communicating errors
to guest_memfd, Yan seems in favor of some kind of page flag. I know
Rick is suggesting option e. Can we do something between f and g? I'm
thinking that the easiest page flag to use is the HWpoison flag, because

1. HWpoison checking is already part of guest_memfd, or should
   be.

   guest_memfd already checks HWpoison for kvm_gmem_get_pfn(), and
   __do_fault() checks HWpoison for guest_memfd [5]. As Yan pointed out
   above, it should definitely check and deal with HWpoison on
   conversion. Perhaps on truncation it should look at HWpoison, or very
   likely memory_failure() will need special handling for guest_memfd
   folios. I'll look into this separately as part of HugeTLB support
   patch series.

2. HWpoison support (especially tracking of sub-folio HWpoison) in
   folio_set_hugetlb_hwpoison() can hopefully be reused for guest_memfd.

3. For now, no need to invent a new tracking mechanism or data structure
   to support option e.

4. HWpoison is kind of "part of guest_memfd" if you consider that
   guest_memfd folios to be pretty much always owned by some guest_memfd
   inode, and if the HWpoison flag is checked at the appropriate places.

Could we (at least for the next RFC of this TDX huge page support for
private memory series, or as a first cut), use HWpoison, and then if we
identify that the concept of HWpoison is being overloaded/polluted, then
try another flag/mechanism for tracking?

I plan to work on HWpoison/kvm_gmem_error_folio() handling for HugeTLB
soon and then I can keep the community updated if I find anything new or
incompatible.

>> 2. The conversion ioctl is a guest_memfd ioctl, not a VM ioctl, and so
>>    there is no check that the VM is not dead. There shouldn't be any
>>    check on the VM, because shareability is a property of the memory and
>>    should be changeable independent of the associated VM.
>>=20
>> > Ohhh... Is
>> > this about the code to allow gmem fds to be handed to new VMs?
>>=20
>> Nope, it's not related to linking. The proposed KVM_LINK_GUEST_MEMFD
>> ioctl [4] also doesn't check if the source VM is dead. There shouldn't
>> be any check on the source VM, since the memory is from guest_memfd and
>> should be independently transferable to a new VM.
>>=20
>> [4] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com=
/T/

[5] https://lore.kernel.org/all/diqzv7ojjxyd.fsf@ackerleytng-ctop.c.googler=
s.com/

