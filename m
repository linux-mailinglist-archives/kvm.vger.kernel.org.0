Return-Path: <kvm+bounces-63562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F957C6AE6A
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 168833A3C6F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C8331ED6E;
	Tue, 18 Nov 2025 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gsr/KvOk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6410393DF8
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485888; cv=none; b=J6s7NwFXLh/yfyG/zfUNP8EURChpX9sFMO0cmtE3H4iBMBMJd+AugOWeQxXJIJQGfksfDciO4hwi8NXrooTqS3lCyHiB+X0J3sChHO1MTPVRpsUuTW+GYiMN7rBf5bsB37D938ItTThsqOJmRmkDBtJymoqq4FVIPZ197dSlSfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485888; c=relaxed/simple;
	bh=NuQn3OfYxineh0KWDf920OOndHNl13nMc1XXtPNfvQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhO4PNpYzqgn3qY/9kvXx4BmnjfoV+6+SDxFObKajZZ2FPLpLIntwWNqvrmbSgIrmmAxyrsNk4ECVGJMalX8hMY7SZSG6sEFarJ4thkn82IxsBb+goH7/fhiZgjgCfEBZXgEb3TrxM4601tptsSR0T/o5/KcZSa48O1nI8ws/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gsr/KvOk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a219db05so17988845e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485882; x=1764090682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/+N5QsX2rcNo+FLul8FJV25DAtd4OsYln3zlGw8aLQ=;
        b=gsr/KvOkK4dVgr6eKSsL4WCDdNej0G+7iw3SwD/LyJlX9Dl75Cc5E+tNHEHcfPICut
         rlhqVs3OtKKgvQR6gP3moIqVVVtnkOAqaPh7mwKde4D0w0TQSIGtX+nFFCpZ5CT1gwkL
         wADn6EPHw0VbBmVb4yxAzojBse7CdBjRdUeU18FbHr1GTLWqrGKVw7zNTG83uihysAgc
         nu5NlpBDsewR/MGH3SlUodMLhR3TDT4SyGwJdYxu8aTdOc7WOeDLI/A6h5871/DK4Ler
         B8rowsCtqDoMKvYBx8QzeaMFSR8enX9WbG+FDKq1F5mUri5A+LbM+IWUT+/ADMzHShTX
         dH5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485882; x=1764090682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/+N5QsX2rcNo+FLul8FJV25DAtd4OsYln3zlGw8aLQ=;
        b=wf58IRDw+L2TPfqIE4nRMtmTlmpjjV0fKdhmFZYvujvlc5yfGltO/4ej6BjFXv0c6Y
         gy7dQyvS+cNzHQCtsGJYXWoDnZOCiYHmmFepzUdYwuyhklH1FOuaorsNekZAOsnAgQ/Z
         0wRNLaBxIiIPDyw0aliVp6otmtIuf6dQQV6zfQrlxdayA7hqoufbsglebSRmVo+E2A6Y
         buk3sfBJluE+wwx35WY8D4+URdZCzGq0/310NoBB0/v6BhaSZ27OhUoL51pv+FivXJ4Y
         l44w7d/mnKPszduRZ+jn2peC0Dazm6U52O5IpuI8DCPbLlWWdA2Cf5FCzrRwNpttYbjK
         1XSA==
X-Gm-Message-State: AOJu0YxMhQ6YrtbuyOjRPbC8hfqJqe0RbJZPOkH46aV/5wad7ULhOaRe
	eIdHzNxC/Zku5QppZDG6uv1hEkBe98mvULYfs+HlLlD10ixKblFUevk9cUMx7POG8eWqSA==
