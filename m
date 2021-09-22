Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D53413EDF
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhIVBKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhIVBK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:10:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BA0C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 18:09:00 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e5-20020ac84905000000b002a69dc43859so5729770qtq.10
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 18:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f+eE05PCo8qChOi7C3TCse89XUY8p/e5JYZmdwEBrZo=;
        b=dJPqGgERbK013/94/AiM4dAyiKix1/DKn7frupuhal/2UEb+36tkSAU2QR5HuvuUrP
         I5lfIfz9mix3ljONjQSJPZsqUxztzw7TWpmga75sAbCpjGjAK5UHn8GmdunRx04JBBEa
         OSPrE6uEN4QUVW+aVCib2A81IVnBp5IFyxqGxm6PvXA4MAE2YJQNDMR3/msn9XXHFFW6
         9X8ORVIypjoWIBFobLZl9reRnKzG6nKCZzWycg2LhY+60z/e3pfcSmkqhxYxDAaDxsvp
         2eiyr+v4RXb88q/WrE74qS+8EHkrtgmikQdbp6ikP1p8w2pEsPV13MN/vtenr9P9f0qK
         EdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f+eE05PCo8qChOi7C3TCse89XUY8p/e5JYZmdwEBrZo=;
        b=SeFn+ko931h35liS0ywB6x9yOYN263eO2sKn8p/Ae+tj45sj8FBKbh/StQHKGyoWfu
         dccUp96jDZgUpGV2YcfmTWAI7ESEeWHferlUi3BNdCNKbTtFKRVxkWI3O3N6k7hcpi4A
         xQLelHMGVRRMeBv0DMAdBDsLTzpB60Z7xSwh12g0SLIBKclFOTBMCyhd0MRaMegHwx/8
         Q7+M4Au1PZwt0dj7T0wM3OB7TiHKsSbyE6uwZVXEsj4scTLkCULQCFyHGaDdBFK1cjIH
         BDQ0DGcfJj0sKe9tQvKA5Dfj294mALwU46A8PXchYXRZzDfEDKEMp0UZFiNc0RGYOX5b
         TzEg==
X-Gm-Message-State: AOAM531O0bgtUGPv/jt5naXqLnGfa3Y5dmBfjiWzI9cF//kxqiDGNfl5
        CoMnXajj8ErOjc3PzKJvlpRGxZcpkc4ozQXmJhwHTqbkdZOH3pLCPxIFVEDwqW3tMIF1KjPemse
        s0oJNQNp2xMpmiDQ9vSgQuv2s+pb2BVI3ptUdKwp9W4Erzsgqmc7X9GRHL6bB0Xz9SWwVipw=
X-Google-Smtp-Source: ABdhPJy3KpjeASdvmJujfjGe+YN1WNhBl+SU4AAgG4BY/Um41MpzopZrZLsD49XgUs0vHx6qrAvH2+FIjjqSM5Xoxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a0c:e381:: with SMTP id
 a1mr29432178qvl.42.1632272939620; Tue, 21 Sep 2021 18:08:59 -0700 (PDT)
