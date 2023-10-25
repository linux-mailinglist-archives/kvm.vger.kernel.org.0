Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8657D661F
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbjJYJCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 05:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjJYJCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 05:02:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F3A8136;
        Wed, 25 Oct 2023 02:02:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4166F2F4;
        Wed, 25 Oct 2023 02:03:23 -0700 (PDT)
Received: from [10.57.1.178] (unknown [10.57.1.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FD503F738;
        Wed, 25 Oct 2023 02:02:39 -0700 (PDT)
Message-ID: <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com>
Date:   Wed, 25 Oct 2023 10:02:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
From:   Aishwarya TCV <aishwarya.tcv@arm.com>
In-Reply-To: <20231011195740.3349631-4-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2023 20:57, Oliver Upton wrote:
> Start generating sysreg-defs.h for arm64 builds in anticipation of
> updating sysreg.h to a version that depends on it.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 

Hi Oliver,


Currently when building kselftest against next-master with arm64 arch
and defconfig+kselftest-kvm  “make[4]: *** [Makefile:26: prepare] Error
2” is observed.

The bisect log is below and a full log from a failing test job can be
seen here:

https://storage.kernelci.org/next/master/next-20231023/arm64/defconfig/gcc-10/logs/kselftest.log

make[4]: Entering directory '/tmp/kci/linux/tools/testing/selftests/kvm'
Makefile:270: warning: overriding recipe for target
'/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
Makefile:265: warning: ignoring old recipe for target
'/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
make -C ../../../../tools/arch/arm64/tools/
make[5]: Entering directory '/tmp/kci/linux/tools/arch/arm64/tools'
Makefile:10: ../tools/scripts/Makefile.include: No such file or directory
make[5]: *** No rule to make target '../tools/scripts/Makefile.include'.
 Stop.
make[5]: Leaving directory '/tmp/kci/linux/tools/arch/arm64/tools'
make[4]: *** [Makefile:26: prepare] Error 2
make[4]: Leaving directory '/tmp/kci/linux/tools/testing/selftests/kvm'

git bisect log
git bisect start
# good: [58720809f52779dc0f08e53e54b014209d13eebb] Linux 6.6-rc6
git bisect good 58720809f52779dc0f08e53e54b014209d13eebb
# bad: [4230ea146b1e64628f11e44290bb4008e391bc24] Add linux-next
specific files for 20231019
git bisect bad 4230ea146b1e64628f11e44290bb4008e391bc24
# good: [2958944f7786b88cb86f7b3377c1a8bda75fd506] Merge branch
'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
git bisect good 2958944f7786b88cb86f7b3377c1a8bda75fd506
# good: [359cb2003c0c273b13ec11b3df076ceac95e5eda] Merge branch
'for-next' of
https://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
git bisect good 359cb2003c0c273b13ec11b3df076ceac95e5eda
# bad: [53cc85767a1dba86b892f72f18e44138ec5e3f83] Merge branch
'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux.git
git bisect bad 53cc85767a1dba86b892f72f18e44138ec5e3f83
# good: [84ceabd4408bd0bae48b58e2c18ddc5263cd5be4] Merge branch
'next-integrity' of
git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity
git bisect good 84ceabd4408bd0bae48b58e2c18ddc5263cd5be4
# good: [35c2f21c0d4a633305773355e86b41e28d835f67] Merge branch 'master'
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git bisect good 35c2f21c0d4a633305773355e86b41e28d835f67
# bad: [92a288da516dc7aaab6e92ba3de7d51c415227b1] Merge branch
'topic/ppc-kvm' of
git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git
git bisect bad 92a288da516dc7aaab6e92ba3de7d51c415227b1
# good: [5df10099418f139bbf2f4e0d7b9a8727e76274ec] srcu: Explain why
callbacks invocations can't run concurrently
git bisect good 5df10099418f139bbf2f4e0d7b9a8727e76274ec
# good: [2ca9297790bdd24b4baa6e432d393e92272f7dc5] Merge branch
kvm-arm64/writable-id-regs into kvmarm/next
git bisect good 2ca9297790bdd24b4baa6e432d393e92272f7dc5
# good: [7ae3136edc0787c890e07fbd1d16d54557644068] Merge branch
'rcu/next' of
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good 7ae3136edc0787c890e07fbd1d16d54557644068
# bad: [50a1ee6541d7c7bac0a43b773b68f20c3ffcbe67] Merge branch 'next' of
git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
git bisect bad 50a1ee6541d7c7bac0a43b773b68f20c3ffcbe67
# bad: [54a9ea73527d55ab746d5425e10f3fa748e00e70] KVM: arm64: selftests:
Test for setting ID register from usersapce
git bisect bad 54a9ea73527d55ab746d5425e10f3fa748e00e70
# good: [e2bdd172e6652c2f5554d125a5048bc9f9b0dfa3] perf build: Generate
arm64's sysreg-defs.h and add to include path
git bisect good e2bdd172e6652c2f5554d125a5048bc9f9b0dfa3
# bad: [0359c946b13153bd57fac65f4f3600ba5673e3de] tools headers arm64:
Update sysreg.h with kernel sources
git bisect bad 0359c946b13153bd57fac65f4f3600ba5673e3de
# bad: [9697d84cc3b6d9bff4b1fbffc10a4bb1398af9ba] KVM: selftests:
Generate sysreg-defs.h and add to include path
git bisect bad 9697d84cc3b6d9bff4b1fbffc10a4bb1398af9ba
# first bad commit: [9697d84cc3b6d9bff4b1fbffc10a4bb1398af9ba] KVM:
selftests: Generate sysreg-defs.h and add to include path

Thanks,
Aishwarya
