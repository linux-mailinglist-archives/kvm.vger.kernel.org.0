Return-Path: <kvm+bounces-28020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22675991997
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 20:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5C1F28200B
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 18:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F0C15DBAB;
	Sat,  5 Oct 2024 18:38:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A4215CD41
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153527; cv=none; b=XPG2RbaggRGEAEX4Sn34TjCjzZw0fhvPg1tffEJbFBS8KwMNvix6615WhDdvFyvmmoE9zLQLX6AAPJe9KZv13Dfwo8jcWTOK0fIyyqrfNylaTsdkw4Jscnv1BNJaMCTrl+GAecZ+iKJXAoOPX1zhfyUF+AgP5PHAVc+Au1kSh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153527; c=relaxed/simple;
	bh=WSgpTwUCUNoFVg372JpUaT18YN3U/v0nRdWuQbBYqPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SklYR550WDS7fba7OgC8zl1UZPgQYvYD+J7lU4HCQ+in0LuH1HWHlmeTiD49Gs7BTuvds7fmJBKjhfT3S+x1jCBN8LU+mXI5aLVecqiRgJKltbtf8IpJHcqgGUtxKekLJH3zCTkJknRAQLuOEIj1ihdEGEQmzVCCKRvMnjpFkyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sx9fd-0001EL-CD; Sat, 05 Oct 2024 20:38:25 +0200
Message-ID: <65ab10d7-6594-490c-be07-39f83ac3559a@pengutronix.de>
Date: Sat, 5 Oct 2024 20:38:23 +0200
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
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <864j5q7sdq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org

Hello Marc,

On 05.10.24 12:31, Marc Zyngier wrote:
> On Fri, 04 Oct 2024 20:50:18 +0100,
> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> With readl/writel implemented in assembly, I get beyond that point, but
>> now I get a data abort running an DC IVAC instruction on address 0x1000,
>> where the cfi-flash is located. This instruction is part of a routine
>> to remap the cfi-flash to start a page later, so the zero page can be
>> mapped faulting.

[snip]

>> Any idea what this is about?
> 
> IIRC, the QEMU flash is implemented as a read-only memslot. A data
> cache invalidation is a *write*, as it can be (and is) upgraded to a
> clean+invalidate by the HW.

So it's a write, even if there are no dirty cache lines?

> KVM cannot satisfy the write, for obvious reasons, and tells the guest
> to bugger off (__gfn_to_pfn_memslot() returns KVM_PFN_ERR_RO_FAULT,
> which satisfies is_error_noslot_pfn() -- a slight oddity, but hey, why
> not).
> 
> In the end, you get an exception. We could relax this by
> special-casing CMOs to RO memslots, but this doesn't look great.
> 
> The real question is: what are you trying to achieve with this?

barebox sets up the MMU, but tries to keep a 1:1 mapping. On Virt, we
want to map the zero page faulting, but still have access to the first
block of the cfi-flash.

Therefore, barebox will map the cfi-flash one page later
(virt 0x1000,0x2000,... -> phys 0x0000,0x1000,...) and so on, so the first
page can be mapped faulting.

The routine[1] that does this remapping invalidates the virtual address range,
because the attributes may change[2]. This invalidate also happens for cfi-flash,
but we should never encounter dirty cache lines there as the remap is done
before driver probe.

Can you advise what should be done differently?

[1]: https://elixir.bootlin.com/barebox/v2024.09.0/source/arch/arm/cpu/mmu_64.c#L193
[2]: https://lore.kernel.org/barebox/20230526063354.1145474-4-a.fatoum@pengutronix.de/

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

