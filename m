Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466B941AC0A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 11:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhI1JiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 05:38:18 -0400
Received: from [119.249.100.165] ([119.249.100.165]:30041 "EHLO
        mx419.baidu.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239989AbhI1JiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 05:38:13 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2021 05:38:12 EDT
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx419.baidu.com (Postfix) with ESMTP id 89609181820C1;
        Tue, 28 Sep 2021 17:27:49 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 80FE0D9932;
        Tue, 28 Sep 2021 17:27:49 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, wanpengli@tencent.com, jan.kiszka@siemens.com,
        x86@kernel.org
Subject: [PATCH] KVM: x86: directly call wbinvd for local cpu when emulate wbinvd
Date:   Tue, 28 Sep 2021 17:27:49 +0800
Message-Id: <1632821269-52969-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

directly call wbinvd for local pCPU, which can avoid ipi for
itself and calling of get_cpu/on_each_cpu_mask/etc.

In fact, This change reverts commit 2eec73437487 ("KVM: x86: Avoid
issuing wbinvd twice"), since smp_call_function_many is skiping the
local cpu (as description of c2162e13d6e2f), wbinvd is not issued
twice

and reverts commit c2162e13d6e2f ("KVM: X86: Fix missing local pCPU
when executing wbinvd on all dirty pCPUs") too, which fixed the
previous patch, when revert previous patch, it is not needed.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/x86.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef141..ee65941 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6984,15 +6984,14 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
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

