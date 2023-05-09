Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDD6FC3EB
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjEIKcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbjEIKcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:32:21 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3706140F1
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:32:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ab01bf474aso43127765ad.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628325; x=1686220325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahp5kQnTghgkZmiSTxR6+eMYSF2yeYW/B9Sl3mLm86I=;
        b=QuXs4LTMe1oMCgfy4c0PKb0/dOvTFtD7zMiKJx3tSzXxCaM4PUvG8qj+8hOwdty8Zr
         kYWycHrrqMv8tRu1zc+4y3BR1xxuh9DmZo/hl+ApJ2K2bxXhiEciQ2UZDDDOT/LKw7he
         3z+TeRLX9KKnjDtWBVbO3+kVmj2TR+sXJG88Iwe5hInny/qwd+JeJu9sTuzzfMOkCZE3
         zWZj6CwAv52pehI1V9P2QYwt1e2+GaysiYiISluhYYjr8WgLveMER52GczLhWO36VVMn
         6ctSPkA9sWTBj1FAq1bfjt5YU00LK/NLKtvsD7ZDWJ2H+wuqwJj1IrxmIgSU3LP7EOsQ
         o18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628325; x=1686220325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahp5kQnTghgkZmiSTxR6+eMYSF2yeYW/B9Sl3mLm86I=;
        b=F97/zRvZ42HSI8CRBmwCT55Wjd6xXYmeqMjtjMHow7nylNx0iLTYtxSKd/7H9vll8Q
         Ahe1VKwJKLLqL+OS9AYgK3IZy00hI/AThHgIQJXYtGmLyiTCeNkEEiHN8XFnzeXa1Si7
         5EnS/OXWUgwlqj1NX//tRXPaAWzjsY6G7Y6PK1jbh7h/kE0PBscVmpayhBneeSnLGlnP
         1VANlQTT22AhOsTRnMGpd6f2p+UiFS1TVak7T/JilHaAgHJHxZdmCpMkdJ8YoMV46Dow
         pgbvqTwz7LG5dIqsrIyJf5sh0Hd6eEYak2A5WoXAIH7KbVSIVTMqyGT/Ks1bFONvRhTa
         /Qxg==
X-Gm-Message-State: AC+VfDzRgH9bTss7/RSbU7LZGmBiVrhQkilzfKFn1f1SycvDPLzlEIgF
        wLpq2UWk6JKG15IZv6OXodGXhw==
X-Google-Smtp-Source: ACHHUZ6KFsz81viA3s3MvRxm/AxDuAtt4z22AwlOnW2jTQrrGqzIl05BEki990/hiZjbPe1AoMhs/g==
X-Received: by 2002:a17:902:ba86:b0:1a6:bd5c:649d with SMTP id k6-20020a170902ba8600b001a6bd5c649dmr13435174pls.56.1683628325622;
        Tue, 09 May 2023 03:32:05 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:32:05 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH -next v19 09/24] riscv: Introduce struct/helpers to save/restore per-task Vector state
Date:   Tue,  9 May 2023 10:30:18 +0000
Message-Id: <20230509103033.11285-10-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Add vector state context struct to be added later in thread_struct. And
prepare low-level helper functions to save/restore vector contexts.

This include Vector Regfile and CSRs holding dynamic configuration state
(vstart, vl, vtype, vcsr). The Vec Register width could be implementation
defined, but same for all processes, so that is saved separately.

This is not yet wired into final thread_struct - will be done when
__switch_to actually starts doing this in later patches.

Given the variable (and potentially large) size of regfile, they are
saved in dynamically allocated memory, pointed to by datap pointer in
__riscv_v_ext_state.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/include/asm/vector.h      | 95 ++++++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/ptrace.h | 17 +++++
 2 files changed, 112 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 68c9fe831a41..7a56bb0769aa 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -11,8 +11,10 @@
 
 #ifdef CONFIG_RISCV_ISA_V
 
+#include <linux/stringify.h>
 #include <asm/hwcap.h>
 #include <asm/csr.h>
