Return-Path: <kvm+bounces-68341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A7BD339FA
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4427A30D9753
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F573469F1;
	Fri, 16 Jan 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tW/8TPEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72B8340A49
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768582846; cv=none; b=F8duntqp6+hy7VLpJz8ivypwPhz+ojNyVs5oF6u6O0iUuT0m5WFClaMNbgUU6KRcpCH85ne4zABfVmB+iFCUHdNaTTe2mNRzf/ElunpEbCA7hItKrvyrUp+AfJbf6S4D0L3+56ibY6KbUPlH9gV70HD8+a6JFjV4G/hW/lEVc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768582846; c=relaxed/simple;
	bh=n5omEAbeH0HypQYgn8QLZSDlUB+byBvXCM3ez0mbFks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJ/cx1mCOih7fRphXZbC5TL5hR5Wu7dbuWq8V28FzjiKCZig9s27zc7708rmuCsNS3kZevPfj6SvoLleTrgzTRwwRPbikDrnaJen1EBQB73ec9AZpwYwqHEASTez9aG71NeO/1j4ehnJemmt5ohoH+qHTwb2HoIEUY2PIzyeP64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tW/8TPEo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so1925415a91.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768582844; x=1769187644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBhZFuluv9bDOslyjEWNr1XnYBIC+ieAIYqPbHyJ5NU=;
        b=tW/8TPEohtYJ+r2xvNSuCcIHbgI93yZ6X6+qRkY3OSQxhH9b2qVdQUZ7rEgJcjB+5h
         05skzxFe91+8l6LBimLNF48cm/QF/pvRPCPyvvwMT0WguJFMfp71uos6SQOM5fQvTOL2
         GcdDidaMyIXCu4Pw+aI5p3AgZvaRoPqhLkBtEmge6Op7XH+a9GAFSEvXotknxm3qdKEY
         t8fgharZE7poKlbDzmjjm7BBfQ9AuqpLeHx/dnLkTD78si37FuTPMU79+Mv07bicAotF
         9L0uW4CQlSG3SNnzqqdOCLuZv2Zm/h8ME4QaCr7AX15USnJprjE+6NW/vaA9N6LoQX1O
         708Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768582844; x=1769187644;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LBhZFuluv9bDOslyjEWNr1XnYBIC+ieAIYqPbHyJ5NU=;
        b=u5f1n4wjOwqePcxt1iin778tmu11vrNYuC3RtQI9BB0z4TM7lgTeCTo+Z+Idmul2TW
         kvT4LJb21FRAxgSoZuIyHWhh342CgAc5D45d/2sZSa2vnA1aI0HR5iFHZn/4ekF1Xd6F
         +iQTCX/FRlCJ2hXQDycy02J3KaymV+b/5bZ6vAlKTCb41otjofwkBlkB+gPu8hTZKyyD
         COlPOJJTzqveVZPFJRhoyToLMpQOZL7+guWV1eElihsQrdHfyIfWyqU0UNT/FLukRNgD
         9QSvauX61IPpY4D7ZQNsUY7S5OhfIaCnufqbOCtDkcRUMLP45IVVAENW6UFVEjT+9nWq
         X54g==
X-Forwarded-Encrypted: i=1; AJvYcCXge/BhwMuemABQujzMXJO3H171tpf1zo1B20l/tY7V3Qj9YurcojukEZ5aVsjBJfpX9Q4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhy/BXHC6Fk63vlj9Pd5UlLsOaAv+FKyuP1CIxOh9oMVKcM+Yl
	DPYXpV2ElRsuV2tCGbItoW9BZMMjHutgu8P/nbAXcIp9o6tT807YcWlleDx5F0ZT6041A1nYVAh
	6BF8jXQ==
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:351:c54:1378])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5707:b0:343:7714:4ca6
 with SMTP id 98e67ed59e1d1-35272f6cf14mr2641098a91.22.1768582843913; Fri, 16
 Jan 2026 09:00:43 -0800 (PST)
Date: Fri, 16 Jan 2026 09:00:42 -0800
In-Reply-To: <aWpb1AnRHW2yupZp@wieczorr-mobl1.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me>
 <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com> <19zLzHKb9uDih-eLthvMnb-TF7WvD5Dk7shNZvYqyzl7wAsyS6s_fXuZG7pMOR4XfouH8Tb1MT7LqHvV5RXQLw==@protonmail.internalid>
 <aWpRwJqjzBxOaRwi@google.com> <aWpb1AnRHW2yupZp@wieczorr-mobl1.localdomain>
