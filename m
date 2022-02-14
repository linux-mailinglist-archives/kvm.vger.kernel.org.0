Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724624B4E77
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351493AbiBNLcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:32:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351933AbiBNLay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39DAD66CBD
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 03:14:23 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E87241042;
        Mon, 14 Feb 2022 03:14:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 028B43F718;
        Mon, 14 Feb 2022 03:14:21 -0800 (PST)
Date:   Mon, 14 Feb 2022 11:14:43 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] x86 UEFI: Fix broken build for UEFI
Message-ID: <Ygo5o7+j1ALOSwtY@monolith.localdoman>
References: <20220210092044.18808-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210092044.18808-1-zhenzhong.duan@intel.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 10, 2022 at 05:20:44PM +0800, Zhenzhong Duan wrote:
> UEFI loads EFI applications to dynamic runtime addresses, so it requires
> all applications to be compiled as PIC (position independent code).
> 
> The new introduced single-step #DB tests series bring some compile time
> absolute address, fixed it with RIP relative address.

With this patch the error:

ld: x86/debug.o: relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC

disappears and I can now build kvm-unit-tests for x86_64 when configured
with --target-efi:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Fixes: 9734b4236294 ("x86/debug: Add framework for single-step #DB tests")
> Fixes: 6bfb9572ec04 ("x86/debug: Test IN instead of RDMSR for single-step #DB emulation test")
> Fixes: bc0dd8bdc627 ("x86/debug: Add single-step #DB + STI/MOVSS blocking tests")
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  x86/debug.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/debug.c b/x86/debug.c
> index 20ff8ebacc16..13d1f9629e1d 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -145,7 +145,7 @@ static unsigned long singlestep_basic(void)
>  		"and $~(1<<8),%%rax\n\t"
>  		"1:push %%rax\n\t"
>  		"popf\n\t"
> -		"lea 1b, %0\n\t"
> +		"lea 1b(%%rip), %0\n\t"
>  		: "=r" (start) : : "rax"
>  	);
>  	return start;
> @@ -186,7 +186,7 @@ static unsigned long singlestep_emulated_instructions(void)
>  		"movl $0x3fd, %%edx\n\t"
>  		"inb %%dx, %%al\n\t"
>  		"popf\n\t"
> -		"lea 1b,%0\n\t"
> +		"lea 1b(%%rip),%0\n\t"
>  		: "=r" (start) : : "rax", "ebx", "ecx", "edx"
>  	);
>  	return start;
> @@ -223,7 +223,7 @@ static unsigned long singlestep_with_sti_blocking(void)
>  		"1:and $~(1<<8),%%rax\n\t"
>  		"push %%rax\n\t"
>  		"popf\n\t"
> -		"lea 1b,%0\n\t"
> +		"lea 1b(%%rip),%0\n\t"
>  		: "=r" (start_rip) : : "rax"
>  	);
>  	return start_rip;
> @@ -259,7 +259,7 @@ static unsigned long singlestep_with_movss_blocking(void)
>  		"and $~(1<<8),%%rax\n\t"
>  		"1: push %%rax\n\t"
>  		"popf\n\t"
> -		"lea 1b,%0\n\t"
> +		"lea 1b(%%rip),%0\n\t"
>  		: "=r" (start_rip) : : "rax"
>  	);
>  	return start_rip;
> @@ -302,7 +302,7 @@ static unsigned long singlestep_with_movss_blocking_and_icebp(void)
>  		"1:and $~(1<<8),%%rax\n\t"
>  		"push %%rax\n\t"
>  		"popf\n\t"
> -		"lea 1b,%0\n\t"
> +		"lea 1b(%%rip),%0\n\t"
>  		: "=r" (start) : : "rax"
>  	);
>  	return start;
> @@ -346,7 +346,7 @@ static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
>  		"and $~(1<<8),%%rax\n\t"
>  		"push %%rax\n\t"
>  		"popf\n\t"
> -		"lea 1b,%0\n\t"
> +		"lea 1b(%%rip),%0\n\t"
>  		: "=r" (start_rip) : : "rax"
>  	);
>  	return start_rip;
> -- 
> 2.25.1
> 
