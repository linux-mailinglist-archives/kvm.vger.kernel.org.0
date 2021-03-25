Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED923496AE
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCYQUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:20:50 -0400
Received: from foss.arm.com ([217.140.110.172]:53440 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhCYQU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 12:20:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97476143D;
        Thu, 25 Mar 2021 09:20:26 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [10.57.23.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 192883F718;
        Thu, 25 Mar 2021 09:20:25 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 2/2] arm64: Output PC load offset on
 unhandled exceptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com
References: <20210325155657.600897-1-drjones@redhat.com>
 <20210325155657.600897-3-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <34d358f1-7831-cf7d-b059-e67ff1d406ba@arm.com>
Date:   Thu, 25 Mar 2021 16:20:24 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325155657.600897-3-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 15:56, Andrew Jones wrote:
> Since for arm64 we can load the unit tests at different addresses,
> then let's make it easier to debug by calculating the PC offset for
> the user. The offset can then be directly used when looking at the
> disassembly of the test's elf file.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com
Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/flat.lds          | 1 +
>   lib/arm64/processor.c | 7 +++++++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 4d43cdfeab41..6ed377c0eaa0 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -1,6 +1,7 @@
>   
>   SECTIONS
>   {
> +    PROVIDE(_text = .);
>       .text : { *(.init) *(.text) *(.text.*) }
>       . = ALIGN(64K);
>       PROVIDE(etext = .);
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index ef558625e284..831207c16587 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -99,12 +99,19 @@ bool get_far(unsigned int esr, unsigned long *far)
>   	return false;
>   }
>   
> +extern unsigned long _text;
> +
>   static void bad_exception(enum vector v, struct pt_regs *regs,
>   			  unsigned int esr, bool esr_valid, bool bad_vector)
>   {
>   	unsigned long far;
>   	bool far_valid = get_far(esr, &far);
>   	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
> +	uintptr_t text = (uintptr_t)&_text;
> +
> +	printf("Load address: %" PRIxPTR "\n", text);
> +	printf("PC: %" PRIxPTR " PC offset: %" PRIxPTR "\n",
> +	       (uintptr_t)regs->pc, (uintptr_t)regs->pc - text);
>   
>   	if (bad_vector) {
>   		if (v < VECTOR_MAX)
> 
