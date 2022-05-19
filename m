Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6052D509
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbiESNtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiESNsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C23FBED
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFB74B824B0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AF1C385B8;
        Thu, 19 May 2022 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968066;
        bh=p4epx9gpbWHrqgR4lCHBD+OJVcMuF2+CwY/eYIiDFs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3NX1aHtHJU6tzqRl9/COho2WNeulJ3zXdWEhi9RI6d91qW/bA7+rXfzwLabysnxO
         rO0lDyDbRy7+Ymcg/NMsVi0LFInppO07IoqKihDBZeGvEEZ0hX1PlW0uPD8Ad3XHyi
         c8C5LIbwC99YWuru23eZYC0e53HGfhJjVr/BmrIp4337cXYJRHlVnsKEcH8rEfdLLQ
         6rzguHJ/GqQ4HyblsBpNR+h4jwwchu/+kTWu7VzFwibZI9t2BOafulpf2jFNGIfTgR
         trXoPHJ+qV8DfeiQRy67jGv5XvrFq47kqruU5D4EfOJd6oI3Io2aqFr6w2mzHk6aDH
         fBDIBwcjZNNqQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 81/89] KVM: arm64: Inject SIGSEGV on illegal accesses
Date:   Thu, 19 May 2022 14:41:56 +0100
Message-Id: <20220519134204.5379-82-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The pKVM hypervisor will currently panic if the host tries to access
memory that it doesn't own (e.g. protected guest memory). Sadly, as
guest memory can still be mapped into the VMM's address space, userspace
can trivially crash the kernel/hypervisor by poking into guest memory.

To prevent this, inject the abort back in the host with S1PTW set in the
ESR, hence allowing the host to differentiate this abort from normal
userspace faults and inject a SIGSEGV cleanly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 50 ++++++++++++++++++++++++++-
 arch/arm64/mm/fault.c                 | 22 ++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d0544259eb01..8459dc33e460 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -549,6 +549,50 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static void host_inject_abort(struct kvm_cpu_context *host_ctxt)
+{
+	u64 spsr = read_sysreg_el2(SYS_SPSR);
+	u64 esr = read_sysreg_el2(SYS_ESR);
+	u64 ventry, ec;
+
+	/* Repaint the ESR to report a same-level fault if taken from EL1 */
+	if ((spsr & PSR_MODE_MASK) != PSR_MODE_EL0t) {
+		ec = ESR_ELx_EC(esr);
+		if (ec == ESR_ELx_EC_DABT_LOW)
+			ec = ESR_ELx_EC_DABT_CUR;
+		else if (ec == ESR_ELx_EC_IABT_LOW)
+			ec = ESR_ELx_EC_IABT_CUR;
+		else
+			WARN_ON(1);
+		esr &= ~ESR_ELx_EC_MASK;
+		esr |= ec << ESR_ELx_EC_SHIFT;
+	}
+
+	/*
+	 * Since S1PTW should only ever be set for stage-2 faults, we're pretty
+	 * much guaranteed that it won't be set in ESR_EL1 by the hardware. So,
+	 * let's use that bit to allow the host abort handler to differentiate
+	 * this abort from normal userspace faults.
+	 *
+	 * Note: although S1PTW is RES0 at EL1, it is guaranteed by the
+	 * architecture to be backed by flops, so it should be safe to use.
+	 */
+	esr |= ESR_ELx_S1PTW;
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(spsr, SYS_SPSR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el1(read_sysreg_el2(SYS_FAR), SYS_FAR);
+
+	ventry = read_sysreg_el1(SYS_VBAR);
+	ventry += get_except64_offset(spsr, PSR_MODE_EL1h, except_type_sync);
+	write_sysreg_el2(ventry, SYS_ELR);
+
+	spsr = get_except64_cpsr(spsr, system_supports_mte(),
+				 read_sysreg_el1(SYS_SCTLR), PSR_MODE_EL1h);
+	write_sysreg_el2(spsr, SYS_SPSR);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -560,7 +604,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 
 	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
 	ret = host_stage2_idmap(addr);
-	BUG_ON(ret && ret != -EAGAIN);
+
+	if (ret == -EPERM)
+		host_inject_abort(host_ctxt);
+	else
+		BUG_ON(ret && ret != -EAGAIN);
 }
 
 struct pkvm_mem_transition {
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 77341b160aca..2b2c16a2535c 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -41,6 +41,7 @@
 #include <asm/system_misc.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/virt.h>
 
 struct fault_info {
 	int	(*fn)(unsigned long far, unsigned int esr,
@@ -257,6 +258,15 @@ static inline bool is_el1_permission_fault(unsigned long addr, unsigned int esr,
 	return false;
 }
 
+static bool is_pkvm_stage2_abort(unsigned int esr)
+{
+	/*
+	 * S1PTW should only ever be set in ESR_EL1 if the pkvm hypervisor
+	 * injected a stage-2 abort -- see host_inject_abort().
+	 */
+	return is_pkvm_initialized() && (esr & ESR_ELx_S1PTW);
+}
+
 static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 							unsigned int esr,
 							struct pt_regs *regs)
@@ -268,6 +278,9 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	    (esr & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_FAULT)
 		return false;
 
+	if (is_pkvm_stage2_abort(esr))
+		return false;
+
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
@@ -383,6 +396,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 			msg = "read from unreadable memory";
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
+	} else if (is_pkvm_stage2_abort(esr)) {
+		msg = "access to hypervisor-protected memory";
 	} else {
 		if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
 			return;
@@ -572,6 +587,13 @@ static int __kprobes do_page_fault(unsigned long far, unsigned int esr,
 					 addr, esr, regs);
 	}
 
+	if (is_pkvm_stage2_abort(esr)) {
+		if (!user_mode(regs))
+			goto no_context;
+		arm64_force_sig_fault(SIGSEGV, SEGV_ACCERR, far, "stage-2 fault");
+		return 0;
+	}
+
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
 	/*
-- 
2.36.1.124.g0e6072fb45-goog

