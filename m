Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73866CAB09
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjC0Qvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjC0Qvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:51:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21E830C0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id cm5so287738pfb.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzAmKYXM2XOf3NeM3nR+dloZ9w8Z5wHrioWtDxR0LaU=;
        b=aBQWUNh1zZY44WTNnQsGb99YXKVGiNj9MZP3PMMCV6/2NWRn/oTqAgjOELQSJpiRd2
         fHl31K1OPffEqCmzisOveI4iU3c2HO6HOO3Aa2ZGjxJOpwHazCeTK+ucr9TuDHBgpiuU
         YJsJbzYJJuPvfN9b4jJXcCqQKAS1q4NVNRXUn5uKo6tlZOWOMZiZMOtANWp7YnY3kNL9
         xPopffCwAlGpQe5A0l9y/zBEr7O7W8AlsptOS2glhCTk8ZR7CoO8IiW2bJArhWPupLlm
         gdIy1utSsPAeuoBX5XpH3Zf7/PSktKOd++Qy69ycLziPcTP6OKFJoT5jEpy88VGByViF
         AC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzAmKYXM2XOf3NeM3nR+dloZ9w8Z5wHrioWtDxR0LaU=;
        b=g7/yiy/NVNFyrKtjvsP5MYhZol1q3ZOlWEWm+MVwiYCQlf4k4STZ+HuoEuLOZzAcLi
         voUQViEChrJswoo/GigpBEvmUqqEcCE1wa38F20uCqm/lVzKm13s+jWYiat+nB/dtr4V
         EyltId6sYZD3pPm7XjPFGJRsC8WMYVDtcUPk+yHp2PH1vwpeg4dZ/F1WsWXv4ivyzVRP
         +aqXFG06VjltiEwlpLmBLJ5Cx+IAukY3lZMaXpqqdXzMustHU13bh2HTv6FE5/cSqsON
         gT/wLTKE3mCt2VnDD3RfIyO4c8ATUDj4x1z+oQXzX20cKs1eNZggVdnmUxPXLF5fFAW/
         gSLA==
X-Gm-Message-State: AAQBX9en05G2E7f1I6HuoKEdW1HKbmedvKZnda0IWMCsQjgbM0YRveTv
        ZYF7qpLFRqjhNQ96kDlS1K3uIw==
X-Google-Smtp-Source: AKy350auufiX01FHWePcT8ozw542dHklxz/Uhcd8ROCySGp1S1QDyMvKleWo9snUSXurnqBAHz+NJQ==
X-Received: by 2002:a62:1d83:0:b0:622:749a:b9df with SMTP id d125-20020a621d83000000b00622749ab9dfmr10893140pfd.3.1679935877360;
        Mon, 27 Mar 2023 09:51:17 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:16 -0700 (PDT)
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
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Zong Li <zong.li@sifive.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v17 14/20] riscv: signal: Report signal frame size to userspace via auxv
Date:   Mon, 27 Mar 2023 16:49:34 +0000
Message-Id: <20230327164941.20491-15-andy.chiu@sifive.com>
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
index 5222ed4eb677..40f740183768 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -22,6 +22,8 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 
+unsigned long signal_minsigstksz __ro_after_init;
+
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
 
@@ -196,7 +198,7 @@ static long restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-static size_t get_rt_frame_size(void)
+static size_t get_rt_frame_size(bool cal_all)
 {
 	struct rt_sigframe __user *frame;
 	size_t frame_size;
@@ -204,8 +206,10 @@ static size_t get_rt_frame_size(void)
 
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
@@ -225,7 +229,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct rt_sigframe __user *frame;
 	struct task_struct *task;
 	sigset_t set;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current->restart_block.fn = do_no_restart_syscall;
@@ -321,7 +325,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
-	size_t frame_size = get_rt_frame_size();
+	size_t frame_size = get_rt_frame_size(false);
 
 	frame = get_sigframe(ksig, regs, frame_size);
 	if (!access_ok(frame, frame_size))
@@ -458,4 +462,10 @@ void __init init_rt_signal_env(void)
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

