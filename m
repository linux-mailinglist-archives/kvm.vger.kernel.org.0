Return-Path: <kvm+bounces-66041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 31542CBFDCE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7F34230012CE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5F4328638;
	Mon, 15 Dec 2025 21:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDpM+k4Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235C92C11F1
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765832758; cv=none; b=GVi7axv70ZCHvaXCOAYCX80yaQJvFxsShH8qfYK31bUdpFziyfbjAbjT7eS7ogRYVyOKcX+C2mb2JPK+Pku5UbW5dhmH4abl9nJWKIx1K4rIg+Kfnt4TdFjJ0ZKzka5nFTC5K3gHT5ishWPsUBLDYiuTsfjLW1pHuCsZr/l6Lvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765832758; c=relaxed/simple;
	bh=3waFsTUEVw9m2bfdOuyKT5etmvKUDZo85avd9L97d0c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TF583D+g9GiRgsVpY45q/Q1UZYr+cp8uq5ec6FffP9wGr4M4vso5FDmU9Jv7jbdNGgx7O8a1ueEmoz2GCNH1vRRoBcczSM6FnvYEHFBD/OPmra/SVhzl6WIe/efxluKS4f58w54U+6lJeuvW7uej6PEIWAA7GjbM5mstQ9UQdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDpM+k4Y; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fbc305552so1989994f8f.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 13:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765832755; x=1766437555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/VQiJ6U2PoviaJ84b4oZbGSbqseMWdNEopASU4Cces=;
        b=MDpM+k4YZbmVpilSLoPanesnzv46LDfjw7qjH+R3mFqgACfrniBabJIqO7nxzxDfuL
         4OLcIJlwznYGViX6olB0Q+Vi6JXfnIW6NITJwyyQD8ZmUf1rksVe0INgpGHc0KEfHIvs
         BsQcPzfA8qx+OivzISkRKCuVILazYjKA6Uqw8GB41aw3osRBEsRdEiu+M92rD0nc8VLX
         3QyKGtftnAIx6r3+zRApK6fxue8+9gypSCaY1k27kT0YxMGLFgpHj2proent74mwFCI2
         SdtPE+fqPZFzjmhIFJZUvlRouwAE7l6Ejzu7GkU6vH4BpaQa90OmDvlpwe3Ld+5NHkQE
         nIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765832755; x=1766437555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k/VQiJ6U2PoviaJ84b4oZbGSbqseMWdNEopASU4Cces=;
        b=tTllRVepzR6LdcOgS/Jok0vHXrbKlUqmvQmCbo1vji9JlhroSkEVzL8pyO105nIHzX
         ZVF195SjYMg1CAqMAd1aWES8hzKOwT+1bIK3pdSlOYobAYFmWXBrnnJ7sTNzLWGYPuHi
         +6bsVaEiU8ODu8kWdBhewupVg7twzhmhNbfa/jmtOQDQGRCr9gSISAjX8o/40NH5G8eY
         65K9KcEoLnw6vBtB4f7fKvRUgdxnxRgI2QNl3VJaa7YxK9xAsyFMgkqAyrbQwtqwbPXB
         Q+8tLmz74xT2iRQlCsoMPqz+fWw+WlvYkBH0YTvYqIMDKjAZI0OsQNmb68ilI8PzjwyA
         DSpA==
X-Forwarded-Encrypted: i=1; AJvYcCWUXiLjfnZPm9WMwSFFIV9YFlouzXrtKAP2XyhblUQBabpai2xPaBWue6hlWo950tTpeoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNAvHJBHORS1mPMdRE5EkFOkJK+g4Jb5fAiDrCCgUxblhPQ8/5
	V9DMeuapTb25IuzYQPFGersgcHe/g8olkqNQRCSd7z34TX+DxlQgis3h
