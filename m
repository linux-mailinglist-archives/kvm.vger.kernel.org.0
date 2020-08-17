Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB5245C2D
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 07:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgHQF5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 01:57:55 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37592 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726235AbgHQF5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 01:57:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0U5z1wNG_1597643859;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0U5z1wNG_1597643859)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 17 Aug 2020 13:57:39 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Artie Ding <artie.ding@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>,
        Zelin Deng <zelin.deng@linux.alibaba.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: kvmclock_init_mem() should be called any way
Date:   Mon, 17 Aug 2020 13:57:39 +0800
Message-Id: <20200817055739.9994-1-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.2432.ga663e714
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pvclock data pointers of vCPUs >= HVC_BOOT_ARRAY_SIZE (64) are stored in
hvclock_mem wihch is initialized in kvmclock_init_mem().
Here're 3 scenarios in current implementation:
    - no-kvmclock is set in cmdline. kvm pv clock driver is disabled,
      no impact.
    - no-kvmclock-vsyscall is set in cmdline. kvmclock_init_mem() won't
      be called. No memory for storing pvclock data of vCPUs >= 64, vCPUs
      >= 64 can not be online or hotpluged.
    - tsc unstable. kvmclock_init_mem() won't be called. vCPUs >= 64 can
      not be online or hotpluged.
It's not reasonable that vCPUs hotplug have been impacted by last 2
scenarios. Hence move kvmclock_init_mem() to front, in case hvclock_mem
can not be initialized unexpectedly.

Fixes: 6a1cac56f41f9 (x86/kvm: Use __bss_decrypted attribute in shared variables)
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
---
 arch/x86/kernel/kvmclock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..1abbda25e037 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -271,7 +271,14 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
 {
 #ifdef CONFIG_X86_64
 	u8 flags;
+#endif
+
+	if (!kvmclock)
+		return 0;
+
+	kvmclock_init_mem();
 
+#ifdef CONFIG_X86_64
 	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
 		return 0;
 
@@ -282,8 +289,6 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
 	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
 #endif
 
-	kvmclock_init_mem();
-
 	return 0;
 }
 early_initcall(kvm_setup_vsyscall_timeinfo);
-- 
2.20.1

