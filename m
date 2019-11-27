Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895F210B186
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0Olv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:41:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0Olv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:41:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A51631B;
        Wed, 27 Nov 2019 06:41:50 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 262763F68E;
        Wed, 27 Nov 2019 06:41:49 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 18/18] arm: cstart64.S: Remove icache
 invalidation from asm_mmu_enable
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
 <20191127142410.1994-19-alexandru.elisei@arm.com>
Message-ID: <611f7833-223c-b55a-489a-0b956011c699@arm.com>
Date:   Wed, 27 Nov 2019 14:41:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127142410.1994-19-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/27/19 2:24 PM, Alexandru Elisei wrote:
> According to the ARM ARM [1]:
>
> "In Armv8, any permitted instruction cache implementation can be
> described as implementing the IVIPT Extension to the Arm architecture.
>
> The formal definition of the Arm IVIPT Extension is that it reduces the
> instruction cache maintenance requirement to the following condition:
> Instruction cache maintenance is required only after writing new data to
> a PA that holds an instruction".

And immediately following: "Previous versions of the Arm architecture have
permitted an instruction cache option that does not implement the Arm IVIPT
Extension".

That type of cache is the ASID and VMID tagged VIVT instruction cache [1], which
require icache maintenance when the instruction at a given virtual address
changes. Seeing how we don't change the IPA for the same VA anywhere in
kvm-unit-tests, I propose that it will be up to the person who will write such a
test to use the appropriate maintenance operations.

[1] ARM DDI 0406C.d, section B3.11.2.

Thanks,
Alex
> We never patch instructions in the boot path, so remove the icache
> invalidation from asm_mmu_enable. Tests that modify instructions (like
> the cache test) should have their own icache maintenance operations.
>
> [1] ARM DDI 0487E.a, section D5.11.2 "Instruction caches"
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart64.S | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 87bf873795a1..7e7f8b2e8f0b 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -166,7 +166,6 @@ halt:
>  
>  .globl asm_mmu_enable
>  asm_mmu_enable:
> -	ic	iallu			// I+BTB cache invalidate
>  	tlbi	vmalle1			// invalidate I + D TLBs
>  	dsb	nsh
>  
