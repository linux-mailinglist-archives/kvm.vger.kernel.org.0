Return-Path: <kvm+bounces-27990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AFC991007
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B4781C238DE
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 20:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD875231C80;
	Fri,  4 Oct 2024 19:50:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A64231C87
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728071431; cv=none; b=WcBZPGCuHD/2X6R3zfRKk0MommzHbWiYPTiOo/AK0+RNz5HV0j2EKaxW6DHWRYlKXEb9G71nKXJzlkyTZ4qxEZRxpXFV6ep1WlCPbecoyzRNpG7BW6+X3wYJjvBgJ+qUtWRmxHa15nyVtCebfGlCJMDiDDydH4FNazFxj62gOwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728071431; c=relaxed/simple;
	bh=d+uNb1YxSbc18Y/ikkvakxRW0zWVs7tZrrGcMxydxoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8zzIT7WZcM21crQG6CNJ2z6XAU/EF5Zo4CCVL6S0iNedwkcFSrO+zXtN+lQlpGYZ5uwsAxPTne/ghZjj9BORwOSrlzV3VvgWEoUY6UHkN4QEshrjs9eq/Wdfp0xsqkyXjHCAta19xyIFSRjkeovMBAnloAbZ8iI9HTu7vi18Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1swoJg-0001qQ-83; Fri, 04 Oct 2024 21:50:20 +0200
Message-ID: <4d559b9e-c208-46f3-851a-68086dc8a50f@pengutronix.de>
Date: Fri, 4 Oct 2024 21:50:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO
 address
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-arm@nongnu.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
 <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org

Hi,

On 04.10.24 14:10, Peter Maydell wrote:
> On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> On 04.10.24 12:40, Peter Maydell wrote:
>>> Don't do this -- KVM doesn't support it. For access to MMIO,
>>> stick to instructions which will set the ISV bit in ESR_EL1.
>>>
>>> That is:
>>>
>>>  * AArch64 loads and stores of a single general-purpose register
>>>    (including the register specified with 0b11111, including those
>>>    with Acquire/Release semantics, but excluding Load Exclusive
>>>    or Store Exclusive and excluding those with writeback).
>>>  * AArch32 instructions where the instruction:
>>>     - Is an LDR, LDA, LDRT, LDRSH, LDRSHT, LDRH, LDAH, LDRHT,
>>>       LDRSB, LDRSBT, LDRB, LDAB, LDRBT, STR, STL, STRT, STRH,
>>>       STLH, STRHT, STRB, STLB, or STRBT instruction.
>>>     - Is not performing register writeback.
>>>     - Is not using R15 as a source or destination register.
>>>
>>> Your instruction is doing writeback. Do the address update
>>> as a separate instruction.

With readl/writel implemented in assembly, I get beyond that point, but
now I get a data abort running an DC IVAC instruction on address 0x1000,
where the cfi-flash is located. This instruction is part of a routine
to remap the cfi-flash to start a page later, so the zero page can be
mapped faulting.

Simple reproducer:

start:
        ldr     x0, =0x1000
        ldr     x1, =0x1040
        bl      v8_inv_dcache_range

        mov     w10, '!'
        bl      putch

        ret

v8_inv_dcache_range:
        mrs     x3, ctr_el0
        lsr     x3, x3, #16
        and     x3, x3, #0xf
        mov     x2, #0x4
        lsl     x2, x2, x3
        sub     x3, x2, #0x1
        bic     x0, x0, x3
1:
        dc      ivac, x0
        add     x0, x0, x2
        cmp     x0, x1
        b.cc    1b
        dsb     sy
        ret

This prints ! without KVM, but triggers a data abort before that with -enable-kvm:

  DABT (current EL) exception (ESR 0x96000010) at 0x0000000000001000
  elr: 000000007fbe0550 lr : 000000007fbe01ac
  [snip]

  Call trace:
  [<7fbe0550>] (v8_inv_dcache_range+0x1c/0x34) from [<7fbe0218>] (arch_remap_range+0x64/0x70)
  [<7fbe0218>] (arch_remap_range+0x64/0x70) from [<7fb8795c>] (of_platform_device_create+0x1e8/0x22c)
  [<7fb8795c>] (of_platform_device_create+0x1e8/0x22c) from [<7fb87a04>] (of_platform_bus_create+0x64/0xbc)
  [snip]

Any idea what this is about?

Thanks,
Ahmad


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

