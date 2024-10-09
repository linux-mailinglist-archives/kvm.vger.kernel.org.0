Return-Path: <kvm+bounces-28315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DDD997535
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991F51C224F5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DB31E201E;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVzd1RmV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A195C1E1A0F;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=otpr/P7vgLp/5sB0wgDqMLz51RmG3iiqikv8y/QHtnHwZ+YDsyPup0RhDQID3hImivSO9s9HhcKJ/mfoo+k8pnDux340MMrffJrh59lyah1CZ5jZV8VQ9GpX6t+uOAt0PXiMHJTwB4WFhAx+fpHJ/97la/jBrTgyLKQsaDKlIsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=V2gaNQUIj9Ndd/20OKV+EYyMNIrQ8wsENOpxc4LklRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BuAZPVtZqIjj2OZ2yf93sB1LB22MHW6NOB7iIHoQjq+MEWsn0cr2sGuf96DKaE8/hkM6DfkS6mXWdM7uVy7xvXjqsbH2cEU4v6odf44zQZlS9HxpLvKPeb/j0bMpB++svshKGZqH30ezmwA756+zuVGOQQ9/NgKIUaK6EDyLmWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVzd1RmV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401FAC4CED5;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=V2gaNQUIj9Ndd/20OKV+EYyMNIrQ8wsENOpxc4LklRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVzd1RmVUIIgb5Cs80NI2gS8BpMp2i1UY65TxJPgFZEJKN7BU2lCbP268L3soj+zW
	 MUT+VcnnloSG0IT5tBkbvUjbdojT4VT0Cqgc3Iq/bi2A2v2M6wl9Z+yV1aClFwuksm
	 XKUV18BnQH5QVve0+tieqNNGtAJUtNpC7nZz15MvwxtZr37DasZzeMz4fQ3TZVT9Bh
	 055eySESuM/mShecbryv5/wU/n0eOigHSIfkIpounHi3SmO1rCRgV3yro95NINfjnr
	 3wHevilbViUl76EbWMs+c+3FeVz+57lOabCta25kc7UYDYprAIZZZRr+D6TFhgmh89
	 zN3z1hDjlPwxg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvN-001wcY-DK;
	Wed, 09 Oct 2024 20:00:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 04/36] KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
Date: Wed,  9 Oct 2024 19:59:47 +0100
Message-Id: <20241009190019.3222687-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

__kvm_at_s1e2() contains the definition of an s2_mmu for the
current context, but doesn't make any use of it. Drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 39f0e87a340e8..f04677127fbc0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -992,12 +992,9 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * switching context behind everybody's back, disable interrupts...
 	 */
 	scoped_guard(write_lock_irqsave, &vcpu->kvm->mmu_lock) {
-		struct kvm_s2_mmu *mmu;
 		u64 val, hcr;
 		bool fail;
 
-		mmu = &vcpu->kvm->arch.mmu;
-
 		val = hcr = read_sysreg(hcr_el2);
 		val &= ~HCR_TGE;
 		val |= HCR_VM;
-- 
2.39.2


