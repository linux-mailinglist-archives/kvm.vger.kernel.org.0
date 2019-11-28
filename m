Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FF410CE48
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfK1SEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39440 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbfK1SEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E3401FB;
        Thu, 28 Nov 2019 10:04:52 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3AFC13F6C4;
        Thu, 28 Nov 2019 10:04:51 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 16/18] arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
Date:   Thu, 28 Nov 2019 18:04:16 +0000
Message-Id: <20191128180418.6938-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
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

