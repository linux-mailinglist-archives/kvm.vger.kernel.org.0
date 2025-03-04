Return-Path: <kvm+bounces-39984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B299EA4D3DB
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:28:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2709B3AE600
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839001F5424;
	Tue,  4 Mar 2025 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lLtagYgB"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F2D1F4734
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069719; cv=none; b=oVyzcyaxnrr0NupVGKurRUtOW5SlVG01yksMi3vz5xZNXGKnokUVN+WWSkd5o7aqv/+6zg9ij/GNW5mHOFZPcTxAS0K4CV/Loa66YO2q3wteRf2wzJXxdl18aEsVIDtxuiqGZmO5CEWjQkbc0ZLbnJngbCd3oEclW6yfdp1SnJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069719; c=relaxed/simple;
	bh=sTWp6TFoGoG9wijMqTB42w3CYiFLz2Ijofd1SXMaB/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jC0dwA+TbreRL1APfvsvpKjLimrBvH0U9KsMxB2S5uD7BKDFRVNsDKWKBXjpY7yJQ/BZCdyP8TwAGGg7yW9QbR9fjj/Aim2uUKbIiQCTdPLo25m8+I2MKHC/Us1ykvRgh3O7aH0bRa5SKsCjk6icn+WRP+UbZR/LlyBoSZA/Tss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lLtagYgB; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741069705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a9qEsSg9jcpve+CwsRU4DZ4eVncjU6IKX3sFzRmX1D8=;
	b=lLtagYgBvJohD4x3FkvhSVUQdRYtTsqp1wUjTnue2MAGOkQovxA/7ffJiU5mxuayj5UJW2
	7l+E0nMjHo7JqncH6gFCYi5JwENK45yxkmkiAtOqlNjIgX61LtaiKyaMB7xlySVOK+1rCz
	wdYzsozbTbPjHAUPM+V4PDQ92+Np+CU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 00/16] KVM: arm64: Add NV GICv3 support
Date: Mon,  3 Mar 2025 22:27:07 -0800
Message-Id: <174106961929.349492.6260089060201840223.b4-ty@linux.dev>
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 25 Feb 2025 17:29:14 +0000, Marc Zyngier wrote:
> Here's a respin of the NV support for GICv3. The integration branch
> containing this (and the rest of the NV stack) is still at [4].
> 
> At this stage, I think this is good to go.
> 
> * From v3 [3]:
> 
> [...]

Fixed up a few typos here but overall this is in great shape, thank you.

Applied to next, thanks!

[01/16] arm64: sysreg: Add layout for ICH_HCR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/22513c0d2ad8
[02/16] arm64: sysreg: Add layout for ICH_VTR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/5815fb82dc67
[03/16] arm64: sysreg: Add layout for ICH_MISR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/b7a252e881f3
[04/16] KVM: arm64: nv: Load timer before the GIC
        https://git.kernel.org/kvmarm/kvmarm/c/16abeb60be62
[05/16] KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
        https://git.kernel.org/kvmarm/kvmarm/c/182f1596941e
[06/16] KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses
        https://git.kernel.org/kvmarm/kvmarm/c/96c2f03311de
[07/16] KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
        https://git.kernel.org/kvmarm/kvmarm/c/21d29cd814d7
[08/16] KVM: arm64: nv: Nested GICv3 emulation
        https://git.kernel.org/kvmarm/kvmarm/c/146a050f2d8c
[09/16] KVM: arm64: nv: Handle L2->L1 transition on interrupt injection
        https://git.kernel.org/kvmarm/kvmarm/c/4b1b97f0d7cf
[10/16] KVM: arm64: nv: Add Maintenance Interrupt emulation
        https://git.kernel.org/kvmarm/kvmarm/c/201c8d40dde9
[11/16] KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting
        https://git.kernel.org/kvmarm/kvmarm/c/69c9176c3862
[12/16] KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
        https://git.kernel.org/kvmarm/kvmarm/c/93078ae63f20
[13/16] KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
        https://git.kernel.org/kvmarm/kvmarm/c/7682c023212e
[14/16] KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
        https://git.kernel.org/kvmarm/kvmarm/c/89896cc15911
[15/16] KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ
        https://git.kernel.org/kvmarm/kvmarm/c/faf7714a47a2
[16/16] KVM: arm64: nv: Fail KVM init if asking for NV without GICv3
        https://git.kernel.org/kvmarm/kvmarm/c/83c6cb20147b

--
Best,
Oliver

