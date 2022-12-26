Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5171F656488
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 19:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiLZSMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 13:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiLZSMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 13:12:20 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F05FAE
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 10:12:16 -0800 (PST)
Date:   Mon, 26 Dec 2022 19:12:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672078335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4NvLV2ID3qQzfb9lyy35QudvVSz5KeLV7z2G9Cnlngo=;
        b=RvSbWTt82CD7poH5jiz+bxf9wKNHgQyPv/Tlg/mo5+6BHeKqaQDi5LaXmJW2RLQfPf2OZJ
        7deW0KG96py2z+PsfZs0x8XN5fwRwnXqnqcUcYHxsCxYvCbKa6EwGXHNcc9/PyHiLQSEmV
        D9HZ4/IUU3S/R9O4k15gQe3m+7YUA3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20221226181207.3ngrwv74p4pcjabe@orel>
References: <20221219185250.631503-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219185250.631503-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 06:52:50PM +0000, Colton Lewis wrote:
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
                                                                    ^ 1
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> The loop is safe to remove with no side effects. It has an explanitory
> comment explaining that it only applies to kernels <=v4.3 on arm and
> suggestion deletion when it becomes tiresome to maintain.

Removing this loop is safe if the body of the loop is not expected to
ever run, i.e. we're through testing kernels older than v4.3. But, if
MAX_SMP is getting reduced, as stated above, then that implies

 $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP

is resulting in a "exceeds max CPUs" error. If that's the case, then
the tests which configure $MAX_SMP cpus should be failing as well.

IOW, the loop should never do anything except be a pointless extra
invocation of QEMU. If it does do something, then we should understand
why.

Thanks,
drew

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
