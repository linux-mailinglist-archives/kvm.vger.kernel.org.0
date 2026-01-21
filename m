Return-Path: <kvm+bounces-68765-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LbaFKwlcWl8eQAAu9opvQ
	(envelope-from <kvm+bounces-68765-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:14:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E77AC5BEDA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E6A437EF880
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EACA3D3016;
	Wed, 21 Jan 2026 19:06:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05053C199E;
	Wed, 21 Jan 2026 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022397; cv=none; b=MfxH0KqlSIrZMefLOXkRr18O4thC9z6QujDUEpr737fdUMN058fy6Y3wTTJwGnO4dXM/IsCppCqA/5DOY+nzJlfuuxLKgQk1iNnyw3ANhe7QRzuFlKZnngi1/LVYDffL7rhTjwWc9EM/pYuIyghoe5o1hJh95LI07u5wU7vMO80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022397; c=relaxed/simple;
	bh=6TOl+ancS3QXn338RWCqLR4HIk4+OJ77QHGJPreqdi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/UtJR5xyPexswhCUoawIFbo7jKTVeNb52AQkxA0yBuCqloX1APVE02cMdqfbuzKFbzKE+y7MkePx6AZFHzcGqEc6DR5NbZQtLz4fi7gynVCgRYySykgPnkQWt8IQktGXzV4Jt44YhopowvdRhNbts4WPy42HAr2hm61Bd71yXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77C641516;
	Wed, 21 Jan 2026 11:06:27 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 055F13F632;
	Wed, 21 Jan 2026 11:06:30 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	scott@os.amperecomputing.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	mark.rutland@arm.com,
	arnd@arndb.de,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Date: Wed, 21 Jan 2026 19:06:17 +0000
Message-Id: <20260121190622.2218669-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260121190622.2218669-1-yeoreum.yun@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : No valid SPF, No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_FROM(0.00)[bounces-68765-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: E77AC5BEDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Since Armv9.6, FEAT_LSUI introduces load/store instructions that allow
privileged code to access user memory without clearing the PSTATE.PAN bit.

Add CPU feature detection for FEAT_LSUI and enable its use
when FEAT_PAN is present so that removes the need for SW_PAN handling
when using LSUI instructions.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 27 +++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 28 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..b41ea479c868 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -280,6 +280,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_FPRCVT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_LSUI_SHIFT, 4, ID_AA64ISAR3_EL1_LSUI_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_LSFE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_FAMINMAX_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -2509,6 +2510,23 @@ test_has_gicv5_legacy(const struct arm64_cpu_capabilities *entry, int scope)
 	return !!(read_sysreg_s(SYS_ICC_IDR0_EL1) & ICC_IDR0_EL1_GCIE_LEGACY);
 }
 
+#ifdef CONFIG_ARM64_LSUI
+static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	/*
+	 * A CPU that supports LSUI should also support FEAT_PAN,
+	 * so that SW_PAN handling is not required.
+	 */
+	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
+		return false;
+
+	return true;
+}
+#endif
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.capability = ARM64_ALWAYS_BOOT,
@@ -3148,6 +3166,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, XNX, IMP)
 	},
+#ifdef CONFIG_ARM64_LSUI
+	{
+		.desc = "Unprivileged Load Store Instructions (LSUI)",
+		.capability = ARM64_HAS_LSUI,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_lsui,
+		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
+	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 0fac75f01534..4b2f7f3f2b80 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -46,6 +46,7 @@ HAS_HCX
 HAS_LDAPR
 HAS_LPA2
 HAS_LSE_ATOMICS
+HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_BBML2_NOABORT
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


