Return-Path: <kvm+bounces-64440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 297E6C82B9B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 23:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F3DA3A8A83
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C102F691D;
	Mon, 24 Nov 2025 22:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pkwq5+A6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208DE2F7456;
	Mon, 24 Nov 2025 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024246; cv=none; b=GQ7hgCSEwCkdDjK3parzPXHtJAfTAnrFMt6wZ9xOHbapc3dOXH4bjEKdlaUCd4OnIW9AbKwRILes6eN387EfCMuR7RRIBe+Yq1s9HIijuAtplqtZ1R+Xd7q3pcO4ZmFNkq9SLjpsvJDGDZ5MulItWL9F3nPffwBL6xwEQcPRrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024246; c=relaxed/simple;
	bh=iq+pBVpT6OeYuuhJ6C0yJpr7YyPJWT2pNltOJSC4Pac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tFAz765MautUEwGJMiK7nHIMEtoUlQjvnzwRPUmDxdXRrihYaCxfZ9Bup11lURHONTYi7VBF2ZBvmXhJ8LVPdhr2kIIPQPCw8dK0hw4auUYkctjTiHHLKaOWkuHBmDmLfC8iip7I8L8QKOF2eCMtu+epZXT+8qjLUvWTwY9qZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pkwq5+A6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55050C4CEF1;
	Mon, 24 Nov 2025 22:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764024245;
	bh=iq+pBVpT6OeYuuhJ6C0yJpr7YyPJWT2pNltOJSC4Pac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pkwq5+A6/E6eA5+8ydkywqZONDULSBGc7UBLcLjWZMvudaQSNlHetO/ntIefIEX94
	 rELf0GKjddm9EQ28nRSFsMLBILa76VTIEfVRQSfHY4n0dwatlT+cfb06/01ufKhS+C
	 zhXTrjOn4c8Ckqwogte8kYCp4joay0q7JcsJ00kwEAM10iNOXUc8HbubTrsnuSa8/6
	 TM7QPDyDQRhew57iahAs7HxgBlZvozLSYXFuIj/9sdePZTPLy4LyBOpW329GGMA4wy
	 R8xfMCZSDPjvDUfBugNt12cMtcN9gghx1geU1OZgFUlh+Drsze5gQVdAX1sENZnaU6
	 3WhX7vk2Wrq0w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 00/49] KVM: arm64: Add LR overflow infrastructure (the final one, I swear!)
Date: Mon, 24 Nov 2025 14:44:01 -0800
Message-ID: <176402422342.855688.6586598326485098287.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 20 Nov 2025 17:24:50 +0000, Marc Zyngier wrote:
> As $SUBJECT says, I really hope this is the last dance for this
> particular series -- I'm done with it! It was supposed to be a 5 patch
> job, and we're close to 50. Something went really wrong...
> 
> Most of the fixes have now been squashed back into the base patches,
> and the only new patch is plugging the deactivation helper into the NV
> code, making it more correct.
> 
> [...]

Applied to next, thanks!

[01/49] irqchip/gic: Add missing GICH_HCR control bits
        https://git.kernel.org/kvmarm/kvmarm/c/8cb4ecec5e36
[02/49] irqchip/gic: Expose CPU interface VA to KVM
        https://git.kernel.org/kvmarm/kvmarm/c/fa8f11e8e183
[03/49] irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
        https://git.kernel.org/kvmarm/kvmarm/c/08f4f41c1e95
[04/49] KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
        https://git.kernel.org/kvmarm/kvmarm/c/8d3dfab1d305
[05/49] KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
        https://git.kernel.org/kvmarm/kvmarm/c/567ebfedb5bd
[06/49] KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
        https://git.kernel.org/kvmarm/kvmarm/c/2a28810cbb8b
[07/49] KVM: arm64: Repack struct vgic_irq fields
        https://git.kernel.org/kvmarm/kvmarm/c/a4413a7c31cf
[08/49] KVM: arm64: Add tracking of vgic_irq being present in a LR
        https://git.kernel.org/kvmarm/kvmarm/c/879a7fd4fd64
[09/49] KVM: arm64: Add LR overflow handling documentation
        https://git.kernel.org/kvmarm/kvmarm/c/0dc433e79ad0
[10/49] KVM: arm64: GICv3: Drop LPI active state when folding LRs
        https://git.kernel.org/kvmarm/kvmarm/c/73c9726975af
[11/49] KVM: arm64: GICv3: Preserve EOIcount on exit
        https://git.kernel.org/kvmarm/kvmarm/c/f4ded7b0848e
[12/49] KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
        https://git.kernel.org/kvmarm/kvmarm/c/00c6d0d4a805
[13/49] KVM: arm64: GICv3: Extract LR folding primitive
        https://git.kernel.org/kvmarm/kvmarm/c/438e47b697f7
