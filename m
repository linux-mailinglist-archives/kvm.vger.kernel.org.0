Return-Path: <kvm+bounces-42338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D11DA77FE5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C35F216BF44
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B032F211713;
	Tue,  1 Apr 2025 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJ6Noud/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B5621128D
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523891; cv=none; b=GQLxAsUILDFYkPT1y2kk/sMm6TzuslKIYWYVmJPoEpY3p3t0wJT/9wrYxjVDKsL5947fFzWthYyBiGK2aSw5XGSNvjnbd8HNJ9CKz87+yQHzLSIE2KyjYjCPaGair/7xuU7cyMYW2433oT9FHADotf2TFxTGZtWMSnKVDlavX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523891; c=relaxed/simple;
	bh=wgQBBmc1qbxZtdWIBwi2SbIZVYBQeBi9r18IbBZZndo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABgzlxDnc/pO4f+3D4I6GHrK9SenARUagv3MMSV8A8TV4zdkjwtBW0k07sMxwFwPArmSgd71QwK+58YnOI3+ljVOuCKs+2nCy3UNoYTQGOviO7UePnEQhnIw3XXP9Pk/GQybIjTKvy5vNWsAvtOXUJ8yqKRUSjAAWX6J5qcAsQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJ6Noud/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sGhYUJTD12TKfaq4UZWtS0jUt1FVjaz51Eq07OqDF4=;
	b=AJ6Noud/YEWKh8K/T4eXK+jz7ktfjh8b/3mIvK1oo17WqINdMTaxmMl+3spOum/Xwu/jq+
	/ADpqcZODyc71cIcCgTIYIsxjfKiQUZngK5rbcfY820gy5X7m+5uEIFFZot5eI0Yr68B7w
	uEkkP5CIruic5FMr5usd2W9Vx0OKZfw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-wnsSAchZN_26aC55MubfXA-1; Tue, 01 Apr 2025 12:11:26 -0400
X-MC-Unique: wnsSAchZN_26aC55MubfXA-1
X-Mimecast-MFC-AGG-ID: wnsSAchZN_26aC55MubfXA_1743523885
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d51bd9b45so37142165e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523885; x=1744128685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sGhYUJTD12TKfaq4UZWtS0jUt1FVjaz51Eq07OqDF4=;
        b=oaAPUkCKUNqJYO0J24ZyUu/+a0+Mem2bX3eCcsl4Bg0s9XkYehnhBUO3iNHcId0Rcv
         EMb9mU5XMzaQCGl/v+2vF4vBvmzIKo+k3qlthGg6j57lVuo6j0eNPwVyEG/+HTkN8Kak
         lNziSO09ujcm9XIqk7ylpcpEQv30UDY4oug2Sk908Y0TrOvKuRk8nHhrgApwE0DDFfff
         0rSZKIPDQLBIo4YEwZ2eRMNWzFukUWbXiGMesJnfUI0HFRGB1yDj4SJxO3RPh4w6vV8W
         77mRwFHQg2bmRWTycc5+F7qKz3j8Qd1+Z6hqfVtjL7gea02r5OGv5Lcf3ek5CHj+1exg
         aqig==
X-Forwarded-Encrypted: i=1; AJvYcCXyW47/9OExuFQQzgN4O81GMo6/D/EdgTPYtb5LWe70dimsidXwhxuca326Ld0c/r5cO70=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMMcI+jfrUghmr9bkzxQQ07cN6lEu9RXGfT+3aCJAi3mNpLGB6
	GKzsifwowMi+733cxcqbuSG+wBZYP+rcoWS0TRs627WWHvjN5PItPAqKqRFGXJr47NdrtpmQfbQ
	mvOsNr0nRnzISXYi5QT4wpdgljlD3lVu7utqomwY19r0RHITaZw==
X-Gm-Gg: ASbGncsCcNAWH5i4QAqwL9zq1WWRuSpQQnhBXi0HhCaDw4AkT6hG6VNnN/M9OcgVGQ4
	96CyMT1Rp30zt4u/9Ch68Q6AYMTuvE3778UBq3MeeRfoL1BoOkyBr+xIwdDpPd2Mu7oNh9leqZ/
	1cMRhgBZxngocupcWa5DRcnI7iKpGBd6y/smF9l7eOvDqOma2XmKVLzImvjc3ZCpU7HZ4Gl7LL3
	E6sCoQUoKl3GvukcFw7Wq7AxYSdPN8iTmJzzSVw02rVoCDAJPlE2mAe/JpkstanzG40VDQntkRA
	rdR/DhxKLCyGMEiylDHJ2g==
