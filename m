Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C33593B5
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 06:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhDIES6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 00:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIES4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 00:18:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F40C061761;
        Thu,  8 Apr 2021 21:18:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y32so2908158pga.11;
        Thu, 08 Apr 2021 21:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xaENlWbODyEto5XlOvRuMJolo5sGz0JfL3nPFrLfnfo=;
        b=WFOqixJdGiNjr07rL6it5V1WYpE09f3ANsOibIqH+z3m2ysCf1BWg5cRIEFrt+d8Km
         HEOq1TOYqfid8x+kcU6mSW5JRzTqFxJ+Wt6pzYHM1N1bHL08rf2f8yzGDbu5PZxkvTMH
         Rpv8xZHGxL6kvCCsjBzHPfYLFwGY1WAmKesKAdxSuTK+2xJocwInYWGLVrGAsyhMBn/6
         gFsZ21i9XG+d8o5OPxJAtyhmk5zj9HFcKmuVSZNnV6ge1EgN80BNP+p0+Cwq97J4aOl4
         kTOU2X2Jznp/xTkpcoxXjw9HHjG3nwvLC/a6Lo6sioTQoYYDCobo3BL2VyorIMohoeJL
         iSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xaENlWbODyEto5XlOvRuMJolo5sGz0JfL3nPFrLfnfo=;
        b=LavGPdQIlOtE/aDYODL4nsZIE9RO9lVVtKZH4df84PUjBdKHTNGH7eUAR/E4ieGR0y
         h9Dn6SJYr6/TEYqU8l3hh2zJXhMLzyblAoqd1bAEIBSqvXjTKd+B4DiA7C9MdZRh4a+y
         4p9gDu+FgT4tavBIhiCSVZs4cM6GfXYOThbuMlTg2YRL+V93XTFr9Bq4MHECVtjkFn1I
         KbKQpox73oMcxnVwK7nhzaIs/TqbYGxkQL0xIH6c2tvDo/MoVRwaQKP0DZaSqblx7QqD
         Hh1pkzkCNFjBgrPI4Tre+4XndBf/2X8uWxmGVtKBSACFhNEdM8e1qaS5HveQBWSgPrRr
         vIjQ==
X-Gm-Message-State: AOAM533aeW8pdra8sY6yvh2Cgn7qtWHuMk8PpLu537DvN31SqpueM9If
        nj4wIM6+8mkBKRwKrA8lesA8Jstlzn0=
X-Google-Smtp-Source: ABdhPJyasOZHxTZMMtmdH6OMq5eDliacx+llgkwbI4zN3cBwXe8Axv8eKrCkRfauuIP4Wo6PBCdy4g==
X-Received: by 2002:a63:d755:: with SMTP id w21mr11514874pgi.400.1617941924255;
        Thu, 08 Apr 2021 21:18:44 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gw24sm765553pjb.42.2021.04.08.21.18.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 21:18:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/3] KVM: X86: Count attempted/successful directed yield
Date:   Fri,  9 Apr 2021 12:18:30 +0800
Message-Id: <1617941911-5338-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
References: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

To analyze some performance issues with lock contention and scheduling,
it is nice to know when directed yield are successful or failing.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * rename new vcpu stat 
 * account success instead of ignore 

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 24 ++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44f8930..5af7411 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1126,6 +1126,8 @@ struct kvm_vcpu_stat {
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
 	u64 nested_run;
+	u64 directed_yield_attempted;
+	u64 directed_yield_successful;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16fb395..f08e9b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
 	VCPU_STAT("nested_run", nested_run),
+	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
+	VCPU_STAT("directed_yield_successful", directed_yield_successful),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
@@ -8211,21 +8213,31 @@ void kvm_apicv_init(struct kvm *kvm, bool enable)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_init);
 
-static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
+static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 {
 	struct kvm_vcpu *target = NULL;
 	struct kvm_apic_map *map;
 
+	vcpu->stat.directed_yield_attempted++;
+
 	rcu_read_lock();
-	map = rcu_dereference(kvm->arch.apic_map);
+	map = rcu_dereference(vcpu->kvm->arch.apic_map);
 
 	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
 		target = map->phys_map[dest_id]->vcpu;
 
 	rcu_read_unlock();
 
-	if (target && READ_ONCE(target->ready))
-		kvm_vcpu_yield_to(target);
+	if (!target || !READ_ONCE(target->ready))
+		goto no_yield;
+
+	if (kvm_vcpu_yield_to(target) <= 0)
+		goto no_yield;
+
+	vcpu->stat.directed_yield_successful++;
+
+no_yield:
+	return;
 }
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
@@ -8272,7 +8284,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 			break;
 
 		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
-		kvm_sched_yield(vcpu->kvm, a1);
+		kvm_sched_yield(vcpu, a1);
 		ret = 0;
 		break;
 #ifdef CONFIG_X86_64
@@ -8290,7 +8302,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
 			break;
 
-		kvm_sched_yield(vcpu->kvm, a0);
+		kvm_sched_yield(vcpu, a0);
 		ret = 0;
 		break;
 	default:
-- 
2.7.4

