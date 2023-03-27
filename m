Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9696C6CAB05
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjC0QvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjC0QvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:51:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6C33C13
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id r7-20020a17090b050700b002404be7920aso8362564pjz.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935858;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N/CoWMWIQZXnMP/KNxBlY67PbYq9vDOHMJRCBoKpsrw=;
        b=YRmyxvdIyWINHT/pjNRSSGTLCp0/L9FT8pNxRFTmdJAfaxW9ljUGYnHytf0rmk//YF
         f4rpMahYmkxv0sx6EJNrh5ulnd5ZERYxIQKHit6cEqVaHz6FP2LINylBIN6O6IQmxZv5
         hq2NGZS+bJ8r7JmThbPkxS1SL6L65cQ3jy/9Iur3eb1oUcHxEppYw6NZ3xmbtYw+fYIo
         7N8xIPWxHb695zRQRthWYZZevxiIA/ACvGBMe8tXJJADhEZ1GFuntwTMdHIZ8bgvJHpQ
         s8x1pf69yQRqLM5AuuORPWDovfKq7lnD6dZ3tl0z0Eq0kqGlXrgbqk6Qzh8yPGELf/vo
         hEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935858;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/CoWMWIQZXnMP/KNxBlY67PbYq9vDOHMJRCBoKpsrw=;
        b=FcmLX3EDuDaorm1uW8MOAaZy2AHr3T9IO0hE7lt7acouEIXf1Wy2bRBAwohWSDeYT/
         Bodooanv8fgEiZH+99P3qrW/1vrvuOR+8u+suY14SvSTmYF6Qjg8Vw5+nzOCceoz5gH1
         9gy7etNKxowaMfafCV4crUytIbkDMkxiegdi2iZWIiEUZIfJ/HulidBrWn2Y3+Fi38hj
         TZ+hK+AlACTOKjn2ppnYNWyXZ9K0GOhle0tcGKjlnZ6tTRWKtzp5Ba9SKL9kEB/oiODQ
         mJSPKAc1wx0gUOerItPntA1uYvdTuc6Fw9AvwTc+/ZE4PTukg3EeTmQuh1oRcEn6misA
         IAoQ==
X-Gm-Message-State: AO0yUKV+Fm40ZALmh6jAVTyh/w0RWOvKr1yUddA224N94ZJ5NzpVkUev
        5j9dVwVJQ1JxhDeNX3k7jmULR2TzwLVR0TD2ew8=
X-Google-Smtp-Source: AK7set/9lp23oY0lwj5aw/dfQ9vRlbzt1nmJwFnW5gzGSiK8k4ewRE5VNaIcS7Cjd4Qypf9ugaN+ng==
X-Received: by 2002:a05:6a20:1aaf:b0:da:53ca:8f26 with SMTP id ci47-20020a056a201aaf00b000da53ca8f26mr9571774pzb.30.1679935857791;
        Mon, 27 Mar 2023 09:50:57 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:57 -0700 (PDT)
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
        Conor Dooley <conor.dooley@microchip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Qing Zhang <zhangqing@loongson.cn>
Subject: [PATCH -next v17 11/20] riscv: Add ptrace vector support
Date:   Mon, 27 Mar 2023 16:49:31 +0000
Message-Id: <20230327164941.20491-12-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 23c48b14a0e7..75e66c040b64 100644
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
+	membuf_zero(&to, sizeof(void *));
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

