Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EC1418ECE
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 07:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhI0FzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 01:55:03 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41615 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhI0FzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 01:55:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UpiJnEZ_1632722004;
Received: from localhost(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0UpiJnEZ_1632722004)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 13:53:24 +0800
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, shannon.zhao@linux.alibaba.com,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: [PATCH] KVM: VMX: Remove redundant handling of bus lock vmexit
Date:   Mon, 27 Sep 2021 13:53:22 +0800
Message-Id: <1632722002-25003-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exit_reason.bus_lock_detected may or may not be set when exit reason is
EXIT_REASON_BUS_LOCK. It is non-deterministic hardware behavior. Dealing
with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit could be redundant
when exit_reason.basic is EXIT_REASON_BUS_LOCK.

We can remove redundant handling of bus lock vmexit. Set
exit_reason.bus_lock_detected (bit 26) unconditionally, and deal with
KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit.

Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5..f993c38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5561,9 +5561,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 
 static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
-	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
-	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-	return 0;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/* The dedicated flag (bit 26 of exit reason in vmcs field) may or may
+	 * not be set by hardware.
+	 */
+	vmx->exit_reason.bus_lock_detected = true;
+	return 1;
 }
 
 /*
@@ -6050,9 +6054,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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

