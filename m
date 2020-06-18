Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF0B1FF9F4
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 19:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbgFRRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 13:12:17 -0400
Received: from foss.arm.com ([217.140.110.172]:55466 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgFRRMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 13:12:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CB5931B;
        Thu, 18 Jun 2020 10:12:15 -0700 (PDT)
Received: from monolith.arm.com (unknown [10.37.8.10])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE59A3F6CF;
        Thu, 18 Jun 2020 10:12:13 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com
Subject: [PATCH] arm64: kvm: Annotate hyp NMI-related functions as __always_inline
Date:   Thu, 18 Jun 2020 18:12:54 +0100
Message-Id: <20200618171254.1596055-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "inline" keyword is a hint for the compiler to inline a function.  The
functions system_uses_irq_prio_masking() and gic_write_pmr() are used by
the code running at EL2 on a non-VHE system, so mark them as
__always_inline to make sure they'll always be part of the .hyp.text
section.

This fixes the following splat when trying to run a VM:

[   47.625273] Kernel panic - not syncing: HYP panic:
[   47.625273] PS:a00003c9 PC:0000ca0b42049fc4 ESR:86000006
[   47.625273] FAR:0000ca0b42049fc4 HPFAR:0000000010001000 PAR:0000000000000000
[   47.625273] VCPU:0000000000000000
[   47.647261] CPU: 1 PID: 217 Comm: kvm-vcpu-0 Not tainted 5.8.0-rc1-ARCH+ #61
[   47.654508] Hardware name: Globalscale Marvell ESPRESSOBin Board (DT)
[   47.661139] Call trace:
[   47.663659]  dump_backtrace+0x0/0x1cc
[   47.667413]  show_stack+0x18/0x24
[   47.670822]  dump_stack+0xb8/0x108
[   47.674312]  panic+0x124/0x2f4
[   47.677446]  panic+0x0/0x2f4
[   47.680407] SMP: stopping secondary CPUs
[   47.684439] Kernel Offset: disabled
[   47.688018] CPU features: 0x240402,20002008
[   47.692318] Memory Limit: none
[   47.695465] ---[ end Kernel panic - not syncing: HYP panic:
[   47.695465] PS:a00003c9 PC:0000ca0b42049fc4 ESR:86000006
[   47.695465] FAR:0000ca0b42049fc4 HPFAR:0000000010001000 PAR:0000000000000000
[   47.695465] VCPU:0000000000000000 ]---

The instruction abort was caused by the code running at EL2 trying to fetch
an instruction which wasn't mapped in the EL2 translation tables. Using
objdump showed the two functions as separate symbols in the .text section.

Fixes: 85738e05dc38 ("arm64: kvm: Unmask PMR before entering guest")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h | 2 +-
 arch/arm64/include/asm/cpufeature.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index a358e97572c1..6647ae4f0231 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -109,7 +109,7 @@ static inline u32 gic_read_pmr(void)
 	return read_sysreg_s(SYS_ICC_PMR_EL1);
 }
 
-static inline void gic_write_pmr(u32 val)
+static __always_inline void gic_write_pmr(u32 val)
 {
 	write_sysreg_s(val, SYS_ICC_PMR_EL1);
 }
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5d1f4ae42799..f7c3d1ff091d 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -675,7 +675,7 @@ static inline bool system_supports_generic_auth(void)
 		cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH);
 }
 
-static inline bool system_uses_irq_prio_masking(void)
+static __always_inline bool system_uses_irq_prio_masking(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) &&
 	       cpus_have_const_cap(ARM64_HAS_IRQ_PRIO_MASKING);
-- 
2.27.0

