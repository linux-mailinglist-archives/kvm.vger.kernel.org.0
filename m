Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB79361812
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 05:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhDPDIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 23:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDPDIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 23:08:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3288C061574;
        Thu, 15 Apr 2021 20:08:23 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id n38so17430067pfv.2;
        Thu, 15 Apr 2021 20:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uFKS1WFTegraebrT+gI7cJRe7sDUnuGWyUREin+ouco=;
        b=YkfygmwWDmCVEsZLunBUBrilsLiA7IDScQtDDzAj1O22eaBGUAhpgnVjJ0bPLP2DV8
         ABXF+F3OcIAaOOSmIBZjD5lHAQfWI7rXaceSqRgKG5X1PDlzYeoBg/xafuj3LjCrlPbG
         AAhmkmcgCP2q9NnjFZK++3AjbBI6/eKREP579HKQQvtgTA6ivrz2C0hSflYVX7q3g93W
         JxHKKEO3j7OVCYMBwgNK8FeBGqowy0bELkQW6ZC5M+Ge1sIvKOZ9kOJt9rLkCbR8rPYx
         k69yWUvo9XBnvaEtZRYMxs0OHY6L0TGhr6F8VTuOwdb4/CAQoohkMsNrprP0dG+EuDCs
         VAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uFKS1WFTegraebrT+gI7cJRe7sDUnuGWyUREin+ouco=;
        b=eye7gZm7ZBS/u9+fCKv1lw6eXO9ST7gJ7y/hJGkb5l2HaZOtKH/odfUoqy6PKbIWq1
         IJYvaiN05Im+SZmeDfygmyEjht5ZB/R72bjDqTM+eAHVkAYAOZEsFBcAONvi6JeQw7hZ
         nSzTB7hsEMc5AC9qhd/tRFCbzr4EulsBviWAHLff0Nh5aGamSlcZmPvPAT+C4S9GSvyu
         iM+y2sUPJsy7QFauOR2U/xJFQCXcZQfFtvl/lXwwtQQLg6aA5B1DLt3YIq0rTLw0b8hO
         qCG6juPjKhSWsrUzy6ogT24VMUgcYWM87wQgxCAZRo4320f/K6bRnwuLIJENk+eZYm/D
         yQXg==
X-Gm-Message-State: AOAM530rkO/AKe8xz5/1c/n0dzumQbu5hRlztZng+fZN264fACVrbstb
        JDUZw7gTSKVI4AoCONHhLzVNoFkpUuw=
X-Google-Smtp-Source: ABdhPJxvnnkermnsBPvw4vDQQcMspMPBLn164mh+/HbqfeJn6OqJVYNt2NtPxYaMdKw34BrqNa7PsA==
X-Received: by 2002:a63:c111:: with SMTP id w17mr6101708pgf.127.1618542503102;
        Thu, 15 Apr 2021 20:08:23 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id r1sm3654698pfh.153.2021.04.15.20.08.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 20:08:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: Boost vCPU candidiate in user mode which is delivering interrupt
Date:   Fri, 16 Apr 2021 11:08:10 +0800
Message-Id: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Both lock holder vCPU and IPI receiver that has halted are condidate for 
boost. However, the PLE handler was originally designed to deal with the 
lock holder preemption problem. The Intel PLE occurs when the spinlock 
waiter is in kernel mode. This assumption doesn't hold for IPI receiver, 
they can be in either kernel or user mode. the vCPU candidate in user mode 
will not be boosted even if they should respond to IPIs. Some benchmarks 
like pbzip2, swaptions etc do the TLB shootdown in kernel mode and most
of the time they are running in user mode. It can lead to a large number 
of continuous PLE events because the IPI sender causes PLE events 
repeatedly until the receiver is scheduled while the receiver is not 
candidate for a boost.

This patch boosts the vCPU candidiate in user mode which is delivery 
interrupt. We can observe the speed of pbzip2 improves 10% in 96 vCPUs 
VM in over-subscribe scenario (The host machine is 2 socket, 48 cores, 
96 HTs Intel CLX box). There is no performance regression for other 
benchmarks like Unixbench spawn (most of the time contend read/write 
lock in kernel mode), ebizzy (most of the time contend read/write sem 
and TLB shoodtdown in kernel mode).

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c       | 8 ++++++++
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d2dd3f..0f16fa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11069,6 +11069,14 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
+		return true;
+
+	return false;
+}
+
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.preempted_in_kernel;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b06d12..5012fc4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -954,6 +954,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
+bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0a481e7..781d2db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3012,6 +3012,11 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool __weak kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -3045,6 +3050,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			    !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+				!kvm_arch_interrupt_delivery(vcpu) &&
 				!kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
-- 
2.7.4

