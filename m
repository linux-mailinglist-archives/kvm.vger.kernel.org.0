Return-Path: <kvm+bounces-38482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30BB7A3A976
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 503AD1777D3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13FE214223;
	Tue, 18 Feb 2025 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y64xFEE3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA0D1DE2CE;
	Tue, 18 Feb 2025 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910435; cv=none; b=GQaM5TFSfaBs0z7BHDkzDoWoqOmnhA+50UXiwRI97XoW9TSqTST0EPSaKSMzgfP1w/hWSAGu19IfgtDm/flObzQh6SqOZDU5LQDbpCEBUL1eLcTv3ouLzYTp58xRwQY4r8p/0wVhSSjaesqkvPgdOqTXhkYGrlUdrK+8e5G7aqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910435; c=relaxed/simple;
	bh=GHTy+unD3cckDiDsDM1wC4/h/2OsZjXd9SeGqkeEjw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ewLsnjraP7QBLd+DpcYo0JseaBSO6u194YirV5ZCDmnCedEYHgrEH0vq9v9lV0mHGqwys7dBeLLlsYjz2ywF7ugqLSPwmq4UYQr0xnYyJRPiGSkL8YDYvJ6lRLfoLGrbn/GOuk0pmAycwtRlnrYVu09+dCmUArFfTPs2zz9Ro0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y64xFEE3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C597DC4CEE4;
	Tue, 18 Feb 2025 20:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739910434;
	bh=GHTy+unD3cckDiDsDM1wC4/h/2OsZjXd9SeGqkeEjw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y64xFEE3Iw+bgSr+XpRP36ODOTV1CPVCmeaBNLZ+pfo3jdKMh+WNIK72CfmgDPHc5
	 ATAcFTSKMTKIhhNlVyatgyQqXHDga928DWaNc/EQHCmiXCNtJatorFtMsgsWGaRLha
	 UwB+maCF/ne1kWxJuOg7RB3hQ9cxdePqAjY3fTEagzTrhI5qGGQs2LoEQSJ+LA0WyX
	 InKLoHrFaiB4tXF6QcrU91FBsdSDcJjQJSlPOBcLI7lDYdPkUihgqHvCOvtfAZLp/9
	 Kr3l2hQxlDj/lOaiy3Ws+WHvScrdhv2xSHiz5EZOhkCA67cwYhHUJobCRVTfFX0SSq
	 GVd9WSG/qL5ng==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	zhaotianrui@loongson.cn,
	chenhuacai@kernel.org,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 25/31] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Tue, 18 Feb 2025 15:26:11 -0500
Message-Id: <20250218202619.3592630-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250218202619.3592630-1-sashal@kernel.org>
References: <20250218202619.3592630-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.15
Content-Transfer-Encoding: 8bit

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 3011b29ec5a33ec16502e687c4264d57416a8b1f ]

PRMD register is only meaningful on the beginning stage of exception
entry, and it is overwritten with nested irq or exception.

When CPU runs in VM mode, interrupt need be enabled on host. And the
mode for host had better be kernel mode rather than random or user mode.

When VM is running, the running mode with top command comes from CRMD
register, and running mode should be kernel mode since kernel function
is executing with perf command. It needs be consistent with both top and
perf command.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/switch.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f8184927..1be185e948072 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -85,7 +85,7 @@
 	 * Guest CRMD comes from separate GCSR_CRMD register
 	 */
 	ori	t0, zero, CSR_PRMD_PIE
-	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+	csrwr	t0, LOONGARCH_CSR_PRMD
 
 	/* Set PVM bit to setup ertn to guest context */
 	ori	t0, zero, CSR_GSTAT_PVM
-- 
2.39.5


