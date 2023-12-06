Return-Path: <kvm+bounces-3782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C06D7807C56
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 00:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6095B1F21BDA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 23:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37D02F508;
	Wed,  6 Dec 2023 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O2LjTPF7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552DAA9
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 15:32:02 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6ce9ebb55b6so58580b3a.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 15:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701905522; x=1702510322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3g9WdfqqfwTN8EG7bwCQdbSX4Tlm9Xey4HM7ERn8Nw=;
        b=O2LjTPF7M95Ess2Uru2Nm2E8JgY63k/2JEynVsQoajdwP52mQOPLoZuGDOtLDvtN8N
         HKNamiVaQlv1dWUoitbZmdWlcQ3ENc/No8aGFzjHctv9ZCOASuLnKBc5TJrwp9Yf78ku
         j7gqK6UCELW4fK3s4syj2ynYCPJyT7qwUi5kc31570tL39X+Klg1VWeEC0KBausTZqdR
         jOqQhi8WBZZ4iilVxoaDipRouxg+5FXU0qOWFZGTVi+V6A1nWk8HpAXsf+y6AoXt3QRh
         WDCK4MAObTaXQACyg5ZVzjtEpkVMgLpBIYAM36CQo4cT9FK7WadOqr+9jYG4wjvWpqp9
         bCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701905522; x=1702510322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3g9WdfqqfwTN8EG7bwCQdbSX4Tlm9Xey4HM7ERn8Nw=;
        b=s19uXOBRExU6iaW1iugIBtyxBPhqwDU7IoXeHLjIl05M1PlslWVGTRZcQlh7Yf5+aL
         81w63dyErldjSA5okfSvbUtc1udmWL7/XL+c72qQhacU5jH/pSplfD7I5rT1bzj9mIiC
         LFQ78tHUU22JOjvrgOyUNzyGuZSJn2I9AELUe5+hrfocqcCnjPEpkNVOXpUhsBEp86li
         CkvxgQfvObs89bIDNyuKKCwtwAEPnDZz7Acz5DojViU5Y26LW6bdvP9L54jVzuqbkilv
         eGlKGjK57cnxRy/6kWQSqPbhFVYhClC42hPCq8M4GTr0DNIe/AEhhGQ7xK0jrh2YpDX7
         xtkg==
X-Gm-Message-State: AOJu0YwZkrBUVD1yPLHsHHuULU3sU3SpsF00mjdwsxbQq4IWsV0Pz047
	3aFXzWdKP2mxjB95HnSZOzIFkZiT+/0=
X-Google-Smtp-Source: AGHT+IHoP2NZCWhBmYB7HjbnCtmNvpNaWitEIYHTnKuBHjFrpikywb64Nq1cupyzyHHdZCE9akDojsrT0Vc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80d:b0:1d0:c2be:3d9d with SMTP id
 u13-20020a170902e80d00b001d0c2be3d9dmr22049plg.7.1701905520546; Wed, 06 Dec
 2023 15:32:00 -0800 (PST)
Date: Wed, 6 Dec 2023 15:31:58 -0800
In-Reply-To: <20231204093731.574465649@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231204093702.989848513@infradead.org> <20231204093731.574465649@infradead.org>
Message-ID: <ZXEEbrI7K6XGr2dN@google.com>
Subject: Re: [PATCH 03/11] objtool: Convert ANNOTATE_RETPOLINE_SAFE to ANNOTATE
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 04, 2023, Peter Zijlstra wrote:
> 
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -193,12 +193,7 @@
>   * objtool the subsequent indirect jump/call is vouched safe for retpoline
>   * builds.
>   */
> -.macro ANNOTATE_RETPOLINE_SAFE
> -.Lhere_\@:
> -	.pushsection .discard.retpoline_safe
> -	.long .Lhere_\@
> -	.popsection
> -.endm
> +#define ANNOTATE_RETPOLINE_SAFE	ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
>  
>  /*
>   * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
> @@ -317,11 +312,7 @@
>  
>  #else /* __ASSEMBLY__ */
>  
> -#define ANNOTATE_RETPOLINE_SAFE					\
> -	"999:\n\t"						\
> -	".pushsection .discard.retpoline_safe\n\t"		\
> -	".long 999b\n\t"					\
> -	".popsection\n\t"
> +#define ANNOTATE_RETPOLINE_SAFE ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE)

This fails for some of my builds that end up with CONFIG_OBJTOOl=n.  Adding a
stub for ASM_ANNOTATE() gets me past that:

@@ -156,6 +171,7 @@
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
+#define ASM_ANNOTATE(x)
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL

but then I run into other issues:

arch/x86/kernel/relocate_kernel_32.S: Assembler messages:
arch/x86/kernel/relocate_kernel_32.S:96: Error: Parameter named `type' does not exist for macro `annotate'
arch/x86/kernel/relocate_kernel_32.S:166: Error: Parameter named `type' does not exist for macro `annotate'
arch/x86/kernel/relocate_kernel_32.S:174: Error: Parameter named `type' does not exist for macro `annotate'
arch/x86/kernel/relocate_kernel_32.S:200: Error: Parameter named `type' does not exist for macro `annotate'
arch/x86/kernel/relocate_kernel_32.S:220: Error: Parameter named `type' does not exist for macro `annotate'
arch/x86/kernel/relocate_kernel_32.S:285: Error: Parameter named `type' does not exist for macro `annotate'

