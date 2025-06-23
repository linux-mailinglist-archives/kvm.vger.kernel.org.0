Return-Path: <kvm+bounces-50427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6181DAE5796
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CDB71B6366F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7236A227EA4;
	Mon, 23 Jun 2025 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZS7ZlPVj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC7221F24
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 22:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718931; cv=none; b=CcEW/s4SNQBw8aMs/kiMs8fOk1DQR9SjPzsU2ajRmJIyMgoTFuppJvGpOdSLjw+1TMVEn4xzFJL0XOM4lSfbtvsFhLnj2PyY7Ll+REVjr4dhWtdr8HAooYtOE35SVZ6SK9o6SS0jvt7QWTFk7VK1TjKUb2a6mgnW5bhH0xMzu3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718931; c=relaxed/simple;
	bh=HVlnWOUhaJDHiqoV6Qi+fWYnBNCA0TmheUmhtVgM2LM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OQdMPYcH/QD8u1byrA+9r465TedUjKJ5fv3uCPSJTTmVbNKpNxVfy4FF0GhTnypEDHfY0PtffQI2lTKGutfqxvkSuP/L+mEeYmsKrNV1Zn9aCAlogNn48I4TfEbOH8VR0i+Et1GtZZtKYZhkUylOmwAE0PS/Fy0dg1fxVAq51JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZS7ZlPVj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748fd21468cso3370621b3a.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750718929; x=1751323729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5FQrnOzlI4rlzIlJ3je95VX2XtHLZtkxIG+j+YsSdSA=;
        b=ZS7ZlPVjdVEFHZc3NvfiQREcr0T2uIzY98NzKNUEoyNwvPWuOgHmYq1fj5QFWmL3dt
         meDh2EnIwKXVFWxwjRokrDELT4eTiv6ZFvGsMKsrd00WKw8IYFY8m7I3dm/BkDczvWaC
         Bw69u8SwzBsRj/x7T+Dzo+atqsfFc/2HK6UaITeR9BP19/EN2fSS01mMUI67w3sOLqUS
         zqzlHpx0RWs3APCtbb86s+1km4RRoeeRVxTDp3CIDHCcPlGAcH3J31v5i+tCYG2Oec1l
         bPQoQ6fG+7M2SooZHB4cORBl1+0FOfoVOIGCCJTCJHpk01OK7hbW/OT45nHEB53Te0IJ
         wHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750718929; x=1751323729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5FQrnOzlI4rlzIlJ3je95VX2XtHLZtkxIG+j+YsSdSA=;
        b=A4qgJYKCvOXx9eNjEazRJGHnSO3bm+gzRHNp8KBr64z2RW27D88UUfShFOewl+NyDf
         irzp/ocguB0xn4GcTuYofWwiABiZ+0pShr+61nuAEaFDQw0n+5LG+vhgbMdDetmWMkhd
         VsN3XxCAdOHI2qQVYhEpRqUjpiBsxK79iiwgHF5WtAzYn3lK4WslfFJYRfQfoF90mBrZ
         j3A3rOawOQ4SFvIIxXPYoJvl4L5ssCJSWwRs4JqZVOwIGqRBTGncQh6r6QmaB5jyWJOa
         z+HsgGifhIoCDbDBUfcYi9t1wwof+VU+1a7bAGaFeVnI2zFhpLEtnEjVCAtjvIHr/sYW
         R4gw==
X-Forwarded-Encrypted: i=1; AJvYcCXu+EFhwFm1S7H3xP6JFzvBjL5l7ADkX4Xp1e0f2fyMTYUxsE4S66F0uFTBJamYpsoDtgI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyax2m7R3KfvgNrUtlkPCecs9FX4ZjOcnnC2wsKewfxXg1hR5sZ
	0/+zxf17HXd1Jd/mECVCPj2i0sewDPGB3HkL643KJY4P7uZORv1i15i57MKAV1csl3VKMm2NUEY
	EcihHsoituGgCH7uluYe55BS8rQ==
