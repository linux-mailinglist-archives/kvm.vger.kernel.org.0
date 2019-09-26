Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA2ABFBCE
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfIZXSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:54 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:34332 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfIZXSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:53 -0400
Received: by mail-yw1-f74.google.com with SMTP id u131so682903ywa.1
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YTeM/yG0z9GHNFu6KUcb+DaUxituIo1MCdiiAiyqIs0=;
        b=SW7G1l0E3/jxIMely99rYls+zRqK3Gbmtow7AR/A6/Gz7NMa5fst+XyG1d3R1kLLan
         i8wWmTcNr8puqVl4nqSIAlQ6jOmK28E9CgeBDwtYt5tSX4xRRt4faQ69p2iRk51HFRW1
         HBkkMCqLyHMEeQmU7TGTDhtRsTjptmhxOxV2gsnimMHOrH/M4VInJ8w5UX0IgXdOwjd8
         XjVyCsPfY5Vjhy+DWpmv3uQBodnjJv1nNXSb0oo3mwMVnqhdoo1pA2M9Xui9ZsRl/9nf
         fR+/hsR1PmeGlH3MTS7xzYIYvoTd4BQztoFUqt5wMvfATht3509GIAkQwpUWbCSaqdH8
         ZOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YTeM/yG0z9GHNFu6KUcb+DaUxituIo1MCdiiAiyqIs0=;
        b=HsV67cxAdmP5mElv/Y1+eoxFWUSjnSfHEDygvefGnSwvlUbOEzAqzRLjB129ReCOUp
         vB8u43rGRM5zIGnawe+G8i+09yuslAfmiZWrG4Bh2xn7Us6CvfHoTXMr5ASOv2e+AzmY
         YorBUj7npkXvwdoTaBR0jWlmkygzejEXTOTOsJnmy/pntmCMgUoAYQ3fYSYYbsJZd5iq
         Oy4FuNvHf7Y6wH1wCmXmWObwI6kCL8QixpGgJrdJj0J/3O+6uMpR1j0rRxY6j24R5dcE
         Twjb0CAk2ylSPgZ1qSybZpy52U2AiFkSNWMS7GcyehP7CgYzeC/MpzN/DBee5CYIs0Ac
         O4UQ==
X-Gm-Message-State: APjAAAUAI7jV4aoplE0e5Fyw1eZ5FNdoHPj8z/wzPm2Xf4giSXDS+3G5
        MesZAtfoBGsQCmqL1u4Mh7d7Fuqg8HBgpj2DNj1ricLSHtAAg3wpSQDDppJkjuIXBwcA1IVNAHL
        PSgOHqSiwkJNamxCO/hzoyFWedWlkb1lINRec2wGY8zyDik3h/97WO3Ahbjwg
X-Google-Smtp-Source: APXvYqx21m+7OPniJOumsOcNtmlKWsjH5VaiFr1fi0Y7z9PWchrV+fsZu2Fghy6Rn4CRvsQxCQSeB/wywP3l
X-Received: by 2002:a81:ca43:: with SMTP id y3mr762810ywk.432.1569539931047;
 Thu, 26 Sep 2019 16:18:51 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:06 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-11-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 10/28] kvm: mmu: Flush TLBs before freeing direct MMU page
 table memory
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If page table memory is freed before a TLB flush, it can result in
improper guest access to memory through paging structure caches.
Specifically, until a TLB flush, memory that was part of the paging
structure could be used by the hardware for address translation if a
partial walk leading to it is stored in the paging structure cache. Ensure
that there is a TLB flush before page table memory is freed by
transferring disconnected pages to a disconnected list, and on a flush
transferring a snapshot of the disconnected list to a free list. The free
list is processed asynchronously to avoid slowing TLB flushes.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |   5 ++
 arch/x86/kvm/Kconfig            |   1 +
 arch/x86/kvm/mmu.c              | 127 ++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h        |   1 +
 virt/kvm/kvm_main.c             |   9 ++-
 5 files changed, 136 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1f8164c577d50..9bf149dce146d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -974,6 +974,11 @@ struct kvm_arch {
 	 */
 	bool pure_direct_mmu;
 	hpa_t direct_root_hpa[KVM_ADDRESS_SPACE_NUM];
+	spinlock_t direct_mmu_disconnected_pts_lock;
+	struct list_head direct_mmu_disconnected_pts;
+	spinlock_t direct_mmu_pt_free_list_lock;
+	struct list_head direct_mmu_pt_free_list;
+	struct work_struct direct_mmu_free_work;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 840e12583b85b..7c615f3cebf8f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -45,6 +45,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9fe57ef7baa29..317e9238f17b2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1700,6 +1700,100 @@ static void free_pt_rcu_callback(struct rcu_head *rp)
 	free_page((unsigned long)disconnected_pt);
 }
 
