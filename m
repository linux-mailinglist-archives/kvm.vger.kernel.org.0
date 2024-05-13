Return-Path: <kvm+bounces-17353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5F48C488C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FCD91F23F20
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 20:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714E9824B7;
	Mon, 13 May 2024 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v//YArKL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE2781AAA
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 20:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715633783; cv=none; b=NM7pambQK+vTxyQzn0jXmzh5OYNd0qMyD6J/2jP1JUE6GvFlsIiVLlxvcnUWSCuQ20kMQEGUr+JCuFEgFlsgX1gQXz1dh+MQm0FyTEEDoZONRmlywt2KwyFeXs94rWdzNfPcfihYZqtVLToSBOH3n1FqS00ViJxpH8oKC+d3Pp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715633783; c=relaxed/simple;
	bh=a38ahy8MNKvTWoemBchbGlDmXUcxYFOMei1qLnNBQNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DxikLwQNZsxDp9fSF2O0gEEBL+PxL+P+skrQ8AI8fOESBvv/BOlkbpl+1SbtoD/8mGKVy5ASGXV+rNbgE2fSl2NLW3wyKAV7uoGSRm5eUyqN1Bw7N/GeExqVU30es7TI0R9+vyRhtUVHEBXNdNLLbe+ZZZi0cRnonRNNOP8KyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v//YArKL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b3717c5decso4258784a91.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 13:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715633781; x=1716238581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9J9OiagbHgYo4fNILaqE2zKAvLmIQvaQQp7mxiI34I=;
        b=v//YArKL07LrU4NeKMa3DAPuqc5+xZWlW1IhlfXE5guWP0h+0ixtDgM+b8rg+QPd7b
         6n3bDIq+J1Dl1Z9da7Uz0nQfucyr8eNobly+HZ5bRocPEwFanLmOD55oJ3cKmvzKqG8+
         fyej6rheyk3MyuXCCOIKKOxRvtKU+bp44Kzs4D9U0KNU+NdEkhG/0pYqPG137iixDSlm
         O0jKCZQuxU8joz8OlP2fzvcl57OY4KUetr99x9CHWBm2DvbDf8LTiQ2ddV7yEgGyl46l
         aAc5kTAujpmUahIYb6/FsFlomE80Xxg3m3zHUFCixHohQ6MapwDmXB/XrX3l1QNs9KcQ
         fGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715633781; x=1716238581;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j9J9OiagbHgYo4fNILaqE2zKAvLmIQvaQQp7mxiI34I=;
        b=kJowMxDYtkBpZ0NNlmumJFDlzdxOEIMNzQOzIITELs830GI86oVNWlU9r7axEj6gEs
         0SUM4Zsco8pDvj9TUTJtZySkaDKc3Fdp+36C8ivCvN6KjVidltLaL3Eo/ZK1BvYM6PH5
         kqogNBMj9/xnH7N83pZ1GjVxvPuRvKRL6VUuRDbIcJDRoMzFL3dcn7zAJVTWqpNXn7SP
         T/oT1g36h9JBwrCgdaPGKcDg8Bjs4+T9ZHPMfOGCSUPBJ1QrsBk3s68qPz3NVj+fC1tA
         T2aJTU7MQ2ad1H3LHMMPYlPIfzNmaAcAwV/tMcWGKr7+qcB7wDJqA6OuhtSHrGLkqd/k
         Y8eg==
X-Forwarded-Encrypted: i=1; AJvYcCUxZNLu3mv3XDDTEK90hEd3lOlI8CWiQKKKm4JwziURnR4Wd3yIFz1jXn8Npgs+H6OAT/QUzDGZiIQVhKhJ808YZuKZ
X-Gm-Message-State: AOJu0YzXBti2ZM4tafBt4ZHUZsbxBNQnqzFrB0xmM7XPKt7GG5VVGek5
	c0CSgzcTkgvmGGtOxdiIr9M0YCRADD8ov8tE0z2GC1RRosBPOPaG/rDarmdQZssL98dBFW4ODmC
	Igg==
X-Google-Smtp-Source: AGHT+IFcGEcUsDPl12bJyUIqIjMBgOr+q2PeBKpAeayx0CQKwRTQxdpBuaJA0HUJg/j9PlAOBRvWKuscvf0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1788:b0:2ad:7736:1a05 with SMTP id
 98e67ed59e1d1-2b6cc769ce3mr29621a91.3.1715633780682; Mon, 13 May 2024
 13:56:20 -0700 (PDT)
