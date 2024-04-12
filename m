Return-Path: <kvm+bounces-14513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA468A2C7E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A55911F23635
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D7A5820D;
	Fri, 12 Apr 2024 10:35:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28273D547
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918115; cv=none; b=ilBm1XB0mTe5Bxa7EuFHH9jtcFNEwaeI6d0vioPqqXn9aLiGXwqo0d56ID/5MSHv7rEY+mLUuaJ9nZcMGC/AnQSLhTnPjeu/hhCWDqTS7SCFFHXVuei7gUuN3txwdkEXN/SZYHPaHx4P45/qXdwF+038COzdiatfGNi8sLu1pM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918115; c=relaxed/simple;
	bh=5iZQrz7mWuKQPTDDJxIV9WSrZXQqNTLMrgKtQAr7dfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lYZ2noqstlo1NpPIllfT7zM6a9PSzK5Y7jzVWlNixayuhmaWyQdFdE+B2FMeXxRgyqJIWNLhJ6tvVfMPwYQ+TjUAXg2Nrt2VAUK7ph50YHalVYIWHY0wwbbyU8MxzbLXTnaJMcoNElUFHpoyNEFAS7mzs8Rqc2Q/PJWzNItBow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2DC4113E;
	Fri, 12 Apr 2024 03:35:42 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A82663F64C;
	Fri, 12 Apr 2024 03:35:11 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 27/33] arm: realm: add RSI interface for attestation measurements
Date: Fri, 12 Apr 2024 11:34:02 +0100
Message-Id: <20240412103408.2706058-28-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add wrappers for the Attestation and measurement related RSI calls.
These will be later used in the test cases

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm64/asm/rsi.h | 10 +++++++++
 lib/arm64/rsi.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index 0b726684..2566c000 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -29,6 +29,16 @@ int rsi_invoke(unsigned int function_id, unsigned long arg0,
 int __rsi_get_version(unsigned long ver, struct smccc_result *res);
 int rsi_get_version(unsigned long ver);
 
+int rsi_attest_token_init(unsigned long *challenge, unsigned long *max_size);
+int rsi_attest_token_continue(phys_addr_t addr,
+			      unsigned long offset,
+			      unsigned long size,
+			      unsigned long *len);
+void rsi_extend_measurement(unsigned int index, unsigned long size,
+			    unsigned long *measurement,
+			    struct smccc_result *res);
+void rsi_read_measurement(unsigned int index, struct smccc_result *res);
+
 static inline bool is_realm(void)
 {
 	return rsi_present;
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
index e58d9660..8fe672fc 100644
--- a/lib/arm64/rsi.c
+++ b/lib/arm64/rsi.c
@@ -134,3 +134,55 @@ void arm_set_memory_shared(unsigned long start, unsigned long size)
 {
 	arm_set_memory_state(start, size, RIPAS_EMPTY, RSI_CHANGE_DESTROYED);
 }
+
+int rsi_attest_token_init(unsigned long *challenge, unsigned long *max_size)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_ATTEST_TOKEN_INIT,
+		   challenge[0], challenge[1], challenge[2],
+		   challenge[3], challenge[4], challenge[5],
+		   challenge[6], challenge[7], 0, 0, 0, &res);
+
+	if (max_size)
+		*max_size = res.r1;
+	return res.r0;
+}
+
+int rsi_attest_token_continue(phys_addr_t addr,
+			      unsigned long offset,
+			      unsigned long size,
+			      unsigned long *len)
+{
+	struct smccc_result res = { 0 };
+
+	rsi_invoke(SMC_RSI_ATTEST_TOKEN_CONTINUE, addr, offset, size,
+		   0, 0, 0, 0, 0, 0, 0, 0, &res);
+	switch (res.r0) {
+	case RSI_SUCCESS:
+	case RSI_INCOMPLETE:
+		if (len)
+			*len = res.r1;
+		/* Fall through */
+	default:
+		break;
+	}
+	return res.r0;
+}
+
+void rsi_extend_measurement(unsigned int index, unsigned long size,
+			    unsigned long *measurement, struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_MEASUREMENT_EXTEND, index, size,
+		   measurement[0], measurement[1],
+		   measurement[2], measurement[3],
+		   measurement[4], measurement[5],
+		   measurement[6], measurement[7],
+		   0, res);
+}
+
+void rsi_read_measurement(unsigned int index, struct smccc_result *res)
+{
+	rsi_invoke(SMC_RSI_MEASUREMENT_READ, index, 0,
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, res);
+}
-- 
2.34.1


