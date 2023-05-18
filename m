Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C62A708596
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjERQGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjERQGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:06:39 -0400
Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7408FF7
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:06:37 -0700 (PDT)
Date:   Thu, 18 May 2023 18:06:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684425995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KHGguFp+orUyyeGUiq903ZvHKiCDRzmx4cH7McznNKM=;
        b=JMei6YcyuQd3irjiVZHAGYMGwYB+IjxvE5FJo/Sx6/SIggPXHwYhBj0EdK/Mfnw/RhnCCO
        pPSk8cqV5Vdvgc0F5IC73wDo08rrzdIZv4gGJxMTQPOxs/hOWTfWDne1Htkzt14wOZsGtM
        u/8a98qcafuwA0fIA+jAo3nXBMYskAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, luc.maranget@inria.fr
Subject: Re: [kvm-unit-tests PATCH] arm64: Make vector_table and vector_stub
 weak symbols
Message-ID: <20230518-d8bd66e7bf671f5df706a216@orel>
References: <20230515221517.646549-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515221517.646549-1-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 15, 2023 at 11:15:17PM +0100, Nikos Nikoleris wrote:
> This changes allows a test to define and override the declared symbols,
> taking control of the whole vector_table or a vector_stub.

Hi Nikos,

Can you add some motivation for this change to the commit message or
submit it along with some test that needs it?

Thanks,
drew

> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/cstart64.S | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index e4ab7d06..eda0daa5 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -275,8 +275,11 @@ exceptions_init:
>  /*
>   * Vector stubs
>   * Adapted from arch/arm64/kernel/entry.S
> + * Declare as weak to allow external tests to redefine and override a
> + * vector_stub.
>   */
>  .macro vector_stub, name, vec
> +.weak \name
>  \name:
>  	stp	 x0,  x1, [sp, #-S_FRAME_SIZE]!
>  	stp	 x2,  x3, [sp,  #16]
> @@ -369,7 +372,13 @@ vector_stub	el0_error_32, 15
>  	b	\label
>  .endm
>  
> +
> +/*
> + * Declare as weak to allow external tests to redefine and override the
> + * default vector table.
> + */
>  .align 11
> +.weak vector_table
>  vector_table:
>  	ventry	el1t_sync			// Synchronous EL1t
>  	ventry	el1t_irq			// IRQ EL1t
> -- 
> 2.25.1
> 
