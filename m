Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDD3651F11
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 11:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiLTKmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 05:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLTKmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 05:42:01 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 462A9DEAB
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 02:42:00 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 046DB2F4;
        Tue, 20 Dec 2022 02:42:41 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F34D3F71A;
        Tue, 20 Dec 2022 02:41:58 -0800 (PST)
Date:   Tue, 20 Dec 2022 10:41:55 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <Y6GRXreBu56PqCyG@monolith.localdoman>
References: <20221219185250.631503-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219185250.631503-1-coltonlewis@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Dec 19, 2022 at 06:52:50PM +0000, Colton Lewis wrote:
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.

I do think removing the loop is a good idea. I tested this patch, and when
running a single test, it makes the run 3 seconds faster on an Cortex-A53
for me - selftest-smp and selftest-vectors-kernel went from taking 12s to
9s. Doesn't make much of a difference when running all the tests (those
take for me 5m10s without the patch, 5m6.5s with the patch), but when
running a single test the 25% speed improvement is noticeable.

Though I'm not sure how you managed to get MAX_SMP to go down to 6 cores on
a 12 core machine. MAX_SMP is initialized to $(getconf _NPROCESSORS_ONLN),
so the body of the loop should never execute. I also tried it on a 6 core
machine, and MAX_SMP was 6, not 3.

Am I missing something?

Thanks,
Alex

> 
> The loop is safe to remove with no side effects. It has an explanitory
> comment explaining that it only applies to kernels <=v4.3 on arm and
> suggestion deletion when it becomes tiresome to maintain.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  scripts/runtime.bash | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9..18a8dd7 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -183,17 +183,3 @@ function run()
>  
>      return $ret
>  }
> -
> -#
> -# Probe for MAX_SMP, in case it's less than the number of host cpus.
> -#
> -# This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
