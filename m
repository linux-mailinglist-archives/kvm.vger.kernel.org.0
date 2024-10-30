Return-Path: <kvm+bounces-30104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BD99B6D47
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A703FB21134
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237FA1D1730;
	Wed, 30 Oct 2024 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bjohu4Rz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67AA1CFEB0
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 20:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730318948; cv=none; b=HlLTWtGgHxsHIWtSaH+hFdKLH6cuhJgaNTUt0Sqt+HSGJBpHVFG6uhSnVKT3ev+31dJeKIgXLMN7gDC97IDTEKteSPEg4Fbg6w7dLL65z00B6+ocvyGX3is01bDmJm8vAXVxvXxPuGtykP2K7PMLMgYuabte5xX2p2Ysw1O56ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730318948; c=relaxed/simple;
	bh=2wMIjMJ9U3vIM+8QqfNF8Rkv4RTWgD3KpGp1QHT7ZD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mhFl/+cawuVEshaMUmQwjcEeyMViHj/o27TIuSqeic8XVWpEPtr2wMMsgWCdnoep1bGP81aY3WKDzf9lfRnHNYrl7/KMwVhVm9zxeyQeEEVTdPg/URKKiAUzgX7PBG8F1dExaRn2ScDRf5McNeaEwclCaR2rWeRCBv7KiG2IKFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bjohu4Rz; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6e33c65d104so1443777b3.3
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 13:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730318945; x=1730923745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngwfEIYbdyLNTkAD5QHGkC0QUp0XJJcJX0AQ5QRONt0=;
        b=Bjohu4Rza8oI+U2SYOicAlVpOOxaA6u/+Y6+u2VikBqKfA/ThD11cmRLPoZU2AoNG/
         omnuYBN1kHBOy76lVdpwt2T6iepTo9yZCsLQ9d/pVfgI/0ZNXuS5kTXghS6lMo5AA3UM
         7dbU7cz63zMwWp1ji9i4b+vGMC3sdU9eYGGT3Ic2t8+reWhsfBu8e35EsY5wEJMHiu9+
         B6c5R4qqRRzdHwkBwUnIDCExaRSiUzoQ3MyFFveu6Q1/GW0myEEgD6PcPWLYUiMSvzI4
         1VTfKBNsTkOmM4IYOx3wqVyorzY20eAwylZb5CJWkQPC7pK9VHP2rMM/z+HFRtwmzlrD
         Zg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730318945; x=1730923745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngwfEIYbdyLNTkAD5QHGkC0QUp0XJJcJX0AQ5QRONt0=;
        b=V99GGvhKMPJrOAJsvoinUvukWIhB4/cMy7MSdPPuC0sxfhPZm09/7ONfGtzGYMiw9I
         K1s7bDzGR5qC/lR2hU5H16HDjZ3o4FvycFwcIUi7XFRoJShaJABFMtkx28p6/Vp4Wvmk
         UOFq+7z7dlQwtX+LvWKkpWlJDBLCAo6zc5a8BS3GXlNtcUPIYvIvfW8sEQDGAGJh6Tqb
         1A9F/XPWE8YXSqtn2t9Du5GUfBNXt6F0P2ItyKsmWABC8zBRUZB6boE4lgK1FiY5cBZA
         khmsRXa5N+hYg1uw6bx1mpdaQ6N0TwkVbV79gyx56GYvnxgtQrxxs2raZYfTGGG27+5B
         zbSw==
X-Forwarded-Encrypted: i=1; AJvYcCXG3cjpE6mFZ/VfQlDCr3hk2BbfARJ60sSDRwUafjGim/rtO3aC3l123SrmvdPFRpKR/iY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgpI8fISQ21lJoBJhUoJ7BxWRKM2FPvc7LNRkRb5qhvUDiSFDW
	rYP30Qkxfus+1CpwWS2RnWZBiU2mS/AjatI1mzH/kt97hau2XW7yJDW5GhuuSbxZ0Pv+vUdSl6U
	pu7Scj+qj5HBOwa+cQMwOJPekipXB/f7QG+rp
X-Google-Smtp-Source: AGHT+IEASnFEOXc7vIoVIxbHZd9ySrbyhS7FOE7XZ3rBN9+qGykABsi2adr6i/4YVKA4HnTxwK7D/2FyJzndDRYeKZw=
X-Received: by 2002:a05:690c:2f89:b0:6e2:10d3:e13 with SMTP id
 00721157ae682-6e9d893fb09mr133553167b3.17.1730318944578; Wed, 30 Oct 2024
 13:09:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZXEEbrI7K6XGr2dN@google.com> <20240913204711.2041299-1-jthoughton@google.com>
