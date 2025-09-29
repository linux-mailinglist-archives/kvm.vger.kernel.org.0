Return-Path: <kvm+bounces-59002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D867CBA9F10
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B113E1922C26
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CC030DD17;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5H5NiDM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60C1FBC91;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161906; cv=none; b=ELWl5TFhXj3Dhdyqc1ny9pmFCPnSYxx/VLF23xwvMNbbxJVzqKQau74WMa+UvGSIHE+mlzVY/q78qSGjcVjaNgsYtu3uqC5Py5N2sFGBiPhtm29z8DBmvmWibLOBCWcjbd4w4PoM3Cnf/by3LZ7X8gnSN3fqTaA04/UyFgC9ZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161906; c=relaxed/simple;
	bh=+R9Ysx4E7t/BLtOfZcuyafnu20V9cRN3ygXcqoeEjbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2CTc3Bdr66+eMEdWyAlKshcDWOX/7DxgRyC2mVvpodefTXktbI920erOHVQiVSXVYoKczj3KIeuqwbDILNXnn6Db0OP+n5zJwYrUbe4LqrzM42i5hZmHCWTVYLLjRpUYHuNBwExfc8PDD8WleY8PuiLLojhjMsaQiNgYqz5piQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5H5NiDM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A49AC4CEF4;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161906;
	bh=+R9Ysx4E7t/BLtOfZcuyafnu20V9cRN3ygXcqoeEjbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5H5NiDMxRsM/YeLbg3+34C6jxa+OW4eEecx9g1UYqYak28SF7Sbxx/rzBW1HQDUa
	 Q1ezLZivy3pJLL3AnX2VVGOCU+QQ7ln2Zh1tx0k92BpYNPwBzSElxInJBF9WoEQAkY
	 NCtwFm1yDXcOVBDOwKAW31ypRb7E8qNDhRWhHsS5+VdAXO/sg/0H1erbCr5rrzw3jn
	 2D1kSiVEuKptsdtU7Yg21PuAvWriOci42/gAOeqnYCCv3jDnX0GZZVeEvCkpUDHm32
	 JQJJWL/9hf8VWUg5VD+2RBTSsWnu5KuHHzLyuxEJtcRnqpb4VtFinLPgtT4x8/S8ST
	 1muI3WkPbL41g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN6-0000000AHqo-1J5v;
	Mon, 29 Sep 2025 16:05:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 04/13] KVM: arm64: Make timer_set_offset() generally accessible
Date: Mon, 29 Sep 2025 17:04:48 +0100
Message-ID: <20250929160458.3351788-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Move the timer_set_offset() helper to arm_arch_timer.h, so that it
is next to timer_get_offset(), and accessible by the rest of KVM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 10 ----------
 include/kvm/arm_arch_timer.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c832c293676a3..27662a3a3043e 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -146,16 +146,6 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 	}
 }
 
-static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
-{
-	if (!ctxt->offset.vm_offset) {
-		WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
-		return;
-	}
-
-	WRITE_ONCE(*ctxt->offset.vm_offset, offset);
-}
-
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d8e400cb2bfff..5f7f2ed8817c5 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -179,4 +179,14 @@ static inline u64 timer_get_offset(struct arch_timer_context *ctxt)
 	return offset;
 }
 
+static inline void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
+{
+	if (!ctxt->offset.vm_offset) {
+		WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
+		return;
+	}
+
+	WRITE_ONCE(*ctxt->offset.vm_offset, offset);
+}
+
 #endif
-- 
2.47.3


