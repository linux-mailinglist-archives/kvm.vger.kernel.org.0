Return-Path: <kvm+bounces-65951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C28CBBF11
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 20:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E781300A86C
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 19:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99BB2DEA8C;
	Sun, 14 Dec 2025 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAJiw8Nv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E08217A305
	for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 19:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765738959; cv=none; b=V03YjAdQPSvxAvHqTzbH8hW3bbcbzhbT0tUi2W3ZcnKt5rsfwFVftBxW/Hsf/VIEpmocAe7GGjPcNKVNHIhjjY7EqB+UFwjRvSHj3wS32J8Ge6mFK7K5gDFi3+19CFQK2FofMYCAVX1c8MWeDhf47VUyQTPulQsa7Mdvpv/9Tdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765738959; c=relaxed/simple;
	bh=bepsvLADxHGtCz1ZC6nFSmEP2kyY3PknJTUC+IX7fm8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sgpdtozYPoe75nBNpP39AMX7G7Wj2YSNe7RXDsCGD0wHEwf5vLXcDBHI3GlSlQouxFz0/WxKp2GCdhZNWh+IzeLdlBuTIKsDIf7Kjju41QQ07xjg14ALQYanVSmwlvg9M1/pb99BVXJTznNS5XM+AasXs6paZ2MkaXwyd+okmxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAJiw8Nv; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so1912772f8f.1
        for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 11:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765738956; x=1766343756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1+QfGmdSwm13QkqQtjtji5o0t2jNZnKAPzHVq0CaKk=;
        b=QAJiw8NvW3ADPjXaxkMiZ4SVCgQfisn7byi1coHUWXaoWZw+FzrONRuaoJBZip0xFA
         BS+3crcWzUsXBMkoaou6aqclrvdjbQ5Hczpd0B92ea95vNUBqsuSPRCi7ljWerycXnGs
         +MwuSh0E3XKKD9aXtpDrrPFmaS5SYuQZA+hN5pGClCkqYEWPKL6PZiMFtcGj+ppJeHVB
         V6xfXMHg2a5YarqTvck6TRcIlyvszMf6wS0/sHZQ6pjZjhjFFVftnV0iMaFnOiPPfNSD
         cb6Wp883vd1nrO/2c9lsCiQrk/mqLJUUZAs8C8/WK2wGYOrjlBIru7TRh9wVleDx57vS
         1Rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765738956; x=1766343756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1+QfGmdSwm13QkqQtjtji5o0t2jNZnKAPzHVq0CaKk=;
        b=N9flCCs3DUOVBi76fa/ZXKcYcTX5GrSfGzGx5rB9PwbgQh3AxFhqzLbIChBTX6LRhf
         E98PXVN9D7pHZmTb1uA1E++bL0XPu6qMj4jStSeBd6sr6BHXeU+VWlLgu/n4LEkjpLkF
         gP9KQaoJ8urD0PzKjJiL10ZqKm2n/wM7GNd4gSdTQu4LD7Xw8CWP3vOOSngmJSU3c509
         gw3O8uRTUOsajW/pgmWFxhO/gSOqhDZeSHVIpK5gYAuy0OBF8RZ1JhhDlYSHpRDFHAWD
         0fgHMsVfqXT3HUugFZNHYy35dX3Pz6qO/pi6Lq0ywyPTfVD9iuiEBdFIKlJq5P68G2al
         uEWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZS01PNEBzCc1PvHlONXBmIwK1Y/GMYsGqQ/qBtrCF//l7YHUahKvRB5+iKV0Ml/d/Y5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YymmStkugWDZMrwhL0VHxtFZ61MorIvl59sY3sPqgq96qD+upQT
	hPJD4+LtsSuhdMkvr5kDwkcZm3EYzgpNh/T8AuDZBDKqhd/eKa/IegnA
