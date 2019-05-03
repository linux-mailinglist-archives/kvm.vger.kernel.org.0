Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8555312E4F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfECMr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:29 -0400
Received: from foss.arm.com ([217.140.101.70]:60998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbfECMr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFC11165C;
        Fri,  3 May 2019 05:47:27 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 771713F220;
        Fri,  3 May 2019 05:47:24 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 47/56] arm64: arm_pmu: Remove unnecessary isb instruction
Date:   Fri,  3 May 2019 13:44:18 +0100
Message-Id: <20190503124427.190206-48-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

The armv8pmu_enable_event_counter function issues an isb instruction
after enabling a pair of counters - this doesn't provide any value
and is inconsistent with the armv8pmu_disable_event_counter.

In any case armv8pmu_enable_event_counter is always called with the
PMU stopped. Starting the PMU with armv8pmu_start results in an isb
instruction being issued prior to writing to PMCR_EL0.

Let's remove the unnecessary isb instruction.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/perf_event.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 4addb38bc250..cccf4fc86d67 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -533,7 +533,6 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
 	armv8pmu_enable_counter(idx);
 	if (armv8pmu_event_is_chained(event))
 		armv8pmu_enable_counter(idx - 1);
-	isb();
 }
 
 static inline int armv8pmu_disable_counter(int idx)
-- 
2.20.1

