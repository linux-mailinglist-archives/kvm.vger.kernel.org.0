Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DE57BE63
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiGTTYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiGTTYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:24:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D4F5C35B
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h132so17257691pgc.10
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fTAbWuxZ1cWXUJfkajtQbPJ+HXs61ab3nj6DcDSwFWU=;
        b=IV3/PZNg+qi/8e59k9/5z7chV+ibXhH/t07gp2TmbWS70uZ/UIm+glSWNAds7viBDV
         BbuSgwE3D/KzVjQ46d2kuqsQdXNS5mhGzx4Jf6PKZlH1wM6LaMm9WC1/tMrMO/KohQAs
         +21s67C1rJBX54YX9oiRW0gZeNhxDhw3MHjeL6ku5e3JUbUTcc2M4iWuI9fQfYysI+ed
         l34TiEAKxxPi0fHTeubUcatHLGVCdvqNJofnconQxbPnjnf/aJExr7/dyF/7iQa/D8tP
         +s5t7GIRsahrGK2BKXikB7UxNbbEZSW0OHevedaKRdHfu9WLJRjqUtW5qGdZg0SW6F6/
         kEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fTAbWuxZ1cWXUJfkajtQbPJ+HXs61ab3nj6DcDSwFWU=;
        b=PDm7BeOd5awZtyDPjueR1nCv4aFvYr7C5kWAg85AWMcm/JTbTcs6CIVCEo98NP2pah
         SfXhbEhehE8+Hgb60rvGDAtpUF367OqEIwc0q4Ogm2nw0z4qW/69koWW1U/S2TSE73N1
         gWKk8FUfSnhtGeUr+0xw3FcHM+1bqs+7sVHyT9gS/ZXnFuI9Y3FXv4sYinMuuWg1zTPD
         ntyhCEgCVRZM5i3PrP3QdF7/Kcmpnq6uF/Xa0nLvKj5YCCyAM93TPjqhmtolAd3hUiZb
         y17Fv0VKLs6I5vVldcqUyCJn+qqbAgdotyl+QyIn65xJqXKMxwqE5CrBHRJ/N1rsOJHD
         Jl9g==
X-Gm-Message-State: AJIora8O7BLldHtNqll45BhWfPN5lLwQs6I2uRDfZxeJdHrHoIm08PGm
        g/SnIGKkWR4ex0TD2VHKG7Y0Og==
X-Google-Smtp-Source: AGRyM1tZP9Z33bqGQEWIHTG87crikA6vd8J5O1EWb3nr5VDqy+RDZzFzm+it7izONv49wXRkTHaRGg==
X-Received: by 2002:a05:6a00:124b:b0:52a:c7de:c76 with SMTP id u11-20020a056a00124b00b0052ac7de0c76mr40836675pfi.5.1658345037474;
        Wed, 20 Jul 2022 12:23:57 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b0016d2e772550sm219902pli.175.2022.07.20.12.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 12:23:57 -0700 (PDT)
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
        Liu Shaohua <liush@allwinnertech.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v5 4/4] RISC-V: KVM: Support sstc extension
Date:   Wed, 20 Jul 2022 12:23:42 -0700
Message-Id: <20220720192342.3428144-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720192342.3428144-1-atishp@rivosinc.com>
References: <20220720192342.3428144-1-atishp@rivosinc.com>
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
 arch/riscv/kvm/vcpu.c                   |   7 +-
 arch/riscv/kvm/vcpu_timer.c             | 144 +++++++++++++++++++++++-
 4 files changed, 152 insertions(+), 7 deletions(-)

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
index 24b2a6e27698..9ac3dbaf0b0f 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -96,6 +96,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_H,
 	KVM_RISCV_ISA_EXT_I,
 	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_SSTC,
 	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_MAX,
 };
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 5d271b597613..9ee6ad376eb2 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -51,6 +51,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	RISCV_ISA_EXT_h,
 	RISCV_ISA_EXT_i,
 	RISCV_ISA_EXT_m,
+	RISCV_ISA_EXT_SSTC,
 	RISCV_ISA_EXT_SVPBMT,
 };
 
@@ -203,7 +204,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
+	return kvm_riscv_vcpu_timer_pending(vcpu);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -785,6 +786,8 @@ static void kvm_riscv_vcpu_update_config(const unsigned long *isa)
 	if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SVPBMT))
 		henvcfg |= ENVCFG_PBMTE;
 
+	if (__riscv_isa_extension_available(isa, RISCV_ISA_EXT_SSTC))
+		henvcfg |= ENVCFG_STCE;
 	csr_write(CSR_HENVCFG, henvcfg);
 #ifdef CONFIG_32BIT
 	csr_write(CSR_HENVCFGH, henvcfg >> 32);
@@ -828,6 +831,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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

