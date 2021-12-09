Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443F546EACD
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhLIPNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbhLIPNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:48 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB86FC061353;
        Thu,  9 Dec 2021 07:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=M/YYv3gr+rHTtVoXKv5llOdH/rGmFevtrCyuCrq7vAs=; b=Jhzb3PUgrXAVUpMifP7+BRtt2Y
        +lusRk/YTrgZJNJO1l0FPtVCpUieCqUhYfHjFYLw/Jy1RQsYj89ncBV9BjwRMZq9KdZBjIZHO0c5Q
        1cqcc0331lqBOit04D5XAC6WvR33SYTf+iUm9TJcqZLh1VIsdfvz+cA2HaDjgkxfeS0uJL/3e5Grw
        hurRnyoXnyPg/VSB3gYDguraYjN4B7n2qGbiypUCKwCzNLdf7Hb9E3b4J0DmU+yJkO2MNVMRVOu9G
        kigGIN6afMmaLFmicMdEFh0/GYTLwgr61oDgF+lt+gtegEk7z0xhMnctcAGQcR9pars9azznVNqgJ
        4X+a9mIA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3K-000Np4-H4; Thu, 09 Dec 2021 15:09:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3K-0000yw-6f; Thu, 09 Dec 2021 15:09:46 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 11/11] x86/kvm: Silence per-cpu pr_info noise about KVM clocks and steal time
Date:   Thu,  9 Dec 2021 15:09:38 +0000
Message-Id: <20211209150938.3518-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209150938.3518-1-dwmw2@infradead.org>
References: <20211209150938.3518-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

I made the actual CPU bringup go nice and fast... and then Linux spends
half a minute printing stupid nonsense about clocks and steal time for
each of 256 vCPUs. Don't do that. Nobody cares.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/kvm.c      | 6 +++---
 arch/x86/kernel/kvmclock.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 59abbdad7729..a438217cbfac 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -313,7 +313,7 @@ static void kvm_register_steal_time(void)
 		return;
 
 	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
-	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
+	pr_debug("stealtime: cpu %d, msr %llx\n", cpu,
 		(unsigned long long) slow_virt_to_phys(st));
 }
 
@@ -350,7 +350,7 @@ static void kvm_guest_cpu_init(void)
 
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
-		pr_info("setup async PF for cpu %d\n", smp_processor_id());
+		pr_debug("setup async PF for cpu %d\n", smp_processor_id());
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
@@ -376,7 +376,7 @@ static void kvm_pv_disable_apf(void)
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
 	__this_cpu_write(apf_reason.enabled, 0);
 
-	pr_info("disable async PF for cpu %d\n", smp_processor_id());
+	pr_debug("disable async PF for cpu %d\n", smp_processor_id());
 }
 
 static void kvm_disable_steal_time(void)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 462dd8e9b03d..a35cbf9107af 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -174,7 +174,7 @@ static void kvm_register_clock(char *txt)
 
 	pa = slow_virt_to_phys(&src->pvti) | 0x01ULL;
 	wrmsrl(msr_kvm_system_time, pa);
-	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
+	pr_debug("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
 }
 
 static void kvm_save_sched_clock_state(void)
-- 
2.31.1

