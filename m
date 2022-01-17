Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D97490195
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 06:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiAQFhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 00:37:42 -0500
Received: from mx411.baidu.com ([124.64.200.154]:34845 "EHLO mx421.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234453AbiAQFhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 00:37:31 -0500
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx421.baidu.com (Postfix) with ESMTP id DD20A2F009D4;
        Mon, 17 Jan 2022 13:37:22 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id D1833D9932;
        Mon, 17 Jan 2022 13:37:22 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        peterz@infradead.org, lirongqing@baidu.com
Subject: [PATCH][v3] KVM: x86: refine kvm_vcpu_is_preempted
Date:   Mon, 17 Jan 2022 13:37:22 +0800
Message-Id: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After support paravirtualized TLB shootdowns, steal_time.preempted
includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB

and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v2: using andl and setnz
diff with v1: clear 64bit rax

 arch/x86/kernel/kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b061d17..fe0aead 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1025,8 +1025,9 @@ asm(
 ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
 "__raw_callee_save___kvm_vcpu_is_preempted:"
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
-"setne	%al;"
+"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
+"andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax;"
+"setnz	%al;"
 "ret;"
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
-- 
2.9.4

