Return-Path: <kvm+bounces-54803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B90B285B3
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 20:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AE117B532B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 18:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FBA25EF81;
	Fri, 15 Aug 2025 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dVOFnBS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A871FCF7C
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755281909; cv=none; b=BB2t3qEv1KIDlh+UsLhtYNkk94YacNF3bm60kCSD7hwawYKwRGziMXQwKUwmOqYlCrL0vhkK12s2SFdIbGwDCbQudag0+JdsLyyLTe8mh7IBUrnRPKfWByM/82uVW+Hoz8y5YV221jw/d6Hn9L7HHQCvKcU/iW0nwCzC7rqLmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755281909; c=relaxed/simple;
	bh=wY+vgsaCc43x29sy+D58GL7Km3HCFo3Oin22U4JvFBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hi7WaOVGawzMuLYkM7VyquQphOhrAJt4OAv9+/mMurNgWJbvlV4fHFbGpNq6pUMb7zCjdZm+V1kcb3mOp+ZO9jLhTc57sAW1vf2wK+O0iWemuixqAehuJtR+aQqABc/tKH1mGKGbEin8t3dZ6NpRkO3+l15p4DSHbypNGwfCdG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dVOFnBS0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-242d1e947feso29765ad.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755281907; x=1755886707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jY3sNtwdFAAn0D3rH2WM6exJASiMf81df/QjJ9/2MSs=;
        b=dVOFnBS0icPEpfG9PKqA7qMiu/H4KXRP+HtKEIrONAMhaobygzZvqSOrHQz67nkVoE
         hMK0VB5LdD10IJUkDAP8BsoF43b/LJvQli5ppST56uFSkApDFQ/aya963q5xwbcD1g+I
         xqttTZ+xC6IqrXZe0OfC8d/zWWuU8ZIz2STiQ1MwORTxqZ1ZQr+obqpiim6hk2BgGa8g
         G+FHAHdPY79zVSu8LxxnGcPxdLey3xIwbAo7WY8nSBf61uzWwYcqiXZngpi8pG+N2JW8
         t4TCYZIfNmjzPCYjisO0LqOWmj2QXIyMHClooQmJfmenRt7FBOl42XLtlKfhwA3ZE7i9
         Fxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755281907; x=1755886707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jY3sNtwdFAAn0D3rH2WM6exJASiMf81df/QjJ9/2MSs=;
        b=gE+MITs+hhriHB0REkhUkJlcg38tKo1m1ZMZ3/kqZTm8y2RhB1gUy875VlDeqUpi+3
         bHNcwNmhanZfl1x5J5CRgJWHxcHRpVKlPScrR07oz+jJSykjjs8lMUikyXVMkulgTjVW
         /ypPZkGx3LSjMQuue5Iwy4orCGNDHZGJLNbIO8xRXeoizZEBA8ydaeN4dq4ZuVt2cH3K
         tzCs2pzerOTxdxNmYgXdshru7mzZwQh4/LAFbxD7KJ0R4XdFPW0LJ6OOXyMsrHrIrti3
         m+D3GIm4MR8tEBg4seHAIpFWWKK2ckfsqNQUOlCjKW1TSrk7fC7Dj/AIPFFi13FuKu0K
         uLWw==
X-Gm-Message-State: AOJu0YzWDr85z0FWQr1OBUvKKA2xGwM1/VQlPTTnVlUPLNTvp9/dZfg5
	eeZQ8D39t21N+oAGDVFimUXijSPpeb/BKzKlemAekE5r3ACKTh4/OOGT42ybgHMuIUEPiVQmJmM
	+4DRmlUQgBq3pvaIgVZU55BOXl8Zsjop93v2hsrt3
X-Gm-Gg: ASbGncvKvZFN+foeSulh8iyrrA3RG50i5oHbHsNZFCyc9Sd8V6dt1HBoScuptXznUeq
	2SAoyPWpY3fE4cqAf39wU921FrZTPKgMcGELoSbQbtkYEJyORkv9TZC/4+69yNrGKlp8sQZHZJK
	4W6XbzPF2/ydrWjiMUpydRyM/jkS17fY8WYT5zLAGxyaeglIovQpYbasNOc1BBSfcPFzid/QIfc
	/zPGnCJjKYlNFnxzZmBVT0X5BFtxd7V0ALZJBpvCfNFtxshohEoUw==
X-Google-Smtp-Source: AGHT+IG/MLfEHn+NUjk3JeTkvygoGYy2JeIHzIrZZHZgIjMPHcITqpps3JgVEHZ+BBPTyF9DrPEKdybZgIAFZ8JuvHo=
X-Received: by 2002:a17:902:f709:b0:242:abac:2aae with SMTP id
 d9443c01a7336-24478e4ac08mr177905ad.12.1755281907107; Fri, 15 Aug 2025
 11:18:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611104844.245235-1-steven.price@arm.com> <20250611104844.245235-20-steven.price@arm.com>
 <CAGtprH-on3JdsHx-DyjN_z_5Z6HJoSQjJpA5o5_V6=rygMSbtQ@mail.gmail.com>
 <80c46a5c-7559-4763-bbf2-6c755a4b067c@arm.com> <CAGtprH_6DYk8POPy+sLc3RL0-5gcrTdPNcDWFTssOK5_U4B3Nw@mail.gmail.com>
 <23be7cdb-f094-4303-87ae-2fdfed80178b@arm.com>
