Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2987696E56
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 21:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjBNUSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 15:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjBNUSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 15:18:36 -0500
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CFF1DB8C
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 12:18:35 -0800 (PST)
Date:   Tue, 14 Feb 2023 21:18:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676405913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZWvHAE3AfHijPUYYwDdENkgr8zhxS3Wmlnay/ly7FA=;
        b=FHqbdBDiHu8GtKvzSunGVJdy78W1/MQgTwzhqVhTr+WEVzmnGC7u3/8AuASP1wNx3zER8w
        H4sKnLDbBxDJ36Z0Qa0xiqI0r3pr+7ImNd+YEmbNACVr+zHxfCCJZNPaB5upsbSNMbzV4J
        D2A/JzEUzf1vDf3UV6yZZifOe9hTTwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v6 0/2] arm: Add PSCI CPU_OFF test
Message-ID: <20230214201832.qtzatjfomh3cxtgd@orel>
References: <20230203162353.34876-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203162353.34876-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023 at 04:23:51PM +0000, Alexandru Elisei wrote:
> The series adds a test for the PSCI function CPU_OFF. The test is
> implemented in patch #2, "arm/psci: Add PSCI CPU_OFF test case".  Patch #1,
> "arm/psci: Test that CPU 1 has been successfully brought online" is a
> preparatory patch to allow the CPU_OFF test to run after the CPU_ON test.
> Executing the CPU_OFF test after the CPU_ON test makes the most sense,
> since CPU_OFF requires all the CPUs to be brought online before the test
> can execute, and this is exactly what the CPU_ON test does.
> 
> I believe that proving that a CPU has been successfully offlined is an
> undecidable problem - it might just be that the CPU is stuck at a higher
> exception level doing something else entirely, and if the test were to wait
> long enough, the CPU would return from the CPU_OFF call and start executing
> code, thus failing to be offlined. Right now, the test waits for 100ms
> after checking that all the other CPUs are offline. I thought this was a
> good balance between making the test fast and being reasonably sure that
> the offline succeeded. I'm open to suggestions here if anyone thinks
> otherwise.
> 
> Tested for both the arm and arm64 architectures: on an x86 machine (qemu
> with TCG), and a rockpro64 (qemu and kvmtool).
> 
> And Nikita is not longer at Arm, and I don't have a new email address where
> she can be reached, so I didn't CC her.
> 
> Changelog:
> 
> v5 -> v6:
> - Added Reviewed-by tag to #1 (Drew).
> - Fixed the unintended change that added the argc/argv arguments to main()
>   in #2 (Drew).
> - Fixed bailing early when all secondaries are offline in #2 (Drew).
> - Run the cpu-off test only if some of the secondaries are not idling
>   instead if cpu-on has failed (cpu-on can fail for other reasons too)
>   (Drew).
> 
> v4 -> v5:
> - Open code smp_prepare_secondary in psci.c instead of exposing it as a
>   library function in the cpu_on test (Drew).
> - Don't return early if a CPU failed to online CPU1 in the cpu_on test, and
>   check the return values for the CPUs that succeeded to online CPU 1
>   (Drew).
> - Drop cpu_off_success in the cpu_off test in favour of checking
>   AFFINITY_INFO and the cpu idle mask (Drew).
> - Hopefully made the cpu_off test faster (Drew).
> 
> v3 -> v4:
> - Moved ownership of the series to Alexandru Elisei. All bugs are mine.
> - Moved the timeout for the CPU_ON test to patch #1.
> - Changed the include order for arm/psic.c in patch #1 to order the headers
>   alphabetically.
> - Run the CPU_OFF test only if CPU_ON succeeds, because CPU_OFF expects all
>   CPUs to be online, the test would otherwise hang forever.
> - Minor style changes here and there.
> 
> v2 -> v3:
> - Add timeout so that test does not hang if CPU1 fails to come online
> - Remove unnecessary call of on_cpus() in the condition where target CPU is not online.
> 
> v1 -> v2:
> - Modify PSCI CPU_ON test to ensure CPU 1 remains online after the execution of the test.
> - Addition of PSCI CPU_OFF test and calling it after PSCI CPU_ON test has been executed.
> 
> Alexandru Elisei (1):
>   arm/psci: Test that CPU 1 has been successfully brought online
> 
> Nikita Venkatesh (1):
>   arm/psci: Add PSCI CPU_OFF test case
> 
>  arm/psci.c        | 138 +++++++++++++++++++++++++++++++++++++++++-----
>  lib/arm/asm/smp.h |   9 ++-
>  lib/arm/smp.c     |   4 --
>  lib/errata.h      |   2 +
>  4 files changed, 134 insertions(+), 19 deletions(-)
> 
> 
> base-commit: 2480430a36102f8ea276b3bfb1d64d5dacc23b8f
> -- 
> 2.39.1
>

Applied, thanks
