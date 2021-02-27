Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36F326CCB
	for <lists+kvm@lfdr.de>; Sat, 27 Feb 2021 11:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhB0Kn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Feb 2021 05:43:26 -0500
Received: from foss.arm.com ([217.140.110.172]:43080 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhB0KnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Feb 2021 05:43:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5740F1396;
        Sat, 27 Feb 2021 02:41:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 965573F73B;
        Sat, 27 Feb 2021 02:41:52 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Mark Rutland <mark.rutland@arm.com>
Subject: [kvm-unit-tests PATCH 6/6] arm64: Disable TTBR1_EL1 translation table walks
Date:   Sat, 27 Feb 2021 10:42:01 +0000
Message-Id: <20210227104201.14403-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210227104201.14403-1-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From an architectural point of view, the PE can speculate instruction
fetches and data reads at any time when the MMU is enabled using the
translation tables from TTBR0_EL1 and TTBR1_EL1. kvm-unit-tests uses an
identity map, and as such it only programs TTBR0_EL1 with a valid table and
leaves TTBR1_EL1 unchanged. The reset value for TTBR1_EL1 is UNKNOWN, which
means it is possible for the PE to perform reads from memory locations
where accesses can cause side effects (like memory-mapped devices) as part
of the speculated translation table walk.

So far, this hasn't been a problem, because KVM resets TTBR{0,1}_EL1 to
zero, and that address is used for emulation for both qemu and kvmtool and
it doesn't point to a real device. However, kvm-unit-tests shouldn't rely
on a particular combination of hypervisor and userspace for correctness.
Another situation where we can't rely on these assumptions being true is
when kvm-unit-tests is run as an EFI app.

To prevent reads from arbitrary addresses, set the TCR_EL1.EPD1 bit to
disable speculative translation table walks using TTBR1_EL1.

This is similar to EDK2 commit fafb7e9c110e ("ArmPkg: correct TTBR1_EL1
settings in TCR_EL1"). Also mentioned in that commit is the Cortex-A57
erratum 822227 which impacts the hypervisor, but kvm-unit-tests is
protected against it because asm_mmu_enable sets both the TCR_EL1.TG0 and
TCR_EL1.TG1 bits when programming the register.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/pgtable-hwdef.h | 1 +
 arm/cstart64.S                | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 48a1d1ab1ac2..8c41fe123fb3 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -136,6 +136,7 @@
 #define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
+#define TCR_EPD1		(UL(1) << 23)
 #define TCR_TG0_4K		(UL(0) << 14)
 #define TCR_TG0_64K		(UL(1) << 14)
 #define TCR_TG0_16K		(UL(2) << 14)
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 42a838ff4c38..3d359c8387c9 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -181,7 +181,8 @@ asm_mmu_enable:
 	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
 		     TCR_TG_FLAGS  |			\
 		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
-		     TCR_SHARED
+		     TCR_SHARED |			\
+		     TCR_EPD1
 	mrs	x2, id_aa64mmfr0_el1
 	bfi	x1, x2, #32, #3
 	msr	tcr_el1, x1
-- 
2.30.1

