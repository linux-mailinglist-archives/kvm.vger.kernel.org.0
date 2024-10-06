Return-Path: <kvm+bounces-28029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA180991D0D
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF76282342
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 08:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E27170822;
	Sun,  6 Oct 2024 08:00:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9E171E5A
	for <kvm@vger.kernel.org>; Sun,  6 Oct 2024 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728201609; cv=none; b=dzbI1oJ3wiorXlIlIc0yYo4wwHe6TIjrJLu9097GAX+VlEkSEGxCbxo+sA935vpQGyJI8ypNfK/BtVagF5HNeqK2YgY4u/MvVZnoaDozweT+gh5eoEleLT1Fv3UmlfYYGqtUuBo18K9o4N9bcQM/DLGwJEITXkIF4ECuULoPjXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728201609; c=relaxed/simple;
	bh=2Dg/aX+fyf4J6P7e0Zqi6a7C94EFVWd6VSqDE+btM+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CmzNLw8BHaw8lDceOpYLZNbVn5/u7xq0EQi/BQiEyRVtTHwVY2UwikEnKZyLGObGBcnpj6DtAO/n841MDH8cMOC7ZCr2HKDcEuH0pe+XoUAzPGFzveWUQONtGbxR/uGUkLbcFLR9sT9wzQENOH2U482C+RczduVGqn7ROtLBo0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sxMBJ-0005Tc-KL; Sun, 06 Oct 2024 09:59:57 +0200
Message-ID: <0352a327-0e78-48d4-a876-d33689fcd766@pengutronix.de>
Date: Sun, 6 Oct 2024 09:59:56 +0200
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
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <87a5fiutai.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org

Hello Marc,

On 05.10.24 23:35, Marc Zyngier wrote:
> On Sat, 05 Oct 2024 19:38:23 +0100,
> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>>> IIRC, the QEMU flash is implemented as a read-only memslot. A data
>>> cache invalidation is a *write*, as it can be (and is) upgraded to a
>>> clean+invalidate by the HW.
>>
>> So it's a write, even if there are no dirty cache lines?
> 
> Yes.
> 
> At the point where this is handled, the CPU has no clue about the
> dirty state of an arbitrary cache line, at an arbitrary cache level.
> The CPU simply forward the CMO downstream, and the permission check
> happens way before that.

I see. When I added that invalidation, it was suggested[1] that instead
of invalidation after the remapping, I would clean the range before
remapping. Cleaning the zero page triggered a data abort, which I didn't
understand as there should be no dirty lines, but now I get it.

One more question: This upgrading of DC IVAC to DC CIVAC is because
the code is run under virtualization, right?

[1]: https://lore.barebox.org/barebox/9809c04c-58c5-6888-2b14-cf17fa7c4b1a@pengutronix.de/

>> The routine[1] that does this remapping invalidates the virtual address range,
>> because the attributes may change[2]. This invalidate also happens for cfi-flash,
>> but we should never encounter dirty cache lines there as the remap is done
>> before driver probe.
>>
>> Can you advise what should be done differently?
> 
> If you always map the flash as Device memory, there is no need for
> CMOs. Same thing if you map it as NC.

Everything, except for RAM, is mapped Device-nGnRnE.

> And even if you did map it as
> Cacheable, it wouldn't matter. KVM already handles coherency when the
> flash is switching between memory-mapped and programming mode, as the
> physical address space changes (the flash literally drops from the
> memory map).
> 
> In general, issuing CMOs to a device is a bizarre concept, because it
> is pretty rare that a device can handle a full cache-line as
> write-back. Devices tend to handle smaller, register-sized accesses,
> not a full 64-byte eviction.

The same remap_range function is used to:

  - remap normal memory:
    - Mapping memory regions uncached for memory test
    - Mapping memory buffers coherent or write-combine
  - remap ROMs: BootROMs at address zero may be hidden behind the NULL
    page and need to be mapped differently when calling/peeking into it.
  - remap device memory, e.g. in the case of the cfi-flash here

The invalidation is done unconditionally for all of them, although it
makes only the sense in the first case.

> Now, I'm still wondering whether we should simply forward the CMO to
> userspace as we do for other writes, and let the VMM deal with it. The
> main issue is that there is no current way to describe this.
> 
> The alternative would be to silently handle the trap and pretend it
> never occurred, as we do for other bizarre behaviours. But that'd be
> something only new kernels would support, and I guess you'd like your
> guest to work today, not tomorrow.

I think following fix on the barebox side may work:

  - Walk all pages about to be remapped
  - Execute the AT instruction on the page's base address
  - Only if the page was previously mapped cacheable, clean + invalidate
    the cache
  - Remove the current cache invalidation after remap

Does that sound sensible?

Thanks,
Ahmad

> 
> 	M.
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

