Return-Path: <kvm+bounces-26870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E3C978A30
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A855285F89
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE7F15099D;
	Fri, 13 Sep 2024 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vxmT0Zk1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4010413774B
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726260434; cv=none; b=Tf6sEZgOYQSZe5Enqjrgd73CznjJLIWmmHz+USaAkCIKFh+r4MlEfP9KbdaGhY0kGC/xV8rx2YDMazbC7MXJgdj/CPZEpx5UP1JSRNkLu80f0OvMJffqaTksAE7U/JubpYRwygbGCUpp5IIDP3kvSMA2KGPs91TZJFHP4pghsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726260434; c=relaxed/simple;
	bh=+w7pnCe13cneotmHtYMAqQ4Thh3L1WZ9Sf2dGfNzHGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cklkGcim9/7uRzrC5eLvN2AAaiOwlV5xdMPUYFLLV8xjbIlYaVELJi9FMgSGaZB1rLa8f3KfFlK4rE9HVVYiCZOIKA3rNR1GQpxoOp/z0xkAf4lF9BoV3gGNnt2niGGZC0S9BW5/1OXoD8Qwd+4KJRaw2qCply4bTEEnaOvzRgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vxmT0Zk1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d3aa5a672dso59243157b3.2
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 13:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726260432; x=1726865232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pB0pBVQhjuwmKvEa6sTHCtkYYP4usAt00xQYDsw1fuA=;
        b=vxmT0Zk1TCjppXF6ZdDWBCVw4D+gwgIpSzNZ1IbjulrQFEn61im5VDpkHBJFOOS/LS
         L2FJntusX6G6zbkobKm3sKCJPiOf1VwrweZuEwzZsBur2DbNFYghGjWTz5az27Y1i5w9
         i9nb2DOxllXgfOkskWRvjDxgmESF5J8IsjXkr01TiP1BSUW+JvLSvb+0AmAsVyTKf0mm
         TNH/oUN90XUCXIiRo4TGDYzRfVJ2otlpd+Z5a/3f+dQwGa/WC6Q6Gi87/cPGWqItKw5s
         upVUDOM7utM5PMxCx73Cl1V3eO9UP3mbRGRv8k2h4QXkjt03s9bJSZVNX+G3FiPyGbIf
         XhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726260432; x=1726865232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pB0pBVQhjuwmKvEa6sTHCtkYYP4usAt00xQYDsw1fuA=;
        b=rfUGvbebkzvwNgSZnI9aKijoR2ZDr4IrAsYLMWRs0POScmc1QcVAGOCJR5+Xi4wruB
         3y/PUO7vEedxRhi6PZssFgNGZ9dDAgIrjH9F36W8aFs4oXdC3J6k01CbYQsvyaKn2I4R
         1zb2fzIB3jNGSgie2ypnr84iGtaHXfGrowo8qufRnmxEplSnVvLGYQjvuhmF/ngg43pa
         iwGR4YRZicw8jd/hdlKkHN4LTxkqeHCrMnHHduAul40SQxX3izpW4xRDsvp6YwHb0iZ2
         uHrseaQH8yjx0ParrzYkabHDJdKB3jDiNKNROYP2HoJBiJfhM2yp/w65lnf3DEbLCfbp
         C/IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt2kGtc/OHwR5xhYUb7JjI5FBVByu0NoDdAX68t/2Hz+YNUXA/voIzoSUyIZF3K05ukwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzneNN2TQZ3OEcyg6t2rGQqegF2h3u2/iJ6ZPMXtgCffiSHdrQC
	fe4LMrinDW6KHcT95qqpC/N22Wm2Je4Kv4C6tyulGruTw8YJObX+rjIMSMBfP++SWcoYweRLPvE
	sxAVkp8BAJHVKlTxjcw==
X-Google-Smtp-Source: AGHT+IF0KlYAfabntP8DGmbCaPONcArZEuk/OdnURmRD8et2Y319XSkqK51oSusCluIbgOxFIPxi3eLs9VtnN36m
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a81:5b88:0:b0:6db:c6d8:678 with SMTP id
 00721157ae682-6dbc6d807f6mr1472677b3.0.1726260432113; Fri, 13 Sep 2024
 13:47:12 -0700 (PDT)
