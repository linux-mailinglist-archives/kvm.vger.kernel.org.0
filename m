Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7E57D30A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiGUSMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiGUSMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:12:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C63D5B8
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b7-20020a17090a12c700b001f20eb82a08so6017938pjg.3
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KXvEKspdEkxNZ7tN6bENVdCw8YU5lf4YyaP929zXWIY=;
        b=gAC9SImSw7eiWFYiv7v1Khp0JthVLSBW0up/Ins6+n9ilcGxde5YuFWQgF6v9bU307
         OEBZib+YmC6/zpj86fVq3hlM4ImxmLY/qVr6xyDhSh7AwY49KVfUX3HRQCqnTgoZiTYr
         fmt1DE2rlmKNqbW+na3IND1xvTIeMRDJUZzONICYBO0nB3cm+cKOrxfutbcXVH9ZiN8E
         9QDtv8wMD4NKFcQbzJ83R25l4pkYxcjGZOA/zlbQylOixYHxQ5kKo59+FozqoBxboFup
         HfeqkgOSsYjXovkD4Ck6fjJdU/OGU7RqWqJPzNtYlJqsqosdGVpAsugG9asA6OABUc6I
         YARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXvEKspdEkxNZ7tN6bENVdCw8YU5lf4YyaP929zXWIY=;
        b=055ftXYyI4QZ7e67U8ogmTpJq3TpNMF5Dvm8jER5YRRwllYT6N5lhIH+xpn9M785+6
         /tB8biQ1Fmdmjer2WcOyQ+VMU6XrFjAVHuJkpnoSq96Wdjts6IJyaWMmnX+jHfqfFj1K
         Tsr+gVzdGdUs1OE41QHHWcWPyzxFus80OcuW3WGGyZazvNBzW/88tuyAWM9mBEOm8g5Z
         Dx5gEUL+2KIqUxQma4tg9CE608SqyLeb1zzDzsdwh7iB5wCnFYWLHgBntTIwdJYSNt8v
         P4bDgyQCNlJwrgh1DZ2W0lzI+ArXU37bTHzodbO2/YoF/llZudgfj45As98GIBLt6Is2
         dB1A==
X-Gm-Message-State: AJIora9RE9mJOvOzfU0rDAz3wsLwpz8v/unGxF7VNhyLGtz6gnPrA2Vx
        /dAo5ievxmdYSNSc4j/EQgD0fw==
X-Google-Smtp-Source: AGRyM1tktQV5/mZfCAg50Mwii7SI/iChwBuFlDmqdIX4qR5jyqvapwLMydfUVdc+jX0wyuTseqdmqA==
X-Received: by 2002:a17:902:db04:b0:16c:5568:d73e with SMTP id m4-20020a170902db0400b0016c5568d73emr46648329plx.46.1658427148522;
        Thu, 21 Jul 2022 11:12:28 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm617358plm.89.2022.07.21.11.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:12:28 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v6 4/4] RISC-V: KVM: Support sstc extension
Date:   Thu, 21 Jul 2022 11:12:12 -0700
Message-Id: <20220721181212.3705138-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220721181212.3705138-1-atishp@rivosinc.com>
References: <20220721181212.3705138-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sstc extension allows the guest to program the vstimecmp CSR directly
instead of making an SBI call to the hypervisor to program the next
event. The timer interrupt is also directly injected to the guest by
the hardware in this case. To maintain backward compatibility, the
hypervisors also update the vstimecmp in an SBI set_time call if
the hardware supports it. Thus, the older kernels in guest also
take advantage of the sstc extension.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_timer.h |   7 ++
 arch/riscv/include/uapi/asm/kvm.h       |   1 +
 arch/riscv/kvm/vcpu.c                   |   8 +-
 arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
 4 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
index 50138e2eb91b..0d8fdb8ec63a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_timer.h
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -28,6 +28,11 @@ struct kvm_vcpu_timer {
 	u64 next_cycles;
 	/* Underlying hrtimer instance */
 	struct hrtimer hrt;
+
+	/* Flag to check if sstc is enabled or not */
+	bool sstc_enabled;
+	/* A function pointer to switch between stimecmp or hrtimer at runtime */
+	int (*timer_next_event)(struct kvm_vcpu *vcpu, u64 ncycles);
 };
 
 int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
@@ -40,5 +45,7 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
 void kvm_riscv_guest_timer_init(struct kvm *kvm);
+void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 24b2a6e27698..7351417afd62 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -97,6 +97,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_I,
 	KVM_RISCV_ISA_EXT_M,
 	KVM_RISCV_ISA_EXT_SVPBMT,
+	KVM_RISCV_ISA_EXT_SSTC,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 5d271b597613..d0f08d5b4282 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -52,6 +52,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	RISCV_ISA_EXT_i,
 	RISCV_ISA_EXT_m,
 	RISCV_ISA_EXT_SVPBMT,
+	RISCV_ISA_EXT_SSTC,
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -85,6 +86,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_C:
 	case KVM_RISCV_ISA_EXT_I:
 	case KVM_RISCV_ISA_EXT_M:
