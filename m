Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC77085E9
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 18:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjERQV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjERQVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 12:21:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7164E1723
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:30 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so263734b3a.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 09:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684426888; x=1687018888;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eqKkCeR0VN0glMEno0S7kDNRAT+sQdtfWCgUmgho7EE=;
        b=Ch4/9TVTWhCscKnaJFQjmCNA1+VVXMjvNhaOydoCYC548TleD3E/qvQza8qzeBlASf
         JzoSZhSS8TeEy4vmpZ9DYzw43dK7yLVyxsgH6PVSie2zjMTCXbumIaKiMHF4elZccnDW
         x/vDQe6/Mtg8srqi0thuduU7DyUqO1x2kMjchxjFBWFCmeZGppKwIhNn/PvOy1rmFyAO
         T6IOpN8Xc1bldNCslA/wZ7fa2/yFF9yvASrzKBwPaapkNb1kYtB9FT0hX18XKjzSt+iX
         3sMz8YGF5lpnNlIyCTHih6M1jFL4NFJfE1ALInqOMH1Bzhdk/ZGZSbC4Nf6R3xidXz9y
         12Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684426888; x=1687018888;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqKkCeR0VN0glMEno0S7kDNRAT+sQdtfWCgUmgho7EE=;
        b=kgRTihEU5N6OWSzxShgPMA/JqBfSGG/M6pnjkqyraC1/EdeOnKjwQT7E5ZJo5G1uA+
         JM9AgzoQ1CRRpJgpSTqo8ITw4ldty65HIqfNMkXx3BGAXYAosliR6nZrEojjY+yz52u+
         R9LUAMGMqTSxBPYCs32JyISKZbLe4yCoAfGfxd9f9gvkNPW8XIjC5M0TaoT/mRGxd0Zl
         Bpy+aXwqYrBr5I1Nn/xrRtMoLdGemjWMG6xs8vBR8tasw2WFWoGqzJhsWQ3xQlzDKR6b
         BUNevM2rPfYeqmW0269iIFmkYo3ROVFt1eB5Px6Go7L2tj9Sr8qlpdjEj/oqDZEeDenC
         Moxg==
X-Gm-Message-State: AC+VfDxRHtGkYT81nEMIkrPPeIO4Jk8k0EG34vdNz4P9vOutifETMH03
        /SoY8q76HEwC/wmn12a1IvBkPQ==
X-Google-Smtp-Source: ACHHUZ6E0KyTQdG2PV+0wjQp8/IFxiwtOAx76jX0jhBczfqnPbcEEag/w5G4YJmKSnucFVwUhNYdfA==
X-Received: by 2002:a05:6a20:12d3:b0:101:5f33:94ad with SMTP id v19-20020a056a2012d300b001015f3394admr194997pzg.52.1684426888575;
        Thu, 18 May 2023 09:21:28 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x23-20020a62fb17000000b006414b2c9efasm1515862pfm.123.2023.05.18.09.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 09:21:27 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Qing Zhang <zhangqing@loongson.cn>,
        Rolf Eike Beer <eb@emlix.com>
Subject: [PATCH -next v20 12/26] riscv: Add ptrace vector support
Date:   Thu, 18 May 2023 16:19:35 +0000
Message-Id: <20230518161949.11203-13-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518161949.11203-1-andy.chiu@sifive.com>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch adds ptrace support for riscv vector. The vector registers will
be saved in datap pointer of __riscv_v_ext_state. This pointer will be set
right after the __riscv_v_ext_state data structure then it will be put in
ubuf for ptrace system call to get or set. It will check if the datap got
from ubuf is set to the correct address or not when the ptrace system call
is trying to set the vector registers.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
Changelog V18:
 - Use sizeof(vstate->datap) instead of sizeof(void*) (Eike)
---
 arch/riscv/include/uapi/asm/ptrace.h |  7 +++
 arch/riscv/kernel/ptrace.c           | 70 ++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  1 +
 3 files changed, 78 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 586786d023c4..e8d127ec5cf7 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -94,6 +94,13 @@ struct __riscv_v_ext_state {
 	 */
 };
 
+/*
+ * According to spec: The number of bits in a single vector register,
+ * VLEN >= ELEN, which must be a power of 2, and must be no greater than
+ * 2^16 = 65536bits = 8192bytes
+ */
+#define RISCV_MAX_VLENB (8192)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 23c48b14a0e7..1d572cf3140f 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -7,6 +7,7 @@
  * Copied from arch/tile/kernel/ptrace.c
  */
 
+#include <asm/vector.h>
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
@@ -24,6 +25,9 @@ enum riscv_regset {
 #ifdef CONFIG_FPU
 	REGSET_F,
 #endif
+#ifdef CONFIG_RISCV_ISA_V
+	REGSET_V,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -80,6 +84,61 @@ static int riscv_fpr_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_ISA_V
+static int riscv_vr_get(struct task_struct *target,
+			const struct user_regset *regset,
+			struct membuf to)
+{
+	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
+
+	if (!riscv_v_vstate_query(task_pt_regs(target)))
+		return -EINVAL;
+
+	/*
+	 * Ensure the vector registers have been saved to the memory before
+	 * copying them to membuf.
+	 */
+	if (target == current)
+		riscv_v_vstate_save(current, task_pt_regs(current));
+
+	/* Copy vector header from vstate. */
+	membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, datap));
+	membuf_zero(&to, sizeof(vstate->datap));
+
+	/* Copy all the vector registers from vstate. */
+	return membuf_write(&to, vstate->datap, riscv_v_vsize);
+}
+
+static int riscv_vr_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	int ret, size;
+	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
+
+	if (!riscv_v_vstate_query(task_pt_regs(target)))
+		return -EINVAL;
+
+	/* Copy rest of the vstate except datap */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate, 0,
+				 offsetof(struct __riscv_v_ext_state, datap));
+	if (unlikely(ret))
+		return ret;
+
+	/* Skip copy datap. */
+	size = sizeof(vstate->datap);
+	count -= size;
+	ubuf += size;
+
+	/* Copy all the vector registers. */
+	pos = 0;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate->datap,
+				 0, riscv_v_vsize);
+	return ret;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		.core_note_type = NT_PRSTATUS,
@@ -99,6 +158,17 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = riscv_fpr_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_ISA_V
+	[REGSET_V] = {
+		.core_note_type = NT_RISCV_VECTOR,
+		.align = 16,
+		.n = ((32 * RISCV_MAX_VLENB) +
+		      sizeof(struct __riscv_v_ext_state)) / sizeof(__u32),
+		.size = sizeof(__u32),
+		.regset_get = riscv_vr_get,
+		.set = riscv_vr_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ac3da855fb19..7d8d9ae36615 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -440,6 +440,7 @@ typedef struct elf64_shdr {
 #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
 #define NT_MIPS_FP_MODE	0x801		/* MIPS floating-point mode */
 #define NT_MIPS_MSA	0x802		/* MIPS SIMD registers */
+#define NT_RISCV_VECTOR	0x900		/* RISC-V vector registers */
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NT_LOONGARCH_CSR	0xa01	/* LoongArch control and status registers */
 #define NT_LOONGARCH_LSX	0xa02	/* LoongArch Loongson SIMD Extension registers */
-- 
2.17.1