Date: Fri, 13 Sep 2024 20:47:11 +0000
In-Reply-To: <ZXEEbrI7K6XGr2dN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZXEEbrI7K6XGr2dN@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913204711.2041299-1-jthoughton@google.com>
Subject: Re: [PATCH 03/11] objtool: Convert ANNOTATE_RETPOLINE_SAFE to ANNOTATE
From: James Houghton <jthoughton@google.com>
To: peterz@infradead.org
Cc: seanjc@google.com, jpoimboe@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

On Wed, 6 Dec 2023, Sean Christopherson wrote:
> On Mon, Dec 04, 2023, Peter Zijlstra wrote:
> > 
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -193,12 +193,7 @@
> >   * objtool the subsequent indirect jump/call is vouched safe for retpoline
> >   * builds.
> >   */
> > -.macro ANNOTATE_RETPOLINE_SAFE
> > -.Lhere_\@:
> > -	.pushsection .discard.retpoline_safe
> > -	.long .Lhere_\@
> > -	.popsection
> > -.endm
> > +#define ANNOTATE_RETPOLINE_SAFE	ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
> >  
> >  /*
> >   * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
> > @@ -317,11 +312,7 @@
> >  
> >  #else /* __ASSEMBLY__ */
> >  
> > -#define ANNOTATE_RETPOLINE_SAFE					\
> > -	"999:\n\t"						\
> > -	".pushsection .discard.retpoline_safe\n\t"		\
> > -	".long 999b\n\t"					\
> > -	".popsection\n\t"
> > +#define ANNOTATE_RETPOLINE_SAFE ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE)
> 
> This fails for some of my builds that end up with CONFIG_OBJTOOl=n.  Adding a
> stub for ASM_ANNOTATE() gets me past that:
> 
> @@ -156,6 +171,7 @@
>  #define STACK_FRAME_NON_STANDARD(func)
>  #define STACK_FRAME_NON_STANDARD_FP(func)
>  #define ANNOTATE_NOENDBR
> +#define ASM_ANNOTATE(x)
>  #define ASM_REACHABLE
>  #else
>  #define ANNOTATE_INTRA_FUNCTION_CALL
> 
> but then I run into other issues:
> 
> arch/x86/kernel/relocate_kernel_32.S: Assembler messages:
> arch/x86/kernel/relocate_kernel_32.S:96: Error: Parameter named `type' does not exist for macro `annotate'
> arch/x86/kernel/relocate_kernel_32.S:166: Error: Parameter named `type' does not exist for macro `annotate'
> arch/x86/kernel/relocate_kernel_32.S:174: Error: Parameter named `type' does not exist for macro `annotate'
> arch/x86/kernel/relocate_kernel_32.S:200: Error: Parameter named `type' does not exist for macro `annotate'
> arch/x86/kernel/relocate_kernel_32.S:220: Error: Parameter named `type' does not exist for macro `annotate'
> arch/x86/kernel/relocate_kernel_32.S:285: Error: Parameter named `type' does not exist for macro `annotate'

Sean pointed me at this series recently. It seems like these compile errors
(and some others) go away with the following diff:

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 0bebdcad7ba1..036ab199859a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -489,7 +489,7 @@ static inline void call_depth_return_thunk(void) {}
 	"       .align 16\n"					\
 	"903:	lea    4(%%esp), %%esp;\n"			\
 	"       pushl  %[thunk_target];\n"			\
-	"       ret;\n"						\
+	"       ret;\n",					\
 	X86_FEATURE_RETPOLINE,					\
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index f6f80bfefe3b..e811b2ff3a9c 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -159,6 +159,7 @@
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
+#define ASM_ANNOTATE(x)
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
@@ -169,7 +170,7 @@
 .endm
 .macro REACHABLE
 .endm
-.macro ANNOTATE
+.macro ANNOTATE type:req
 .endm
 #endif

This series applies on top of the latest kvm-x86/next with only a few trivial
conflicts, so I hope you are able to send a new version.

I could send one for you, but I have no idea how to properly test it.

