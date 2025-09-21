Return-Path: <kvm+bounces-58339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DECE4B8D97D
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 12:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09C617AD36B
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 10:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4C5258CE7;
	Sun, 21 Sep 2025 10:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMc2JFpa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DAB249E5;
	Sun, 21 Sep 2025 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758452276; cv=none; b=U2Sj9KoOV7I5mU2QVRMXhAM92fo6C77+WDdFHGNndj1O6OcU/oxOIgpb1XbI6t0+LhQN9qE6pD+K4Atb4TScICfAQinCTasP35k5ttRLrpUJzFbcfVpagfb6tCtnEITEGMy/Of8sCQ+an2ubuzTK7q+pGfIUuunKP1CP5NAw+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758452276; c=relaxed/simple;
	bh=8Op61nzSpVhT7RNzCmXUhBy/d+AQXo4ddYpTYafvvqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCst/yZZAwofyX6Fk/yLlTKbbQ4MKuMVeaUyEmtTYN+MAViYiAmgee4OQXDS3JG248uMILyz1CEjys4xZ3Lo3NX1NhQWc3u7mJzHJuU5G6O71sepMszlBsWSgHjhL92gKY8+r7/2vJeQv0taFeOxECjYvrTk8M6spJBOmMXOcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMc2JFpa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40ADC4CEE7;
	Sun, 21 Sep 2025 10:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758452275;
	bh=8Op61nzSpVhT7RNzCmXUhBy/d+AQXo4ddYpTYafvvqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMc2JFpawOs1NCf2REhhEkTHNX9fUpIq361qjmtT7U/BmpovsSDZ7s/QfreyO47SG
	 RykgxkEZjd3BzyMNOD7b5Dny4PRdXauRP3Xm2lPP1wXq2erStMj/V5ho428gMs7HIU
	 uTr8lW6HZewvWPsdvkZAkP1JNYseW3O57VoXGQtbVFFZoCfoirrCRqQeg2zApm1QPj
	 /4avlvMR+5c78M7VAjMH7+9AU7Ph7hKeP2SboLi3Fa+4I/eDHsJ5n3OxFQ4R2QerV7
	 Q+9AMhWw6MmY/LuxP2dEv6cHgcbpxDJsFPkUb2UlqvZa0CTUOcnhGxysnQPkh6K0uQ
	 CoJxK7ae7XwzQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v0HlR-000000089rB-0xoW;
	Sun, 21 Sep 2025 10:57:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 00/16] KVM: arm64: TTW reporting on SEA and 52bit PA in S1 PTW
Date: Sun, 21 Sep 2025 11:57:49 +0100
Message-ID: <175845226586.1792635.11249464012956393475.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 15 Sep 2025 12:44:35 +0100, Marc Zyngier wrote:
> Yes, $SUBJECT rolls off the tongue.
> 
> This series was triggered by the realisation that when injecting an
> SEA while on a S1PTW fault, we don't report the level of the walk and
> instead give a bare SEA, which definitely violates the architecture.
> 
> This state of things dates back to the pre-NV days, when we didn't
> have a S1 page table walker, and really didn't want to implement one.
> I've since moved on and reluctantly implemented one, which means we
> now *could* provide the level if we really wanted to.
> 
> [...]

Applied to next, thanks!

[01/16] KVM: arm64: Add helper computing the state of 52bit PA support
        commit: 0090c0a247cd3dc37181be4a9af4750ae3fedbd0
[02/16] KVM: arm64: Account for 52bit when computing maximum OA
        commit: 23cf13def0c87d9ce234f12eb6132f6bf9442f29
[03/16] KVM: arm64: Compute 52bit TTBR address and alignment
        commit: e645226a9c238db919d105d0ee7b4e09d80d13b1
[04/16] KVM: arm64: Decouple output address from the PT descriptor
        commit: df1d0197a2b939e28321686cafaead4a183980fa
[05/16] KVM: arm64: Pass the walk_info structure to compute_par_s1()
        commit: e4bd479884a1353efd43aa950c996d333145642d
[06/16] KVM: arm64: Compute shareability for LPA2
        commit: c0cc438046eed8d906ac917bc70a7284b6cc3f03
[07/16] KVM: arm64: Populate PAR_EL1 with 52bit addresses
        commit: dd82412c2b2b30bf4aa08ef069eb38c7795cd9b8
[08/16] KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
        commit: 5da3a3b27a0108562547086e0ba7d9593f147cfe
[09/16] KVM: arm64: Report faults from S1 walk setup at the expected start level
        commit: dabf9f73fed86e096255c5be12c7e1d08a939c67
[10/16] KVM: arm64: Allow use of S1 PTW for non-NV vcpus
        commit: 14d4802dc22acf670333c8aad4e1931e7d6ee412
[11/16] KVM: arm64: Allow EL1 control registers to be accessed from the CPU state
        commit: cb1762904c5000220a0facf9bcab68ba687ec417
[12/16] KVM: arm64: Don't switch MMU on translation from non-NV context
        commit: 61b0280a670bdbb3a209ae474625f387788af0a8
[13/16] KVM: arm64: Add filtering hook to S1 page table walk
        commit: 0c5471408cb5c518bce76b851aff89719283a428
[14/16] KVM: arm64: Add S1 IPA to page table level walker
        commit: b8e625167a321138f83b1f6c99cf25d1290cb04e
[15/16] KVM: arm64: Populate level on S1PTW SEA injection
        commit: 50f77dc87f133b09db44a5bbfdd64b1ca83a8d8e
[16/16] KVM: arm64: selftest: Expand external_aborts test to look for TTW levels
        commit: 00a37271c8a68070dc64f81a5d64644beb4cef2f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



