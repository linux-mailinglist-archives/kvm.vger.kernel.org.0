Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E7107C8C
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 03:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWCqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 21:46:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbfKWCqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 21:46:07 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 14A4F43DFEB5CD2E76D2;
        Sat, 23 Nov 2019 10:46:06 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 23 Nov 2019
 10:45:57 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: Fix jump label out_free_* in kvm_init()
Date:   Sat, 23 Nov 2019 10:45:50 +0800
Message-ID: <1574477150-775-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The jump label out_free_1 and out_free_2 deal with
the same stuff, so git rid of one and rename the
label out_free_0a to retain the label name order.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e6b7094596..00268290dcbd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4354,12 +4354,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
-		goto out_free_0a;
+		goto out_free_1;
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, check_processor_compat, &r, 1);
 		if (r < 0)
-			goto out_free_1;
+			goto out_free_2;
 	}
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
@@ -4416,9 +4416,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
-out_free_1:
 	kvm_arch_hardware_unsetup();
-out_free_0a:
+out_free_1:
 	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
 	kvm_irqfd_exit();
-- 
2.19.1

