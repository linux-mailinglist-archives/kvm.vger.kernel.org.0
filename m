Return-Path: <kvm+bounces-65654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B06C8CB30A2
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 14:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FCE430249E3
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 13:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C29325721;
	Wed, 10 Dec 2025 13:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUazbg9k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12051A2C11
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 13:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765373750; cv=none; b=YH98cEdBIrq8O2Wcj287uD8CLMiJrIkXMQndtqdlzmhad5dJFl2Z0APU5r1GoTJCXv5yIUvM27HXuyIZTuBcNvozO4TT0uzEZQ+GAAb4gc1Jevc+oO3Nmq84NTFyMpjOrS6nO1bh2y1YXKRYlA8692QlzPeAigQMg+PiAhcC4Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765373750; c=relaxed/simple;
	bh=3chFlfQNlFVWJVzvKQFrukX2qjONzgGT1iGcZ9uBVvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9K3rPd/6wRVemgpSUR29xqAbnmM/NjIVyoJuM+XWQ4W4lDKgC9J9V0E/e7oV6AhCyjI/olCvJ4aWTSQERb0rHLItfnmdh2HqhXwqxS6/rSDLyE/M/tFylsgbBFUZIvgKChX/zPFFUqZ8Y2dKK/MAJy9l2HvvqhADK1dq7iEOYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUazbg9k; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42e2d52c24dso3759770f8f.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 05:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765373747; x=1765978547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKYmbGekRU7SahKpUvVjmpNohsVSYMad5CjFU6n5IO8=;
        b=NUazbg9kIm7f7c02kzFOim5bT9FqU4aMhsUt8K/VHZtNtPoYskrgcN5xctV+91FsNP
         4sq0oaKH6U9gq+CLdL9BaR0FcK6gz8zJY2+WJWKW6yiJqXnXGAXwgdMVVWtyW6r65coD
         lh7gUqele1gPo02XAAskM3o7OcG23CpON+81blt00F037g3g3yMZGefGTxd+rnbOpjGn
         F5SpSGbeYbuNDChXCpvQjuUT5IJBD8y4sf1ZhCxJ8ORH0fJk7uFaskH39auICHs5+sIR
         Bvp+GriVVWo0OniGchl9XTdW90otD47GoKG1OLYI4j8792WgqU/GKt6vnEzmFZdkzW9i
         lMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765373747; x=1765978547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PKYmbGekRU7SahKpUvVjmpNohsVSYMad5CjFU6n5IO8=;
        b=QD399yBYLPnW17xkDJVG31eHZL/MorKwD1uRS/I7reAIOW+cUmtEEE4AVt6cVg3541
         9EDSVs+72KgQmEytJ1quHPbgdOa5slJUZhDMr1sSz1p9PPDCMKkckpbrs78IL0qFRsVB
         Bjd2jf9/0QzUSfQQiqr4tg/Qd1m2ortIpyXFgx5bOYYNfn4ldjJngaD2kGyPw430dKm0
         HVRsM4yjmkql5kxSLUju+HKDKfU8FzBUbarbdG6dHpcvo/U0jXG2XZHMu6XW0yzgGKCw
         CKaqgf/NDDbwxAbw5PANkg0oSHY3gFT1pqTW8dA3TTEjbq+feBF99Yom25ns2Ks/OcD0
         xCJA==
X-Forwarded-Encrypted: i=1; AJvYcCUNYNE0yDnsZcDVNYyRWIJGbppJA/S6oRhG19Tm8b+7B7GgkEa8rc0YF3oy1IxkA9/aWao=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbXGNpNeockV8DVhuJe6zLapvlwQ5JnNFxN02Q1ZtA1j0EX5Dl
	Pxz9i0UGeFkXPCJRkp63Z36JEQvEQuU+7yp9QHh0AS+Do0y8wLUFcEaO
