Return-Path: <kvm+bounces-54126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B35B1CA26
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD47A18C45F3
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9833A29C33A;
	Wed,  6 Aug 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYnisNZR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD9929ACF1;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499390; cv=none; b=Q575qg1s8is+Rm5UEhL1/a0NrA/QQW8uA3GGm0diHqb5OjfVSTepUBH6wN4lgv3EbPjg2eZXB5ViXMB2FEEBpKhev9rQeC3sWABf6dnA1qACQoNa4KRiJUXUojeH2NVuuiA9+XMg3ApebXoob/2Qxb4G/tA6T6yeJgX2Y7C09ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499390; c=relaxed/simple;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wo74yk6qsL3MI0QA/nRgGUlYAWZRTZcsaKG9KYBxBcoLGL7vYBBXTsDtmcT7sgwd85q4lCaHIXS5ehG5/1VrrRImUFcaCj2jkUWEOGj8QTn04Gw8Q1TKuzQ6ZpyAg8r5v8A2GI7/dURiTymgADd09KFxVaNe44iAGkvQ0rhWYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYnisNZR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71176C4CEF1;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499390;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYnisNZRRK/wMN2mccykAAboqPGygUcsGkaFhGuIIb5ctY22+4UdkBsHg6A0gHMBj
	 aVV2eLK2FKSK4FS66AIo747V4FzAibPmDStsgdjtDsbUdKUUZwzTD+ENhsHIhnN7CH
	 Wdlheqe7IdcCByY48UVmcaa3y3CI1GJ0KMe5phO9kS+oYIPDFNhKw8J3Of9Djz5F6Q
	 jtlRveSPD4QTCcizu5WGh9ojIbiAX7GCCRbeBcGvPhyez3sy2tNaWL+J6QqjOTLj7S
	 TOgW0a+oQDgMixfiHGFkevc2DX8rK9QV0nYNwJ+Ie/Iet//h7LqRRG3E1myP8Q2st8
	 76TU28duIYOTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRE-004ZQV-Af;
	Wed, 06 Aug 2025 17:56:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 3/5] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
Date: Wed,  6 Aug 2025 17:56:13 +0100
Message-Id: <20250806165615.1513164-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806165615.1513164-1-maz@kernel.org>
References: <20250806165615.1513164-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

An EL2 guest can set HCR_EL2.FIEN, which gives access to the RASv1p1
fault injection mechanism. This would allow an EL1 guest to inject
error records into the system, which does sound like a terrible idea.

Prevent this situation by added FIEN to the list of bits we silently
exclude from being inserted into the host configuration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index e482181c66322..0998ad4a25524 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -43,8 +43,11 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
  *
  * - API/APK: they are already accounted for by vcpu_load(), and can
  *   only take effect across a load/put cycle (such as ERET)
+ *
+ * - FIEN: no way we let a guest have access to the RAS "Common Fault
+ *   Injection" thing, whatever that does
  */
-#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
+#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK | HCR_FIEN)
 
 static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 {
-- 
2.39.2


