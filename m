Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEE6A6223
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjB1WJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjB1WJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:09:17 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA8C7AB6;
        Tue, 28 Feb 2023 14:09:16 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id ay9so12295808qtb.9;
        Tue, 28 Feb 2023 14:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677622155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElzNfX4GjaaLF5eErquCaYeuK/Or8StIZN6B5eFp3VI=;
        b=nKk+3RKoMV3sv/aF3KndF+sExc24k8XNkK6PAbs3TwFGWlQ5LE9E63vQgLJbmfpaBb
         PzPiZtn5Nqdv4A4M8LViKE8XZT+QOfu1bEU4uR094ADSUu4cT6Wt067TPAWcVf4gK5/P
         P9noDHMaMnyYlNUkS+2GrMOu5uHzm6Dz3l99toCEaSO0Daoy0JT+SIvfh+wLoKA+TTRR
         xO0frT6733LN7zm/YtpuMKcnHmKfQnr0jbQ+rAkj4MgMm1In85cMYu5CGeVW/1wNg6Wk
         FfwfiIaE/xYzzvH5wdRWBrW1CmqzxnC2TNu4dkFheE7Nn9SaNgMgr5GdUhQp7C0b936N
         mbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677622155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElzNfX4GjaaLF5eErquCaYeuK/Or8StIZN6B5eFp3VI=;
        b=lNXeT+zoeGMkb/qiyN4Qxosn8H6Z2jZFrmprc7NHCUuXzZ30qcwnN13V33bb/+78X6
         wNMfIaw7xozPqZXXDEQVposgBuvdTth7e1K+92Ck6XtVIDv1I6Y1i7blMGGAck6pI3Ia
         bFqPCWSNbQ7L9WqfHNQGc8PleeSfXZDV2LbU5hRh3cBpA+i0zYV7KYBKT+iEIJBdVs34
         bYdr7Qxeo7Y5aSAy/5oDtBtsGuRrlM195G3jg7ZPQrO5gkc9LNL2d3uD9PhBXSVJY0SI
         kkwsdNx3IlNX8KS3T1b4XrywOjeIzFbS9BjBhCxxPeXEHUdmSHo2VI26N4y5NYog2/0q
         cthw==
X-Gm-Message-State: AO0yUKVRZMRO38dM9KQs0fVSfde848MCJhaXY+XY1Sf4MFqnhCZlltiv
        4SbYCJ/w3SKI6H6OPiPWJj4GRJL2HrISyFTZ3Q==
X-Google-Smtp-Source: AK7set9Z/v6X0lvyuqr9Eu2aEbzgMuD1yVw/iuBxTvo2kJ7Mjf1mkYkSx7vbYu7XXwufe62bQxGcqZXIVeOXDVKWNy0=
X-Received: by 2002:ac8:5901:0:b0:3bf:b95e:1768 with SMTP id
 1-20020ac85901000000b003bfb95e1768mr1170735qty.10.1677622155219; Tue, 28 Feb
 2023 14:09:15 -0800 (PST)
MIME-Version: 1.0
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
In-Reply-To: <878rghmrn2.ffs@tglx>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 28 Feb 2023 17:09:03 -0500
Message-ID: <CAMzpN2hwwZ64MycrCfqKw-Hu_8Xfvz_LdzMgiJ_Ho=x6HFYGVA@mail.gmail.com>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 4:01=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> On Sun, Feb 26 2023 at 11:07, Usama Arif wrote:
> > @@ -265,7 +265,12 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SY=
M_L_GLOBAL)
> >        * addresses where we're currently running on. We have to do that=
 here
> >        * because in 32bit we couldn't load a 64bit linear address.
> >        */
> > -     lgdt    early_gdt_descr(%rip)
> > +     subq    $16, %rsp
> > +     movw    $(GDT_SIZE-1), (%rsp)
> > +     leaq    gdt_page(%rdx), %rax
>
> Even on !SMP gdt_page is in the 0...__per_cpu_end range. Which means
> that on !SMP this results in:
>
>       leaq    0xb000(%rdx),%rax
>
> and RDX is 0. That's not really a valid GDT pointer, right?

No.  On !SMP per-cpu variables are normal variables in the .data
section.  They are not gathered together in the per-cpu section and
are not accessed with the GS prefix.

ffffffff810000c9:       48 8d 82 00 10 81 82    lea    0x82811000(%rdx),%ra=
x
                        ffffffff810000cc: R_X86_64_32S  gdt_page

ffffffff82811000 D gdt_page

So RDX=3D0 is correct.

> > +     movq    %rax, 2(%rsp)
> > +     lgdt    (%rsp)
>
> and obviously that's equally broken for the task stack part:
>
> >       movq    pcpu_hot + X86_current_task(%rdx), %rax

Same as gdt_page:

ffffffff810000b1:       48 8b 82 00 88 a8 82    mov    0x82a88800(%rdx),%ra=
x
                        ffffffff810000b4: R_X86_64_32S  pcpu_hot

ffffffff82a88800 D pcpu_hot

> This needs:
>
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -239,7 +239,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_
>         /* Get the per cpu offset for the given CPU# which is in ECX */
>         movq    __per_cpu_offset(,%rcx,8), %rdx
>  #else
> -       xorl    %edx, %edx
> +       leaq    INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
>  #endif /* CONFIG_SMP */
>
>         /*
>
> in the initial_stack patch, which then allows to remove this hunk in the
> initial_gs patch:
>
> @@ -286,9 +286,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_
>          * the per cpu areas are set up.
>          */
>         movl    $MSR_GS_BASE,%ecx
> -#ifndef CONFIG_SMP
> -       leaq    INIT_PER_CPU_VAR(fixed_percpu_data)(%rip), %rdx
> -#endif

On !SMP the only thing GSBASE is used for is the stack protector
canary, which is in fixed_percpu_data.  There is no per-cpu section.

FWIW, I posted a patch set a while back that switched x86-64 to use
the options added to newer compilers controlling where the canary is
located, allowing it to become a standard per-cpu variable and
removing the need to force the per-cpu section to be zero-based.
However it was not accepted at that time, due to removing support for
stack protector on older compilers (GCC < 8.1).

>         movl    %edx, %eax
>         shrq    $32, %rdx
>         wrmsr
>
> Maybe we should enforce CONFIG_SMP=3Dy first :)

Makes sense, only the earliest generations of x86-64 processors have a
single core/thread, and an SMP kernel can still run on them.

--
Brian Gerst
