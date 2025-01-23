Return-Path: <kvm+bounces-36316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6231BA19C24
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 02:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 735BC188521E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F981D555;
	Thu, 23 Jan 2025 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WjHfHha9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45225629
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737595036; cv=none; b=pl7e9d/AIIWxRKF1nwxMep2p2FAefBCDXnrFIX8jwK5sYQl80VJzgfn9BwUmMBiC8t86MH7CSVxZsW+1FgDQiarqiK1ddc5rOxXiGQF+f+xZukL27kkIAuDLmWAWMq4NKVD8hsUpT60l92dbAQY2Pnb7xlfcE+S//DXUDY3aONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737595036; c=relaxed/simple;
	bh=Mz+Pwy++vYRu8PIXxfJGevAhGSzaG1rHmxVefS7fT5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2JCSGalzBom6kOE1AciP/J8NpzE4TBYpNG9fh7hU2lxDlXpH/P2w85KS5alWPtQF6pMw+IhhAQbsogl5UM+3c/wlkSxXD82UqvnAcENCtAuXEc9Dm39wfaUP+hn/+OeJMZu9Rz/HrBZCvOer01R/VgtBb/c7z6eeA31kMTLAZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WjHfHha9; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-8641bc78952so101451241.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 17:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737595034; x=1738199834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TmDjalffEM2QhoxzdwgJcTgpiuF1rwhaxf0ZWZEP3o=;
        b=WjHfHha9Et3pA7j9eR/0i54afWog2+fIngkoWjRhhfIPnT2dZQqbHx53ych/xy6hxw
         VIUj/eg7M8ETg4kmwBrZ28MNXOHtP4N4t9nMMIEJDl/9KWA83CW8oZGinhgze/TISLsW
         IYF9BGsOUQFHRUHVYpALIMXJqB72fwrkhuNHAgDihqghJNXEe3zruYYooMleRUUWtqr+
         FWp754knFu2scTlj8AHhNZV4f8zywHfMKTMoUPw15QWVu0dCUoWtdra0mK+qJAE8NHin
         jjns00bL/Vm+H3rwdcnuBRROU96qoZcQF7MLrjWXPXOZqVac+F88u6rmytPCp8dcz50S
         SVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737595034; x=1738199834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TmDjalffEM2QhoxzdwgJcTgpiuF1rwhaxf0ZWZEP3o=;
        b=fYGAS5fh1xZA0isrVNLVOMGPOHsktGmRARGf/t3ky8ebjCzC/UREaFgdihdOG9ZKvE
         qq1SrvNShJXbqL/EWmpyZeKc9/UATdckvC5cNSt6W7U0JarYPomA/hG+ZDtaF28UA0mL
         S15nf+wkG6PcO6B4bRNdclqTiFUdgjC37NjhCndywnQE4UUN6dGL4Lkb3yhgLTZ7riJE
         8DdfUkHfzxKviAtYKYQy8yTJe8T/VdVmQlbgGh914O0C/Jaf+iVSivvUKN14b57TAkMr
         jrkauOD+F446vLySSg+JWerTDWJazWN+vd+1530gfLDPuncpSjhXGu7bTTcaaO+f6XMR
         RXiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNF74mc+JCe1aAba5/zIRw+yzAqmtMJtgpomzYBJuSdCqkQ++JsWqb01xuAGfz5eQHUDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF9ALsPmL3M8RYV9bdh/eKFz331XaeNgcFlgSYirR2O6ALwwci
	/H1NvrFaBC0vF5pSitnULaYmI0O359ojZKvbVmjmzar+ZBLCVUOibN+Uty2+hqJEIP9X6anklw4
	MVnKDrYpmMU0TF4kdBB96GXa39rsItYu66ZLp
X-Gm-Gg: ASbGnctz85KQxC8YlAdmpenMAQZ4jXteVcn0PlP5dHUXx/w5uy6C/RwEnckpLHcBFkO
	+01+Ybdrz+wO9KKZg5IWCYumfEUiP4VFI1r3DEI65WCUVfSo2Gry3YILbn8YS6cAjP1jPdKprHd
	XY9VfruSfnmgug9+VhPk0=
X-Google-Smtp-Source: AGHT+IHjafuHLJmB55v40CA4vF4HRmwsl26uuCCaL4je8cWUKPEpJtNczvi86Fkvt8GFO6bFt0W0ykMxIFKHAiNVYrU=
X-Received: by 2002:a05:6102:548d:b0:4b6:5e0f:6ddc with SMTP id
 ada2fe7eead31-4b690be8ea7mr16873659137.14.1737595033832; Wed, 22 Jan 2025
 17:17:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com> <20250122013438.731416-2-kevinloughlin@google.com>
 <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
 <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com> <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
 <CAGdbjm+syon_W0W_oEiDJBKu4s5q9JS9cKyPmPoqDAzeyMJf3Q@mail.gmail.com>
 <3dd183fa-df95-487e-a2e9-73579fa160be@intel.com> <CAGdbjm+pBXysSJjt6GaJHFQB8S5857Yk3LVziXGOf7QH5SzyeQ@mail.gmail.com>
