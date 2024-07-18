Return-Path: <kvm+bounces-21823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA53934C60
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 13:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 628CA1C21D70
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 11:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC0A13AA38;
	Thu, 18 Jul 2024 11:24:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF3136E01;
	Thu, 18 Jul 2024 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721301845; cv=none; b=oDl5d5XUJw1cBU4OwWy115HHLP1/puyJemibQID5KbXaIfD+C7O1MVWFgZKFOPJCD0Wc5iqmiNANEr3PFtV93qVNJ+uMbO1V/AQ2HykejgujoCxR4jw/fzvsYa3a9m8sxDozZg5Ueiki0zTyPGhQunhWNm6jPhRHrRk1G8gNOXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721301845; c=relaxed/simple;
	bh=K+ehr7liMYpPS4555ePwGdOq8SJwtGqE+eX2Il26uL8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cVn+PUf/uTCQazeHP+RXRyFAWuanLKG/GDlaH1rSH4Ib1iOnY+Y8JiOyMIQgbl8gwhkK6hGzsVqFDeJ3M0epaUb4iGcUHNV4+QioxonEzvn23YwAioR9pqY8TM9LOxb0RgmKMFK+rg52DX3YdeSiVWGNuO+rDGmcPrrxGWQ5tc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ThinkPad-T480s.. (unknown [180.110.112.93])
	by APP-03 (Coremail) with SMTP id rQCowAAXHZk9+5hm0aZgFg--.36049S2;
	Thu, 18 Jul 2024 19:23:42 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 1/2] riscv: perf: add guest vs host distinction
Date: Thu, 18 Jul 2024 19:23:41 +0800
Message-Id: <8e2d2f60fc30d64b6c69b38184a1b640c7b30003.1721271251.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1721271251.git.zhouquan@iscas.ac.cn>
References: <cover.1721271251.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXHZk9+5hm0aZgFg--.36049S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXw45tF18Xw45CFy7tF43Wrg_yoW5Wr4DpF
	4DC3Z3KrWUWrs2934ayF4Uur15ur1rX3y7ZryI9w45CrsFqF98JF1kKw15AryFyrykXFy8
	J3WYvr45Cwn8taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYManUUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBwsCBmaY8NAcmAAAsS

From: Quan Zhou <zhouquan@iscas.ac.cn>

Introduce basic guest support in perf, enabling it to distinguish
between PMU interrupts in the host or guest, and collect
fundamental information.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/include/asm/perf_event.h |  7 ++++++
 arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
index 665bbc9b2f84..5866d028aee5 100644
--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -8,13 +8,20 @@
 #ifndef _ASM_RISCV_PERF_EVENT_H
 #define _ASM_RISCV_PERF_EVENT_H
 
+#ifdef CONFIG_PERF_EVENTS
 #include <linux/perf_event.h>
 #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
 
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_misc_flags(struct pt_regs *regs);
+#define perf_misc_flags(regs) perf_misc_flags(regs)
+
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->epc = (__ip); \
 	(regs)->s0 = (unsigned long) __builtin_frame_address(0); \
 	(regs)->sp = current_stack_pointer; \
 	(regs)->status = SR_PP; \
 }
+#endif
+
 #endif /* _ASM_RISCV_PERF_EVENT_H */
diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index 3348a61de7d9..c673dc6d9bd2 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -58,6 +58,11 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 {
 	unsigned long fp = 0;
 
+	if (perf_guest_state()) {
+		/* TODO: We don't support guest os callchain now */
+		return;
+	}
+
 	fp = regs->s0;
 	perf_callchain_store(entry, regs->epc);
 
@@ -74,5 +79,38 @@ static bool fill_callchain(void *entry, unsigned long pc)
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
+	if (perf_guest_state()) {
+		/* TODO: We don't support guest os callchain now */
+		return;
+	}
+
 	walk_stackframe(NULL, regs, fill_callchain, entry);
 }
+
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
+	if (perf_guest_state())
+		return perf_guest_get_ip();
+
+	return instruction_pointer(regs);
+}
+
+unsigned long perf_misc_flags(struct pt_regs *regs)
+{
+	unsigned int guest_state = perf_guest_state();
+	int misc = 0;
+
+	if (guest_state) {
+		if (guest_state & PERF_GUEST_USER)
+			misc |= PERF_RECORD_MISC_GUEST_USER;
+		else
+			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
+	} else {
+		if (user_mode(regs))
+			misc |= PERF_RECORD_MISC_USER;
+		else
+			misc |= PERF_RECORD_MISC_KERNEL;
+	}
+
+	return misc;
+}
-- 
2.34.1


