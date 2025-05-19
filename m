Return-Path: <kvm+bounces-46980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1AAABBD28
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 541973B35D5
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 11:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BDB276054;
	Mon, 19 May 2025 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lccKlshv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD0A2690F9;
	Mon, 19 May 2025 12:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747656003; cv=none; b=Hm/xMoipFy1AMB2YtXAWYIIZrt83MQRoSNcPpoAlsqK1/MveZH9x+Ii+WvRHR8fZoXGKyZt/AGLNzZqaNdTQK7/nSgQYD2nmO034Ct34aBEsLjp9dBUUL2RaAhDiO4r1JhQHvCLvyaQAmEVP6iJQrGx19Xmfp2mu6jySmC4flRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747656003; c=relaxed/simple;
	bh=o36p20zzdltSGrsO+bxyIBTuQpGkmuNulgK1bAhY/Ak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OC4CuduqbG3pTlHArWokZaAF0rzE3Xl51UP/E+KlQM6kpksknr48fHVawE0hdV/X/gPbRtuEcKa33xbYhlRRIii/TiGvxGBL6moqBpZtWihhg1okZNR+sLqqbMEZAV9L6BnSMdzsqiMlXBpL7IflJQgxDiYRXfUZ4hUSU0pDOzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lccKlshv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33A4C4CEE9;
	Mon, 19 May 2025 12:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747656003;
	bh=o36p20zzdltSGrsO+bxyIBTuQpGkmuNulgK1bAhY/Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lccKlshvSYlD99U8Az8i/TQEQMgFbc8rqkZrbkR+lUt3B1SECWQS0NocAJb0zInoY
	 TOFjs5j19WFiK7CAvaTL7FUoHChIsx6y/JDRTR7jYfZX3FzZ1sgIomuNkQQIEJrzao
	 2zRG38G9p6jPFLhpz+7Uk9vnXE9WNC7807nriHHPCOovkyG2ehCDAhxKzv+s+rZFqQ
	 8UBAJtaUIQTC6S132Mvl8rRRp6OyEbJ5Wy6VzTW+3hJy8Wk6wWwDw++QzeMu79IYgm
	 YjAXrQcEvud5+4qoYLb3rAGhditevSmBLGNefKSSQL/v42mDqLnHYWqcP9iNjSMKeU
	 Y9/vR0tMaE7xA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uGz9z-00GDYo-5q;
	Mon, 19 May 2025 13:00:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v4 00/43] KVM: arm64: Revamp Fine Grained Trap handling
Date: Mon, 19 May 2025 12:59:55 +0100
Message-Id: <174765597419.3054795.9601866173269003599.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 06 May 2025 17:43:05 +0100, Marc Zyngier wrote:
> This is yet another version of the series last posted at [1].
> 
> The eagled eye reviewer will have noticed that since v2, the series
> has more or less doubled in size for any reasonable metric (number of
> patches, number of lines added or deleted). It is therefore pretty
> urgent that this gets either merged or forgotten! ;-)
> 
> [...]

Applied to next, thanks!

[01/43] arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
        commit: 2030396dac5f564ec85422ceb4327fcdb0054f83
[02/43] arm64: sysreg: Update ID_AA64MMFR4_EL1 description
        commit: eef33835bf6f297faa222f48bf941d57d2f8bda0
[03/43] arm64: sysreg: Add layout for HCR_EL2
        commit: d0f39259eff447fb4518777c36c7dffcf8b4ef9e
[04/43] arm64: sysreg: Replace HFGxTR_EL2 with HFG{R,W}TR_EL2
        commit: 0f013a524b240e7d67dc94d083a0d3ab72516ea3
[05/43] arm64: sysreg: Update ID_AA64PFR0_EL1 description
        commit: 9d737fddc93946d87f0ef60e00f506260534b1f4
[06/43] arm64: sysreg: Update PMSIDR_EL1 description
        commit: 894f2841f51fdeb1a7f61c74e00c883582a5af94
[07/43] arm64: sysreg: Update TRBIDR_EL1 description
        commit: 4533a0238df75d8215e72a4f3e006418ad6fe45d
[08/43] arm64: sysreg: Update CPACR_EL1 description
        commit: f062c19a9348d23a9bb7c6609ad17de3749157fd
[09/43] arm64: sysreg: Add registers trapped by HFG{R,W}TR2_EL2
        commit: 0be91cfbfdcd2f37ecf238760ce74c0ad2518e19
[10/43] arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
        commit: dd161dc2dfcbdef19849f46745949b18f5ef54f9
[11/43] arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
        commit: 7c9cb893ae3e06c9f38bd86d62992eae906bf2b7
