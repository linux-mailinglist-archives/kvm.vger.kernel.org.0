Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB597D61FA
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjJYG6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 02:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjJYG6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 02:58:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6671DD;
        Tue, 24 Oct 2023 23:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eDKxmuej9tXfCEvb9vvcLDbQO6JariJ+oFUVHWu6xYU=; b=lXRiBz0fpXvDJLERZRH4R6/dOH
        8WcES3v/b44vy20LpA3DpgZjtcOxXkV04gv+3jtsISxr/DHSqc9/a06KYB9iwYwCy1a3m5959tzve
        3l7VW09AOplEaTSe/3KEOsT6trZpwbG8OND6mSMxxXvTHyCDks1p372/+sWzgCVQht6CACs+dEDst
        Wlf9qsXXrbbMuoejkBaHDbs0NL5Jvf7q+cqI/O9NKQ+6ti8K6Ak07Cp+nisGb8iZfrmQehOe/X0ez
        doIHoEEeFwKKyKPRHrXnwCbUwPwTQc64qhqN19lmEC8VIyNdOkFy2DljqH4vsIivevY0Uzg47nCTG
        KibtAllw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvXqN-007H5T-Bg; Wed, 25 Oct 2023 06:58:19 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A9E030047C; Wed, 25 Oct 2023 08:58:19 +0200 (CEST)
Date:   Wed, 25 Oct 2023 08:58:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231025065818.GB31201@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231025040029.uglv4dwmlnfhcjde@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025040029.uglv4dwmlnfhcjde@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 09:00:29PM -0700, Pawan Gupta wrote:

> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index c55cc243592e..ed8218e2d9a7 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -13,6 +13,7 @@
>  #include <asm/unwind_hints.h>
>  #include <asm/percpu.h>
>  #include <asm/current.h>
> +#include <asm/segment.h>
>  
>  /*
>   * Call depth tracking for Intel SKL CPUs to address the RSB underflow
> @@ -329,6 +330,29 @@
>  #endif
>  .endm
>  
> +/*
> + * Macros to execute VERW instruction that mitigate transient data sampling
> + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> + * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
> + *
> + * Note: Only the memory operand variant of VERW clears the CPU buffers.
> + */
> +.pushsection .rodata
> +.align 64
> +mds_verw_sel:
> +	.word __KERNEL_DS
> + 	.byte 0xcc
> +.align 64
> +.popsection

This should not be in a header file, you'll get an instance of this per
translation unit, not what you want.

> +
> +.macro EXEC_VERW
> +	verw _ASM_RIP(mds_verw_sel)
> +.endm
> +
> +.macro CLEAR_CPU_BUFFERS
> +	ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
> +.endm
> +
>  #else /* __ASSEMBLY__ */
