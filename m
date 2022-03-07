Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91F94CFC7F
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiCGLSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241965AbiCGLRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:17:53 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7520B6A03D
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 02:42:51 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4FBBED1;
        Mon,  7 Mar 2022 02:42:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 356213F73D;
        Mon,  7 Mar 2022 02:42:50 -0800 (PST)
Date:   Mon, 7 Mar 2022 10:43:20 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Dongli Si <sidongli1997@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] x86: Fixed Unable to execute init process since
 glibc version 2.33
Message-ID: <YiXhtZGFJ68qJeyn@monolith.localdoman>
References: <20220226060048.3-1-sidongli1997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226060048.3-1-sidongli1997@gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sat, Feb 26, 2022 at 02:00:48PM +0800, Dongli Si wrote:
> From: Dongli Si <sidongli1997@gmail.com>
> 
> glibc detected invalid CPU Vendor name will cause an error:
> 
> [    0.450127] Run /sbin/init as init process
> /lib64/libc.so.6: CPU ISA level is lower than required
> [    0.451931] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00
> [    0.452117] CPU: 0 PID: 1 Comm: init Not tainted 5.17.0-rc1 #72

This looks bad. I'll try to reproduce it and I'll give my Tested-by tag after I
test it.

Thanks,
Alex

> 
> Signed-off-by: Dongli Si <sidongli1997@gmail.com>
> ---
>  x86/cpuid.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/cpuid.c b/x86/cpuid.c
> index c3b67d9..d58a027 100644
> --- a/x86/cpuid.c
> +++ b/x86/cpuid.c
> @@ -2,6 +2,7 @@
>  
>  #include "kvm/kvm.h"
>  #include "kvm/util.h"
> +#include "kvm/cpufeature.h"
>  
>  #include <sys/ioctl.h>
>  #include <stdlib.h>
> @@ -10,7 +11,7 @@
>  
>  static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
>  {
> -	unsigned int signature[3];
> +	struct cpuid_regs regs;
>  	unsigned int i;
>  
>  	/*
> @@ -22,10 +23,13 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
>  		switch (entry->function) {
>  		case 0:
>  			/* Vendor name */
> -			memcpy(signature, "LKVMLKVMLKVM", 12);
> -			entry->ebx = signature[0];
> -			entry->ecx = signature[1];
> -			entry->edx = signature[2];
> +			regs = (struct cpuid_regs) {
> +				.eax		= 0x00,
> +			};
> +			host_cpuid(&regs);
> +			entry->ebx = regs.ebx;
> +			entry->ecx = regs.ecx;
> +			entry->edx = regs.edx;
>  			break;
>  		case 1:
>  			/* Set X86_FEATURE_HYPERVISOR */
> -- 
> 2.32.0
> 
