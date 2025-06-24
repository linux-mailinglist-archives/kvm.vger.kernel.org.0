Return-Path: <kvm+bounces-50589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FACAAE7331
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D09931BC29BD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDDF26B75D;
	Tue, 24 Jun 2025 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OLxpsjua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F726B2D6
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 23:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750807861; cv=none; b=SN+G8tN/FvWUxA+dhEAdLj9CNaWCS1iEZDlVbeB3KBkXVXPdMfOy3tJtlCnO17abjFGso3wxJA9rx+0j8Ajyjf9mW7imqhMitQHTU+oQNXJn19QzKs9xiy6tgyWfSMJXY0R8IeDJE/yWl2eRFKZJkKauIDyJdJcbyedZA0YZ2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750807861; c=relaxed/simple;
	bh=G0QA6EhjQoHJ4msURoBtUwJ8DqyVQ/+4mpQMBmSaPeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F+n1gM8dtdeinH7fSg+JYkXRLmK4KUSoKE+9RMa98zC+jsu0ODH5RFD1eoKrl7Clsr6goJ+Jjf0zrPTGPfYrYcuC4P5dVeiner3V4XFa+RrhQJvcHsKAkoLwDYA1AKoSUl5OLb93j2LXvDseabf/bSd22TbEnU6sbQQetapPvzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OLxpsjua; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso210749b3a.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750807859; x=1751412659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k7bVufurzKMbQYqev0HYl+XbE75Sktt4q+sPFQcqMZs=;
        b=OLxpsjuawf8P7IRf9uaCa77yLUC0+BaXha8XHh4ZNe/rQj0T2CNs3bDh+1J6UBUpOr
         Yn/DjPkd5NiThzNQfJZm0LqSM8TAuo/8Y3No3EXx5LNkhp6AFAMevY5WhQmXUE5lYpeG
         SNcKWJaS21DaB5brl9fIU7NDAWim8HdGbpp2qdyT5IR/ZgG7DUViwyKbm4l3j5j6duTt
         EtZ+jWIhbKcJI8z2nRpHqQ9+EWrsNouYjJ8MS38v1mfx3wGZ/HHfQ2horQlLLMrkA20w
         YbOwYn8WfkbfZiQxkoO05lMKhRBYqRhangl1q1MXe3gpzl+0Hp6Sj9vJhrEzC+UZ+JgX
         1Ydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750807859; x=1751412659;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k7bVufurzKMbQYqev0HYl+XbE75Sktt4q+sPFQcqMZs=;
        b=C9+R0fn0fxTnUFb3Rn0cA5pddP1c6WLZyDrmZbdErtNbun5g2bT0DTKhOOZgXds2zM
         VPAvi//uB7leFab5WyacuvwsxM9XEXJhDPTZ5c+gcFGnZcOZPBj5hAzoxhMo52Aodc1l
         tWGK0hzM/y8CkIJPmeQ4OCw7Xj2zvAcE5OsmSTSoYd/OE+f6ryObjFcbdLb6DrkGTTwg
         JvTxeta7IddpKdG7MopSA53ZEO/J3Ii8kpekKPtQufsLuMtdJDzb6PMYaGvFw7gQBhCC
         qAoojPh7J4yMlCj9b4rnfW8eqBkH0/lDxcpvCuWiAmAJm68NRNCVpdb4d2SH8lAJjgi4
         nXaw==
X-Forwarded-Encrypted: i=1; AJvYcCV/v3yGUAgXt/7ifUS7Vn0DBdRP/inxW+ZqF1TLgoI5PMtFGpp4RzWpyDelv+rQ1Lm1rpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTU8otsOyO74bXNVhlQOSoVMZv8YpHdmiGmVgpeKeosdpU/a36
	Me0hFSzpjMO8nO8by4olp1SpM7mLpBVPIXDTe58YWuAK7aaXd2T7iBKmiDKAO8aDG4RCCAH+hsV
	TxC/Scn8+uvkkP6NeGDyXf12Fiw==
X-Google-Smtp-Source: AGHT+IFHOXkuHoFSuO4cxXMRql20r565PaY6nEigUWC9RlAjf2JY4s3m4YHelr26msO/QnZLUX+oUeY/8RWe5nDaGA==
X-Received: from pgbbz36.prod.google.com ([2002:a05:6a02:624:b0:b2e:b47d:8dc])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a51e:b0:220:7e5f:b2fe with SMTP id adf61e73a8af0-2207e5fb348mr1205881637.21.1750807858634;
 Tue, 24 Jun 2025 16:30:58 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:30:57 -0700