X-Gm-Gg: ASbGncthzHN0zKDlHGokS5m6HRjdvsjhUvdhtE7TZqESNxrxnOYqDgoDjBAG2dAlnSk
	h1xffWKavQYG67o0C/V5bkHOAnqD+P5v6wl3gO7hXpPmKQm3ReV0XFhXK8jZEYHdoWekm6C/2mU
	26Op9ON6+o1yhhaPLDl80wZAfLNQj+TRGHUolk8z9ZXt/IHe8aZp7K4mkMU7B5kBA2jbjL4tcXb
	hhYlqNSgRIeK1xmJTS7tGgsXnZ4KIJop41oV+DdfoaDjjbb0D5G6jsPpAOPhYzK4U+5D0kWKBEA
	C+v7OkAWLGV0S+og6NH+J35eZvteijBytl4p+rpvXEoTPwqmUpNgFUA1kDLDRFK9cqz/DqpkNVm
	RX7IipZY0Z/eSWHSx7QnbOOy1H8Ydp41SYmhbP7n4KN8ab0Lqmr5Gojho5vHserrMjEBY5RxXGG
	eHMMhlVfTjYbkna9M7odVWt112d8XHySCt10ltekMI/J320iiBlDjBXfmB0aB9oNyVcg1E09vku
	5Qr6n6TRh722uaXweaVtmzCnQ27Cvl1Yhunw0kSh94=
X-Google-Smtp-Source: AGHT+IHzxclG4jBwiQp70vxCA2ZAiQghW7Y5GZpasp1HpOszP3Zzx0IMeOTCiRFywIuJghT3KdWqlw==
X-Received: by 2002:a05:600c:1d16:b0:477:7c45:87b1 with SMTP id 5b1f17b1804b1-4778feb78e1mr160881775e9.36.1763485881445;
        Tue, 18 Nov 2025 09:11:21 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:20 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 02/10] KVM: pfncache: Restore guest-uses-pfn support
Date: Tue, 18 Nov 2025 17:11:05 +0000
Message-ID: <20251118171113.363528-3-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Restore functionality for guest page access tracking in pfncache,
enabling automatic vCPU request generation when cache invalidation
occurs through MMU notifier events.

This feature is critical for nested VMX operations where both KVM and L2
guest access guest-provided pages, such as APIC pages and posted
interrupt descriptors.

This change:

- Reverts commit eefb85b3f031 ("KVM: Drop unused @may_block param from
  gfn_to_pfn_cache_invalidate_start()")

- Partially reverts commit a4bff3df5147 ("KVM: pfncache: remove
  KVM_GUEST_USES_PFN usage"). Adds kvm_gpc_init_for_vcpu() to
  initialize pfncache for guest mode access, instead of the
  usage-specific flag approach.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/kvm_host.h  | 29 +++++++++++++++++++++++++-
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       |  3 ++-
 virt/kvm/kvm_mm.h         |  6 ++++--
 virt/kvm/pfncache.c       | 43 ++++++++++++++++++++++++++++++++++++---
 5 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19b8c4bebb9c..6253cf1c38c1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1402,6 +1402,9 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 			 unsigned long len);
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
+void __kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+		    struct kvm_vcpu *vcpu);
+
 /**
  * kvm_gpc_init - initialize gfn_to_pfn_cache.
  *
@@ -1412,7 +1415,11 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * immutable attributes.  Note, the cache must be zero-allocated (or zeroed by
  * the caller before init).
  */
