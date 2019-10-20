Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB4DDDDFE
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 12:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJTKLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 06:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbfJTKLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 06:11:44 -0400
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk [62.31.163.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CEF222BD;
        Sun, 20 Oct 2019 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571566303;
        bh=Syg7JpTSjO3UDfWlqULqNwmrn1vfNkZUjqNdeFNbT8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1nAb5ChLYmSWCc2pr0VVskYWZu2pdancAXCgfmvHAw4nfVbhLMAr9pfMBkL/+JGx
         E16M4+CSRQxIwt5DQaAjg137rwxJ9kz1n3foB8ty/1U0BHwkDJ+qbvUHOzdDkPExBV
         q7bB3qIjiwhVHYEdJgaiz4Qr/I3Lo64SZZo/o6ak=
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
Date:   Sun, 20 Oct 2019 11:11:28 +0100
Message-Id: <20191020101129.2612-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020101129.2612-1-maz@kernel.org>
References: <20191020101129.2612-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current convention for KVM to request a chained event from the
host PMU is to set bit[0] in attr.config1 (PERF_ATTR_CFG1_KVM_PMU_CHAINED).

But as it turns out, this bit gets set *after* we create the kernel
event that backs our virtual counter, meaning that we never get
a 64bit counter.

Moving the setting to an earlier point solves the problem.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index c30c3a74fc7f..f291d4ac3519 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -569,12 +569,12 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 		 * high counter.
 		 */
 		attr.sample_period = (-counter) & GENMASK(63, 0);
+		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
+			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
+
 		event = perf_event_create_kernel_counter(&attr, -1, current,
 							 kvm_pmu_perf_overflow,
 							 pmc + 1);
-
-		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
-			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
 	} else {
 		/* The initial sample period (overflow count) of an event. */
 		if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
-- 
2.20.1

