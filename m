Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044BE60AC9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 19:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfGERMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 13:12:16 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:29402 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfGERMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 13:12:16 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 888BA60F1E79325F9FB0;
        Sat,  6 Jul 2019 01:12:14 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x65HC1g4011035;
        Sat, 6 Jul 2019 01:12:01 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070601124094-2115158 ;
          Sat, 6 Jul 2019 01:12:40 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH] kvm: x86: some tsc debug cleanup
Date:   Sat, 6 Jul 2019 01:10:22 +0800
Message-Id: <1562346622-1003-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-06 01:12:41,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-06 01:12:07,
        Serialize complete at 2019-07-06 01:12:07
X-MAIL: mse-fl2.zte.com.cn x65HC1g4011035
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some pr_debug in TSC code, which may have
been no use, so remove them as Paolo suggested.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/x86.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fafd81d..86f9861 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1518,9 +1518,6 @@ static void kvm_get_time_scale(uint64_t scaled_hz, uint64_t base_hz,
 
 	*pshift = shift;
 	*pmultiplier = div_frac(scaled64, tps32);
-
-	pr_debug("%s: base_hz %llu => %llu, shift %d, mul %u\n",
-		 __func__, base_hz, scaled_hz, shift, *pmultiplier);
 }
 
 #ifdef CONFIG_X86_64
@@ -1763,12 +1760,10 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
 		if (!kvm_check_tsc_unstable()) {
 			offset = kvm->arch.cur_tsc_offset;
-			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
 			offset = kvm_compute_tsc_offset(vcpu, data);
-			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
 		matched = true;
 		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
@@ -1787,8 +1782,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		kvm->arch.cur_tsc_write = data;
 		kvm->arch.cur_tsc_offset = offset;
 		matched = false;
-		pr_debug("kvm: new tsc generation %llu, clock %llu\n",
-			 kvm->arch.cur_tsc_generation, data);
 	}
 
 	/*
@@ -6857,7 +6850,6 @@ static void kvm_timer_init(void)
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
-	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
 
 	cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
-- 
1.8.3.1

