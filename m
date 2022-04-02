Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72F84EFE54
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 06:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352881AbiDBEDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 00:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiDBEDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 00:03:47 -0400
Received: from njjs-sys-mailin06.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E007C192581
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 21:01:55 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin06.njjs.baidu.com (Postfix) with ESMTP id 18A2F185C0067;
        Sat,  2 Apr 2022 12:01:54 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 05076D9932;
        Sat,  2 Apr 2022 12:01:54 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com
Subject: [PATCH] KVM: VMX: optimize pi_wakeup_handler
Date:   Sat,  2 Apr 2022 12:01:53 +0800
Message-Id: <1648872113-24329-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pi_wakeup_handler is used to wakeup the sleep vCPUs by posted irq
list_for_each_entry is used in it, and whose input is other function
per_cpu(), That cause that per_cpu() be invoked at least twice when
there is one sleep vCPU

so optimize pi_wakeup_handler it by reading once which is safe in
spinlock protection

and same to per CPU spinlock

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5fdabf3..0dae431 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -214,17 +214,21 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
  */
 void pi_wakeup_handler(void)
 {
+	struct list_head *wakeup_list;
 	int cpu = smp_processor_id();
+	raw_spinlock_t *spinlock;
 	struct vcpu_vmx *vmx;
 
-	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
-	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
-			    pi_wakeup_list) {
+	spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
+
+	raw_spin_lock(spinlock);
+	wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
+	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
 
 		if (pi_test_on(&vmx->pi_desc))
 			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_unlock(spinlock);
 }
 
 void __init pi_init_cpu(int cpu)
-- 
2.9.4

