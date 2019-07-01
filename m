Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268675B4FD
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 08:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGAGX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 02:23:59 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:41454 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGAGX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 02:23:58 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id D26B3C151C38B5507445;
        Mon,  1 Jul 2019 14:23:55 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x616Mhka033824;
        Mon, 1 Jul 2019 14:22:43 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070114224699-1995718 ;
          Mon, 1 Jul 2019 14:22:46 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH 4/4] kvm: x86: convert TSC pr_debugs to be gated by CONFIG_KVM_DEBUG
Date:   Mon, 1 Jul 2019 14:21:11 +0800
Message-Id: <1561962071-25974-5-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-01 14:22:47,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-01 14:22:44,
        Serialize complete at 2019-07-01 14:22:44
X-MAIL: mse-fl1.zte.com.cn x616Mhka033824
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some pr_debug in TSC code, which may affect
performance, so it may make sense to wrap them using a new
macro tsc_debug which takes effect only when CONFIG_KVM_DEBUG
is defined.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/x86.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd7..1505e53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -74,6 +74,12 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+#ifdef CONFIG_KVM_DEBUG
+#define tsc_debug(x...) pr_debug(x)
+#else
+#define tsc_debug(x...)
+#endif
+
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
 u64 __read_mostly kvm_mce_cap_supported = MCG_CTL_P | MCG_SER_P;
@@ -1522,7 +1528,7 @@ static void kvm_get_time_scale(uint64_t scaled_hz, uint64_t base_hz,
 	*pshift = shift;
 	*pmultiplier = div_frac(scaled64, tps32);
 
-	pr_debug("%s: base_hz %llu => %llu, shift %d, mul %u\n",
+	tsc_debug("%s: base_hz %llu => %llu, shift %d, mul %u\n",
 		 __func__, base_hz, scaled_hz, shift, *pmultiplier);
 }
 
@@ -1603,7 +1609,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	thresh_lo = adjust_tsc_khz(tsc_khz, -tsc_tolerance_ppm);
 	thresh_hi = adjust_tsc_khz(tsc_khz, tsc_tolerance_ppm);
 	if (user_tsc_khz < thresh_lo || user_tsc_khz > thresh_hi) {
-		pr_debug("kvm: requested TSC rate %u falls outside tolerance [%u,%u]\n", user_tsc_khz, thresh_lo, thresh_hi);
+		tsc_debug("kvm: requested TSC rate %u falls outside tolerance [%u,%u]\n", user_tsc_khz, thresh_lo, thresh_hi);
 		use_scaling = 1;
 	}
 	return set_tsc_khz(vcpu, user_tsc_khz, use_scaling);
@@ -1766,12 +1772,12 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
 		if (!kvm_check_tsc_unstable()) {
 			offset = kvm->arch.cur_tsc_offset;
-			pr_debug("kvm: matched tsc offset for %llu\n", data);
+			tsc_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
 			offset = kvm_compute_tsc_offset(vcpu, data);
-			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
+			tsc_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
 		matched = true;
 		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
@@ -1790,7 +1796,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		kvm->arch.cur_tsc_write = data;
 		kvm->arch.cur_tsc_offset = offset;
 		matched = false;
-		pr_debug("kvm: new tsc generation %llu, clock %llu\n",
+		tsc_debug("kvm: new tsc generation %llu, clock %llu\n",
 			 kvm->arch.cur_tsc_generation, data);
 	}
 
@@ -6860,7 +6866,7 @@ static void kvm_timer_init(void)
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
-	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
+	tsc_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 
 	cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
-- 
1.8.3.1

