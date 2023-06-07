Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3240472693B
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjFGSxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjFGSxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:53:21 -0400
Received: from out-28.mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1321BD8
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:53:19 -0700 (PDT)
Date:   Wed, 7 Jun 2023 20:53:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686163997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uZriKRSNBbzvJHJtIENKwxHY6qma95a+SzevJ1d0sZU=;
        b=Obvn7QhCH0nPk/AqET+xjZel4gBk1D7AgZS9WWgfpiUTvNwdwQaWpmCeFyRxMMbq6JLlVM
        wyryjmNPVs9na3YDvP+vJdPecKr4NsE/ZJTXINNu9i5hv9oQnI7C2cvnLqNwDAorOPymkG
        EcQpDG0gT/MKF4nKRsinTqu6Ir5L7zw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Make vector_table and
 vector_stub weak symbols
Message-ID: <20230607-5a5ef657ae5d4c001b388b26@orel>
References: <20230523135325.1081036-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523135325.1081036-1-nikos.nikoleris@arm.com>
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

On Tue, May 23, 2023 at 02:53:25PM +0100, Nikos Nikoleris wrote:
> This changes allows a test to define and override the declared symbols,
> taking control of all or some execptions.
> 
> With the ability to override specific exception handlers, litmus7 [1] a
> tool used to generate c sources for a given memory model litmus test,
> can override the el1h_sync symbol to implement tests with explicit
> exception handlers. For example:
> 
> AArch64 LDRv0+I2V-dsb.ishst-once
> {
>   [PTE(x)]=(oa:PA(x),valid:0);
>   x=1;
> 
>   0:X1=x;
>   0:X3=PTE(x);
>   0:X2=(oa:PA(x),valid:1);
> }
>  P0          | P0.F           ;
> L0:          | ADD X8,X8,#1   ;
>  LDR W0,[X1] | STR X2,[X3]    ;
>              | DSB ISHST      ;
>              | ADR X9,L0      ;
>              | MSR ELR_EL1,X9 ;
>              | ERET           ;
> exists(0:X0=0 \/ 0:X8!=1)
> 
> In this test, a thread running in core P0 executes a load to a memory
> location x. The PTE of the virtual address x is initially invalid.  The
> execution of the load causes a synchronous EL1 exception which is
> handled by the code in P0.F. P0.F increments a counter which is
> maintained in X8, updates the PTE of x and makes it valid, executes a
> DSB ISHST and calls ERET which is expected to return and retry the
> execution of the load in P0:L0.
> 
> The postcondition checks if there is any execution where the load wasn't
> executed (X0 its destination register is not update), or that the P0.F
> handler was invoked more than once (the counter X8 is not 1).
> 
> For this tests, litmus7 needs to control the el1h_sync. Calling
> install_exception_handler() would be suboptimal because the
> vector_stub would wrap around the code of P0.F and perturb the test.
> 
> [1]: https://diy.inria.fr/doc/litmus.html
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

Applied to arm/queue. Thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
