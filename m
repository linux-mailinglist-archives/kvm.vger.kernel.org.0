Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB25D222D83
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 23:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGPVOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 17:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgGPVOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 17:14:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB89C08C5C0
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 14:14:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f16so5269763pjt.0
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 14:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CSCv+qenN8fQz+hz3SBJPq4lxH8/L5lNiF/O/RXH4cs=;
        b=I+5xqu6T187eBlA+tL31dh5CS7wCkNI25QanX8f0QfAWVGToBzsZX8AeIKyT7710Bs
         F94Tg6+plhmnLGCVlrr/UFEsPF9kU5zpXXmZwrmqg0W/0MYVN46CtWYu55uxwXw2fCn6
         +2FGuZWQiqu1zo5Jq+VajaCuGX6Q4J7vQ4gJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CSCv+qenN8fQz+hz3SBJPq4lxH8/L5lNiF/O/RXH4cs=;
        b=dFHtmcDxB0bHEHzHekyPRQ1JWAj6QW4eXi3xaRK2AwC+BSSQxPLeUJSGLE5ZhZhsbI
         7E80At9nPozbc1lxeStzuGBJBIGcadgC2C33+76hBKjhC3Qw7F3joB4p51rcAMhbOxhO
         KRgbpTQ2K0XtdKWA+cq5WQrlRri1FDqG9DRklb2kdL/ahvv0v7Kwbh7q0XMqozY9aNPy
         hy4NgbGudNaj/cnm+qWnJ9KtiWyA5UgkWfPu8Y+lKV5OiTevppPZqpnG1jVr2j07InLw
         Cgpxb7mfRq7NgySl5ukjxYDPlERd4+SwkrQQgPSL4VXLUsohnS+88ck/4YX0REZeal/V
         ze+A==
X-Gm-Message-State: AOAM530uh+qTRHT31E/2vJ0wSyKHzhO5LM2vXHo6AlINtztHEHnLX7Hc
        zNQ7xMhZ39V8GFF61HX5JciFYg==
X-Google-Smtp-Source: ABdhPJz1BmB9fwt+demvs5kOAZ0MYGo3jfds+eP75BLBTh2DsDI3UFftrsMyrJVfYldCQpL3sKvIZQ==
X-Received: by 2002:a17:902:8206:: with SMTP id x6mr5160870pln.328.1594934040349;
        Thu, 16 Jul 2020 14:14:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x13sm5361936pfj.122.2020.07.16.14.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:13:59 -0700 (PDT)
Date:   Thu, 16 Jul 2020 14:13:58 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch V3 08/13] x86/entry: Use generic syscall entry function
Message-ID: <202007161359.AB211685@keescook>
References: <20200716182208.180916541@linutronix.de>
 <20200716185424.765294277@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716185424.765294277@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 08:22:16PM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Replace the syscall entry work handling with the generic version. Provide
> the necessary helper inlines to handle the real architecture specific
> parts, e.g. audit and seccomp invocations.
> 
> Use a temporary define for idtentry_enter_user which will be cleaned up
> seperately.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [...]
> --- /dev/null
> +++ b/arch/x86/include/asm/entry-common.h
> @@ -0,0 +1,86 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASM_X86_ENTRY_COMMON_H
> +#define _ASM_X86_ENTRY_COMMON_H
> +
> +#include <linux/seccomp.h>
> +#include <linux/audit.h>
> +
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
> +
> +		/* We think we came from user mode. Make sure pt_regs agrees. */
> +		WARN_ON_ONCE(!user_mode(regs));
> +
> +		/*
> +		 * All entries from user mode (except #DF) should be on the
> +		 * normal thread stack and should have user pt_regs in the
> +		 * correct location.
> +		 */
> +		WARN_ON_ONCE(!on_thread_stack());
> +		WARN_ON_ONCE(regs != task_pt_regs(current));
> +	}
> +}
> +#define arch_check_user_regs arch_check_user_regs

Will architectures implement subsets of these functions? (i.e. instead
of each of the defines, is CONFIG_ENTRY_GENERIC sufficient for the
no-op inlines?)

> +
> +static inline long arch_syscall_enter_seccomp(struct pt_regs *regs)
> +{
> +#ifdef CONFIG_SECCOMP
> +	u32 arch = in_ia32_syscall() ? AUDIT_ARCH_I386 : AUDIT_ARCH_X86_64;
> +	struct seccomp_data sd;
> +
> +	sd.arch = arch;
> +	sd.nr = regs->orig_ax;
> +	sd.instruction_pointer = regs->ip;
> +
> +#ifdef CONFIG_X86_64
> +	if (arch == AUDIT_ARCH_X86_64) {
> +		sd.args[0] = regs->di;
> +		sd.args[1] = regs->si;
> +		sd.args[2] = regs->dx;
> +		sd.args[3] = regs->r10;
> +		sd.args[4] = regs->r8;
> +		sd.args[5] = regs->r9;
> +	} else
> +#endif
> +	{
> +		sd.args[0] = regs->bx;
> +		sd.args[1] = regs->cx;
> +		sd.args[2] = regs->dx;
> +		sd.args[3] = regs->si;
> +		sd.args[4] = regs->di;
> +		sd.args[5] = regs->bp;
> +	}
> +
> +	return __secure_computing(&sd);
> +#else
> +	return 0;
> +#endif
> +}
> +#define arch_syscall_enter_seccomp arch_syscall_enter_seccomp

Actually, I've been meaning to clean this up. It's not needed at all.
This was left over from the seccomp fast-path code that got ripped out a
while ago. seccomp already has everything it needs to do this work, so
just:

	__secure_computing(NULL);

is sufficient for every architecture that supports seccomp. (See kernel/seccomp.c
populate_seccomp_data().)

And if you want more generalization work, note that the secure_computing()
macro performs a TIF test before calling __secure_computing(NULL). But
my point is, I think arch_syscall_enter_seccomp() is not needed.

> +static inline void arch_syscall_enter_audit(struct pt_regs *regs)
> +{
> +#ifdef CONFIG_X86_64
> +	if (in_ia32_syscall()) {
> +		audit_syscall_entry(regs->orig_ax, regs->di,
> +				    regs->si, regs->dx, regs->r10);
> +	} else
> +#endif
> +	{
> +		audit_syscall_entry(regs->orig_ax, regs->bx,
> +				    regs->cx, regs->dx, regs->si);
> +	}
> +}
> +#define arch_syscall_enter_audit arch_syscall_enter_audit

Similarly, I think these can be redefined in the generic case
using the existing accessors for syscall arguments, etc. e.g.
arch_syscall_enter_audit() is not needed for any architecture, and the
generic is:

	unsigned long args[6];

        syscall_get_arguments(task, regs, args);
	audit_syscall_entry(syscall_get_nr(current, regs),
			    args[0], args[1], args[2], args[3]);



-- 
Kees Cook
