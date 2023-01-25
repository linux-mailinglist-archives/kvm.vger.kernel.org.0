Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56F667B430
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjAYOV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbjAYOVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EB04B892
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lp10so15249532pjb.4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I461UKwYCe7oejg8aaYPXuzSkV6F30l8yLoOf3ygkB4=;
        b=GRH57D0ezoBm1KqgDbbchAl29975AdJ/YorG7T/Y+oqaHevLcKrumc0dSFs5fvoOV0
         oJL+h3Cwvhf3ubtD+9X8Q3sSIBReq5cBe8ZwkpoSD0cn70BWPAGyB/5vFyH3elErczq8
         c280iYEpMAq1nPIaL791oCsKQURE6LAksfrFZaT+tHQFMxPUR2hbqPrltZg0SeDeFIez
         GUIwni9KlRpNXV633W/i2gh83wZuV23oIQ8geAFf1zvU36roWe70cOiDmwy7veD9y+DJ
         2R8q5bTbYoH2QE7dR1iW2D8FCzkc2EqzwlSCHNkP/ie8wJPj/8rI0EtZRviJu+wW2tOr
         KCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I461UKwYCe7oejg8aaYPXuzSkV6F30l8yLoOf3ygkB4=;
        b=RJ15p76uM6HXQg3Fidciv37zZSeXq64OMjNSjzd3Obb/szgVPSojFrLn1qHYeGR3aB
         9iOUUR09z+C2RCRUHcIoBRmLfreXEmhvg+Vyvynj5RCUaUPWeUlGTD80Fd6D0/gZT/3B
         mPlbtQhrM/07YTA9+J6M1OpWsfFqMbYPKAwZby6SiCnyBOGWm1/7Rf0Gi/EIqG6oMb8S
         0HbuAIPbhn4tWhMGtjGbv6n+vz3S8tdwMcuvV7zCm9roliMKuQyi8aefrzkWDyO3ohZz
         ZaH+D6Mz7rlDHuGMia2reOirbMN1e9eav7mdLhxX3Rk3ZDUQP5TBlqUVRFj21Je4gm03
         A3gw==
X-Gm-Message-State: AFqh2krqgmbjWwF0Zo2IDAsl/UMI8AM7zkaG6OKDPYWlCMVjUzQKo3v0
        vCgc2rASPbedpYKBv7dO/v+7nA==
X-Google-Smtp-Source: AMrXdXsg/AKY+8+tJy6lpshr2gM1GnesjhZ5ahV28D5bSSWPggmjdVSd4FdK6DGZJxoO0A1xfv4YFw==
X-Received: by 2002:a05:6a21:3296:b0:b8:8961:b169 with SMTP id yt22-20020a056a21329600b000b88961b169mr45638126pzb.25.1674656502980;
        Wed, 25 Jan 2023 06:21:42 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:42 -0800 (PST)
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
Subject: [PATCH -next v13 08/19] riscv: Introduce struct/helpers to save/restore per-task Vector state
Date:   Wed, 25 Jan 2023 14:20:45 +0000
Message-Id: <20230125142056.18356-9-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
__riscv_v_state.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
[vineetg: merged bits from 2 different patches]
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
[andy.chiu: use inline asm to save/restore context, remove asm vaiant]
---
 arch/riscv/include/asm/vector.h      | 84 ++++++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/ptrace.h | 17 ++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 16cb4a1c1230..842a859609b5 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -12,6 +12,9 @@
 
 #include <asm/hwcap.h>
 #include <asm/csr.h>
+#include <asm/asm.h>
+
+#define CSR_STR(x) __ASM_STR(x)
 
 extern unsigned long riscv_vsize;
 
@@ -20,6 +23,26 @@ static __always_inline bool has_vector(void)
 	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_VECTOR]);
 }
 
+static inline void __vstate_clean(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~(SR_VS)) | SR_VS_CLEAN;
+}
+
+static inline void vstate_off(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~SR_VS) | SR_VS_OFF;
+}
+
+static inline void vstate_on(struct pt_regs *regs)
+{
+	regs->status = (regs->status & ~(SR_VS)) | SR_VS_INITIAL;
+}
+
+static inline bool vstate_query(struct pt_regs *regs)
+{
+	return (regs->status & SR_VS) != 0;
+}
+
 static __always_inline void rvv_enable(void)
 {
 	csr_set(CSR_SSTATUS, SR_VS);
@@ -30,10 +53,71 @@ static __always_inline void rvv_disable(void)
 	csr_clear(CSR_SSTATUS, SR_VS);
 }
 
+static __always_inline void __vstate_csr_save(struct __riscv_v_state *dest)
+{
+	asm volatile (
+		"csrr	%0, " CSR_STR(CSR_VSTART) "\n\t"
+		"csrr	%1, " CSR_STR(CSR_VTYPE) "\n\t"
+		"csrr	%2, " CSR_STR(CSR_VL) "\n\t"
+		"csrr	%3, " CSR_STR(CSR_VCSR) "\n\t"
+		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl),
+		  "=r" (dest->vcsr) : :);
+}
+
+static __always_inline void __vstate_csr_restore(struct __riscv_v_state *src)
+{
+	asm volatile (
+		"vsetvl	 x0, %2, %1\n\t"
+		"csrw	" CSR_STR(CSR_VSTART) ", %0\n\t"
+		"csrw	" CSR_STR(CSR_VCSR) ", %3\n\t"
+		: : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
+		    "r" (src->vcsr) :);
+}
+
+static inline void __vstate_save(struct __riscv_v_state *save_to, void *datap)
+{
+	rvv_enable();
+	__vstate_csr_save(save_to);
+	asm volatile (
+		"vsetvli	t4, x0, e8, m8, ta, ma\n\t"
+		"vse8.v		v0, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vse8.v		v8, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vse8.v		v16, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vse8.v		v24, (%0)\n\t"
+		: : "r" (datap) : "t4", "memory");
+	rvv_disable();
+}
+
+static inline void __vstate_restore(struct __riscv_v_state *restore_from,
+				    void *datap)
+{
+	rvv_enable();
+	asm volatile (
+		"vsetvli	t4, x0, e8, m8, ta, ma\n\t"
+		"vle8.v		v0, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vle8.v		v8, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vle8.v		v16, (%0)\n\t"
+		"add		%0, %0, t4\n\t"
+		"vle8.v		v24, (%0)\n\t"
+		: : "r" (datap) : "t4");
+	__vstate_csr_restore(restore_from);
+	rvv_disable();
+}
+
 #else /* ! CONFIG_RISCV_ISA_V  */
 
+struct pt_regs;
+
 static __always_inline bool has_vector(void) { return false; }
+static inline bool vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_vsize (0)
+#define vstate_off(regs)		do {} while (0)
+#define vstate_on(regs)			do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 882547f6bd5c..6ee1ca2edfa7 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -77,6 +77,23 @@ union __riscv_fp_state {
 	struct __riscv_q_ext_state q;
 };
 
+struct __riscv_v_state {
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

