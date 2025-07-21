Return-Path: <kvm+bounces-52966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F99FB0C12B
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E8DB16F678
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F8328F527;
	Mon, 21 Jul 2025 10:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATtVxx+Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DB928E5F3;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093208; cv=none; b=Zk3VvhOg35peqL8f5Kh8zX+aZt8qmtnfL8yVbztGsAz6DjRVlAk9usahYnD7HhWbolIe2X4bSNWeapx9+n7iFkf17LLOovxT7ys9/mEBVMGmTk+5ub4e5Aqv/IDwZCYlY2J6/+nzJBhp/z2/j9he0GUIRBk1fwji+TnprB41S1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093208; c=relaxed/simple;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AAO2vnzb2OEwpE+jDjjSfiaMxwCI0+VfV3isXpcKXc76hqcpBm3Zoi/8PZ9jqY19TZxP+q3hUwGYr2kUa0Q3lfS4N68YO3VP93LLO2JdrL9/gbyFKOnJSO2RlOh7V7hITAvJ9PqrDxqY+/l3Lu+mhvsuo7SsvI4OhVbKVcRez5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATtVxx+Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E203C4CEF4;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093208;
	bh=eANUx6yTarI1XjY5Wc/aBHqOLih6GMKUKHwFun94n8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATtVxx+QilGd5YPeJZNWCLGmEkqrFGbNjANZg5mXUmT586Kq+YAs81ewdQv5IIo7E
	 WXJPrus7nFJlEz4IGyI4GUedH6EMglFYEij+Z4rOdr2c7nnIFkoBDW2YwDV3anHqd2
	 clETiOjjA2krM5XOsW4E7YfyoWDzx4WKGSjO7c0WjICffaTGDFsknPhsIci2+zIpva
	 dXyHRh6cnPhl7PVokgMTQUb3ktqZSgX4FZHzYUu4xqqEuWIhOQ4ev2L2g/5XGUCue7
	 zhf5w5a7VATgSHzgEBQwtxO6Tr4BBZ4qkUgC1wJIDtE8XBzF8p3X+MQBBbO0QwX75T
	 NHhabJ3lOZhVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncs-00HZDF-Dc;
	Mon, 21 Jul 2025 11:20:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5/7] KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
Date: Mon, 21 Jul 2025 11:19:53 +0100
Message-Id: <20250721101955.535159-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
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


