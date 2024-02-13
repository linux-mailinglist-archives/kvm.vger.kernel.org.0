Return-Path: <kvm+bounces-8632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3578853AD6
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1938A1F21807
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 19:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAE760878;
	Tue, 13 Feb 2024 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xtfk4dyZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466E1605BB
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 19:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852227; cv=none; b=p8HQQf1lPN2d0MIEtbMIHMbWTubRBKXuQAi2ATcZ/OGGw4y7cwLqsVd2Pfn8heOQqrXg7Lvjk7szvaQvXyqE7O5Kv4Tayl7IVe54QhqFFlUCTiP2lupaPLfu6kXICHMAWtaffxIi6vvdvdpAGZq6TRoXSsFrEmWyH2Y/ghL91ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852227; c=relaxed/simple;
	bh=EOHvK7uHwUOOmi6bfq5xmfA3oU4UQjOOq5ueZxiclP4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CJ2Jlv92JBUozOTeYVpNZw+VqhMreJcmZ9rcC1mTAZuVhihwHAK1EZh7fX0mY8aY1f6D2s/kiq35Oaakgb9D5b+J6EAdtiheHhnlHmIocGL5g6Gb+5vA9KxX+4+z7/2VJnkXdTPSrUCJm5GRFVaDMafcLxw1aslT0vdm+E4qhmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--avagin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xtfk4dyZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--avagin.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cf2714e392so73646a12.0
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 11:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707852225; x=1708457025; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ExCkZDXy1AVqJwQCfKejHjr8UJa3r0tbqmV1p94ofSE=;
        b=Xtfk4dyZhI0vBzCcdIXjEIN10AxO9dOvPwC+1GDbYeiIAXciPS0dX6SciiLHTZjhz7
         ZQITVfo4d9bk2YDA4gV6QjXH3wg1VmCks8J4WFzO0IL4CK9BUumN8T0B2JfD4BHbbm9H
         UxyCBwzNUDeRvrupekPFkDlaV4p0CztMhSNC4pXWZ4OWjZj5Gjny0dym0uVg5eXYcLal
         Mt8MAgrtpKkHweniXcrGRRa7CCaD8Mvo0mkxVapek+HfmJBXfr3vUHkpiY30aBFWKbBk
         y1OgtNs0tvY7JcG2TUpLSCx33CQ9s7bztJkGUQA6XRTIaza2P0g6lQF7Wnseoj3eSe9w
         tX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852225; x=1708457025;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ExCkZDXy1AVqJwQCfKejHjr8UJa3r0tbqmV1p94ofSE=;
        b=uVFNTTWjpN2gLreBt+qly6qn0YayVM2hrUUUCpMjRme5jn8eBnI3/Q0jjA7eXfUksi
         FWBxkxgA48jqpJ0Knj9w1RAgmFq7/16pAOteo5ZhTi+JGQqw2Xhi++VjpPgInOtyZg42
         9GKCF4E0Pf6NTUBiw2byMN+k/GpxkjO/KiyxSwJO4cX8tilAhBn01jWwTQrTR7ixVBh+
         iyXFAoSVcrwohOepXalrPKcCQLZxIgQDmUYBS16OA+NxLV9iu8eKVburSWuUQPaYr8BA
         6FlBF0Vg07qfbOgCFKsNC6YWFstqgfPs3zui6YkJAljx2hNqPPNWrX0mxFu+CZsTcxHe
         +owg==
X-Forwarded-Encrypted: i=1; AJvYcCVCuV9yTr5s+T3Gu+272uQAiXWa8hiL/GZm2UGKy+9/pzXvIrfzUrekCx5fXEMBNXlsHRUrFi7z45/i2TtvAW9nNOLZ
X-Gm-Message-State: AOJu0YyZXdLvre5vn2GPEjjBHDJJdilouOJJ393hpydzFYnp4I8Jue+7
	WNbK3m6qrOEOFdIx0/DFNS/yqbjEEGH5ogO3MgnFIzyLj8X28N67UEqP8DIyoIkP8Qzq4J5H1tU
	z7Q==
X-Google-Smtp-Source: AGHT+IGWi17+EWwj8QqOfMRs/2jzz/wVTn/vSsPpoGbcqSiLu03AJPhqfVkvu4BORpV18AnDW+7qh37OIBA=
X-Received: from avagin.kir.corp.google.com ([2620:0:1008:10:4c28:d6b4:a5c2:fc22])
 (user=avagin job=sendgmr) by 2002:a05:6a02:a09:b0:5dc:8203:7285 with SMTP id
 cm9-20020a056a020a0900b005dc82037285mr1275pgb.0.1707852225590; Tue, 13 Feb
 2024 11:23:45 -0800 (PST)
