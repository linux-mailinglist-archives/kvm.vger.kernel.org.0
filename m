Return-Path: <kvm+bounces-64954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48970C93FFC
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 15:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA553A6382
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 14:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D3B30FC37;
	Sat, 29 Nov 2025 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xwjdl5Ey"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D11B4224;
	Sat, 29 Nov 2025 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764427531; cv=none; b=MVLojYyh/seEA3/pe4uF/ea+kGqmzyENEM3uEIdlRpQr1MxB1TPYufnWUZti8OX9WGFVdECiAXTU6NH5ITHKfQEjVPyLYYVjwRPcruWmnDTJc305Imzdmg+vGZHEzHVIRYrWnOqUbCQKgJ0eNJfwn9JM0QQNdS/0wngVXo6TeXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764427531; c=relaxed/simple;
	bh=7tC7op/J6rZJJxjSeQrwuiT/WKqfCsxg4T0/eT/3V3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tkGshztADZVOrzw1cKgFqmTAdEtv8m8wa/FzRKKVXkJqoFqc5MPOE6hI50otbNQZ0Me48K8GZlpqWe8SMLYUkO8a1/noskXHC+5Ei1bUgsHDC2PEIeR376upUBgjuw+yBJ5SO0Rgstr4rxfJ6N5oW3oObllFGWgO+GFgHcv9g4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xwjdl5Ey; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E051C4AF0B;
	Sat, 29 Nov 2025 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764427530;
	bh=7tC7op/J6rZJJxjSeQrwuiT/WKqfCsxg4T0/eT/3V3w=;
	h=From:To:Cc:Subject:Date:From;
	b=Xwjdl5EyjbRBMY8k6J8fOB0VOKULwD7uBLYx5dibgztz6l5wo1AYAfMx/y3nk3Noa
	 eV9rdA28P2qWeOnQI4mX5trNfM2QOAwZp2mC+JVNXDIWmO4nWKyAnCDJGkS4S7WXLI
	 +865rIi2o597uELMkfbM3zf50KODmH89OZislubOkVaDzkYSoJzn4Em38YHQYuXCsL
	 XBZfI5+3CWT8D5DKOOgcNcCDXXVYsUmIVF62BlJXW0DM9FWtqNUV2WDDKDjf3e/CYs
	 qFwGt9I3KqyQr+Cl0SYMevJMCnBTQWGvCnDKOoQalvdPbybItKrBAEudZHw2VYS0Hv
	 hy3eYAPLt12TQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vPMCW-00000009HnQ-14Nf;
	Sat, 29 Nov 2025 14:45:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/4] KVM: arm64: VTCR_EL2 conversion to feature dependency framework
Date: Sat, 29 Nov 2025 14:45:21 +0000
Message-ID: <20251129144525.2609207-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Alexandru recently pointed out [0] that the RES0 handling of VTCR_EL2
was broken now that we have some support for stage-2 AF.

Instead of addressing this piecemeal as Alexandru was suggesting in
his series, I've taken the approach to do a full-blown conversion,
including moving VTCR_EL2 to the sysreg file (the latter resulting in
a bit of churn in the page table code, both canonical and nested).

The result is, as usual, on the larger side of things, but mostly made
of generated stuff, though the definition for FEAT_LPA2 is horrific,
and required some adjustments to the way we define TGRAN*_2.

Lightly tested on M2.

[0] https://lore.kernel.org/r/20251128100946.74210-1-alexandru.elisei@arm.com

Marc Zyngier (4):
  arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
  arm64: Convert VTCR_EL2 to sysreg infratructure
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP()
  KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation

 arch/arm64/include/asm/kvm_arm.h | 52 ++++++-----------------
 arch/arm64/include/asm/sysreg.h  |  1 -
 arch/arm64/kvm/config.c          | 72 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c     |  8 ++--
 arch/arm64/kvm/nested.c          | 11 +++--
 arch/arm64/tools/sysreg          | 63 ++++++++++++++++++++++++++--
 6 files changed, 151 insertions(+), 56 deletions(-)

-- 
2.47.3


