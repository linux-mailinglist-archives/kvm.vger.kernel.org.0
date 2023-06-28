Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2964A741033
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjF1Lkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjF1Lka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 07:40:30 -0400
Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A8C2D59
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:40:26 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:40:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687952424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T42XXTPlA/u7vCJ89unfBNk6XLUFAADuVLoneR5wo+E=;
        b=KCPrdNnhyNXAuTSJsgftkIEon/E+Ter3yhK1Ene2LaoPdz00Qoa8Zg9gbDge1NrjBRNNzI
        bsRKK4+FHIlocS60UcDWFOoPp99afkgQpGg7rPrSFgT4NI0rJI2FreOt8WR7jlC2L0xnrL
        WYchhcrJpHnTaWY9AE3A6OhLwrAFL50=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] arm64: timer: ignore ISTATUS with
 disabled timer
Message-ID: <20230628-1a712a9e7c4710acaa744f52@orel>
References: <20230615003832.161134-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615003832.161134-1-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 05:38:32PM -0700, Nadav Amit wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> According to ARM specifications for the vtimer (CNTV_CTL_EL0): "When the
> value of the ENABLE bit is 0, the ISTATUS field is UNKNOWN."
> 
> Currently the test, however, does check that ISTATUS is cleared when the
> ENABLE bit is zero. Remove this check as the value is unknown.

Hmm, does it? timer_pending() is

 /* Check that the timer condition is met. */
 static bool timer_pending(struct timer_info *info)
 {
        return (info->read_ctl() & ARCH_TIMER_CTL_ENABLE) &&
                (info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
 }

which I would expect to short-circuit when ENABLE is zero.

Thanks,
drew

> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  arm/timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 2cb8051..0b976a7 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -256,7 +256,7 @@ static void test_timer_pending(struct timer_info *info)
>  	set_timer_irq_enabled(info, true);
>  
>  	report(!info->irq_received, "no interrupt when timer is disabled");
> -	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
> +	report(gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
>  			"interrupt signal no longer pending");
>  
>  	info->write_cval(now - 1);
> -- 
> 2.34.1
> 
