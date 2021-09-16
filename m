Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11C140EA68
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344089AbhIPS5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245508AbhIPS53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:29 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9501DC04A155
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:43 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so44934123qka.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EqfJ4nsZ26w2OY+w0/ZRQGVHhFarrWqQ77C9H9qe4wk=;
        b=jCgTfuzY3Xi/FfyO0lx2uvq5fA0lVuB+u2I9budg5JdSmdUW6fkucj/6Iswn5+9u81
         S5Hii45+Igo8DnjUigtICHwVREClRsu6Tt94jvAfHqx/W4EdvzOWJfxyBJRSO/PtALZt
         511OJi7qp+hjaP2T2gNjcMes9QckyDHsJh+2BGWhGKw0M1JamoY1Gp59mcwwonYWw3jo
         YzlI/iWllIFsVn66gc/48kc2LhIAYzj4gD09j2aRz8ifMS/+7cKghKSzkamlf41sDmLH
         xwJx2x4VOpX8THrVq3tJaaLDKzBQd47kw3OExONFC73ii1Dcr8WZjUXHO6zWaFv0mYYj
         2w9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EqfJ4nsZ26w2OY+w0/ZRQGVHhFarrWqQ77C9H9qe4wk=;
        b=N01Is4iHvMqi5KY3fjT1c4Af0I2SqQYlFuXt/gK3rEaKgayQX5OeEToB6saX138ro8
         QH0fBlOPPoVIBcW1cxjLwDRnZ9qEI5DINgpK9l8BFY5aFlpWwg8+xuUrsssNkpzJjTMr
         5uCRjcT7nYTIvQ6nLY8BAYdibnEIjJnLP6LP0WoYN7gpeAMh54v5j/Svg805GuVPXdvj
         AjlF+SBK/HHXj272ZXQkmoDC/G0iOuW9CYhicvyjYFxfjgq86N9CABgAMgCr4Yn29Yed
         pn/mab6UWxWoaX6YJPyTaKapn7TwlNARHHgLGfX9OEhKVBtKA4kPnvjs+BOznc8X+xdt
         vRfQ==
X-Gm-Message-State: AOAM533z1XFMRLuU5PBUdXNMtpPeJbt2OZsSa+in93N7THad7effb1eV
        XHEEJqCtCk/SVpypyWHKXDbFDrWGKaYcN/XvWlTGKEeQJPIu1oGPr5/9eH3Vtb8mBsG8W7vnkpS
        FXg61HDjYbc3ZApZoD2OwJh75Bbgx/C52KX1fgdZBfifnEl++mBIfdEkQDw==
X-Google-Smtp-Source: ABdhPJzJVShjUP9eV6I0zKA9rrR+wmqb3KVny8yYAxYLYNtJU8sisB/xFAD1ErUlrDRx7ismNi4ONuO4ygA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:431:: with SMTP id
 a17mr6549014qvy.48.1631816142691; Thu, 16 Sep 2021 11:15:42 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:32 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-2-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 1/7] kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Updates to the kvmclock parameters needs to do a complicated dance of
KVM_REQ_MCLOCK_INPROGRESS and KVM_REQ_CLOCK_UPDATE in addition to taking
pvclock_gtod_sync_lock.  Place that in two functions that can be called
on all of master clock update, KVM_SET_CLOCK, and Hyper-V reenlightenment.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 62 +++++++++++++++------------------
 2 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..be6805fc0260 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1866,7 +1866,6 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..1082b48418c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2755,35 +2755,42 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 #endif
 }
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm)
+static void kvm_make_mclock_inprogress_request(struct kvm *kvm)
 {
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
 }
 
-static void kvm_gen_update_masterclock(struct kvm *kvm)
+static void kvm_start_pvclock_update(struct kvm *kvm)
 {
-#ifdef CONFIG_X86_64
-	int i;
-	struct kvm_vcpu *vcpu;
 	struct kvm_arch *ka = &kvm->arch;
-	unsigned long flags;
-
-	kvm_hv_invalidate_tsc_page(kvm);
 
 	kvm_make_mclock_inprogress_request(kvm);
 
 	/* no guest entries from this point */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	pvclock_update_vm_gtod_copy(kvm);
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+}
 
+static void kvm_end_pvclock_update(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
-#endif
+}
+
+static void kvm_update_masterclock(struct kvm *kvm)
+{
+	kvm_hv_invalidate_tsc_page(kvm);
+	kvm_start_pvclock_update(kvm);
+	pvclock_update_vm_gtod_copy(kvm);
+	kvm_end_pvclock_update(kvm);
 }
 
 u64 get_kvmclock_ns(struct kvm *kvm)
@@ -6079,12 +6086,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		/*
-		 * TODO: userspace has to take care of races with VCPU_RUN, so
-		 * kvm_gen_update_masterclock() can be cut down to locked
-		 * pvclock_update_vm_gtod_copy().
-		 */
-		kvm_gen_update_masterclock(kvm);
+
+		kvm_hv_invalidate_tsc_page(kvm);
+		kvm_start_pvclock_update(kvm);
+		pvclock_update_vm_gtod_copy(kvm);
 
 		/*
 		 * This pairs with kvm_guest_time_update(): when masterclock is
@@ -6093,15 +6098,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		 * is slightly ahead) here we risk going negative on unsigned
 		 * 'system_time' when 'user_ns.clock' is very small.
 		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		if (kvm->arch.use_master_clock)
 			now_ns = ka->master_kernel_ns;
 		else
 			now_ns = get_kvmclock_base_ns();
 		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-
-		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+		kvm_end_pvclock_update(kvm);
 		break;
 	}
 	case KVM_GET_CLOCK: {
@@ -8107,14 +8109,13 @@ static void tsc_khz_changed(void *data)
 static void kvm_hyperv_tsc_notifier(void)
 {
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
 	int cpu;
-	unsigned long flags;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_make_mclock_inprogress_request(kvm);
 
+	/* no guest entries from this point */
 	hyperv_stop_tsc_emulation();
 
 	/* TSC frequency always matches when on Hyper-V */
@@ -8125,16 +8126,11 @@ static void kvm_hyperv_tsc_notifier(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka = &kvm->arch;
 
-		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
+		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
 		pvclock_update_vm_gtod_copy(kvm);
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+		kvm_end_pvclock_update(kvm);
 	}
+
 	mutex_unlock(&kvm_lock);
 }
 #endif
@@ -9418,7 +9414,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
-			kvm_gen_update_masterclock(vcpu->kvm);
+			kvm_update_masterclock(vcpu->kvm);
 		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
 			kvm_gen_kvmclock_update(vcpu);
 		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
-- 
2.33.0.309.g3052b89438-goog

