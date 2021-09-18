Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83E841060F
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 13:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhIRLcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Sep 2021 07:32:51 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:42499 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232331AbhIRLct (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Sep 2021 07:32:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UonAS5U_1631964683;
Received: from localhost(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0UonAS5U_1631964683)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 19:31:24 +0800
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        shannon.zhao@linux.alibaba.com,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
Date:   Sat, 18 Sep 2021 19:30:00 +0800
Message-Id: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exit_reason.bus_lock_detected is not only set when bus lock VM exit 
was preempted, in fact, this bit is always set if bus locks are 
detected no matter what the exit_reason.basic is.

So the bus_lock_vmexit handling in vmx_handle_exit should be duplicated 
when exit_reason.basic is EXIT_REASON_BUS_LOCK(74). We can avoid it by 
checking if bus lock vmexit was preempted in vmx_handle_exit.

Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5..5ddf1df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6054,7 +6054,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * still need to exit to user space when bus lock detected to inform
 	 * that there is a bus lock in guest.
 	 */
-	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
+	if (to_vmx(vcpu)->exit_reason.bus_lock_detected &&
+			to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_BUS_LOCK) {
 		if (ret > 0)
 			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
 
-- 
1.8.3.1