Date: Tue, 13 Feb 2024 11:23:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240213192340.2023366-1-avagin@google.com>
Subject: [PATCH v3] kvm/x86: allocate the write-tracking metadata on-demand
From: Andrei Vagin <avagin@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	Andrei Vagin <avagin@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

The write-track is used externally only by the gpu/drm/i915 driver.
Currently, it is always enabled, if a kernel has been compiled with this
driver.

Enabling the write-track mechanism adds a two-byte overhead per page across
all memory slots. It isn't significant for regular VMs. However in gVisor,
where the entire process virtual address space is mapped into the VM, even
with a 39-bit address space, the overhead amounts to 256MB.

Rework the write-tracking mechanism to enable it on-demand in
kvm_page_track_register_notifier.

Here is Sean's comment about the locking scheme:

The only potential hiccup would be if taking slots_arch_lock would
deadlock, but it should be impossible for slots_arch_lock to be taken in
any other path that involves VFIO and/or KVMGT *and* can be coincident.
Except for kvm_arch_destroy_vm() (which deletes KVM's internal
memslots), slots_arch_lock is taken only through KVM ioctls(), and the
caller of kvm_page_track_register_notifier() *must* hold a reference to
the VM.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
v1: https://lore.kernel.org/lkml/ZcErs9rPqT09nNge@google.com/T/
v2: allocate the write-tracking metadata on-demand
    https://lore.kernel.org/kvm/20240206153405.489531-1-avagin@google.com/
v3: explicitly track if there are *external* write tracking users.

 arch/x86/include/asm/kvm_host.h |  9 +++++
 arch/x86/kvm/mmu/page_track.c   | 68 ++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d271ba20a0b2..a777ac77b3ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1468,6 +1468,15 @@ struct kvm_arch {
 	 */
 	bool shadow_root_allocated;
 
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+	/*
+	 * If set, the VM has (or had) an external write tracking user, and
+	 * thus all write tracking metadata has been allocated, even if KVM
+	 * itself isn't using write tracking.
+	 */
+	bool external_write_tracking_enabled;
+#endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a04..f6448284c18e 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -20,10 +20,23 @@
 #include "mmu_internal.h"
 #include "page_track.h"
 
+static bool kvm_external_write_tracking_enabled(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+	/*
+	 * Read external_write_tracking_enabled before related pointers.  Pairs
+	 * with the smp_store_release in kvm_page_track_write_tracking_enable().
+	 */
+	return smp_load_acquire(&kvm->arch.external_write_tracking_enabled);
+#else
+	return false;
+#endif
+}
+
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
-	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
-	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
+	return kvm_external_write_tracking_enabled(kvm) ||
+	       kvm_shadow_root_allocated(kvm) || !tdp_enabled;
 }
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
@@ -153,6 +166,50 @@ int kvm_page_track_init(struct kvm *kvm)
 	return init_srcu_struct(&head->track_srcu);
 }
 
+static int kvm_enable_external_write_tracking(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0, i, bkt;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Check for *any* write tracking user (not just external users) under
+	 * lock.  This avoids unnecessary work, e.g. if KVM itself is using
+	 * write tracking, or if two external users raced when registering.
+	 */
+	if (kvm_page_track_write_tracking_enabled(kvm))
+		goto out_success;
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, bkt, slots) {
+			/*
+			 * Intentionally do NOT free allocations on failure to
+			 * avoid having to track which allocations were made
+			 * now versus when the memslot was created.  The
+			 * metadata is guaranteed to be freed when the slot is
+			 * freed, and will be kept/used if userspace retries
+			 * the failed ioctl() instead of killing the VM.
+			 */
+			r = kvm_page_track_write_tracking_alloc(slot);
+			if (r)
+				goto out_unlock;
+		}
+	}
+
+out_success:
+	/*
+	 * Ensure that external_write_tracking_enabled becomes true strictly
+	 * after all the related pointers are set.
+	 */
+	smp_store_release(&kvm->arch.external_write_tracking_enabled, true);
+out_unlock:
+	mutex_unlock(&kvm->slots_arch_lock);
+	return r;
+}
+
 /*
  * register the notifier so that event interception for the tracked guest
  * pages can be received.
@@ -161,10 +218,17 @@ int kvm_page_track_register_notifier(struct kvm *kvm,
 				     struct kvm_page_track_notifier_node *n)
 {
 	struct kvm_page_track_notifier_head *head;
+	int r;
 
 	if (!kvm || kvm->mm != current->mm)
 		return -ESRCH;
 
+	if (!kvm_external_write_tracking_enabled(kvm)) {
+		r = kvm_enable_external_write_tracking(kvm);
+		if (r)
+			return r;
+	}
+
 	kvm_get_kvm(kvm);
 
 	head = &kvm->arch.track_notifier_head;
-- 
2.43.0.687.g38aa6559b0-goog


