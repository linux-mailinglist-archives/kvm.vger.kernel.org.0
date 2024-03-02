Return-Path: <kvm+bounces-10730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D08C786F036
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 12:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EA161C21E5E
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 11:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F9817988;
	Sat,  2 Mar 2024 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSRFECNa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E517557;
	Sat,  2 Mar 2024 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709378399; cv=none; b=e/TtqAD2wrXX9eLeGPZm+L6i17y7NDHqg4yy/pq+AgTmLYv0boDOrpDNUr1AnPnJ0C6QOm+m4T/UxYWfkCURpRgB67BfR8zYlpwqnwR66B4eBj5TxZbpOuwOxrXlP9XEc7gUIBoXVEwI2RSI+sRwr2uYR03fgytt491bmEBZqKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709378399; c=relaxed/simple;
	bh=HS/j+OQhYdAZh6fG4YkqbtHPpdB6xcRRNkEe+IveeC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MhIopJgvID2kdx6ih5ozghbcwVkdPqhyir6cIY44urQbTJXtYqysVk6xbTf5sgdh6pl3y2GaaJNNK/5UMQOG8M+GsiL7GQq4bM3Kwqxu5UGd0Ld1eojxtpIvXrZocKktPH/Eq+B8TGV4CqtEqGCmZ0yLdgZaD4a33/3dziDNkw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSRFECNa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB7DC433A6;
	Sat,  2 Mar 2024 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709378398;
	bh=HS/j+OQhYdAZh6fG4YkqbtHPpdB6xcRRNkEe+IveeC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSRFECNaK6As5fvWwyYr7u/3BrMN+qSHneRYkWkXUHZfzV0Wv4xZ0SRxLua2/kqbg
	 tEETbKr6CxGY+wle3aMypN4WJ4zm4YL4HwpmjKKsk8ffdodcJZF7kfcucqppUHyj1a
	 GsGm9MB82V/aTKn+HSlaXDvVanMk5dk/yRkif3w5TH25gkJ78HG0MqnYM+XKjWFuzo
	 HaEfGp6VvnvOcRAScPHlZ+d/q3C6D0KQVIjCU49AsYL7An8AhJL9rB9QEagJuEeMmI
	 WZgo1budNv9NTapjehmkJoUvcmPclTIibVNQtHIj81OlDhZed7Ip5eq/xcPZZIWjz3
	 k+dsAjPO90fGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rgNPI-008lLw-Ha;
	Sat, 02 Mar 2024 11:19:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/5] KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
Date: Sat,  2 Mar 2024 11:19:33 +0000
Message-Id: <20240302111935.129994-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240302111935.129994-1-maz@kernel.org>
References: <20240302111935.129994-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As for the rest of the host debug state, the host copy of mdcr_el2
has little to do in the vcpu, and is better placed in the host_data
structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 5 ++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 90ea5524c545..a3718f441e12 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -517,6 +517,8 @@ struct kvm_host_data {
 		u64 pmscr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
+		/* Values of trap registers for the host before guest entry. */
+		u64 mdcr_el2;
 	} host_debug_state;
 };
 
@@ -576,9 +578,6 @@ struct kvm_vcpu_arch {
 	u64 mdcr_el2;
 	u64 cptr_el2;
 
-	/* Values of trap registers for the host before guest entry. */
-	u64 mdcr_el2_host;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9405a0c9b4c3..8ae81301083f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -225,7 +225,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
-	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
+	*host_data_ptr(host_debug_state.mdcr_el2) = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
@@ -247,7 +247,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
-	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
+	write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3()) {
-- 
2.39.2