+	case KVM_RISCV_ISA_EXT_SSTC:
 		return false;
 	default:
 		break;
@@ -203,7 +205,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
+	return kvm_riscv_vcpu_timer_pending(vcpu);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -785,6 +787,8 @@ static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
 	if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SVPBMT))
 		henvcfg |= ENVCFG_PBMTE;
 
+	if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SSTC))
+		henvcfg |= ENVCFG_STCE;
 	csr_write(CSR_HENVCFG, henvcfg);
 #ifdef CONFIG_32BIT
 	csr_write(CSR_HENVCFGH, henvcfg >> 32);
@@ -828,6 +832,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 				     vcpu->arch.isa);
 	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
 
+	kvm_riscv_vcpu_timer_save(vcpu);
+
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
 	csr->vsie = csr_read(CSR_VSIE);
 	csr->vstvec = csr_read(CSR_VSTVEC);
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 595043857049..16f50c46ba39 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -69,7 +69,18 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
 	return 0;
 }
 
-int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+#if defined(CONFIG_32BIT)
+		csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
+		csr_write(CSR_VSTIMECMPH, ncycles >> 32);
+#else
+		csr_write(CSR_VSTIMECMP, ncycles);
+#endif
+		return 0;
+}
+
+static int kvm_riscv_vcpu_update_hrtimer(struct kvm_vcpu *vcpu, u64 ncycles)
 {
 	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
 	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
@@ -88,6 +99,65 @@ int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
 	return 0;
 }
 
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	return t->timer_next_event(vcpu, ncycles);
+}
+
+static enum hrtimer_restart kvm_riscv_vcpu_vstimer_expired(struct hrtimer *h)
+{
+	u64 delta_ns;
+	struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+	if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
+		delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
+		hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
+		return HRTIMER_RESTART;
+	}
+
+	t->next_set = false;
+	kvm_vcpu_kick(vcpu);
+
+	return HRTIMER_NORESTART;
+}
+
+bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+	if (!kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t) ||
+	    kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER))
+		return true;
+	else
+		return false;
+}
+
+static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 delta_ns;
+
+	if (!t->init_done)
+		return;
+
+	delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
+	if (delta_ns) {
+		hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+		t->next_set = true;
+	}
+}
+
+static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
+{
+	kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+}
+
 int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
 				 const struct kvm_one_reg *reg)
 {
@@ -180,10 +250,20 @@ int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
 	t->init_done = true;
 	t->next_set = false;
 
+	/* Enable sstc for every vcpu if available in hardware */
+	if (riscv_isa_extension_available(NULL, SSTC)) {
+		t->sstc_enabled = true;
+		t->hrt.function = kvm_riscv_vcpu_vstimer_expired;
+		t->timer_next_event = kvm_riscv_vcpu_update_vstimecmp;
+	} else {
+		t->sstc_enabled = false;
+		t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
+		t->timer_next_event = kvm_riscv_vcpu_update_hrtimer;
+	}
+
 	return 0;
 }
 
@@ -199,21 +279,73 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu)
 
 int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	t->next_cycles = -1ULL;
 	return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
 }
 
-void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
+static void kvm_riscv_vcpu_update_timedelta(struct kvm_vcpu *vcpu)
 {
 	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
 
-#ifdef CONFIG_64BIT
-	csr_write(CSR_HTIMEDELTA, gt->time_delta);
-#else
+#if defined(CONFIG_32BIT)
 	csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
 	csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
+#else
+	csr_write(CSR_HTIMEDELTA, gt->time_delta);
 #endif
 }
 
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr;
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	kvm_riscv_vcpu_update_timedelta(vcpu);
+
+	if (!t->sstc_enabled)
+		return;
+
+	csr = &vcpu->arch.guest_csr;
+#if defined(CONFIG_32BIT)
+	csr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
+	csr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
+#else
+	csr_write(CSR_VSTIMECMP, t->next_cycles);
+#endif
+
+	/* timer should be enabled for the remaining operations */
+	if (unlikely(!t->init_done))
+		return;
+
+	kvm_riscv_vcpu_timer_unblocking(vcpu);
+}
+
+void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr;
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	if (!t->sstc_enabled)
+		return;
+
+	csr = &vcpu->arch.guest_csr;
+	t = &vcpu->arch.timer;
+#if defined(CONFIG_32BIT)
+	t->next_cycles = csr_read(CSR_VSTIMECMP);
+	t->next_cycles |= (u64)csr_read(CSR_VSTIMECMPH) << 32;
+#else
+	t->next_cycles = csr_read(CSR_VSTIMECMP);
+#endif
+	/* timer should be enabled for the remaining operations */
+	if (unlikely(!t->init_done))
+		return;
+
+	if (kvm_vcpu_is_blocking(vcpu))
+		kvm_riscv_vcpu_timer_blocking(vcpu);
+}
+
 void kvm_riscv_guest_timer_init(struct kvm *kvm)
 {
 	struct kvm_guest_timer *gt = &kvm->arch.timer;
-- 
2.25.1