In-Reply-To: <CAGdbjm+pBXysSJjt6GaJHFQB8S5857Yk3LVziXGOf7QH5SzyeQ@mail.gmail.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 22 Jan 2025 17:17:03 -0800
X-Gm-Features: AWEUYZk-mvuPUwg0qot0sPdb1-sb6cG422VpZZCH9sRaPUkr3G6uNP9uAsEUt8s
Message-ID: <CAGdbjm+JVbszOKRmCtHWWFYpAs5495f9+ZuAxc8ZOkqVLPEScw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com, 
	kvm@vger.kernel.org, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 4:58=E2=80=AFPM Kevin Loughlin <kevinloughlin@googl=
e.com> wrote:
>
> On Wed, Jan 22, 2025 at 4:33=E2=80=AFPM Dave Hansen <dave.hansen@intel.co=
m> wrote:
> >
> > On 1/22/25 16:06, Kevin Loughlin wrote:
> > >> BTW, I don't think you should be compelled to use alternative() as
> > >> opposed to a good old:
> > >>
> > >>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
> > >>                 ...
> > > Agreed, though I'm leaving as alternative() for now (both because it
> > > results in fewer checks and because that's what is used in the rest o=
f
> > > the file); please holler if you prefer otherwise. If so, my slight
> > > preference in that case would be to update the whole file
> > > stylistically in a separate commit.
> >
> > alternative() can make a _lot_ of sense.  It's extremely compact in the
> > code it generates. It messes with compiler optimization, of course, jus=
t
> > like any assembly. But, overall, it's great.
> >
> > In this case, though, we don't care one bit about code generation or
> > performance. We're running the world's slowest instruction from an IPI.
> >
> > As for consistency, special_insns.h is gloriously inconsistent. But onl=
y
> > two instructions use alternatives, and they *need* the asm syntax
> > because they're passing registers and meaningful constraints in.
> >
> > The wbinvds don't get passed registers and their constraints are
> > trivial. This conditional:
> >
> >         alternative_io(".byte 0x3e; clflush %0",
> >                        ".byte 0x66; clflush %0",
> >                        X86_FEATURE_CLFLUSHOPT,
> >                        "+m" (*(volatile char __force *)__p));
> >
> > could be written like this:
> >
> >         if (cpu_feature_enabled(X86_FEATURE_CLFLUSHOPT))
> >                 asm volatile(".byte 0x3e; clflush %0",
> >                        "+m" (*(volatile char __force *)__p));
> >         else
> >                 asm volatile(".byte 0x66; clflush %0",
> >                        "+m" (*(volatile char __force *)__p));
> >
> > But that's _actively_ ugly.  alternative() syntax there makes sense.
> > Here, it's not ugly at all:
> >
> >         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
> >                 asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
> >         else
> >                 wbinvd();
> >
> > and it's actually more readable with alternative() syntax.
> >
> > So, please just do what makes the code look most readable. Performance
> > and consistency aren't important. I see absolutely nothing wrong with:
> >
> > static __always_inline void raw_wbnoinvd(void)
> > {
> >         asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
> > }
> >
> > void wbnoinvd(void)
> > {
> >         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
> >                 raw_wbnoinvd();
> >         else
> >                 wbinvd();
> > }
> >
> > ... except the fact that cpu_feature_enabled() kinda sucks and needs
> > some work, but that's a whole other can of worms we can leave closed to=
day.
>
> Thanks for the detailed explanation; you've convinced me. v6 coming up
> shortly (using native_wbnoinvd() instead of raw_wbnoinvd(), as you
> named the proposed wrapper in your reply to v5).

Actually, we may still want to use alternative() for the following reason:

Kirill noted in ad3fe525b950 ("x86/mm: Unify pgtable_l5_enabled usage
in early boot code") that cpu_feature_enabled() can't be used in early
boot code, which would mean using it would make the wbnoinvd()
implementation incompatible with early boot code if desired there. In
contrast, I believe alternative() will just fall back to WBINVD until
apply_alternatives() runs, at which point it will be replaced with
WBNOINVD if the processor supports it.

I'll still use the native_wbnoinvd() wrapper to clarify the encoding
as you suggested, but does this reasoning for keeping alternative()
make sense to you Dave? Or am I missing something?