[12/43] arm64: Remove duplicated sysreg encodings
        commit: 7a11d98d6e4893e9d8b145f211ffa94ec4e6be4e
[13/43] arm64: tools: Resync sysreg.h
        commit: 3654f454bcfdd17446544841bcac3803907122ff
[14/43] arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
        commit: 7c7d56fcebd0c029c73c41d8daba49f9787eb9c2
[15/43] arm64: Add FEAT_FGT2 capability
        commit: fbc8a4e137e5673600ec276b06ca31a46967167b
[16/43] KVM: arm64: Tighten handling of unknown FGT groups
        commit: 04af8a39684f471e3785261f5d2f0df265fd77b6
[17/43] KVM: arm64: Simplify handling of negative FGT bits
        commit: 4b4af68dd972aedc4193bd886e383c123511d275
[18/43] KVM: arm64: Handle trapping of FEAT_LS64* instructions
        commit: 2e04378f1a766b9a8962004962d32e5df06a5707
[19/43] KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_LS64_ACCDATA being disabled
        commit: 9308d0b1d7abe36f0ee2052b0ffceb7869e83f8e
[20/43] KVM: arm64: Don't treat HCRX_EL2 as a FGT register
        commit: 09be03c6b54dd8959eba6cb25051c20a475ecde9
[21/43] KVM: arm64: Plug FEAT_GCS handling
        commit: 5329358c222fec1132169ab3de9973aa4cd63aa9
[22/43] KVM: arm64: Compute FGT masks from KVM's own FGT tables
        commit: 1b8570be89f8436b25bddc8afd7e54fcd906c3aa
[23/43] KVM: arm64: Add description of FGT bits leading to EC!=0x18
        commit: 3164899c21fd915f4ca60a215fe57a671a9699bc
[24/43] KVM: arm64: Use computed masks as sanitisers for FGT registers
        commit: 7ed43d84c17cc90e683b3901e92993864756a601
[25/43] KVM: arm64: Unconditionally configure fine-grain traps
        commit: ea266c72496873468bd2fdfd53ac1db203330142
[26/43] KVM: arm64: Propagate FGT masks to the nVHE hypervisor
        commit: 311ba55a5f8637d9a79035d4ea624236283c8c99
[27/43] KVM: arm64: Use computed FGT masks to setup FGT registers
        commit: aed34b6d2134efcfaf4c123e02b1926bb789f5c3
[28/43] KVM: arm64: Remove hand-crafted masks for FGT registers
        commit: 3ce9bbba935714c344bcff096973b6daa29cf857
[29/43] KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
        commit: ef6d7d2682d948df217db73985e0a159305c7743
[30/43] KVM: arm64: Handle PSB CSYNC traps
        commit: 397411c743c77a9c1d90f407b502010227a259dc
[31/43] KVM: arm64: Switch to table-driven FGU configuration
        commit: 63d423a7635bca6d817a30adff29be58ee99c6d5
[32/43] KVM: arm64: Validate FGT register descriptions against RES0 masks
        commit: 938a79d0aa8dd0f75e4302a67006db4f45e1ce4e
[33/43] KVM: arm64: Use FGT feature maps to drive RES0 bits
        commit: c6cbe6a4c1bdce88bb0384df0e3679e4ef81dcd6
[34/43] KVM: arm64: Allow kvm_has_feat() to take variable arguments
        commit: a764b56bf90b6d758ff21408c13cd686c2519ef9
[35/43] KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
        commit: beed4448418ee2e2f48a9d5d6c01fe79df200bc2
[36/43] KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits
        commit: b2a324ff01feac7ea1ffe5a521cffc2749e9f113
[37/43] KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
        commit: df56f1ccb0ec02570a0740703c63cac6bf0ec57c
[38/43] KVM: arm64: Add sanitisation for FEAT_FGT2 registers
        commit: 4bc0fe089840695538aff879e25efab2cdad22bd
[39/43] KVM: arm64: Add trap routing for FEAT_FGT2 registers
        commit: fc631df00c4cef4a95b25ac87842b9d1ec9ceaa1
[40/43] KVM: arm64: Add context-switch for FEAT_FGT2 registers
        commit: 1ba41c816007107e0f774d6803e0cbbbb40a47e0
[41/43] KVM: arm64: Allow sysreg ranges for FGT descriptors
        commit: f654e9e47eac95424b8ef4b285f331604460174b
[42/43] KVM: arm64: Add FGT descriptors for FEAT_FGT2
        commit: af2d78dcadbc2386610566ab2052fee78993fb53
[43/43] KVM: arm64: Handle TSB CSYNC traps
        commit: 98dbe56a016a4ea457ef312637a625d3c627dbd9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



