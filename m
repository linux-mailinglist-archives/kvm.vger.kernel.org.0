Return-Path: <kvm+bounces-70839-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOIsNXGAjGl9pwAAu9opvQ
	(envelope-from <kvm+bounces-70839-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D01C124AB3
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33129301D050
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC2034EF06;
	Wed, 11 Feb 2026 13:13:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6DD35EDCD
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815580; cv=none; b=bE8uSYiaYhbaML9aHM9DWFlRDBmAIkTZF9vY568WmM4UI2kSYzMD/6bUJbLBxugnP1X+IPG999qPZFjJrSXStN1sICJD0vUtSGE5Tb6ZwTmyquOq1G7dfymkgF/x4uS2UgQUWT+GsKuKwqyXX9zaJ6ivIz7nE4J/PkTdIYEteog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815580; c=relaxed/simple;
	bh=2ED7cAmH83SMkTI/78kvAC52c4xP/9XilTmeOSiXBi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8FY6beqUGDdBgCkNMVbRCTQr1i/PEMJnmXu3gxKoTAY2TePQjtua3qI5pQq1jCUx97PWX86VRvxIKFBvjD8zJ7pOqAN6qlkYj+KRPBAB1Eyin+FqzjXIH0OvRw9yIwJpwMbgaWJpO6Boe1eNk86yG8lBPNyNqMzGPzSSinCoJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D09E1497;
	Wed, 11 Feb 2026 05:12:51 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D0BE3F63F;
	Wed, 11 Feb 2026 05:12:56 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 1/6] arm64: Initial nested virt support
Date: Wed, 11 Feb 2026 13:12:44 +0000
Message-ID: <20260211131249.399019-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211131249.399019-1-andre.przywara@arm.com>
References: <20260211131249.399019-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70839-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 3D01C124AB3
X-Rspamd-Action: no action

The ARMv8.3 architecture update includes support for nested
virtualization. Allow the user to specify "--nested" to start a guest in
(virtual) EL2 instead of EL1.
This will also change the PSCI conduit from HVC to SMC in the device
tree.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c                         |  5 ++++-
 arm64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm64/kvm-cpu.c                     | 12 +++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index df77758..98f1dd9 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -205,7 +205,10 @@ static int setup_fdt(struct kvm *kvm)
 		_FDT(fdt_property_string(fdt, "compatible", "arm,psci"));
 		fns = &psci_0_1_fns;
 	}
-	_FDT(fdt_property_string(fdt, "method", "hvc"));
+	if (kvm->cfg.arch.nested_virt)
+		_FDT(fdt_property_string(fdt, "method", "smc"));
+	else
+		_FDT(fdt_property_string(fdt, "method", "hvc"));
 	_FDT(fdt_property_cell(fdt, "cpu_suspend", fns->cpu_suspend));
 	_FDT(fdt_property_cell(fdt, "cpu_off", fns->cpu_off));
 	_FDT(fdt_property_cell(fdt, "cpu_on", fns->cpu_on));
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index ee031f0..a1dac28 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -10,6 +10,7 @@ struct kvm_config_arch {
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	bool		mte_disabled;
+	bool		nested_virt;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
@@ -57,6 +58,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
+		    "Start VCPUs in EL2 (for nested virt)"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 94c08a4..42dc11d 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -71,6 +71,12 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
 	/* Enable SVE if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
+
+	if (kvm->cfg.arch.nested_virt) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
+			die("EL2 (nested virt) is not supported");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
+	}
 }
 
 static int vcpu_configure_sve(struct kvm_cpu *vcpu)
@@ -313,7 +319,11 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 	reg.addr = (u64)&data;
 
 	/* pstate = all interrupts masked */
-	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL1h;
+	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	if (vcpu->kvm->cfg.arch.nested_virt)
+		data |= PSR_MODE_EL2h;
+	else
+		data |= PSR_MODE_EL1h;
 	reg.id	= ARM64_CORE_REG(regs.pstate);
 	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
 		die_perror("KVM_SET_ONE_REG failed (spsr[EL1])");
-- 
2.47.3


