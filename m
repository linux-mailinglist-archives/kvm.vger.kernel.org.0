Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984045631E0
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiGAKsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiGAKsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:48:13 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB238BA
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 03:48:12 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:48:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656672490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zXlrN3nFpmgIQhTgAf37F9YHqwMmPRCNvfBXuvlMA4E=;
        b=UBMMeGWXEArD/boDjdOBrAT+KBOJgY/obJqJm780J0hcJgpKyD18X9yfIk+xGGYwm4mIaG
        wnyJftO5wAuR0cHrTqHTATUZLJwAW6QhK8MnObcvxpj/r42As8LUb/JNUARtcaqxR0769v
        IOe1e3CNczd2bcNVp5OD2FHpf2Tmzq4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 26/27] lib: arm: Print test exit status
Message-ID: <20220701104809.zypqks76yeo4lit7@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-27-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-27-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 11:03:23AM +0100, Nikos Nikoleris wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The arm tests can be run under kvmtool, which doesn't emulate a chr-testdev
> device. Print the test exit status to make it possible for the runner
> scripts to pick it up when they have support for it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm/io.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index a91f116..337cf1b 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -138,6 +138,12 @@ extern void halt(int code);
>  
>  void exit(int code)
>  {
> +	/*
> +	 * Print the test return code in the format used by chr-testdev so the
> +	 * runner can pick it up if there is chr-testdev is not present.

nit: The comment isn't worded quite right...

The printed format ("EXIT: STATUS=") isn't chr-testdev's format, but it
is the format we want, because it's consistent with powerpc and s390x.
The exit code format '(code << 1) | 1' is chr-testdev's and
isa-debug-exit's exit format.

> +	 */
> +	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +
>  	chr_testdev_exit(code);
>  	psci_system_off();
>  	halt(code);
> -- 
> 2.25.1
>

Anyway,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
