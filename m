Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2C379C43
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 03:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhEKBtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 21:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhEKBtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 21:49:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE725C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:48:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x20so26249071lfu.6
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDBP3t8xxw7FgcC7Mn32xXjVLL/Iv7un1Ml6otcfL1Q=;
        b=o59sfAUNDxiMTA1SI3piUPgR0fGkH11jRbky8By0hyLvSsisRH56Nsgaxazi4Ab3Ck
         Kz6rjekiyIqQN2AT+DlKKiq6LASCZOUztCzZyaKefB1YBgh/K8G1rCLoHMBu+CUgeK6e
         C0UbX/T8kxPKnp+0rOB8y8xtFkzfzHdvatWwyctPRgq4HZ7XVywqafAsP+poIxRgRNky
         TVX2aAVTKAbO5pEJIqhiJbhhq/8YiZxGaYJCrHkB9x180SSzvZAWZ/M8gO9tCqtYUM6t
         zFpS975IuBHAI4plD2K7YKs9XqFsV6GnHnETaH4pkTD1C37P+KmXFI6EY6bufet+VyP1
         hM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDBP3t8xxw7FgcC7Mn32xXjVLL/Iv7un1Ml6otcfL1Q=;
        b=H/OTAWhhl8n4GNMNriNIwOp8b3uiSmfSzTN8rohmeG3RS/5Ef135ZIo3Z9hIZpyH8a
         jvwd7w02mfZjZ9OAZXW2q5hKKa/SJmJtFWZezLHae0jhGpK3M7hgV3IWYTdgLZql4Puo
         xRR1CtXfGpNb23F6lUSfSHqklsj1tV0ooIYiJawfMSmXYXYhRKaN2qLzhVoXpGfDvyx8
         uzcSSAnQRpOwWDgvJn8kPHOq7WpGMUCiKg1JGaJ0QhWBHnMLWlhZFqP6kixvxcEwMa9U
         YZaUdIWmAQWlV9a9XV/LqHgxjB3dyiOujQVoQiLZ4hBZEm3ux4L6qq4RDhc/UpnGB6UJ
         HFyw==
X-Gm-Message-State: AOAM533CjMMZ1Sx7updxrwPrOAjxHGE9deGWsoeb2SFuufNUzqoIeniS
        LOJDA5NpmNOmviMDgqbT7elJYxPrPh2zrerqG3srfA==
X-Google-Smtp-Source: ABdhPJziTZFHPGAaKcWARoXLkt0sVY54G61qQPiK3+b7cwda45qjpiU9luCCzbh0X+3ZEY9Dz/tfkv428e44BMYb1Os=
X-Received: by 2002:a05:6512:54c:: with SMTP id h12mr18563622lfl.357.1620697681115;
 Mon, 10 May 2021 18:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184925.290359-1-jacobhxu@google.com> <YJQ8NN6EzzZEiJ6a@google.com>
 <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com> <CALMp9eQoscqr9p5ayzYkKXHNMcQthntJr_BJ+egEdriEQUqSTw@mail.gmail.com>
In-Reply-To: <CALMp9eQoscqr9p5ayzYkKXHNMcQthntJr_BJ+egEdriEQUqSTw@mail.gmail.com>
From:   Jacob Xu <jacobhxu@google.com>
Date:   Mon, 10 May 2021 18:47:49 -0700
Message-ID: <CAJ5mJ6h4413=3go6kRkB0VcCdz2o6sgq_p91ZbcqWv-FZBd4hw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> The compiler does not
> have to discard what it can infer about the alignment just because you
> cast 'mem' to a type with weaker alignment constraints.
>
> Why does 'mem' need to have type 'sse_union *'? Why can't it just be
> declared as 'uint8_t *'?

Huh, I see. I'll just delete sse_union then and use uint32_t instead.

> Ewwww.  That's likely because emulator.c does:
>  #define memset __builtin_memset
> As evidenced by this issue, using the compiler's memset() in kvm-unit-tests seems
> inherently dangerous since the tests are often doing intentionally stupid things.

I'll make a separate patch to remove this from emulator.c



On Thu, May 6, 2021 at 1:11 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, May 6, 2021 at 12:14 PM Jacob Xu <jacobhxu@google.com> wrote:
> >
> > > memset() takes a void *, which it casts to an char, i.e. it works on one byte at
> > a time.
> > Huh, TIL. Based on this I'd thought that I don't need a cast at all,
> > but doing so actually results in a movaps instruction.
> > I've changed the cast back to (uint8_t *).
>
> I'm pretty sure you're just getting lucky. If 'mem' is not 16-byte
> aligned, the behavior of the code is undefined. The compiler does not
> have to discard what it can infer about the alignment just because you
> cast 'mem' to a type with weaker alignment constraints.
>
> Why does 'mem' need to have type 'sse_union *'? Why can't it just be
> declared as 'uint8_t *'? Just add a "memory" clobbers to the inline
> asm statements that use 'mem' as an SSE operand.
>
> Of course, passing it as an argument to sseeq() also implies 16-byte
> alignment. Perhaps sseeq should take uint32_t pointers as arguments
> rather than sse_union pointers. I'm not convinced that the sse_union
> buys us anything other than trouble.