In-Reply-To: <23be7cdb-f094-4303-87ae-2fdfed80178b@arm.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 15 Aug 2025 11:18:15 -0700
X-Gm-Features: Ac12FXxRfPJJ5CiXj1SEYOdMuRetA156ExPvVO3KltOm1QNQAryxM5r582UfZ7g
Message-ID: <CAGtprH9rbW173qZyC5_cHkKT5J4YDSg8itFcR2VZvSY88fsGrQ@mail.gmail.com>
Subject: Re: [PATCH v9 19/43] arm64: RME: Allow populating initial contents
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 8:48=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> >>>> +static int populate_region(struct kvm *kvm,
> >>>> +                          phys_addr_t ipa_base,
> >>>> +                          phys_addr_t ipa_end,
> >>>> +                          unsigned long data_flags)
> >>>> +{
> >>>> +       struct realm *realm =3D &kvm->arch.realm;
> >>>> +       struct kvm_memory_slot *memslot;
> >>>> +       gfn_t base_gfn, end_gfn;
> >>>> +       int idx;
> >>>> +       phys_addr_t ipa =3D ipa_base;
> >>>> +       int ret =3D 0;
> >>>> +
> >>>> +       base_gfn =3D gpa_to_gfn(ipa_base);
> >>>> +       end_gfn =3D gpa_to_gfn(ipa_end);
> >>>> +
> >>>> +       idx =3D srcu_read_lock(&kvm->srcu);
> >>>> +       memslot =3D gfn_to_memslot(kvm, base_gfn);
> >>>> +       if (!memslot) {
> >>>> +               ret =3D -EFAULT;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       /* We require the region to be contained within a single mem=
slot */
> >>>> +       if (memslot->base_gfn + memslot->npages < end_gfn) {
> >>>> +               ret =3D -EINVAL;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       if (!kvm_slot_can_be_private(memslot)) {
> >>>> +               ret =3D -EPERM;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       while (ipa < ipa_end) {
> >>>> +               struct vm_area_struct *vma;
> >>>> +               unsigned long hva;
> >>>> +               struct page *page;
> >>>> +               bool writeable;
> >>>> +               kvm_pfn_t pfn;
> >>>> +               kvm_pfn_t priv_pfn;
> >>>> +               struct page *gmem_page;
> >>>> +
> >>>> +               hva =3D gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa))=
;
> >>>> +               vma =3D vma_lookup(current->mm, hva);
> >>>> +               if (!vma) {
> >>>> +                       ret =3D -EFAULT;
> >>>> +                       break;
> >>>> +               }
> >>>> +
> >>>> +               pfn =3D __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), =
FOLL_WRITE,
> >>>> +                                       &writeable, &page);
> >>>
> >>> Is this assuming double backing of guest memory ranges? Is this logic
> >>> trying to simulate a shared fault?
> >>
> >> Yes and yes...
> >>
> >>> Does memory population work with CCA if priv_pfn and pfn are the same=
?
> >>> I am curious how the memory population will work with in-place
> >>> conversion support available for guest_memfd files.
> >>
> >> The RMM interface doesn't support an in-place conversion. The
> >> RMI_DATA_CREATE operation takes the PA of the already delegated
> >> granule[1] along with the PA of a non-delegated granule with the data.
> >
> > Ok, I think this will need a source buffer from userspace that is
> > outside guest_memfd once guest_memfd will support a single backing for
> > guest memory. You might want to simulate private access fault for
> > destination GPAs backed by guest_memfd ranges for this initial data
> > population -> similar to how memory population works today with TDX
> > VMs.
>
> Yes, that might well be the best option. At the moment I'm not sure what
> the best approach from the perspective of the VMM is. The current setup
> is nice because the VMM can populate the VM just like a normal non-coco
> setup, so we don't need to special-case anything. Requiring the VMM to
> load the initial contents into some other memory for the purpose of the
> populate call is a little ugly.

IIUC ARM CCA architecture requires two buffers for initial memory
population irrespective of whether we do it within kernel or in
userspace.

IMO, doing it in the kernel is uglier than doing it in userspace.
Baking the requirement of passing two buffers into userspace ABI for
populate seems cleaner to me.

>
> The other option is to just return to the double-memcpy() approach of
> emulating an in-place content-preserving populate by the kernel copying
> the data out of guest_memfd into a temporary page before doing the
> conversion and the RMM copying back from the temporary page. I worry
> about the performance of this, although it doesn't prevent the first
> option being added in the future if necessary. The big benefit is that
> it goes back to looking like a non-coco VM (but using guest_memfd).

Populate path is CoCo specific, I don't see the benefit of trying to
match the behavior with non-coco VMs in userspace.

>
> > Note that with single backing around, at least for x86, KVM
> > shared/private stage2 faults will always be served using guest_memfd
> > as the source of truth (i.e. not via userspace pagetables for shared
> > faults).
>
> Indeed, it's not yet clear to me whether we can only support this
> "single backing" world for CCA, or if it's going to be an option
> alongside using guest_memfd only for protected memory. Obviously we need
> the guest_memfd changes to land first too...

Having a dual backing support just for supporting the initial populate
seems overkill to me. How much payload in general are we talking about
in terms of percentage of total memory size?

IMO, dual backing for guest_memfd was a stopgap solution and should be
deprecated once we have single memory backing support.
CoCo VMs should default to using single backing going forward. Mmap
support [1] for guest_memfd is close to getting merged. In-place
conversion support is likely to follow soon.

[1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com/

>
> At the moment I'm planning to post a v10 of this series soon, keeping
> the same API. But we will definitely want to support the new guest_memfd
> approach when it's ready.
>
> Thanks,
> Steve
>

