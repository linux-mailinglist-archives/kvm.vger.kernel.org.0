Return-Path: <kvm+bounces-8914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C5C8858835
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 22:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E801BB240B4
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 21:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916E914691C;
	Fri, 16 Feb 2024 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cYi8K41L"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A819E12CDBC;
	Fri, 16 Feb 2024 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708120001; cv=none; b=oTZAvfks/Jir8xsr77mdEwluh4tkGpgtUqcTRTESA+CP1xm/nIBiWQvWWVNm4Jwri8WsxHzba+ie2G70XClBQEi1p9XgO7ChrA8ErZ6BMT8uCYdT/da5a03IegpkND4rk2oGbCdFMjDhzAPts+kOdjKW39TFdO3TI8GTG3VVryI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708120001; c=relaxed/simple;
	bh=GBzUaQTzQIXEH3jwfRFQFMZy7ku57c714xxsPdAdDks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGDG6Jfp4dRhTdKwILgk5VsWvuv5BRz6Fh4yQObUy1Xgt09iNDS0gb+W6sQePmr7Vy8m4I3wkpoY6OaKlpC5NNmCiFC5zJ0WVaM9RzOnS4SXfGgsFvBCwOv9Hz9Zj09NHvEUrDF1QQHacqznn8h6tKAAtRw1mVtVMjqF8rhlq8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cYi8K41L reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 617F340E00B2;
	Fri, 16 Feb 2024 21:46:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cpescH5LrsrR; Fri, 16 Feb 2024 21:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1708119993; bh=DMZt+yXqUGedwpCJ2zmwPDYvJ2VbTlzxw7/c4wws5E0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYi8K41Ly2JMpJv2SfCy29Fg1W2su34spl64iCzzqTnxb+4UICFx+ojVY6R7Iv8xX
	 9n9zOuZNpGfji9+IuZcZRkMCeTQv/g9ICUxxuCv1MbfXyd2ROjQym9MwefnZQdlrbD
	 d1hap9xFbXYR+/xpD+h5hjS4NlKpXm/oUO4jysId+j9F52xRYq2moAXDH2INwHH1c6
	 KZQfR7hHBi7YF81b81vs0W40k+JhyBwKpFltGaNK8TAoJ35sV8JBQzaW/xHqeo1hsO
	 Dwnj/o/W/Zh5PRn1Ce4T8TP7gg3p90XgWRz5gzztFq1J1AeqBc5kCkxY6bQilt2Obg
	 7kQw/yxcSgLTgg0gQJ2PdEEVGOGxw2Jeh1aeRIDu9E105117EWeFgeITh3+j4thFly
	 qCcOXz3q3FTQzSghhqv9dP6bUkDGhDsepFd4XCOIS0e7zOFXhBGDH1V40p6bD5ziT8
	 98Do8ZlQHL0Y+GgSOUcx3F7xhjr+eJo1DGr1RxkpdOgUuboae9UXsszPBlAlhshd4d
	 BWV0O1nZ9ybdFZkfwtG+6Fv4dieRMFw5vNfLLS7S7ZeMzEYqbA6ygbzjaC1rpXGz74
	 lSYzIb2qgHqikEDfdfFks39FpgLXAwaQUW8kx2435GBzak9TPTSKYp2QzmgaDtRMh0
	 FBUSgTczgtCshqCRj7qBDEP0=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E2D5940E0192;
	Fri, 16 Feb 2024 21:46:22 +0000 (UTC)
Date: Fri, 16 Feb 2024 22:46:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>,
	Max Kellermann <max.kellermann@ionos.com>, hpa@zytor.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
Message-ID: <20240216214617.GBZc_XqVtMuY9_eWWG@fat_crate.local>
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
Content-Transfer-Encoding: quoted-printable

+ Arnd for

https://lore.kernel.org/r/20240216202527.2493264-1-arnd@kernel.org

