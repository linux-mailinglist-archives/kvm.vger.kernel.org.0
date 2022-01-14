Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0362748E8A2
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiANKy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:54:28 -0500
Received: from mx313.baidu.com ([180.101.52.140]:47652 "EHLO
        njjs-sys-mailin08.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229454AbiANKy1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:54:27 -0500
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin08.njjs.baidu.com (Postfix) with ESMTP id DD52B60C005E;
        Fri, 14 Jan 2022 18:54:24 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id BAC14D9932;
        Fri, 14 Jan 2022 18:54:24 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        peterz@infradead.org
Subject: 
Date:   Fri, 14 Jan 2022 18:54:24 +0800
Message-Id: <1642157664-18105-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After support paravirtualized TLB shootdowns, steal_time.preempted
includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB

and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: 
clear the rest of rax, suggested by Sean and peter
remove Fixes tag, since no issue in practice

 arch/x86/kernel/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b061d17..45c9ce8d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1025,8 +1025,8 @@ asm(
 ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
 "__raw_callee_save___kvm_vcpu_is_preempted:"
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
-"setne	%al;"
+"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
+"and	$" __stringify(KVM_VCPU_PREEMPTED) ", %rax;"
 "ret;"
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
-- 
2.9.4

