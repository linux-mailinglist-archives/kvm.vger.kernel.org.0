Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86225D9A77
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389182AbfJPTxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 15:53:22 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:44282 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfJPTxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 15:53:21 -0400
Received: by mail-il1-f196.google.com with SMTP id f13so3884508ils.11
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 12:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X79BZjGgfq7WmClHAQgDSWlzjKHAr+RKg+MNBU41si4=;
        b=GEY3P7+wKIxwvh3mK/t/j0KnQ0cHRcB0Td7w7fGPRMCVMoJLd1vXJ2t25lBZwxvaby
         riM1U52mR34t4SLUDWCHiUKv6YXnRz+XroAADDklVtNPuRjdcIoSMa4yD9ccw9a6hvjM
         yMRYNRmPazmNLJ2DyY38/r7kz3abKcKdrmeNbuzmcqG5+0eA0Y4rKR9RNckX4DyFzy+L
         toCOCprZXZTXxqG/ZHQJk1ugzfL2we+q+002yz0IdkfspztZiYNu/aUCgo22WiJdsbeS
         CuW1t8CckQ0hMwNJ+Fx/NVNPSgE6WzyuYxSxGlZI4JCnKwu6svnP50XmdISyQADD6Cq2
         hHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X79BZjGgfq7WmClHAQgDSWlzjKHAr+RKg+MNBU41si4=;
        b=avMQ0zVWqtImWJ0D25lM95vWJ8eLuAxgDxDmLLlnBOsuWw+mMgEX2bIlZ0fKXCD0Y6
         qc0bFPD3rO2TqARCSCdOVlpWX4WyaDzQb4J6O21tgEjSvU6CQyK5qWcCQXVbU3F8ELfl
         FNMbgxGrKEJqi6e3OkQLvTxw8rL3M9h/IhXreDXUxp/eHf3RMp7EJw1aICBcaLCkrm7Y
         PnGDVMELa05Ic4YxnIyw3Xdw+Rj6EUviITbXpsGJOsaCNVO5HF1qfeg1FzR8Uu+pnT0x
         F/Zc3Roz/M29bOfvnlhSsc9NchEo8lO4MYiUrjUcu1ksnqDCjZxq+PikIpnPagYQSe2E
         0yjw==
X-Gm-Message-State: APjAAAXuQSLYK0DLcjEHHW3JtsAtsQ8KemLnqd2JCw2BNYEclcnTB0aL
        RDlJBnRq49197+4k7g27OcWdW3FVjAq3qz6bzeIPUA==
X-Google-Smtp-Source: APXvYqylg0rWocYa8bWvBTa7roa6kLe/lssk+yBjlNwjrRzIcYEtEJIrxb2ZPQSuuNTJtYTPHFHUMIzt49y8fJuGkCs=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr14130182ilq.296.1571255600831;
 Wed, 16 Oct 2019 12:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191012235859.238387-3-morbo@google.com>
In-Reply-To: <20191012235859.238387-3-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 12:53:09 -0700
Message-ID: <CALMp9eSK_O24gYg6J7U-eL1Lq4Y=YaXSaQVZhXs+1RSM+h83ew@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: realmode: use inline asm to get
 stack pointer
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 12, 2019 at 4:59 PM Bill Wendling <morbo@google.com> wrote:
>
> It's fragile to try to retrieve the stack pointer by taking the address
> of a variable on the stack. For instance, clang reserves more stack
> space than gcc here, indicating that the variable may not be at the
> start of the stack. Instead of relying upon this to work, retrieve the
> "%rbp" value, which contains the value of "%rsp" before stack
> allocation.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/realmode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/x86/realmode.c b/x86/realmode.c
> index cf45fd6..7c89dd1 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -518,11 +518,12 @@ extern void retf_imm(void);
>
>  static void test_call(void)
>  {
> -       u32 esp[16];
>         u32 addr;
>
>         inregs = (struct regs){ 0 };
> -       inregs.esp = (u32)esp;
> +
> +       // At this point the original stack pointer is in %ebp.
> +       asm volatile ("mov %%ebp, %0" : "=rm"(inregs.esp));

I don't think we should assume the existence of frame pointers.
Moreover, I think %esp is actually the value that should be saved
here, regardless of how large the current frame is.

>         MK_INSN(call1, "mov $test_function, %eax \n\t"
>                        "call *%eax\n\t");
> --
> 2.23.0.700.g56cf767bdb-goog
>
