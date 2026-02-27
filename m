Return-Path: <kvm+bounces-72161-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sGvtGVW3oWm+vwQAu9opvQ
	(envelope-from <kvm+bounces-72161-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:25:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 431EA1B9BA3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47FD231CA34E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5923543E485;
	Fri, 27 Feb 2026 15:17:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D312443D502;
	Fri, 27 Feb 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205467; cv=none; b=TQNfkUiKuE0fNe/pQQQHoVsmqaU+bIycRysgT2sDdSUJK+KBDHG/DgzNTj3AZYF1QpH1BEbrttPwyBGqt4hH/vUEUqerBeBIdu0qzUhR+tydwwoeLKA6q2L61iNNDnBeWtoTS+g7Y+3/8RCBVZIvv88TNSkkom36HWf7gX9VxwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205467; c=relaxed/simple;
	bh=vu1YTnurQsdl41tWBjnRNhm7kHGYenI4f+h1W0AsaGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jdl9XqgCDapc344EmpQDIldhBm29e/OsJS0z6Plwy07xN+bHRwKBeCYZxi3c1rDYJOoCMunGK8m2ubtJkO+JMyzcsRcD1ndEyw0yxpBOsiLdo7l6RKIUu0lV+HndQPVYEHhNUzTglTiN5RDC+3gqn7xG7HDj8Q3gCQyZERlWOiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C003339;
	Fri, 27 Feb 2026 07:17:39 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 818763F905;
	Fri, 27 Feb 2026 07:17:42 -0800 (PST)
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
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v15 3/8] KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
Date: Fri, 27 Feb 2026 15:17:00 +0000
Message-Id: <20260227151705.1275328-4-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227151705.1275328-1-yeoreum.yun@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72161-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.966];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 431EA1B9BA3
X-Rspamd-Action: no action

Add test coverage for FEAT_LSUI.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 73de5be58bab..fa3478a6c914 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -124,6 +124,7 @@ static const struct reg_ftr_bits ftr_id_aa64isar2_el1[] = {
 
 static const struct reg_ftr_bits ftr_id_aa64isar3_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FPRCVT, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, LSUI, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, LSFE, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FAMINMAX, 0),
 	REG_FTR_END,
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


