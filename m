Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68E1512393
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiD0UJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiD0UJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C56D58BF19
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rfBwYJ26N8Es/7hSENLfHEbnCP+ZI4tpFxE+x8/wzk=;
        b=fZnSCOw9UuaPD/e1TZa6LWngh5RZjDXvCGUAow+4LAveQdH583rgzDYGar/ZOtVQ82Y4i7
        OL6ZoLVQ/I82x5Ha3oyIU0oIYhoQlkWYl3289SCVrpZH5Yl8/G0fjaaeLwTK9Di8jIKfO1
        2q6XdFz4TrYaYNvTN1bO2XXDTZqq2+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-eEGmp6jkPTC81hMEBShfiA-1; Wed, 27 Apr 2022 16:04:37 -0400
X-MC-Unique: eEGmp6jkPTC81hMEBShfiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0817B801E80;
        Wed, 27 Apr 2022 20:04:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63CBF9E84;
        Wed, 27 Apr 2022 20:04:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 11/19] KVM: x86: nSVM: implement shadowing of AVIC's physical id table
Date:   Wed, 27 Apr 2022 23:03:06 +0300
Message-Id: <20220427200314.276673-12-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the shadow physical id table and its
write tracking code which will be soon used for the nested AVIC.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 461 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h  |  71 +++++++
 2 files changed, 524 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e5cbbb97fbab6..f462b7e48e3ca 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -51,6 +51,433 @@ static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 
