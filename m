Return-Path: <kvm+bounces-72192-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNLGCabNoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72192-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:00:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B745F1BB20D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 998F23059AE7
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4114C35A3AC;
	Fri, 27 Feb 2026 17:00:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0EBB2010EE
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211604; cv=none; b=T2RsSEJ2keK0thr5NMulBKFxo74/rbTd/KTHtg+gZTOzCngFP6s4qU+5PftE+9N7fAQIHkL3tWKJaQBJS7msdl/y0XvPsMInHkounl9pBYrrAcgCBCeqJ6t4A1yAJUDtzuOWEXbkQ0DnZPwiSrSxDYNDKNEyOYTgDuL4xfK6P1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211604; c=relaxed/simple;
	bh=hpDfcXJ0ERxD9QdxSdOFTgn2JgPNfhZudvBW4grrPzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDLIR/SPZvJsZUD4LcsGmYIfS3Vtz2AZtMttOP368v2k+/t9tWfjOhUnzB/UIwac6RI8mL7aPuxQdXdkL0C58+3LLKSF8lqqF67OGeS3S5nwofEsj4Yr2ykQ89BbbbYkrOvYnuSqbhyn0AyzCwxrSO7qL1uiEdEZKb0yQOI/xWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 117DC14BF;
	Fri, 27 Feb 2026 08:59:57 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 01A4D3F73B;
	Fri, 27 Feb 2026 09:00:01 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 16/17] arm64: psci: Implement SYSTEM_{OFF,RESET}
Date: Fri, 27 Feb 2026 16:56:23 +0000
Message-ID: <20260227165624.1519865-17-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72192-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.963];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:mid,arm.com:email,linux.dev:email]
X-Rspamd-Queue-Id: B745F1BB20D
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

Add support for the PSCI SYSTEM_{OFF,RESET} calls. Match the behavior of
the SYSTEM_EVENT based implementation and just terminate the VM.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 3deb672e..874ad141 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -33,6 +33,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -195,6 +197,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		/* Trusted OS not present */
 		res->a0 = PSCI_0_2_TOS_MP;
 		break;
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+		kvm__reboot(vcpu->kvm);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0


