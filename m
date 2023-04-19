Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF66E743C
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 09:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjDSHoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 03:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjDSHny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 03:43:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED6A5D5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9364662F3B
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA24C433D2;
        Wed, 19 Apr 2023 07:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681890206;
        bh=Ph+AAW24rYPBEnSvM4IgbKn1qjlAp05TGyLFtVPz7dE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OxP7OLls4SzwPY7IMv87WLFfDOQHCMYO2CpXtTAvb7oRv5oRDK6xb173pMhRPps5B
         hmH8uzn4cABQFTr+HoheMk5wRlBLdxqixEZGurk3zbCPhg1S4bfCHokukQaukGIeMq
         yKgJMmptnvkMv1jLo6FdctEEupRnDulN2ilAm71dMpxmFwFnaplz5RS94ywicJQIf+
         YMreate4oQMcbCrh/U4Rt7KMsH1jOoc6I0D0j0y54WVZNaHUbIMeARC4iWTrLzvf2u
         WVmbeKMQpLRqKQsERTy0ek6QlEYhHFg2HEegzhd3lGsdXyPuDTtbirXBgFnnn7lUrd
         NG6SdMNWRUgHg==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "GNU C Library" <libc-alpha@sourceware.org>,
        "Andrew Waterman" <andrew@sifive.com>
Subject: Re: [PATCH -next v18 00/20] riscv: Add vector ISA support
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
Date:   Wed, 19 Apr 2023 09:43:22 +0200
Message-ID: <87cz4048rp.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> This patchset is implemented based on vector 1.0 spec to add vector suppo=
rt
> in riscv Linux kernel. There are some assumptions for this implementation=
s.
>
> 1. We assume all harts has the same ISA in the system.
> 2. We disable vector in both kernel and user space [1] by default. Only
>    enable an user's vector after an illegal instruction trap where it
>    actually starts executing vector (the first-use trap [2]).
> 3. We detect "riscv,isa" to determine whether vector is support or not.
>
> We defined a new structure __riscv_v_ext_state in struct thread_struct to
> save/restore the vector related registers. It is used for both kernel spa=
ce
> and user space.
>  - In kernel space, the datap pointer in __riscv_v_ext_state will be
>    allocated to save vector registers.
>  - In user space,
> 	- In signal handler of user space, the structure is placed
> 	  right after __riscv_ctx_hdr, which is embedded in fp reserved
> 	  aera. This is required to avoid ABI break [2]. And datap points
> 	  to the end of __riscv_v_ext_state.
> 	- In ptrace, the data will be put in ubuf in which we use
> 	  riscv_vr_get()/riscv_vr_set() to get or set the
> 	  __riscv_v_ext_state data structure from/to it, datap pointer
> 	  would be zeroed and vector registers will be copied to the
> 	  address right after the __riscv_v_ext_state structure in ubuf.
>
> This patchset is rebased to v6.3-rc1 and it is tested by running several
> vector programs simultaneously. It delivers signals correctly in a test
> where we can see a valid ucontext_t in a signal handler, and a correct V
> context returing back from it. And the ptrace interface is tested by
> PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
> a guest using the same kernel image. All tests are done on an rv64gcv
> virt QEMU.
>
> Note: please apply the patch at [4] due to a regression introduced by
> commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations") before testing the series.
>
> Source tree:
> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v18

After some offlist discussions, we might have a identified a
potential libc->application ABI break.

Given an application that does custom task scheduling via a signal
handler. The application binary is not vector aware, but libc is. Libc
is using vector registers for memcpy. It's an "old application, new
library, new kernel"-scenario.

 | ...
 | struct context *p1_ctx;
 | struct context *p2_ctx;
 |=20
 | void sighandler(int sig, siginfo_t *info, void *ucontext)
 | {
 |   if (p1_running)
 |     switch_to(p1_ctx, p2_ctx);
 |   if (p2_running)
 |     switch_to(p2_ctx, p1_ctx);
 | }
 |=20
 | void p1(void)
 | {
 |   memcpy(foo, bar, 17);
 | }
 |=20
 | void p2(void)
 | {
 |   ...
 | }
 | ...

The switch_to() function schedules p1() and p2(). E.g., the
application (assumes that it) saves the complete task state from
sigcontext (ucontext) to p1_ctx, and restores sigcontext to p2_ctx, so
when sigreturn is called, p2() is running, and p1() has been
interrupted.

The "old application" which is not aware of vector, is now run on a
vector enabled kernel/glibc.

Assume that the sighandler is hit, and p1() is in the middle of the
vector memcpy. The switch_to() function will not save the vector
state, and next time p2() is scheduled to run it will have incorrect
machine state.

Now:

Is this an actual or theoretical problem (i.e. are there any
applications in the wild)? I'd be surprised if it would not be the
latter...

Regardless, a kernel knob for disabling vector (sysctl/prctl) to avoid
these kind of breaks is needed (right?). Could this knob be a
follow-up patch to the existing v18 series?

Note that arm64 does not suffer from this with SVE, because the default
vector length (vl=3D=3D0/128b*32) fits in the "legacy" sigcontext.


Bj=C3=B6rn
