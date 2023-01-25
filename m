Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96A467B438
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbjAYOXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbjAYOXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:23:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A405975E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso2190038pjg.2
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eLbAXOZbwgUjNyd1ycRLXXifneyMqp4+hrjSAxv59Tg=;
        b=B4LQHHm1PrWBZsIXxPa0QzdFHdWyA8B0KywNCrfI3OMMoiGywC87C3WW0KfLC52AFt
         TPOSZXo6IGeeqRYHixCFW92lT8IOnNu90qmSMTgRqEQQC4s6HOlj+dRK0A7MSENSa52N
         1nGLxSll3y5a3HIJuVBjV7nBBGF9EAfoMTzyXtm647Rgh1oXSCyhn1jdjKHkr9a0sjOY
         DIGvx17YERMHOcw0sqSGQ2WNKnpHrE+ZwKWTf9647vux406+AM2pGFNJh0KQO/Myef8X
         ov+M3QCIOajCEYO0BRTDa3AoSxBAopSKYtn46GABLKX2f5UZcRpiO+oNULoteowZEHaV
         X33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLbAXOZbwgUjNyd1ycRLXXifneyMqp4+hrjSAxv59Tg=;
        b=WnVrgHiqgiSsh7A7TKfO8g/2pLRBL3HOSaUIoZzpXH1H59rnuKzGsIZTS8kNE8TgKv
         M1QXsUtLEju3FukGw+9iD912jcC75nC/3el54TWHSIAim1GRLz6pkiYYVo0TDKU5TE7k
         sikCqHs1OjCO2rVR4JakClv2iYAyBdPHZ15wR/OztGQG22fW52qFzRJ7/WR1eFT4O3Yr
         WuuXINznzaAD0BjgTFOc1jrvZmdiHhOr5ritojlhWDpYq23teqk01riINH0kEyjHPcQV
         e+KpNXZi6ODOXci+sRKND2ybwOeJYwVaCG4ttJfTOL4gqznnLyB99wnLJOHu41MvQgps
         NhOQ==
X-Gm-Message-State: AFqh2kqfrVc0KQu2YmQMkxyQfUUcwu04/9h/KKrp4pBfuEGiPfaeuoYP
        VbTKupxum/iFyFOOuKm8TAsxjA==
X-Google-Smtp-Source: AMrXdXuWJlSwRB5Ev/qUZdt3Lz70/jhT2BJYNZGezyQdQgqh4T52hDp4V1RPXLlpn9xR1Fna0ReeBg==
X-Received: by 2002:a05:6a20:491a:b0:af:98cd:846a with SMTP id ft26-20020a056a20491a00b000af98cd846amr34878044pzb.30.1674656546031;
        Wed, 25 Jan 2023 06:22:26 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:22:25 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Zong Li <zong.li@sifive.com>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v13 14/19] riscv: signal: Report signal frame size to userspace via auxv
Date:   Wed, 25 Jan 2023 14:20:51 +0000
Message-Id: <20230125142056.18356-15-andy.chiu@sifive.com>
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

From: Vincent Chen <vincent.chen@sifive.com>

The vector register belongs to the signal context. They need to be stored
and restored as entering and leaving the signal handler. According to the
V-extension specification, the maximum length of the vector registers can
be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
sigframe, it may not be enough. To resolve this problem, this patch refers
to the commit 94b07c1f8c39c
("arm64: signal: Report signal frame size to userspace via auxv") to enable
userspace to know the minimum required sigframe size through the auxiliary
vector and use it to allocate enough memory for signal context.

