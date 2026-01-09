Return-Path: <kvm+bounces-67632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 160AED0BD6F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 19:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD7243047FFB
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 18:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7079B368283;
	Fri,  9 Jan 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Un1E5eKf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A057F366546
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983391; cv=none; b=K9CrJcLKSgat80bcSBbOe1gv1A6gfTcMhfPOQy0SWNzTOIT385Dp/OpqH/K1iLE2/O6YUUgj2jZJK/RFE4kWRitRm/FD6/DIoTbtplJBGFgiDxTWoDg4EpKz8lhUTf9JiR+4+bRPvEgxUFMItJaUyykaTKB4IdxuSHMFSOqf/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983391; c=relaxed/simple;
	bh=2H4oXaiuKcTkJMgXWW3Q9GF0HFkVU/b0UuFWnXoPIBQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7c0qQb8uS4CeE56d3fRgbGs170jPrXWNyLtZELQeVjGfSm5J8HjN4a+K3vPPY+L18CsKD561b9K5NTtTEoUmVYTZxA70mlqZ0T+srwqN2CfC3JmolNyhS0Bpur4VMBn9QfSr0GUs2DAl30p6aBBAeqiK3ICK92jguRHsfr1qhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Un1E5eKf; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-9412f43cb9eso2806988241.2
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 10:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767983388; x=1768588188; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Omv2UnhK3BHG1YqZhmFqBsPS/R21oE1F0P8YdFHtAk=;
        b=Un1E5eKfzuybHvg5i1IfOs35m7uGZbmj3Mpo4VW021JCGIFNl4rdgAaJoOlgIDnWrx
         Ym6gNXuQzBNUvbbxG2Ch/ZOvWd5StvkWYnXnIGis7GUghrj2n67V/vPS29aRvXhtzw/B
         h+cEvW2W8i9pyFjDKCSexk9THeTUKnqjZifY++Hioq3H2Ywq0OqIuDu0F8r9jHotZ30j
         8RKkAD+gGQdZpQlZD0FVQa3dJ/+OdQvaO/I3ZLHpvDj+9Kf6m/WHF1jZy6zvpBDAFr67
         XYc6ANhmnh8UrNcWVuMV2Yjqm51PRnBRyrtdPJYJ3ezs7E+DCQmxL6JkhHDqNxJBpX/q
         EPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983388; x=1768588188;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Omv2UnhK3BHG1YqZhmFqBsPS/R21oE1F0P8YdFHtAk=;
        b=TRH6HiTLBfl9axqQHj0YUs+GP1ViHU3ZN08MnV88NO0JmqRAohIAyjL1lcScp8qv4W
         nxS8dooBrea8bX4mhcqUueGBNxSsGVYUB6SsmUNpOezbnrqvozVfxEyN1js3helQOFnZ
         KdgSBFC/MGURo/G4sPN3Xgppsw3tUC7FIBXwQtdqKYDjsgJFXswpWKgn4eVFzmM13wwd
         QRJuzsP0tK4shUg/BFdj2oajvvasGQqTEJJbPBEwMiXMGVPxZnj/xVTKr027LXA/Jf41
         yheD1M0c3w4iOtLPHwkBkLbxCQLkbPKB31/O513yhIjjSxkRVA3p03dxguT8YlbMoPiS
         90Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVxuViDbhNMk3o4Jnw/pyDiqzvUPbIBjhef/8l0WulBvIAUxMAc/T05dBgb8CmMIanLX64=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv1zEM7wBx2+N5umgl114Jybvc6/hFrV4MQKj1tVp26w5kZ06U
	XzlUrcvDPtZLPvkQfAmPwt5G/YP8S2QowM4K/q2cxvPegVgBNEpCUHF9g1O0VTwFKguB7UXLi2N
	WCjxHhAUZsyVLTwTKCAOFkODgyoZJDvpMjKnyvfEY
