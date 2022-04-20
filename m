Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E298508ECB
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381278AbiDTRq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381268AbiDTRqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:46:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B284473A0
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A58B82149
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797EBC385A0;
        Wed, 20 Apr 2022 17:44:03 +0000 (UTC)
Date:   Wed, 20 Apr 2022 18:44:00 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 10/10] arm64: Use WFxT for __delay() when possible
Message-ID: <YmBGYLpaJJ3OZMQV@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
 <20220419182755.601427-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-11-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 07:27:55PM +0100, Marc Zyngier wrote:
> Marginally optimise __delay() by using a WFIT/WFET sequence.
> It probably is a win if no interrupt fires during the delay.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/lib/delay.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index 1688af0a4c97..5b7890139bc2 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -27,7 +27,17 @@ void __delay(unsigned long cycles)
>  {
>  	cycles_t start = get_cycles();
>  
> -	if (arch_timer_evtstrm_available()) {
> +	if (cpus_have_const_cap(ARM64_HAS_WFXT)) {
> +		u64 end = start + cycles;
> +
> +		/*
> +		 * Start with WFIT. If an interrupt makes us resume
> +		 * early, use a WFET loop to complete the delay.
> +		 */
> +		wfit(end);
> +		while ((get_cycles() - start) < cycles)
> +			wfet(end);

Do you use WFET here as a pending interrupt would cause WFIT to complete
immediately?

> +	} else 	if (arch_timer_evtstrm_available()) {

Nit: two spaces between else and if ;).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