[14/49] KVM: arm64: GICv3: Extract LR computing primitive
        https://git.kernel.org/kvmarm/kvmarm/c/1ae0448ca797
[15/49] KVM: arm64: GICv2: Preserve EOIcount on exit
        https://git.kernel.org/kvmarm/kvmarm/c/5ceb3dac8022
[16/49] KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
        https://git.kernel.org/kvmarm/kvmarm/c/a00c88ac1f90
[17/49] KVM: arm64: GICv2: Extract LR folding primitive
        https://git.kernel.org/kvmarm/kvmarm/c/3aa9a50c2007
[18/49] KVM: arm64: GICv2: Extract LR computing primitive
        https://git.kernel.org/kvmarm/kvmarm/c/0660bc4a2b70
[19/49] KVM: arm64: Compute vgic state irrespective of the number of interrupts
        https://git.kernel.org/kvmarm/kvmarm/c/dd598fc1139f
[20/49] KVM: arm64: Eagerly save VMCR on exit
        https://git.kernel.org/kvmarm/kvmarm/c/cf72ee637119
[21/49] KVM: arm64: Revamp vgic maintenance interrupt configuration
        https://git.kernel.org/kvmarm/kvmarm/c/6780a756044c
[22/49] KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
        https://git.kernel.org/kvmarm/kvmarm/c/f04b8a5a83db
[23/49] KVM: arm64: Make vgic_target_oracle() globally available
        https://git.kernel.org/kvmarm/kvmarm/c/76b2eda65ccc
[24/49] KVM: arm64: Invert ap_list sorting to push active interrupts out
        https://git.kernel.org/kvmarm/kvmarm/c/05984ba67eb6
[25/49] KVM: arm64: Move undeliverable interrupts to the end of ap_list
        https://git.kernel.org/kvmarm/kvmarm/c/33c1f60b3213
[26/49] KVM: arm64: Use MI to detect groups being enabled/disabled
        https://git.kernel.org/kvmarm/kvmarm/c/a69e2d6f8934
[27/49] KVM: arm64: GICv3: Handle LR overflow when EOImode==0
        https://git.kernel.org/kvmarm/kvmarm/c/3cfd59f81e0f
[28/49] KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
        https://git.kernel.org/kvmarm/kvmarm/c/cd4f6ee99b28
[29/49] KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
        https://git.kernel.org/kvmarm/kvmarm/c/295b69216558
[30/49] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
        https://git.kernel.org/kvmarm/kvmarm/c/70fd60bdedc9
[31/49] KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
        https://git.kernel.org/kvmarm/kvmarm/c/1c3b3cadcd69
[32/49] KVM: arm64: GICv3: Handle in-LR deactivation when possible
        https://git.kernel.org/kvmarm/kvmarm/c/ca3c34da3644
[33/49] KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
        https://git.kernel.org/kvmarm/kvmarm/c/84792050e039
[34/49] KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emulation
        https://git.kernel.org/kvmarm/kvmarm/c/eb33ffa2bd3f
[35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive
        https://git.kernel.org/kvmarm/kvmarm/c/6dd333c8942b
[36/49] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
        https://git.kernel.org/kvmarm/kvmarm/c/78ffc28456f5
[37/49] KVM: arm64: GICv2: Handle LR overflow when EOImode==0
        https://git.kernel.org/kvmarm/kvmarm/c/281c6c06e2a7
[38/49] KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
        https://git.kernel.org/kvmarm/kvmarm/c/255de897e7fb
[39/49] KVM: arm64: GICv2: Always trap GICV_DIR register
        https://git.kernel.org/kvmarm/kvmarm/c/07bb1c5622a5
[40/49] KVM: arm64: selftests: gic_v3: Add irq group setting helper
        https://git.kernel.org/kvmarm/kvmarm/c/a1650de7c160
[41/49] KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
        https://git.kernel.org/kvmarm/kvmarm/c/2366295c76c2
[42/49] KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
        https://git.kernel.org/kvmarm/kvmarm/c/27392612c882
[43/49] KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
        https://git.kernel.org/kvmarm/kvmarm/c/8b7888c5114d
[44/49] KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
        https://git.kernel.org/kvmarm/kvmarm/c/5053c2ab92a1
[45/49] KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
        https://git.kernel.org/kvmarm/kvmarm/c/fd5fa1c8d09a
[46/49] KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
        https://git.kernel.org/kvmarm/kvmarm/c/b6c68612ab41
[47/49] KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation test
        https://git.kernel.org/kvmarm/kvmarm/c/d2dee2e84983
[48/49] KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
        https://git.kernel.org/kvmarm/kvmarm/c/1c9c71ac1b9f
[49/49] KVM: arm64: selftests: vgic_irq: Add timer deactivation test
        https://git.kernel.org/kvmarm/kvmarm/c/de8842327728

--
Best,
Oliver

