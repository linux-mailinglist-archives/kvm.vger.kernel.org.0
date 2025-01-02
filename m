Return-Path: <kvm+bounces-34503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 981499FFF61
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 20:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44BD07A1982
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9892B1B4238;
	Thu,  2 Jan 2025 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOco+yHX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1786250;
	Thu,  2 Jan 2025 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735845923; cv=none; b=cfZRrX3UUaqQc0WkGl1N3ADVj0JI9kecJLomQGraNQAE5e0VC1anGtuNVLqnzzUCJbaMlkTKI0O4O4Mjpsdl5AtA/47tL3K5+PC66fGLuq9+wb+qJqGq0Qv1kYAamFVTsKp6Z3ndRnUF9LxPuy5+mPI6uoJcaQ3WAobfCKgt9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735845923; c=relaxed/simple;
	bh=KUMIyjQ4nZZlXB09ywwBTfalUhusJhQ+ekMU5Ns2Kms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eEhSxbJfCGZZQtfFpFUQvNOIoIT3ehWXiY86nrjOWRfSBCqtvdlL/dNQRPar5K3eDIe5KkJ5X71kZX1T1DeFTuNyxC1VJKrMEBdA+vvB3gk7PaylP5r+IBPCJKxQJaE08w8Vy0oKs1Zdb9qoPtM6e7uHJM0daka7EdUzw8nqluE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOco+yHX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444CDC4CED0;
	Thu,  2 Jan 2025 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735845923;
	bh=KUMIyjQ4nZZlXB09ywwBTfalUhusJhQ+ekMU5Ns2Kms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOco+yHXIBJL9y5HUEX/ZV5LCUhWE92rAY/QEoemcZFS9byEy1MQnvYZ1OQm7zdmk
	 9XypXaN0gbl5+Ek+tNOjv56jY5a7mrkGiXJsMfZWryTFEx9W8V2FrJfOlZXCgEU+RX
	 XvGbTxMaHtwEteHzi/55fLNQ0zbC0aGm4Ys2fKkrURMgEYBszwKPmtjjQacaT+wk3t
	 smKvkl2qhk18iS1KDnaxQi0q2B4srGhNVogsNl4eQc0cc5kB+wK4+V4Kmx3Y2jwlBf
	 bizg9b71KVa4Qnr5udHOcA+UeWOInx75yn+2GyKL+RuPmbbMhWILse5dp8amxzBfIa
	 0WbfNBJ+5VmvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tTQor-008Vst-2S;
	Thu, 02 Jan 2025 19:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 00/12] KVM: arm64: Add NV timer support
Date: Thu,  2 Jan 2025 19:25:17 +0000
Message-Id: <173584591101.1567893.2047112696934752500.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 17 Dec 2024 14:23:08 +0000, Marc Zyngier wrote:
> Here's another version of the series initially posted at [1], which
> implements support for timers in NV context.
> 
> From v1:
> 
> - Repainted EL0->EL1 when rambling about the timers
> 
> [...]

Applied to next, thanks!

[01/12] KVM: arm64: nv: Add handling of EL2-specific timer registers
        commit: b59dbb91f7636a89b54ab8fff756afe320ba6549
[02/12] KVM: arm64: nv: Sync nested timer state with FEAT_NV2
        commit: 4bad3068cfa9fc38dd767441871e0edab821105b
[03/12] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
        commit: cc45963cbf6334d2b9078f06efef9864639cddd0
[04/12] KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
        commit: 2cd2a77f9c32f1eaf599fb72cbcd0394938a8b58
[05/12] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in use
        commit: 338f8ea51944d02ea29eadb3d5fa9196e74a100d
[06/12] KVM: arm64: nv: Accelerate EL0 counter accesses from hypervisor context
        commit: 9b3b2f00291e1abd54bff345761a7fadd8df4daa
[07/12] KVM: arm64: Handle counter access early in non-HYP context
        commit: b86fc215dc26d8e1bb274f0a7990b5deab740ac8
[08/12] KVM: arm64: nv: Add trap routing for CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}
        commit: c271269e3570766724820bcb76a144125dead272
[09/12] KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
        commit: 479428cc3dc99bbe28954b62b053b22accbfd1fd
[10/12] KVM: arm64: nv: Sanitise CNTHCTL_EL2
        commit: d1e37a50e1d781201768c89314532f6ab87e5a42
[11/12] KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity
        commit: 0bc9a9e85fcf4ffb69846b961273fde4eb0d03ab
[12/12] KVM: arm64: nv: Document EL2 timer API
        commit: affd1c83e090133a3d1750916c7911b20f8911c0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



