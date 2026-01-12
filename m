Return-Path: <kvm+bounces-67831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F9DD1522B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C68B304486D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E59532824D;
	Mon, 12 Jan 2026 19:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ajavoDxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446CA3164C8
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768247765; cv=none; b=N0pUALHY8zcm9yaYjMQurRIg5/ko9I5qWFxBGNog/HVdQw3ZID5bJt6jLae/NmhFG6hBcHYDbjwkBNczx8jQtt9iuu7PFiJT9xo++rK2MIyAv4pP3tCrZwqlGKhffyoLeLysg2FXSq9L8wPZ+c5EIqe9yvl2TU1SzjY7Nx8T5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768247765; c=relaxed/simple;
	bh=cSc/Cnugu82JZuXPULrd2kEQCjATdzFrUJAcFzAGfzk=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Content-Type; b=cVPWU184Q3aseBaOZrqiuxF0eqvL0eV6JsJ+j0wB4IiQdzJzsCkbomuKH1Fp/Y2no8JIeG6Us4s2VVqc/b7TFvbxvpOh3TcOYorgDkQ3coB+//xiYsPe0FEounJpPx+oFJwnFWEGj9rc8WlLkbaNbi0uCyYYg96L68bb0gHAigY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ajavoDxC; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-56379cb870bso423585e0c.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 11:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768247763; x=1768852563; darn=vger.kernel.org;
        h=to:subject:message-id:date:mime-version:references:in-reply-to:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4rsgMY7n9RJu+J9so3MR9djLOeVf6EOXqUwYnvenTjw=;
        b=ajavoDxCEf39r7RfbkDqfUNcVRAPkVUtiuey9g4BoIjY6ravxGjBVPNoWeqdo76b8j
         fNofsl2XFc548wlt1Ve8eqDrQ7TFdAPuVc7xMSk2Xx0/ZnYrn6kYZ7O+pQ78GGwAKsMj
         Qv1uNdGbK3MgNynwU5Z86+96w/eSjBWYdjMGBWH++cabHISL7+O/6BHnnrzTtcpFdmEo
         aEPsuTIiZ13GHk3v3PZAniqxt5l1hGjT2iPt79oyZ0Vt05Bq79eqtjQHAK7orilJEzXD
         ChaqtgBfpQFTYLrCzSrQZDPaCohxLHMpiaYwUa+AVObzcer/eZ2jolgmHwJIrNaZyK3s
         DCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768247763; x=1768852563;
        h=to:subject:message-id:date:mime-version:references:in-reply-to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4rsgMY7n9RJu+J9so3MR9djLOeVf6EOXqUwYnvenTjw=;
        b=QGNd/BswhE4b7k2uI6bHNM+t68fxjqkL776NrtDhExrdXhvPV/z1K/v1FR4K3verFq
         HkvXtGpN0S/KYTXCShM9obhHkRo1aKHso4i7nt+KXGg2O3eKlsO6vaii+20DDWVPK6ro
         nfMUJGdIpUQwX2Lc+Cl/5plZigy2mt5bkpjegQC5V+A7kiRwcv4ZRbYLukEw1vijPSID
         yydrYIiRab93unFu9xmYfIB4qfsBUQ/purIHofERAOW/qJYeIxsQvv2SAo8ctMI1BUBC
         H5BgAreDELx0FItkaQKnzBRvw+mdFyimnR1tEqo89uxjyTfWsR++M67heJVxbxHmFeyh
         FYoA==
X-Forwarded-Encrypted: i=1; AJvYcCW+d3HOIziWmyhndZNg3AG+0DG0zLT5/t1WMbsANg0vh3P2YrozUCndw/goxUzj6ERG4ws=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxDev7V6meh6zRfDl0DLbw3mEXEizMpT9HixM27itjSE75ET2U
	rqqE+zAUlwp9kDmg/my1eYTgZCYkWCxsmv+B59XorDqGSGg37Lzi3Jo2V+mmvmBKCXjLsY43dUs
	N3fnAuu8aCmC3AQ6M9DIqlVQoOIXYyveh2jlo7hSN
X-Gm-Gg: AY/fxX6gRWWOYc4KFRWYvkGxPvhwUhEkDcvnQ4XyCUUnAWPQwLNEQJdS7YVzogZPDwI
	MyuTksjjeq9ID4Yl7Y8o9n18C13RO5q6LQfn7GwMaTKgGYF5CWdx/5w+aYuvMEkvZP9qIvywDOb
	cdpKvjo5fDLxUK/iG+kXPCOnSVzByLC1t4HuAyxjAvPr17MCMzwMZjB4ySVfU2tH/TPTurRGPVM
	+duXknev48h7uafDjeCSTT8RAJymgdqByFiXKOnL7diz2fVjFDPt4q88dfJ5C/pH4wL2EauV1U9
	AqP1VcJgvpSXQNJksdZjFYSaWg==
X-Google-Smtp-Source: AGHT+IH0wnU4L8nPKhiuHjBajk39moS+//1QdnkVa9zA6ix8vhuEOUYX/Tmq5CSbubsQseZAArvwITcrApRPcpTH6Rg=
X-Received: by 2002:a05:6102:3c82:b0:5db:3bbf:8e62 with SMTP id
 ada2fe7eead31-5ecb5cbba61mr6784250137.1.1768247762739; Mon, 12 Jan 2026
 11:56:02 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Jan 2026 11:56:01 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Jan 2026 11:56:01 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com> <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
 <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com> <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Jan 2026 11:56:01 -0800
