Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A0E301C9D
	for <lists+kvm@lfdr.de>; Sun, 24 Jan 2021 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbhAXOMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 09:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbhAXOMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 09:12:06 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E84C061573;
        Sun, 24 Jan 2021 06:11:26 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id x21so21172047iog.10;
        Sun, 24 Jan 2021 06:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ao/yarVyR+Aon04nX87tyRiOiK8ZlEZS4G8Yy79d54=;
        b=TBkJ6nomCk8/2cv7rEzXhkIJHSRYlN/B20umDI5FBypSXY4LiVPvMYkZ78nB0graug
         gySN6qtT5tUkrEvc6+TXZP+uf8C6cziH+LvxTvGjYKvAJ5T/3X7OkFwMVs4dxtFZ/z5K
         OgXcxITHmq15P9yHxa8MBf8MAT8zpKYkt+Aw//x97N6VRwmDjJElxZ+jYmCinRwCsEup
         chv3TFU2MILu2qa3ld8TSXvqHYeZ75983Br0qd0yD64NSLXkt0ShGnq0/dx9VFfGxEJR
         zgAVgvSAeNvbJrbbZZ0lZrsALbx10cfXv/YqMvWBQbX4V5+h5oGxhe5G2jiv+eJGRzN8
         j0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ao/yarVyR+Aon04nX87tyRiOiK8ZlEZS4G8Yy79d54=;
        b=BtLavFlaMx5D5zwNCoaCsOuDPLtI9FUVSvqnbv66LNGGzAW/ELC/lS6wI1uZBsZV5e
         L+GH1cqUOPgIAO7Hg3bHc0utMgC49X7KY1zFgpM6q1k/W4GAlDdB6yHtGp2bpOI+dWUp
         gSDvq5oq99RYMf8qwGVIfXp2f9HtHOKL6p/cu4fAnuAGEUMu+5AxVN2+G4NPvpICi+lB
         YR/wf3AEcfCoyvHMSn+sNtoKfJAoyvI+CYe9yKIj8IMcWAtfI67VAHm5VJ7prqUlW7eN
         HNtzMfbot6T1+HRiiw4i8xrm1pRy/IuFvTRKYWcpvjHnsAT6GacLK8E6yExYmLyE8WjU
         m0iw==
X-Gm-Message-State: AOAM5311b8ZUlaYzfzIVMCP+rVQk2Fv90GiA0HugCdTohbyWkruV5YlG
        x2FFvgHfgj5cTi7yJ0oYcF3NRnQbtXKPqR6GpCA=
X-Google-Smtp-Source: ABdhPJznuyJvRo9LDknc7bU5INTQtX0KgDxkRL8UdxQK31cnGO7u+mTblUQvNbV7yrqjpB4rl6bFUja0JrQyw/1zljo=
X-Received: by 2002:a6b:8d0f:: with SMTP id p15mr4436364iod.56.1611497485689;
 Sun, 24 Jan 2021 06:11:25 -0800 (PST)
MIME-Version: 1.0
References: <20200907131613.12703-1-joro@8bytes.org> <20200907131613.12703-46-joro@8bytes.org>
In-Reply-To: <20200907131613.12703-46-joro@8bytes.org>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Sun, 24 Jan 2021 22:11:14 +0800
Message-ID: <CAJhGHyCMMCY9bZauzrSeQr_62SpJgZQEQy9P7Rh28HXJtF5O5A@mail.gmail.com>
Subject: Re: [PATCH v7 45/72] x86/entry/64: Add entry code for #VC handler
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +
> +       /*
> +        * No need to switch back to the IST stack. The current stack is either
> +        * identical to the stack in the IRET frame or the VC fall-back stack,
> +        * so it is definitly mapped even with PTI enabled.
> +        */
> +       jmp     paranoid_exit
> +
>

Hello

I know we don't enable PTI on AMD, but the above comment doesn't align to the
next code.

We assume PTI is enabled as the comments said "even with PTI enabled".

When #VC happens after entry_SYSCALL_64 but before it switches to the
kernel CR3.  vc_switch_off_ist() will switch the stack to the kernel stack
and paranoid_exit can't work when it switches to user CR3 on the kernel stack.

The comment above lost information that the current stack is possible to be
the kernel stack which is mapped not user CR3.

Maybe I missed something.

Thanks
Lai

> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *regs)
> +{
> +       unsigned long sp, *stack;
> +       struct stack_info info;
> +       struct pt_regs *regs_ret;
> +
> +       /*
> +        * In the SYSCALL entry path the RSP value comes from user-space - don't
> +        * trust it and switch to the current kernel stack
> +        */
> +       if (regs->ip >= (unsigned long)entry_SYSCALL_64 &&
> +           regs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack) {
> +               sp = this_cpu_read(cpu_current_top_of_stack);
> +               goto sync;
> +       }
