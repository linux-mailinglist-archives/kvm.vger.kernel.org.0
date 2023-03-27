Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B16CAB00
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjC0Quo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjC0Qum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:50:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4222730EB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c18so8986389ple.11
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Udr950R2Z02WuBhnFPF0mNQ6jR2x6UMx+TQ6xeOkBXQ=;
        b=eJkMdCIOK/a37GcACaI9FeNjF/vy+cAVmyKJtJW0FPm/4M33eA4rmCzSd4Nwkg8SCF
         b9W/ioa3yGYIR9hJ2P/UkDIhxLvOSPZh/iP9PHlMWtWgmEk4Iz3pkp5DAugHbiDcaakX
         VAYjw/vJbYcRyun/wua2ah/dpsiJ1KGMTfeMVnxcklur5YGbF1Ms6yMiDFMCIFlwOlTX
         qpoHScNI7OAPDZBufh2VobHgO2sEuWUXzcl5qa3Z/QORLDcmeKkLzIv9dmG7vmLK5KJ5
         RCSLS9UTIAxS1s1ggG3j9iZyE/Id4HOw/p0fx2Es9alpwmO2D9oSH99HcGv6pkMxToZK
         TdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Udr950R2Z02WuBhnFPF0mNQ6jR2x6UMx+TQ6xeOkBXQ=;
        b=KpHgiO6gZESocdD0ujT/7c3G4E4GmziFvusjj4w6mHFVpQHC0AFZowL2SnL25Ab4d3
         X3lKve/GPOCSU248IMgEPu6rheLkJ6EXEuu0AWJYC1v+ngnX6xIJr4NYWp+sSSkkgIwR
         NhNMepFeDt//OrgP6qNJWYcMHFhWFGQCPzMvN+jokEnRr2SwM3vBIN4AVdvf37AzCc1C
         XVr8+dV8RexyitF8kBSTSpCLTXvvZyj+jatnYDn6wMcdTcrZ/u+zd3sAdDEabxmZWJrF
         pDGvb4S/+hULGe9UhPCFxwE8m+AwvrVycI3aHrFPD6sEdoWFT+bYDFs0e8WgFZeDJzRX
         mDWQ==
X-Gm-Message-State: AO0yUKWRuzlQgC5+SagtRG5fdLrY02Yw3tG8ba34lwGNjGZ+PJt0PnuY
        QjcRM4bHrVUWMOm7dOt8YQCNSw==
X-Google-Smtp-Source: AK7set/EVgggal0RNDrlrwcfcoyUTEdcnun7QzGdZ6yKGp579tgvpTlFOCX+yvmgSDIemeyL4AiKoQ==
X-Received: by 2002:a05:6a20:bc9e:b0:dd:7661:fb34 with SMTP id fx30-20020a056a20bc9e00b000dd7661fb34mr10387614pzb.51.1679935833878;
        Mon, 27 Mar 2023 09:50:33 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:33 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH -next v17 08/20] riscv: Introduce struct/helpers to save/restore per-task Vector state
Date:   Mon, 27 Mar 2023 16:49:28 +0000
Message-Id: <20230327164941.20491-9-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/riscv/include/asm/vector.h      | 97 ++++++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/ptrace.h | 17 +++++
 2 files changed, 114 insertions(+)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index e433ba3cd4da..cb60637443be 100644
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
 #define riscv_v_setup_vsize()			do {} while (0)
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