Note that auxv always reports size of the sigframe as if V exists for
all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
reason is that users usually reference this value to allocate an
alternative signal stack, and the user may use V anytime. So the user
must reserve a space for V-context in sigframe in case that the signal
handler invokes after the kernel allocating V.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/elf.h         |  9 +++++++++
 arch/riscv/include/asm/processor.h   |  2 ++
 arch/riscv/include/uapi/asm/auxvec.h |  1 +
 arch/riscv/kernel/signal.c           | 20 +++++++++++++++-----
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index e7acffdf21d2..c7eb40383453 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -103,6 +103,15 @@ do {								\
 		get_cache_size(3, CACHE_TYPE_UNIFIED));		\
 	NEW_AUX_ENT(AT_L3_CACHEGEOMETRY,			\
 		get_cache_geometry(3, CACHE_TYPE_UNIFIED));	\
+	/*							 \
+	 * Should always be nonzero unless there's a kernel bug. \
+	 * If we haven't determined a sensible value to give to	 \
+	 * userspace, omit the entry:				 \
+	 */							 \
+	if (likely(signal_minsigstksz))				 \
+		NEW_AUX_ENT(AT_MINSIGSTKSZ, signal_minsigstksz); \
+	else							 \
+		NEW_AUX_ENT(AT_IGNORE, 0);			 \
 } while (0)
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 44d2eb381ca6..4f36c553605e 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -7,6 +7,7 @@
 #define _ASM_RISCV_PROCESSOR_H
 
 #include <linux/const.h>
+#include <linux/cache.h>
 
 #include <vdso/processor.h>
 
@@ -81,6 +82,7 @@ int riscv_of_parent_hartid(struct device_node *node, unsigned long *hartid);
 extern void riscv_fill_hwcap(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 
+extern unsigned long signal_minsigstksz __ro_after_init;
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PROCESSOR_H */
diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index fb187a33ce58..2c50d9ca30e0 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -35,5 +35,6 @@
 
 /* entries in ARCH_DLINFO */
 #define AT_VECTOR_SIZE_ARCH	9
+#define AT_MINSIGSTKSZ 51
 
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index fe91475e63e4..8f5549c7eac5 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -21,6 +21,8 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 
+unsigned long __ro_after_init signal_minsigstksz;
+
 extern u32 __user_rt_sigreturn[2];
 static size_t rvv_sc_size;
 
@@ -195,7 +197,7 @@ static long restore_sigcontext(struct pt_regs *regs,
 	return -EINVAL;
 }
 
-static size_t cal_rt_frame_size(void)
+static size_t cal_rt_frame_size(bool cal_all)
 {
 	struct rt_sigframe __user *frame;
 	size_t frame_size;
@@ -203,8 +205,10 @@ static size_t cal_rt_frame_size(void)
 
 	frame_size = sizeof(*frame);
 
-	if (has_vector() && vstate_query(task_pt_regs(current)))
-		total_context_size += rvv_sc_size;
+	if (has_vector()) {
+		if (cal_all || vstate_query(task_pt_regs(current)))
+			total_context_size += rvv_sc_size;
+	}
 	/* Preserved a __riscv_ctx_hdr for END signal context header. */
 	total_context_size += sizeof(struct __riscv_ctx_hdr);
 
@@ -221,7 +225,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct rt_sigframe __user *frame;
 	struct task_struct *task;
 	sigset_t set;
-	size_t frame_size = cal_rt_frame_size();
+	size_t frame_size = cal_rt_frame_size(false);
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
@@ -309,7 +313,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
-	size_t frame_size = cal_rt_frame_size();
+	size_t frame_size = cal_rt_frame_size(false);
 
 	frame = get_sigframe(ksig, regs, frame_size);
 	if (!access_ok(frame, frame_size))
@@ -472,4 +476,10 @@ void __init init_rt_signal_env(void)
 {
 	rvv_sc_size = sizeof(struct __riscv_ctx_hdr) +
 		      sizeof(struct __sc_riscv_v_state) + riscv_vsize;
+	/*
+	 * Determine the stack space required for guaranteed signal delivery.
+	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
+	 * in the auxiliary array at process startup.
+	 */
+	signal_minsigstksz = cal_rt_frame_size(true);
 }
-- 
2.17.1