In-Reply-To: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
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
Message-ID: <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
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

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Mon, 2025-06-23 at 15:48 -0700, Ackerley Tng wrote:
>> Let me try and summarize the current state of this discussion:
>>=20
>> Topic 1: Does TDX need to somehow indicate that it is using a page?
>>=20
>> This patch series uses refcounts to indicate that TDX is using a page,
>> but that complicates private-to-shared conversions.
>>=20
>> During a private-to-shared conversion, guest_memfd assumes that
>> guest_memfd is trusted to manage private memory. TDX and other users
>> should trust guest_memfd to keep the memory around.
>>=20
>> Yan's position is that holding a refcount is in line with how IOMMU
>> takes a refcount when a page is mapped into the IOMMU [1].
>>=20
>> Yan had another suggestion, which is to indicate using a page flag [2].
>>=20
>> I think we're in agreement that we don't want to have TDX hold a
>> refcount while the page is mapped into the Secure EPTs, but taking a
>> step back, do we really need to indicate (at all) that TDX is using a
>> page?
>>=20
>> In [3] Yan said
>>=20
>> > If TDX does not hold any refcount, guest_memfd has to know that which
>> > private
>> > page is still mapped. Otherwise, the page may be re-assigned to other
>> > kernel
>> > components while it may still be mapped in the S-EPT.
>>=20
>> If the private page is mapped for regular VM use as private memory,
>> guest_memfd is managing that, and the same page will not be re-assigned
>> to any other kernel component. guest_memfd does hold refcounts in
>> guest_memfd's filemap.
>>=20
>> If the private page is still mapped because there was an unmapping
>> failure, we can discuss that separately under error handling in Topic 2.
>>=20
>> With this, can I confirm that we are in agreement that TDX does not need
>> to indicate that it is using a page, and can trust guest_memfd to keep
>> the page around for the VM?
>
> Minor correction here. Yan was concerned about *bugs* happening when free=
ing
> pages that are accidentally still mapped in the S-EPT. My opinion is that=
 this
> is not especially risky to happen here vs other similar places, but it co=
uld be
> helpful if there was a way to catch such bugs. The page flag, or page_ext
> direction came out of a discussion with Dave and Kirill. If it could run =
all the
> time that would be great, but if not a debug config could be sufficient. =
For
> example like CONFIG_PAGE_TABLE_CHECK. It doesn't need to support vmemmap
> optimizations because the debug checking doesn't need to run all the time=
.
> Overhead for debug settings is very normal.
>

I see, let's call debug checking Topic 3 then, to separate it from Topic
1, which is TDX indicating that it is using a page for production
kernels.

Topic 3: How should TDX indicate use of a page for debugging?

I'm okay if for debugging, TDX uses anything other than refcounts for
checking, because refcounts will interfere with conversions.

Rick's other email is correct. The correct link should be
https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/.

[INTERFERE WITH CONVERSIONS]

To summarize, if TDX uses refcounts to indicate that it is using a page,
or to indicate anything else, then we cannot easily split a page on
private to shared conversions.

Specifically, consider the case where only the x-th subpage of a huge
folio is mapped into Secure-EPTs. When the guest requests to convert
some subpage to shared, the huge folio has to be split for
core-mm. Core-mm, which will use the shared page, must have split folios
to be able to accurately and separately track refcounts for subpages.

During splitting, guest_memfd would see refcount of 512 (for 2M page
being in the filemap) + 1 (if TDX indicates that the x-th subpage is
mapped using a refcount), but would not be able to tell that the 513th
refcount belongs to the x-th subpage. guest_memfd can't split the huge
folio unless it knows how to distribute the 513th refcount.

One might say guest_memfd could clear all the refcounts that TDX is
holding on the huge folio by unmapping the entire huge folio from the
Secure-EPTs, but unmapping the entire huge folio for TDX means zeroing
the contents and requiring guest re-acceptance. Both of these would mess
up guest operation.

Hence, guest_memfd's solution is to require that users of guest_memfd
for private memory trust guest_memfd to maintain the pages around and
not take any refcounts.

So back to Topic 1, for production kernels, is it okay that TDX does not
need to indicate that it is using a page, and can trust guest_memfd to
keep the page around for the VM?

>>=20
>> Topic 2: How to handle unmapping/splitting errors arising from TDX?
>>=20
>> Previously I was in favor of having unmap() return an error (Rick
>> suggested doing a POC, and in a more recent email Rick asked for a
>> diffstat), but Vishal and I talked about this and now I agree having
>> unmapping return an error is not a good approach for these reasons.
>
> Ok, let's close this option then.
>
>>=20
>> 1. Unmapping takes a range, and within the range there could be more
>> =C2=A0=C2=A0 than one unmapping error. I was previously thinking that un=
map()
>> =C2=A0=C2=A0 could return 0 for success and the failed PFN on error. Ret=
urning a
>> =C2=A0=C2=A0 single PFN on error is okay-ish but if there are more error=
s it could
>> =C2=A0=C2=A0 get complicated.
>>=20
>> =C2=A0=C2=A0 Another error return option could be to return the folio wh=
ere the
>> =C2=A0=C2=A0 unmapping/splitting issue happened, but that would not be
>> =C2=A0=C2=A0 sufficiently precise, since a folio could be larger than 4K=
 and we