X-Google-Smtp-Source: AGHT+IFXcWLeuIKgfe/GpzK3L8MUHvaAHpiTHonP1boAS308TfryaPn9WMz6uCXNyx65KgwmMm9jHSqAQPckJNRbGw==
X-Received: from pfrb8.prod.google.com ([2002:aa7:8ec8:0:b0:746:32ae:99d5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1990:b0:748:edf5:95de with SMTP id d2e1a72fcca58-7490d5d033amr16444878b3a.10.1750718929219;
 Mon, 23 Jun 2025 15:48:49 -0700 (PDT)
Date: Mon, 23 Jun 2025 15:48:48 -0700
In-Reply-To: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
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
Message-ID: <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Yan Zhao <yan.y.zhao@intel.com> writes:
>
>> On Wed, Jun 18, 2025 at 08:41:38AM +0800, Edgecombe, Rick P wrote:
>>> On Wed, 2025-06-18 at 08:19 +0800, Yan Zhao wrote:
>>> > > I don't think a potential bug in KVM is a good enough reason. If we are
>>> > > concerned can we think about a warning instead?
>>> > > 
>>> > > We had talked enhancing kasan to know when a page is mapped into S-EPT in
>>> > > the
>>> > > past. So rather than design around potential bugs we could focus on having a
>>> > > simpler implementation with the infrastructure to catch and fix the bugs.
>>> > However, if failing to remove a guest private page would only cause memory
>>> > leak,
>>> > it's fine. 
>>> > If TDX does not hold any refcount, guest_memfd has to know that which private
>>> > page is still mapped. Otherwise, the page may be re-assigned to other kernel
>>> > components while it may still be mapped in the S-EPT.
>>> 
>>> KASAN detects use-after-free's like that. However, the TDX module code is not
>>> instrumented. It won't check against the KASAN state for it's accesses.
>>> 
>>> I had a brief chat about this with Dave and Kirill. A couple ideas were
>>> discussed. One was to use page_ext to keep a flag that says the page is in-use
>> Thanks!
>>
>> To use page_ext, should we introduce a new flag PAGE_EXT_FIRMWARE_IN_USE,
>> similar to PAGE_EXT_YOUNG?
>>
>> Due to similar issues as those with normal page/folio flags (see the next
>> comment for details), TDX needs to set PAGE_EXT_FIRMWARE_IN_USE on a
>> page-by-page basis rather than folio-by-folio.
>>
>> Additionally, it seems reasonable for guest_memfd not to copy the
>> PAGE_EXT_FIRMWARE_IN_USE flag when splitting a huge folio?
>> (in __folio_split() --> split_folio_to_order(), PAGE_EXT_YOUNG and
>> PAGE_EXT_IDLE are copied to the new folios though).
>>
>> Furthermore, page_ext uses extra memory. With CONFIG_64BIT, should we instead
>> introduce a PG_firmware_in_use in page flags, similar to PG_young and PG_idle?
>>

I think neither page flags nor page_ext will work for us, but see below.

>>> by the TDX module. There was also some discussion of using a normal page flag,
>>> and that the reserved page flag might prevent some of the MM operations that
>>> would be needed on guestmemfd pages. I didn't see the problem when I looked.
>>> 
>>> For the solution, basically the SEAMCALL wrappers set a flag when they hand a
>>> page to the TDX module, and clear it when they successfully reclaim it via
>>> tdh_mem_page_remove() or tdh_phymem_page_reclaim(). Then if the page makes it
>>> back to the page allocator, a warning is generated.
>> After some testing, to use a normal page flag, we may need to set it on a
>> page-by-page basis rather than folio-by-folio. See "Scheme 1".
>> And guest_memfd may need to selectively copy page flags when splitting huge
>> folios. See "Scheme 2".
>>
>> Scheme 1: Set/unset page flag on folio-by-folio basis, i.e.
>>         - set folio reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
>>         - unset folio reserved after a successful tdh_mem_page_remove() or
>>           tdh_phymem_page_reclaim().
>>
>>         It has problem in following scenario:
>>         1. tdh_mem_page_aug() adds a 2MB folio. It marks the folio as reserved
>> 	   via "folio_set_reserved(page_folio(page))"
>>
>>         2. convert a 4KB page of the 2MB folio to shared.
>>         2.1 tdh_mem_page_demote() is executed first.
>>        
>>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
>>             "folio_clear_reserved(page_folio(page))" clears reserved flag for
>>             the 2MB folio while the rest 511 pages are still mapped in the
>>             S-EPT.
>>
>>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
>>
>>

Folio flags on their own won't work because they're not precise
enough. A folio can be multiple 4K pages, and if a 4K page had failed to
unmap, we want to be able to indicate which 4K page had the failure,
instead of the entire folio. (But see below)

>> Scheme 2: Set/unset page flag on page-by-page basis, i.e.
>>         - set page flag reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
>>         - unset page flag reserved after a successful tdh_mem_page_remove() or
>>           tdh_phymem_page_reclaim().
>>
>>         It has problem in following scenario:
>>         1. tdh_mem_page_aug() adds a 2MB folio. It marks pages as reserved by
>>            invoking "SetPageReserved()" on each page.
>>            As the folio->flags equals to page[0]->flags, folio->flags is also
>> 	   with reserved set.
>>
>>         2. convert a 4KB page of the 2MB folio to shared. say, it's page[4].
>>         2.1 tdh_mem_page_demote() is executed first.
>>        
>>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
>>             "ClearPageReserved()" clears reserved flag of page[4] of the 2MB
>>             folio.
>>
>>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
>>              In guestmem_hugetlb_split_folio(), "p->flags = folio->flags" marks
>>              page[4]->flags as reserved again as page[0] is still reserved.
>>
>>             (see the code in https://lore.kernel.org/all/2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com/
>>             for (i = 1; i < orig_nr_pages; ++i) {
>>                 struct page *p = folio_page(folio, i);
>>
>>                 /* Copy flags from the first page to split pages. */
>>                 p->flags = folio->flags;
>>
>>                 p->mapping = NULL;
>>                 clear_compound_head(p);
>>             }
>>             )
>>

Per-page flags won't work because we want to retain HugeTLB Vmemmap
Optimization (HVO), which allows subsequent (identical) struct pages to
alias to each other. If we use a per-page flag, then HVO would break
since struct pages would no longer be identical to each other.

>> [...]

Let me try and summarize the current state of this discussion:

Topic 1: Does TDX need to somehow indicate that it is using a page?

This patch series uses refcounts to indicate that TDX is using a page,
but that complicates private-to-shared conversions.

During a private-to-shared conversion, guest_memfd assumes that
guest_memfd is trusted to manage private memory. TDX and other users
should trust guest_memfd to keep the memory around.

Yan's position is that holding a refcount is in line with how IOMMU
takes a refcount when a page is mapped into the IOMMU [1].

Yan had another suggestion, which is to indicate using a page flag [2].

I think we're in agreement that we don't want to have TDX hold a
refcount while the page is mapped into the Secure EPTs, but taking a
step back, do we really need to indicate (at all) that TDX is using a
page?

In [3] Yan said

> If TDX does not hold any refcount, guest_memfd has to know that which
> private
> page is still mapped. Otherwise, the page may be re-assigned to other
> kernel
> components while it may still be mapped in the S-EPT.

If the private page is mapped for regular VM use as private memory,
guest_memfd is managing that, and the same page will not be re-assigned
to any other kernel component. guest_memfd does hold refcounts in
guest_memfd's filemap.

If the private page is still mapped because there was an unmapping
failure, we can discuss that separately under error handling in Topic 2.

With this, can I confirm that we are in agreement that TDX does not need
to indicate that it is using a page, and can trust guest_memfd to keep
the page around for the VM?

Topic 2: How to handle unmapping/splitting errors arising from TDX?

Previously I was in favor of having unmap() return an error (Rick
suggested doing a POC, and in a more recent email Rick asked for a
diffstat), but Vishal and I talked about this and now I agree having
unmapping return an error is not a good approach for these reasons.

1. Unmapping takes a range, and within the range there could be more
   than one unmapping error. I was previously thinking that unmap()
   could return 0 for success and the failed PFN on error. Returning a
   single PFN on error is okay-ish but if there are more errors it could
   get complicated.

   Another error return option could be to return the folio where the
   unmapping/splitting issue happened, but that would not be
   sufficiently precise, since a folio could be larger than 4K and we
   want to track errors as precisely as we can to reduce memory loss due
   to errors.

2. What I think Yan has been trying to say: unmap() returning an error
   is non-standard in the kernel.

I think (1) is the dealbreaker here and there's no need to do the
plumbing POC and diffstat.

So I think we're all in support of indicating unmapping/splitting issues
without returning anything from unmap(), and the discussed options are

a. Refcounts: won't work - mostly discussed in this (sub-)thread
   [3]. Using refcounts makes it impossible to distinguish between
   transient refcounts and refcounts due to errors.

b. Page flags: won't work with/can't benefit from HVO.

Suggestions still in the running:

c. Folio flags are not precise enough to indicate which page actually
   had an error, but this could be sufficient if we're willing to just
   waste the rest of the huge page on unmapping error.

d. Folio flags with folio splitting on error. This means that on
   unmapping/Secure EPT PTE splitting error, we have to split the
   (larger than 4K) folio to 4K, and then set a flag on the split folio.

   The issue I see with this is that splitting pages with HVO applied
   means doing allocations, and in an error scenario there may not be
   memory left to split the pages.

e. Some other data structure in guest_memfd, say, a linked list, and a
   function like kvm_gmem_add_error_pfn(struct page *page) that would
   look up the guest_memfd inode from the page and add the page's pfn to
   the linked list.

   Everywhere in guest_memfd that does unmapping/splitting would then
   check this linked list to see if the unmapping/splitting
   succeeded.

   Everywhere in guest_memfd that allocates pages will also check this
   linked list to make sure the pages are functional.

   When guest_memfd truncates, if the page being truncated is on the
   list, retain the refcount on the page and leak that page.

f. Combination of c and e, something similar to HugeTLB's
   folio_set_hugetlb_hwpoison(), which sets a flag AND adds the pages in
   trouble to a linked list on the folio.

g. Like f, but basically treat an unmapping error as hardware poisoning.

I'm kind of inclined towards g, to just treat unmapping errors as
HWPOISON and buying into all the HWPOISON handling requirements. What do
yall think? Can a TDX unmapping error be considered as memory poisoning?


[1] https://lore.kernel.org/all/aE%2F1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com/
[2] https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com/
[3] https://lore.kernel.org/all/aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com/
[3] https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/

