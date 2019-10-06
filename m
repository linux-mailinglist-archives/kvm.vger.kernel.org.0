Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF7ECD166
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 12:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfJFKrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 06:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfJFKrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Oct 2019 06:47:10 -0400
Received: from localhost.localdomain (82-132-217-85.dab.02.net [82.132.217.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3C32084D;
        Sun,  6 Oct 2019 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570358829;
        bh=Kbjk8U9KY83YtrC+Vj1iMZXkRW6yshTSizjEOBVjj3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mez2mYzED96KqrhBz67wivD2jw1wIwdikf3GrsDkzHasjg5QTgXSnijiFwjnfUbJy
         q13TxPAqD2mC4KN2lk89SDpLrAzbDj7P7FgMLg58iOXMyDyMTEIVHiS5U0hEnPsyow
         r6xpj6r4VNBE1Bvan82NC5l+sIsAwQ9Ok7USMXS0=
From:   maz@kernel.org
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 3/3] KVM: arm64: pmu: Reset sample period on overflow handling
Date:   Sun,  6 Oct 2019 11:46:36 +0100
Message-Id: <20191006104636.11194-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191006104636.11194-1-maz@kernel.org>
References: <20191006104636.11194-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

The PMU emulation code uses the perf event sample period to trigger
the overflow detection. This works fine  for the *first* overflow
handling, but results in a huge number of interrupts on the host,
unrelated to the number of interrupts handled in the guest (a x20
factor is pretty common for the cycle counter). On a slow system
(such as a SW model), this can result in the guest only making
forward progress at a glacial pace.

It turns out that the clue is in the name. The sample period is
exactly that: a period. And once the an overflow has occured,
the following period should be the full width of the associated
counter, instead of whatever the guest had initially programed.

Reset the sample period to the architected value in the overflow
handler, which now results in a number of host interrupts that is
much closer to the number of interrupts in the guest.

Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index c30c3a74fc7f..3ca4761fc0f5 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -444,6 +444,18 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	int idx = pmc->idx;
+	u64 val, period;
+
+	/* Start by resetting the sample period to the architectural limit */
+	val = kvm_pmu_get_pair_counter_value(vcpu, pmc);
+
+	if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+		period = (-val) & GENMASK(63, 0);
+	else
+		period = (-val) & GENMASK(31, 0);
+
+	pmc->perf_event->attr.sample_period = period;
+	pmc->perf_event->hw.sample_period = period;
 
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
-- 
2.20.1

