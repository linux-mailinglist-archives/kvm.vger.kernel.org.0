Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75242E771
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 05:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhJOD7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 23:59:55 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38612 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233955AbhJOD7y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 23:59:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Us2TCZa_1634270267;
Received: from localhost(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0Us2TCZa_1634270267)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 11:57:47 +0800
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: [PATCH v2] KVM: VMX: Remove redundant handling of bus lock vmexit
Date:   Fri, 15 Oct 2021 11:57:45 +0800
Message-Id: <1634270265-99421-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.

We can remove redundant handling of bus lock vmexit. Force Setting
exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
---
v1 -> v2: a little modifications of comments

 arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 116b089..22be02e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5562,9 +5562,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 
 static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
-	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-	return 0;
+	/*
+	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
+	 * VM-Exits, force setting the flag so that the logic in vmx_handle_exit()
+	 * doesn't have to handle the flag and the basic exit reason.
+	 */
+	to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
+	return 1;
 }
 
 /*
@@ -6051,9 +6055,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
 	/*
-	 * Even when current exit reason is handled by KVM internally, we
-	 * still need to exit to user space when bus lock detected to inform
-	 * that there is a bus lock in guest.
+	 * Exit to user space when bus lock detected to inform that there is
+	 * a bus lock in guest.
 	 */
 	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
 		if (ret > 0)
-- 
1.8.3.1

