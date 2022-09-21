Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9085E5593
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIUVwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiIUVwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:52:10 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9EA7210
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:52:08 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c198so7288038pfc.13
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pVu+lnUdwFy/wDRUvSag5pYFGjTAxbn9RAYMOsiPMes=;
        b=8CHGaUK43VPwaGKy6s0v+4rvx8e033MGQ0SVpV4G3yEDK9Rayoa+OmMR4d3cZNv0Js
         Ry462tUhf7bod6gBC3mSi/AUOCOl6zUlehF2vJXCAtdQi6W2KDSXX9z22wuPhEdIwNht
         WBuojWsf+k2PdKRXrDU9uVPMlm91kPVKyFk1ZlLtkFTpoG3Zos969R++Fn2IuIdMoIHt
         75KzcQgVLxsbvb3L2eSWfk239Zf6ZvguwHSCj+j8ILd0De26lg0d82tGdpmMwh2PJsoR
         59S5RANER+k798B0zKzQVrxtcWj7uJGh4Sj5mmLrux2BdcAG7TelJKVJf3pHMggnY2lR
         m1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pVu+lnUdwFy/wDRUvSag5pYFGjTAxbn9RAYMOsiPMes=;
        b=smXoUnJSLKyh3KexAeECHbTao6wjjCHdVVnAPdo3rWC4K2bp3n2TPKBx9zJ77Zxcs1
         5kBj5l9zmyJXnE910NQXmaZM3h+Eief74PIrUNj2j3GXKBPryCnt+u7/Md4kqTBxJOpM
         EkWHr/4Y2EybkZ/eE+BzPtEUKYNaG+fjlTYVup1DC8vFmBoKunHFCwdjM8cVzoXH3iZJ
         VW8miQ8ANZTf7mHidGNm4K+5hBnwL8LyezpuSiHouuDJmmN7Ol+caHm3+BklHM3TwFVH
         v0QtS8adp+VvC0AudI27bVIIS7vsWEuttsAJbsdS1dF5xp2laiHU44zvJj1tksiJYsKY
         HAMA==
X-Gm-Message-State: ACrzQf0qdSN7UfMIG4aeUf9NHzWqFP6SDeEBN5r8+nb+pSETiBUJVLbl
        126xPlkdHCDi0maA0Kh5fXSAYA==
X-Google-Smtp-Source: AMsMyM6FMnAlPzLX6rQkFOPQ7u/0N7HhlBrs8TUoKv04qZnD51TCGGWzU6DRjlPULYMOq1ht5Z7b9w==
X-Received: by 2002:a63:85c3:0:b0:43a:4c05:c313 with SMTP id u186-20020a6385c3000000b0043a4c05c313mr242802pgd.418.1663797128343;
        Wed, 21 Sep 2022 14:52:08 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:52:07 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>, Guo Ren <guoren@kernel.org>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Chris Stillson <stillson@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>, Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Barret Rhoden <brho@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 11/17] riscv: signal: Report signal frame size to userspace via auxv
Date:   Wed, 21 Sep 2022 14:43:53 -0700
Message-Id: <20220921214439.1491510-11-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
---
 arch/riscv/include/asm/elf.h         | 47 +++++++++++++++-------------
 arch/riscv/include/asm/processor.h   |  2 ++
 arch/riscv/include/uapi/asm/auxvec.h |  1 +
 arch/riscv/kernel/signal.c           |  8 +++++
 4 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
index 14fc7342490b..df9047b619e8 100644
--- a/arch/riscv/include/asm/elf.h
+++ b/arch/riscv/include/asm/elf.h
@@ -77,28 +77,31 @@ extern unsigned long elf_hwcap;
 #define COMPAT_ELF_PLATFORM	(NULL)
 
 #ifdef CONFIG_MMU
