Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C269448C31A
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352859AbiALL3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 06:29:36 -0500
Received: from mx411.baidu.com ([124.64.200.154]:52191 "EHLO mx421.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237766AbiALL3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 06:29:35 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2022 06:29:35 EST
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx421.baidu.com (Postfix) with ESMTP id EA0762F0053F;
        Wed, 12 Jan 2022 19:19:40 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id DFD79D9932;
        Wed, 12 Jan 2022 19:19:40 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org, joro@8bytes.org
Subject: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Date:   Wed, 12 Jan 2022 19:19:40 +0800
Message-Id: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After support paravirtualized TLB shootdowns, steal_time.preempted
includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB

and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED

Fixes: 858a43aae2367 ("KVM: X86: use paravirtualized TLB Shootdown")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 59abbda..a9202d9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1025,8 +1025,8 @@ asm(
 ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
 "__raw_callee_save___kvm_vcpu_is_preempted:"
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
-"setne	%al;"
+"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
+"andb	$" __stringify(KVM_VCPU_PREEMPTED) ", %al;"
 "ret;"
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
-- 
2.9.4

