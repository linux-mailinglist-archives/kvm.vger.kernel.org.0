Return-Path: <kvm+bounces-63502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF63C67E3C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E9BDF2A401
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4102FBE00;
	Tue, 18 Nov 2025 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auyuCTfQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7CC25A633;
	Tue, 18 Nov 2025 07:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763450450; cv=none; b=hXpbmQepoxLMdnnbvHAdKs7F6a4cWqXlys4K/ymC7DMa6SMgI9Ahjm1x/s8cXqJBzEnS8g+AXMLlelnw13FWrnVmR03oIc6HKTaiUajji60ak6KO0A+oQYoIdOUmiylcN87E0GxNs4ulGVQbKUpIgAurHuTqSYBf+34Lnwmseck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763450450; c=relaxed/simple;
	bh=j+MYg21RyAED4d0T7A8bQOMTtInQi6sOoDxd6eR1Muk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Irjdqtgqi8wQwbEcqK1cWAkfIGCNOaHivN1e8GYMCt28/gmMk9fqG3qe/QxtDcJlf/v4dju3dyhHnbklY9DGBmj1ZfQL1NrVO36vnJ/iY3OvFeb6nLmAZV16O7uxMfaRCUGT+rhs91DW3IKFgUu1YUb+kg2nH9dsnAiTrMwB0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auyuCTfQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CC7C4CEF1;
	Tue, 18 Nov 2025 07:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763450450;
	bh=j+MYg21RyAED4d0T7A8bQOMTtInQi6sOoDxd6eR1Muk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=auyuCTfQWiotWzkuYWbY3kpLpU1Rx9vv6Ce6mePeTlvdStH2Mlq/MJ0L17XFdeYHr
	 rPw5mvZiWtV57Bti6p32Ki0iGz8l0N289niGMqWyULzI2S67/OF2J2ClZ30l1NVMZT
	 SwqYRKAUWiAAv2xwzyJNP8fdeAyHQlfcYj0oCMYZ6booge8jwliQKyLdy4KrO1P5qs
	 Ri00Ujz2q199Go/WiONfVpbVz5whlik+KM4Hc9EY07glIlJ4A2oZ8lkJOL7X6yscjb
	 O0ztnAYtRpuGe0AkCAO6a1vh3BIgj40zKn07NAprKsSCqHXxqe6/UW5CI5k5V7CaWr
	 UfncsehknxHEw==
Date: Mon, 17 Nov 2025 23:20:48 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the
 dregs, the bad and the ugly)
Message-ID: <aRweUM4O71ecPvVr@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>

On Mon, Nov 17, 2025 at 09:15:22AM +0000, Marc Zyngier wrote:
> This is a follow-up to the original series [1] (and fixes [2][3])
> with a bunch of bug-fixes and improvements. At least one patch has
> already been posted, but I thought I might repost it as part of a
> series, since I accumulated more stuff:
> 
> - The first patch addresses Mark's observation that the no-vgic-v3
>   test has been broken once more. At some point, we'll have to retire
>   that functionality, because even if we keep fixing the SR handling,
>   nobody tests the actual interrupt state exposure to userspace, which
>   I'm pretty sure has badly been broken for at least 5 years.
> 
> - The second one addresses a report from Fuad that on QEMU,
>   ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
>   the host exploding on deactivating an interrupt. This behaviour is
>   allowed by the spec, so make sure we clear all trap bits
> 
> - Running vgic_irq in an L1 guest (the test being an L2) results in a
>   MI storm on the host, as the state synchronisation is done at the
>   wrong place, much like it was on the non-NV path before it was
>   reworked. Apply the same methods to the NV code, and enjoy much
>   better MI emulation, now tested all the way into an L3.
> 
> - Nuke a small leftover from previous rework.
> 
> - Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
>   the trap prevents too many spurious MIs in an L1 guest, as the write
>   to ICH_HCR_EL2 does exactly nothing on its own when running under
>   FEAT_NV2.
> 
> Oliver: this is starting to be a large series of fixes on top of the
> existing series, plus the two patches you have already added. I'd be
> happy to respin a full v4 with the fixes squashed into their original
> patches. On the other hand, if you want to see the history in its full
> glory, that also works for me.

I'll pick up these patches in a moment but at this point I'd prefer a
clean history. Plan is to send out the 6.19 pull sometime next week so
any time before then would be great for v4.

Thanks for ironing out all the quirks :)

Best,
Oliver