-#define ARCH_DLINFO						\
-do {								\
-	/*							\
-	 * Note that we add ulong after elf_addr_t because	\
-	 * casting current->mm->context.vdso triggers a cast	\
-	 * warning of cast from pointer to integer for		\
-	 * COMPAT ELFCLASS32.					\
-	 */							\
-	NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
-		(elf_addr_t)(ulong)current->mm->context.vdso);	\
-	NEW_AUX_ENT(AT_L1I_CACHESIZE,				\
-		get_cache_size(1, CACHE_TYPE_INST));		\
-	NEW_AUX_ENT(AT_L1I_CACHEGEOMETRY,			\
-		get_cache_geometry(1, CACHE_TYPE_INST));	\
-	NEW_AUX_ENT(AT_L1D_CACHESIZE,				\
-		get_cache_size(1, CACHE_TYPE_DATA));		\
-	NEW_AUX_ENT(AT_L1D_CACHEGEOMETRY,			\
-		get_cache_geometry(1, CACHE_TYPE_DATA));	\
-	NEW_AUX_ENT(AT_L2_CACHESIZE,				\
-		get_cache_size(2, CACHE_TYPE_UNIFIED));		\
-	NEW_AUX_ENT(AT_L2_CACHEGEOMETRY,			\
-		get_cache_geometry(2, CACHE_TYPE_UNIFIED));	\
+#define ARCH_DLINFO						 \
+do {								 \
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,				 \
+		(elf_addr_t)current->mm->context.vdso);		 \
+	NEW_AUX_ENT(AT_L1I_CACHESIZE,				 \
+		get_cache_size(1, CACHE_TYPE_INST));		 \
+	NEW_AUX_ENT(AT_L1I_CACHEGEOMETRY,			 \
+		get_cache_geometry(1, CACHE_TYPE_INST));	 \
+	NEW_AUX_ENT(AT_L1D_CACHESIZE,				 \
+		get_cache_size(1, CACHE_TYPE_DATA));		 \
+	NEW_AUX_ENT(AT_L1D_CACHEGEOMETRY,			 \
+		get_cache_geometry(1, CACHE_TYPE_DATA));	 \
+	NEW_AUX_ENT(AT_L2_CACHESIZE,				 \
+		get_cache_size(2, CACHE_TYPE_UNIFIED));		 \
+	NEW_AUX_ENT(AT_L2_CACHEGEOMETRY,			 \
+		get_cache_geometry(2, CACHE_TYPE_UNIFIED));	 \
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
index 95917a2b24f9..a09141ecf6aa 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -7,6 +7,7 @@
 #define _ASM_RISCV_PROCESSOR_H
 
 #include <linux/const.h>
+#include <linux/cache.h>
 
 #include <vdso/processor.h>
 
@@ -86,6 +87,7 @@ int riscv_of_parent_hartid(struct device_node *node, unsigned long *hartid);
 extern void riscv_fill_hwcap(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 
+extern unsigned long signal_minsigstksz __ro_after_init;
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PROCESSOR_H */
diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index 32c73ba1d531..6610d24e6662 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -33,5 +33,6 @@
 
 /* entries in ARCH_DLINFO */
 #define AT_VECTOR_SIZE_ARCH	7
+#define AT_MINSIGSTKSZ 51
 
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 41d9a02c7098..fb1f5012416e 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -478,8 +478,16 @@ asmlinkage __visible void do_notify_resume(struct pt_regs *regs,
 		resume_user_mode_work(regs);
 }
 
+unsigned long __ro_after_init signal_minsigstksz;
+
 void init_rt_signal_env(void);
 void __init init_rt_signal_env(void)
 {
 	rvv_sc_size = sizeof(struct __sc_riscv_v_state) + riscv_vsize;
+	/*
+	 * Determine the stack space required for guaranteed signal delivery.
+	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
+	 * in the auxiliary array at process startup.
+	 */
+	signal_minsigstksz = cal_rt_frame_size();
 }
-- 
2.25.1

