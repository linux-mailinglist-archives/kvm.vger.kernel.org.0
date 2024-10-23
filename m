Return-Path: <kvm+bounces-29526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 056C69ACDDF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A479E1F20FDD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0B51CFEDC;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0B8yTgz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778321C830E;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695232; cv=none; b=OqYlZiasAYVlnl5Xi0ADOLp6jJVLBWoLty1eUDARSq/vSXFSMqJxTLcyWEWiIXvLLKvznRNdW8Pu1Luaest9RHbrMle0XEf9dywj2OWGOrlizEx11QZHeFZUCFZdmi9wCEDZ5mX4iC0xeicdskUOqr5AAHA1VQ3L+oFr9IG8cmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695232; c=relaxed/simple;
	bh=V2gaNQUIj9Ndd/20OKV+EYyMNIrQ8wsENOpxc4LklRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLybthPkfa+bHqCvVr8SeBQ7j4+BojczQD5PXAmazb4lsnqUKE/ikGaCy6zGzeWfoC59p0sM+/myV9Onws2mYEepINbgiZFK1A5gETIXgOv5LmvTKyZQrgLCpbC0UTVOJfFFpUH0hXwJ4CRX/0IVPVVDq1ecBUc01ijE3tGO7Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0B8yTgz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18349C4CEEF;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695232;
	bh=V2gaNQUIj9Ndd/20OKV+EYyMNIrQ8wsENOpxc4LklRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0B8yTgzGNwJHYrGwRf0JjQznwLRz2V1Bt9j9a4HhaV87egqSEeA1KQgflKtvYYA2
	 GCmQJGQUHXbnapg6tB/mEvkZ7uhXiHK1yUuZhStg7LqpbNa9r0pTKUo7qJQXX1Vx3N
	 EOrApQSDffDR1e2/UkhW/PFeE1IHUu7OB1KoOrcvMyzakigDfZ22Rlflio38Zu7TPX
	 PUfIC2o5Czw0JnG+NpUl1Z1TXhNlnMG7PSCa7gs8pEe4FMq+q9vXsjbsIIPlOWijus
	 vRDdGZk0RUnBK8yn7iLxkaKWHdaYWxEY0PWDcMIlpEXY+Rb8EjCxM9RhULA39pSkn8
	 0CI+t6GTRuoPA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckA-0068vz-9o;
	Wed, 23 Oct 2024 15:53:50 +0100
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
Subject: [PATCH v5 04/37] KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
Date: Wed, 23 Oct 2024 15:53:12 +0100
Message-Id: <20241023145345.1613824-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
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


