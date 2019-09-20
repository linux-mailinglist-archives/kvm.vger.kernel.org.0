Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7354EB8B08
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 08:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394873AbfITG1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 02:27:35 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:55008 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393085AbfITG1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 02:27:35 -0400
Received: by mail-ua1-f74.google.com with SMTP id t16so1208684uae.21
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 23:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tCwobJ4sibSbRL27xRdckc8ojKP82LRYHZd+OSAZkFc=;
        b=NwItX0CDO8BWB79lwMnI/3DOOTIfkoSTBe9lNRVdjukKaRivMeIvDHkWK6yp5k8u63
         hEB341B4VTKGuk0Lvr27YGvMrtomaF+Hyrf1GkLEAbTbLOqrmZJ2DoKmskO2dalXC4LO
         VkvtJWhOvXAdrCPnilFMiGLU5d8z2c/EzKx73QIgZIZCj6ho3L2rns7kqDWcEOpZJ0S3
         I2rlk0NbDpwaXmpFVRfwpgPU9+6z/1Ikt+w1M0dnORZdINjQ7hJeksL1pHqC4JTK+93p
         MV6qrub4k3YpL665sq4WiT9lRI+/WzmAJNb0yculC6qO9xyPgphDfaa9D0uXUvuABYSU
         hb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tCwobJ4sibSbRL27xRdckc8ojKP82LRYHZd+OSAZkFc=;
        b=YlGoO5ls7Wx81FZLhyIbpXwIsFVvDQ17tdLVK+GTHarSuyjS0xnK2gmZTZGLcgS0hg
         HeGT1gy5bmSHK+oPQ8XQaARsOVVf04yXJ+DZ9jTV/dWcKsk3IVGHCStVDmZOxPoPx4t+
         hNU5fEfP38L4c9etEcgPy55DpPSwTBuidXdBVSaGTvQkdVpq1psfSToxCbjEuHLiwGKB
         8FrDb0HNK3X7FNL1+9LkwiYtjzTO1iKVnx3rl6j3Kc+oXyEG6res/+3eleSsGzKPXY2e
         8TdBtddGismmeVayEl7txIZMuteoUpCO4P3d2aa5Z2NrqoOVgGU/IPK79pObzHUuO4JX
         dVSQ==
X-Gm-Message-State: APjAAAVn8gz95SnyOZA4gAeIL+qACye/OTuiSY7VD23W94M9R6oMRpde
        CkeQDII0OxhSB+VBvI6ds9r56LSo+bAs+g==
X-Google-Smtp-Source: APXvYqwkpI1UTuytyD+va/BNDVesQIbTDdeVsObF4jwY61WcWFOHCDgl8oIjbxKI5sjw4aUWlO8ab6fCNgQ4rA==
X-Received: by 2002:ab0:5ac6:: with SMTP id x6mr8614021uae.7.1568960852015;
 Thu, 19 Sep 2019 23:27:32 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:27:12 +0900
In-Reply-To: <20190920062713.78503-1-suleiman@google.com>
Message-Id: <20190920062713.78503-2-suleiman@google.com>
Mime-Version: 1.0
References: <20190920062713.78503-1-suleiman@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [RFC 1/2] kvm: Mechanism to copy host timekeeping parameters into guest.
From:   Suleiman Souhlal <suleiman@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used to synchronize time between host and guest.
The guest can request the (guest) physical address it wants the
data in through the MSR_KVM_TIMEKEEPER_EN MSR.

We maintain a shadow copy of the timekeeper that gets updated
whenever the timekeeper gets updated, and then copied into the
guest.

It currently assumes the host timekeeper is "tsc".

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h      |   3 +
 arch/x86/include/asm/pvclock-abi.h   |  27 ++++++
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kvm/x86.c                   | 121 +++++++++++++++++++++++++++
 4 files changed, 152 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bdc16b0aa7c6..b1b4c3a80b8d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -666,7 +666,10 @@ struct kvm_vcpu_arch {
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned int hw_tsc_khz;
 	struct gfn_to_hva_cache pv_time;
+	struct gfn_to_hva_cache pv_timekeeper_g2h;
+	struct pvclock_timekeeper pv_timekeeper;
 	bool pv_time_enabled;
+	bool pv_timekeeper_enabled;
 	/* set guest stopped flag in pvclock flags field */
 	bool pvclock_set_guest_stopped_request;
 
diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
index 1436226efe3e..2809008b9b26 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -40,6 +40,33 @@ struct pvclock_wall_clock {
 	u32   nsec;
 } __attribute__((__packed__));
 
+struct pvclock_read_base {
+	u64 mask;
+	u64 cycle_last;
+	u32 mult;
+	u32 shift;
+	u64 xtime_nsec;
+	u64 base;
+} __attribute__((__packed__));
+
+struct pvclock_timekeeper {
+	u64 gen;
+	u64 flags;
+	struct pvclock_read_base tkr_mono;
+	struct pvclock_read_base tkr_raw;
+	u64 xtime_sec;
+	u64 ktime_sec;
+	u64 wall_to_monotonic_sec;
+	u64 wall_to_monotonic_nsec;
+	u64 offs_real;
+	u64 offs_boot;
+	u64 offs_tai;
+	u64 raw_sec;
+	u64 tsc_offset;
+} __attribute__((__packed__));
+
+#define	PVCLOCK_TIMEKEEPER_ENABLED (1 << 0)
+
 #define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
 #define PVCLOCK_GUEST_STOPPED	(1 << 1)
 /* PVCLOCK_COUNTS_FROM_ZERO broke ABI and can't be used anymore. */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..3ebb1d87db3a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -50,6 +50,7 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_TIMEKEEPER_EN	0x4b564d06
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91602d310a3f..06a940a74005 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -157,6 +157,8 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+static atomic_t pv_timekeepers_nr;
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -2621,6 +2623,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		break;
 	}
