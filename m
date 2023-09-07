Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9425797CDF
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 21:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbjIGTjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbjIGTjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 15:39:19 -0400
X-Greylist: delayed 464 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 12:39:10 PDT
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED08F1BE9
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 12:39:10 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id CAA891FE03;
        Thu,  7 Sep 2023 22:32:08 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id D8932266E5;
        Thu,  7 Sep 2023 22:31:20 +0300 (MSK)
Message-ID: <7d3615d0-d501-a28c-eebc-b3f7a599fc23@tls.msk.ru>
Date:   Thu, 7 Sep 2023 22:31:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Content-Language: en-US
To:     Colton Lewis <coltonlewis@google.com>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        qemu-trivial@nongnu.org, qemu-stable <qemu-stable@nongnu.org>
References: <20230831190052.129045-1-coltonlewis@google.com>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <20230831190052.129045-1-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

31.08.2023 22:00, Colton Lewis wrote:
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
> for additional context.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   target/arm/kvm64.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 4d904a1d11..2dd46e0a99 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
>    */
>   static const CPRegStateLevel non_runtime_cpregs[] = {
>       { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
>   };
>   
>   int kvm_arm_cpreg_level(uint64_t regidx)

While this patch itself is one-liner and trivial and all, I'd rather
not apply this to the trivial-patches tree, - it requires a little
bit more than trivial expertise in this area.

So basically, ping for qemu-arm@ ? :)

Thanks,

/mjt