+#include <asm/asm.h>
 
 extern unsigned long riscv_v_vsize;
 int riscv_v_setup_vsize(void);
@@ -22,6 +24,26 @@ static __always_inline bool has_vector(void)
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
 }
 
+static inline void __riscv_v_vstate_clean(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~SR_VS) | SR_VS_CLEAN;
+}
+
+static inline void riscv_v_vstate_off(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~SR_VS) | SR_VS_OFF;
+}
+
+static inline void riscv_v_vstate_on(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~SR_VS) | SR_VS_INITIAL;
+}
+
+static inline bool riscv_v_vstate_query(struct pt_regs *regs)
+{
+	return (regs->status & SR_VS) != 0;
+}
+
 static __always_inline void riscv_v_enable(void)
 {
 	csr_set(CSR_SSTATUS, SR_VS);
@@ -32,13 +54,86 @@ static __always_inline void riscv_v_disable(void)
 	csr_clear(CSR_SSTATUS, SR_VS);
 }
 
+static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state *dest)
+{
+	asm volatile (
+		"csrr	%0, " __stringify(CSR_VSTART) "\n\t"
+		"csrr	%1, " __stringify(CSR_VTYPE) "\n\t"
+		"csrr	%2, " __stringify(CSR_VL) "\n\t"
+		"csrr	%3, " __stringify(CSR_VCSR) "\n\t"
+		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl),
+		  "=r" (dest->vcsr) : :);
+}
+
+static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_state *src)
+{
+	asm volatile (
+		".option push\n\t"
+		".option arch, +v\n\t"
+		"vsetvl	 x0, %2, %1\n\t"
+		".option pop\n\t"
+		"csrw	" __stringify(CSR_VSTART) ", %0\n\t"
+		"csrw	" __stringify(CSR_VCSR) ", %3\n\t"
+		: : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
+		    "r" (src->vcsr) :);
+}
+
+static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to,
+					 void *datap)
+{
+	unsigned long vl;
+
+	riscv_v_enable();
+	__vstate_csr_save(save_to);
+	asm volatile (
+		".option push\n\t"
+		".option arch, +v\n\t"
+		"vsetvli	%0, x0, e8, m8, ta, ma\n\t"
+		"vse8.v		v0, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vse8.v		v8, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vse8.v		v16, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vse8.v		v24, (%1)\n\t"
+		".option pop\n\t"
+		: "=&r" (vl) : "r" (datap) : "memory");
+	riscv_v_disable();
+}
+
+static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_from,
+					    void *datap)
+{
+	unsigned long vl;
+
+	riscv_v_enable();
+	asm volatile (
+		".option push\n\t"
+		".option arch, +v\n\t"
+		"vsetvli	%0, x0, e8, m8, ta, ma\n\t"
+		"vle8.v		v0, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vle8.v		v8, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vle8.v		v16, (%1)\n\t"
+		"add		%1, %1, %0\n\t"
+		"vle8.v		v24, (%1)\n\t"
+		".option pop\n\t"
+		: "=&r" (vl) : "r" (datap) : "memory");
+	__vstate_csr_restore(restore_from);
+	riscv_v_disable();
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 struct pt_regs;
 
 static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
 static __always_inline bool has_vector(void) { return false; }
+static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
+#define riscv_v_vstate_off(regs)		do {} while (0)
+#define riscv_v_vstate_on(regs)			do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 882547f6bd5c..586786d023c4 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -77,6 +77,23 @@ union __riscv_fp_state {
 	struct __riscv_q_ext_state q;
 };
 
+struct __riscv_v_ext_state {
+	unsigned long vstart;
+	unsigned long vl;
+	unsigned long vtype;
+	unsigned long vcsr;
+	void *datap;
+	/*
+	 * In signal handler, datap will be set a correct user stack offset
+	 * and vector registers will be copied to the address of datap
+	 * pointer.
+	 *
+	 * In ptrace syscall, datap will be set to zero and the vector
+	 * registers will be copied to the address right after this
+	 * structure.
+	 */
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
-- 
2.17.1

