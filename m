Return-Path: <kvm+bounces-72183-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCgjJbbOoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72183-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:04:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E55111BB2CA
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A214C31A513A
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3EF3542CF;
	Fri, 27 Feb 2026 16:59:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BB8356A2B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211591; cv=none; b=D/PMFJ6+6D/ZS1sY0+/DgFALVG0aMuyNp+49qZcHawQ4mGKbRMJpot8aydeo6xhWCoD2lZXMBCef5ZZrepFa44OIE3vNIkKxvxvJV0dXa8m4uBaxu6vMiOfcZpBCfe9bFoATpGsN/mTxMDMhnfkpxQM52O4NIFGWv98FW10KHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211591; c=relaxed/simple;
	bh=Jy09jgbBZ0NtLoWAppmx87IBHL6F4I7aPwJ9L2m2ZNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suxZVTWtdJyQZGjzDGXgqk50UxzM+XdPAyeGi+R03rRjg47exwmmSxBz0eVrMpYU4UnQXS81CJyrrjk1A3xlhqdtOATe39Rx4TJuUPt1bvNIZ0s5tkcqCgGPy/SHtpOhtEF5jJ8cxtIzRPJsN1BgiMZvMZXAc5otHI36e9RZehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B17314BF;
	Fri, 27 Feb 2026 08:59:42 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9420B3F73B;
	Fri, 27 Feb 2026 08:59:47 -0800 (PST)
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
Subject: [kvmtool PATCH v6 07/17] arm64: Stash kvm_vcpu_init for later use
Date: Fri, 27 Feb 2026 16:56:14 +0000
Message-ID: <20260227165624.1519865-8-suzuki.poulose@arm.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72183-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.976];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: E55111BB2CA
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

A subsequent change will add support for resetting a vCPU, which
requires reissuing the KVM_ARM_VCPU_INIT ioctl. Save the kvm_vcpu_init
worked out for later use.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 2 +-
 arm64/kvm-cpu.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 1af394aa..2f189abc 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -17,7 +17,7 @@ struct kvm_cpu {
 	pthread_t	thread;
 
 	unsigned long	cpu_id;
-	unsigned long	cpu_type;
+	struct kvm_vcpu_init	init;
 	const char	*cpu_compatible;
 
 	struct kvm	*kvm;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 94c08a4d..3d914112 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -194,7 +194,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.43.0