On Fri, Feb 16, 2024 at 07:31:46AM +0100, Paolo Bonzini wrote:
> On 2/16/24 03:10, Xin Li wrote:
> > On 2/15/2024 11:55 AM, Sean Christopherson wrote:
> > > +Paolo and Stephen
> > >=20
> > > FYI, there's a build failure in -next due to a collision between
> > > kvm/next and
> > > tip/x86/fred.=C2=A0 The above makes everything happy.
> > >=20
> > > On Thu, Feb 15, 2024, Max Kellermann wrote:
> > > > When KVM is disabled, the POSTED_INTR_* macros do not exist, and =
the
> > > > build fails.
> > > >=20
> > > > Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code=
")
> > > > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > > > ---
> > > > =C2=A0 arch/x86/entry/entry_fred.c | 2 ++
> > > > =C2=A0 1 file changed, 2 insertions(+)
> > > >=20
> > > > diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_f=
red.c
> > > > index ac120cbdaaf2..660b7f7f9a79 100644
> > > > --- a/arch/x86/entry/entry_fred.c
> > > > +++ b/arch/x86/entry/entry_fred.c
> > > > @@ -114,9 +114,11 @@ static idtentry_t
> > > > sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init =3D {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SYSVEC(IRQ_WORK_VECTOR,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 irq_work),
> > > > +#if IS_ENABLED(CONFIG_KVM)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SYSVEC(POSTED_INTR_VECTOR,=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_posted_intr_ipi),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SYSVEC(POSTED_INTR_WAKEUP_VECTOR,=C2=
=A0=C2=A0=C2=A0 kvm_posted_intr_wakeup_ipi),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SYSVEC(POSTED_INTR_NESTED_VECTOR,=C2=
=A0=C2=A0=C2=A0 kvm_posted_intr_nested_ipi),
> > > > +#endif
> > > > =C2=A0 };
> > > > =C2=A0 static bool fred_setup_done __initdata;
> > > > --=20
> > > > 2.39.2
> >=20
> > We want to minimize #ifdeffery (which is why we didn't add any to
> > sysvec_table[]), would it be better to simply remove "#if
> > IS_ENABLED(CONFIG_KVM)" around the the POSTED_INTR_* macros from the
> > Linux-next tree?
> >=20
> > BTW, kvm_posted_intr_*() are defined to NULL if !IS_ENABLED(CONFIG_KV=
M).
>=20
> It is intentional that KVM-related things are compiled out completely
> if !IS_ENABLED(CONFIG_KVM), because then it's also not necessary to hav=
e
>=20
> # define fred_sysvec_kvm_posted_intr_ipi                NULL
> # define fred_sysvec_kvm_posted_intr_wakeup_ipi         NULL
> # define fred_sysvec_kvm_posted_intr_nested_ipi         NULL
>=20
> in arch/x86/include/asm/idtentry.h. The full conflict resultion is
>=20
> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
> index ac120cbdaaf2..660b7f7f9a79 100644
> --- a/arch/x86/entry/entry_fred.c
> +++ b/arch/x86/entry/entry_fred.c
> @@ -114,9 +114,11 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] =
__ro_after_init =3D {
>      SYSVEC(IRQ_WORK_VECTOR,            irq_work),
> +#if IS_ENABLED(CONFIG_KVM)
>      SYSVEC(POSTED_INTR_VECTOR,        kvm_posted_intr_ipi),
>      SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    kvm_posted_intr_wakeup_ipi),
>      SYSVEC(POSTED_INTR_NESTED_VECTOR,    kvm_posted_intr_nested_ipi),
> +#endif
>  };
>  static bool fred_setup_done __initdata;
> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idt=
entry.h
> index 749c7411d2f1..758f6a2838a8 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -745,10 +745,6 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,        sy=
svec_irq_work);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,        sysvec_kvm_posted_i=
ntr_ipi);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    sysvec_kvm_poste=
d_intr_wakeup_ipi);
>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,    sysvec_kvm_poste=
d_intr_nested_ipi);
> -#else
> -# define fred_sysvec_kvm_posted_intr_ipi        NULL
> -# define fred_sysvec_kvm_posted_intr_wakeup_ipi        NULL
> -# define fred_sysvec_kvm_posted_intr_nested_ipi        NULL
>  #endif
>  #if IS_ENABLED(CONFIG_HYPERV)
>=20
> and it seems to be a net improvement to me.  The #ifs match in
> the .h and .c files, and there are no unnecessary initializers
> in the sysvec_table.

Ok, I'll pick up Max' patch tomorrow and we must remember to tell Linus
during the merge window about this.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

