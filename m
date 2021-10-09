Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B615427645
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244585AbhJICRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244308AbhJICR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445E6C061794
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v203-20020a25c5d4000000b005bb21580411so2359272ybe.19
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=74r31OpU8NW+MC737KW2OyC4MoV5BxluWFmZ0wIUFwQ=;
        b=V7r7iotGGXSpwOyFo/5GOSk0OYL1h+1pOxbdC4LI5JCruGlrPLbnqn07EuCdfIwu0T
         Zmfvn9BWul9wSaR03Y4GuJvuRpvNM9GPW0g8UZ0ASJVKDvY1XN6qije5YFCYzLqWb0Ox
         h3h1UTdUfkhi0wg9KFd4+tuAGLSbiGpDis/Fr3m+vTeTPIUcLtSpmxnQfkRh0/DaszXp
         5H2ib25eMzRVYEc2xmrqf1JeyB/szEhAI8rd7GzbDU3qhiUT2F4XMkp8BugwIMIM3gvJ
         6+HChgOgvy/ayjdP2z8uJHXP2yKvQDdpl8X6zrmbCa91OqEywPOyHAZcF4Fpf43IvF27
         jXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=74r31OpU8NW+MC737KW2OyC4MoV5BxluWFmZ0wIUFwQ=;
        b=bXZjLYzZqFP+uTo1kUV7JYEQmdnZ7EQwP5R7Ex94rGSBv9frS92OuYPypKMZibEfI6
         Ym9yirGOF3XQYl6SOF9zeNmQmN+XnUZF54rAYvBSdYV42PkXkdPT1YrCPUe09J+bAxe3
         3aSXOstKD7dnY4E9j0GYxO3RPI4VPER4RDIgbwYRHGYp1Gb9vNv5k89fd79saG0fqA6t
         oXcTQrEMon/JYUDcMfqMct7R9ji7pU4rU3GgVh0h7bq+s0fIqxLSg2nx0+PXWEkG5eOC
         m0TS9mVzxtFND/I5/Nb2ANqpNUh1YIPPUtRt9dXhFEtDLCdqIQPjJ/4/KLGLwXAe0Do9
         veSA==
X-Gm-Message-State: AOAM531twiHR7t2YvYqzRKe+mrnddVN0dL/v8oDNOdoDnz4v0z0q9rLi
        RUJ08fakjjzY2fENGoysToyU5cO9dK0=
X-Google-Smtp-Source: ABdhPJwgbsSdnQrzbzPUJKulJyChRLEDriPJWDBbVXRDLiiDF8J2h2Ck1mesLvf0H4KXpFh8QBnQHKs2rsM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:1b56:: with SMTP id b83mr7086955ybb.327.1633745638422;
 Fri, 08 Oct 2021 19:13:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:24 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-32-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 31/43] KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
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
---
 arch/x86/kvm/vmx/posted_intr.c | 39 +++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c         |  2 ++
 arch/x86/kvm/vmx/vmx.h         |  3 +++
 include/linux/kvm_host.h       |  2 --
 virt/kvm/kvm_main.c            |  2 --
 5 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index d2b3d75c57d1..f1bcf8c32b6d 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -18,7 +18,7 @@
  * wake the target vCPUs.  vCPUs are removed from the list and the notification
  * vector is reset when the vCPU is scheduled in.
  */
-static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
 /*
  * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
  * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
@@ -26,7 +26,7 @@ static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
  * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
  * occur if a wakeup IRQ arrives and attempts to acquire the lock.
  */
-static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+static DEFINE_PER_CPU(spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
@@ -36,6 +36,7 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -71,9 +72,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -121,15 +122,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
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
 
@@ -182,24 +184,23 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
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
index 26ed8cd1a1f2..b3bb2031a7ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6848,6 +6848,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
+	INIT_LIST_HEAD(&vmx->pi_wakeup_list);
+
 	err = -ENOMEM;
 
 	vmx->vpid = allocate_vpid();
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..d1a720be9a64 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -298,6 +298,9 @@ struct vcpu_vmx {
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
 
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 87996b22e681..c5961a361c73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -304,8 +304,6 @@ struct kvm_vcpu {
 	u64 requests;
 	unsigned long guest_debug;
 
-	struct list_head blocked_vcpu_list;
-
 	struct mutex mutex;
 	struct kvm_run *run;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2bbf5c9d410f..c1850b60f38b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -426,8 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
-	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
-
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
-- 
2.33.0.882.g93a45727a2-goog

