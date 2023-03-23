Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571996C6591
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjCWKrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjCWKr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E2522A2C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E666D625A8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4336C433EF;
        Thu, 23 Mar 2023 10:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679568297;
        bh=FC284fe1reOFExtyK7FiUWEHEjvzt4Zx9HsDnW61qPk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fKuzo6CpZnPgIL5G4ThNKt9biwu09hhGZp2K8qRTYo5cUktc74MPnFoIRBIG0WPq6
         SJ9swzV0Xhz7ltvvtqcZxKP+XssAUUwSpASyWyqn7J0/vsoW9jLNv4GY0/RTsICUYJ
         a5Va/67NYD9t6RiaxopNusxwus9WOXcRNHECher7PICjw3F5vOCZW2l6ThCbkUZGyE
         XYL6VgRqPkUbPX/xfOcZJ3WCuo3I0SC7hVHReqHS5dz+T0/+s1r5UtiQ7FZn+fQM/Q
         h5lkhQgN7ULebrzVUoyo1fwWMuVZx43j0fF4+eME60RUR3xQV4KQ3nT7zym8B0X3l8
         PMPgHIex2tLKA==
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
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH -next v15 00/19] riscv: Add vector ISA support
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
Date:   Thu, 23 Mar 2023 11:44:54 +0100
Message-ID: <874jqb4uhl.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
> 2. We disable vector in both kernel andy user space [1] by default. Only
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
> Specail thanks to Conor and Vineet for kindly giving help on- and off-lis=
t.
>
> Source tree:
> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v15
>
> Links:
>  - [1] https://lore.kernel.org/all/20220921214439.1491510-17-stillson@riv=
osinc.com/
>  - [2] https://lore.kernel.org/all/73c0124c-4794-6e40-460c-b26df407f322@r=
ivosinc.com/T/#u
>  - [3] https://lore.kernel.org/all/20230128082847.3055316-1-apatel@ventan=
amicro.com/
>  - [4] https://lore.kernel.org/all/CAHk-=3DwiAxtKyxs6BPEzirrXw1kXJ-7ZyGpg=
OrbzhmC=3Dud-6jBA@mail.gmail.com/
> ---
> Changelog V15
>  - Rebase to risc-v -next (v6.3-rc1)
>  - Make V depend on FD in Kconfig according to the spec and shut off v
>    properly.
>  - Fix a syntax error for clang build. But mark RISCV_ISA_V GAS only due
>    to https://reviews.llvm.org/D123515
>  - Use scratch reg in inline asm instead of t4.
>  - Refine code.
>  - Cleanup per-patch changelogs.

Andy, I think the series is in a good shape! Thanks for the hard work!

To summarize; AFAIU the outstanding issues are:

 * sparse, patch 13
 * Anup's KVM comments, patch 18
 * Nathan's suggestion, patch 19

Anything else? If not, it would be amazing for a quick v16 turnaround,
addressing the points above. Hopefully the next version can land in the
upcoming release.


Bj=C3=B6rn
