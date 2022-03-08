Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63EE4D1F28
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiCHRc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiCHRcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:32:25 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1349B55763
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:31:28 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59A26139F;
        Tue,  8 Mar 2022 09:31:28 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9393FA45;
        Tue,  8 Mar 2022 09:31:27 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:31:25 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Dongli Si <sidongli1997@gmail.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool] x86: Fixed Unable to execute init process since
 glibc version 2.33
Message-ID: <20220308173125.13130a28@donnerap.cambridge.arm.com>
In-Reply-To: <20220226060048.3-1-sidongli1997@gmail.com>
References: <20220226060048.3-1-sidongli1997@gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 26 Feb 2022 14:00:48 +0800
Dongli Si <sidongli1997@gmail.com> wrote:

Hi,

> From: Dongli Si <sidongli1997@gmail.com>
> 
> glibc detected invalid CPU Vendor name will cause an error:
> 
> [    0.450127] Run /sbin/init as init process
> /lib64/libc.so.6: CPU ISA level is lower than required
> [    0.451931] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00
> [    0.452117] CPU: 0 PID: 1 Comm: init Not tainted 5.17.0-rc1 #72
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

But that's redundant, isn't it? We already get the host vendor ID in the
three registers in entry, and the current code is just there to overwrite
this. So just removing the whole "case 0:" part should do the trick.

Also please be aware that there was a reason for this fixup, as explained
in commit bc0b99a2a740 ("kvm tools: Filter out CPU vendor string").

Alex, did you boot this on an AMD box, to spot if this is still an issue?

Cheers,
Andre



>  			break;
>  		case 1:
>  			/* Set X86_FEATURE_HYPERVISOR */