X-Gm-Gg: AY/fxX4A8E6kwuUoQcua1KhDi5axGSr4SkeCDJrk/0gb78dJEktocECfiglAoZ2okJR
	+ps+cANd/JBOvyWZ8maabVj4JMZPgSwUWKFkEK8TqDIoA8Q7c/49Wh9Dbq/7BrwSmoE0GsHKEC8
	XT3I13sqwl4DYCof3kPEWFZx9dNQYCNW3tT7rRbWgTHgjFoHhGMGPJ5Y3QS4UYKRdjIMH3WxmPJ
	PjSt+ZZkxeAeHjjiD81CP793L7Zl8Cf2jqv8xgE2ubKBR2Gbrwv+EPl9/Md2/mbyvEzSDE+Rpdg
	wJg6LlWFNW2TOpmTq+GanNKx0w==
X-Google-Smtp-Source: AGHT+IGMMTYzPGp/Mp30QguuEe7/GAoJyFmlnHc/gJd1vWeZWw81hgcnVwY3dgLaAkxs61fETO26Vf3lDcc7HIsbGvE=
X-Received: by 2002:a05:6102:5714:b0:5db:d60a:6b1f with SMTP id
 ada2fe7eead31-5ecb6938423mr4564466137.23.1767983388250; Fri, 09 Jan 2026
 10:29:48 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 9 Jan 2026 10:29:47 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 9 Jan 2026 10:29:47 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com> <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com> <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 9 Jan 2026 10:29:47 -0800
X-Gm-Features: AZwV_QjW90Epw5jyV04BkSH8MCSgjnOXAHnVLcSFaJumueQQQzvGLAM6a4_nd6U
Message-ID: <CAEvNRgHtDJx52+KU3dZfhOMjvWxjX7eJ7WdX8y+kN+bNqpspeg@mail.gmail.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
To: Yan Zhao <yan.y.zhao@intel.com>, Dave Hansen <dave.hansen@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, tabba@google.com, michael.roth@amd.com, david@kernel.org, 
	vannapurve@google.com, sagis@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, nik.borisov@suse.com, pgonda@google.com, 
	fan.du@intel.com, jun.miao@intel.com, francescolavra.fl@gmail.com, 
	jgross@suse.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, kai.huang@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jan 07, 2026 at 08:39:55AM -0800, Dave Hansen wrote:
