Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F81FE00E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKOO1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:27:48 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38584 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfKOO1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 09:27:48 -0500
Received: by mail-lf1-f67.google.com with SMTP id q28so8171578lfa.5
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 06:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J1z043+yawG1LzHxNBrYBrUNUJ78K6NFWaeacWnh1zU=;
        b=SMW9FbN7RnsHSYe0SlcG5Ry9aF3WH+GCkTB8whiPCkPC0QdiexUJRKjTw4mJi1EJh7
         CAW3piMolLIShTG6LLclPfQokNNE6lYK5hU8dwVtHgXgl2sD/dvDK5KV99JbT42gXfd0
         NvbDGYoiq7r2JnhKhl1Cn14Jk576xgKL2915nUBYbhpWhNnLymB6Dx+BK639RebEYzwa
         suDPAvIyKzMYc5uJfb21ASEYu1vikZ00vDy53LMyWx5q/65zryVyjv0vITKvtbE8vWt4
         PXH5stUYQUNCVtDi1FbyvkuzffETM7hI5aL2aFjmOHyQHH6YDL4fQW2XXb+O0+UvdXdw
         OqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1z043+yawG1LzHxNBrYBrUNUJ78K6NFWaeacWnh1zU=;
        b=mGCbFfwaNTbEZ01q5W0IlyeKrvXNNlEDmTR16Hb0Fs45k1gYD9MegxqBeFRzzLo1hG
         1fTDSWPz6jc6PK8ZB/UBbuJ6mo6WtScp2yY+FU7XBiBU6laqYkcQqZnUFiR2JJltT22r
         l+hV0v5+o17lANPjRYhUR3qmTmRYxjlcsGQ0T1VWJXQQuJ2YLbAxvfzL7SpjEBc1kS9W
         PX9wKCneElsOKPiZAIiZUEYh/0wWCLHMKqy0X8nf8kCTjtaZ3itLdKFzHfOr6wCu+yRe
         YfRkGwafZBXSS/V68ysS2FXURLbEHpsphEisnv9lR5c4BHxWtIohiojQCIqAlp0KuZIT
         a1/Q==
X-Gm-Message-State: APjAAAW6i4dT6EhaZiAQ0kHFXeMxSrWmzZLBm3/BQMUx4VWS0Zno2omd
        IqvrHz5XX65/zeV3Ztzuliopggo1SQKZVBnH4WrjvBR+
X-Google-Smtp-Source: APXvYqyrl8aZQJaxpEhtocBfKqeg6VtJwq4ABDL/Mt3KWlzoFUS4xL9wwGj62yFi2vQDFnx28KGx9HTi6SssOcKy//4=
X-Received: by 2002:a19:848a:: with SMTP id g132mr11805229lfd.62.1573828065804;
 Fri, 15 Nov 2019 06:27:45 -0800 (PST)
MIME-Version: 1.0
References: <20191025170056.109755-1-aaronlewis@google.com>
In-Reply-To: <20191025170056.109755-1-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 15 Nov 2019 06:27:34 -0800
Message-ID: <CAAAPnDFcS+SCrLK1wGGEiBBc+yy1bGOKsw4oKnXgXFwUb9p0CQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the register order to match
 struct regs
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 10:01 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Fix the order the registers show up in SAVE_GPR and SAVE_GPR_C to ensure
> the correct registers get the correct values.  Previously, the registers
> were being written to (and read from) the wrong fields.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/vmx.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 8496be7..8527997 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -492,9 +492,9 @@ enum vm_instruction_error_number {
>
>  #define SAVE_GPR                               \
>         "xchg %rax, regs\n\t"                   \
> -       "xchg %rbx, regs+0x8\n\t"               \
> -       "xchg %rcx, regs+0x10\n\t"              \
> -       "xchg %rdx, regs+0x18\n\t"              \
> +       "xchg %rcx, regs+0x8\n\t"               \
> +       "xchg %rdx, regs+0x10\n\t"              \
> +       "xchg %rbx, regs+0x18\n\t"              \
>         "xchg %rbp, regs+0x28\n\t"              \
>         "xchg %rsi, regs+0x30\n\t"              \
>         "xchg %rdi, regs+0x38\n\t"              \
> @@ -511,9 +511,9 @@ enum vm_instruction_error_number {
>
>  #define SAVE_GPR_C                             \
>         "xchg %%rax, regs\n\t"                  \
> -       "xchg %%rbx, regs+0x8\n\t"              \
> -       "xchg %%rcx, regs+0x10\n\t"             \
> -       "xchg %%rdx, regs+0x18\n\t"             \
> +       "xchg %%rcx, regs+0x8\n\t"              \
> +       "xchg %%rdx, regs+0x10\n\t"             \
> +       "xchg %%rbx, regs+0x18\n\t"             \
>         "xchg %%rbp, regs+0x28\n\t"             \
>         "xchg %%rsi, regs+0x30\n\t"             \
>         "xchg %%rdi, regs+0x38\n\t"             \
> --
> 2.24.0.rc0.303.g954a862665-goog
>

Ping.
