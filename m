Return-Path: <kvm+bounces-50577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F05AE718C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA5D1894F3C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07C725A2A3;
	Tue, 24 Jun 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fRT1MooT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36032512F1
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 21:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750800560; cv=none; b=IDxiPId/heGaJW5YOVXeBDRV8JWWCT6f5nzUAVoWGxBIwdROmBcw+e1oQ2K1DxebP9qknUStI63ZBGVWZphwAouVs2mteeMPzmQxbYJAlhVpWoDGDECTvM6L5lXKr4h90DKdfDQVzA6ongxZdG+L2997cfVYOgCzmxwO9Hnk/nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750800560; c=relaxed/simple;
	bh=VyXx4fFOaQFeb9bK6ElzVi1q5/w0iku6joOpmAasf8g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WONdZFz0Nyl1CkgOzZ3LoXbkkkpC+yzYsACC7+Vg8Xx55DN0EPYRyVWKUjn5M4OT2cjiu9dUHydDN61NcZTqcKsR3Wyuj2K622QDu8Y00Rqa0FiLFtXBYuivYAr0nkB+UJuYt9Z4e//Gb95OY9hb1rrX0sSc/U4O/Bg23eQR18c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fRT1MooT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740270e168aso491220b3a.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750800558; x=1751405358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxE9lix96X9N66BtdXnY0yxc/Kl8Ep1AKX9YSUGEfMI=;
        b=fRT1MooTfooQo2mVSSgVzDEJmEdiEULK3bmWRyrRU80/cQAACZnTFlCudT0Vs6ZwTi
         6Uipn7X2qomXFazIw9en0z1yhqUd4tAD1n+dFV+gtIimntV+XUOO+hVfncvU5ObJgnlz
         yOOHt11XDHvrDcOlxmn0nLJg6m3ALW49LTEk99Y5Upv+rGiJ+aYAAnBK/RqdodNtjhOQ
         730l2/8ASmwX0qJD84mkrjGMvuZ/s4ItG9EB3xaQEzJyZyq9mU3z4Gxmh3+97KsviIv+
         zWIca9AGgGaRCYCu5L2euxojNJ/HvsQpRLlLcmo8djUbu66iELgDGIYjYzeey5nmtbeJ
         ulxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750800558; x=1751405358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxE9lix96X9N66BtdXnY0yxc/Kl8Ep1AKX9YSUGEfMI=;
        b=dqU/gmHP0aHtDxyRLqmwxPWWdkgoJc7LninS7+iXC2A5SjVHbsX/dfYjcsMag9VGsC
         WSyaUhjAX5ww+jq9OyxgQ5LAD047IoiyOy7nT+t79aL8Buj7+VqxCiPX/2d2Pp1xRU2l
         xhLuA5qfpi8gwsev3Y4QAAO7yYPiqwSwSMrGNXnGwGzRv8CN256JobldbVKd5xGV9YK5
         uuX+zYRIL+GbsuRJVJw+KlqylbflHiryQgw69K2LQAiMJUEtDsjbTjyh+lhbJygwYmds
         uhSlp4W6pp8Eg6lPhkjT0MSBJk+1nc1tT0feGLRy93pDszRGdnJydjiQNlgXKe5HoxL8
         J6Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWEw10tuhrRgiH6XQWTjofiH+wGXIsUhaMJ1ngJ9XvPKsHlcZqVi1CegEw2LWBg5MTaQn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSgVWml2WVOf5L0ll+y1kN1HeJYAUK3v/SINXh0SPsvYkS7+vM
	EXCNP8UmCkKTJtDd/mMCdDmQ2rEvadn/WksuQPJdyp7qWTDLq+47NWVwQT4BVDYBcWpB9FmT2zo
	1tgIlg++zv+AgTUqZNX07pDpNZg==