Date: Mon, 13 May 2024 13:56:19 -0700
In-Reply-To: <20240513203839.GA168153@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-3-pbonzini@redhat.com>
 <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com> <4d0d9f64-4cc4-4c1e-ba27-ff70c9827570@linux.intel.com>
 <20240513203839.GA168153@ls.amr.corp.intel.com>
Message-ID: <ZkJ-c5El-sXc-GZB@google.com>
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	thomas.lendacky@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024, Isaku Yamahata wrote:
> On Tue, Mar 26, 2024 at 11:56:35PM +0800, Binbin Wu <binbin.wu@linux.inte=
l.com> wrote:
> > > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > > index d93f6522b2c3..827ecc0b7e10 100644
> > > > --- a/include/linux/kvm_types.h
> > > > +++ b/include/linux/kvm_types.h
> > > > @@ -86,6 +86,7 @@ struct gfn_to_pfn_cache {
> > > > =C2=A0 struct kvm_mmu_memory_cache {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp_zero;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp_custom;
> > > > +=C2=A0=C2=A0=C2=A0 u64 init_value;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kmem_cache *kmem_cache;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int capacity;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nobjs;
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 9c99c9373a3e..c9828feb7a1c 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *=
kvm)
> > > > =C2=A0 static inline void *mmu_memory_cache_alloc_obj(struct
> > > > kvm_mmu_memory_cache *mc,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp_flags)
> > > > =C2=A0 {
> > > > +=C2=A0=C2=A0=C2=A0 void *page;
> > > > +
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_flags |=3D mc->gfp_zero;
> > > > =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mc->kmem_cache)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return kmem_=
cache_alloc(mc->kmem_cache, gfp_flags);
> > > > -=C2=A0=C2=A0=C2=A0 else
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return (void *)__get_fr=
ee_page(gfp_flags);
> > > > +
> > > > +=C2=A0=C2=A0=C2=A0 page =3D (void *)__get_free_page(gfp_flags);
> > > > +=C2=A0=C2=A0=C2=A0 if (page && mc->init_value)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset64(page, mc->init=
_value, PAGE_SIZE /
> > > > sizeof(mc->init_value));
> >=20
> > Do we need a static_assert() to make sure mc->init_value is 64bit?
>=20
> That's overkill because EPT entry is defined as 64bit and KVM uses u64 fo=
r it
> uniformly.

I'm pretty sure Binbin is talking about passing init_value to memset64(), n=
ot
about whether or not that suffices for EPT.  So I wouldn't say it's overkil=
l.

However, I don't think a static assert is warranted.  Functionally, trackin=
g
init_value as a u32 or even a u8 would be a-ok as it's a copy-by-value para=
meter
that won't be sign-extended or truncated.  I.e. the real reqiurement comes =
from
TDX wanting to set a 64-bit value.

And trying to set bit 63 in a 32-bit field _will_ make the compiler unhappy=
:

arch/x86/kvm/mmu/mmu.c: In function =E2=80=98kvm_mmu_create=E2=80=99:
include/vdso/bits.h:8:33: error: conversion from =E2=80=98long long unsigne=
d int=E2=80=99 to =E2=80=98u32=E2=80=99 {aka =E2=80=98unsigned int=E2=80=99=
} changes value from =E2=80=989223372036854775808=E2=80=99 to =E2=80=980=E2=
=80=99 [-Werror=3Doverflow]
    8 | #define BIT_ULL(nr)             (ULL(1) << (nr))
      |                                 ^
arch/x86/kvm/mmu/spte.h:162:33: note: in expansion of macro =E2=80=98BIT_UL=
L=E2=80=99
  162 | #define SHADOW_NONPRESENT_VALUE BIT_ULL(63)
      |                                 ^~~~~~~
arch/x86/kvm/mmu/mmu.c:6225:17: note: in expansion of macro =E2=80=98SHADOW=
_NONPRESENT_VALUE=E2=80=99
 6225 |                 SHADOW_NONPRESENT_VALUE;
      |                 ^~~~~~~~~~~~~~~~~~~~~~~


I suppose one could argue that changing init_value to a u128 could result i=
n
undetected truncation, but IMO that firmly crosses into ridiculous territor=
y.

