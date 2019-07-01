Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D634EB9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFDR0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:26:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35962 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfFDR0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:26:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so13663173wrs.3;
        Tue, 04 Jun 2019 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=NfqPXqw25zfxC8REEm909jnYpuAKYcy4DP01vafdLYk=;
        b=X+X0G5/EROrlKKbWgg0zSC3qV8blFrxBFvAsuHIz6hUtzLmenGBciz4IJvXML/CF6q
         S/+LwOuw+Aoj55fujxyTDcgPa8PkZ/Waby0l5THKaSoFMpP3BVEIXyWNwyIRy0Y3nEG+
         kLNh998Yh7vUIZJSRzjCAKy0XyJz8eXXd0tvdRdMfYVVaqhdawns7MQV3QsUJbXxsmom
         /rlL4BxV1yXQpWBiYkZ+TCdVc/Yxjfxm9Map4PSABVIXtzl9UyfTyq1EBFwmYpyqd2Ty
         snCbGdqu5SMRKAQOL4uDLARR/RjEGgzPzRwSKTg3MQNVkh3TxjyL8/6t8RuY7xSn8V5M
         sAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=NfqPXqw25zfxC8REEm909jnYpuAKYcy4DP01vafdLYk=;
        b=O0qCyDR4J5mK9GN4PFprcaU5clP47PWnX0/HwKAvrw8+NBjc0OHUIolzM9n1B4ByQF
         DRMbXf05TJNrE0xqbTlp9ZOj02G2J0rkbptY9WUsDY5bd/LyG46mNPoP2Y+cgkhM04P6
         5tMo8fBMiQSMCyza7o1GGSLKFxGVuF+yzKa0Y3yo/RIe+yWkQ7YXTZzA5G4m8QyBIOa8
         n+OfnXcNlTPKKc1UKZ79vGTI8voT3FSWIltOmvDOCVtIRYZySBOv5qn+K7lomjyB/HM2
         YY87kTV9rN8IcOATsqynT+THCtFMeKpcBe5qZixgr+8VfnuDd7/nns/5dik20t1+PrG8
         tXeg==
X-Gm-Message-State: APjAAAVuC+HvTnKXdO1tqTE3WGMW1Yqw7mUldyxsIBpBZdaXvcBCiQkT
        Ot0lCg9HC53FT0J9PtbmR8udzl69
X-Google-Smtp-Source: APXvYqwRrC7JBFEreoeS/wRs2QvlOFEF9esrUNzISw9+5O5C5qwTo7ktHlBGTVtKdWlP+JadZMT5IQ==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr3582546wrp.352.1559669174739;
        Tue, 04 Jun 2019 10:26:14 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id y17sm40192777wrg.18.2019.06.04.10.26.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:26:14 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>
Subject: [PATCH] kvm: Convert kvm_lock to a mutex
Date:   Tue,  4 Jun 2019 19:26:12 +0200
Message-Id: <1559669172-87111-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

It doesn't seem as if there is any particular need for kvm_lock to be a
spinlock, so convert the lock to a mutex.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/locking.txt |  4 +---
 arch/s390/kvm/kvm-s390.c              |  4 ++--
 arch/x86/kvm/mmu.c                    |  4 ++--
 arch/x86/kvm/x86.c                    | 14 +++++++-------
 include/linux/kvm_host.h              |  2 +-
 virt/kvm/kvm_main.c                   | 30 +++++++++++++++---------------
 6 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/Documentation/virtual/kvm/locking.txt b/Documentation/virtual/kvm/locking.txt
index 1bb8bcaf8497..635cd6eaf714 100644
--- a/Documentation/virtual/kvm/locking.txt
+++ b/Documentation/virtual/kvm/locking.txt
@@ -15,8 +15,6 @@ The acquisition orders for mutexes are as follows:
 
 On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
 
-For spinlocks, kvm_lock is taken outside kvm->mmu_lock.
-
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
@@ -169,7 +167,7 @@ which time it will be set using the Dirty tracking mechanism described above.
 ------------
 
 Name:		kvm_lock
