Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D612DA25
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfLaQKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:48 -0500
Received: from foss.arm.com ([217.140.110.172]:35606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfLaQKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4DBA328;
        Tue, 31 Dec 2019 08:10:47 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DE1693F68F;
        Tue, 31 Dec 2019 08:10:45 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 16/18] arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
Date:   Tue, 31 Dec 2019 16:09:47 +0000
Message-Id: <1577808589-31892-17-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
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
2.7.4

