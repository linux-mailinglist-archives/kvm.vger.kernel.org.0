Return-Path: <kvm+bounces-25561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0472966A29
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D61BB22956
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 20:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B9F1BF7F8;
	Fri, 30 Aug 2024 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIVs1eTY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2211BF32B;
	Fri, 30 Aug 2024 20:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725048090; cv=none; b=Mx7u0e6Pv963o/zaGjuDdAMLIdLckdu6kIjCCRP8K6SnqDSXCbFP0j+rjBoGaVFsOCuT0JY5paf9Q6kQ6ni4nWJdVRtc6vZHLs4UJGC0J1y9hJZzD7LnGoiyqAw8h4J6GrA+UW98XhOjzF27oAwMPppF77H+dJs4MZPsHMSZ18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725048090; c=relaxed/simple;
	bh=UnnRz/fXubHjZaCcgN3w8cVmELw8vTqbztLRBLNlvwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sk0tjRuYlQipgv7vQcoTdmRcgmAQ7APughk2cZ43UTzZKgoacbxkvX5DCerezBmQ/EraliB66Z/ARQViYDwcUhc1EhtGuelxFs5oNmDd5DhGH4ocaMZ61lOHufFunYy8VXwLwaZhFSNf4+EQuAWsAVhZ7LzksEZRFiKSY5kOD0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIVs1eTY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4EC4CEC2;
	Fri, 30 Aug 2024 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725048090;
	bh=UnnRz/fXubHjZaCcgN3w8cVmELw8vTqbztLRBLNlvwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIVs1eTYBMNJLXUF/c9tjbcPnL6OnpO9stlJ/Qk8WgmoqqcJ1NmNs0Nn7pjJ2xVEJ
	 s26c9pc/iMPQ8iJ2vDcWq30oV3yMQKq7cME7O9ZMI5rzt0HeioytJqKqNL/N3Y3e9N
	 u85q+mj8rFn1Ov7BpbbSN7Mq7QGc0D5/k0s3oRy9MxZCJ97X7tABt+2pch7Fdnxvjy
	 WM7JJCRYJKwwYSaUoF8DCc9aAJi3lfQlSHFZoX2jWXaGim5ROH9y08t+Vl8pOj5C/t
	 YE70V94syL76t/fZcmRcEgudAdUzRsctIweQ/+NhaL9RnCt+Gkc1vxzHQuaqhD9IT3
	 XikH32811nJnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sk7oF-008LX5-Bt;
	Fri, 30 Aug 2024 21:01:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v4 00/18] KVM: arm64: nv: Add support for address translation instructions
Date: Fri, 30 Aug 2024 21:01:24 +0100
Message-Id: <172504804211.526098.10058042822239904952.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Aug 2024 11:37:38 +0100, Marc Zyngier wrote:
> This is the fourth revision of the address translation emulation for
> NV support on arm64 previously posted at [1].
> 
> Thanks again to Alex for his continuous (contiguous? ;-) scrutiny on
> this series.
> 
> * From v3:
> 
> [...]

Applied to kvm-arm64/s2-ptdump, thanks!

[01/18] arm64: Add missing APTable and TCR_ELx.HPD masks
        commit: 4abc783e4741cd33216e7796e9b2f4973b4bca61
[02/18] arm64: Add PAR_EL1 field description
        commit: 6dcd2ac7ea7c5b20b416ee09d8d5d2ec89866ef8
[03/18] arm64: Add system register encoding for PSTATE.PAN
        commit: b229b46b0bf7828bef5f88c91708776869b751ac
[04/18] arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
        commit: 5fddf9abc31a57e2cc35287998994cf4a684fada
[05/18] KVM: arm64: Make kvm_at() take an OP_AT_*
        commit: 69231a6fcb638b7929e9fc88c4fa73a04e6d4e0c
[06/18] KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
        commit: 4155539bc5baab514ac71285a1a13fcf148f9cf1
[07/18] KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
        commit: 0a0f25b71ca544388717f8bf4a54ba324e234e7a
[08/18] KVM: arm64: nv: Honor absence of FEAT_PAN2
        commit: 90659853febcf63ceb71529b247d518df3c2a76c
[09/18] KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
        commit: 477e89cabb1428d5989430d57828347f5de2be9c
[10/18] KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
        commit: be0135bde1df5e80cffacd2ed6f952e6d38d6f71
[11/18] KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
        commit: e794049b9acbd6500b77b9ce92a95101091b52d3
[12/18] KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
        commit: be04cebf3e78874627dc1042991d5d504464a5cc
[13/18] KVM: arm64: nv: Make ps_to_output_size() generally available
        commit: 97634dac1974d28e5ffc067d257f0b0f79b5ed2e
[14/18] KVM: arm64: nv: Add SW walker for AT S1 emulation
        commit: d6a01a2dc760c8350fa182a6afd69fabab131f73
[15/18] KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
        commit: 2441418f3aadb3f9232431aeb10d89e48a934d94
[16/18] KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
        commit: d95bb9ef164edb33565cb73e3f0b0a581b3e4fbb
[17/18] KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
        commit: 8df747f4f3a5c680e3c0e68af3487b97343ca80a
[18/18] KVM: arm64: nv: Add support for FEAT_ATS1A
        commit: ff987ffc0c18c98f05ddc7696d56bb493b994450

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



