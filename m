Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1015A4D2AB7
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 09:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiCIIgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 03:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiCIIgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 03:36:45 -0500
Received: from mx421.baidu.com (mx411.baidu.com [124.64.200.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE781108748
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 00:35:46 -0800 (PST)
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx421.baidu.com (Postfix) with ESMTP id E95BB2F0051A;
        Wed,  9 Mar 2022 16:35:44 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id DCAAAD9932;
        Wed,  9 Mar 2022 16:35:44 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, x86@kernel.org, kvm@vger.kernel.org,
        lirongqing@baidu.com, wanpengli@tencent.com
Subject: [PATCH] KVM: x86: fix sending PV IPI
Date:   Wed,  9 Mar 2022 16:35:44 +0800
Message-Id: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if apic_id is less than min, and (max - apic_id) is greater than
KVM_IPI_CLUSTER_SIZE, then third check condition is satisfied,

but it should enter last branch, send IPI directly

Fixes: aaffcfd1e82 ("KVM: X86: Implement PV IPIs in linux guest")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 959f919..8915c93 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -517,7 +517,7 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
 		} else if (apic_id < min && max - apic_id < KVM_IPI_CLUSTER_SIZE) {
 			ipi_bitmap <<= min - apic_id;
 			min = apic_id;
-		} else if (apic_id < min + KVM_IPI_CLUSTER_SIZE) {
+		} else if (apic_id > min && apic_id < min + KVM_IPI_CLUSTER_SIZE) {
 			max = apic_id < max ? max : apic_id;
 		} else {
 			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
-- 
2.9.4