>> =C2=A0=C2=A0 want to track errors as precisely as we can to reduce memor=
y loss due
>> =C2=A0=C2=A0 to errors.
>>=20
>> 2. What I think Yan has been trying to say: unmap() returning an error
>> =C2=A0=C2=A0 is non-standard in the kernel.
>>=20
>> I think (1) is the dealbreaker here and there's no need to do the
>> plumbing POC and diffstat.
>>=20
>> So I think we're all in support of indicating unmapping/splitting issues
>> without returning anything from unmap(), and the discussed options are
>>=20
>> a. Refcounts: won't work - mostly discussed in this (sub-)thread
>> =C2=A0=C2=A0 [3]. Using refcounts makes it impossible to distinguish bet=
ween
>> =C2=A0=C2=A0 transient refcounts and refcounts due to errors.
>>=20
>> b. Page flags: won't work with/can't benefit from HVO.
>
> As above, this was for the purpose of catching bugs, not for guestmemfd t=
o
> logically depend on it.
>
>>=20
>> Suggestions still in the running:
>>=20
>> c. Folio flags are not precise enough to indicate which page actually
>> =C2=A0=C2=A0 had an error, but this could be sufficient if we're willing=
 to just
>> =C2=A0=C2=A0 waste the rest of the huge page on unmapping error.
>
> For a scenario of TDX module bug, it seems ok to me.
>
>>=20
>> d. Folio flags with folio splitting on error. This means that on
>> =C2=A0=C2=A0 unmapping/Secure EPT PTE splitting error, we have to split =
the
>> =C2=A0=C2=A0 (larger than 4K) folio to 4K, and then set a flag on the sp=
lit folio.
>>=20
>> =C2=A0=C2=A0 The issue I see with this is that splitting pages with HVO =
applied
>> =C2=A0=C2=A0 means doing allocations, and in an error scenario there may=
 not be
>> =C2=A0=C2=A0 memory left to split the pages.
>>=20
>> e. Some other data structure in guest_memfd, say, a linked list, and a
>> =C2=A0=C2=A0 function like kvm_gmem_add_error_pfn(struct page *page) tha=
t would
>> =C2=A0=C2=A0 look up the guest_memfd inode from the page and add the pag=
e's pfn to
>> =C2=A0=C2=A0 the linked list.
>>=20
>> =C2=A0=C2=A0 Everywhere in guest_memfd that does unmapping/splitting wou=
ld then
>> =C2=A0=C2=A0 check this linked list to see if the unmapping/splitting
>> =C2=A0=C2=A0 succeeded.
>>=20
>> =C2=A0=C2=A0 Everywhere in guest_memfd that allocates pages will also ch=
eck this
>> =C2=A0=C2=A0 linked list to make sure the pages are functional.
>>=20
>> =C2=A0=C2=A0 When guest_memfd truncates, if the page being truncated is =
on the
>> =C2=A0=C2=A0 list, retain the refcount on the page and leak that page.
>
> I think this is a fine option.
>
>>=20
>> f. Combination of c and e, something similar to HugeTLB's
>> =C2=A0=C2=A0 folio_set_hugetlb_hwpoison(), which sets a flag AND adds th=
e pages in
>> =C2=A0=C2=A0 trouble to a linked list on the folio.
>>=20
>> g. Like f, but basically treat an unmapping error as hardware poisoning.
>>=20
>> I'm kind of inclined towards g, to just treat unmapping errors as
>> HWPOISON and buying into all the HWPOISON handling requirements. What do
>> yall think? Can a TDX unmapping error be considered as memory poisoning?
>
> What does HWPOISON bring over refcounting the page/folio so that it never
> returns to the page allocator?

For Topic 2 (handling TDX unmapping errors), HWPOISON is better than
refcounting because refcounting interferes with conversions (see
[INTERFERE WITH CONVERSIONS] above).

> We are bugging the TD in these cases.

Bugging the TD does not help to prevent future conversions from being
interfered with.

1. Conversions involves unmapping, so we could actually be in a
   conversion, the unmapping is performed and fails, and then we try to
   split and enter an infinite loop since private to shared conversions
   assumes guest_memfd holds the only refcounts on guest_memfd memory.

2. The conversion ioctl is a guest_memfd ioctl, not a VM ioctl, and so
   there is no check that the VM is not dead. There shouldn't be any
   check on the VM, because shareability is a property of the memory and
   should be changeable independent of the associated VM.

> Ohhh... Is
> this about the code to allow gmem fds to be handed to new VMs?

Nope, it's not related to linking. The proposed KVM_LINK_GUEST_MEMFD
ioctl [4] also doesn't check if the source VM is dead. There shouldn't
be any check on the source VM, since the memory is from guest_memfd and
should be independently transferable to a new VM.

[4] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/T/

