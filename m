Return-Path: <kvm+bounces-64005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 096E2C76AAD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 615D735E16E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EFB30E83D;
	Thu, 20 Nov 2025 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wqv50+yS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358B30BBA3
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682664; cv=none; b=JziTa7sz0M9yVzl24ILojZ7qJM2utKvbmEwu9mKyHZcKB/yFjab4iCdITiwFerK0bDpvT2rqj5KcPXFeN2XWG+OJ3sf8NjkRAJNaxvczp0j1zmKhhXWQ75mi7K59IArrsmHmZSCZHyvUBX1ADokeagx6cZNE8SMVqNMKFD4ZaDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682664; c=relaxed/simple;
	bh=wAPZivYOMHkDR4JeK2ZUADR/++iooVHZlCDWkKTiovQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W2L6ZyTypjDoA9L0HObO7v/0wuDYY+zps+BaJULuwwJviwE65AO4PRlWZfpncipikNKOpdeKsi4+/sPu7G0Xqi1vAu0xU/8f0NxgXstcojXHmogXi0q08uo+3O0xI+dtNiccdYYNGXcGnHpoQoSgxnIZz1POIGfa4jGFOxjT2MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wqv50+yS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-342701608e2so1606907a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763682663; x=1764287463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tsDKuH4iwTs4JY/fFdI2/78Dj2xeVmTj3cLA95jGMHI=;
        b=wqv50+ySenhAFb/PizUxCnQRJafyZZ7zqBhX5nZBg1hOI6vkqdY+Lau0Bm94L6wTEI
         6Q+yNXr4DKoYFs6hMDfdtG5NysdX7A28cOK4fcN2nhQl9bJ1GXHa6uBKIlgdPRmHpgWY
         QaPLkeFoEnWiKXNtrYGRhKRcMsi1ZdIz3BbGa61c/t+nCdrwFDrzwM+h2AXlH8bx92Po
         t85VVJvPS8RWiS+BQzPKQY00CWH9UnOms08Vesrj7un3oxDPxOOKpgM/1kzil4yhmTAA
         pCimOj/pzcEGxb7x8T+APPXhfoiEBf0wZYe6t8CXeFojUW7beTHV/ZDokZkqHjMe3bwM
         oYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763682663; x=1764287463;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tsDKuH4iwTs4JY/fFdI2/78Dj2xeVmTj3cLA95jGMHI=;
        b=U/8AngTWb6FT58ztdaDY3ugTWfKCCisoxzaiMzvbRU0ryeNZpIy9ufUQWv+jFk1AZh
         T3ejLgJW5Acu0k1pSC0F69rHum+IaVod/7P0tAoKOGK7niqH4JpUxUxqcmrqnHF4SGNm
         epRUCbXecvUijP9HAuBr3lpl5lGWvUki5Zbir3bJmafsxroJtXoIFSQrAnTa9Abj3uzM
         5K+t8pUAO/qmWzznpOnjCaQb9qRwPAPXNlzDhFrVsltoMJPbR6oGdPazmkRgxAyKheKh
         QofbXAb6f3oiJfD4jpxs0m3NV6AK/4AwMC8BocQOMa8i1moYPQHtWgiIJAUnipT5LpGk
         E4iA==
X-Forwarded-Encrypted: i=1; AJvYcCU4ncxaEt5lB1yxoEe/CL/ofoiPy+oAayNGDvapSdX0o3HNDP4oaaD7wzZCXjv5RXcWq/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwE93MlPiK5h7Glm7+FTYwdTAKliJmgVpd7bCGRqdCxoFyiTGui
	1wHujQeV7lvOubPgwrhoP8iRHc7z9jUSALSqJEpJm8VHPKNPrRnkAQsYc2XicFaQadSqi1MpPmI
	hDLAGbA==