X-Gm-Gg: AY/fxX4xFRCQEvPyZ54K/vYmX0soovcWQw1bZstyeNJOhjH4qTceFAB0Umep4KOqwxQ
	QFffQMyH6nxQJOHiaMxasmGLHQN2Cw2ly2GcMP7/pd8V2dXbONRx1xNyfOIURtE/5/nE+F3PwhT
	p88kxNJtvzQq7K7Cbd4I87YcAfPyTRsIkHELkv3Em/nea70UAx2XTN8cSnN2blTLpnXRsE8fMZD
	yjURMj6pZremkwWL7X1EFaMHQZpBhUI1Wt88yHEluNFtoNHYna7DG4ixfJivgJMua7WG8aJ+C6S
	3RQxMbmM5RIYcCy567g+EvtAQrl9EgNfCCwTYwjyI1PDommXQENOLQ04v2ymc6ewpX2oO+E9Cqq
	J2AqV75pBsD5wCTSn7mGWDlyK5z9AjWhbXl6jRCG+F3Uu8mqBYwJA0vW+jrzxMSuP82PVK66QPp
	CGkIouLsNQfJXVWwtnT9H6rLJSRVXUNIJWUT7RZN3Gu53hjM7eu5wV
X-Google-Smtp-Source: AGHT+IFlS7jR+bhVF9MvcK4UJikc4zOezLf06rBPcECsBeB4Eo/ik8yDduWEQR6GUdOzJN6pRBkxhg==
X-Received: by 2002:a05:6000:611:b0:42f:7616:6c7c with SMTP id ffacd0b85a97d-42fb44e3cbbmr8216386f8f.14.1765738955385;
        Sun, 14 Dec 2025 11:02:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43009dfe5b3sm12367863f8f.39.2025.12.14.11.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 11:02:35 -0800 (PST)
Date: Sun, 14 Dec 2025 19:02:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org, David Kaplan
 <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang
 <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251214190233.4b40fe20@pumpkin>
In-Reply-To: <20251214183827.4z6nrrol4vz2tc5w@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
	<20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
	<fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
	<20251210133542.3eff9c4a@pumpkin>
	<20251214183827.4z6nrrol4vz2tc5w@desk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Dec 2025 10:38:27 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Wed, Dec 10, 2025 at 01:35:42PM +0000, David Laight wrote:
> > On Wed, 10 Dec 2025 14:31:31 +0200
> > Nikolay Borisov <nik.borisov@suse.com> wrote:
> >  =20
> > > On 2.12.25 =D0=B3. 8:19 =D1=87., Pawan Gupta wrote: =20
> > > > As a mitigation for BHI, clear_bhb_loop() executes branches that ov=
erwrites
> > > > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > > > sequence is not sufficient because it doesn't clear enough entries.=
 This
> > > > was not an issue because these CPUs have a hardware control (BHI_DI=
S_S)
> > > > that mitigates BHI in kernel.
> > > >=20
> > > > BHI variant of VMSCAPE requires isolating branch history between gu=
ests and
> > > > userspace. Note that there is no equivalent hardware control for us=
erspace.
> > > > To effectively isolate branch history on newer CPUs, clear_bhb_loop=
()
> > > > should execute sufficient number of branches to clear a larger BHB.
> > > >=20
> > > > Dynamically set the loop count of clear_bhb_loop() such that it is
> > > > effective on newer CPUs too. Use the hardware control enumeration
> > > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > > >=20
> > > > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>   =20
> > >=20
> > > nit: My RB tag is incorrect, while I did agree with Dave's suggestion=
 to=20