>> On 1/7/26 01:12, Yan Zhao wrote:
>> ...
>> > However, my understanding is that it's better for functions expecting huge pages
>> > to explicitly receive "folio" instead of "page". This way, people can tell from
>> > a function's declaration what the function expects. Is this understanding
>> > correct?
>>
>> In a perfect world, maybe.
>>
>> But, in practice, a 'struct page' can still represent huge pages and
>> *does* represent huge pages all over the kernel. There's no need to cram
>> a folio in here just because a huge page is involved.
> Ok. I can modify the param "struct page *page" to "struct page *base_page",
> explaining that it may belong to a huge folio but is not necessarily the
> head page of the folio.
>
>> > Passing "start_idx" along with "folio" is due to the requirement of mapping only
>> > a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
>> > the nth idx of a 1GB folio.
>> >
>> > On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
>> > pages and have tdh_mem_page_aug() internally convert it to "folio" and
>> > "start_idx", it makes me wonder if we could have previously just passed "pfn" to
>> > tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".
>>
>> As a general pattern, I discourage folks from using pfns and physical
>> addresses when passing around references to physical memory. They have
>> zero type safety.
>>
>> It's also not just about type safety. A 'struct page' also *means*
>> something. It means that the kernel is, on some level, aware of and
>> managing that memory. It's not MMIO. It doesn't represent the physical
>> address of the APIC page. It's not SGX memory. It doesn't have a
>> Shared/Private bit.
>>
>> All of those properties are important and they're *GONE* if you use a
>> pfn. It's even worse if you use a raw physical address.
>>
>> Please don't go back to raw integers (pfns or paddrs).
> I understood and fully accept it.
>
> I previously wondered if we could allow KVM to pass in pfn and let the SEAMCALL
> wrapper do the pfn_to_page() conversion.
> But it was just out of curiosity. I actually prefer "struct page" too.
>
>
>> >>> -	tdx_clflush_page(page);
>> >>> +	if (start_idx + npages > folio_nr_pages(folio))
>> >>> +		return TDX_OPERAND_INVALID;
>> >>
>> >> Why is this necessary? Would it be a bug if this happens?
>> > This sanity check is due to the requirement in KVM that mapping size should be
>> > no larger than the backend folio size, which ensures the mapping pages are
>> > physically contiguous with homogeneous page attributes. (See the discussion
>> > about "EPT mapping size and folio size" in thread [1]).
>> >
>> > Failure of the sanity check could only be due to bugs in the caller (KVM). I
>> > didn't convert the sanity check to an assertion because there's already a
>> > TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.
>>
>> We generally don't protect against bugs in callers. Otherwise, we'd have
>> a trillion NULL checks in every function in the kernel.
>>
>> The only reason to add caller sanity checks is to make things easier to
>> debug, and those almost always include some kind of spew:
>> WARN_ON_ONCE(), pr_warn(), etc...
>
> Would it be better if I use WARN_ON_ONCE()? like this:
>
> u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *base_page,
>                      u64 *ext_err1, u64 *ext_err2)
> {
>         unsigned long npages = tdx_sept_level_to_npages(level);
>         struct tdx_module_args args = {
>                 .rcx = gpa | level,
>                 .rdx = tdx_tdr_pa(td),
>                 .r8 = page_to_phys(base_page),
>         };
>         u64 ret;
>
>         WARN_ON_ONCE(page_folio(base_page) != page_folio(base_page + npages - 1));

This WARNs if the first and last folios are not the same folio, which
still assumes something about how pages are grouped into folios. I feel
that this is still stretching TDX code over to make assumptions about
how the kernel manages memory metadata, which is more than TDX actually
cares about.

>
>         for (int i = 0; i < npages; i++)
>                 tdx_clflush_page(base_page + i);
>
>         ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
>
>         *ext_err1 = args.rcx;
>         *ext_err2 = args.rdx;
>
>         return ret;
> }
>
> The WARN_ON_ONCE() serves 2 purposes:
> 1. Loudly warn of subtle KVM bugs.
> 2. Ensure "page_to_pfn(base_page + i) == (page_to_pfn(base_page) + i)".
>

I disagree with checking within TDX code, but if you would still like to
check, 2. that you suggested is less dependent on the concept of how the
kernel groups pages in folios, how about:

  WARN_ON_ONCE(page_to_pfn(base_page + npages - 1) !=
               page_to_pfn(base_page) + npages - 1);

The full contiguity check will scan every page, but I think this doesn't
take too many CPU cycles, and would probably catch what you're looking
to catch in most cases.

I still don't think TDX code should check. The caller should check or
know the right thing to do.

> If you don't like using "base_page + i" (as the discussion in v2 [1]), we can
> invoke folio_page() for the ith page instead.
>
> [1] https://lore.kernel.org/all/01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com/
>
>> >>> +	for (int i = 0; i < npages; i++)
>> >>> +		tdx_clflush_page(folio_page(folio, start_idx + i));
>> >>
>> >> All of the page<->folio conversions are kinda hurting my brain. I think
>> >> we need to decide what the canonical type for these things is in TDX, do
>> >> the conversion once, and stick with it.
>> > Got it!
>> >
>> > Since passing in base "page" or base "pfn" may still require the
>> > wrappers/helpers to internally convert them to "folio" for sanity checks, could
>> > we decide that "folio" and "start_idx" are the canonical params for functions
>> > expecting huge pages? Or do you prefer KVM to do the sanity check by itself?
>>
>> I'm not convinced the sanity check is a good idea in the first place. It
>> just adds complexity.
> I'm worried about subtle bugs introduced by careless coding that might be
> silently ignored otherwise, like the one in thread [2].
>
> [2] https://lore.kernel.org/kvm/aV2A39fXgzuM4Toa@google.com/