X-Gm-Gg: AY/fxX5oW1WyWlBGcKTo8HMSCbIffwmmfuSHKEhfqlX3VfD3dZBmmlUaefF2pqWi/Xk
	AvK4y19ygC0AIW29TefRtbhwGQhaka2nQL68c3T903EFwaSR8jUFM824bxwsGWR2yYDWTp0liuS
	pfMq+G635lcInMr0z6MNcTUmFwcTUaZlWak0vexK12vtxj6jwq7yN5pgXlAxQZ36ISritNnb5MQ
	/TAGuW3QW9gM1mTQm7+WvZbhsZKVJQ67q7P2QVnf0x+MCTlNjnu3sl8vo5V4i2iFD9lV9od6OM8
	AaPrx/PUTKZsqvlhj0Wy0PYBQwTHb5ViJwis+SryhM5dmeWcfXGH/0AkSp/+ZFGUd8Kv3u/lmvC
	KVnVhA+szaVM803vaLTgegQvEuf4CfCXQOouzXLEmvoEaQLK2JjajNxmbiJfgo2NjMdXl86BG7Q
	aT2C81EIW/Dbp6CurhuHOF/yej+/VejG3JnjkFEZ9qjsBHeg2ggSfXUq8cjZB9aMU=
X-Google-Smtp-Source: AGHT+IGbQSE2jechcjkJcIULXse77YsZC3S1gn46PwQPhkydxujDlM1wOE72uTLpNldTVJ86313oIw==
X-Received: by 2002:adf:ff90:0:b0:42f:a8d6:865b with SMTP id ffacd0b85a97d-42fb44ca939mr10582387f8f.24.1765832755177;
        Mon, 15 Dec 2025 13:05:55 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8a09fbesm31508262f8f.0.2025.12.15.13.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 13:05:54 -0800 (PST)
Date: Mon, 15 Dec 2025 21:05:53 +0000
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
Message-ID: <20251215210553.5ab5b674@pumpkin>
In-Reply-To: <20251215180136.sjtvt57autnrassg@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
	<20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
	<fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
	<20251210133542.3eff9c4a@pumpkin>
	<20251214183827.4z6nrrol4vz2tc5w@desk>
	<20251214190233.4b40fe20@pumpkin>
	<20251215180136.sjtvt57autnrassg@desk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Dec 2025 10:01:36 -0800
Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:

> On Sun, Dec 14, 2025 at 07:02:33PM +0000, David Laight wrote:
> > On Sun, 14 Dec 2025 10:38:27 -0800
> > Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> >  =20
> > > On Wed, Dec 10, 2025 at 01:35:42PM +0000, David Laight wrote: =20
> > > > On Wed, 10 Dec 2025 14:31:31 +0200
> > > > Nikolay Borisov <nik.borisov@suse.com> wrote:
> > > >    =20
> > > > > On 2.12.25 =D0=B3. 8:19 =D1=87., Pawan Gupta wrote:   =20
> > > > > > As a mitigation for BHI, clear_bhb_loop() executes branches tha=
t overwrites
> > > > > > the Branch History Buffer (BHB). On Alder Lake and newer parts =
this
> > > > > > sequence is not sufficient because it doesn't clear enough entr=
ies. This
> > > > > > was not an issue because these CPUs have a hardware control (BH=
I_DIS_S)
> > > > > > that mitigates BHI in kernel.
> > > > > >=20
> > > > > > BHI variant of VMSCAPE requires isolating branch history betwee=
n guests and
> > > > > > userspace. Note that there is no equivalent hardware control fo=
r userspace.
> > > > > > To effectively isolate branch history on newer CPUs, clear_bhb_=
loop()
> > > > > > should execute sufficient number of branches to clear a larger =
BHB.
> > > > > >=20
> > > > > > Dynamically set the loop count of clear_bhb_loop() such that it=
 is
> > > > > > effective on newer CPUs too. Use the hardware control enumerati=
on
> > > > > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > > > > >=20
> > > > > > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > > > > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com> =
    =20
