Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E97375B83
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 21:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhEFTPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 15:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbhEFTPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 15:15:10 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68130C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 12:14:10 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p12so8482884ljg.1
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 12:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=teGSJavUceBIyaezAgy8ShryTq9123TcwoLgFekHYSo=;
        b=pYBg9u17s8LiP5KKBAomMJPNdr9v2aLWpvwR33XER0lW97+r81u2wsdS1hWrSBVGRc
         hkl/NOjCaABScNL+q4EJd4berJih8mn1/kBN4gKg+Rl8VXuKF0tZY/WCD9pQbpO/6GqO
         Bc8uA6iy5eHTfpLiEAPpMpCPin2lXixOc5hL1O0p+oErlKzV0/bvi0YuoLO2VEPnPE1O
         yuKE8M2wpe5NLXbAXYRypTriNqvOd7plxsDNA+8IsLIja+aamgOSLpuDn9tnTQqjub1Z
         YDKlvJf/Mfvq0aGOzGwB7x45WiRhJ0nopdZmFXONe2mOK7KCHlesi0BWGDmDWpKJMcgY
         o7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teGSJavUceBIyaezAgy8ShryTq9123TcwoLgFekHYSo=;
        b=E+t3ZuHgXS0R3vhatq3FDr93Hxjfg4aqoIJ0i3wshnsIjqQqL9p/CB4iUha7zbpJWa
         gRjjNWYpwbAb8NHzfsRH21Oq0btIgcyqk7M+nJe07pQ93xdEkBEdxE7eJRurA7G2q+pB
         5FU9wLHEV/o2swfV9K8B9HPAr/7xfO8fde+z4gnxmDE6jeYXCAnge0mOgjylPX/tFDjC
         l9rZ7t0TiM8ylOFrrcnTqrhyZyS5D/sDIVwKMl5EoednXTPeoFu4u8YVOmeTTuSWh3yC
         Y/MJKWHvwy8+e7h/2S4S+V1L6b1WqFF/l2sX+upsev8Oaqf3xXfT/NlhTl9IQGsosEE4
         JIgA==
X-Gm-Message-State: AOAM5309VM0mJmNJpInEIYsYGwpPUzOa3sloPEwXxaaAZ2YwuacIwMk0
        EmG0ihibIi04gsFbaSHDMouSDpx1D7NWM79+Jf84Lg==
X-Google-Smtp-Source: ABdhPJypH+StdnTDoDHOxEtGsJooPgOX5pEyHi3etKk2m3Qp2hLJtPjG+a34+0AAjGvUyiN4PLVP7oPUxGVOEtaBV08=
X-Received: by 2002:a2e:b4a9:: with SMTP id q9mr2069683ljm.167.1620328448732;
 Thu, 06 May 2021 12:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210506184925.290359-1-jacobhxu@google.com> <YJQ8NN6EzzZEiJ6a@google.com>
In-Reply-To: <YJQ8NN6EzzZEiJ6a@google.com>
From:   Jacob Xu <jacobhxu@google.com>
Date:   Thu, 6 May 2021 12:13:57 -0700
Message-ID: <CAJ5mJ6gYmwXEQZASk8A_Ozt6asW6ZDTnDs83nCfLNTa62x7n+g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> memset() takes a void *, which it casts to an char, i.e. it works on one byte at
a time.
Huh, TIL. Based on this I'd thought that I don't need a cast at all,
but doing so actually results in a movaps instruction.
I've changed the cast back to (uint8_t *).

> The size needs to be sizeof(*mem)
Bah, thanks for catching that.

I've updated it below.
---
 x86/emulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 9705073..ea23ef1 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void
test_sse_exceptions(void *cross_mem)

        // test unaligned access for movups, movupd and movaps
        v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+       memset((uint8_t *)mem, 5, sizeof(*mem));
        asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
        report(sseeq(&v, mem), "movups unaligned");

        v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+       memset((uint8_t *)mem, 5, sizeof(*mem));
        asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
        report(sseeq(&v, mem), "movupd unaligned");
        exceptions = 0;
@@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void
test_sse_exceptions(void *cross_mem)
        // setup memory for cross page access
        mem = (sse_union *)(&bytes[4096-8]);
        v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+       memset((uint8_t *)mem, 5, sizeof(*mem));

        asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
        report(sseeq(&v, mem), "movups unaligned crosspage");
--


On Thu, May 6, 2021 at 11:58 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, May 06, 2021, Jacob Xu wrote:
> > When compiled with clang, the following statement gets converted into a
> > movaps instructions.
> > mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> >
> > Since mem is an unaligned pointer to a union of an sse, we get a GP when
> > running.
> >
> > All we want is to make the values between mem and v different for this
> > testcase, so let's just memset the pointer at mem, and convert to
> > uint32_t pointer. Then the compiler will not assume the pointer is
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
> > index 9705073..a2c7e5b 100644
> > --- a/x86/emulator.c
> > +++ b/x86/emulator.c
> > @@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
> >
> >       // test unaligned access for movups, movupd and movaps
> >       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> > -     mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> > +     memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
>
> memset() takes a void *, which it casts to an char, i.e. it works on one byte at
> a time.  Casting to a uint32_t won't make it write the full "0xdecafbad", it will
> just repease 0xad over and over.
>
> The size needs to be sizeof(*mem), i.e. the size of the object that mem points to,
> not the size of the pointer's storage.
>
> >       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
> >       report(sseeq(&v, mem), "movups unaligned");
> >
> >       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> > -     mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> > +     memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
> >       asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
> >       report(sseeq(&v, mem), "movupd unaligned");
> >       exceptions = 0;
> > @@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
> >       // setup memory for cross page access
> >       mem = (sse_union *)(&bytes[4096-8]);
> >       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> > -     mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> > +     memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
> >
> >       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
> >       report(sseeq(&v, mem), "movups unaligned crosspage");
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
