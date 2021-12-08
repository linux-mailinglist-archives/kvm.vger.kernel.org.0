Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE5146CA6B
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbhLHB6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbhLHB63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:29 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26A7C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:54:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 61-20020a17090a09c300b001adc4362b42so679052pjo.7
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mZkxzlEm8MBRNYBkK9eDkrOtQSNqYYOUUFB/yqMbNLc=;
        b=fvbstA2FV3AgxMq48AckzsKGodTQ5DKYyjXR0dqZMB/K2Z9wmslFmOiF8qOkvrJ8NU
         P737TQ6cN8hKJ2dAM58OE1xR/tSkpDAKFINHW8/75zo50f5N4V1x3rTCcQcQPctn+g64
         TOPf+WntX/TZ0JmmQcEogZ1xPpX7hhqo7mSjOk3yGEnSEC0o/zTDxqSrG3nIzYh7zw75
         FND9GSGO7Y6AzoJKlFdMp+i0//rjMA8hq97cQb5jp/aooc2ZOsdHslw8t/LtyP0xm6k7
         NOxQ6/pwFI0eFGe4FqyVj9f9UpJF0tUi2frxesv304I+lK07Qnk7sw4h8e2PaxDvACWZ
         WkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mZkxzlEm8MBRNYBkK9eDkrOtQSNqYYOUUFB/yqMbNLc=;
        b=QGej1h/EB/CRbOwMj0F5U66GZOC1sU3PHhi+Nzu5nRyBcu7onz0NmS5DYagqWsbRpF
         g/XvetXmf1npPgD341hxYnPITVg0ZYFnP/zqt5TLofejctRHa7PvW/wS2v7p2TM7TZFh
         170AAAPmr390q7K3INyLPBw8YINMxZ/DhklyoczZirV4B9zW41DzPsgMXyKSSQ5hLP0Q
         USkUPHRhIlup1s78zBE1c0fHFZ7Ascbvz9FDiNjMO5aeHqfWpZBLWPF1w7ONUJ/4NiyP
         RFnAwjjr0+4Sp9BawhpRwz8rr6rHUMB5aGK2RDSiJAQmic7GWKQ1wLb4hZc1NDn3dLyc
         k6vQ==
X-Gm-Message-State: AOAM532duzOy+PU9UFu6y9NsfLl2AKyTxd3zHX/XqhYkrMq00VU6lIob
        YeII5kefpmnbtvuE+v9xcN8xo7uOYD0=
X-Google-Smtp-Source: ABdhPJwJP+xrzFBsVd/E76KaLqfJdLfkHdFbidzfSlXdv1bSh5ufbzKqJU9fhU7VtX7RUbHvfdKTcV+ROhQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:211b:: with SMTP id h27mr27065654pgh.203.1638928497275;
 Tue, 07 Dec 2021 17:54:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:16 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 06/26] KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the seemingly generic block_vcpu_list from kvm_vcpu to vcpu_vmx, and
rename the list and all associated variables to clarify that it tracks
the set of vCPU that need to be poked on a posted interrupt to the wakeup
vector.  The list is not used to track _all_ vCPUs that are blocking, and
the term "blocked" can be misleading as it may refer to a blocking
condition in the host or the guest, where as the PI wakeup case is
specifically for the vCPUs that are actively blocking from within the
guest.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 39 +++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c         |  2 ++
 arch/x86/kvm/vmx/vmx.h         |  3 +++
 include/linux/kvm_host.h       |  2 --
 virt/kvm/kvm_main.c            |  2 --
 5 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index a1776d186225..023a6b9b0fa4 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -19,7 +19,7 @@
  * wake the target vCPUs.  vCPUs are removed from the list and the notification
  * vector is reset when the vCPU is scheduled in.
  */
-static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
 /*
  * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
  * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
@@ -27,7 +27,7 @@ static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
  * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
  * occur if a wakeup IRQ arrives and attempts to acquire the lock.
  */
-static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+static DEFINE_PER_CPU(spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -51,6 +51,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -86,9 +87,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
-		list_del(&vcpu->blocked_vcpu_list);
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
+		spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		list_del(&vmx->pi_wakeup_list);
+		spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
 	dest = cpu_physical_id(cpu);
@@ -142,15 +143,16 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
 static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vcpu->blocked_vcpu_list,
-		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
+	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	list_add_tail(&vmx->pi_wakeup_list,
+		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
+	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
 	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
 
@@ -199,24 +201,23 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
  */
 void pi_wakeup_handler(void)
 {
-	struct kvm_vcpu *vcpu;
 	int cpu = smp_processor_id();
+	struct vcpu_vmx *vmx;
 
-	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
-	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
-			blocked_vcpu_list) {
-		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
+	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
+			    pi_wakeup_list) {
 
-		if (pi_test_on(pi_desc))
-			kvm_vcpu_kick(vcpu);
+		if (pi_test_on(&vmx->pi_desc))
+			kvm_vcpu_kick(&vmx->vcpu);
 	}
-	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 void __init pi_init_cpu(int cpu)
 {
-	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
-	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
+	spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
 }
 
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0254d7f64698..64932cc3e4e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6837,6 +6837,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
+	INIT_LIST_HEAD(&vmx->pi_wakeup_list);
+
 	err = -ENOMEM;
 
 	vmx->vpid = allocate_vpid();
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f978699480e3..fc52721018ce 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -308,6 +308,9 @@ struct vcpu_vmx {
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
 
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 30cc1327065c..2d17381b5210 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -305,8 +305,6 @@ struct kvm_vcpu {
 	u64 requests;
 	unsigned long guest_debug;
 
-	struct list_head blocked_vcpu_list;
-
 	struct mutex mutex;
 	struct kvm_run *run;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d3e86f246e1c..84b4af38a2ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -427,8 +427,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
-	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
-
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
-- 
2.34.1.400.ga245620fadb-goog

