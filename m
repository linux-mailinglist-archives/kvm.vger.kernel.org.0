Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD67348C3C3
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 13:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353067AbiALMJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 07:09:35 -0500
Received: from mx313.baidu.com ([180.101.52.140]:18239 "EHLO
        njjs-sys-mailin07.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240575AbiALMJf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 07:09:35 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 07:09:34 EST
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin07.njjs.baidu.com (Postfix) with ESMTP id 22CD81948005C;
        Wed, 12 Jan 2022 20:02:02 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 013BDD9932;
        Wed, 12 Jan 2022 20:02:02 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org
Subject: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Date:   Wed, 12 Jan 2022 20:02:01 +0800
Message-Id: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu can schedule out when run halt instruction, and set itself
to INTERRUPTIBLE and switch to idle thread, vcpu should not be
set preempted for this condition

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Wang GuangJu <wangguangju@baidu.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f5dbf7..10d76bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4407,6 +4407,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
+	if (!vcpu->preempted)
+		return;
+
 	/* This happens on process exit */
 	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
-- 
2.9.4

