Return-Path: <kvm+bounces-38478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F625A3A8FF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6EBB7A1DB5
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CAC61E5B76;
	Tue, 18 Feb 2025 20:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDIYHCJO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3361E3775;
	Tue, 18 Feb 2025 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910349; cv=none; b=ApVke20nArGO2DEgTdoNhakLjWjEBKpKpJ7D4wydDaVmOtClLCID7jICLAa8oTb/wSpsgHB5yT4S142PrhPWOKPIzwQ598KloFSNnIKmIHRO6EYC4Yko0dKv1ITzXDZ1lSR2j/YAS2U0V/t82NwNMLiQaAbAAk6HW3ZacSnxnjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910349; c=relaxed/simple;
	bh=GHTy+unD3cckDiDsDM1wC4/h/2OsZjXd9SeGqkeEjw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=au7G7qq1BPDRbO5+dhnACBJm2tNUh7I/iOL0TGup2gfRDjauYUBHExuuqxSwPUpsyF0xtL7ekIdHt1daDOmyhtKrxuPYkNiBa/YWceR05BORrL2uhnpGVFCNst5wXzvIi9/E+245gCxPDkqbTpsFWRoEIwIhFgbiA3ktyeF46eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDIYHCJO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D791C4CEE8;
	Tue, 18 Feb 2025 20:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739910349;
	bh=GHTy+unD3cckDiDsDM1wC4/h/2OsZjXd9SeGqkeEjw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDIYHCJOXs7BEW76d710T/lyyy5ZWc5c73RbiHiFlVmW5TFyNKjAlSLhBnxthFBXj
	 51O9yclkJbGW2f+46yo43td2DuoCDa2ohCQH06ZBqnBGu4mwbMTV8Gri9sN2cNzV1/
	 ksvOEFZmbobUyS+tajce9nMBA27DJ1MfD7wynPVj4WkD7z5T9ZBmdjwF1L9B2ScDBv
	 qugMz9ZJ6HEEn6jlDVQNZu9TP8szMifAqCsHzfSDZQmsIuGY4BTk8ZYqy7mhmV8oEQ
	 h3QwqOal36RyzFOoF8xGfj4Qd+bYKK8Ybjh2xgigRLWZWfhYd2iMXBAXzeZ3MqzTP9
	 fnDRvzMHuI7aA==
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
Subject: [PATCH AUTOSEL 6.13 25/31] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Tue, 18 Feb 2025 15:24:45 -0500
Message-Id: <20250218202455.3592096-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250218202455.3592096-1-sashal@kernel.org>
References: <20250218202455.3592096-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.3
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


