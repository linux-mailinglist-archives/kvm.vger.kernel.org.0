Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E23714F0AB
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgAaQiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:14 -0500
Received: from foss.arm.com ([217.140.110.172]:37346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgAaQiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17A72FEC;
        Fri, 31 Jan 2020 08:38:13 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1745F3F68E;
        Fri, 31 Jan 2020 08:38:11 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 04/10] arm64: timer: Add ISB before reading the counter value
Date:   Fri, 31 Jan 2020 16:37:22 +0000
Message-Id: <20200131163728.5228-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reads of the physical counter and the virtual counter registers "can occur
speculatively and out of order relative to other instructions executed on
the same PE" [1, 2].

There is no theoretical limit to the number of instructions that the CPU
can reorder and we use the counter value to program the timer to fire in
the future. Add an ISB before reading the counter to make sure the read
instruction is not reordered too long in the past with regard to the
instruction that programs the timer alarm, thus causing the timer to fire
unexpectedly. This matches what Linux does (see
arch/arm64/include/asm/arch_timer.h).

Because we use the counter value to program the timer, we create a register
dependency [3] between the value that we read and the value that we write to
CVAL and thus we don't need a barrier after the read. Linux does things
differently because the read needs to be ordered with regard to a memory
load (more information in commit 75a19a0202db ("arm64: arch_timer: Ensure
counter register reads occur with seqlock held")).

This also matches what we already do in get_cntvct from
lib/arm{,64}/asm/processor.h.

[1] ARM DDI 0487E.a, section D11.2.1
[2] ARM DDI 0487E.a, section D11.2.2
[3] ARM DDI 0486E.a, section B2.3.2

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index c6ea108cfa4b..e758e84855c3 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -30,6 +30,7 @@ static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
 
 static u64 read_vtimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntvct_el0);
 }
 
@@ -68,6 +69,7 @@ static void write_vtimer_ctl(u64 val)
 
 static u64 read_ptimer_counter(void)
 {
+	isb();
 	return read_sysreg(cntpct_el0);
 }
 
-- 
2.20.1