+
+static inline struct kvm_vcpu *avic_vcpu_by_l1_apicid(struct kvm *kvm,
+						      int l1_apicid)
+{
+	WARN_ON(l1_apicid == -1);
+	return kvm_get_vcpu_by_id(kvm, l1_apicid);
+}
+
+static void avic_physid_shadow_entry_set_vcpu(struct kvm *kvm,
+					      struct avic_physid_table *t,
+					      int n,
+					      int new_l1_apicid)
+{
+	struct avic_physid_entry_descr *e = &t->entries[n];
+	u64 sentry = READ_ONCE(*e->sentry);
+	u64 old_sentry = sentry;
+	struct kvm_vcpu *new_vcpu = NULL;
+	int l0_apicid = -1;
+
+	WARN_ON(!test_bit(n, t->valid_entires));
+
+	if (!list_empty(&e->link))
+		list_del_init(&e->link);
+
+	if (new_l1_apicid != -1)
+		new_vcpu = avic_vcpu_by_l1_apicid(kvm, new_l1_apicid);
+
+	if (new_vcpu)
+		l0_apicid = kvm_cpu_get_apicid(new_vcpu->cpu);
+
+	physid_entry_set_apicid(&sentry, l0_apicid);
+
+	trace_kvm_avic_physid_update_vcpu_guest(new_l1_apicid, l0_apicid);
+
+	if (sentry != old_sentry)
+		WRITE_ONCE(*e->sentry, sentry);
+}
+
+static void avic_physid_shadow_entry_create(struct kvm *kvm,
+					    struct avic_physid_table *t,
+					    int n,
+					    u64 gentry)
+{
+	struct avic_physid_entry_descr *e = &t->entries[n];
+	struct page *backing_page;
+	u64 backing_page_gpa = physid_entry_get_backing_table(gentry);
+	int l1_apic_id = physid_entry_get_apicid(gentry);
+	hpa_t backing_page_hpa;
+	u64 sentry = 0;
+
+
+	if (backing_page_gpa == INVALID_BACKING_PAGE)
+		return;
+
+	/* Pin the APIC backing page */
+	backing_page = gfn_to_page(kvm, gpa_to_gfn(backing_page_gpa));
+
+	if (is_error_page(backing_page))
+		/* Invalid GPA in the guest entry - point to a dummy entry */
+		backing_page_hpa = t->dummy_page_hpa;
+	else
+		backing_page_hpa = page_to_phys(backing_page);
+
+	physid_entry_set_backing_table(&sentry, backing_page_hpa);
+
+	e->gentry = gentry;
+	*e->sentry = sentry;
+
+	if (test_and_set_bit(n, t->valid_entires))
+		WARN_ON(1);
+
+	if (backing_page_hpa != t->dummy_page_hpa)
+		avic_physid_shadow_entry_set_vcpu(kvm, t, n, l1_apic_id);
+}
+
+static void avic_physid_shadow_entry_remove(struct kvm *kvm,
+					   struct avic_physid_table *t,
+					   int n)
+{
+	struct avic_physid_entry_descr *e = &t->entries[n];
+	hpa_t backing_page_hpa;
+
+	if (!test_and_clear_bit(n, t->valid_entires))
+		WARN_ON(1);
+
+	/* Release the APIC backing page */
+	backing_page_hpa = physid_entry_get_backing_table(*e->sentry);
+
+	if (backing_page_hpa != t->dummy_page_hpa)
+		kvm_release_pfn_dirty(backing_page_hpa >> PAGE_SHIFT);
+
+	if (!list_empty(&e->link))
+		list_del_init(&e->link);
+
+	e->gentry = 0;
+	*e->sentry = 0;
+}
+
+
+static bool
+avic_physid_shadow_table_setup_write_tracking(struct kvm *kvm,
+					      struct avic_physid_table *t,
+					      bool enable)
+{
+	struct kvm_memory_slot *slot;
+
+	write_lock(&kvm->mmu_lock);
+	slot = gfn_to_memslot(kvm, t->gfn);
+	if (!slot) {
+		write_unlock(&kvm->mmu_lock);
+		return false;
+	}
+
+	if (enable)
+		kvm_slot_page_track_add_page(kvm, slot, t->gfn, KVM_PAGE_TRACK_WRITE);
+	else
+		kvm_slot_page_track_remove_page(kvm, slot, t->gfn, KVM_PAGE_TRACK_WRITE);
+	write_unlock(&kvm->mmu_lock);
+	return true;
+}
+
+static void
+avic_physid_shadow_table_erase(struct kvm *kvm, struct avic_physid_table *t)
+{
+	int i;
+
+	if (!t->nentries)
+		return;
+
+	avic_physid_shadow_table_setup_write_tracking(kvm, t, false);
+
+	for_each_set_bit(i, t->valid_entires, AVIC_MAX_PHYSICAL_ID_COUNT)
+		avic_physid_shadow_entry_remove(kvm, t, i);
+
+	t->nentries = 0;
+	t->flood_count = 0;
+}
+
+static struct avic_physid_table *
+avic_physid_shadow_table_alloc(struct kvm *kvm, gfn_t gfn)
+{
+	struct avic_physid_entry_descr *e;
+	struct avic_physid_table *t;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	u64 *shadow_table_address;
+	int i;
+
+	if (kvm_page_track_write_tracking_enable(kvm))
+		return NULL;
+
+	lockdep_assert_held(&kvm_svm->avic.tables_lock);
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL_ACCOUNT);
+	if (!t)
+		return NULL;
+
+	t->shadow_table = alloc_page(GFP_KERNEL_ACCOUNT|__GFP_ZERO);
+	if (!t->shadow_table)
+		goto err_free_table;
+
+	shadow_table_address = page_address(t->shadow_table);
+	t->shadow_table_hpa = __sme_set(page_to_phys(t->shadow_table));
+
+	for (i = 0; i < ARRAY_SIZE(t->entries); i++) {
+		e = &t->entries[i];
+		e->sentry = &shadow_table_address[i];
+		e->gentry = 0;
+		INIT_LIST_HEAD(&e->link);
+	}
+
+	t->gfn = gfn;
+	t->refcount = 1;
+
+	list_add_tail(&t->link, &kvm_svm->avic.physid_tables);
+
+	t->dummy_page_hpa = page_to_phys(kvm_svm->avic.invalid_physid_page);
+
+	trace_kvm_avic_physid_table_alloc(gfn_to_gpa(gfn));
+	return t;
+
+err_free_table:
+	kfree(t);
+	return NULL;
+}
+
+static void
+avic_physid_shadow_table_free(struct kvm *kvm, struct avic_physid_table *t)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
+	lockdep_assert_held(&kvm_svm->avic.tables_lock);
+
+	WARN_ON(t->refcount);
+
+	avic_physid_shadow_table_erase(kvm, t);
+
+	trace_kvm_avic_physid_table_free(gfn_to_gpa(t->gfn));
+
+	hlist_del(&t->hash_link);
+	list_del(&t->link);
+	__free_page(t->shadow_table);
+	kfree(t);
+}
+
+static struct avic_physid_table *
+__avic_physid_shadow_table_get(struct hlist_head *head, gfn_t gfn)
+{
+	struct avic_physid_table *t;
+
+	hlist_for_each_entry(t, head, hash_link)
+		if (t->gfn == gfn) {
+			t->refcount++;
+			return t;
+		}
+	return NULL;
+}
+
+struct avic_physid_table *
+avic_physid_shadow_table_get(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+	struct hlist_head *hlist;
+	struct avic_physid_table *t;
+
+	mutex_lock(&kvm_svm->avic.tables_lock);
+
+	hlist = &kvm_svm->avic.physid_gpa_hash[avic_physid_hash(gfn)];
+	t = __avic_physid_shadow_table_get(hlist, gfn);
+	if (!t) {
+		t = avic_physid_shadow_table_alloc(vcpu->kvm, gfn);
+		if (!t)
+			goto out_unlock;
+		hlist_add_head(&t->hash_link, hlist);
+	}
+out_unlock:
+	mutex_unlock(&kvm_svm->avic.tables_lock);
+	return t;
+}
+
+static void
+__avic_physid_shadow_table_put(struct kvm *kvm, struct avic_physid_table *t)
+{
+	WARN_ON(t->refcount <= 0);
+	if (--t->refcount == 0)
+		avic_physid_shadow_table_free(kvm, t);
+}
+
+void avic_physid_shadow_table_put(struct kvm *kvm, struct avic_physid_table *t)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
+	mutex_lock(&kvm_svm->avic.tables_lock);
+	__avic_physid_shadow_table_put(kvm, t);
+	mutex_unlock(&kvm_svm->avic.tables_lock);
+}
+
+static void avic_physid_shadow_table_invalidate(struct kvm *kvm,
+		struct avic_physid_table *t)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
+	lockdep_assert_held(&kvm_svm->avic.tables_lock);
+	avic_physid_shadow_table_erase(kvm, t);
+}
+
+int avic_physid_shadow_table_sync(struct kvm_vcpu *vcpu,
+				  struct avic_physid_table *t, int nentries)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+	struct kvm_host_map map;
+	u64 *gentries;
+	int i;
+	int ret = 0;
+
+	mutex_lock(&kvm_svm->avic.tables_lock);
+
+	if (t->nentries >= nentries)
+		goto out_unlock;
+
+
+	trace_kvm_avic_physid_table_reload(gfn_to_gpa(t->gfn), t->nentries, nentries);
+
+	if (t->nentries == 0) {
+		if (!avic_physid_shadow_table_setup_write_tracking(vcpu->kvm, t, true)) {
+			ret = -EFAULT;
+			goto out_unlock;
+		}
+	}
+
+	if (kvm_vcpu_map(vcpu, t->gfn, &map)) {
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+
+	gentries = (u64 *)map.hva;
+
+	for (i = t->nentries ; i < nentries ; i++)
+		avic_physid_shadow_entry_create(vcpu->kvm, t, i, gentries[i]);
+
+	/* publish the table before setting nentries */
+	wmb();
+	WRITE_ONCE(t->nentries, nentries);
+
+	kvm_vcpu_unmap(vcpu, &map, false);
+out_unlock:
+	mutex_unlock(&kvm_svm->avic.tables_lock);
+	return ret;
+}
+
+static void avic_physid_shadow_table_track_write(struct kvm_vcpu *vcpu,
+						 gpa_t gpa,
+						 const u8 *new,
+						 int bytes,
+						 struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
+	struct hlist_head *hlist;
+	struct avic_physid_table *t;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	unsigned int page_offset = offset_in_page(gpa);
+	unsigned int entry_offset = page_offset & 0x7;
+	int first = page_offset / sizeof(u64);
+	int last = (page_offset + bytes - 1) / sizeof(u64);
+	u64 new_entry, old_entry;
+	int l1_apic_id;
+
+	if (WARN_ON_ONCE(bytes == 0))
+		return;
+
+	mutex_lock(&kvm_svm->avic.tables_lock);
+
+	hlist = &kvm_svm->avic.physid_gpa_hash[avic_physid_hash(gfn)];
+	t = __avic_physid_shadow_table_get(hlist, gfn);
+
+	if (!t)
+		goto out_unlock;
+
+	trace_kvm_avic_physid_table_write(gpa, bytes);
+
+	/*
+	 * Update policy:
+	 *
+	 * Only a write to a single entry, entry that had a valid backing page
+	 * on the last VM entry with this page, and only if the
+	 * write touches only the is_running and/or apic_id part of this entry
+	 * is allowed.
+	 *
+	 * Writes outside of known number of entries are ignored to support
+	 * case when the guest is adding entries to end of the page
+	 * in the process of a cpu hotplug.
+	 *
+	 * All other writes, which are not supposed to happen during
+	 * use of the page, cause the page to be invalidated,
+	 * and read as a whole, next time it is used by a vCPU for VM entry.
+	 */
+
+	if (first >= t->nentries)
+		goto out_table_put;
+
+	if (first != last || !test_bit(first, t->valid_entires))
+		goto invalidate;
+
+	/* update the entry with written bytes */
+	old_entry = t->entries[first].gentry;
+	new_entry = old_entry;
+	memcpy(((u8 *)&new_entry) + entry_offset, new, bytes);
+
+	/* if backing page changed, invalidate the whole page*/
+	if (physid_entry_get_backing_table(old_entry) !=
+				physid_entry_get_backing_table(new_entry))
+		goto invalidate;
+
+	/*
+	 * Detect write flooding to physid pages that might not be used
+	 * for the purpose anymore
+	 */
+	if (!atomic_read(&t->usecount)) {
+		if (++t->flood_count > t->nentries * AVIC_PHYSID_FLOOD_COUNT)
+			goto invalidate;
+	} else {
+		t->flood_count = 0;
+	}
+
+	/* Update the backing cpu */
+	l1_apic_id = physid_entry_get_apicid(new_entry);
+	avic_physid_shadow_entry_set_vcpu(vcpu->kvm, t, first, l1_apic_id);
+	t->entries[first].gentry = new_entry;
+	goto out_table_put;
+invalidate:
+	avic_physid_shadow_table_invalidate(vcpu->kvm, t);
+out_table_put:
+	__avic_physid_shadow_table_put(vcpu->kvm, t);
+out_unlock:
+	mutex_unlock(&kvm_svm->avic.tables_lock);
+}
+
+static void avic_physid_shadow_table_flush_memslot(struct kvm *kvm,
+						   struct kvm_memory_slot *slot,
+						   struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	struct avic_physid_table *t, *n;
+	int i;
+
+	mutex_lock(&kvm_svm->avic.tables_lock);
+
+	list_for_each_entry_safe(t, n, &kvm_svm->avic.physid_tables, link) {
+
+		if (gfn_in_memslot(slot, t->gfn)) {
+			avic_physid_shadow_table_invalidate(kvm, t);
+			continue;
+		}
+
+		for_each_set_bit(i, t->valid_entires, AVIC_MAX_PHYSICAL_ID_COUNT) {
+			u64 gentry = t->entries[i].gentry;
+			gpa_t gpa = physid_entry_get_backing_table(gentry);
+
+			if (gfn_in_memslot(slot, gpa_to_gfn(gpa))) {
+				avic_physid_shadow_table_invalidate(kvm, t);
+				break;
+			}
+		}
+	}
+	mutex_unlock(&kvm_svm->avic.tables_lock);
+}
+
+
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
  */
