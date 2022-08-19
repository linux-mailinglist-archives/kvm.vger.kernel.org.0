Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8959A3AD
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354785AbiHSRrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 13:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354667AbiHSRqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 13:46:30 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF3D106FAC;
        Fri, 19 Aug 2022 10:12:03 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9849329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9849:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4AB101EC0513;
        Fri, 19 Aug 2022 19:11:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660929118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oVl17GCAM3jigji/R6bhFAs3AfjiIwBGZ04xbfRynoM=;
        b=BjmMfzZW3ekrUBJWKII5nG4s6IjaVVIN/J426q0MZIEbLn70mT7KI9kFu6AvA09GUllnYP
        y9OwhipC181n+2LXoB2cCNMDb2RONKhefsJt20Ynw0ld+REVwxjhKXY7Bmx7aVnZ57mBnX
        S6ilEyEeA+sEmd54lzYz16CI+JlsfDM=
Date:   Fri, 19 Aug 2022 19:11:54 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH] Kconfig: eradicate CC_HAS_ASM_GOTO
Message-ID: <Yv/EWqYy0HzrpO2u@zn.tnic>
References: <20220819170053.2686006-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220819170053.2686006-1-ndesaulniers@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 10:00:53AM -0700, Nick Desaulniers wrote:
> GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
> The minimum supported versions of these tools for the build according to
> Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.
> 
> Remove the feature detection script, Kconfig option, and clean up some
> fallback code that is no longer supported.
> 
> The removed script was also testing for a GCC specific bug that was
> fixed in the 4.7 release.
> 
> The script was also not portable; users of Dash shell reported errors
> when it was invoked.
> 
> Link: https://lore.kernel.org/lkml/CAK7LNATSr=BXKfkdW8f-H5VT_w=xBpT2ZQcZ7rm6JfkdE+QnmA@mail.gmail.com/
> Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
> Reported-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Documentation/kbuild/kconfig-language.rst |  4 ++--
>  arch/Kconfig                              |  3 +--
>  arch/um/include/asm/cpufeature.h          |  4 ++--
>  arch/x86/Makefile                         |  4 ----
>  arch/x86/include/asm/cpufeature.h         |  4 ++--
>  arch/x86/include/asm/rmwcc.h              | 19 +------------------
>  arch/x86/kvm/emulate.c                    |  2 +-
>  init/Kconfig                              |  4 ----
>  scripts/gcc-goto.sh                       | 22 ----------------------
>  tools/arch/x86/include/asm/rmwcc.h        | 21 ---------------------
>  10 files changed, 9 insertions(+), 78 deletions(-)
>  delete mode 100755 scripts/gcc-goto.sh

Nice and good riddance.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
