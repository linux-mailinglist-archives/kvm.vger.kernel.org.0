Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F874ACD6
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 10:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjGGIZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGGIZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 04:25:21 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044EB90
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 01:25:17 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qy5yx2r7MzTmCt;
        Fri,  7 Jul 2023 16:24:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 7 Jul 2023 16:25:14 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] KVM: arm64: Keep need_db always true in vgic_v4_put() when emulating WFI
Date:   Fri, 7 Jul 2023 16:55:45 +0800
Message-ID: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When enabled GICv4.1 on Kunpeng 920 platform with 6.4 kernel (preemptible
kernel), running a vm with 128 vcpus on 64 pcpu, sometimes vm is not booted
successfully, and we find there is a situation that doorbell interrupt will
not occur event if there is a pending interrupt.
In function kvm_vcpu_wfi(), the parameter of need_db is true for function
vgic_v4_put() which wants to tell GICv4 that we need doorbells to be
signalled if there is a pending interrupt.
But if there is a preemption before kvm_vcpu_halt (after preempt_enable()),
it will change the value of vpe->resident, which will make vgic_v4_put()
is called with need_db = false When calling function schedule().
Then after calling schedule(), doorbell interrupt will not occur even
if there is a pending interrupt.
We need to keep need_db always true for emulate Wait-For-Interrupt
behavior, so set need_db true in vgic_v4_put() if it is in the process of
emulating WFI.

kvm_vcpu_wfi
    preempt_disable
    ...
    vgic_v4_put(vcpu, true)
	vpe->resident = 0
	need_db = 1
    preempt_enable
------------------------------------------> preemption occur
    kvm_sched_out
	vgic_v4_put(vcpu, false)
	    vpe->resident == 0 -> return 0 (do nothing)
	    ...
<------------------------------------------ back
    kvm_sched_in
	vgic_v4_load
	    vpe->resident  = 1
	    ...
------------------------------------------- Continue
    kvm_vcpu_halt
	set vcpu thread INTERRUPTIBLE
	schedule() ->
	    kvm_sched_out
		vgic_v4_put(vcpu, false)
		    need_db = 0 (vcpu thread is not scheduled and doorbell interrupt
		    will not signalled even if there is a pending interrupt)
		    vpe->resident = 0

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c1c28fe..37152cf8 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -343,6 +343,9 @@ int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
+	if (vcpu->stat.generic.blocking == 1)
+		need_db = true;
+
 	return its_make_vpe_non_resident(vpe, need_db);
 }
 
-- 
2.8.1