X-Google-Smtp-Source: AGHT+IE6BZe5nugH/R/86Hdqt4E6MGob8B/FNyuMjRFLiB+rvr40sM9D/oFfrZUVpwFwBDBtC9YNTMj2NpkdeB6r9g==
X-Received: from pfblp17.prod.google.com ([2002:a05:6a00:3d51:b0:746:2ae9:24a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d85:b0:220:21bf:b112 with SMTP id adf61e73a8af0-2207f18e346mr810790637.13.1750800558214;
 Tue, 24 Jun 2025 14:29:18 -0700 (PDT)
Date: Tue, 24 Jun 2025 14:29:16 -0700
In-Reply-To: <aFp7j+2VBhHZiKx/@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com> <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com> <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com> <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <aFp7j+2VBhHZiKx/@yzhao56-desk.sh.intel.com>
Message-ID: <diqz7c10ltg3.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
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

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Mon, Jun 23, 2025 at 03:48:48PM -0700, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>> 
>> > Yan Zhao <yan.y.zhao@intel.com> writes:
>> >
>> >> On Wed, Jun 18, 2025 at 08:41:38AM +0800, Edgecombe, Rick P wrote:
>> >>> On Wed, 2025-06-18 at 08:19 +0800, Yan Zhao wrote:
>> >>> > > I don't think a potential bug in KVM is a good enough reason. If we are
>> >>> > > concerned can we think about a warning instead?
>> >>> > > 
>> >>> > > We had talked enhancing kasan to know when a page is mapped into S-EPT in
>> >>> > > the
>> >>> > > past. So rather than design around potential bugs we could focus on having a
>> >>> > > simpler implementation with the infrastructure to catch and fix the bugs.
>> >>> > However, if failing to remove a guest private page would only cause memory
>> >>> > leak,
>> >>> > it's fine. 
>> >>> > If TDX does not hold any refcount, guest_memfd has to know that which private
>> >>> > page is still mapped. Otherwise, the page may be re-assigned to other kernel
>> >>> > components while it may still be mapped in the S-EPT.
>> >>> 
>> >>> KASAN detects use-after-free's like that. However, the TDX module code is not
>> >>> instrumented. It won't check against the KASAN state for it's accesses.
>> >>> 
>> >>> I had a brief chat about this with Dave and Kirill. A couple ideas were
>> >>> discussed. One was to use page_ext to keep a flag that says the page is in-use
>> >> Thanks!
>> >>
>> >> To use page_ext, should we introduce a new flag PAGE_EXT_FIRMWARE_IN_USE,
>> >> similar to PAGE_EXT_YOUNG?
>> >>
>> >> Due to similar issues as those with normal page/folio flags (see the next
>> >> comment for details), TDX needs to set PAGE_EXT_FIRMWARE_IN_USE on a
>> >> page-by-page basis rather than folio-by-folio.
>> >>
>> >> Additionally, it seems reasonable for guest_memfd not to copy the
>> >> PAGE_EXT_FIRMWARE_IN_USE flag when splitting a huge folio?
>> >> (in __folio_split() --> split_folio_to_order(), PAGE_EXT_YOUNG and
>> >> PAGE_EXT_IDLE are copied to the new folios though).
>> >>
>> >> Furthermore, page_ext uses extra memory. With CONFIG_64BIT, should we instead
>> >> introduce a PG_firmware_in_use in page flags, similar to PG_young and PG_idle?
>> >>
>> 
>> I think neither page flags nor page_ext will work for us, but see below.
>> 
>> >>> by the TDX module. There was also some discussion of using a normal page flag,
>> >>> and that the reserved page flag might prevent some of the MM operations that
>> >>> would be needed on guestmemfd pages. I didn't see the problem when I looked.
>> >>> 
>> >>> For the solution, basically the SEAMCALL wrappers set a flag when they hand a
>> >>> page to the TDX module, and clear it when they successfully reclaim it via
>> >>> tdh_mem_page_remove() or tdh_phymem_page_reclaim(). Then if the page makes it
>> >>> back to the page allocator, a warning is generated.
>> >> After some testing, to use a normal page flag, we may need to set it on a
>> >> page-by-page basis rather than folio-by-folio. See "Scheme 1".
>> >> And guest_memfd may need to selectively copy page flags when splitting huge
>> >> folios. See "Scheme 2".
>> >>
>> >> Scheme 1: Set/unset page flag on folio-by-folio basis, i.e.
>> >>         - set folio reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
>> >>         - unset folio reserved after a successful tdh_mem_page_remove() or
>> >>           tdh_phymem_page_reclaim().
>> >>
>> >>         It has problem in following scenario:
>> >>         1. tdh_mem_page_aug() adds a 2MB folio. It marks the folio as reserved
>> >> 	   via "folio_set_reserved(page_folio(page))"
>> >>
>> >>         2. convert a 4KB page of the 2MB folio to shared.
>> >>         2.1 tdh_mem_page_demote() is executed first.
>> >>        
>> >>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
>> >>             "folio_clear_reserved(page_folio(page))" clears reserved flag for
>> >>             the 2MB folio while the rest 511 pages are still mapped in the
>> >>             S-EPT.
>> >>
>> >>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
>> >>
>> >>
>> 
>> Folio flags on their own won't work because they're not precise
>> enough. A folio can be multiple 4K pages, and if a 4K page had failed to
>> unmap, we want to be able to indicate which 4K page had the failure,
>> instead of the entire folio. (But see below)
>> 
>> >> Scheme 2: Set/unset page flag on page-by-page basis, i.e.
>> >>         - set page flag reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
>> >>         - unset page flag reserved after a successful tdh_mem_page_remove() or
>> >>           tdh_phymem_page_reclaim().
>> >>
>> >>         It has problem in following scenario:
>> >>         1. tdh_mem_page_aug() adds a 2MB folio. It marks pages as reserved by
>> >>            invoking "SetPageReserved()" on each page.
>> >>            As the folio->flags equals to page[0]->flags, folio->flags is also
>> >> 	   with reserved set.
>> >>
>> >>         2. convert a 4KB page of the 2MB folio to shared. say, it's page[4].
>> >>         2.1 tdh_mem_page_demote() is executed first.
>> >>        
>> >>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
>> >>             "ClearPageReserved()" clears reserved flag of page[4] of the 2MB
>> >>             folio.
>> >>
>> >>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
>> >>              In guestmem_hugetlb_split_folio(), "p->flags = folio->flags" marks
>> >>              page[4]->flags as reserved again as page[0] is still reserved.
>> >>
>> >>             (see the code in https://lore.kernel.org/all/2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com/
>> >>             for (i = 1; i < orig_nr_pages; ++i) {
>> >>                 struct page *p = folio_page(folio, i);
>> >>
>> >>                 /* Copy flags from the first page to split pages. */
>> >>                 p->flags = folio->flags;
>> >>
>> >>                 p->mapping = NULL;
>> >>                 clear_compound_head(p);
>> >>             }
>> >>             )
>> >>
>> 
>> Per-page flags won't work because we want to retain HugeTLB Vmemmap
>> Optimization (HVO), which allows subsequent (identical) struct pages to
>> alias to each other. If we use a per-page flag, then HVO would break
>> since struct pages would no longer be identical to each other.
> Ah, I overlooked HVO.
> In my testing, neither CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON nor
> hugetlb_free_vmemmap was set.
>
> With HVO enabled, setting page flags on a per-page basis indeed does not work.
>> 
>> >> [...]
>> 
>> Let me try and summarize the current state of this discussion:
> Thanks for this summary.
>
>
>> Topic 1: Does TDX need to somehow indicate that it is using a page?
>> 
>> This patch series uses refcounts to indicate that TDX is using a page,
>> but that complicates private-to-shared conversions.
>> 
>> During a private-to-shared conversion, guest_memfd assumes that
>> guest_memfd is trusted to manage private memory. TDX and other users
>> should trust guest_memfd to keep the memory around.
>> 
>> Yan's position is that holding a refcount is in line with how IOMMU
>> takes a refcount when a page is mapped into the IOMMU [1].
>> 
>> Yan had another suggestion, which is to indicate using a page flag [2].
>> 
>> I think we're in agreement that we don't want to have TDX hold a
>> refcount while the page is mapped into the Secure EPTs, but taking a
>> step back, do we really need to indicate (at all) that TDX is using a
>> page?
>> 
>> In [3] Yan said
>> 
>> > If TDX does not hold any refcount, guest_memfd has to know that which
>> > private
>> > page is still mapped. Otherwise, the page may be re-assigned to other
>> > kernel
>> > components while it may still be mapped in the S-EPT.
>> 
>> If the private page is mapped for regular VM use as private memory,
>> guest_memfd is managing that, and the same page will not be re-assigned
>> to any other kernel component. guest_memfd does hold refcounts in
>> guest_memfd's filemap.
> After kvm_gmem_release(), guest_memfd will return folios to hugetlb, so the same
> page could be re-assigned to other kernel components that allocate pages from
> hugetlb.
>

Yes, at kvm_gmem_release(), guest_memfd also unmaps all the private and
shared pages from Secure EPTs, so on successful unmap, all is good, the
page can and should be reused elsewhere.

On unsuccessful unmap, we can then handle that according to the option
we pick from below. e.g. if we pick options f or g, the page should
never be reused elsewhere.

If we pick other options, then we would have to ensure the page doesn't
get used elsewhere anyway, so TDX still won't need to hold a refcount
while using the page?

>> 
>> If the private page is still mapped because there was an unmapping
>> failure, we can discuss that separately under error handling in Topic 2.
>> 
>> With this, can I confirm that we are in agreement that TDX does not need
>> to indicate that it is using a page, and can trust guest_memfd to keep
>> the page around for the VM?
> I thought it's not a must until I came across a comment from Sean:
> "Should these bail early if the KVM_BUG_ON() is hit?  Calling into the TDX module
> after bugging the VM is a bit odd."
> https://lore.kernel.org/kvm/Z4r_XNcxPWpgjZio@google.com/#t.
>
> This comment refers to the following scenario:
> when a 2MB non-leaf entry in the mirror root is zapped with shared mmu_lock,
> BUG_ON() will be triggered for TDX. But by the time handle_removed_pt() is
> reached, the 2MB non-leaf entry would have been successfully removed in the
> mirror root.
>
> Bailing out early in remove_external_spte() would prevent the removal of 4KB
> private guest pages in the S-EPT later due to lacking of corresponding entry in
> the mirror root.
>
> Since KVM MMU does not hold guest page's ref count, failing to notify TDX about
> the removal of a guest page could result in a situation where a page still
> mapped in the S-EPT is freed and re-allocated by the OS. 
>
> Therefore, indicating that TDX is using a page can be less error-prone, though
> it does consume more memory.
>

This is true, but instead of somehow indicating that the page is used by
TDX upfront, how about treating this as an error, so we should not bail
out before first indicating an error on the page, such as using Option f
or g below. Indicating an error on the page will prevent the case where
a page still mapped in the S-EPT is freed and reused by the OS elsewhere.

>> Topic 2: How to handle unmapping/splitting errors arising from TDX?
>> 
>> Previously I was in favor of having unmap() return an error (Rick
>> suggested doing a POC, and in a more recent email Rick asked for a
>> diffstat), but Vishal and I talked about this and now I agree having
>> unmapping return an error is not a good approach for these reasons.
>> 
>> 1. Unmapping takes a range, and within the range there could be more
>>    than one unmapping error. I was previously thinking that unmap()
>>    could return 0 for success and the failed PFN on error. Returning a
>>    single PFN on error is okay-ish but if there are more errors it could
>>    get complicated.
>> 
>>    Another error return option could be to return the folio where the
>>    unmapping/splitting issue happened, but that would not be
>>    sufficiently precise, since a folio could be larger than 4K and we
>>    want to track errors as precisely as we can to reduce memory loss due
>>    to errors.
>> 
>> 2. What I think Yan has been trying to say: unmap() returning an error
>>    is non-standard in the kernel.
>> 
>> I think (1) is the dealbreaker here and there's no need to do the
>> plumbing POC and diffstat.
>> 
>> So I think we're all in support of indicating unmapping/splitting issues
>> without returning anything from unmap(), and the discussed options are
>> 
>> a. Refcounts: won't work - mostly discussed in this (sub-)thread
>>    [3]. Using refcounts makes it impossible to distinguish between
>>    transient refcounts and refcounts due to errors.
>> 
>> b. Page flags: won't work with/can't benefit from HVO.
>> 
>> Suggestions still in the running:
>> 
>> c. Folio flags are not precise enough to indicate which page actually
>>    had an error, but this could be sufficient if we're willing to just
>>    waste the rest of the huge page on unmapping error.
> For 1GB folios, more precise info will be better.
>
>
>> d. Folio flags with folio splitting on error. This means that on
>>    unmapping/Secure EPT PTE splitting error, we have to split the
>>    (larger than 4K) folio to 4K, and then set a flag on the split folio.
>> 
>>    The issue I see with this is that splitting pages with HVO applied
>>    means doing allocations, and in an error scenario there may not be
>>    memory left to split the pages.
> Could we restore the page structures before triggering unmap?
>

Do you mean every time, before unmapping (every conversion, truncation,
etc), first restore the page structs in preparation for unmap failure,
then re-optimize HVO after successful unmap?

Restoring the page structures is quite an expensive operation IIUC,
involving time and allocations, and it kind of defeats the purpose of
HVO if we need to keep extra memory around to keep restoring and undoing
HVO.

Or do you mean only on unmap failure, undo restore page structs to mark
the error?

Because it is expensive, it seems hard for this to work when the unmap
fails (the machine might be in some dire state already).

>> 
>> e. Some other data structure in guest_memfd, say, a linked list, and a
>>    function like kvm_gmem_add_error_pfn(struct page *page) that would
>>    look up the guest_memfd inode from the page and add the page's pfn to
>>    the linked list.
>>
>>    Everywhere in guest_memfd that does unmapping/splitting would then
>>    check this linked list to see if the unmapping/splitting
>>    succeeded.
>> 
>>    Everywhere in guest_memfd that allocates pages will also check this
>>    linked list to make sure the pages are functional.
>> 
>>    When guest_memfd truncates, if the page being truncated is on the
>>    list, retain the refcount on the page and leak that page.
>>
>> f. Combination of c and e, something similar to HugeTLB's
>>    folio_set_hugetlb_hwpoison(), which sets a flag AND adds the pages in
>>    trouble to a linked list on the folio.
> That seems like a good idea. If memory allocation for the linked list succeeds,
> mark the pages within a folio as troublesome; otherwise, mark the entire folio
> as troublesome.
>

This is already what HugeTLB does for poisoning in
folio_set_hugetlb_hwpoison(), so if an unmapping error can be treated as
hardware poisoning, we could re-use all that infrastructure.

> But maybe c is good enough for 2MB folios.
>

I think it'd be awkward/troublesome to treat different sizes of folios
differently and I would prefer not to do this.

>> g. Like f, but basically treat an unmapping error as hardware poisoning.
> Not sure if hwpoison bit can be used directly.
> Further investigation is needed.
>

Would appreciate your assessment on whether an unmapping error can be
treated as hardware poisoning!

>> I'm kind of inclined towards g, to just treat unmapping errors as
>> HWPOISON and buying into all the HWPOISON handling requirements. What do
>> yall think? Can a TDX unmapping error be considered as memory poisoning?
>> 
>>

I have another option h to add: if there is a unmapping error from TDX,
can it be an indication of compromise, in terms of security? Should TDX
continue to be trusted to run the TD or other TDs securely? If there is
some unmapping error, could correctness in the entire host be in
question?

If either correctness or security is broken, would it be acceptable to
do a full BUG_ON and crash the system, since neither TDX nor regular VMs
on the host should trusted to run correctly after this kind of error?

>> [1] https://lore.kernel.org/all/aE%2F1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com/
>> [2] https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com/
>> [3] https://lore.kernel.org/all/aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com/
>> [3] https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/

