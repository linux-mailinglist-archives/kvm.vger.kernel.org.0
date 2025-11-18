Return-Path: <kvm+bounces-63626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 120D2C6C0D0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 006EA4E8863
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5783313E04;
	Tue, 18 Nov 2025 23:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IB0MzO6B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5611B27E1D5
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763509798; cv=none; b=Vd250c+uct32QW1tgJeloi9LuU6WWjeLr7tjJOGDngH4Y5IiXEmPTmXeQk04wGKthD9m+BloMtHGzozaB5ma/w3Ov2qT2tX4Ro9J4G3FwfgNaoNbvAgN+G9NGU7wYKQBW9IeX1Uuf+TlMOWneOSyUwrw1C4JwNe+lwrzBmL1jBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763509798; c=relaxed/simple;
	bh=bB0IjKmx5It+GPylYG68WZqvDj8jtg5HHHopGPW33ts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qtAI7el3kcIHhInB1PUGK1pkqwzjpgpkWeC/pi2pQOBsDu7yJ53olHTIVzeCzfpiIuhZVAN3HTXMHWwsRS6ZGSY509bb0RSoAJfeVBcDGU6t5rxwdBcY6vKsjeiuqm8/NjdK7IxfbyVzjRw9F4J8FLOFoSGdF95As2gvHYvzGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IB0MzO6B; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso6882763a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763509797; x=1764114597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQlAj3r/TNtuDvBj+1kn0ORH3+7LM3avG1xH2tJcUxw=;
        b=IB0MzO6BJ8xS5V5y+ryEqDwU+SODAVLLt7BKZcNCN6y407953GskRYlOiFhEfqNH/J
         nOTwkRezuK6EqISM/wrbR6fPPZIdAh9nFV5A7mgm5u0RuK16pTi7gLnDkDmZax9Ee8h3
         GvaKqJruYVOhruT/EJzOxtwE2KQpkNsflD0WNGvd8ZiMwtA8dMZ3SWoZDJ8mWT8QyGJm
         IA1wPWiaJrL8HkiE2Coo+P0BUpAUEbsZlzV27JsbrtJFe9012tPU7umLKWTUCfPB29s4
         2v04mTOaKCtLDBG87GvQcsggEekYYd5ro01PnhaPsphGJufA359M310wJhjL+ouSzRJw
         261Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763509797; x=1764114597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BQlAj3r/TNtuDvBj+1kn0ORH3+7LM3avG1xH2tJcUxw=;
        b=IDEw/vju24b0H20P2KeFyduqMDNkibWwc0yZWHoWWyyo2I+ilIqRZOnKWmq1iLmBaA
         JUJVuHIVqEyb39HbP9VR5TSYzFGWaFmEqegR520gaB+Mkpq+iaIu8LM5xYu8cy4TOEJz
         1BsQF2PAHxZgAS+g4eIaoevezMcJ3WB/+enNWoeS5wWnp8EmwY5Obt/iPYj4fNQIdDJz
         s7iVfTocyRWI1TZPqxDvem4USmBVDg1sZ9KK8XOww3k7t4rBH/2bsrepK3fQCOtaUupK
         koxCM54OJz/FTGYcR4oO6mp/w2pwfYBeguyMj2+sAp2B4YjrgZ3dJmwSMdI3jV0DX4ad
         WUSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmbtUijLbv6hL5VKsO9ZN+KSRKcBPcqcbryiY1Dpazj8zifqGJsphcvyZKmgiOVeonomU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWcT96dKxC0VuegSCy+iYRNzY4/Wh3aZvq2chVLgsTLWa784QN
	b81XjFEd1elke1a73pjB30OWZBmTT94f9B+Y2LnlU16pOAPfo0jgVHKl8XFeCfWr+XW9DxIo9Us
	h/vAX0w==
X-Google-Smtp-Source: AGHT+IFitQOWfyjVWaorasbGDNJterdirG43O1GlO7IipgpYOLEmWvnYPxare6VPplDjDr4agknUJDwhHgI=
X-Received: from pjbgv23.prod.google.com ([2002:a17:90b:11d7:b0:33b:5907:81cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f88:b0:33d:a0fd:257b
 with SMTP id 98e67ed59e1d1-343fa76159cmr20282671a91.36.1763509796690; Tue, 18
 Nov 2025 15:49:56 -0800 (PST)
Date: Tue, 18 Nov 2025 15:49:55 -0800
In-Reply-To: <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
 <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com> <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
Message-ID: <aR0GI81ZASDYeFP_@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025, Yosry Ahmed wrote:
> On Tue, Nov 18, 2025 at 03:00:26PM -0800, Jim Mattson wrote:
> > On Tue, Nov 18, 2025 at 2:26=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.=
dev> wrote:
> > >
> > > On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> > > > There are multiple selftests exercising nested VMX that are not spe=
cific
> > > > to VMX (at least not anymore). Extend their coverage to nested SVM.
> > > >
> > > > This version is significantly different (and longer) than v1 [1], m=
ainly
> > > > due to the change of direction to reuse __virt_pg_map() for nested =
EPT/NPT
> > > > mappings instead of extending the existing nested EPT infrastructur=
e. It
> > > > also has a lot more fixups and cleanups.
> > > >
> > > > This series depends on two other series:
> > > > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > > > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 5=
7-bit L1" [3]
> > >
> > > v2 of Jim's series switches all tests to use 57-bit by default when
> > > available:
> > > https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@google.=
com/
> > >
> > > This breaks moving nested EPT mappings to use __virt_pg_map() because
> > > nested EPTs are hardcoded to use 4-level paging, while __virt_pg_map(=
)
> > > will assume we're using 5-level paging.
> > >
> > > Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs") wil=
l
> > > need the following diff to make nested EPTs use the same paging level=
 as
> > > the guest:
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/tes=
ting/selftests/kvm/lib/x86_64/vmx.c
> > > index 358143bf8dd0d..8bacb74c00053 100644
> > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(struc=
t vmx_pages *vmx)
> > >                 uint64_t ept_paddr;
> > >                 struct eptPageTablePointer eptp =3D {
> > >                         .memory_type =3D X86_MEMTYPE_WB,
> > > -                       .page_walk_length =3D 3, /* + 1 */
> > > +                       .page_walk_length =3D get_cr4() & X86_CR4_LA5=
7 ? 4 : 3, /* + 1 */
> >=20
> > LA57 does not imply support for 5-level EPT. (SRF, IIRC)

Yuuuup.  And similarly, MAXPHYADDR=3D52 doesn't imply 5-level EPT (thank yo=
u TDX!).

> Huh, that's annoying. We can keep the EPTs hardcoded to 4 levels and
> pass in the max level to __virt_pg_map() instead of hardcoding
> vm->pgtable_levels.

I haven't looked at the series in-depth so I don't know exactly what you're=
 trying
to do, but why not check MSR_IA32_VMX_EPT_VPID_CAP for PWL5?