X-Received: by 2002:a05:600c:1d14:b0:43c:fe15:41e1 with SMTP id 5b1f17b1804b1-43ea7c4e878mr34970885e9.4.1743523884837;
        Tue, 01 Apr 2025 09:11:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw0KCQptOpUzsEJC9h+J15baLRxkJXWFt4YysKwcuqvA/vSlOPdWF/S+38oX+DaBh6C3XLCA==
X-Received: by 2002:a05:600c:1d14:b0:43c:fe15:41e1 with SMTP id 5b1f17b1804b1-43ea7c4e878mr34970365e9.4.1743523884345;
        Tue, 01 Apr 2025 09:11:24 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ea97895e1sm19840855e9.1.2025.04.01.09.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:23 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 06/29] KVM: move mem_attr_array to kvm_plane
Date: Tue,  1 Apr 2025 18:10:43 +0200
Message-ID: <20250401161106.790710-7-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another aspect of the VM that is now different for separate planes is
memory attributes, in order to support RWX permissions in the future.
The existing vm-level ioctls apply to plane 0 and the underlying
functionality operates on struct kvm_plane, which now hosts the
mem_attr_array xarray.

As a result, the pre/post architecture-specific callbacks also take
a plane.

Private/shared is a global attribute and only applies to plane 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 23 ++++++-----
 include/linux/kvm_host.h | 24 +++++++-----
 virt/kvm/guest_memfd.c   |  3 +-
 virt/kvm/kvm_main.c      | 85 +++++++++++++++++++++++++---------------
 4 files changed, 84 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a284dce227a0..04e4b041e248 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7670,9 +7670,11 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+bool kvm_arch_pre_set_memory_attributes(struct kvm_plane *plane,
 					struct kvm_gfn_range *range)
 {
+	struct kvm *kvm = plane->kvm;
+
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
 	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
@@ -7714,26 +7716,27 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
+static bool hugepage_has_attrs(struct kvm_plane *plane, struct kvm_memory_slot *slot,
 			       gfn_t gfn, int level, unsigned long attrs)
 {
 	const unsigned long start = gfn;
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
+		return kvm_range_has_memory_attributes(plane, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
-		    attrs != kvm_get_memory_attributes(kvm, gfn))
+		    attrs != kvm_get_plane_memory_attributes(plane, gfn))
 			return false;
 	}
 	return true;
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+bool kvm_arch_post_set_memory_attributes(struct kvm_plane *plane,
 					 struct kvm_gfn_range *range)
 {
+	struct kvm *kvm = plane->kvm;
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -7767,7 +7770,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 			 */
 			if (gfn >= slot->base_gfn &&
 			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
-				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+				if (hugepage_has_attrs(plane, slot, gfn, level, attrs))
 					hugepage_clear_mixed(slot, gfn, level);
 				else
 					hugepage_set_mixed(slot, gfn, level);
@@ -7789,7 +7792,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 		 */
 		if (gfn < range->end &&
 		    (gfn + nr_pages) <= (slot->base_gfn + slot->npages)) {
-			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+			if (hugepage_has_attrs(plane, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
 			else
 				hugepage_set_mixed(slot, gfn, level);
@@ -7801,11 +7804,13 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 					    struct kvm_memory_slot *slot)
 {
+	struct kvm_plane *plane0;
 	int level;
 
 	if (!kvm_arch_has_private_mem(kvm))
 		return;
 
+	plane0 = kvm->planes[0];
 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
 		/*
 		 * Don't bother tracking mixed attributes for pages that can't
@@ -7825,9 +7830,9 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 		 * be manually checked as the attributes may already be mixed.
 		 */
 		for (gfn = start; gfn < end; gfn += nr_pages) {
-			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
+			unsigned long attrs = kvm_get_plane_memory_attributes(plane0, gfn);
 
-			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+			if (hugepage_has_attrs(plane0, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
 			else
 				hugepage_set_mixed(slot, gfn, level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 98bae5dc3515..4d408d1d5ccc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -763,6 +763,10 @@ struct kvm_memslots {
 
 struct kvm_plane {
 	struct kvm *kvm;
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	struct xarray mem_attr_array;
+#endif
 	int plane;
 
 	struct kvm_arch_plane arch;
@@ -875,10 +879,6 @@ struct kvm {
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
-#endif
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
-	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
@@ -2511,20 +2511,26 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+static inline unsigned long kvm_get_plane_memory_attributes(struct kvm_plane *plane, gfn_t gfn)
 {
-	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+	return xa_to_value(xa_load(&plane->mem_attr_array, gfn));
 }
 
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	return kvm_get_plane_memory_attributes(kvm->planes[0], gfn);
+}
+
+bool kvm_range_has_memory_attributes(struct kvm_plane *plane, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+bool kvm_arch_pre_set_memory_attributes(struct kvm_plane *plane,
 					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+bool kvm_arch_post_set_memory_attributes(struct kvm_plane *plane,
 					 struct kvm_gfn_range *range);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
+	/* Private/shared is always in plane 0 */
 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..f07102bcaf24 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -642,6 +642,7 @@ EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
+	struct kvm_plane *plane0 = kvm->planes[0];
 	struct file *file;
 	struct kvm_memory_slot *slot;
 	void __user *p;
@@ -694,7 +695,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
+		while (!kvm_range_has_memory_attributes(plane0, gfn, gfn + (1 << max_order),
 							KVM_MEMORY_ATTRIBUTE_PRIVATE,
 							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
 			if (!max_order)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b44a7f9e52e..e343905e46d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -500,6 +500,7 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 }
 
 typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+typedef bool (*plane_gfn_handler_t)(struct kvm_plane *plane, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
 
@@ -511,7 +512,11 @@ struct kvm_mmu_notifier_range {
 	u64 start;
 	u64 end;
 	union kvm_mmu_notifier_arg arg;
-	gfn_handler_t handler;
+	/* The only difference is the type of the first parameter.  */
+	union {
+		gfn_handler_t handler;
+		plane_gfn_handler_t handler_plane;
+	};
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
@@ -1105,6 +1110,9 @@ static struct kvm_plane *kvm_create_vm_plane(struct kvm *kvm, unsigned plane_id)
 	plane->kvm = kvm;
 	plane->plane = plane_id;
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	xa_init(&plane->mem_attr_array);
+#endif
 	kvm_arch_init_plane(plane);
 	return plane;
 }
@@ -1130,9 +1138,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_init(&kvm->mem_attr_array);
-#endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
@@ -1280,6 +1285,10 @@ static void kvm_destroy_devices(struct kvm *kvm)
 static void kvm_destroy_plane(struct kvm_plane *plane)
 {
 	kvm_arch_free_plane(plane);
+
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	xa_destroy(&plane->mem_attr_array);
+#endif
 }
 
 static void kvm_destroy_vm(struct kvm *kvm)
@@ -1335,9 +1344,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	}
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_destroy(&kvm->mem_attr_array);
-#endif
 	for (i = 0; i < ARRAY_SIZE(kvm->planes); i++) {
 		struct kvm_plane *plane = kvm->planes[i];
 		if (plane)
@@ -2385,9 +2391,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
+static u64 kvm_supported_mem_attributes(struct kvm_plane *plane)
 {
-	if (!kvm || kvm_arch_has_private_mem(kvm))
+	if (!plane || (!plane->plane && kvm_arch_has_private_mem(plane->kvm)))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
 	return 0;
@@ -2397,19 +2403,20 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
  * such that the bits in @mask match @attrs.
  */
-bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+bool kvm_range_has_memory_attributes(struct kvm_plane *plane,
+				     gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
-	XA_STATE(xas, &kvm->mem_attr_array, start);
+	XA_STATE(xas, &plane->mem_attr_array, start);
 	unsigned long index;
 	void *entry;
 
-	mask &= kvm_supported_mem_attributes(kvm);
+	mask &= kvm_supported_mem_attributes(plane);
 	if (attrs & ~mask)
 		return false;
 
 	if (end == start + 1)
-		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
+		return (kvm_get_plane_memory_attributes(plane, start) & mask) == attrs;
 
 	guard(rcu)();
 	if (!attrs)
@@ -2428,8 +2435,8 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return true;
 }
 
-static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
-						 struct kvm_mmu_notifier_range *range)
+static __always_inline void __kvm_handle_gfn_range(struct kvm *kvm, void *arg1,
+						   struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
@@ -2469,7 +2476,7 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 					range->on_lock(kvm);
 			}
 
-			ret |= range->handler(kvm, &gfn_range);
+			ret |= range->handler(arg1, &gfn_range);
 		}
 	}
 
@@ -2480,7 +2487,19 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
+static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
+						 struct kvm_mmu_notifier_range *range)
+{
+	__kvm_handle_gfn_range(kvm, kvm, range);
+}
+
+static __always_inline void kvm_plane_handle_gfn_range(struct kvm_plane *plane,
+						       struct kvm_mmu_notifier_range *range)
+{
+	__kvm_handle_gfn_range(plane->kvm, plane, range);
+}
+
+static bool kvm_pre_set_memory_attributes(struct kvm_plane *plane,
 					  struct kvm_gfn_range *range)
 {
 	/*
@@ -2494,20 +2513,21 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 	 * but it's not obvious that allowing new mappings while the attributes
 	 * are in flux is desirable or worth the complexity.
 	 */
-	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
+	kvm_mmu_invalidate_range_add(plane->kvm, range->start, range->end);
 
-	return kvm_arch_pre_set_memory_attributes(kvm, range);
+	return kvm_arch_pre_set_memory_attributes(plane, range);
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+static int kvm_vm_set_mem_attributes(struct kvm_plane *plane, gfn_t start, gfn_t end,
 				     unsigned long attributes)
 {
+	struct kvm *kvm = plane->kvm;
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_pre_set_memory_attributes,
+		.handler_plane = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
 		.may_block = true,
@@ -2516,7 +2536,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.start = start,
 		.end = end,
 		.arg.attributes = attributes,
-		.handler = kvm_arch_post_set_memory_attributes,
+		.handler_plane = kvm_arch_post_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
 	};
@@ -2529,7 +2549,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
+	if (kvm_range_has_memory_attributes(plane, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
@@ -2537,27 +2557,28 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	 * partway through setting the new attributes.
 	 */
 	for (i = start; i < end; i++) {
-		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
+		r = xa_reserve(&plane->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
 		if (r)
 			goto out_unlock;
 	}
 
-	kvm_handle_gfn_range(kvm, &pre_set_range);
+	kvm_plane_handle_gfn_range(plane, &pre_set_range);
 
 	for (i = start; i < end; i++) {
-		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
+		r = xa_err(xa_store(&plane->mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
 	}
 
-	kvm_handle_gfn_range(kvm, &post_set_range);
+	kvm_plane_handle_gfn_range(plane, &post_set_range);
 
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
 
 	return r;
 }
-static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
+
+static int kvm_vm_ioctl_set_mem_attributes(struct kvm_plane *plane,
 					   struct kvm_memory_attributes *attrs)
 {
 	gfn_t start, end;
@@ -2565,7 +2586,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	/* flags is currently not used. */
 	if (attrs->flags)
 		return -EINVAL;
-	if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
+	if (attrs->attributes & ~kvm_supported_mem_attributes(plane))
 		return -EINVAL;
 	if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
 		return -EINVAL;
@@ -2582,7 +2603,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_vm_set_mem_attributes(plane, start, end, attrs->attributes);
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
@@ -4867,7 +4888,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	case KVM_CAP_MEMORY_ATTRIBUTES:
-		return kvm_supported_mem_attributes(kvm);
+		return kvm_supported_mem_attributes(kvm ? kvm->planes[0] : NULL);
 #endif
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
@@ -5274,7 +5295,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		if (copy_from_user(&attrs, argp, sizeof(attrs)))
 			goto out;
 
-		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
+		r = kvm_vm_ioctl_set_mem_attributes(kvm->planes[0], &attrs);
 		break;
 	}
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
-- 
2.49.0