X-Gm-Gg: AY/fxX6UqGDL4PmPdkk/lDkfe20ooK04puEV9R5bGSIETmbfD8RiUqfBYsoZOaIaXds
	9wehBaMR/9LWemHBKHPHUqrzF5aIfepNDzAkPJcChpoYk+m3w9ZTno95tQt7Uhgbm/kQQwZIK8k
	0ZJ8r9FY2y+H7MTekKSZvF4CdaENVBeUSs1kETa4ehfAWQHYUMJi2HoBPVWdzFyAiYHE7fELf0p
	ldblJ252nm8c5Zb+eVj8pdcBmuUTBbatAjTms8iX64aiUS6qxdXov0uMWjglxYaBSo/m56VMw+o
	PYLxtbWmSkNqXW/taWgZ50PcCu3xHcuVJ5/GaWOv/RqLmheySX6XtWuv9W4MCOqs1xVjgAIjYzy
	iW0mpsU0EP6drLpLb20v1mLGYiwxMd41liAZIrWVegxOcpY8E/rDWoBjN1Tq3WLxef4u7Bh5Ibx
	CR7s+Oz2qT+oR2rxAhPVeN3ZbI1BWs5kCrZ134f1r1GqO6dqZw//HJvvsK6xxWF58=
X-Google-Smtp-Source: AGHT+IGP8JOu+iHpy+jYNohvNXcy9hmvnhBozoIdgH/0JkW29rY2bNmSzznfuZlJXLOyf7fvKKK4EQ==
X-Received: by 2002:a05:6000:400d:b0:42f:9f18:8f40 with SMTP id ffacd0b85a97d-42fa3b17789mr2940334f8f.42.1765373746957;
        Wed, 10 Dec 2025 05:35:46 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9065sm37426274f8f.8.2025.12.10.05.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 05:35:46 -0800 (PST)
Date: Wed, 10 Dec 2025 13:35:42 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, David
 Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang
 <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251210133542.3eff9c4a@pumpkin>
In-Reply-To: <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
	<20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
	<fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Dec 2025 14:31:31 +0200
Nikolay Borisov <nik.borisov@suse.com> wrote:

> On 2.12.25 =D0=B3. 8:19 =D1=87., Pawan Gupta wrote:
> > As a mitigation for BHI, clear_bhb_loop() executes branches that overwr=
ites
> > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > sequence is not sufficient because it doesn't clear enough entries. This
> > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > that mitigates BHI in kernel.
> >=20
> > BHI variant of VMSCAPE requires isolating branch history between guests=
 and
> > userspace. Note that there is no equivalent hardware control for usersp=
ace.
> > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > should execute sufficient number of branches to clear a larger BHB.
> >=20
> > Dynamically set the loop count of clear_bhb_loop() such that it is
> > effective on newer CPUs too. Use the hardware control enumeration
> > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> >=20
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com> =20
>=20
> nit: My RB tag is incorrect, while I did agree with Dave's suggestion to=
=20
> have global variables for the loop counts I haven't' really seen the=20
> code so I couldn't have given my RB on something which I haven't seen=20
> but did agree with in principle.

I thought the plan was to use global variables rather than ALTERNATIVE.
The performance of this code is dominated by the loop.

I also found this code in arch/x86/net/bpf_jit_comp.c:
	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
		/* The clearing sequence clobbers eax and ecx. */
		EMIT1(0x50); /* push rax */
		EMIT1(0x51); /* push rcx */
		ip +=3D 2;

		func =3D (u8 *)clear_bhb_loop;
		ip +=3D x86_call_depth_emit_accounting(&prog, func, ip);

		if (emit_call(&prog, func, ip))
			return -EINVAL;
		EMIT1(0x59); /* pop rcx */
		EMIT1(0x58); /* pop rax */
	}
which appears to assume that only rax and rcx are changed.
Since all the counts are small, there is nothing stopping the code
using the 8-bit registers %al, %ah, %cl and %ch.

There are probably some schemes that only need one register.
eg two separate ALTERNATIVE blocks.

	David

>=20
> Now that I have seen the code I'm willing to give my :
>=20
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > ---
> >   arch/x86/entry/entry_64.S | 8 ++++++--
> >   1 file changed, 6 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b=
11e25e2fbcc77489d 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
> >   	ANNOTATE_NOENDBR
> >   	push	%rbp
> >   	mov	%rsp, %rbp
> > -	movl	$5, %ecx
> > +
> > +	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> > +	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> > +		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL =20
>=20
> nit: Just
>=20
> > +
> >   	ANNOTATE_INTRA_FUNCTION_CALL
> >   	call	1f
> >   	jmp	5f
> > @@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
> >   	 * but some Clang versions (e.g. 18) don't like this.
> >   	 */
> >   	.skip 32 - 18, 0xcc
> > -2:	movl	$5, %eax
> > +2:	movl	%edx, %eax
> >   3:	jmp	4f
> >   	nop
> >   4:	sub	$1, %eax
> >  =20
>=20
>=20


