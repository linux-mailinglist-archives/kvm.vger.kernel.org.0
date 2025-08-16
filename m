Return-Path: <kvm+bounces-54825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DE1B289BC
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 03:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29109581973
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 01:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A7E199949;
	Sat, 16 Aug 2025 01:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DH29Qz3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1914F18A6AD
	for <kvm@vger.kernel.org>; Sat, 16 Aug 2025 01:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755309411; cv=none; b=aktMBVsBkec+Gx3eOEY9HD2cJrBDpB6IvRCD3YO/3DWR+nnWwr4v+6Cc7rF3Lv6x7SsyfMEAI7MRyW8oKdEH+avaBQ0mUF6+v64lahuiQs27xMJgVzz0zZi+c1ZBa3Cn46vtu1RcGGcRJtROT/yKGAeF+0OvxCXcZqa6n32MDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755309411; c=relaxed/simple;
	bh=Ej1Ms8x3fV9hlh+VBITET4wxyZCGlUYPCpJfqRg4/mk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I0dZwFNtypk7ZT5Ki1u7fwvD2mtrxQLaqYcAPwb8uiriVrqmRaDw6RlXPkBd/a5osqtbvY6epVTLXYjkTXtTpvM+LJTuemMeigt12ddloyBj6PBTw5AMira1lLoevN1yNKmtjJTC/09oAQ+EqMIisnD3M15Llvw2D/5XkGYulYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DH29Qz3M; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-242d1e947feso102085ad.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 18:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755309409; x=1755914209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4ItdIwW0Nn2rbKUapLvi+7KaOlcmfEY49F8WH61kT0=;
        b=DH29Qz3Mu9cmUzSOsvN+lWHbTYR0UenpjF6MiJc8ALS0O2NRQumsLUq8OqrPMOlvD/
         EKNocpxMLd/M9yKnBYYZ8KdeF1/L4J5a1Omxq2XN8gUOI9q2VXFBZUzQlSqDnZa8qj4T
         HNCQ0afMNiLLxLQX4/d7OuJigxTqTfNMlcq2Sm1yrR+zjPE/yF/bs1YMiMV3jCitLG2l
         Lc0vWKqIEYmkHD9BEJ9J9guKlb7yOFbFCWsaRgpSJusgtynNrtjreFQwF1UglYkxdleS
         0Lu9ayTLBZCcwOgLeR0rxSeEwjB/JIOxOeGREvfoy/ZdkEt+FKBY7X5IdQU1uCxM1l/W
         zBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755309409; x=1755914209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4ItdIwW0Nn2rbKUapLvi+7KaOlcmfEY49F8WH61kT0=;
        b=lpH8imJvYBVfIDn7WXSKwK7g4r30n6E+2jVlWdHv8E2iKEtPPGb+NJWDkf6ZaCYg8h
         2iBHk9MEocFTTUsjKjUbQVsnjyMKh40tsnRDAn5bo+7MdvsgY2q0FYMWRrfhMhTJ/iP4
         GzjEorAwv8DLSXFtcpDqUuDLrbHDoxVyRkDUhEhw7yxKw21FTjrgHvhrKTgCeI3I/ynb
         fefeUSLVoCv7RtIU9EAmPIr99pv7yN2ppHcx+wFITBMNs1cLMGmqDxKAAzu0zb4QOK1l
         m+KV2Rs2vPSV7qTQJzBBuox1465dh0FVf3RWv6D2PI9oBpNFoFt34iz0bojs+SSkeYVb
         rZhQ==
X-Gm-Message-State: AOJu0YxinxjpoSg9+/2zkxTB8QbAfYgyKJ8Yn8vke6a+HpqOYZ8Rbxw4
	tkDgtHz2xEnycD9F6M+narvBz3e6UFb5bdQI8/0iqIvVpFz7fJlhzl3of8IK2/VI9cuck/KbGj1
	rdz/njk5X7+mqAZwCFLp3zUcEUxpSEmjgpT8qAReH
