Return-Path: <kvm+bounces-39388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 609FAA46BB1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E91D016D62C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0202B280A3E;
	Wed, 26 Feb 2025 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7lgui0k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC53280A41
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599774; cv=none; b=Q4MOhp+UN7+zh7oCubiyCf9iBxeUrUNnLpL9YilsJBVfv+jLRerbLSOSHZBAYXEwCeZjZrjmt3tvwmVx3cxv7aGz/dQLDoCMRhWyqR8OA760NWP0vUQgA2VUWaDC9pVbTnFpWk7cEp6C9VPC6HC5i+hl29gCfAQg4/45oy/jI6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599774; c=relaxed/simple;
	bh=M6biQnI0vhTOaFRQ2KtvhqOWbF0op87BMwR5488rgxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RE446mPEF1F3wWBTqmLKVdAbeT+2fguP/2Yie2+2pe2sal9GSjhAUgKeEslL2NlfqTLRrXIjrq+6AG/2rZVYcKZEZPEQYExnhq1i4Cq6oqcfBiV7BtyZB4FnLXj/OOaxUDyvxIGWkIb8NdCnx2XelLq7vT8TklT2lRuCqzln4JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7lgui0k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jV0TtFGYV1xlyHHgap+hex5QF40o3OgRCNCmWF3Bi/U=;
	b=Q7lgui0krNaq0XaerdLaoALX5Ocnea0f2Alg7XaClJ0MKJ6H7ydbWQ/skiJgQf3AMmOBd/
	EN3Tr5WLE7YR2YFGOosdE8LO9PCNLnr5mUwSUvaPUdyGQa4tArTKx8AGTXTAZcX8SuKzn1
	FTLApvjAKj9/7UcLRR/FUbCd9YjeAqY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-50-BtxgYE4cM-K1SkYwYdYBHQ-1; Wed,
 26 Feb 2025 14:56:06 -0500
X-MC-Unique: BtxgYE4cM-K1SkYwYdYBHQ-1
X-Mimecast-MFC-AGG-ID: BtxgYE4cM-K1SkYwYdYBHQ_1740599764
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FA5418D9516;
	Wed, 26 Feb 2025 19:56:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0AA519560AE;
	Wed, 26 Feb 2025 19:56:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 25/29] KVM: Add parameter "kvm" to kvm_cpu_dirty_log_size() and its callers
Date: Wed, 26 Feb 2025 14:55:25 -0500
Message-ID: <20250226195529.2314580-26-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Yan Zhao <yan.y.zhao@intel.com>

Add a parameter "kvm" to kvm_cpu_dirty_log_size() and down to its callers:
kvm_dirty_ring_get_rsvd_entries(), kvm_dirty_ring_alloc().

This is a preparation to make cpu_dirty_log_size a per-VM value rather than
a system-wide value.

No function changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         |  2 +-
 include/linux/kvm_dirty_ring.h | 11 ++++++-----
 virt/kvm/dirty_ring.c          | 11 ++++++-----
 virt/kvm/kvm_main.c            |  4 ++--
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 443c4836bc62..3caeaebda637 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1311,7 +1311,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-int kvm_cpu_dirty_log_size(void)
+int kvm_cpu_dirty_log_size(struct kvm *kvm)
 {
 	return kvm_x86_ops.cpu_dirty_log_size;
 }
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 4862c98d80d3..da4d9b5f58f1 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -32,7 +32,7 @@ struct kvm_dirty_ring {
  * If CONFIG_HAVE_HVM_DIRTY_RING not defined, kvm_dirty_ring.o should
  * not be included as well, so define these nop functions for the arch.
  */
-static inline u32 kvm_dirty_ring_get_rsvd_entries(void)
+static inline u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 {
 	return 0;
 }
@@ -42,7 +42,7 @@ static inline bool kvm_use_dirty_bitmap(struct kvm *kvm)
 	return true;
 }
 
-static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
+static inline int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
 				       int index, u32 size)
 {
 	return 0;
@@ -71,11 +71,12 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
-int kvm_cpu_dirty_log_size(void);
+int kvm_cpu_dirty_log_size(struct kvm *kvm);
 bool kvm_use_dirty_bitmap(struct kvm *kvm);
 bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
-u32 kvm_dirty_ring_get_rsvd_entries(void);
-int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
+u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm);
+int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int index, u32 size);
 
 /*
  * called with kvm->slots_lock held, returns the number of
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 7bc74969a819..d14ffc7513ee 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -11,14 +11,14 @@
 #include <trace/events/kvm.h>
 #include "kvm_mm.h"
 
-int __weak kvm_cpu_dirty_log_size(void)
+int __weak kvm_cpu_dirty_log_size(struct kvm *kvm)
 {
 	return 0;
 }
 
-u32 kvm_dirty_ring_get_rsvd_entries(void)
+u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 {
-	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
+	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size(kvm);
 }
 
 bool kvm_use_dirty_bitmap(struct kvm *kvm)
@@ -74,14 +74,15 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	KVM_MMU_UNLOCK(kvm);
 }
 
-int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
+int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
+			 int index, u32 size)
 {
 	ring->dirty_gfns = vzalloc(size);
 	if (!ring->dirty_gfns)
 		return -ENOMEM;
 
 	ring->size = size / sizeof(struct kvm_dirty_gfn);
-	ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();
+	ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries(kvm);
 	ring->dirty_index = 0;
 	ring->reset_index = 0;
 	ring->index = index;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c88acfa154e6..3187b2ae0e5b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4109,7 +4109,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 		goto vcpu_free_run_page;
 
 	if (kvm->dirty_ring_size) {
-		r = kvm_dirty_ring_alloc(&vcpu->dirty_ring,
+		r = kvm_dirty_ring_alloc(kvm, &vcpu->dirty_ring,
 					 id, kvm->dirty_ring_size);
 		if (r)
 			goto arch_vcpu_destroy;
@@ -4848,7 +4848,7 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
 		return -EINVAL;
 
 	/* Should be bigger to keep the reserved entries, or a page */
-	if (size < kvm_dirty_ring_get_rsvd_entries() *
+	if (size < kvm_dirty_ring_get_rsvd_entries(kvm) *
 	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
 		return -EINVAL;
 
-- 
2.43.5



