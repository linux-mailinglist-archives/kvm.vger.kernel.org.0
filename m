Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A337942F018
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbhJOMBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 08:01:38 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:34907 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238623AbhJOMBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 08:01:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UsAlkTn_1634299169;
Received: from localhost(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0UsAlkTn_1634299169)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 19:59:29 +0800
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        seanjc@google.com, xiaoyao.li@intel.com,
        linux-kernel@vger.kernel.org,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: [PATCH v3] KVM: VMX: Remove redundant handling of bus lock vmexit
Date:   Fri, 15 Oct 2021 19:59:21 +0800
Message-Id: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.

We can remove redundant handling of bus lock vmexit. Unconditionally Set
exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
---
v1 -> v2: a little modifications of comments
v2 -> v3: addressed the review comments

 arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 116b089..7fb2a3a 100644
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
+	 * VM-Exits. Unconditionally set the flag here and leave the handling to
+	 * vmx_handle_exit().
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

