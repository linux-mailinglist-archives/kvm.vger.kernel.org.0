Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA0C7D197F
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 01:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjJTXNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 19:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjJTXNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 19:13:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5625FD52
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 16:13:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6bd00edc63fso1246585b3a.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 16:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697843595; x=1698448395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CgAVXy/axx8rbE3S2sz/Fpl+Q5PtMzZyyI0NieynS1Q=;
        b=3dzEKRkQ3gyICAewppe2ffS6ZcMlYJNYdSp0UhbUUy9GAMvGPZSTOBDQBYOvfNPb8q
         /aO3YepGbcj1wHzD60P6vX61zRnFjr8Sn32IIAlzvbWDrrHH5sqsTav6I8eyTxe+YRnR
         Pa3A3j1/YJRXX87xGouWpsID1BeypQFBeq0Sa10b042o6IOLXZ2hmOExcuOqsE6KH5YF
         gVtVGvMPwGLfrhEUJdrPmA9NKcRn+pbf1UhmzQbNri+SO6tmFlR4TYSILZjmic3cp79T
         mR62nI6y3qkkL7kZ77ISvQdCFQ4g/wKBnhYkUaiNyhRfcsOASyAuEV66smJ82chJpOe7
         SQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697843595; x=1698448395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CgAVXy/axx8rbE3S2sz/Fpl+Q5PtMzZyyI0NieynS1Q=;
        b=jUbUENuAiUhoOyjPeDJglr6BHQi4d6eiwmdmrpnkY/YhW9iHzSrzUawBLk3pHib8pD
         dL7hsqBbXUxjqNwCRWq8uIZOVtjJsBGtj+Ait5wQ8HJhIh8Egllnv0/4yvDDWlRvZJiy
         yfEPx1q1ieLFWLMac4Sgf/dnf/q2H4xm7y4Kx0PHA8tBdGoevoT5/49JiZDQ94GBybJl
         fWr5QPGeu5oXZ81lWy6WhglHoQBadw9poBNLV4YSAqg+CBkcEEi5XmXf5f0UTg9TmEPP
         uh0o0fRZaD8+iYeBIozl+T54KLAmLG7jR2DwxFqWm2S2VG7bDeVEdTLoYXdAlu5Fu3+s
         9AHQ==
X-Gm-Message-State: AOJu0YxuUDnMZvqI5cykQVJIBv7AGJmOvEvKa8mfde/4MMbuzg5/OyWn
        2DfVIfG1ZN8BwbgcG2xDPkQrMG2oKJE=
X-Google-Smtp-Source: AGHT+IEb+B01P1bRaoNxc8joEn7AXOfNyBKk3u3HcHvMNx5bY4rK4asGL8wTgvrzbJpYbbyCzWgKi6MQfSk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:26e4:b0:6bc:ff89:a30e with SMTP id
 p36-20020a056a0026e400b006bcff89a30emr86478pfw.3.1697843594765; Fri, 20 Oct
 2023 16:13:14 -0700 (PDT)
Date:   Fri, 20 Oct 2023 16:13:13 -0700
In-Reply-To: <20231020-delay-verw-v1-1-cff54096326d@linux.intel.com>
Mime-Version: 1.0
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com> <20231020-delay-verw-v1-1-cff54096326d@linux.intel.com>
Message-ID: <ZTMJiVsEeyu6Vd8E@google.com>
Subject: Re: [PATCH  1/6] x86/bugs: Add asm helpers for executing VERW
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023, Pawan Gupta wrote:
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index c55cc243592e..e1b623a27e1b 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -111,6 +111,24 @@
>  #define RESET_CALL_DEPTH_FROM_CALL
>  #endif
>  
> +/*
> + * Macro to execute VERW instruction to mitigate transient data sampling
> + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> + * instruction to also clear the CPU buffers.
> + *
> + * Note: Only the memory operand variant of VERW clears the CPU buffers. To
> + * handle the case when VERW is executed after user registers are restored, use
> + * RIP to point the memory operand to a part NOPL instruction that contains
> + * __KERNEL_DS.
> + */
> +#define __EXEC_VERW(m)	verw _ASM_RIP(m)
> +
> +#define EXEC_VERW				\
> +	__EXEC_VERW(551f);			\
> +	/* nopl __KERNEL_DS(%rax) */		\
> +	.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;	\
> +551:	.word __KERNEL_DS;			\

Why are there so many macro layers?  Nothing jumps out to justfying two layers,
let alone three.

> +
>  /*
>   * Fill the CPU return stack buffer.
>   *
> @@ -329,6 +347,13 @@
>  #endif
>  .endm
>  
> +/* Clear CPU buffers before returning to user */
> +.macro USER_CLEAR_CPU_BUFFERS
> +	ALTERNATIVE "jmp .Lskip_verw_\@;", "", X86_FEATURE_USER_CLEAR_CPU_BUF
> +	EXEC_VERW

Rather than a NOP after VERW, why not something like this?

/* Clear CPU buffers before returning to user */
.macro USER_CLEAR_CPU_BUFFERS
                ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@;", X86_FEATURE_USER_CLEAR_CPU_BUF
551:            .word __KERNEL_DS
.Ldo_verw_\@:   verw _ASM_RIP(551b)
.Lskip_verw_\@:
.endm

> +.Lskip_verw_\@:
> +.endm
