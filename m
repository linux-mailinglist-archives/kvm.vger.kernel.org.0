Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1C14F6045
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 15:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiDFNvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 09:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiDFNum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 09:50:42 -0400
Received: from njjs-sys-mailin06.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AB765F4747
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 04:25:05 -0700 (PDT)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin06.njjs.baidu.com (Postfix) with ESMTP id C805A185C0048;
        Wed,  6 Apr 2022 19:25:02 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id B4796D9932;
        Wed,  6 Apr 2022 19:25:02 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     x86@kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com
Subject: [PATCH][v2] KVM: VMX: optimize pi_wakeup_handler
Date:   Wed,  6 Apr 2022 19:25:02 +0800
Message-Id: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
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

so optimize pi_wakeup_handler it by reading once and same to per CPU
spinlock

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v1: move reading the per-cpu variable out of spinlock protection

 arch/x86/kvm/vmx/posted_intr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5fdabf3..c5c1d31 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -215,16 +215,17 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 void pi_wakeup_handler(void)
 {
 	int cpu = smp_processor_id();
+	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
+	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
 	struct vcpu_vmx *vmx;
 
-	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
-	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
-			    pi_wakeup_list) {
+	raw_spin_lock(spinlock);
+	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
 
 		if (pi_test_on(&vmx->pi_desc))
 			kvm_vcpu_wake_up(&vmx->vcpu);
 	}
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	raw_spin_unlock(spinlock);
 }
 
 void __init pi_init_cpu(int cpu)
-- 
1.8.3.1

