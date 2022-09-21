Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973235E556F
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIUVsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiIUVsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:48:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAF6A6C0B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:48:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso159353pjd.4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LT61xLA3xO8Cm0mngS+B9eObitluLVCYOP6BvnQtjLU=;
        b=KTbyz47q38rOvNH4MaSFOrps1Y9zCXQ6Q5/53AoIJm1skkxgugSIuwlert/lAleh50
         KvK8X42g6WNWey323t+KIBlDGBSiX+NAfIP5aAUfONFStURjNCuR33L1g1krNqS8f9KO
         IJp19kSHkgX78HqozbEi+07FKRDe3HS0DEb6wmgKKIJT5hQrnS34T7kP7VwkOZNUq3wg
         NvsuP3vWYb4dbYHcCDkRQ/hZG87FqeSM3JfnpkntZ5bbBEKDYYEqp+9tvRUWY0tQQ7qT
         UtgVhD8d2FYBmISbFP22uUgEi2cTPvHDeSXzFyQpKxIcvqP0GYDLJWQJrK1/1DPv+tHa
         WrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LT61xLA3xO8Cm0mngS+B9eObitluLVCYOP6BvnQtjLU=;
        b=Vphs+mpjng2YcfAKMA9rkrfj+ptL102/E36GKfCo6k0QYyBHOOV0U2pccSGzmoG83R
         X5TYryzNErTcxfK6piSBlhvJdjuo0nV1C69Iherv8oze3082tXTjNMxCp2za+7rBt9mm
         qRGDck+Mpq65x2cLs/6K2w6Sn9AFX5KWhdGEUFB6ybR/V4fS2yG4BKkgEib1R/ntRQBK
         AUH0matWuvoFlu5DqVlnqOj20kuE56vX7AMabGcXSOgkQ1lEiEMaz2YOjLdUW81KVUVh
         L6JbAGuUPVYylgYBl4+XW4hTOUe8ORT7D/aWX2vkgughN9tbFgIjdYNtvmbXAxbX08oK
         z8mA==
X-Gm-Message-State: ACrzQf0Ywvpf5jxTzB32RcKdc3/+O4zMwn3G+ukPAjD3QrwNLdDuJXEI
        E06Llmkvn4nC3IZXnFv94tUbgQ==
X-Google-Smtp-Source: AMsMyM5g1Fe8zKJclCNS+r/j90c9oB56KnFADvTXlJfEuvTn9wcw9ZCKUbfSp58YveUPRAHaiZp9fA==
X-Received: by 2002:a17:902:e383:b0:176:9ee2:e099 with SMTP id g3-20020a170902e38300b001769ee2e099mr270156ple.44.1663796918852;
        Wed, 21 Sep 2022 14:48:38 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:48:38 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Chris Stillson <stillson@rivosinc.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barret Rhoden <brho@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 06/17] riscv: Reset vector register
Date:   Wed, 21 Sep 2022 14:43:48 -0700
Message-Id: <20220921214439.1491510-6-stillson@rivosinc.com>
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

From: Guo Ren <guoren@linux.alibaba.com>

Reset vector registers at boot-time and disable vector instructions
execution for kernel mode.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Co-developed-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Signed-off-by: Han-Kuan Chen <hankuan.chen@sifive.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/kernel/entry.S |  6 +++---
 arch/riscv/kernel/head.S  | 35 +++++++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index b9eda3fcbd6d..1e9987376591 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -77,10 +77,10 @@ _save_context:
 	 * Disable user-mode memory access as it should only be set in the
 	 * actual user copy routines.
 	 *
-	 * Disable the FPU to detect illegal usage of floating point in kernel
-	 * space.
+	 * Disable the FPU/Vector to detect illegal usage of floating point
+	 * or vector in kernel space.
 	 */
-	li t0, SR_SUM | SR_FS
+	li t0, SR_SUM | SR_FS | SR_VS
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index b865046e4dbb..2c81ca42ec4e 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -140,10 +140,10 @@ secondary_start_sbi:
 	.option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS | SR_VS
 	csrc CSR_STATUS, t0
 
 	/* Set trap vector to spin forever to help debug */
@@ -234,10 +234,10 @@ pmp_done:
 .option pop
 
 	/*
-	 * Disable FPU to detect illegal usage of
-	 * floating point in kernel space
+	 * Disable FPU & VECTOR to detect illegal usage of
+	 * floating point or vector in kernel space
 	 */
-	li t0, SR_FS
+	li t0, SR_FS | SR_VS
 	csrc CSR_STATUS, t0
 
 #ifdef CONFIG_RISCV_BOOT_SPINWAIT
@@ -431,6 +431,29 @@ ENTRY(reset_regs)
 	csrw	fcsr, 0
 	/* note that the caller must clear SR_FS */
 #endif /* CONFIG_FPU */
+
+#ifdef CONFIG_VECTOR
+	csrr	t0, CSR_MISA
+	li	t1, COMPAT_HWCAP_ISA_V
+	and	t0, t0, t1
+	beqz	t0, .Lreset_regs_done
+
+	/*
+	 * Clear vector registers and reset vcsr
+	 * VLMAX has a defined value, VLEN is a constant,
+	 * and this form of vsetvli is defined to set vl to VLMAX.
+	 */
+	li	t1, SR_VS
+	csrs	CSR_STATUS, t1
+	csrs	CSR_VCSR, x0
+	vsetvli t1, x0, e8, m8, ta, ma
+	vmv.v.i v0, 0
+	vmv.v.i v8, 0
+	vmv.v.i v16, 0
+	vmv.v.i v24, 0
+	/* note that the caller must clear SR_VS */
+#endif /* CONFIG_VECTOR */
+
 .Lreset_regs_done:
 	ret
 END(reset_regs)
-- 
2.25.1

