Return-Path: <kvm+bounces-68316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BFABED33027
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8665A302FC7F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033B73939BD;
	Fri, 16 Jan 2026 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IfBXVs7T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1516A304BBC
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575428; cv=none; b=MHyo2jkANhbGKy3WvHipYucUBuFjtp4blI/fEZYNByVYxuStOkMYrkX1FJI4WJlMoCKMIgSTjpEwDOO2QtMx/GQ6wazTI2rHKoXQjhMNHR8lfQ6G/Lw09FwI2Ns0LRhwBrd4PbM8Q1e4PBaTQUuq+Y642Noy0sgLfptSgrDeft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575428; c=relaxed/simple;
	bh=3FfFG/8Sfu2zSeeszrLQA9L0XS6OjUhmK2tFEfNFvG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O5xKqJaq00Ej48fSEL545OtH8IE8l1Qk5ggJu1442ztP+qFG83JKsUXEh9Vb4crZfqSC1BIwGZZi3AGHbhCL2b/kZLO+9De3eqpY8S+CypkZKF/ppF/VA+4dByaJMcG4HGvqBtN1CB+Br3m3W/IHcRahmCRH4na2luFvaMaGgA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IfBXVs7T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so4114312a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 06:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768575426; x=1769180226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QL9ufm+d9i6QPcOIxqlwFVWYb5rVko7dIEwvCG5N6jI=;
        b=IfBXVs7Tw+fYK3pvWh2OeoC/xJfRZLnR0MLmmEfnrpolMNZLPNgKzI5LYT40d1wtnD
         mLA71HR3ixzcwHTLxKdWicTavWocAZ4N8w6WKjWyinOaF8dpXHOBRnGnfYfmKhGu7YrI
         xueqQnouW4lDxLCtRuwdecKyRUQ/x4oPdk6uzq9A5IFY3cH0u6PNIJe+GqDI2jybufv3
         XusKJe5IWso6YFkTbfjeTpxju1sXJRO/ikVqzVAee4vPQKVVCqkIvYBx1mngX/WT05pQ
         9Fag9R8gYMk/xb+EIVhXG5BnrN4daY85E+BM0VQdAvMIIMPtVWFAJjyMAqucboDn15So
         Bssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768575426; x=1769180226;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QL9ufm+d9i6QPcOIxqlwFVWYb5rVko7dIEwvCG5N6jI=;
        b=EE48Er8seU5/k/wTdrxEjeEUyZ7lBi++ebG83i3x1RifZjS1o9Z7SLGqfOPHtLxEXE
         dG0BdgzpwW1+K6/+UZQDzHNO0QI3aTPfReOMX+R2pu6iP1L8KyqVAAGdsjHC9WJv8AvK
         ESSyP/LfybzlHLdkhX5S9xWl7KQjDwJHRFoocXsN8xFMY+v9lZeP0HHAUmNn0bZex/98
         00+x+QMo7h7x873q79K9JaOBA/X1yf63Wdpj3fIrsqSwnIVcs7IfytFTeyu0TfEsajn5
         qB0A1kFPh1FrJu1tT7uRtiNLHJqKfu0Uy3quQzqwKvCIM8nZpop9JquDcNOiT2kLUfks
         tnVw==
X-Forwarded-Encrypted: i=1; AJvYcCU0rieR/kG5SqV05Wjd4drmW16DdJjSP0Gwn9pvwm+zOtEF+nsk5dD+U62223A6Ua9ZA8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNvfPrCAzzD0GbM/zlvSTgESJU5H8um/DSSce2tWv5hQEHiDxB
	MjclJQswsn5Vl6Zm5KOkrQa64ICuud7gN2StMkFz0W+wfzaC3m2MBdlq6h5v1rqiyJoM0M4EvHl
	f2M4eeA==
X-Received: from pjbie5.prod.google.com ([2002:a17:90b:4005:b0:34b:fe89:512c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec6:b0:343:6d82:9278
 with SMTP id 98e67ed59e1d1-35272fb1029mr2842393a91.30.1768575426288; Fri, 16
 Jan 2026 06:57:06 -0800 (PST)
Date: Fri, 16 Jan 2026 06:57:04 -0800
In-Reply-To: <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me>
 <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com>
Message-ID: <aWpRwJqjzBxOaRwi@google.com>
Subject: Re: [PATCH v8 09/14] x86/mm: LAM compatible non-canonical definition
From: Sean Christopherson <seanjc@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026, Andrey Ryabinin wrote:
> On 1/12/26 6:28 PM, Maciej Wieczor-Retman wrote:
> > diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> > index bcf5cad3da36..b7940fa49e64 100644
> > --- a/arch/x86/include/asm/page.h
> > +++ b/arch/x86/include/asm/page.h
> > @@ -82,9 +82,22 @@ static __always_inline void *pfn_to_kaddr(unsigned l=
ong pfn)
> >  	return __va(pfn << PAGE_SHIFT);
> >  }
> > =20
> > +#ifdef CONFIG_KASAN_SW_TAGS
> > +#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_bits)=
 - 1))
>=20
> why is the choice of CANONICAL_MASK() gated at compile time? Shouldn=E2=
=80=99t this be a
> runtime decision based on whether LAM is enabled or not on the running sy=
stem?
> =20
> > +#else
> > +#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
> > +#endif
> > +
> > +/*
> > + * To make an address canonical either set or clear the bits defined b=
y the
> > + * CANONICAL_MASK(). Clear the bits for userspace addresses if the top=
 address
> > + * bit is a zero. Set the bits for kernel addresses if the top address=
 bit is a
> > + * one.
> > + */
> >  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bit=
s)
>=20
> +Cc KVM

Thanks!

> This is used extensively in KVM code. As far as I can tell, it may be use=
d to
> determine whether a guest virtual address is canonical or not.

Yep, KVM uses this both to check canonical addresses and to force a canonic=
al
address (Intel and AMD disagree on the MSR_IA32_SYSENTER_{EIP,ESP} semantic=
s in
64-bit mode) for guest addresses.  This change will break KVM badly if KASA=
N_SW_TAGS=3Dy.

> case, the result should depend on whether LAM is enabled for the guest, n=
ot
> the host (and certainly not a host's compile-time option).

Ya, KVM could roll its own versions, but IMO these super low level helpers =
should
do exactly what they say.  E.g. at a glance, I'm not sure pt_event_addr_fil=
ters_sync()
should be subjected to KASAN_SW_TAGS either.  If that's true, then AFAICT t=
he
_only_ code that wants the LAM-aware behavior is copy_from_kernel_nofault_a=
llowed(),
so maybe just handle it there?  Not sure that's a great long-term maintenan=
ce
story either though.