X-Gm-Features: AZwV_QjFI7p6-9Ram0lk0qFKYGsvzZVd4GQNqVVjHQ2Ga8Amyfe3ObWFgI9vu0Q
Message-ID: <CAEvNRgGCpDniO2TFqY9cpCJ1Sf84tM_Q4pQCg0mNq25mEftTKw@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, michael.roth@amd.com, 
	david@kernel.org, sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

>> > >> > I think the central question I have among all the above is what TDX
>> > >> > needs to actually care about (putting aside what KVM's folio size/memory
>> > >> > contiguity vs mapping level rule for a while).
>> > >> >
>> > >> > I think TDX code can check what it cares about (if required to aid
>> > >> > debugging, as Dave suggested). Does TDX actually care about folio sizes,
>> > >> > or does it actually care about memory contiguity and alignment?
>> > >> TDX cares about memory contiguity. A single folio ensures memory contiguity.
>> > >
>> > > In this slightly unusual case, I think the guarantee needed here is
>> > > that as long as a range is mapped into SEPT entries, guest_memfd
>> > > ensures that the complete range stays private.
>> > >
>> > > i.e. I think it should be safe to rely on guest_memfd here,
>> > > irrespective of the folio sizes:
>> > > 1) KVM TDX stack should be able to reclaim the complete range when unmapping.
>> > > 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
>> > > entries, guest_memfd will not let host userspace mappings to access
>> > > guest private memory.
>> > >
>> > >>
>> > >> Allowing one S-EPT mapping to cover multiple folios may also mean it's no longer
>> > >> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
>> > >> contiguous range larger than the page's folio range.
>> > >
>> > > What's the issue with passing the (struct page*, unsigned long nr_pages) pair?
>> > >

Please let us know what you think of this too, why not parametrize using
page and nr_pages?

>> > >>
>> > >> Additionally, we don't split private mappings in kvm_gmem_error_folio().
>> > >> If smaller folios are allowed, splitting private mapping is required there.
>> >
>> > It was discussed before that for memory failure handling, we will want
>> > to split huge pages, we will get to it! The trouble is that guest_memfd
>> > took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
>> > from the ground up), so we'll still need to figure out it's okay to let
>> > HugeTLB deal with it when freeing, and when I last looked, HugeTLB
>> > doesn't actually deal with poisoned folios on freeing, so there's more
>> > work to do on the HugeTLB side.
>> >
>> > This is a good point, although IIUC it is a separate issue. The need to
>> > split private mappings on memory failure is not for confidentiality in
>> > the TDX sense but to ensure that the guest doesn't use the failed
>> > memory. In that case, contiguity is broken by the failed memory. The
>> > folio is split, the private EPTs are split. The folio size should still
>> > not be checked in TDX code. guest_memfd knows contiguity got broken, so
>> > guest_memfd calls TDX code to split the EPTs.
>>
>> Hmm, maybe the key is that we need to split S-EPT first before allowing
>> guest_memfd to split the backend folio. If splitting S-EPT fails, don't do the
>> folio splitting.
>>
>> This is better than performing folio splitting while it's mapped as huge in
>> S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try to split
>> S-EPT. If the S-EPT splitting fails, falling back to zapping the huge mapping in
>> kvm_gmem_error_folio() would still trigger the over-zapping issue.
>>

Let's put memory failure handling aside for now since for now it zaps
the entire huge page, so there's no impact on ordering between S-EPT and
folio split.

>> In the primary MMU, it follows the rule of unmapping a folio before splitting,
>> truncating, or migrating a folio. For S-EPT, considering the cost of zapping
>> more ranges than necessary, maybe a trade-off is to always split S-EPT before
>> allowing backend folio splitting.
>>

The mapping size <= folio size rule (for KVM and the primary MMU) is
there because it is the safe way to map memory into the guest because a
folio implies contiguity. Folios are basically a core MM concept so it
makes sense that the primary MMU relies on that.

IIUC the core of the rule isn't folio sizes, it's memory
contiguity. guest_memfd guarantees memory contiguity, and KVM should be
able to rely on guest_memfd's guarantee, especially since guest_memfd is
virtualiation-first, and KVM first.

I think rules from the primary MMU are a good reference, but we
shouldn't copy rules from the primary MMU, and KVM can rely on
guest_memfd's guarantee of memory contiguity.

>> Does this look good to you?
> So, the flow of converting 0-4KB from private to shared in a 1GB folio in
> guest_memfd is:
>
> a. If guest_memfd splits 1GB to 2MB first:
>    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
>    2. split folio
>    3. zap the 0-4KB mapping.
>
> b. If guest_memfd splits 1GB to 4KB directly:
>    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
>    2. split folio
>    3. zap the 0-4KB mapping.
>
> The flow of converting 0-2MB from private to shared in a 1GB folio in
> guest_memfd is:
>
> a. If guest_memfd splits 1GB to 2MB first:
>    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
>    2. split folio
>    3. zap the 0-2MB mapping.
>
> b. If guest_memfd splits 1GB to 4KB directly:
>    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
>    2. split folio
>    3. zap the 0-2MB mapping.
>
>> So, to convert a 2MB range from private to shared, even though guest_memfd will
>> eventually zap the entire 2MB range, do the S-EPT splitting first! If it fails,
>> don't split the backend folio.
>>
>> Even if folio splitting may fail later, it just leaves split S-EPT mappings,
>> which matters little, especially after we support S-EPT promotion later.
>>

I didn't consider leaving split S-EPT mappings since there is a
performance impact. Let me think about this a little.

Meanwhile, if the folios are split before the S-EPTs are split, as long
as huge folios worth of memory are guaranteed contiguous by guest_memfd
for KVM, what are the problems you see?

