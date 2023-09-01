Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D529F78F92B
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbjIAHfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbjIAHfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:35:53 -0400
Received: from out-235.mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F7310D2
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:35:50 -0700 (PDT)
Date:   Fri, 1 Sep 2023 09:35:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693553749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uSTkpiBeyJOSrDyBqH5u+QE0xVO5xgn5RZNE7JKVcac=;
        b=YunA2qSYy4vcIkBJ5DQbT7RYLD/OWgVFsES3gy7S0S3TpjGK/GdAZrCZgktwl4SABbAmV4
        v8IwiGnGXpVDM/6UsvuPyoH+He74lAdYDdEYiIWvqsGO/7CEIAE9D5BfBWG1uCUjeyVAco
        dRtzNx/jHIO+Bak/lzkbHN1MJvP+T0A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, qemu-trivial@nongnu.org
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Message-ID: <20230901-16232ff17690fc32a0feb5df@orel>
References: <20230831190052.129045-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831190052.129045-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 07:00:52PM +0000, Colton Lewis wrote:
> Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> in unintended trap and emulate access and a consequent performance
> hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> access.
> 
> Quoting Andrew Jones:
> 
> Simply reading the CNT register and writing back the same value is
> enough to set an offset, since the timer will have certainly moved
> past whatever value was read by the time it's written.  QEMU
> frequently saves and restores all registers in the get-reg-list array,
> unless they've been explicitly filtered out (with Linux commit
> 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> restore trapless ptimer accesses, we need a QEMU patch to filter out
> the register.
> 
> See
> https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9

The link can be shorter with

https://lore.kernel.org/all/20230823200408.1214332-1-coltonlewis@google.com/

> for additional context.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Thanks for the testing and posting, Colton. Please add your s-o-b and a
Tested-by tag as well.

Thanks,
drew

> ---
>  target/arm/kvm64.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 4d904a1d11..2dd46e0a99 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
>   */
>  static const CPRegStateLevel non_runtime_cpregs[] = {
>      { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
>  };
>  
>  int kvm_arm_cpreg_level(uint64_t regidx)
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
