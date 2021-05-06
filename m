Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F504375891
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbhEFQlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhEFQlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:41:11 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E5CC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 09:40:13 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id c12-20020a4ae24c0000b02901bad05f40e4so1381273oot.4
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WoWdcVhaKgBx8aRDpUOXmoHORz3RdCxP4DX2bATlIbs=;
        b=blzRXHNVROgJET/HSvhddWHBX4YHJaKfWaDhmM7OKpQlGyIb9CKIo7Hg/3LybOrmxL
         e9i6Sff1GJfXcvg+XoIhqQIOvv/8+LlCKN65iAYVtu2XkEmxHnuX1j/woGHVSKHJvEpl
         VnLVG39Okto6j6O+iFzPQMY1HCapSaMfWR1/0g5QCqjpZTIRCewbX7Iz1bTzOLV5VGAm
         XGPKbeSXWzDHoAwLnOeOTd0aehB70lCT1ShAdmnBGn4od7LKy5gl1dybixv7r3uJi2+z
         bTN6boryNHGmYG6hOw9RtJVrTs+/0xzW+VeIzZNnl4n6FHHIovtI4Upt+dohLyxqQXEe
         jz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WoWdcVhaKgBx8aRDpUOXmoHORz3RdCxP4DX2bATlIbs=;
        b=ZCAHI/xSDTKG2EDRh5jtL1mBUFJo6d0d9daHspn3kJGlkPhboCUhKqjSp80EAMgW5G
         qQHRWLypAxfJDdgUVEQzNN6Xi+wRm7xP8t5+2gpVK7WHOHLhXrVi9W/YVc/2tYHgbO+2
         +oOMcsFWaa0WbWKefoSOv3XTrwTpFsfy2TYNHJ7GCFNVOsxrWD47PaX5Pzv37IMcj4EB
         zMNKXKfwbVkoQp4WGAIfeoPkzIhcveKsVYaXe5hdjgUzsD5nWToR/cIzMgLIFu/ga3kq
         W/0mazSlnE+L/aDXw5jFnvxrpYwb3Y9obEP/VgNsWeO/3Ayx59V5JQCFEQEww2heSdYa
         ZtFg==
X-Gm-Message-State: AOAM531BzZIIjKMKZIBodsNvwq21/AUvs60WsdbAKCoPBAJv1jq9Go/9
        5I22X22yrgMI4WsUeZcDKcqiJRlyi0shzSft9OuorA==
X-Google-Smtp-Source: ABdhPJw79HSZTWuUu/dLWQ/Am8k3vorS6YbEPro+IuQPDXMzbvl/f0Sv95goJkHQE4sf7qWKeP/t7f0D3YULMqQ2XzI=
X-Received: by 2002:a05:6820:100a:: with SMTP id v10mr936579oor.55.1620319212570;
 Thu, 06 May 2021 09:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210506004847.210466-1-jacobhxu@google.com> <YJQSx9vb1lT3P79j@google.com>
In-Reply-To: <YJQSx9vb1lT3P79j@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 May 2021 09:40:01 -0700
Message-ID: <CALMp9eSWA+KKA93fdyX7o+rEPogP-QJvY+CADTnDPXmCoEg1Yw@mail.gmail.com>
Subject: Re: [PATCH] x86: Do not assign values to unaligned pointer to 128 bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jacob Xu <jacobhxu@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 9:01 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Please use [kvm-unit-tests PATCH ...] for the subject, it took me a depressingly
> long time to figure out which code base this applied to (though admittedly there
> was a non-zero amount of PEBKAC going on).
>
> On Wed, May 05, 2021, Jacob Xu wrote:
> > When compiled with clang, the following statement gets converted into a
> > movaps instructions.
> > mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> >
> > Since mem is an unaligned pointer to a union of an sse, we get a GP when
> > running.
> >
> > All we want is to make the values between mem and v different for this
> > testcase, so let's just memset the pointer at mem, and convert to
> > uint8_t pointer. Then the compiler will not assume the pointer is
> > aligned to 128 bits.
> >
> > Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
> > emulator.c")
> >
> > Signed-off-by: Jacob Xu <jacobhxu@google.com>
> > ---
> >  x86/emulator.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/x86/emulator.c b/x86/emulator.c
> > index 9705073..672bfda 100644
> > --- a/x86/emulator.c
> > +++ b/x86/emulator.c
> > @@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
> >
> >       // test unaligned access for movups, movupd and movaps
> >       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> > -     mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> > +     memset((uint8_t *)mem, 0, 128);
>
> Shouldn't this be '16', as in 16 bytes / 128 bits?  And would it makes sense to
> use a pattern other than '0', if only for giggles?

Or possibly sizeof(*mem)?
