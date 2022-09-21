Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2745E5571
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIUVtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIUVtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:49:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7EFA6C0B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:49:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso156112pjm.5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=BvXu+QXgzcKTzY7GQZ6McuBPlZWnkV19grD1UPI3mnI=;
        b=2Zivm6A/Q9fjuFhqOz4aFrJ4mttfj+vMvGL/use9tWtM+iU/jGsErSU8dXfCdtWfor
         IUvGbh/ffs6oX/xp2q/MZQ70jVl31CD2HJY3vZAnoiuaQKaxYLcGlpLizNhlN8f3zwjY
         1TT2Rm3DicHIEsCYrDfskgMjR5Ir0ddmdvotGyZ058jsMvazNk6LjNTJOypDRvMi2MCX
         St1FRq+x9do7SRC9girM6Wh4WIG2Tiv/LfyNa/kuAAg6xYIgD70dJNhJuPErOImfOdfd
         5KrMTF84K1GmVIndglT2dW+pgBlozWo6kiFuI7G9rXOLRxDc21UPLEGZlNQP0FEwJWpf
         qHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=BvXu+QXgzcKTzY7GQZ6McuBPlZWnkV19grD1UPI3mnI=;
        b=qdbmjedzW1twg34DEl/bOZkVyXbyswaTsO6RDU83vke0mY0lNLX40AKp9A2Wmq8rlI
         S2lg/N3g8gmnENC/ZDxjKBww4BhizGiJrJneycDuM0HCacxm0WnqmTXYZcEoiFkIG3Yk
         76IyCbBAzVg6v1wK3pAn+D9t0ZaeMcJgwdEElNIVvlCe+qhM6M1tWKM0OHLG4hbgysQd
         ZhhvZiAWR3DjG73gTxK0JIITq3wM+eMGahVgs2tKoI8GmD3TV7hBKEzA3leeHZ15b3ZI
         zNKLzDQKieyTIkU3CDP+T53ZMEySsvPBhAxNeukkNFUIFU4xL0upFiAJDfygRl2lKilQ
         6K2A==
X-Gm-Message-State: ACrzQf2+zao5JmlR54rLWPWQqpYQHD4k00IChFVENhF1koOdEcGQWrA2
        mDyYNAu78aLIDXqWAjHELCEaCw==
X-Google-Smtp-Source: AMsMyM76gPT3cfpKVZvjavadgnI5fLw75ySqJIfPm57aR3zJCEDVVRM7IcxWkxdKu0/g+KF3ivDAbA==
X-Received: by 2002:a17:903:2346:b0:178:4c17:eef7 with SMTP id c6-20020a170903234600b001784c17eef7mr129194plh.30.1663796960633;
        Wed, 21 Sep 2022 14:49:20 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:49:20 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Greentime Hu <greentime.hu@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>, Guo Ren <guoren@kernel.org>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Chris Stillson <stillson@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>, Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Changbin Du <changbin.du@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Nick Knight <nick.knight@sifive.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@google.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Peter Collingbourne <pcc@google.com>,
        Barret Rhoden <brho@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 07/17] riscv: Add vector struct and assembler definitions
Date:   Wed, 21 Sep 2022 14:43:49 -0700
Message-Id: <20220921214439.1491510-7-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

Add vector state context struct in struct thread and asm-offsets.c
definitions.

The vector registers will be saved in datap pointer of __riscv_v_state. It
will be dynamically allocated in kernel space. It will be put right after
the __riscv_v_state data structure in user space.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
---
 arch/riscv/include/asm/processor.h   |  1 +
 arch/riscv/include/uapi/asm/ptrace.h | 17 +++++++++++++++++
 arch/riscv/kernel/asm-offsets.c      |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
index 19eedd4af4cd..95917a2b24f9 100644
--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -39,6 +39,7 @@ struct thread_struct {
 	unsigned long s[12];	/* s[0]: frame pointer */
 	struct __riscv_d_ext_state fstate;
 	unsigned long bad_cause;
+	struct __riscv_v_state vstate;
 };
 
 /* Whitelist the fstate from the task_struct for hardened usercopy */
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
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index df9444397908..37e3e6a8d877 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -75,6 +75,12 @@ void asm_offsets(void)
 	OFFSET(TSK_STACK_CANARY, task_struct, stack_canary);
 #endif
 
+	OFFSET(RISCV_V_STATE_VSTART, __riscv_v_state, vstart);
+	OFFSET(RISCV_V_STATE_VL, __riscv_v_state, vl);
+	OFFSET(RISCV_V_STATE_VTYPE, __riscv_v_state, vtype);
+	OFFSET(RISCV_V_STATE_VCSR, __riscv_v_state, vcsr);
+	OFFSET(RISCV_V_STATE_DATAP, __riscv_v_state, datap);
+
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 	OFFSET(PT_EPC, pt_regs, epc);
 	OFFSET(PT_RA, pt_regs, ra);
-- 
2.25.1

