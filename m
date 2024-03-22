Return-Path: <kvm+bounces-12512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F988871B8
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 773FE282ED7
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B616026C;
	Fri, 22 Mar 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dnzT4Lpe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51BE5FBBA;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127409; cv=none; b=GLJ/L6Krb2d4Y4PW/qYP79XHbYhT3sM1+3kwbBfOzxOi4BEemRiOyuO92qf18lRCgm+ogZjHeC/jvQhE/FpcslUIM9cMl1e/W/Gu959laEQLkuI4QWyxbey+bK0WhFH4O9EtTq1PgU6MZGXsEJ2QHRjcs2PE228LoASOS3r1CwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127409; c=relaxed/simple;
	bh=f7zVa7Vb35emtaj3yee+ueV8CX7+6/2j7VjOZT6XV3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BNx7Q1MBom81bBCzvpGs7aC0rk7zkkGnXx1OcR76nN8vwhgaXTeBJQUK1t5xV7T9hJbnt4LHkrmzbPYAajvJZGnWZNSy5a+OsM0OTY/TLH3ScukX1GqHnaKxkJwZJ01q4wuYFfii4mtgx1UfF8FSt1uVL8+GZBRHKBpvMWWeg14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dnzT4Lpe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582E8C433A6;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127409;
	bh=f7zVa7Vb35emtaj3yee+ueV8CX7+6/2j7VjOZT6XV3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnzT4Lpe1JiyN2deKxmgb2UZ9xsGpuoomAUFdtyIk7yGTXCFt7Zp/h987rdRV/knn
	 4YefQy/Xm2XWppM636tP1mrYP7aC7SjhRv5FgP2p96CFhSqXsAYKydOflhehQI9U7H
	 0Z3Q8moUxuBE3ia5qu1TiJC/TI27DJhbRoPmN6vPAI+7miAc7dZ/R+/o8RdPa/Wxic
	 oJ2rVXnsODWtHK0AO+aMl38p0f5KLU6CQ1+MXqBjv+uO/oxjUWxEyr8OhUHM+9EZ7J
	 aJeyZVu3ckIMQvJb2f6hRxV69nmpzv7vtqUxEWAwx2NfzaT8RHHITONK76/8hBSFRi
	 9lCLzC4F+0qAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniP9-00EZPz-Ip;
	Fri, 22 Mar 2024 17:10:07 +0000
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
	Mark Brown <broonie@kernel.org>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH v2 3/5] KVM: arm64: Exclude mdcr_el2_host from kvm_vcpu_arch
Date: Fri, 22 Mar 2024 17:09:43 +0000
Message-Id: <20240322170945.3292593-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240322170945.3292593-1-maz@kernel.org>
References: <20240322170945.3292593-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org, dongli.zhang@oracle.com
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
index 8c149e4ae99d..590e8767b720 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -555,6 +555,8 @@ struct kvm_host_data {
 		u64 pmscr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
+		/* Values of trap registers for the host before guest entry. */
+		u64 mdcr_el2;
 	} host_debug_state;
 };
 
@@ -615,9 +617,6 @@ struct kvm_vcpu_arch {
 	u64 mdcr_el2;
 	u64 cptr_el2;
 
-	/* Values of trap registers for the host before guest entry. */
-	u64 mdcr_el2_host;
-
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index ae198b84ca01..7d7de0245ed0 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -232,7 +232,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
-	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
+	*host_data_ptr(host_debug_state.mdcr_el2) = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
@@ -254,7 +254,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
-	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
+	write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3()) {
-- 
2.39.2