In-Reply-To: <20240913204711.2041299-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 30 Oct 2024 13:08:28 -0700
Message-ID: <CADrL8HXv6qG5ewYP07_b7a+FOKB5GAowQjV=6_sBPOrREi-c1Q@mail.gmail.com>
Subject: Re: [PATCH 03/11] objtool: Convert ANNOTATE_RETPOLINE_SAFE to ANNOTATE
To: peterz@infradead.org
Cc: seanjc@google.com, jpoimboe@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 1:47=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Wed, 6 Dec 2023, Sean Christopherson wrote:
> > On Mon, Dec 04, 2023, Peter Zijlstra wrote:
> > >
> > > --- a/arch/x86/include/asm/nospec-branch.h
> > > +++ b/arch/x86/include/asm/nospec-branch.h
> > > @@ -193,12 +193,7 @@
> > >   * objtool the subsequent indirect jump/call is vouched safe for ret=
poline
> > >   * builds.
> > >   */
> > > -.macro ANNOTATE_RETPOLINE_SAFE
> > > -.Lhere_\@:
> > > -   .pushsection .discard.retpoline_safe
> > > -   .long .Lhere_\@
> > > -   .popsection
> > > -.endm
> > > +#define ANNOTATE_RETPOLINE_SAFE    ANNOTATE type=3DANNOTYPE_RETPOLIN=
E_SAFE
> > >
> > >  /*
> > >   * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instruc=
tions
> > > @@ -317,11 +312,7 @@
> > >
> > >  #else /* __ASSEMBLY__ */
> > >
> > > -#define ANNOTATE_RETPOLINE_SAFE                                    \
> > > -   "999:\n\t"                                              \
> > > -   ".pushsection .discard.retpoline_safe\n\t"              \
> > > -   ".long 999b\n\t"                                        \
> > > -   ".popsection\n\t"
> > > +#define ANNOTATE_RETPOLINE_SAFE ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE=
)
> >
> > This fails for some of my builds that end up with CONFIG_OBJTOOl=3Dn.  =
Adding a
> > stub for ASM_ANNOTATE() gets me past that:
> >
> > @@ -156,6 +171,7 @@
> >  #define STACK_FRAME_NON_STANDARD(func)
> >  #define STACK_FRAME_NON_STANDARD_FP(func)
> >  #define ANNOTATE_NOENDBR
> > +#define ASM_ANNOTATE(x)
> >  #define ASM_REACHABLE
> >  #else
> >  #define ANNOTATE_INTRA_FUNCTION_CALL
> >
> > but then I run into other issues:
> >
> > arch/x86/kernel/relocate_kernel_32.S: Assembler messages:
> > arch/x86/kernel/relocate_kernel_32.S:96: Error: Parameter named `type' =
does not exist for macro `annotate'
> > arch/x86/kernel/relocate_kernel_32.S:166: Error: Parameter named `type'=
 does not exist for macro `annotate'
> > arch/x86/kernel/relocate_kernel_32.S:174: Error: Parameter named `type'=
 does not exist for macro `annotate'
> > arch/x86/kernel/relocate_kernel_32.S:200: Error: Parameter named `type'=
 does not exist for macro `annotate'
> > arch/x86/kernel/relocate_kernel_32.S:220: Error: Parameter named `type'=
 does not exist for macro `annotate'
> > arch/x86/kernel/relocate_kernel_32.S:285: Error: Parameter named `type'=
 does not exist for macro `annotate'
>
> Sean pointed me at this series recently. It seems like these compile erro=
rs
> (and some others) go away with the following diff:
>
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/=
nospec-branch.h
> index 0bebdcad7ba1..036ab199859a 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -489,7 +489,7 @@ static inline void call_depth_return_thunk(void) {}
>         "       .align 16\n"                                    \
>         "903:   lea    4(%%esp), %%esp;\n"                      \
>         "       pushl  %[thunk_target];\n"                      \
> -       "       ret;\n"                                         \
> +       "       ret;\n",                                        \
>         X86_FEATURE_RETPOLINE,                                  \
>         "lfence;\n"                                             \
>         ANNOTATE_RETPOLINE_SAFE                                 \
> diff --git a/include/linux/objtool.h b/include/linux/objtool.h
> index f6f80bfefe3b..e811b2ff3a9c 100644
> --- a/include/linux/objtool.h
> +++ b/include/linux/objtool.h
> @@ -159,6 +159,7 @@
>  #define STACK_FRAME_NON_STANDARD_FP(func)
>  #define ANNOTATE_NOENDBR
>  #define ASM_REACHABLE
> +#define ASM_ANNOTATE(x)
>  #else
>  #define ANNOTATE_INTRA_FUNCTION_CALL
>  .macro UNWIND_HINT type:req sp_reg=3D0 sp_offset=3D0 signal=3D0
> @@ -169,7 +170,7 @@
>  .endm
>  .macro REACHABLE
>  .endm
> -.macro ANNOTATE
> +.macro ANNOTATE type:req
>  .endm
>  #endif
>
> This series applies on top of the latest kvm-x86/next with only a few tri=
vial
> conflicts, so I hope you are able to send a new version.
>
> I could send one for you, but I have no idea how to properly test it.

Hi Peter,

I'll go ahead and repost this series soon unless you tell me otherwise. :)