> > > > >=20
> > > > > nit: My RB tag is incorrect, while I did agree with Dave's sugges=
tion to=20
> > > > > have global variables for the loop counts I haven't' really seen =
the=20
> > > > > code so I couldn't have given my RB on something which I haven't =
seen=20
> > > > > but did agree with in principle.   =20
> > > >=20
> > > > I thought the plan was to use global variables rather than ALTERNAT=
IVE.
> > > > The performance of this code is dominated by the loop.   =20
> > >=20
> > > Using globals was much more involved, requiring changes in atleast 3 =
files.
> > > The current ALTERNATIVE approach is much simpler and avoids additional
> > > handling to make sure that globals are set correctly for all mitigati=
on
> > > modes of BHI and VMSCAPE.
> > >=20
> > > [ BTW, I am travelling on a vacation and will be intermittently check=
ing my
> > >   emails. ]
> > >  =20
> > > > I also found this code in arch/x86/net/bpf_jit_comp.c:
> > > > 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
> > > > 		/* The clearing sequence clobbers eax and ecx. */
> > > > 		EMIT1(0x50); /* push rax */
> > > > 		EMIT1(0x51); /* push rcx */
> > > > 		ip +=3D 2;
> > > >=20
> > > > 		func =3D (u8 *)clear_bhb_loop;
> > > > 		ip +=3D x86_call_depth_emit_accounting(&prog, func, ip);
> > > >=20
> > > > 		if (emit_call(&prog, func, ip))
> > > > 			return -EINVAL;
> > > > 		EMIT1(0x59); /* pop rcx */
> > > > 		EMIT1(0x58); /* pop rax */
> > > > 	}
> > > > which appears to assume that only rax and rcx are changed.
> > > > Since all the counts are small, there is nothing stopping the code
> > > > using the 8-bit registers %al, %ah, %cl and %ch.   =20
> > >=20
> > > Thanks for catching this. =20
> >=20
> > I was trying to find where it was called from.
> > Failed to find the one on system call entry... =20
>=20
> The macro CLEAR_BRANCH_HISTORY calls clear_bhb_loop() at system call entr=
y.

I didn't look very hard :-)

>=20
> > > > There are probably some schemes that only need one register.
> > > > eg two separate ALTERNATIVE blocks.   =20
> > >=20
> > > Also, I think it is better to use a callee-saved register like rbx to=
 avoid
> > > callers having to save/restore registers. Something like below: =20
> >=20
> > I'm not sure.
> > %ax is the return value so can be 'trashed' by a normal function call.
> > But if the bpf code is saving %ax then it isn't expecting a normal call=
. =20
>=20
> BHB clear sequence is executed at the end of the BPF JITted code, and %rax
> is likely the return value of the BPF program. So, saving/restoring %rax
> around the sequence makes sense to me.
>=20
> > OTOH if you are going to save the register in clear_bhb_loop you might
> > as well use %ax to get the slightly shorter instructions for %al.
> > (I think 'movb' comes out shorter - as if it really matters.) =20
>=20
> %rbx is a callee-saved register so it felt more intuitive to save/restore
> it in clear_bhb_loop(). But, I can use %ax if you feel strongly.

If you are going to save a register it might as well be %ax.
Otherwise someone will wonder why you picked a different one.

>=20
> > Definitely worth a comment that it must save all resisters. =20
>=20
> Yes, will add a comment.
>=20
> > I also wonder if it needs to setup a stack frame? =20
>=20
> I don't know if thats necessary, objtool doesn't complain because
> clear_bhb_loop() is marked STACK_FRAME_NON_STANDARD.

In some senses it is a leaf functions - and the compiler doesn't create
stack frames for those (by default).

Provided objtool isn't confused by all the call instructions it probably
doesn't matter.

	David

>=20
> > Again, the code is so slow it won't matter.
> >=20
> > 	David =20


