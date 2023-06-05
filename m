Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4F3722B82
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbjFEPmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbjFEPl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:41:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2AB1981
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:33 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b011cffef2so45845585ad.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979679; x=1688571679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpPHieyVlo9+c3IVReFx0FCE99hnAu9eLlwHEwust2g=;
        b=ASbUni3uP4QBlGKnA1jDgKxw1LgqQLuh8uABwBOBgPAxn74EU+91YKZFGhbM0N1K7H
         zSLUEfV+4MQ+PO4AX0M32yA7pU4veQReW+1M91ci/MFm7EmuNw1gAtvQ7oSEMvw/2EbR
         0WW/9sav1Dtt+zH615PqAFfB6jyT8ViqkmiEBnlUUU34V7tqQiyPSDUoQeCX7iy1dXdf
         +uLr/e1KUAx0KHhkc1LXCcI8+YQQ50HO+tnPYSNa/9cy4dOvJ+QEp3U+SwaJROZ+e6ZL
         PblvsYeRYuhE7w2zg8uKQEgGyr6NnWGdKjnQ2VXxi0RwtMlkWMekOOZaPNvugof8aBc6
         K2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979679; x=1688571679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpPHieyVlo9+c3IVReFx0FCE99hnAu9eLlwHEwust2g=;
        b=AMv1lYeGxu6GuMFy4iLl78qqtTYpVEBAutZNYB9O+uizNzl1GZR1XJ2ZJO218dMLz9
         kmsvLUd0/1x9LeNMbMeBR+n4hPY4w0YjONTqHRfaIwLWkfDdEHmxcXBwZl+pdpHBl0iz
         aXD2VYlZZb9T2zifpxecR4i4/BWVdwFhI1a9sb7CcQ/5y+NEparIi0Pgj0t6SY6gqJh6
         7ZHCiw1lOnenFKHnUBCyc/4EiQIsycuOI6f9vQwGqcTW6KeFpUlccPLdFsdlyXk4r0NY
         NJSyzOR6YMWYM/B6E/Y9cfMLVjsQ6OOEapU4KNSN7cyQlw3TzjT6frKF20oxPYerkPi3
         bOtQ==
X-Gm-Message-State: AC+VfDxFX3hNHEWVoArteLaU5CDct6gD3qi63nUleJS2qz6inf1aQMhY
        JcoUrE+lmGcVBdidNpfSFQIj8w==
X-Google-Smtp-Source: ACHHUZ5i3fvT6T1qemxpcIaS16TmjcZrIINJwytHecFRYPQau81EV/BhCKqVg+3ZMNtrc9oH82kduA==
X-Received: by 2002:a17:902:d712:b0:1af:d724:63ed with SMTP id w18-20020a170902d71200b001afd72463edmr7074424ply.42.1685979679176;
        Mon, 05 Jun 2023 08:41:19 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:18 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Zong Li <zong.li@sifive.com>, Guo Ren <guoren@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v21 15/27] riscv: signal: Report signal frame size to userspace via auxv
Date:   Mon,  5 Jun 2023 11:07:12 +0000
Message-Id: <20230605110724.21391-16-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

The vector register belongs to the signal context. They need to be stored
and restored as entering and leaving the signal handler. According to the
V-extension specification, the maximum length of the vector registers can
be 2^16. Hence, if userspace refers to the MINSIGSTKSZ to create a
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
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
Changelog V19:
 - Fix a conflict in signal.c due to commit 8d736482749f
   ("riscv: add icache flush for nommu sigreturn trampoline")
---
 arch/riscv/include/asm/elf.h         |  9 +++++++++
 arch/riscv/include/asm/processor.h   |  2 ++
 arch/riscv/include/uapi/asm/auxvec.h |  1 +
 arch/riscv/kernel/signal.c           | 20 +++++++++++++++-----
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index 30e7d2455960..ca23c4f6c440 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -105,6 +105,15 @@ do {								\
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
index f0ddf691ac5e..38ded8c5f207 100644
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
index fb187a33ce58..10aaa83db89e 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -35,5 +35,6 @@
 
 /* entries in ARCH_DLINFO */
 #define AT_VECTOR_SIZE_ARCH	9
+#define AT_MINSIGSTKSZ		51
 
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index c46f3dc039bb..f117641c1c49 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -23,6 +23,8 @@
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
 
+unsigned long signal_minsigstksz __ro_after_init;
+
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
 
@@ -197,7 +199,7 @@ static long restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-static size_t get_rt_frame_size(void)
+static size_t get_rt_frame_size(bool cal_all)
 {
 	struct rt_sigframe __user *frame;
 	size_t frame_size;
@@ -205,8 +207,10 @@ static size_t get_rt_frame_size(void)
 
 	frame_size = sizeof(*frame);
 
-	if (has_vector() && riscv_v_vstate_query(task_pt_regs(current)))
-		total_context_size += riscv_v_sc_size;
+	if (has_vector()) {
+		if (cal_all || riscv_v_vstate_query(task_pt_regs(current)))
+			total_context_size += riscv_v_sc_size;
+	}
 	/*
 	 * Preserved a __riscv_ctx_hdr for END signal context header if an
 	 * extension uses __riscv_extra_ext_header
@@ -226,7 +230,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct rt_sigframe __user *frame;
 	struct task_struct *task;
 	sigset_t set;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
@@ -323,7 +327,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	struct rt_sigframe __user *frame;
 	long err = 0;
 	unsigned long __maybe_unused addr;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	frame = get_sigframe(ksig, regs, frame_size);
 	if (!access_ok(frame, frame_size))
@@ -465,4 +469,10 @@ void __init init_rt_signal_env(void)
 {
 	riscv_v_sc_size = sizeof(struct __riscv_ctx_hdr) +
 			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
+	/*
+	 * Determine the stack space required for guaranteed signal delivery.
+	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
+	 * in the auxiliary array at process startup.
+	 */
+	signal_minsigstksz = get_rt_frame_size(true);
 }
-- 
2.17.1

