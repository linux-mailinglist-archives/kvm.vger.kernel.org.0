Return-Path: <kvm+bounces-54857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3911B294F5
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B39784E124D
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5AC02BEFE6;
	Sun, 17 Aug 2025 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppa3LlJY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F76323F42A;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462126; cv=none; b=OJlrS4NoGzWrdF6gdGXjW7dkmXcbIzOTL7upd8y7IqIiYidyRmNgxMb+//PPudzWV6JwpIjj+mkbmDE6Gg+ebLFjV8zqKOlHhrPFHSg68MYQCWYroXertNiTy/UdaSaV8ANJNxJbZ3o4+IqR0G870MdNHl8RvXabhZQEK68PLeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462126; c=relaxed/simple;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nryjVQM24M2MJyfJ6tuGZ8fyF55o0wv0+Z3541ih2NumOQER0O/MXmbHCYY4qke+JLXoy9QDNmNM996NvEvUsCV5xIO1UF9JJWNAQr0+vHDjJU4hOoMtUwTSDuNUqZLvqvLq5/R1aNd+HAr0u+Hlp2Z+xTxHGabGTmydFgCmEp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppa3LlJY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5064C16AAE;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462125;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppa3LlJYYgfSUE4g1fr7+b+tcGNtLQaSFlPVWC/hL87P8G65Zci7b5sY2DHnAhHyT
	 FNC7gnf6hgjfwsyaneyb46XO37inhwMu7sR6UJVYc7mX8QzZ09tqoc9WoYaY3DuPC3
	 5p/Cje1+mvxJ1ZrIOBlB0TANmyqhTDm1P75fPxdZ5as06MQfPK4KZxwHyG1AJHVp/G
	 /oXUZoJ+2CgdSOVFY1siRkxWk0XMxzguiYOB4AplsGCdtEAp3TYUpm3MXFSOqqLh4z
	 NURLw+hMiR8VhjaSyt7X802DhNj7qLJnbiSy0Fe9ZkKYNdK6kq4ZdD1bxcO5ySK0Up
	 rwqOXHUtr5Z7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtD-008PX0-Gx;
	Sun, 17 Aug 2025 21:22:03 +0100
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
Subject: [PATCH v3 3/6] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
Date: Sun, 17 Aug 2025 21:21:55 +0100
Message-Id: <20250817202158.395078-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
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