@@ -113,18 +540,22 @@ void avic_vm_destroy(struct kvm *kvm)
 		__free_page(avic->logical_id_table_page);
 	if (avic->physical_id_table_page)
 		__free_page(avic->physical_id_table_page);
+	if (avic->invalid_physid_page)
+		__free_page(avic->invalid_physid_page);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&avic->hnode);
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
+
+
+	kvm_page_track_unregister_notifier(kvm, &avic->write_tracker);
 }
 
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
 	int err = -ENOMEM;
-	struct page *p_page;
-	struct page *l_page;
+	struct page *page;
 	struct kvm_svm_avic *avic = &to_kvm_svm(kvm)->avic;
 	u32 vm_id;
 
@@ -132,18 +563,25 @@ int avic_vm_init(struct kvm *kvm)
 		return 0;
 
 	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!p_page)
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!page)
 		goto free_avic;
 
-	avic->physical_id_table_page = p_page;
+	avic->physical_id_table_page = page;
 
 	/* Allocating logical APIC ID table (4KB) */
-	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!l_page)
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!page)
 		goto free_avic;
 
-	avic->logical_id_table_page = l_page;
+	avic->logical_id_table_page = page;
+
+	/* Allocating a dummy page for invalid nested avic physid entries */
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!page)
+		goto free_avic;
+
+	avic->invalid_physid_page = page;
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
  again:
@@ -165,6 +603,13 @@ int avic_vm_init(struct kvm *kvm)
 	hash_add(svm_vm_data_hash, &avic->hnode, avic->vm_id);
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 
+	mutex_init(&avic->tables_lock);
+	INIT_LIST_HEAD(&avic->physid_tables);
+
+	avic->write_tracker.track_write = avic_physid_shadow_table_track_write;
+	avic->write_tracker.track_flush_slot = avic_physid_shadow_table_flush_memslot;
+
+	kvm_page_track_register_notifier(kvm, &avic->write_tracker);
 	return 0;
 
 free_avic:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dfca4c06e2071..fc15e1f938793 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/bits.h>
+#include <linux/hash.h>
 
 #include <asm/svm.h>
 #include <asm/sev-common.h>
@@ -89,13 +90,33 @@ struct kvm_sev_info {
 };
 
 
+#define AVIC_PHYSID_HASH_SHIFT 8
+#define AVIC_PHYSID_HASH_SIZE (1 << AVIC_PHYSID_HASH_SHIFT)
+
 struct kvm_svm_avic {
 	u32 vm_id;
 	struct page *logical_id_table_page;
 	struct page *physical_id_table_page;
 	struct hlist_node hnode;
+
+	struct mutex tables_lock;
+
+	/* List of all shadow tables */
+	struct list_head physid_tables;
+
+	/* GPA hash table to find a shadow table via its GPA */
+	struct hlist_head physid_gpa_hash[AVIC_PHYSID_HASH_SIZE];
+
+	struct kvm_page_track_notifier_node write_tracker;
+
+	struct page *invalid_physid_page;
 };
 