-Type:		spinlock_t
+Type:		mutex
 Arch:		any
 Protects:	- vm_list
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7936af0a971f..0fef9192f6ac 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2423,13 +2423,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
 	if (!kvm->arch.sca)
 		goto out_err;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	sca_offset += 16;
 	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
 		sca_offset = 0;
 	kvm->arch.sca = (struct bsca_block *)
 			((char *) kvm->arch.sca + sca_offset);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	sprintf(debug_name, "kvm-%u", current->pid);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 95ac393e2959..3384c539d150 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5956,7 +5956,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	int nr_to_scan = sc->nr_to_scan;
 	unsigned long freed = 0;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int idx;
@@ -5998,7 +5998,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 		break;
 	}
 
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return freed;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1ea651a6adea..d01e029faa31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6719,7 +6719,7 @@ static void kvm_hyperv_tsc_notifier(void)
 	struct kvm_vcpu *vcpu;
 	int cpu;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_make_mclock_inprogress_request(kvm);
 
@@ -6745,7 +6745,7 @@ static void kvm_hyperv_tsc_notifier(void)
 
 		spin_unlock(&ka->pvclock_gtod_sync_lock);
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 }
 #endif
 
@@ -6796,17 +6796,17 @@ static void __kvmclock_cpufreq_notifier(struct cpufreq_freqs *freq, int cpu)
 
 	smp_call_function_single(cpu, tsc_khz_changed, freq, 1);
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (vcpu->cpu != cpu)
 				continue;
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-			if (vcpu->cpu != smp_processor_id())
+			if (vcpu->cpu != raw_smp_processor_id())
 				send_ipi = 1;
 		}
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	if (freq->old < freq->new && send_ipi) {
 		/*
@@ -6929,12 +6929,12 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
 	struct kvm_vcpu *vcpu;
 	int i;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
 			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 	atomic_set(&kvm_guest_has_master_clock, 0);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 }
 
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5e9fd7ad8018..abafddb9fe2c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -162,7 +162,7 @@ static inline bool is_error_page(struct page *page)
 
 extern struct kmem_cache *kvm_vcpu_cache;
 
-extern spinlock_t kvm_lock;
+extern struct mutex kvm_lock;
 extern struct list_head vm_list;
 
 struct kvm_io_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b2579841263f..9613987ef4c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -98,7 +98,7 @@
  *	kvm->lock --> kvm->slots_lock --> kvm->irq_lock
  */
 
-DEFINE_SPINLOCK(kvm_lock);
+DEFINE_MUTEX(kvm_lock);
 static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
@@ -683,9 +683,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	preempt_notifier_inc();
 
@@ -731,9 +731,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	kvm_free_irq_routing(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++) {
 		struct kvm_io_bus *bus = kvm_get_bus(kvm, i);
@@ -4034,13 +4034,13 @@ static int vm_stat_get(void *_offset, u64 *val)
 	u64 tmp_val;
 
 	*val = 0;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vm_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
 		*val += tmp_val;
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -4053,12 +4053,12 @@ static int vm_stat_clear(void *_offset, u64 val)
 	if (val)
 		return -EINVAL;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vm_stat_clear_per_vm((void *)&stat_tmp, 0);
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	return 0;
 }
@@ -4073,13 +4073,13 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 	u64 tmp_val;
 
 	*val = 0;
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vcpu_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
 		*val += tmp_val;
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -4092,12 +4092,12 @@ static int vcpu_stat_clear(void *_offset, u64 val)
 	if (val)
 		return -EINVAL;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		stat_tmp.kvm = kvm;
 		vcpu_stat_clear_per_vm((void *)&stat_tmp, 0);
 	}
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	return 0;
 }
@@ -4118,7 +4118,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	if (!kvm_dev.this_device || !kvm)
 		return;
 
-	spin_lock(&kvm_lock);
+	mutex_lock(&kvm_lock);
 	if (type == KVM_EVENT_CREATE_VM) {
 		kvm_createvm_count++;
 		kvm_active_vms++;
@@ -4127,7 +4127,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	created = kvm_createvm_count;
 	active = kvm_active_vms;
-	spin_unlock(&kvm_lock);
+	mutex_unlock(&kvm_lock);
 
 	env = kzalloc(sizeof(*env), GFP_KERNEL_ACCOUNT);
 	if (!env)
-- 
1.8.3.1