+	case MSR_KVM_TIMEKEEPER_EN:
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		    &vcpu->arch.pv_timekeeper_g2h, data,
+		    sizeof(struct pvclock_timekeeper)))
+			vcpu->arch.pv_timekeeper_enabled = false;
+		else {
+			vcpu->arch.pv_timekeeper_enabled = true;
+			atomic_inc(&pv_timekeepers_nr);
+		}
+		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
@@ -6965,6 +6977,109 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
 };
 
+static DEFINE_SPINLOCK(shadow_pvtk_lock);
+static struct pvclock_timekeeper shadow_pvtk;
+
+static void
+pvclock_copy_read_base(struct pvclock_read_base *pvtkr,
+    struct tk_read_base *tkr)
+{
+	pvtkr->cycle_last = tkr->cycle_last;
+	pvtkr->mult = tkr->mult;
+	pvtkr->shift = tkr->shift;
+	pvtkr->mask = tkr->mask;
+	pvtkr->xtime_nsec = tkr->xtime_nsec;
+	pvtkr->base = tkr->base;
+}
+
+static void
+kvm_copy_into_pvtk(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_timekeeper *pvtk;
+	unsigned long flags;
+
+	if (!vcpu->arch.pv_timekeeper_enabled)
+		return;
+
+	pvtk = &vcpu->arch.pv_timekeeper;
+	if (pvclock_gtod_data.clock.vclock_mode == VCLOCK_TSC) {
+		pvtk->flags |= PVCLOCK_TIMEKEEPER_ENABLED;
+		spin_lock_irqsave(&shadow_pvtk_lock, flags);
+		pvtk->tkr_mono = shadow_pvtk.tkr_mono;
+		pvtk->tkr_raw = shadow_pvtk.tkr_raw;
+
+		pvtk->xtime_sec = shadow_pvtk.xtime_sec;
+		pvtk->ktime_sec = shadow_pvtk.ktime_sec;
+		pvtk->wall_to_monotonic_sec =
+		    shadow_pvtk.wall_to_monotonic_sec;
+		pvtk->wall_to_monotonic_nsec =
+		    shadow_pvtk.wall_to_monotonic_nsec;
+		pvtk->offs_real = shadow_pvtk.offs_real;
+		pvtk->offs_boot = shadow_pvtk.offs_boot;
+		pvtk->offs_tai = shadow_pvtk.offs_tai;
+		pvtk->raw_sec = shadow_pvtk.raw_sec;
+		spin_unlock_irqrestore(&shadow_pvtk_lock, flags);
+
+		pvtk->tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
+	} else
+		pvtk->flags &= ~PVCLOCK_TIMEKEEPER_ENABLED;
+
+	BUILD_BUG_ON(offsetof(struct pvclock_timekeeper, gen) != 0);
+
+	/*
+	 * Make the gen count odd to indicate we are in the process of
+	 * updating.
+	 */
+	vcpu->arch.pv_timekeeper.gen++;
+	vcpu->arch.pv_timekeeper.gen |= 1;
+
+	/*
+	 * See comment in kvm_guest_time_update() for why we have to do
+	 * multiple writes.
+	 */
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
+	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper.gen));
+
+	smp_wmb();
+
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
+	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper));
+
+	smp_wmb();
+
+	vcpu->arch.pv_timekeeper.gen++;
+
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
+	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper.gen));
+}
+
+static void
+update_shadow_pvtk(struct timekeeper *tk)
+{
+	struct pvclock_timekeeper *pvtk;
+	unsigned long flags;
+
+	pvtk = &shadow_pvtk;
+
+	if (atomic_read(&pv_timekeepers_nr) == 0 ||
+	    pvclock_gtod_data.clock.vclock_mode != VCLOCK_TSC)
+		return;
+
+	spin_lock_irqsave(&shadow_pvtk_lock, flags);
+	pvclock_copy_read_base(&pvtk->tkr_mono, &tk->tkr_mono);
+	pvclock_copy_read_base(&pvtk->tkr_raw, &tk->tkr_raw);
+
+	pvtk->xtime_sec = tk->xtime_sec;
+	pvtk->ktime_sec = tk->ktime_sec;
+	pvtk->wall_to_monotonic_sec = tk->wall_to_monotonic.tv_sec;
+	pvtk->wall_to_monotonic_nsec = tk->wall_to_monotonic.tv_nsec;
+	pvtk->offs_real = tk->offs_real;
+	pvtk->offs_boot = tk->offs_boot;
+	pvtk->offs_tai = tk->offs_tai;
+	pvtk->raw_sec = tk->raw_sec;
+	spin_unlock_irqrestore(&shadow_pvtk_lock, flags);
+}
+
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -6993,6 +7108,7 @@ static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
 	struct timekeeper *tk = priv;
 
 	update_pvclock_gtod(tk);
+	update_shadow_pvtk(tk);
 
 	/* disable master clock if host does not trust, or does not
 	 * use, TSC based clocksource.
@@ -7809,6 +7925,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	bool req_immediate_exit = false;
 
+	kvm_copy_into_pvtk(vcpu);
+
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
 			kvm_x86_ops->get_vmcs12_pages(vcpu);
@@ -8891,6 +9009,9 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	if (vcpu->arch.pv_timekeeper_enabled)
+		atomic_dec(&pv_timekeepers_nr);
+
 	kvm_x86_ops->vcpu_free(vcpu);
 	free_cpumask_var(wbinvd_dirty_mask);
 }
-- 
2.23.0.237.gc6a4ce50a0-goog