+/*
+ * Takes a snapshot of, and clears, the direct MMU disconnected pt list. Once
+ * TLBs have been flushed, this snapshot can be transferred to the direct MMU
+ * PT free list to be freed.
+ */
+static void direct_mmu_cut_disconnected_pt_list(struct kvm *kvm,
+						struct list_head *snapshot)
+{
+	spin_lock(&kvm->arch.direct_mmu_disconnected_pts_lock);
+	list_splice_tail_init(&kvm->arch.direct_mmu_disconnected_pts, snapshot);
+	spin_unlock(&kvm->arch.direct_mmu_disconnected_pts_lock);
+}
+
+/*
+ * Takes a snapshot of, and clears, the direct MMU PT free list and then sets
+ * each page in the snapshot to be freed after an RCU grace period.
+ */
+static void direct_mmu_process_pt_free_list(struct kvm *kvm)
+{
+	LIST_HEAD(free_list);
+	struct page *page;
+	struct page *next;
+
+	spin_lock(&kvm->arch.direct_mmu_pt_free_list_lock);
+	list_splice_tail_init(&kvm->arch.direct_mmu_pt_free_list, &free_list);
+	spin_unlock(&kvm->arch.direct_mmu_pt_free_list_lock);
+
+	list_for_each_entry_safe(page, next, &free_list, lru) {
+		list_del(&page->lru);
+		/*
+		 * Free the pt page in an RCU callback, once it's safe to do
+		 * so.
+		 */
+		call_rcu(&page->rcu_head, free_pt_rcu_callback);
+	}
+}
+
+static void direct_mmu_free_work_fn(struct work_struct *work)
+{
+	struct kvm *kvm = container_of(work, struct kvm,
+				       arch.direct_mmu_free_work);
+
+	direct_mmu_process_pt_free_list(kvm);
+}
+
+/*
+ * Propagate a snapshot of the direct MMU disonnected pt list to the direct MMU
+ * PT free list, after TLBs have been flushed. Schedule work to free the pages
+ * in the direct MMU PT free list.
+ */
+static void direct_mmu_process_free_list_async(struct kvm *kvm,
+					       struct list_head *snapshot)
+{
+	spin_lock(&kvm->arch.direct_mmu_pt_free_list_lock);
+	list_splice_tail_init(snapshot, &kvm->arch.direct_mmu_pt_free_list);
+	spin_unlock(&kvm->arch.direct_mmu_pt_free_list_lock);
+
+	schedule_work(&kvm->arch.direct_mmu_free_work);
+}
+
+/*
+ * To be used during teardown once all VCPUs are paused. Ensures that the
+ * direct MMU disconnected PT and PT free lists are emptied and outstanding
+ * page table memory freed.
+ */
+static void direct_mmu_process_pt_free_list_sync(struct kvm *kvm)
+{
+	LIST_HEAD(snapshot);
+
+	cancel_work_sync(&kvm->arch.direct_mmu_free_work);
+	direct_mmu_cut_disconnected_pt_list(kvm, &snapshot);
+
+	spin_lock(&kvm->arch.direct_mmu_pt_free_list_lock);
+	list_splice_tail_init(&snapshot, &kvm->arch.direct_mmu_pt_free_list);
+	spin_unlock(&kvm->arch.direct_mmu_pt_free_list_lock);
+
+	direct_mmu_process_pt_free_list(kvm);
+}
+
+/*
+ * Add a page of memory that has been disconnected from the paging structure to
+ * a queue to be freed. This is a two step process: after a page has been
+ * disconnected, the TLBs must be flushed, and an RCU grace period must elapse
+ * before the memory can be freed.
+ */
+static void direct_mmu_disconnected_pt_list_add(struct kvm *kvm,
+						struct page *page)
+{
+	spin_lock(&kvm->arch.direct_mmu_disconnected_pts_lock);
+	list_add_tail(&page->lru, &kvm->arch.direct_mmu_disconnected_pts);
+	spin_unlock(&kvm->arch.direct_mmu_disconnected_pts_lock);
+}
+
+
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 			       u64 old_pte, u64 new_pte, int level);
 
