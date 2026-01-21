Return-Path: <kvm+bounces-68770-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKcjGVc2cWnKfQAAu9opvQ
	(envelope-from <kvm+bounces-68770-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:25:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE655D2B1
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D91CFB4F938
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C403E9F97;
	Wed, 21 Jan 2026 19:06:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CE23E8C7F;
	Wed, 21 Jan 2026 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022413; cv=none; b=XdQ8/xvJVnhscUKMXwXVb98FTSFHsxOwUtvy2NYdI/eXPOALswGRCJ8Qs1ZXEvhnTeRfaVIZHBPp7HVU71VKEoIZbhe7i1rPwW279xgTru3tW7IfYCDYjsGWnJiWX6VJtcTk1/35Lh2PwWbUWJfWWdgdxS34MfuJCA+7v0ntn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022413; c=relaxed/simple;
	bh=gC1ASY4XTWOU9NSvQyEf85WEp3yTpQCXJkzGjWaR5EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dmz8wN0lz2izaHsVwhCGojSpqGYmolahVGs6c5lo2P8cswrLVCoviQEiWfGxw7J5RFUfzlcHUkCkWpm9A64IJ/95Vebnhf68iA2VTGlAqQE6qYWIfpj43ilCmwplEzEizNAMjZB5i32cL1WGf5dutZ/GfhkYOjzkLhm7QIu8ToI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 073731684;
	Wed, 21 Jan 2026 11:06:45 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6B6533F632;
	Wed, 21 Jan 2026 11:06:48 -0800 (PST)
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
Subject: [PATCH v12 7/7] arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
Date: Wed, 21 Jan 2026 19:06:22 +0000
Message-Id: <20260121190622.2218669-8-yeoreum.yun@arm.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68770-lists,kvm=lfdr.de];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: ECE655D2B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The purpose of supporting LSUI is to eliminate PAN toggling.
CPUs that support LSUI are unlikely to support a 32-bit runtime.
Since environments that support both LSUI and
a 32-bit runtimeare expected to be extremely rare,
not to emulate the SWP instruction using LSUI instructions
in order to remove PAN toggling, and instead simply disable SWP emulation.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kernel/armv8_deprecated.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index e737c6295ec7..049754f7da36 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -610,6 +610,22 @@ static int __init armv8_deprecated_init(void)
 	}
 
 #endif
+
+#ifdef CONFIG_SWP_EMULATION
+	/*
+	 * The purpose of supporting LSUI is to eliminate PAN toggling.
+	 * CPUs that support LSUI are unlikely to support a 32-bit runtime.
+	 * Since environments that support both LSUI and a 32-bit runtime
+	 * are expected to be extremely rare, we choose not to emulate
+	 * the SWP instruction using LSUI instructions in order to remove PAN toggling,
+	 * and instead simply disable SWP emulation.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_LSUI)) {
+		insn_swp.status = INSN_UNAVAILABLE;
+		pr_info("swp/swpb instruction emulation is not supported on this system\n");
+	}
+#endif
+
 	for (int i = 0; i < ARRAY_SIZE(insn_emulations); i++) {
 		struct insn_emulation *ie = insn_emulations[i];
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


