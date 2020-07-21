Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05C8228B9D
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgGUVrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUVrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:47:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026FEC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:47:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d1so10840485plr.8
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d0qw9X0tNGniS1ZJuNmh3kQo0rHArpwRCY1SdmDzv4o=;
        b=VrGO2Qoq0WqpJ07WYt90MTK0xpEak25oY1oRNPdwVdrOHTnsfYEQIxRsIeb+iWgK3P
         zWcDPnRsirzCdz+Aa6+WWHFeTwLA9DXgueCQChEQUvveKG56nSmSXKas8mvhOhJBXs16
         P6VL0c0jIp/xMthj2/iqyvn36MIhNwy5vzuSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d0qw9X0tNGniS1ZJuNmh3kQo0rHArpwRCY1SdmDzv4o=;
        b=FLdiLRxg2yE6ar+wwQ9A9b9LeqjfN9/pLxOwFPOPKib4n0pTnvgQ8dTrdnRrB5J3ux
         jzwB7/e//98+40yacU9sphHli7nHt/8CkdCL+i591HMXrM/Xt8UUWvswfjSDBrOTnGuO
         HpQM6cvpgLcXXmuhEfHOqWjiPuAYKxlKhh1uyJxu1N4rL9CWgWjlmpn0TiC8Ehs7nmqp
         5FudL04tNdE5DvjdZwlF0So+5zDACnGsK9LgOVNW3yqruObAYo6ZXS2EjnuNUIDibAQp
         soOHnDsjjeWbl8dt9Bwcpr5KqrGIzcN32EnRDYtwJ4v3/wvVgLSgfLz/fk+HUg0MwhT2
         wfOw==
X-Gm-Message-State: AOAM530MsdFgYzCjNDAU0PD2mDqn3R1YNNV++/uGrIYF8GUN8ailh/+J
        wGAsZQXLtYaN/tlche/f7pli5A==
X-Google-Smtp-Source: ABdhPJzsElosVq+XXtJ0Yinun69/6HciJUEIooMKainxABpdEdX6Grphvcj0PD+BYTIgwXAAXapr3w==
X-Received: by 2002:a17:90a:9287:: with SMTP id n7mr6064081pjo.223.1595368039408;
        Tue, 21 Jul 2020 14:47:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b15sm4060054pje.52.2020.07.21.14.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 14:47:18 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:47:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [patch V4 10/15] x86/entry: Use generic syscall entry function
Message-ID: <202007211440.BEF76E2@keescook>
References: <20200721105706.030914876@linutronix.de>
 <20200721110809.325060396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110809.325060396@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:57:16PM +0200, Thomas Gleixner wrote:
> Replace the syscall entry work handling with the generic version. Provide
> the necessary helper inlines to handle the real architecture specific
> parts, e.g. ptrace.
> 
> Use a temporary define for idtentry_enter_user which will be cleaned up
> seperately.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

Though, notes and a comment below...

> +/* Check that the stack and regs on entry from user mode are sane. */
> +static __always_inline void arch_check_user_regs(struct pt_regs *regs)
> +{
> +	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
> +		/*
> +		 * Make sure that the entry code gave us a sensible EFLAGS
> +		 * register.  Native because we want to check the actual CPU
> +		 * state, not the interrupt state as imagined by Xen.
> +		 */
> +		unsigned long flags = native_save_fl();
> +		WARN_ON_ONCE(flags & (X86_EFLAGS_AC | X86_EFLAGS_DF |
> +				      X86_EFLAGS_NT));

push, pop, bit test

> +
> +		/* We think we came from user mode. Make sure pt_regs agrees. */
> +		WARN_ON_ONCE(!user_mode(regs));

memory deref, bit test

> +
> +		/*
> +		 * All entries from user mode (except #DF) should be on the
> +		 * normal thread stack and should have user pt_regs in the
> +		 * correct location.
> +		 */
> +		WARN_ON_ONCE(!on_thread_stack());

per-cpu deref, subtract, test

> +		WARN_ON_ONCE(regs != task_pt_regs(current));

memory deref, test

> +	}
> +}

This doesn't look very expensive, and they certain indicate really bad
conditions. Does this need to be behind a CONFIG? (Whatever the answer,
we can probably make those changes in a later series -- some of these
also look not arch-specific...)

-- 
Kees Cook