@@ -1760,12 +1854,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 		gfn += KVM_PAGES_PER_HPAGE(level);
 	}
 
-	/*
-	 * Free the pt page in an RCU callback, once it's safe to do
-	 * so.
-	 */
 	page = pfn_to_page(pfn);
-	call_rcu(&page->rcu_head, free_pt_rcu_callback);
+	direct_mmu_disconnected_pt_list_add(kvm, page);
 }
 
 /**
@@ -5813,6 +5903,12 @@ static int kvm_mmu_init_direct_mmu(struct kvm *kvm)
 	kvm->arch.direct_mmu_enabled = true;
 
 	kvm->arch.pure_direct_mmu = true;
+	spin_lock_init(&kvm->arch.direct_mmu_disconnected_pts_lock);
+	INIT_LIST_HEAD(&kvm->arch.direct_mmu_disconnected_pts);
+	spin_lock_init(&kvm->arch.direct_mmu_pt_free_list_lock);
+	INIT_LIST_HEAD(&kvm->arch.direct_mmu_pt_free_list);
+	INIT_WORK(&kvm->arch.direct_mmu_free_work, direct_mmu_free_work_fn);
+
 	return 0;
 err:
 	for (i = 0; i < ARRAY_SIZE(kvm->arch.direct_root_hpa); i++) {
@@ -5831,6 +5927,8 @@ static void kvm_mmu_uninit_direct_mmu(struct kvm *kvm)
 	if (!kvm->arch.direct_mmu_enabled)
 		return;
 
+	direct_mmu_process_pt_free_list_sync(kvm);
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		handle_disconnected_pt(kvm, i, 0,
 			(kvm_pfn_t)(kvm->arch.direct_root_hpa[i] >> PAGE_SHIFT),
@@ -6516,3 +6614,22 @@ void kvm_mmu_module_exit(void)
 	unregister_shrinker(&mmu_shrinker);
 	mmu_audit_disable();
 }
+
+void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	LIST_HEAD(disconnected_snapshot);
+
+	if (kvm->arch.direct_mmu_enabled)
+		direct_mmu_cut_disconnected_pt_list(kvm,
+						    &disconnected_snapshot);
+
+	/*
+	 * Synchronously flush the TLBs before processing the direct MMU free
+	 * list.
+	 */
+	__kvm_flush_remote_tlbs(kvm);
+
+	if (kvm->arch.direct_mmu_enabled)
+		direct_mmu_process_free_list_async(kvm, &disconnected_snapshot);
+}
+EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index baed80f8a7f00..350a3b79cc8d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -786,6 +786,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
+void __kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9ce067b6882b7..c8559a86625ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -255,8 +255,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	return called;
 }
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+void __kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	/*
 	 * Read tlbs_dirty before setting KVM_REQ_TLB_FLUSH in
@@ -280,6 +279,12 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.remote_tlb_flush;
 	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
+
+#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
+void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	__kvm_flush_remote_tlbs(kvm);
+}
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
 
-- 
2.23.0.444.g18eeb5a265-goog