Message-ID: <aWpuuiuqZhkGRj2B@google.com>
Subject: Re: [PATCH v8 09/14] x86/mm: LAM compatible non-canonical definition
From: Sean Christopherson <seanjc@google.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Maciej Wieczor-Retman <m.wieczorretman@pm.me>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026, Maciej Wieczor-Retman wrote:
> On 2026-01-16 at 06:57:04 -0800, Sean Christopherson wrote:
> >On Fri, Jan 16, 2026, Andrey Ryabinin wrote:
> >> On 1/12/26 6:28 PM, Maciej Wieczor-Retman wrote:
> >> > diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page=
.h
> >> > index bcf5cad3da36..b7940fa49e64 100644
> >> > --- a/arch/x86/include/asm/page.h
> >> > +++ b/arch/x86/include/asm/page.h
> >> > @@ -82,9 +82,22 @@ static __always_inline void *pfn_to_kaddr(unsigne=
d long pfn)
> >> >  	return __va(pfn << PAGE_SHIFT);
> >> >  }
> >> >
> >> > +#ifdef CONFIG_KASAN_SW_TAGS
> >> > +#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_bi=
ts) - 1))
> >>
> >> why is the choice of CANONICAL_MASK() gated at compile time? Shouldn=
=E2=80=99t this be a
> >> runtime decision based on whether LAM is enabled or not on the running=
 system?
>=20
> What would be appropriate for KVM? Instead of using #ifdefs checking
> if(cpu_feature_enabled(X86_FEATURE_LAM))?

None of the above.  Practically speaking, the kernel APIs simply can't auto=
matically
handle the checks, because they are dependent on guest virtual CPU state, _=
and_
on the exact operation.  E.g. LAM doesn't apply to inputs to TLB invalidati=
on
instructions like INVVPID and INVPCID.

By the time KVM invokes __is_canonical_address(), KVM has already done the =
necessary
LAM unmasking.  E.g. having KVM pass in a flag saying it doesn't need LAM m=
asking
would be rather silly.

> >> > +#else
> >> > +#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
> >> > +#endif
> >> > +
> >> > +/*
> >> > + * To make an address canonical either set or clear the bits define=
d by the
> >> > + * CANONICAL_MASK(). Clear the bits for userspace addresses if the =
top address
> >> > + * bit is a zero. Set the bits for kernel addresses if the top addr=
ess bit is a
> >> > + * one.
> >> > + */
> >> >  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_=
bits)
> >>
> >> +Cc KVM
> >
> >Thanks!
> >
> >> This is used extensively in KVM code. As far as I can tell, it may be =
used to
> >> determine whether a guest virtual address is canonical or not.
> >
> >Yep, KVM uses this both to check canonical addresses and to force a cano=
nical
> >address (Intel and AMD disagree on the MSR_IA32_SYSENTER_{EIP,ESP} seman=
tics in
> >64-bit mode) for guest addresses.  This change will break KVM badly if K=
ASAN_SW_TAGS=3Dy.
>=20
> Oh, thanks! That's good to know.
>=20
> >
> >> case, the result should depend on whether LAM is enabled for the guest=
, not
> >> the host (and certainly not a host's compile-time option).
> >
> >Ya, KVM could roll its own versions, but IMO these super low level helpe=
rs should
> >do exactly what they say.  E.g. at a glance, I'm not sure pt_event_addr_=
filters_sync()
> >should be subjected to KASAN_SW_TAGS either.  If that's true, then AFAIC=
T the
> >_only_ code that wants the LAM-aware behavior is copy_from_kernel_nofaul=
t_allowed(),
> >so maybe just handle it there?  Not sure that's a great long-term mainte=
nance
> >story either though.
>=20
> Yes, longterm it's probably best to just get it right in here.

As above, I don't think that's feasible, because the context of both the cu=
rrent
(virtual) CPU and the usage matters.  In other words, making __canonical_ad=
dress()
itself LAM-aware feels wrong.

Actually, the kernel already has to deal with masking LAM bits for userspac=
e
addresses, and this series needs to unmask kernel address in other flows th=
at
effectively consume virtual addresses in software, so why not just do somet=
hing
similar for copy_from_kernel_nofault_allowed()?

diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index 42115ac079cf..0b3c96f8902a 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -33,7 +33,8 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_=
src, size_t size)
        if (!boot_cpu_data.x86_virt_bits)
                return true;
=20
-       return __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
+       return __is_canonical_address(__tag_reset(vaddr),
+                                     boot_cpu_data.x86_virt_bits);
 }
 #else
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)

