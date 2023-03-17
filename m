Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268BC6BE862
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCQLh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjCQLhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68FD5A68
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a16so437346pjs.4
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053025;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9dHPvpP6H9JYLtPqTW/BeWDrK0Nn6vwGeB+P7ioLAq8=;
        b=Kc4wxRmpL0/HdJIJfP+fnPUzVQss5Yv9r4VMGL/CQp5ukoeI8wufU6ACdtfKwm305s
         Rj0qIHElh6z+nsVM6JqeIk70Khvuh2z5mbxNWaYeQncf6IlqqnjwHEoflNPRA2vDN8wY
         8P2N/T+/DiNSNXNOxA+0c8NuK7MmDASSg10boXZ0Vu8lUpKcxHOgY/0u7yf4lm1DkuQH
         rJvGeEYI1qmVRoGWeCt1Ju1JpyBQ50sDxNLzCQ72IFFdI+JO5G0XOQ38/youABGYc8Bo
         L6X/AViIQf6RLJjZeYy8y90F8lJbpirMezeyIY48vJcjiEkboZgYfaII7ANhdFT38Jak
         wuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053025;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dHPvpP6H9JYLtPqTW/BeWDrK0Nn6vwGeB+P7ioLAq8=;
        b=DAL4C9xWd8WwyOuxRWED6kaaSYTUcro50dFqqqGj8x9PfBRpMEPnaa2UuNZdoXDgCq
         NO9Yyx+xSBd/z4VdZFJeCd7b3TcSOlD4PsMc5lNO69EJ1YhwXfIU1ZGTw46RppHBqjNJ
         a+J73CGEU/AJvtaakYVFcZU62FoBuYca6ANuqR/faEm4+KfhgD3u2oGpxvoSAipXrK1D
         hpkulwM7UIh8Dxtp3tohvQp+Zi5z4dUUDPSjg6riav4YLnyvLFyCJ6NTwuQBvbfLmW55
         pypYQ6G/aAh0AHP6C1/cnUuEr2gIZjbTpVe4PyxxSsaB3/txCfcKFkKsYYHCj7P7piUl
         4j0A==
X-Gm-Message-State: AO0yUKUkRHparUIKgRtNHy3hLgw6LTMnjRxhG4ccvQWcbYG3niUb6Af+
        JLtXtVuC2lXsyGGDsfFV0MYC1A==
X-Google-Smtp-Source: AK7set+OOPPoQyGLOK+cynFouK3pY18HP8glSjxPqxTcfimLt+8DpivryQrgjm43FnUIXTi2hTVHow==
X-Received: by 2002:a17:90b:1b11:b0:23e:aba4:21e2 with SMTP id nu17-20020a17090b1b1100b0023eaba421e2mr8211915pjb.37.1679053024960;
        Fri, 17 Mar 2023 04:37:04 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:04 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH -next v15 08/19] riscv: Introduce struct/helpers to save/restore per-task Vector state
Date:   Fri, 17 Mar 2023 11:35:27 +0000
Message-Id: <20230317113538.10878-9-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 arch/riscv/include/asm/vector.h      | 97 ++++++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/ptrace.h | 17 +++++
 2 files changed, 114 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 18448e24d77b..c7143b7d64d1 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -10,8 +10,10 @@
 
 #ifdef CONFIG_RISCV_ISA_V
 
+#include <linux/stringify.h>
 #include <asm/hwcap.h>
 #include <asm/csr.h>
+#include <asm/asm.h>
 
 extern unsigned long riscv_v_vsize;
 void riscv_v_setup_vsize(void);
@@ -21,6 +23,26 @@ static __always_inline bool has_vector(void)
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
@@ -31,11 +53,86 @@ static __always_inline void riscv_v_disable(void)
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
 
+struct pt_regs;
+
 static __always_inline bool has_vector(void) { return false; }
+static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_setup_vsize()	 		do {} while (0)
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