-void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm);
+
+static inline void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
+{
+	__kvm_gpc_init(gpc, kvm, NULL);
+}
 
 /**
  * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
@@ -1494,6 +1501,26 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
  */
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
+/**
+ * kvm_gpc_init_for_vcpu - initialize gfn_to_pfn_cache for pin/unpin usage
+ *
+ * @gpc:        struct gfn_to_pfn_cache object.
+ * @vcpu:       vCPU that will pin and directly access this cache.
+ * @req:        request to send when cache is invalidated while pinned.
+ *
+ * This sets up a gfn_to_pfn_cache for use by a vCPU that will directly access
+ * the cached physical address. When the cache is invalidated while pinned,
+ * the specified request will be sent to the associated vCPU to force cache
+ * refresh.
+ *
+ * Note, the cache must be zero-allocated (or zeroed by the caller before init).
+ */
+static inline void kvm_gpc_init_for_vcpu(struct gfn_to_pfn_cache *gpc,
+					 struct kvm_vcpu *vcpu)
+{
+	__kvm_gpc_init(gpc, vcpu->kvm, vcpu);
+}
+
 static inline bool kvm_gpc_is_gpa_active(struct gfn_to_pfn_cache *gpc)
 {
 	return gpc->active && !kvm_is_error_gpa(gpc->gpa);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 490464c205b4..445170ea23e4 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -74,6 +74,7 @@ struct gfn_to_pfn_cache {
 	struct kvm_memory_slot *memslot;
 	struct kvm *kvm;
 	struct list_head list;
+	struct kvm_vcpu *vcpu;
 	rwlock_t lock;
 	struct mutex refresh_lock;
 	void *khva;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 226faeaa8e56..88de1eac5baf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -760,7 +760,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * mn_active_invalidate_count (see above) instead of
 	 * mmu_invalidate_in_progress.
 	 */
-	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
+	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
+					  hva_range.may_block);
 
 	/*
 	 * If one or more memslots were found and thus zapped, notify arch code
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccba..f1ba02084bd9 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -58,11 +58,13 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp);
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 				       unsigned long start,
-				       unsigned long end);
+				       unsigned long end,
+				       bool may_block);
 #else
 static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 						     unsigned long start,
-						     unsigned long end)
+						     unsigned long end,
+						     bool may_block)
 {
 }
 #endif /* HAVE_KVM_PFNCACHE */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b488a..543466ff40a0 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -23,9 +23,11 @@
  * MMU notifier 'invalidate_range_start' hook.
  */
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
-				       unsigned long end)
+				       unsigned long end, bool may_block)
 {
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	struct gfn_to_pfn_cache *gpc;
+	bool evict_vcpus = false;
 
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
@@ -46,8 +48,21 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 
 			write_lock_irq(&gpc->lock);
 			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >= start && gpc->uhva < end)
+			    gpc->uhva >= start && gpc->uhva < end) {
 				gpc->valid = false;
+
+				/*
+				 * If a guest vCPU could be using the physical address,
+				 * it needs to be forced out of guest mode.
+				 */
+				if (gpc->vcpu) {
+					if (!evict_vcpus) {
+						evict_vcpus = true;
+						bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+					}
+					__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
+				}
+			}
 			write_unlock_irq(&gpc->lock);
 			continue;
 		}
@@ -55,6 +70,27 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 		read_unlock_irq(&gpc->lock);
 	}
 	spin_unlock(&kvm->gpc_lock);
+
+	if (evict_vcpus) {
+		/*
+		 * KVM needs to ensure the vCPU is fully out of guest context
+		 * before allowing the invalidation to continue.
+		 */
+		unsigned int req = KVM_REQ_OUTSIDE_GUEST_MODE;
+		bool called;
+
+		/*
+		 * If the OOM reaper is active, then all vCPUs should have
+		 * been stopped already, so perform the request without
+		 * KVM_REQUEST_WAIT and be sad if any needed to be IPI'd.
+		 */
+		if (!may_block)
+			req &= ~KVM_REQUEST_WAIT;
+
+		called = kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap);
+
+		WARN_ON_ONCE(called && !may_block);
+	}
 }
 
 static bool kvm_gpc_is_valid_len(gpa_t gpa, unsigned long uhva,
@@ -382,7 +418,7 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	return __kvm_gpc_refresh(gpc, gpc->gpa, uhva);
 }
 
-void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
+void __kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
 	rwlock_init(&gpc->lock);
 	mutex_init(&gpc->refresh_lock);
@@ -391,6 +427,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 	gpc->gpa = INVALID_GPA;
 	gpc->uhva = KVM_HVA_ERR_BAD;
+	gpc->vcpu = vcpu;
 	gpc->active = gpc->valid = false;
 }
 
-- 
2.43.0


