Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FEC3116EA
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhBEXUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhBEKEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:04:14 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08740C061797
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:03:34 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o20so4020509pfu.0
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=twA+ohaZAhGQm1SgqW1LJtL4DjvACaYrw3/ciTiXJv4=;
        b=zObEpqaNG3PF1c21juSMpPkVF3dolK//ldykqiEmaZXVDHzSMb3YEtlfodq4GAuq6Z
         a/mPWJLP5wwnuYV1qdJfGlIDaPOf5CrezOoEbNhhLfSbjYwmc8LcselRSTUAQgOw+iBL
         eNQT0ggfDRW0+GlVbdry5TkoqhUXzCDS9hEgL6nFojQXLhkutqMkqv8qTxnZOrcVPzQ9
         XFPt1CAvIkA9uDT2CPnB4wHResxAsqTKDfcniTR/byg2ya2BrF9ZQcTcRfGCKz1pNxV3
         QPol8QrieqdG1y23MoyWa+DuvZvsVKD2ain5hwL1YPwEnT/Ta57rMQEwvprmW+24lBDX
         ndRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=twA+ohaZAhGQm1SgqW1LJtL4DjvACaYrw3/ciTiXJv4=;
        b=IA33FUxqCRveESwU11mVhFbPv8nu/kWhSCYGuXu8xtsFVo47LAcMrMZ47abXt8ER2w
         swwnGCTeFFI7POgnTR1miWxewoVaDD9MjFljN1kuagpK8L66/7rS+5R87RLXdbP8SW7x
         7T1/20EttK3X3CTd5Dnh0xNe6fbMXhgRRQFOI7/QUK8l/DYcR41RW9Z5ltUqPr2pkr9g
         qBHglbywhjvZFHy6Fs9mMqV9vxFPx2k9rmKu50HZtuoxTcwBdqLZgYy9DnvBwhLoTtsY
         xYA/cytFA9cSqMWkumduld9o+JeCfURsIgmdLOFmbBKMmH6LKScxKwoZ6FvqosBoHLhO
         Slkg==
X-Gm-Message-State: AOAM532TvNCWgTp8prpnTlycUw5DbiRv3VInQlWkrUp/4QYHiV5Vzc78
        i6mqS7XEckcRysYdDRLIs8DzAIOVxdynr/S6
X-Google-Smtp-Source: ABdhPJzgH+mQQojRpdTrO++fZMM0bLeNHaIJx2xAKqG6/6opIBTafqtFOESp8rOhGNVFuCTMJX8dTQ==
X-Received: by 2002:a63:d601:: with SMTP id q1mr3629722pgg.417.1612519413622;
        Fri, 05 Feb 2021 02:03:33 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:03:33 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 1/9] KVM: vmx: hook set_next_event for getting the host tscd
Date:   Fri,  5 Feb 2021 18:03:09 +0800
Message-Id: <20210205100317.24174-2-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to get the host tscd value,
we need to hook set_next_event function

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h | 21 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 51 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  1 +
 kernel/time/tick-common.c       |  1 +
 4 files changed, 74 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5f33a0d0e2..eb6a611963b7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -34,6 +34,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <linux/clockchips.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -520,6 +521,24 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
 
+enum tick_device_mode {
+	TICKDEV_MODE_PERIODIC,
+	TICKDEV_MODE_ONESHOT,
+};
+
+struct tick_device {
+	struct clock_event_device *evtdev;
+	enum tick_device_mode mode;
+};
+
+struct timer_passth_info {
+	u64 host_tscd;
+	struct clock_event_device *curr_dev;
+
+	void (*orig_event_handler)(struct clock_event_device *dev);
+	int (*orig_set_next_event)(unsigned long evt, struct clock_event_device *dev);
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -805,6 +824,8 @@ struct kvm_vcpu_arch {
 		 */
 		bool enforce;
 	} pv_cpuid;
+
+	bool timer_passth_enable;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..38b8d80fa157 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -128,6 +128,11 @@ static bool __read_mostly enable_preemption_timer = 1;
 module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #endif
 
+static bool __read_mostly enable_timer_passth;
+#ifdef CONFIG_X86_64
+module_param_named(timer_passth, enable_timer_passth, bool, 0444);
+#endif
+
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
@@ -220,6 +225,46 @@ static const struct {
 	[VMENTER_L1D_FLUSH_NOT_REQUIRED] = {"not required", false},
 };
 
+#define TSC_DIVISOR  8
+static DEFINE_PER_CPU(struct timer_passth_info, passth_info);
+
+static int override_lapic_next_event(unsigned long delta,
+		struct clock_event_device *evt)
+{
+	struct timer_passth_info *local_timer_info;
+	u64 tsc;
+	u64 tscd;
+
+	local_timer_info = &per_cpu(passth_info, smp_processor_id());
+	tsc = rdtsc();
+	tscd = tsc + (((u64) delta) * TSC_DIVISOR);
+	local_timer_info->host_tscd = tscd;
+	wrmsrl(MSR_IA32_TSCDEADLINE, tscd);
+
+	return 0;
+}
+
+static void vmx_host_timer_passth_init(void *junk)
+{
+	struct timer_passth_info *local_timer_info;
+	int cpu = smp_processor_id();
+
+	local_timer_info = &per_cpu(passth_info, cpu);
+	local_timer_info->curr_dev = per_cpu(tick_cpu_device, cpu).evtdev;
+	local_timer_info->orig_set_next_event =
+		local_timer_info->curr_dev->set_next_event;
+	local_timer_info->curr_dev->set_next_event = override_lapic_next_event;
+}
+
+static void vmx_host_timer_restore(void *junk)
+{
+	struct timer_passth_info *local_timer_info;
+
+	local_timer_info = &per_cpu(passth_info, smp_processor_id());
+	local_timer_info->curr_dev->set_next_event =
+		local_timer_info->orig_set_next_event;
+}
+
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
@@ -7573,6 +7618,9 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 static void hardware_unsetup(void)
 {
+	if (enable_timer_passth)
+		on_each_cpu(vmx_host_timer_restore, NULL, 1);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7884,6 +7932,9 @@ static __init int hardware_setup(void)
 
 	vmx_set_cpu_caps();
 
+	if (enable_timer_passth)
+		on_each_cpu(vmx_host_timer_passth_init, NULL, 1);
+
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e545a8a613b1..5d353a9c9881 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9911,6 +9911,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
+	vcpu->arch.timer_passth_enable = false;
 
 	kvm_hv_vcpu_init(vcpu);
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 6c9c342dd0e5..bc50f4a1a7c0 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -26,6 +26,7 @@
  * Tick devices
  */
 DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
+EXPORT_SYMBOL_GPL(tick_cpu_device);
 /*
  * Tick next event: keeps track of the tick time
  */
-- 
2.11.0

