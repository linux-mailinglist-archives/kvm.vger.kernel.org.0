Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3712DA27
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLaQKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:52 -0500
Received: from foss.arm.com ([217.140.110.172]:35626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbfLaQKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21C10328;
        Tue, 31 Dec 2019 08:10:52 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4DC4E3F68F;
        Tue, 31 Dec 2019 08:10:50 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 18/18] arm: cstart64.S: Remove icache invalidation from asm_mmu_enable
Date:   Tue, 31 Dec 2019 16:09:49 +0000
Message-Id: <1577808589-31892-19-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the ARM ARM [1]:

"In Armv8, any permitted instruction cache implementation can be
described as implementing the IVIPT Extension to the Arm architecture.

The formal definition of the Arm IVIPT Extension is that it reduces the
instruction cache maintenance requirement to the following condition:
Instruction cache maintenance is required only after writing new data to
a PA that holds an instruction".

We never patch instructions in the boot path, so remove the icache
invalidation from asm_mmu_enable. Tests that modify instructions (like
the cache test) should have their own icache maintenance operations.

[1] ARM DDI 0487E.a, section D5.11.2 "Instruction caches"

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart64.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 87bf873795a1..7e7f8b2e8f0b 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -166,7 +166,6 @@ halt:
 
 .globl asm_mmu_enable
 asm_mmu_enable:
-	ic	iallu			// I+BTB cache invalidate
 	tlbi	vmalle1			// invalidate I + D TLBs
 	dsb	nsh
 
-- 
2.7.4

