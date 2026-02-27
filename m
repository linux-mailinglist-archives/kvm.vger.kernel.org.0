Return-Path: <kvm+bounces-72193-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBYzEhzPoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72193-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CB01BB322
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC84931C7DC8
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E16361644;
	Fri, 27 Feb 2026 17:00:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F2D3612D5
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211606; cv=none; b=cMLWWWaUrftkcyBzarFZr0jMBGVYxNPNW0jqEttS3+EgdJcqkHjVNFbjCIjri3wT04bODe8tfUGfGO03pl04QSA5bOPfkaghlYH0fLHBGKfKaBGicMu34UPNfnTqii2ipEzWQylE1b+6Z3mJ4KlewatfqIRjzYxef5jLEOyL9eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211606; c=relaxed/simple;
	bh=1qd9jKKkciPMBnCtIYoZky5yLvK/08oE+llkGM6J0zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED2Vml5sxO8NEuUcjcaA/tnD1tYAGGEUFfYsnbrDk9vgZJOYXLPmhIeRo3u+oFbKgya3F7XkSOlEkI1otx/7j0ch7wNpyP8dIBEbfww1lNnj4s4j5NnBlG1QN6cm6sxbDTTpXbX8VkTQ9qY0Z8OBVtHdqs1Q10E5b/ll0ons+FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A50FD1516;
	Fri, 27 Feb 2026 08:59:58 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9AB653F73B;
	Fri, 27 Feb 2026 09:00:03 -0800 (PST)
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
Subject: [kvmtool PATCH v6 17/17] arm64: smccc: Start sending PSCI to userspace
Date: Fri, 27 Feb 2026 16:56:24 +0000
Message-ID: <20260227165624.1519865-18-suzuki.poulose@arm.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72193-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.967];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email,linux.dev:email]
X-Rspamd-Queue-Id: B4CB01BB322
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

kvmtool now has a PSCI implementation that complies with v1.0 of the
specification. Use the SMCCC filter to start sending these calls out to
userspace for further handling. While at it, shut the door on the
legacy, KVM-specific v0.1 functions.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v4:
 - Switch to default in-kernel PSCI
---
 arm64/include/kvm/kvm-config-arch.h |  8 +++++--
 arm64/smccc.c                       | 37 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index ee031f01..f8dd088d 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -15,6 +15,7 @@ struct kvm_config_arch {
 	u64		fw_addr;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
+	bool		psci;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -52,11 +53,14 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
-        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
+	OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "psci", &(cfg)->psci,					\
+			"Request userspace handling of PSCI, instead of"	\
+			" relying on the in-kernel implementation"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/smccc.c b/arm64/smccc.c
index ef986d8c..47310a04 100644
--- a/arm64/smccc.c
+++ b/arm64/smccc.c
@@ -38,7 +38,44 @@ out:
 	return true;
 }
 
+static struct kvm_smccc_filter filter_ranges[] = {
+	{
+		.base		= KVM_PSCI_FN_BASE,
+		.nr_functions	= 4,
+		.action		= KVM_SMCCC_FILTER_DENY,
+	},
+	{
+		.base		= PSCI_0_2_FN_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+	{
+		.base		= PSCI_0_2_FN64_BASE,
+		.nr_functions	= 0x20,
+		.action		= KVM_SMCCC_FILTER_FWD_TO_USER,
+	},
+};
+
 void kvm__setup_smccc(struct kvm *kvm)
 {
+	struct kvm_device_attr attr = {
+		.group	= KVM_ARM_VM_SMCCC_CTRL,
+		.attr	= KVM_ARM_VM_SMCCC_FILTER,
+	};
+	unsigned int i;
 
+	if (!kvm->cfg.arch.psci)
+		return;
+
+	if (ioctl(kvm->vm_fd, KVM_HAS_DEVICE_ATTR, &attr)) {
+		pr_debug("KVM SMCCC filter not supported");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(filter_ranges); i++) {
+		attr.addr = (u64)&filter_ranges[i];
+
+		if (ioctl(kvm->vm_fd, KVM_SET_DEVICE_ATTR, &attr))
+			die_perror("KVM_SET_DEVICE_ATTR failed");
+	}
 }
-- 
2.43.0


