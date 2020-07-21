Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A35228B7C
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgGUViT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUViT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:38:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE94BC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:38:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n5so76536pgf.7
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N8VanKmeRrXmUDjwB//KyQiklAQYuN1233LuhalXZDY=;
        b=M2vJNqQyTqxUsB1nXZFLYUKfNHbTRGab8/0+dLF/2r9JZ7nH10z0uN3cCClfO0hYci
         T+4S8tTg8ZYoPj9PCP/S2B2sSOkwYBTQqkZHFjQcOWHvTpRQhApJXxn/bQsTu30cZANg
         Ay6OP8DIN90u4bigwKC6D1BQ6l8stBbeNfsa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N8VanKmeRrXmUDjwB//KyQiklAQYuN1233LuhalXZDY=;
        b=q/gkoZPr2jrgAJxPQOiWCKT879gL0qpqxIGHX0A5dwbx1O91i+XCcmHsWtf16yJ0ib
         UMyPTCQX/z7qRmnG+DX1acJMbh2pzzufKRmfIWp0scuUGkJQb0eEN25WGzXeBCI9AWlf
         6BKTONf/6J6RKDgVBJqJA3IK8NhnWrWiwfMJ09Q+53kdoeNSr+ODa9fXropogfWRT1b3
         BSNK393C/HdxGoYJ0bROL99aeGACx0yfsfmDvhwS0563Z7yxENZP5niX8u0KZl9DyQ/e
         /lgP6I0zC4fQB1BWopil005o8U9Geg1wQW8MOAZLEIsbAj0gs7qGoEUf4kGd/6n/cRnc
         b5RQ==
X-Gm-Message-State: AOAM533nZUCXb5nJIIRkeAI8LI73Q270+Ag0DGGNG7IJn3AOeMJWw0L6
        EdfHAMr4Zsl6vjnYO7Nwd5Pikw==
X-Google-Smtp-Source: ABdhPJxXK+DvtoU+SH7F3Avuq52iHrYc8e37vzMnso4NE6iCFlUgn7Qdzc81vqSxav95we+YPatD5w==
X-Received: by 2002:a62:1c8b:: with SMTP id c133mr26939454pfc.134.1595367498413;
        Tue, 21 Jul 2020 14:38:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s22sm18659133pgv.43.2020.07.21.14.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 14:38:17 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:38:16 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [patch V4 02/15] entry: Provide generic syscall entry
 functionality
Message-ID: <202007211426.B40A7A7BD@keescook>
References: <20200721105706.030914876@linutronix.de>
 <20200721110808.455350746@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110808.455350746@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:57:08PM +0200, Thomas Gleixner wrote:
> On syscall entry certain work needs to be done:
> 
>    - Establish state (lockdep, context tracking, tracing)
>    - Conditional work (ptrace, seccomp, audit...)
> 
> This code is needlessly duplicated and  different in all
> architectures.
> 
> Provide a generic version based on the x86 implementation which has all the
> RCU and instrumentation bits right.
> 
> As interrupt/exception entry from user space needs parts of the same
> functionality, provide a function for this as well.
> 
> syscall_enter_from_user_mode() and irqentry_enter_from_user_mode() must be
> called right after the low level ASM entry. The calling code must be
> non-instrumentable. After the functions returns state is correct and the
> subsequent functions can be instrumented.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Kees Cook <keescook@chromium.org>

With one suggestion...

> [...]
> --- /dev/null
> +++ b/kernel/entry/common.c
> @@ -0,0 +1,88 @@
> [...]
> +static inline void syscall_enter_audit(struct pt_regs *regs, long syscall)
> +{
> +	if (unlikely(audit_context())) {
> +		unsigned long args[6];
> +
> +		syscall_get_arguments(current, regs, args);
> +		audit_syscall_entry(syscall, args[0], args[1], args[2], args[3]);
> +	}
> +}

One thing I noticed while doing syscall entry timings for the kernel
stack base offset randomization was that the stack protector was being
needlessly enabled in certain paths (seccomp, audit) due to seeing a
register array being declared on the stack. As part of that series I
suggested down-grading the stack protector. Since then, Peter's changes
entirely disabled the stack protector on the entry code, which I
grudgingly accept (I'd rather have a way to mark a variable as "ignore
this for stack protector detection", but ... there isn't, so fine.)

> [...]
> --- /dev/null
> +++ b/kernel/entry/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_GENERIC_ENTRY) += common.o

But, my point is, let's avoid tripping over this again, and retain the
disabling here:

CFLAGS_common.o += -fno-stack-protector

I can add this again later, but it'd be nice if it was done here to
avoid gaining back the TIF_WORK stack protector overhead penalty (which
we're free of in v5.8 for the first time). ;)

-- 
Kees Cook
