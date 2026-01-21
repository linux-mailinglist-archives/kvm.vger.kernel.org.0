Return-Path: <kvm+bounces-68766-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cF5KClwscWl1fAAAu9opvQ
	(envelope-from <kvm+bounces-68766-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:43:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B687C5C6A4
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC33586F520
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8233934FF4B;
	Wed, 21 Jan 2026 19:06:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F4B3B8BAA;
	Wed, 21 Jan 2026 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022400; cv=none; b=h+5obTGI9iAr5mxic516br+vo6spoB3qOxx1imPLhxBGDlt5RbBWZf8qPQQpd1HA4/0Zz4wg7iDP4s3IFqwq4tX2qJx/cKA9CIBJ2UUr17VLwBqdB2AdjgtXZWspgl4drdn5AIUGsEjtrlSVepDe+iIOBrLg6Jox64jVxRKt4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022400; c=relaxed/simple;
	bh=PpABYLd1h9D352dB0+L25AjVrL4EaNZuSw/EdKhaXEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PLuBBwF7IxcAnkGEa69oPO2dySUGnrEMZfBtS6f6Nw6o8Hso8TpFMefUnP02A6rysDPihOCQbXzPlZcumSXjefHWpiM2738NZmQGz/BvesQpETUcN4FyUL+qMLd6XAiPPbp2EmP+Dednbf4u3b+OmoNcW4fWupxwKdGjoaV0Cdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 486481517;
	Wed, 21 Jan 2026 11:06:31 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6BECC3F632;
	Wed, 21 Jan 2026 11:06:34 -0800 (PST)
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
Subject: [PATCH v12 3/7] KVM: arm64: expose FEAT_LSUI to guest
Date: Wed, 21 Jan 2026 19:06:18 +0000
Message-Id: <20260121190622.2218669-4-yeoreum.yun@arm.com>
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
	TAGGED_FROM(0.00)[bounces-68766-lists,kvm=lfdr.de];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,arm.com:email,arm.com:mid]
X-Rspamd-Queue-Id: B687C5C6A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

expose FEAT_LSUI to guest.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a1..fa34910b22ae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1805,7 +1805,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		break;
 	case SYS_ID_AA64ISAR3_EL1:
 		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_LSFE |
-			ID_AA64ISAR3_EL1_FAMINMAX;
+			ID_AA64ISAR3_EL1_FAMINMAX | ID_AA64ISAR3_EL1_LSUI;
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
@@ -3249,6 +3249,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64ISAR2_EL1_GPA3)),
 	ID_WRITABLE(ID_AA64ISAR3_EL1, (ID_AA64ISAR3_EL1_FPRCVT |
 				       ID_AA64ISAR3_EL1_LSFE |
+				       ID_AA64ISAR3_EL1_LSUI |
 				       ID_AA64ISAR3_EL1_FAMINMAX)),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


