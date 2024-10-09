Return-Path: <kvm+bounces-28166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A64C995F7F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC6D7282C65
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB42016BE20;
	Wed,  9 Oct 2024 06:12:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931EF36D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 06:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454324; cv=none; b=p74Z08hrrCM8tn56ha41RJhCn7GtcUM85jsAjrBZ5vsyoHvq7YgBDVOGM1hyHy9NJ1qkcH3EnVZk625TfqHZ1WPCsD6RsHauJyPx5h3t2EgYmodyMEf/SkRGp4GMGx7NNyLSPVgVqRVW14ezHxIz4HxmVnnZ23Z/6OH6MfevJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454324; c=relaxed/simple;
	bh=cRKE11JMe+EoQ5AKczDzkrZzREHOA7C0sg9++MFgw7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wzwu1WWdBhvYvU91rN46klkIAsl0F5TCMGn3syCBWII35DJ6d4U/7D/qlpxp61qXXRJLMQgid1SO8GhPyvZeD1mN+NOn8DajXJyiF+rXpDgbCHNGQglYt2joK4qUDzE54vYJbAQnF4WgqdbKq1luig7oSmVxAlZBr99OPpxXfWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1syPvM-0007eP-OX; Wed, 09 Oct 2024 08:11:52 +0200
Message-ID: <f096876b-f364-4291-88e0-ac189b4f26fe@pengutronix.de>
Date: Wed, 9 Oct 2024 08:11:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO
 address
To: Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
 <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
 <4d559b9e-c208-46f3-851a-68086dc8a50f@pengutronix.de>
 <864j5q7sdq.wl-maz@kernel.org>
 <65ab10d7-6594-490c-be07-39f83ac3559a@pengutronix.de>
 <87a5fiutai.wl-maz@kernel.org>
 <0352a327-0e78-48d4-a876-d33689fcd766@pengutronix.de>
 <8634l97cfs.wl-maz@kernel.org>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <8634l97cfs.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org

Hello Marc,

On 06.10.24 12:28, Marc Zyngier wrote:
> On Sun, 06 Oct 2024 08:59:56 +0100,
> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> On 05.10.24 23:35, Marc Zyngier wrote:
>>> On Sat, 05 Oct 2024 19:38:23 +0100,
>>> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> One more question: This upgrading of DC IVAC to DC CIVAC is because
>> the code is run under virtualization, right?
> 
> Not necessarily. Virtualisation mandates the upgrade, but CIVAC is
> also a perfectly valid implementation of both IVAC and CVAC.  And it
> isn't uncommon that CPUs implement everything the same way.

Makes sense. After all, software should expect cache lines to
be evicted at any time due to capacity misses anyway.

>> I think following fix on the barebox side may work:
>>
>>   - Walk all pages about to be remapped
>>   - Execute the AT instruction on the page's base address
> 
> Why do you need AT if you are walking the PTs? If you walk, you
> already have access to the memory attributes. In general, AT can be
> slower than an actual walk.
>
> Or did you actually mean iterating over the VA range? Even in that
> case, AT can be a bad idea, as you are likely to iterate in page-size
> increments even if you have a block mapping. Walking the PTs tells you
> immediately how much a leaf is mapping (assuming you don't have any
> other tracking).

There's no other tracking and I hoped that using AT (which is already
being used for the mmuinfo shell command) would be easier.

I see now that it would be too suboptimal to do it this way and have
implemented a revised arch_remap_range[1] for barebox, which I just
Cc'd you on.

[1]: https://lore.kernel.org/barebox/20241009060511.4121157-5-a.fatoum@pengutronix.de/T/#u

>>   - Only if the page was previously mapped cacheable, clean + invalidate
>>     the cache
>>   - Remove the current cache invalidation after remap
>>
>> Does that sound sensible?
> 
> This looks reasonable (apart from the AT thingy).

I have two (hopefully the last!) questions about remaining differing
behavior with KVM and without:

1) Unaligned stack accesses crash in KVM:

start: /* This will be mapped at 0x40080000 */
        ldr     x0, =0x4007fff0
        mov     sp, x0
        stp     x0, x1, [sp] // This is ok

        ldr     x0, =0x4007fff8
        mov     sp, x0
        stp     x0, x1, [sp] // This crashes

I know that the stack should be 16 byte aligned, but why does it crash
only under KVM?

Context: The barebox Image used for Qemu has a Linux ARM64 "Image" header,
so it's loaded at an offset and grows the stack down into this memory region
until the FDT's /memory could be decoded and a proper stack is set up.

A regression introduced earlier this year, caused the stack to grow down
from a non-16-byte address, which is fixed in [2].

[2]: https://lore.kernel.org/barebox/20241009060511.4121157-5-a.fatoum@pengutronix.de/T/#ma381512862d22530382aff1662caadad2c8bc182

2) Using uncached memory for Virt I/O queues with KVM enabled is considerably
   slower. My guess is that these accesses keep getting trapped, but what I wonder
   about is the performance discrepancy between the big.LITTLE cores
   (measurement of barebox copying 1MiB using `time cp -v /dev/virtioblk0 /tmp`):

    KVM && !CACHED && 1x Cortex-A53:  0.137s
    KVM && !CACHED && 1x Cortex-A72: 54.030s
    KVM &&  CACHED && 1x Cortex-A53:  0.120s
    KVM &&  CACHED && 1x Cortex-A72:  0.035s

The A53s are CPUs 0-1 and the A72 are 2-5.

Any idea why accessing uncached memory from the big core is so much worse?

Thank you!
Ahmad

> 
> Thanks,
> 
> 	M.
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

