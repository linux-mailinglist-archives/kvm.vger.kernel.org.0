Return-Path: <kvm+bounces-30142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 048FA9B72B3
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6511C22F8F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 03:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532A933FD;
	Thu, 31 Oct 2024 03:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RFgN+t8n"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF81BD9EA
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 03:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730343872; cv=none; b=uvywL/EtTn8gUpLO1KrswbOoJeC9QIZifHefB3oL6R9Wv5gRfy4myvcFZ87oIWthiFpz9Env6QUKxFdn8psFKojkkNJxpPMFFZj4YVMthg4ohlHBBraPhiE7Z1kaKARe4q/fesBd6uYjPEQWenpx6TFzAkYXBJJGzMoVjklxr0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730343872; c=relaxed/simple;
	bh=wdCoFEjwa8iGWdAfqKivFQcrwdTRXlT0IoRxu+pRDBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQJBrZYtwxACvHKKQqTVjZq15TveeNhITtTXrWwEgtbRDsSz4KjLpCRHgLqHrdpuJ6UvUGbkUBHeBP7Gzwti6/4mYh96b0IJ1PpEMbxpf81i8wY6tVnrVFScPwPmwoAwiSvIM0mQ1fFwefPpjLGFgNddWL5hkxuD6Jy3QTVzQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RFgN+t8n; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730343866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JU5mWi+4xOc6kAhkGMfdVmB9NWczUXuOyU69dRDI3rw=;
	b=RFgN+t8nlHdRDO7Tq3qufprYhgnhMTvP9uJxwNm982IprAiC5GQlbWBWkl4BP25LdZV/iq
	LNOFM4AAk3zcPkoKmyt5ymCo3aSylAhV2tGm+t1uuouHD+/jpAYrJjP10pV9NUhgpfqSXI
	tYCMRquzrIudpNJ6x+v9PpPbzwCWJys=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 00/37] KVM: arm64: Add EL2 support to FEAT_S1PIE/S1POE
Date: Thu, 31 Oct 2024 03:04:14 +0000
Message-ID: <173034380993.2566795.1591637584460232637.b4-ty@linux.dev>
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 23 Oct 2024 15:53:08 +0100, Marc Zyngier wrote:
> This series serves a few purposes:
> 
> - Complete the S1PIE/S1POE support to include EL2
> - Sneak in the EL2 system register world switch
> 
> As mentioned in few of the patches, this implementation relies on a
> very recent fix to the architecture (D22677 in [0]).
> 
> [...]

Applied to kvmarm/next, thanks!

[01/37] arm64: Drop SKL0/SKL1 from TCR2_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/d41571c7097a
[02/37] arm64: Remove VNCR definition for PIRE0_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/5792349d0cce
[03/37] arm64: Add encoding for PIRE0_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/4ecda4c67961
[04/37] KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
        https://git.kernel.org/kvmarm/kvmarm/c/a5c870d0939b
[05/37] KVM: arm64: nv: Add missing EL2->EL1 mappings in get_el2_to_el1_mapping()
        https://git.kernel.org/kvmarm/kvmarm/c/dfeb91686992
[06/37] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
        https://git.kernel.org/kvmarm/kvmarm/c/164b5e20cdf6
[07/37] KVM: arm64: nv: Save/Restore vEL2 sysregs
        https://git.kernel.org/kvmarm/kvmarm/c/b9527b38c667
[08/37] KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
        https://git.kernel.org/kvmarm/kvmarm/c/14ca930d828b
[09/37] KVM: arm64: Extend masking facility to arbitrary registers
        https://git.kernel.org/kvmarm/kvmarm/c/a0162020095e
[10/37] arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
        https://git.kernel.org/kvmarm/kvmarm/c/9ae424d2a1ae
[11/37] KVM: arm64: Add TCR2_EL2 to the sysreg arrays
        https://git.kernel.org/kvmarm/kvmarm/c/69c19e047dfe
[12/37] KVM: arm64: Sanitise TCR2_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/ad4f6ef0fa19
[13/37] KVM: arm64: Add save/restore for TCR2_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/5055938452ed
[14/37] KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
        https://git.kernel.org/kvmarm/kvmarm/c/5f8d5a15ef5a
[15/37] KVM: arm64: Add save/restore for PIR{,E0}_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/b3ad940a0887
[16/37] KVM: arm64: Handle PIR{,E0}_EL2 traps
        https://git.kernel.org/kvmarm/kvmarm/c/874ae1d48e60
[17/37] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
        (no commit info)
[18/37] KVM: arm64: Add AT fast-path support for S1PIE
        https://git.kernel.org/kvmarm/kvmarm/c/23e7a34c8397
[19/37] KVM: arm64: Split S1 permission evaluation into direct and hierarchical parts
        https://git.kernel.org/kvmarm/kvmarm/c/4967b87a9ff7
[20/37] KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
        https://git.kernel.org/kvmarm/kvmarm/c/5e21b2978722
[21/37] KVM: arm64: Implement AT S1PIE support
        https://git.kernel.org/kvmarm/kvmarm/c/364c081029a6
[22/37] KVM: arm64: Add a composite EL2 visibility helper
        https://git.kernel.org/kvmarm/kvmarm/c/ee3a9a0643c5
[23/37] KVM: arm64: Define helper for EL2 registers with custom visibility
        https://git.kernel.org/kvmarm/kvmarm/c/997eeecafeba
[24/37] KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
        https://git.kernel.org/kvmarm/kvmarm/c/0fcb4eea5345
[25/37] KVM: arm64: Hide S1PIE registers from userspace when disabled for guests
        https://git.kernel.org/kvmarm/kvmarm/c/a68cddbe47ef
[26/37] KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
        https://git.kernel.org/kvmarm/kvmarm/c/b4824120303f
[27/37] arm64: Add encoding for POR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/b9ed7e5dfbe9
[28/37] KVM: arm64: Drop bogus CPTR_EL2.E0POE trap routing
        https://git.kernel.org/kvmarm/kvmarm/c/b17d8aa20126
[29/37] KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
        https://git.kernel.org/kvmarm/kvmarm/c/f7575530df43
[30/37] KVM: arm64: Add kvm_has_s1poe() helper
        https://git.kernel.org/kvmarm/kvmarm/c/26e89dccdf63
[31/37] KVM: arm64: Add basic support for POR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/5970e9903f03
[32/37] KVM: arm64: Add save/restore support for POR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/de5c2827fb44
[33/37] KVM: arm64: Add POE save/restore for AT emulation fast-path
        https://git.kernel.org/kvmarm/kvmarm/c/846c993df982
[34/37] KVM: arm64: Disable hierarchical permissions when POE is enabled
        https://git.kernel.org/kvmarm/kvmarm/c/8a9b304d7e22
[35/37] KVM: arm64: Make PAN conditions part of the S1 walk context
        https://git.kernel.org/kvmarm/kvmarm/c/7cd5c2796cb0
[36/37] KVM: arm64: Handle stage-1 permission overlays
        https://git.kernel.org/kvmarm/kvmarm/c/e39ce7033c70
[37/37] KVM: arm64: Handle WXN attribute
        https://git.kernel.org/kvmarm/kvmarm/c/1c6801d565ec

--
Best,
Oliver

