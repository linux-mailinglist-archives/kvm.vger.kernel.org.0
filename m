Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A3279347
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgIYVYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbgIYVXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1E0C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t128so135390pgb.23
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZtTFMXOwk8C5vsuTGnAkh2xh9duLo4nsCMaZH0pUTdA=;
        b=hcU3avKqIN+6PuxfNZwEg93X/KJeNgORAEkZ/PriVAe96Tx0XcZJzCzEPE2Zk308c3
         8Uy6YHa9/adr0EJ8vOVKvxuRu1op+nXP6GcW4G3DIjRhF5FQGu7wECiKEeghKf/Q73Uc
         BI7q6rvz7OIWKygNEQOfxjXeyQ/G4xPzw4+gVvJlGFXaYwTID+XoGKH212jmKLu6KPML
         fVHnYqUcQsKfJQdbvTDoJe34+0+5xrK+LRiAyTyXvaskPoN5Oc3ei5qNCeY4a/n8ugUj
         JZ4VfiP6tKAR8GwiSWbzQa8V/Evl8WNdosJvh1xDb1UFQuECEjfwk9DBVdrJPXABiJKV
         zKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZtTFMXOwk8C5vsuTGnAkh2xh9duLo4nsCMaZH0pUTdA=;
        b=BeEAklqjdlZH7qJKR8rL+WcKoj3HS5Jo6zu0yzk0wg7P/0IFkMsSGnLv/WMBRYcg8G
         EufpkuPADmmlc7qd/DeCUKDWK3R7okWYS/p65xLJmN0Lw4V/PAPMu8vYL6KBeioiyXi0
         hF1ZHShPsWB4Rf9Gg5HZC/vp/ni2HWTvqlvulOC+GtS6cmsdAKs6nG95hXel2bfGOzla
         v6xesOxKOvlcRI25WVPc3GxNIRLb2v+QCiYjK0pq4KDkg3Y8DzZTWgZcBl45/QdAGhkP
         DIFnBeoCp+MjmDBVrASa9aPDxJRWk3smz4wX3pknYvyaNUAjk8hXyIrrPVc3ge4xDlR5
         bluw==
X-Gm-Message-State: AOAM533z9mtWCdlLbwQHZLt/OrBeN8uuX9Z+FIDb+XXDW6RTdmAR+LFz
        MerAHRene4I4lBp929VEEjRoxVJdhzkD
X-Google-Smtp-Source: ABdhPJzwN0bL90aFnxlyc8pnXr3MMR7bFhEqLqgmUIw+smVYRoFCKS8N7SAcu35L/W6sN7D0XNyaKt+OWDzL
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:aa7:9edb:0:b029:13e:d13d:a059 with SMTP id
 r27-20020aa79edb0000b029013ed13da059mr1088084pfq.31.1601069025715; Fri, 25
 Sep 2020 14:23:45 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:23:00 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-21-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 20/22] kvm: mmu: NX largepage recovery for TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM maps a largepage backed region at a lower level in order to
make it executable (i.e. NX large page shattering), it reduces the TLB
performance of that region. In order to avoid making this degradation
permanent, KVM must periodically reclaim shattered NX largepages by
zapping them and allowing them to be rebuilt in the page fault handler.

With this patch, the TDP MMU does not respect KVM's rate limiting on
reclaim. It traverses the entire TDP structure every time. This will be
addressed in a future patch.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++---
 arch/x86/kvm/mmu/mmu_internal.h |  4 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 66 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 +
 5 files changed, 97 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a76bcb51d43d8..cf00b1c837708 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -963,6 +963,7 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+	struct task_struct *nx_lpage_tdp_mmu_recovery_thread;
 
 	/*
 	 * Whether the TDP MMU is enabled for this VM. This contains a
@@ -977,6 +978,8 @@ struct kvm_arch {
 	struct list_head tdp_mmu_roots;
 	/* List of struct tdp_mmu_pages not being used as roots */
 	struct list_head tdp_mmu_pages;
+	struct list_head tdp_mmu_lpage_disallowed_pages;
+	u64 tdp_mmu_lpage_disallowed_page_count;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6f5093ba8f6f..6101c696e92d3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -54,12 +54,12 @@
 
 extern bool itlb_multihit_kvm_mitigation;
 
-static int __read_mostly nx_huge_pages = -1;
+int __read_mostly nx_huge_pages = -1;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
-static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
+uint __read_mostly nx_huge_pages_recovery_ratio = 0;
 #else