+static __always_inline unsigned int avic_physid_hash(gfn_t gfn)
+{
+	return hash_64(gfn, AVIC_PHYSID_HASH_SHIFT);
+}
+
 struct kvm_svm {
 	struct kvm kvm;
 	struct kvm_svm_avic avic;
@@ -147,6 +168,49 @@ struct vmcb_ctrl_area_cached {
 	u8 reserved_sw[32];
 };
 
+struct avic_physid_entry_descr {
+	struct list_head link;
+
+	/* cached value of guest entry */
+	u64  gentry;
+
+	/* shadow table entry pointer*/
+	u64 *sentry;
+};
+
+#define AVIC_PHYSID_FLOOD_COUNT 1000
+
+struct avic_physid_table {
+	/* List of all tables member */
+	struct list_head link;
+
+	/* GPA hash of all tables member */
+	struct hlist_node hash_link;
+
+	/* GPA of the table in guest memory*/
+	gfn_t gfn;
+
+	/* Number of entries that we shadow and which are valid*/
+	int nentries;
+	DECLARE_BITMAP(valid_entires, AVIC_MAX_PHYSICAL_ID_COUNT);
+
+	struct avic_physid_entry_descr entries[AVIC_MAX_PHYSICAL_ID_COUNT];
+
+	/* Guest visible shadow table */
+	struct page *shadow_table;
+	hpa_t shadow_table_hpa;
+	hpa_t dummy_page_hpa;
+
+	/* Number of vCPUs which have reference to this table  */
+	int refcount;
+
+	/* number of vCPUs that are in guest mode and use this table */
+	atomic_t usecount;
+
+	/* Number of writes to this page between uses of it*/
+	int flood_count;
+};
+
 struct svm_nested_state {
 	struct kvm_vmcb_info vmcb02;
 	u64 hsave_msr;
@@ -628,6 +692,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 
+struct avic_physid_table *
+avic_physid_shadow_table_get(struct kvm_vcpu *vcpu, gfn_t gfn);
+void avic_physid_shadow_table_put(struct kvm *kvm, struct avic_physid_table *t);
+int avic_physid_shadow_table_sync(struct kvm_vcpu *vcpu,
+				  struct avic_physid_table *t, int nentries);
+
+
 #define INVALID_BACKING_PAGE	(~(u64)0)
 
 static inline u64 physid_entry_get_backing_table(u64 entry)
-- 
2.26.3

