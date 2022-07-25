Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13F57FE08
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 13:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiGYLGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 07:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiGYLGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 07:06:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F9E813F7E
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 04:06:09 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 996B6D6E;
        Mon, 25 Jul 2022 04:06:09 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E7263F73B;
        Mon, 25 Jul 2022 04:06:07 -0700 (PDT)
Date:   Mon, 25 Jul 2022 12:06:38 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sami.mujawar@arm.com
Subject: Re: [PATCH kvmtool 2/4] Makefile: Fix ARCH override
Message-ID: <Yt55PpZJvJXt5OlK@monolith.localdoman>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
 <20220722141731.64039-3-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722141731.64039-3-jean-philippe@linaro.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thank you for fixing this, I've come across it several times in the past.

On Fri, Jul 22, 2022 at 03:17:30PM +0100, Jean-Philippe Brucker wrote:
> Variables set on the command-line are not overridden by normal
> assignments. So when passing ARCH=x86_64 on the command-line, build
> fails:
> 
> Makefile:227: *** This architecture (x86_64) is not supported in kvmtool.
> 
> Use the 'override' directive to force the ARCH reassignment.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index f0df76f4..faae0da2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -115,11 +115,11 @@ ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
>  	  -e s/riscv64/riscv/ -e s/riscv32/riscv/)
>  
>  ifeq ($(ARCH),i386)

As far as I know, there are several versions of the x86 architecture: i386,
i486, i586 and i686.

It looks rather arbitrary to have i386 as a valid ARCH value, but not the other
ix86 versions. I wonder if we should just drop it and keep only x86 and x86_64,
like the kernel.

Regardless, the patch looks good to me:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> -	ARCH         := x86
> +	override ARCH = x86
>  	DEFINES      += -DCONFIG_X86_32
>  endif
>  ifeq ($(ARCH),x86_64)
> -	ARCH         := x86
> +	override ARCH = x86
>  	DEFINES      += -DCONFIG_X86_64
>  	ARCH_PRE_INIT = x86/init.S
>  endif
> -- 
> 2.37.1
> 
