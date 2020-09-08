Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83702260CC9
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgIHH7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbgIHH6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:58:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EB621D6C;
        Tue,  8 Sep 2020 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599551928;
        bh=4krfchsT8X0gKS7c3hX0W/WHBUA/yypESIUHYByJQVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsPcdtfAX48Jq0P7tQpHEJqqXjA39iEWqHkm1EOZadTHz3xM7CZciJrBBEmLgNpsS
         yJkMVPcZYb9llmSKqwi3UOq6K5oevjY7kL2Q45SxLA4XFKqMMPDqEywioopkzYowrc
         XQKmFXS1d51aRjDy42o2NOarWIXFEB8Z1lh/bXmY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFYWd-009zhy-9J; Tue, 08 Sep 2020 08:58:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>, graf@amazon.com,
        kernel-team@android.com
Subject: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1
Date:   Tue,  8 Sep 2020 08:58:29 +0100
Message-Id: <20200908075830.1161921-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075830.1161921-1-maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we can now hide events from the guest, let's also adjust its view of
PCMEID{0,1}_EL1 so that it can figure out why some common events are not
counting as they should.

The astute user can still look into the TRM for their CPU and find out
they've been cheated, though. Nobody's perfect.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c |  5 +----
 include/kvm/arm_pmu.h     |  5 +++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 67a731bafbc9..0458860bade2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -765,6 +765,35 @@ static int kvm_pmu_probe_pmuver(void)
 	return pmuver;
 }
 
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
+	u64 val, mask = 0;
+	int base, i;
+
+	if (!pmceid1) {
+		val = read_sysreg(pmceid0_el0);
+		base = 0;
+	} else {
+		val = read_sysreg(pmceid1_el0);
+		base = 32;
+	}
+
+	if (!bmap)
+		return val;
+
+	for (i = 0; i < 32; i += 8) {
+		u64 byte;
+
+		byte = bitmap_get_value8(bmap, base + i);
+		mask |= byte << i;
+		byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+		mask |= byte << (32 + i);
+	}
+
+	return val & mask;
+}
+
 bool kvm_arm_support_pmu_v3(void)
 {
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 077293b5115f..20ab2a7d37ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -769,10 +769,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	if (!(p->Op2 & 1))
-		pmceid = read_sysreg(pmceid0_el0);
-	else
-		pmceid = read_sysreg(pmceid1_el0);
+	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
 
 	p->regval = pmceid;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6db030439e29..98cbfe885a53 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -34,6 +34,7 @@ struct kvm_pmu {
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
@@ -108,6 +109,10 @@ static inline int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	return 0;
+}
 #endif
 
 #endif
-- 
2.28.0