Date:   Wed, 22 Sep 2021 01:08:51 +0000
In-Reply-To: <20210922010851.2312845-1-jingzhangos@google.com>
Message-Id: <20210922010851.2312845-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time of
 arch specific exit reasons
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These logarithmic histogram stats are useful for monitoring performance
of handling for different kinds of VCPU exit reasons.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 36 ++++++++++++
 arch/arm64/kvm/arm.c              |  4 ++
 arch/arm64/kvm/guest.c            | 43 ++++++++++++++
 arch/arm64/kvm/handle_exit.c      | 95 +++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d65de22add3..f1a29ca3d4f3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -417,6 +417,9 @@ struct kvm_vcpu_arch {
 
 	/* Arch specific exit reason */
 	enum arm_exit_reason exit_reason;
+
+	/* The timestamp for the last VCPU exit */
+	u64 last_exit_time;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -605,6 +608,8 @@ struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
 
+#define ARM_EXIT_HIST_CNT	64
+
 struct kvm_vcpu_stat {
 	struct kvm_vcpu_stat_generic generic;
 	u64 mmio_exit_user;
@@ -641,6 +646,36 @@ struct kvm_vcpu_stat {
 		u64 exit_fp_asimd;
 		u64 exit_pac;
 	};
+	/* Histogram stats for handling time of arch specific exit reasons */
+	struct {
+		u64 exit_unknown_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_irq_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_el1_serror_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hyp_gone_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_il_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_wfi_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_wfe_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp15_32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp15_64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_ls_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_cp14_64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hvc32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_smc32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_hvc64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_smc64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_sys64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_sve_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_iabt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_dabt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_softstp_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_watchpt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_breakpt_low_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_bkpt32_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_brk64_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_fp_asimd_hist[ARM_EXIT_HIST_CNT];
+		u64 exit_pac_hist[ARM_EXIT_HIST_CNT];
+	};
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
@@ -715,6 +750,7 @@ void force_vm_exit(const cpumask_t *mask);
 
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
+void update_hist_exit_stats(struct kvm_vcpu *vcpu);
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..156f80b699d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -795,6 +795,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		/* Update histogram stats for exit reasons */
+		update_hist_exit_stats(vcpu);
+
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -903,6 +906,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		guest_exit();
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index abd9327d7110..bbf51578fdec 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -75,6 +75,49 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, exit_brk64),
 	STATS_DESC_COUNTER(VCPU, exit_fp_asimd),
 	STATS_DESC_COUNTER(VCPU, exit_pac),
+	/* Histogram stats for handling time of arch specific exit reasons */
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_unknown_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_irq_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_el1_serror_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_hyp_gone_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_il_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_wfi_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_wfe_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp15_32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp15_64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_ls_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_cp14_64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_hvc32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_smc32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_hvc64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_smc64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_sys64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_sve_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_iabt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_dabt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_softstp_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_watchpt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_breakpt_low_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_bkpt32_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_brk64_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(
+			VCPU, exit_fp_asimd_hist, ARM_EXIT_HIST_CNT),
+	STATS_DESC_LOGHIST_TIME_NSEC(VCPU, exit_pac_hist, ARM_EXIT_HIST_CNT),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e83cd52078b2..5e642a6275c1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,3 +395,98 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
 	      spsr, elr_virt, esr, far, hpfar, par, vcpu);
 }
+
+void update_hist_exit_stats(struct kvm_vcpu *vcpu)
+{
+	u64 val = ktime_to_ns(ktime_get()) - vcpu->arch.last_exit_time;
+
+	if (unlikely(!vcpu->arch.last_exit_time))
+		return;
+
+	switch (vcpu->arch.exit_reason) {
+	case ARM_EXIT_UNKNOWN:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_unknown_hist, val);
+		break;
+	case ARM_EXIT_IRQ:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_irq_hist, val);
+		break;
+	case ARM_EXIT_EL1_SERROR:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_el1_serror_hist, val);
+		break;
+	case ARM_EXIT_HYP_GONE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hyp_gone_hist, val);
+		break;
+	case ARM_EXIT_IL:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_il_hist, val);
+		break;
+	case ARM_EXIT_WFI:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_wfi_hist, val);
+		break;
+	case ARM_EXIT_WFE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_wfe_hist, val);
+		break;
+	case ARM_EXIT_CP15_32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp15_32_hist, val);
+		break;
+	case ARM_EXIT_CP15_64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp15_64_hist, val);
+		break;
+	case ARM_EXIT_CP14_32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_32_hist, val);
+		break;
+	case ARM_EXIT_CP14_LS:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_ls_hist, val);
+		break;
+	case ARM_EXIT_CP14_64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_cp14_64_hist, val);
+		break;
+	case ARM_EXIT_HVC32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hvc32_hist, val);
+		break;
+	case ARM_EXIT_SMC32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_smc32_hist, val);
+		break;
+	case ARM_EXIT_HVC64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_hvc64_hist, val);
+		break;
+	case ARM_EXIT_SMC64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_smc64_hist, val);
+		break;
+	case ARM_EXIT_SYS64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_sys64_hist, val);
+		break;
+	case ARM_EXIT_SVE:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_sve_hist, val);
+		break;
+	case ARM_EXIT_IABT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_iabt_low_hist, val);
+		break;
+	case ARM_EXIT_DABT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_dabt_low_hist, val);
+		break;
+	case ARM_EXIT_SOFTSTP_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_softstp_low_hist, val);
+		break;
+	case ARM_EXIT_WATCHPT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_watchpt_low_hist, val);
+		break;
+	case ARM_EXIT_BREAKPT_LOW:
+		KVM_STATS_LOG_HIST_UPDATE(
+				vcpu->stat.exit_breakpt_low_hist, val);
+		break;
+	case ARM_EXIT_BKPT32:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_bkpt32_hist, val);
+		break;
+	case ARM_EXIT_BRK64:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_brk64_hist, val);
+		break;
+	case ARM_EXIT_FP_ASIMD:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_fp_asimd_hist, val);
+		break;
+	case ARM_EXIT_PAC:
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.exit_pac_hist, val);
+		break;
+	}
+}
-- 
2.33.0.464.g1972c5931b-goog

