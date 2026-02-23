Return-Path: <kvm+bounces-71517-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHC6I4CTnGnRJQQAu9opvQ
	(envelope-from <kvm+bounces-71517-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:50:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFEC17B15B
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C7877309EE26
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD60733A9DB;
	Mon, 23 Feb 2026 17:48:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF9433A70B;
	Mon, 23 Feb 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771868907; cv=none; b=DmLnQmPOLl0guax6LVUeChWf3hu5gG1zq6xaN/xz9xeuRwtRSAmMddyyaNvmabXowzNZt6KBicND6Acb0Rc27/PbPvEqfWThey+3iH752BVewwWeYIiBjatV3qcOBwmwSxb3vjxLrGPtUeGHYT1UdW+xd9aj5FQN69OToaAfcx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771868907; c=relaxed/simple;
	bh=gC1ASY4XTWOU9NSvQyEf85WEp3yTpQCXJkzGjWaR5EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q5xtS0xQlcCjVbqD8I9jstfNBA44kbjYCsg/M7IKnMV1TkXrC7KGQ1fjplywBnnyXXWESC7A40frkqPTjHxk2350vOn+8m1xo868goXEA7Cs1qXMA1OWhxyjDl5VK+HemaGzGutQTfU1Q/kksPJGn/77HGEsl6bBZ5GEEzswXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC9E61570;
	Mon, 23 Feb 2026 09:48:18 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 798663F59E;
	Mon, 23 Feb 2026 09:48:22 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	yangyicong@hisilicon.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v13 6/8] arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
Date: Mon, 23 Feb 2026 17:48:00 +0000
Message-Id: <20260223174802.458411-7-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223174802.458411-1-yeoreum.yun@arm.com>
References: <20260223174802.458411-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71517-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.974];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 0DFEC17B15B
X-Rspamd-Action: no action

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