X-Google-Smtp-Source: AGHT+IF1fTQ/8cNwXe46tuOknfPEcoZDXBHNJfIVOB0uV+ZgkifDtoCo+zmMMF5SD1wrmdxLx7y2Xu6UyAc=
X-Received: from pjbsv16.prod.google.com ([2002:a17:90b:5390:b0:340:9d73:9c06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5183:b0:340:7b2e:64cc
 with SMTP id 98e67ed59e1d1-34733e5c408mr287132a91.15.1763682662740; Thu, 20
 Nov 2025 15:51:02 -0800 (PST)
Date: Thu, 20 Nov 2025 15:51:01 -0800
In-Reply-To: <vh3yjo36ortltqjrcsegllzbpkmum2c5ywna25q3ah25txlv74@4edzsqjjs73c>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
 <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
 <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
 <aR0GI81ZASDYeFP_@google.com> <vh3yjo36ortltqjrcsegllzbpkmum2c5ywna25q3ah25txlv74@4edzsqjjs73c>
Message-ID: <aR-pZcbIm7-l0jyh@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025, Yosry Ahmed wrote:
> On Tue, Nov 18, 2025 at 03:49:55PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 18, 2025, Yosry Ahmed wrote:
> > > On Tue, Nov 18, 2025 at 03:00:26PM -0800, Jim Mattson wrote:
> > > > On Tue, Nov 18, 2025 at 2:26=E2=80=AFPM Yosry Ahmed <yosry.ahmed@li=
nux.dev> wrote:
> > > > > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools=
/testing/selftests/kvm/lib/x86_64/vmx.c
> > > > > index 358143bf8dd0d..8bacb74c00053 100644
> > > > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > > @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(s=
truct vmx_pages *vmx)
> > > > >                 uint64_t ept_paddr;
> > > > >                 struct eptPageTablePointer eptp =3D {
> > > > >                         .memory_type =3D X86_MEMTYPE_WB,
> > > > > -                       .page_walk_length =3D 3, /* + 1 */
> > > > > +                       .page_walk_length =3D get_cr4() & X86_CR4=
_LA57 ? 4 : 3, /* + 1 */
> > > >=20
> > > > LA57 does not imply support for 5-level EPT. (SRF, IIRC)
> >=20
> > Yuuuup.  And similarly, MAXPHYADDR=3D52 doesn't imply 5-level EPT (than=
k you TDX!).
> >=20
> > > Huh, that's annoying. We can keep the EPTs hardcoded to 4 levels and
> > > pass in the max level to __virt_pg_map() instead of hardcoding
> > > vm->pgtable_levels.
> >=20
> > I haven't looked at the series in-depth so I don't know exactly what yo=
u're trying
> > to do, but why not check MSR_IA32_VMX_EPT_VPID_CAP for PWL5?
>=20
> The second part of the series reuses __virt_pg_map() to be used for
> nested EPTs (and NPTs). __virt_pg_map() uses vm->pgtable_levels to find
> out how many page table levels we have.
>=20
> So we need to either:
>=20
> (a) Always use the same number of levels for page tables and EPTs.
>=20
> (b) Make __virt_pg_map() take the number of page table levels as a
>   parameter, and always pass 4 for EPTs (for now).
>=20
> I suggested (a) initially, but it doesn't work because we can
> technically have LA57 but not MSR_IA32_VMX_EPT_VPID_CAP, so we need to
> do (b). We can still check MSR_IA32_VMX_EPT_VPID_CAP and use PWL5 for
> EPTs, but that's an orthogonal change at this point.

I choose option (c)

 (c) Add a "struct kvm_mmu" and use it to hold the PTE masks, root, root le=
vel,
     and any other metadata that comes along in the future.

Then we only need to do the core plumbing once, to get "struct kvm_mmu *mmu=
"
passed in.  After that, adding each piece only needs to touch code that act=
ually
cares about those things.

That was going to be my vote even without this particular discussion (I for=
got
why I even started reviewing the series, *sigh*), because the root_gpa and
pte_masks should be passed as a single entity.  The root+level are even mor=
e
tightly coupled.

