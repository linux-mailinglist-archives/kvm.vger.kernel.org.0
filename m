Return-Path: <kvm+bounces-46489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50735AB68F0
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B1CD3B0BC4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F75278163;
	Wed, 14 May 2025 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0vIT+d1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8852277806;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218910; cv=none; b=QCHehbn6PfUyc+AXcQ2Jco38bvSsssRrFmVqWlXXpfjI9Rnm/2P4eenZcvTxcY9PRzYGdGJrO8AiYba2Pe+1+h+DHQhPtWTZAkFO2ILhf/B7N4AgqPMQChvCiL1qJtxcdqSeaZ1cKLEyqK5MO8p1BYdgULuD6WtgiWcmOfBINgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218910; c=relaxed/simple;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AcW3QP5XxPbicjl9wDKPAEOdmADHMERhJFLK1OWgoHWGoiD7ZVdIL7hqMgHrCHAk/CN8PigbQxQ9lgC9yzADdhxsNAWjxGsM20+ay1/9duw+p/4Z4njaCehAJCtchhmeY5Ea9BBBMPv8IBRqHSxDD5GaR0+87vCrzPEovYf+NBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0vIT+d1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238FAC4CEE9;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218909;
	bh=6xnfxO24XeMhZUOFnH7AZVi9lO940gonY1iIvv10IoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0vIT+d1T/KWB+Gwz6oiqrERfVUZCCZrJFP2uegVvy5hTjm7o3DjYMLBR/fM8kDOo
	 PPbcEB5rsF3nvmglD/HxqaKZ0YLwhxjQEGvpGQ6UJ4i+Lmh+3BrYDz6X7q46FAUX97
	 yt83Nei4dtDAIb0XfHOPu5PTYVb+g0zQNkuszasBR9tX2cTnMQUU5dv0yYVsUItlha
	 Qtf/h168HUFmxZQv3BpUFJPnO1N6jMDV4KMlehRMA60fD6jSws42tNRK65ekoYvKB1
	 xLfQy+OVUXeBk6oskZYC5ehSbU2rIN8RY+BQvONJhLlNLxVp4pjelPOSTHYC6GpL8M
	 66uzL4BTe0DHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S7-00Eos3-Cg;
	Wed, 14 May 2025 11:35:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 15/17] KVM: arm64: nv: Remove dead code from ERET handling
Date: Wed, 14 May 2025 11:34:58 +0100
Message-Id: <20250514103501.2225951-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Cleanly, this code cannot trigger, since we filter this from the
caller. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 0fcfcc0478f94..5e9fec251684d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2471,13 +2471,6 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
 	u64 spsr, elr, esr;
 
-	/*
-	 * Forward this trap to the virtual EL2 if the virtual
-	 * HCR_EL2.NV bit is set and this is coming from !EL2.
-	 */
-	if (forward_hcr_traps(vcpu, HCR_NV))
-		return;
-
 	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
 
-- 
2.39.2


