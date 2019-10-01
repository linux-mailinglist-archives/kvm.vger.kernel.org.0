Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99744C3139
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbfJAKXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:23:54 -0400
Received: from foss.arm.com ([217.140.110.172]:45970 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbfJAKXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:23:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 385DD15A2;
        Tue,  1 Oct 2019 03:23:54 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA30A3F739;
        Tue,  1 Oct 2019 03:23:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 11/19] arm/cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
Date:   Tue,  1 Oct 2019 11:23:15 +0100
Message-Id: <20191001102323.27628-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's really no need to invalidate the TLB entries for all CPUs when
enabling the MMU for the current CPU, so use the non-shareable version of
the TLBI operation (and downgrade the DSB accordingly).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index f41ffa3bc6c2..87bf873795a1 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -167,8 +167,8 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	ic	iallu			// I+BTB cache invalidate
-	tlbi	vmalle1is		// invalidate I + D TLBs
-	dsb	ish
+	tlbi	vmalle1			// invalidate I + D TLBs
+	dsb	nsh
 
 	/* TCR */
 	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
-- 
2.20.1

