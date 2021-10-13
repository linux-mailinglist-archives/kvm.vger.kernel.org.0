Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C5842BC24
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 11:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhJMJxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 05:53:44 -0400
Received: from mx316.baidu.com ([180.101.52.236]:13393 "EHLO
        njjs-sys-mailin03.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237603AbhJMJxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 05:53:43 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 05:53:42 EDT
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin03.njjs.baidu.com (Postfix) with ESMTP id 9B23A27400AB;
        Wed, 13 Oct 2021 17:42:52 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 7E234D9932;
        Wed, 13 Oct 2021 17:42:52 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     x86@kernel.org, kvm@vger.kernel.org, lirongqing@baidu.com
Subject: [PATCH][v2] KVM: x86: directly call wbinvd for local cpu when emulate wbinvd
Date:   Wed, 13 Oct 2021 17:42:52 +0800
Message-Id: <1634118172-32699-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

directly call wbinvd for local cpu, instead of calling atomic
cpumask_set_cpu to set local cpu, and then check if local cpu
needs to run in on_each_cpu_mask

on_each_cpu_mask is less efficient than smp_call_function_many,
since it will close preempt again and running call function by
checking flag with SCF_RUN_LOCAL. and here wbinvd can be called
directly

In fact, This change reverts commit 2eec73437487 ("KVM: x86: Avoid
issuing wbinvd twice"), since smp_call_function_many is skiping the
local cpu (as description of c2162e13d6e2f), wbinvd is not issued
twice

and reverts commit c2162e13d6e2f ("KVM: X86: Fix missing local pCPU
when executing wbinvd on all dirty pCPUs") too, which fixed the
previous patch, when revert previous patch, it is not needed.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v2: rewrite commit log

 arch/x86/kvm/x86.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aabd3a2..28c4c72 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6991,15 +6991,14 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		return X86EMUL_CONTINUE;
 
 	if (static_call(kvm_x86_has_wbinvd_exit)()) {
-		int cpu = get_cpu();
-
-		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
+		preempt_disable();
+		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
 				wbinvd_ipi, NULL, 1);
-		put_cpu();
+		preempt_enable();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
-	} else
-		wbinvd();
+	}
+
+	wbinvd();
 	return X86EMUL_CONTINUE;
 }
 
-- 
1.7.1

