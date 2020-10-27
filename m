Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7517629C0D7
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818317AbgJ0RS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:18:58 -0400
Received: from foss.arm.com ([217.140.110.172]:47648 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818301AbgJ0RSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:18:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A49B139F;
        Tue, 27 Oct 2020 10:18:54 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D640B3F719;
        Tue, 27 Oct 2020 10:18:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com,
        Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC PATCH v2 1/5] arm64: Move get_id_aa64dfr0() in processor.h
Date:   Tue, 27 Oct 2020 17:19:40 +0000
Message-Id: <20201027171944.13933-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

SPE support is reported in the ID_AA64DFR0_EL1 register. Move the function
get_id_aa64dfr0() from the pmu test to processor.h so it can be reused by
the SPE tests.

[ Alexandru E: Reworded commit ]

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h | 5 +++++
 arm/pmu.c                 | 1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b84cc7e..11b756475494 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -88,6 +88,11 @@ static inline uint64_t get_mpidr(void)
 	return read_sysreg(mpidr_el1);
 }
 
+static inline uint64_t get_id_aa64dfr0(void)
+{
+	return read_sysreg(id_aa64dfr0_el1);
+}
+
 #define MPIDR_HWID_BITMASK 0xff00ffffff
 extern int mpidr_to_cpu(uint64_t mpidr);
 
diff --git a/arm/pmu.c b/arm/pmu.c
index 831fb6618279..5406ca3b31ed 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -167,7 +167,6 @@ static void test_overflow_interrupt(void) {}
 #define ID_DFR0_PMU_V3_8_5	0b0110
 #define ID_DFR0_PMU_IMPDEF	0b1111
 
-static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
 static inline uint64_t get_pmccntr(void) { return read_sysreg(pmccntr_el0); }
-- 
2.29.1

