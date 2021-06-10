Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B903A3051
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhFJQRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:17:52 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:37820 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhFJQRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 12:17:52 -0400
Received: by mail-lj1-f178.google.com with SMTP id e2so5688276ljk.4
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 09:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T1W3xL4t/99LxynShZQSfyPqwxQEAUk8Mb6ODp2DP7s=;
        b=iUk9VuHToDosZMzBMlQkcAv1a4CQroRs+V7Vwj73XYMDtBXecIBGbOszwhM+EjFydZ
         jMdnw24wH0dBeFcOPf/uTFNfhzB5zE7rMe0iL4N/Vs0w+SaGB/pqLTB80RNrfYCVCW3h
         z6gdJVRY6hTcDdGwUBVOrP0z64NWDCvJ7Y1u1wQUMu3/usgfcKkFSdilbzNNmCioLerq
         7juwcm2n6v0D9YBMMIsr3kJd6JD1RQRdg86sxZykFX23HjJBq/XKu/ekzJqExojqnEVl
         4q6mRNH6VYzSp6iV4LN4Q/uzL6sCEh8ohyAHKKKFUsZsWv5rUoXlc7K2/T1+5+xpgunz
         xyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T1W3xL4t/99LxynShZQSfyPqwxQEAUk8Mb6ODp2DP7s=;
        b=eOQMk2CnR0kNdvAS0e5ASshVgYDJdPVC7PE0u0ertNmW09zeNmY3UUNtWuclT7pSx9
         9wpaxBiH6gli2tPvcOdMzLcENapmHZOH5NSexFcHYzvQ605KQjFoncjG6fFPf9FEXhq/
         5fZi+AHjbk4PeNQYKyx+rpReCmrhEDi1id9QPjapJLozs9PretMjzeRmUGSpUK/J5JtK
         BQqsNdt9uuirNmLPqFkKXt3EJ/AmS9k893aHUPk48ds1skkgKkUq6AzEatZ+Jwj1ItLX
         5B+YIFaNQtEnPbI5MkV8roTg84vgnI1N51HFpOvCOzOJbzvPRZYjDc4O2UwGrD7pLQMy
         FayA==
X-Gm-Message-State: AOAM533ZSnXZc/8+EplaMlWDCxJlKWeTOAHI3/f/31XHLLj3DBQqReBv
        NFvxMvU0jnkJTaHZ2fNleXidZixZm/d0LlJdhqx5kJXb/2YHUw==
X-Google-Smtp-Source: ABdhPJxe5obT5Vd/XBA1MBuq313MdQYvgAXyzbH1C0NCXHqQtVTBbK7Myxs3/88M1HbVGTqtxT73g+h8ZQmqzcs9z6w=
X-Received: by 2002:a05:651c:383:: with SMTP id e3mr2898119ljp.220.1623341684809;
 Thu, 10 Jun 2021 09:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210511015016.815461-1-jacobhxu@google.com>
In-Reply-To: <20210511015016.815461-1-jacobhxu@google.com>
From:   Jacob Xu <jacobhxu@google.com>
Date:   Thu, 10 Jun 2021 09:14:33 -0700
Message-ID: <CAJ5mJ6jUvHN5Mh_hVR5rArvA6aFNdhDCinQd1ZjLg=ht=J4ijw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: Do not assign values to unaligned
 pointer to 128 bits
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping (previous ping just now contained html subpart, oops).


