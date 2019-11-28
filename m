Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794E810CE4B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK1SE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:56 -0500
Received: from foss.arm.com ([217.140.110.172]:39456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfK1SEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 124431FB;
        Thu, 28 Nov 2019 10:04:55 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E502F3F6C4;
        Thu, 28 Nov 2019 10:04:53 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 18/18] arm: cstart64.S: Remove icache invalidation from asm_mmu_enable
Date:   Thu, 28 Nov 2019 18:04:18 +0000
Message-Id: <20191128180418.6938-19-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

And immediately following: "Previous versions of the Arm architecture have
permitted an instruction cache option that does not implement the Arm IVIPT
Extension".

That type of cache is the ASID and VMID tagged VIVT instruction cache [2],
which require icache maintenance when the instruction at a given virtual
address changes. Seeing how we don't change the IPA for the same VA
anywhere in kvm-unit-tests, I think it should be up to the person who will
write such a test to use the appropriate maintenance operations.

[2] ARM DDI 0406C.d, section B3.11.2.

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
2.20.1