-static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
+uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
@@ -6455,7 +6455,7 @@ static long get_nx_lpage_recovery_timeout(u64 start_time)
 		: MAX_SCHEDULE_TIMEOUT;
 }
 
-static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
+static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t tdp_mmu)
 {
 	u64 start_time;
 	long remaining_time;
@@ -6476,7 +6476,10 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
 		if (kthread_should_stop())
 			return 0;
 
-		kvm_recover_nx_lpages(kvm);
+		if (tdp_mmu)
+			kvm_tdp_mmu_recover_nx_lpages(kvm);
+		else
+			kvm_recover_nx_lpages(kvm);
 	}
 }
 
@@ -6489,6 +6492,17 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 					  &kvm->arch.nx_lpage_recovery_thread);
 	if (!err)
 		kthread_unpark(kvm->arch.nx_lpage_recovery_thread);
+	else
+		return err;
+
+	if (!kvm->arch.tdp_mmu_enabled)
+		return err;
+
+	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 1,
+			"kvm-nx-lpage-tdp-mmu-recovery",
+			&kvm->arch.nx_lpage_tdp_mmu_recovery_thread);
+	if (!err)
+		kthread_unpark(kvm->arch.nx_lpage_tdp_mmu_recovery_thread);
 
 	return err;
 }
@@ -6497,4 +6511,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
 	if (kvm->arch.nx_lpage_recovery_thread)
 		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
+
+	if (kvm->arch.nx_lpage_tdp_mmu_recovery_thread)
+		kthread_stop(kvm->arch.nx_lpage_tdp_mmu_recovery_thread);
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1a777ccfde44e..567e119da424f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -43,6 +43,7 @@ struct kvm_mmu_page {
 	atomic_t write_flooding_count;
 
 	bool tdp_mmu_page;
+	u64 *parent_sptep;
 };
 
 extern struct kmem_cache *mmu_page_header_cache;
@@ -154,4 +155,7 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 u64 mark_spte_for_access_track(u64 spte);
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
+extern int nx_huge_pages;
+extern uint nx_huge_pages_recovery_ratio;
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 931cb469b1f2f..b83c18e29f9c6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -578,10 +578,18 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
+			if (iter.level <= max_level &&
+			    account_disallowed_nx_lpage) {
+				list_add(&sp->lpage_disallowed_link,
+					 &vcpu->kvm->arch.tdp_mmu_lpage_disallowed_pages);
+				vcpu->kvm->arch.tdp_mmu_lpage_disallowed_page_count++;
+			}
+
 			*iter.sptep = new_spte;
 			handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
 					    iter.old_spte, new_spte,
 					    iter.level);
+			sp->parent_sptep = iter.sptep;
 		}
 	}
 
@@ -1218,3 +1226,61 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+/*
+ * Clear non-leaf SPTEs and free the page tables they point to, if those SPTEs
+ * exist in order to allow execute access on a region that would otherwise be
+ * mapped as a large page.
+ */
+void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp;
+	bool flush;
+	int rcu_idx;
+	unsigned int ratio;
+	ulong to_zap;
+	u64 old_spte;
+
+	rcu_idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
+
+	while (to_zap &&
+	       !list_empty(&kvm->arch.tdp_mmu_lpage_disallowed_pages)) {
+		/*
+		 * We use a separate list instead of just using active_mmu_pages
+		 * because the number of lpage_disallowed pages is expected to
+		 * be relatively small compared to the total.
+		 */
+		sp = list_first_entry(&kvm->arch.tdp_mmu_lpage_disallowed_pages,
+				      struct kvm_mmu_page,
+				      lpage_disallowed_link);
+
+		old_spte = *sp->parent_sptep;
+		*sp->parent_sptep = 0;
+
+		list_del(&sp->lpage_disallowed_link);
+		kvm->arch.tdp_mmu_lpage_disallowed_page_count--;
+
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sp->gfn,
+				    old_spte, 0, sp->role.level + 1);
+
+		flush = true;
+
+		if (!--to_zap || need_resched() ||
+		    spin_needbreak(&kvm->mmu_lock)) {
+			flush = false;
+			kvm_flush_remote_tlbs(kvm);
+			if (to_zap)
+				cond_resched_lock(&kvm->mmu_lock);
+		}
+	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, rcu_idx);
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 2ecb047211a6d..45ea2d44545db 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
+
+void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