X-Gm-Gg: ASbGncvJbi4gmDly9j4IndCBzVMSb6+b04+9oWH+5rQUB8PtVE6Vuw2StZdUkBK6Bca
	WUTdgw1zuMKJd/WlCjpcNOjbkBlRtwrUfPH5HFBsD+AcIGyWeDSAq+UhlCl4SVRVFcMPe6foP1G
	Zj5ddwfGuaivZKpkq+PWdTfYOzAEEqKgbWWN+8sxpSCHY6LQcKKhc0effr50qdDgLwMluUm5R1F
	L6sdpA4onj1oScZ57j91+T9NhpQEUzL/y7qe1Ic/IQ=
X-Google-Smtp-Source: AGHT+IGjIbEibm7TAU0Qy99Qr9hDz/0we50Y7edVXGYdgrm7Uw4jOk5StezzxSbZkloheGwBu8Np97ishY6Mw8oSHGs=
X-Received: by 2002:a17:903:18e:b0:223:2630:6b86 with SMTP id
 d9443c01a7336-2447a749a14mr766545ad.7.1755309408800; Fri, 15 Aug 2025
 18:56:48 -0700 (PDT)
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
Date: Fri, 15 Aug 2025 18:56:36 -0700
X-Gm-Features: Ac12FXy9Nf5jI_ZDaA0g-5pDhbHHzOx-JhcDUdLC5lWZaTciSyoinSl41owJHk4
Message-ID: <CAGtprH-TChZuLgb0sOU_14YGpCynw7sukLT0tP9sEzzd040dHw@mail.gmail.com>
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
> On 14/08/2025 17:26, Vishal Annapurve wrote:
> > On Wed, Aug 13, 2025 at 2:30=E2=80=AFAM Steven Price <steven.price@arm.=
com> wrote:
> >>
> >> On 01/08/2025 02:56, Vishal Annapurve wrote:
> >>> On Wed, Jun 11, 2025 at 3:59=E2=80=AFAM Steven Price <steven.price@ar=
m.com> wrote:
> >>>>
> >>>> +static int realm_create_protected_data_page(struct realm *realm,
> >>>> +                                           unsigned long ipa,
> >>>> +                                           kvm_pfn_t dst_pfn,
> >>>> +                                           kvm_pfn_t src_pfn,
> >>>> +                                           unsigned long flags)
> >>>> +{
> >>>> +       unsigned long rd =3D virt_to_phys(realm->rd);
> >>>> +       phys_addr_t dst_phys, src_phys;
> >>>> +       bool undelegate_failed =3D false;
> >>>> +       int ret, offset;
> >>>> +
> >>>> +       dst_phys =3D __pfn_to_phys(dst_pfn);
> >>>> +       src_phys =3D __pfn_to_phys(src_pfn);
> >>>> +
> >>>> +       for (offset =3D 0; offset < PAGE_SIZE; offset +=3D RMM_PAGE_=
SIZE) {
> >>>> +               ret =3D realm_create_protected_data_granule(realm,
> >>>> +                                                         ipa,
> >>>> +                                                         dst_phys,
> >>>> +                                                         src_phys,
> >>>> +                                                         flags);
> >>>> +               if (ret)
> >>>> +                       goto err;
> >>>> +
> >>>> +               ipa +=3D RMM_PAGE_SIZE;
> >>>> +               dst_phys +=3D RMM_PAGE_SIZE;
> >>>> +               src_phys +=3D RMM_PAGE_SIZE;
> >>>> +       }
> >>>> +
> >>>> +       return 0;
> >>>> +
> >>>> +err:
> >>>> +       if (ret =3D=3D -EIO) {
> >>>> +               /* current offset needs undelegating */
> >>>> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> >>>> +                       undelegate_failed =3D true;
> >>>> +       }
> >>>> +       while (offset > 0) {
> >>>> +               ipa -=3D RMM_PAGE_SIZE;
> >>>> +               offset -=3D RMM_PAGE_SIZE;
> >>>> +               dst_phys -=3D RMM_PAGE_SIZE;
> >>>> +
> >>>> +               rmi_data_destroy(rd, ipa, NULL, NULL);
> >>>> +
> >>>> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> >>>> +                       undelegate_failed =3D true;
> >>>> +       }
> >>>> +
> >>>> +       if (undelegate_failed) {
> >>>> +               /*
> >>>> +                * A granule could not be undelegated,
> >>>> +                * so the page has to be leaked
> >>>> +                */
> >>>> +               get_page(pfn_to_page(dst_pfn));
> >>>
> >>> I would like to point out that the support for in-place conversion
> >>> with guest_memfd using hugetlb pages [1] is under discussion.
> >>>
> >>> As part of the in-place conversion, the policy we are routing for is
> >>> to avoid any "refcounts" from KVM on folios supplied by guest_memfd a=
s
> >>> in-place conversion works by splitting and merging folios during
> >>> memory conversion as per discussion at LPC [2].
> >>
> >> CCA doesn't really support "in-place" conversions (see more detail
> >> below). But here the issue is that something has gone wrong and the RM=
M
> >> is refusing to give us a page back.
> >
> > I think I overloaded the term "in-place" conversion in this context. I
> > was talking about supporting "in-place" conversion without data
> > preservation. i.e. Host will use the same GPA->HPA range mapping even
> > after conversions, ensuring single backing for guest memory. This is
> > achieved by guest_memfd keeping track of private/shared ranges based
> > on userspace IOCTLs to change the tracking metadata.
>
> Yes, so for a destructive conversion this is fine. We can remove the
> page from the protected region and then place the same physical page in
> the shared region (or vice versa).
>
> Population is a special case because it's effectively non-destructive,
> and in that case we need both the reference data and the final
> (protected) physical page both available at same time.
>
> >>
> >>>
> >>> The best way to avoid further use of this page with huge page support
> >>> around would be either:
> >>> 1) Explicitly Inform guest_memfd of a particular pfn being in use by
> >>> KVM without relying on page refcounts or
> >>
> >> This might work, but note that the page is unavailable even after user
> >> space has freed the guest_memfd. So at some point the page needs to be
> >> marked so that it cannot be reallocated by the kernel. Holding a
> >> refcount isn't ideal but I haven't come up with a better idea.
> >>
> >> Note that this is a "should never happen" situation - the code will ha=
ve
> >> WARN()ed already - so this is just a best effort to allow the system t=
o
> >> limp on.
> >>
> >>> 2) Set the page as hwpoisoned. (Needs further discussion)
> >>
> >> This certainly sounds like a closer fit - but I'm not very familiar wi=
th
> >> hwpoison so I don't know how easy it would be to integrate with this.
> >>
> >
> > We had similar discussions with Intel specific SEPT management and the
> > conclusion there was to just not hold refcounts and give a warning on
> > such failures [1].
> >
> > [1] https://lore.kernel.org/kvm/20250807094241.4523-1-yan.y.zhao@intel.=
com/
>
> So these paths (should) all warn already. I guess the question is
> whether we want the platform to limp on in these situations or not.
> Certainly converting the WARNs to BUG_ON would be very easy, but the
> intention here was to give the user some chance to save their work
> before killing the system.
>
> Just WARNing might be ok, but if the kernel allocates the page for one
> of it's data structures then it's effectively a BUG_ON - there's no
> reasonable recovery. Reallocation into user space we can sort of handle,
> but only by killing the process.

Makes sense, this scenario is different from TDX as the host will run
into GPT faults if accessing memory owned by the realm world with no
good way to recover. Let's try to find the right complexity to take on
when handling errors for such rare scenarios, without relying on
refcounts as we start looking into huge page support.

>
> >>> This page refcounting strategy will have to be revisited depending on
> >>> which series lands first. That being said, it would be great if ARM
> >>> could review/verify if the series [1] works for backing CCA VMs with
> >>> huge pages.
> >>>
> >>> [1] https://lore.kernel.org/kvm/cover.1747264138.git.ackerleytng@goog=
le.com/
> >>> [2] https://lpc.events/event/18/contributions/1764/