On Mon, May 10, 2021 at 6:50 PM Jacob Xu <jacobhxu@google.com> wrote:
>
> When compiled with clang, the following statement gets converted into a
> movaps instructions.
> mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>
> Since mem is an unaligned pointer to sse_union, we get a GP when
> running. Let's avoid using a pointer to sse_union at all, since doing so
> implies that the pointer is aligned to 128 bits.
>
> Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
> emulator.c")
>
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> ---
>  x86/emulator.c | 67 +++++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 34 deletions(-)
>
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 9705073..1d5c172 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -645,37 +645,34 @@ static void test_muldiv(long *mem)
>
>  typedef unsigned __attribute__((vector_size(16))) sse128;
>
> -typedef union {
> -    sse128 sse;
> -    unsigned u[4];
> -} sse_union;
> -
> -static bool sseeq(sse_union *v1, sse_union *v2)
> +static bool sseeq(uint32_t *v1, uint32_t *v2)
>  {
>      bool ok = true;
>      int i;
>
>      for (i = 0; i < 4; ++i) {
> -       ok &= v1->u[i] == v2->u[i];
> +       ok &= v1[i] == v2[i];
>      }
>
>      return ok;
>  }
>
> -static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
> +static __attribute__((target("sse2"))) void test_sse(uint32_t *mem)
>  {
> -       sse_union v;
> +       sse128 vv;
> +       uint32_t *v = (uint32_t *)&vv;
>
>         write_cr0(read_cr0() & ~6); /* EM, TS */
>         write_cr4(read_cr4() | 0x200); /* OSFXSR */
> +       memset(&vv, 0, sizeof(vv));
>
>  #define TEST_RW_SSE(insn) do { \
> -               v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4; \
> -               asm(insn " %1, %0" : "=m"(*mem) : "x"(v.sse)); \
> -               report(sseeq(&v, mem), insn " (read)"); \
> -               mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8; \
> -               asm(insn " %1, %0" : "=x"(v.sse) : "m"(*mem)); \
> -               report(sseeq(&v, mem), insn " (write)"); \
> +               v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4; \
> +               asm(insn " %1, %0" : "=m"(*mem) : "x"(vv) : "memory"); \
> +               report(sseeq(v, mem), insn " (read)"); \
> +               mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8; \
> +               asm(insn " %1, %0" : "=x"(vv) : "m"(*mem) : "memory"); \
> +               report(sseeq(v, mem), insn " (write)"); \
>  } while (0)
>
>         TEST_RW_SSE("movdqu");
> @@ -704,40 +701,41 @@ static void cross_movups_handler(struct ex_regs *regs)
>
>  static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>  {
> -       sse_union v;
> -       sse_union *mem;
> +       sse128 vv;
> +       uint32_t *v = (uint32_t *)&vv;
> +       uint32_t *mem;
>         uint8_t *bytes = cross_mem; // aligned on PAGE_SIZE*2
>         void *page2 = (void *)(&bytes[4096]);
>         struct pte_search search;
>         pteval_t orig_pte;
>
>         // setup memory for unaligned access
> -       mem = (sse_union *)(&bytes[8]);
> +       mem = (uint32_t *)(&bytes[8]);
>
>         // test unaligned access for movups, movupd and movaps
> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> -       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
> -       report(sseeq(&v, mem), "movups unaligned");
> -
> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> -       asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
> -       report(sseeq(&v, mem), "movupd unaligned");
> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
> +       mem[0] = 5; mem[1] = 6; mem[2] = 8; mem[3] = 9;
> +       asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
> +       report(sseeq(v, mem), "movups unaligned");
> +
> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
> +       mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
> +       asm("movupd %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
> +       report(sseeq(v, mem), "movupd unaligned");
>         exceptions = 0;
>         handle_exception(GP_VECTOR, unaligned_movaps_handler);
>         asm("movaps %1, %0\n\t unaligned_movaps_cont:"
> -                       : "=m"(*mem) : "x"(v.sse));
> +                       : "=m"(*mem) : "x"(vv));
>         handle_exception(GP_VECTOR, 0);
>         report(exceptions == 1, "unaligned movaps exception");
>
>         // setup memory for cross page access
> -       mem = (sse_union *)(&bytes[4096-8]);
> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +       mem = (uint32_t *)(&bytes[4096-8]);
> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
> +       mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
>
> -       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
> -       report(sseeq(&v, mem), "movups unaligned crosspage");
> +       asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
> +       report(sseeq(v, mem), "movups unaligned crosspage");
>
>         // invalidate second page
>         search = find_pte_level(current_page_table(), page2, 1);
> @@ -747,7 +745,8 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>
>         exceptions = 0;
>         handle_exception(PF_VECTOR, cross_movups_handler);
> -       asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(v.sse));
> +       asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(vv) :
> +                       "memory");
>         handle_exception(PF_VECTOR, 0);
>         report(exceptions == 1, "movups crosspage exception");
>
> --
> 2.31.1.607.g51e8a6a459-goog
>