> > > have global variables for the loop counts I haven't' really seen the=
=20
> > > code so I couldn't have given my RB on something which I haven't seen=
=20
> > > but did agree with in principle. =20
> >=20
> > I thought the plan was to use global variables rather than ALTERNATIVE.
> > The performance of this code is dominated by the loop. =20
>=20
> Using globals was much more involved, requiring changes in atleast 3 file=
s.
> The current ALTERNATIVE approach is much simpler and avoids additional
> handling to make sure that globals are set correctly for all mitigation
> modes of BHI and VMSCAPE.
>=20
> [ BTW, I am travelling on a vacation and will be intermittently checking =
my
>   emails. ]
>=20
> > I also found this code in arch/x86/net/bpf_jit_comp.c:
> > 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
> > 		/* The clearing sequence clobbers eax and ecx. */
> > 		EMIT1(0x50); /* push rax */
> > 		EMIT1(0x51); /* push rcx */
> > 		ip +=3D 2;
> >=20
> > 		func =3D (u8 *)clear_bhb_loop;
> > 		ip +=3D x86_call_depth_emit_accounting(&prog, func, ip);
> >=20
> > 		if (emit_call(&prog, func, ip))
> > 			return -EINVAL;
> > 		EMIT1(0x59); /* pop rcx */
> > 		EMIT1(0x58); /* pop rax */
> > 	}
> > which appears to assume that only rax and rcx are changed.
> > Since all the counts are small, there is nothing stopping the code
> > using the 8-bit registers %al, %ah, %cl and %ch. =20
>=20
> Thanks for catching this.

I was trying to find where it was called from.
Failed to find the one on system call entry...

> > There are probably some schemes that only need one register.
> > eg two separate ALTERNATIVE blocks. =20
>=20
> Also, I think it is better to use a callee-saved register like rbx to avo=
id
> callers having to save/restore registers. Something like below:

I'm not sure.
%ax is the return value so can be 'trashed' by a normal function call.
But if the bpf code is saving %ax then it isn't expecting a normal call.
OTOH if you are going to save the register in clear_bhb_loop you might
as well use %ax to get the slightly shorter instructions for %al.
(I think 'movb' comes out shorter - as if it really matters.)

Definitely worth a comment that it must save all resisters.

I also wonder if it needs to setup a stack frame?
Again, the code is so slow it won't matter.

	David


>=20
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 9f6f4a7c5baf..ca4a34ce314a 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1535,11 +1535,12 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>  SYM_FUNC_START(clear_bhb_loop)
>  	ANNOTATE_NOENDBR
>  	push	%rbp
> +	push	%rbx
>  	mov	%rsp, %rbp
> =20
>  	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> -	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> -		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL
> +	ALTERNATIVE "movb $5,  %bl",	\
> +		    "movb $12, %bl", X86_FEATURE_BHI_CTRL
> =20
>  	ANNOTATE_INTRA_FUNCTION_CALL
>  	call	1f
> @@ -1561,15 +1562,17 @@ SYM_FUNC_START(clear_bhb_loop)
>  	 * but some Clang versions (e.g. 18) don't like this.
>  	 */
>  	.skip 32 - 18, 0xcc
> -2:	movl	%edx, %eax
> +2:	ALTERNATIVE "movb $5, %bh",	\
> +		    "movb $7, %bh", X86_FEATURE_BHI_CTRL
>  3:	jmp	4f
>  	nop
> -4:	sub	$1, %eax
> +4:	sub	$1, %bh
>  	jnz	3b
> -	sub	$1, %ecx
> +	sub	$1, %bl
>  	jnz	1b
>  .Lret2:	RET
>  5:
> +	pop	%rbx
>  	pop	%rbp
>  	RET
>  SYM_FUNC_END(clear_bhb_loop)
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index c1ec14c55911..823b3f613774 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1593,11 +1593,6 @@ static int emit_spectre_bhb_barrier(u8 **pprog, u8=
 *ip,
>  	u8 *func;
> =20
>  	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
> -		/* The clearing sequence clobbers eax and ecx. */
> -		EMIT1(0x50); /* push rax */
> -		EMIT1(0x51); /* push rcx */
> -		ip +=3D 2;
> -
>  		func =3D (u8 *)clear_bhb_loop;
>  		ip +=3D x86_call_depth_emit_accounting(&prog, func, ip);
> =20
> @@ -1605,8 +1600,6 @@ static int emit_spectre_bhb_barrier(u8 **pprog, u8 =
*ip,
>  			return -EINVAL;
>  		/* Don't speculate past this until BHB is cleared */
>  		EMIT_LFENCE();
> -		EMIT1(0x59); /* pop rcx */
> -		EMIT1(0x58); /* pop rax */
>  	}
>  	/* Insert IBHF instruction */
>  	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&


