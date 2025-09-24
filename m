Return-Path: <kvm+bounces-58642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A87F6B9A18E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B74061B2636F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2C53054CC;
	Wed, 24 Sep 2025 13:45:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BEF3054E5
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721528; cv=none; b=GDw73mb9aORx9SXeJuI63pPgqba4is/xa1CA9krCQ/LfZwzK1LnOrLn/wkLkA8yO43ilBT0Wrm05/01M61e8+StKhrHmCaSDglrgGuPnnYZp5FDHYyegTS89i0MhKb28CrSvGGmA1ncA7DQx34VmPEOctSO9hsCEFek1oApgGOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721528; c=relaxed/simple;
	bh=fwj77Slc/UheEdnhG71mLczgg896YD4CvQPGDebUc1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Foswi/5mu9lB8oNV6+0MPizsF7/ux+4YzBbopD7f8RMblBBs4n1fpn0U/e3ib2QR9jcDW10sbGu5yDFETN7KAQGQEekDggPL2hOqykMNRGq0gTjA3Bv3OGKqlY7r3qKVfjmq+iTKEN4GmfNyijq1JNTC1RO1mmlkyN6XdPC3etI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0C55106F;
	Wed, 24 Sep 2025 06:45:17 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24B0B3F5A1;
	Wed, 24 Sep 2025 06:45:25 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 4/7] arm64: Add counter offset control
Date: Wed, 24 Sep 2025 14:45:08 +0100
Message-Id: <20250924134511.4109935-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

KVM allows the offsetting of the global counter in order to help with
migration of a VM. This offset applies cumulatively with the offsets
provided by the architecture.

Although kvmtool doesn't provide a way to migrate a VM, controlling
this offset is useful to test the timer subsystem.

Add the command line option --counter-offset to allow setting this value
when creating a VM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-config-arch.h |  3 +++
 arm64/kvm.c                         | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index a1dac28e6..44c43367b 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -14,6 +14,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	u64		counter_offset;
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
 };
@@ -59,6 +60,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
 		"Address where firmware should be loaded"),			\
+	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
+		"Specify the counter offset, defaulting to 0"),			\
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
 		    "Start VCPUs in EL2 (for nested virt)"),
 
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 23b4dab1f..6e971dd78 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -119,6 +119,22 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
 	pr_debug("MTE capability enabled");
 }
 
+static void kvm__arch_set_counter_offset(struct kvm *kvm)
+{
+	struct kvm_arm_counter_offset offset = {
+		.counter_offset = kvm->cfg.arch.counter_offset,
+	};
+
+	if (!kvm->cfg.arch.counter_offset)
+		return;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_COUNTER_OFFSET))
+		die("No support for global counter offset");
+
+	if (ioctl(kvm->vm_fd, KVM_ARM_SET_COUNTER_OFFSET, &offset))
+		die_perror("KVM_ARM_SET_COUNTER_OFFSET");
+}
+
 void kvm__arch_init(struct kvm *kvm)
 {
 	/* Create the virtual GIC. */
@@ -126,6 +142,7 @@ void kvm__arch_init(struct kvm *kvm)
 		die("Failed to create virtual GIC");
 
 	kvm__arch_enable_mte(kvm);
+	kvm__arch_set_counter_offset(kvm);
 }
 
 static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
-- 
2.25.1


