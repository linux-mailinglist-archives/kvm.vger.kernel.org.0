Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B106C9B54
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjC0GVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 02:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjC0GV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 02:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DE4422B
        for <kvm@vger.kernel.org>; Sun, 26 Mar 2023 23:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7346FB80DAE
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 06:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B863C433D2;
        Mon, 27 Mar 2023 06:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679898086;
        bh=FXVSNvSgX3uY/taNLPW6RtwU4c/uJBp2AcWeLUkYJKA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=d8FuAv65ijDpdS/TwqDPgn9gSP8cC9iI0r+FST1M20K6Vzd7JPNpQhKLCAOfeSx7N
         lQ0P/cZ5qdi0TUSxEKTk9VZrc1X4zPnGsv8BrYrnC8ZrohiGg6/Hco9h/XXlLn42AV
         QyHDtpuvykOHw428qDQYICj67MlbaLhs1+Z2eDse7sZ1/+S4O1JHL/u/YZMA9EdZiJ
         LFCk/hHtAQyF1YZG0L4nCuFYpw3QRHlykj30+BzCwigST9ZW1So/HNQXJrSFmjqd9P
         HeE6qXHNjYVif966JwrcR3/cpdPq/TN0cY2qh7dp9hyNRDFMM7JL6V3sZly8KGgBf5
         Uxn0q3pc230fQ==
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
Subject: Re: [PATCH -next v16 00/20] riscv: Add vector ISA support
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
Date:   Mon, 27 Mar 2023 08:21:22 +0200
Message-ID: <87tty6ww7x.fsf@all.your.base.are.belong.to.us>
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
> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v16
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
> Changelog V16
>  - Rebase to the latest for-next:
>    - Solve conflicts at 7, and 17
>  - Use as-instr to detect if assembler supports .option arch directive
>    and remove dependency from GAS, for both ZBB and V.
>  - Cleanup code in KVM vector
>  - Address issue reported by sparse
>  - Refine code:
>    - Fix a mixed-use of space/tab
>    - Remove new lines at the end of file

Andy,

The generic entry series was applied to for-next, which conflicts with
yours. One more spin... :-(

https://patchwork.kernel.org/project/linux-riscv/patch/20230323145924.4194-=
2-andy.chiu@sifive.com/


Bj=C3=B6rn
