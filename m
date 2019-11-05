Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC858F05DD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390438AbfKETYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:24:17 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42161 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389691AbfKETYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:24:17 -0500
Received: by mail-lf1-f65.google.com with SMTP id z12so16016118lfj.9
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwm6PZsL/4t+WR3kaVLVQpWpW7OrpwI1YAqH8VSalYs=;
        b=n1gt22naX+jhZOYGv13Ky4y594vAMUsNkqyO65RMfU2FIY6ACHSe+2JhsP4lVVt/AL
         zGPJtzyDSIsMbQn9meiYIJ03KYUFxIXhFzzrulBORtGyjetT7g4lnRL/zFI8Q+dSXK7T
         PET06lcv0G214HjyY8lCb5UxSHY9olpGd82Q1ZVceU3OVXAi2+KZGS8iUd0O35rBg7mx
         vAUeuL8aEhtbM1HvAJzoP1hmZISXQzUHH6Au0s1YVrQ0GUQzal5eOuqaWuy+JgOu7HzG
         cieOEBwIzxhVmcKGiT93FP1T2aHuRLV31mdIQtEXqQOjKVQeEQpT9Kz1U28DXAG+Uqeq
         HeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwm6PZsL/4t+WR3kaVLVQpWpW7OrpwI1YAqH8VSalYs=;
        b=Kk1yFDqORuliwY9IWOZS7xMsQDQ8ZS0RaH/wW4ua7Fubepr8zJwI089SEuwfo/opNM
         nHPtU3xbZyMNPITg8hkp+Sf7OfIlSzUs5e24Ka/ZiapMblfIO3jxAORsbUAiSXg7SuLe
         fK3eGwI1jRvIZYsOnnqGYJJQVdGjWzKL1++PFLSjVDxg0vReTVFqV8TJMh/SeLN+GLZ9
         Dr9KAbbE+PXF/+Viagke5ivpRSgxx+/9meHERXSfFha4RDGjESpx0BDPzPObXb+D4n4l
         Mb+jJvz2/989hCivjFP8dmwdogINcwVsYXJai671kv9+qBETO+Klz+QvlDUHOkOqyImT
         Kd8A==
X-Gm-Message-State: APjAAAWSjO2CQ8+QXkTA9WIWD5Y44zzICZWaWou2z4Q2NkUOp8GkMlEc
        w7LUXgv21DBkPUqdsSoGUDUvexYHRqB/rhPZoS2YDkuC
X-Google-Smtp-Source: APXvYqxv4z0fp2/PVyWG+wBDIiNeG6YDhpCKtNew/Q339yXgLQ5RjcwbofoelH51SyOVcQ8rb2tjwstrzSnZfVyBoRY=
X-Received: by 2002:ac2:51dd:: with SMTP id u29mr21913601lfm.135.1572981853358;
 Tue, 05 Nov 2019 11:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20191025170056.109755-1-aaronlewis@google.com>
In-Reply-To: <20191025170056.109755-1-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 5 Nov 2019 11:24:02 -0800
Message-ID: <CAAAPnDF8kYw2r4=cu-xfPcrgQnwit-fNsZcAoU4hOZRz-6qEZA@mail.gmail.com>
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

ping. plain text this time.
