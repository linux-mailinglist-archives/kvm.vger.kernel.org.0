Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195D710B13D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfK0OZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:28 -0500
Received: from foss.arm.com ([217.140.110.172]:48316 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfK0OZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECB1931B;
        Wed, 27 Nov 2019 06:25:26 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C95703F68E;
        Wed, 27 Nov 2019 06:25:25 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 16/18] arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
Date:   Wed, 27 Nov 2019 14:24:08 +0000
Message-Id: <20191127142410.1994-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
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

