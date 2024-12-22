Return-Path: <kvm+bounces-34317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAAD9FA7D2
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:41:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7F971885DD6
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225FA1C5499;
	Sun, 22 Dec 2024 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByTZ2qUL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781A41BDA99
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896118; cv=none; b=BVIaIak32+MpopgLD3cp4qCoH352Hjqkdw4XSYnLo9lLnhsnfyChvUa9bUVGMvb7mojhKJfGgvFlq6XkDco2jtSt0O24XfqIdrX9Pipj0vCMdwwncHizK/NXi+5uMbC5/2jUcmSQZuS9yPVD2Wb9ib/7iEhuoSoEleCPqQgHXT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896118; c=relaxed/simple;
	bh=rRlBc+7v2v8hifJF8qslsmfm/NzfUgzTU9k6TgE0X6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYWdkb8/NY8Oe6W0jLnK4M9ytkXDq7SmvW38nKxS2msji8rNGtPhoqjwTTV/2iP7H7YBw3w5eMOVMFzGMFegHOiVmJCbehm8OsYWGFQzjAh8MEsn0FxCfPvonJbRl0n62bvEiYSUHPqf1qBstMEkZ73xy6SlrecJcrz5P2sq4r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ByTZ2qUL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVTghMLA7kk2pt4g/7ZP3OjTkF4JURRo7QC+8yQ+ZP8=;
	b=ByTZ2qULj2ILnIJ6xvoFYhqo/izASTZsVjPvbhOMXs8TSsV9sU6GMuHVogvRMARspMiyGC
	rF+z6m2flw52SFIg8Kj6gi2uxd2HTR/e0N/KrzNKKz8pprJJXJJ5FDFE0mLGFAw1WiCpsE
	1w+pZnl9ZL6Wd7R++5wbVkyklrzNpCE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-bMstr-c8NQaIGEkOQXQSiw-1; Sun,
 22 Dec 2024 14:35:12 -0500
X-MC-Unique: bMstr-c8NQaIGEkOQXQSiw-1
X-Mimecast-MFC-AGG-ID: bMstr-c8NQaIGEkOQXQSiw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF83C19560B8;
	Sun, 22 Dec 2024 19:35:10 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC6DA19560AA;
	Sun, 22 Dec 2024 19:35:09 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v6 18/18] KVM: x86/mmu: Prevent aliased memslot GFNs
Date: Sun, 22 Dec 2024 14:34:45 -0500
Message-ID: <20241222193445.349800-19-pbonzini@redhat.com>
In-Reply-To: <20241222193445.349800-1-pbonzini@redhat.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Add a few sanity checks to prevent memslot GFNs from ever having alias bits
set.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

For TDX, the shared half will be mapped in the higher alias, with a "shared
bit" set in the GPA. However, KVM will still manage it with the same
memslots as the private half. This means memslot looks ups and zapping
operations will be provided with a GFN without the shared bit set.

If these memslot GFNs ever had the bit that selects between the two aliases
it could lead to unexpected behavior in the complicated code that directs
faulting or zapping operations between the roots that map the two aliases.

As a safety measure, prevent memslots from being set at a GFN range that
contains the alias bit.

Also, check in the kvm_faultin_pfn() for the fault path. This later check
does less today, as the alias bits are specifically stripped from the GFN
being checked, however future code could possibly call in to the fault
handler in a way that skips this stripping. Since kvm_faultin_pfn() now
has many references to vcpu->kvm, extract it to local variable.

Link: https://lore.kernel.org/kvm/ZpbKqG_ZhCWxl-Fc@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-19-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h     |  5 +++++
 arch/x86/kvm/mmu/mmu.c | 10 +++++++---
 arch/x86/kvm/x86.c     |  3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d1775a38ffd3..878061d0063e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -313,4 +313,9 @@ static inline bool kvm_is_addr_direct(struct kvm *kvm, gpa_t gpa)
 
 	return !gpa_direct_bits || (gpa & gpa_direct_bits);
 }
+
+static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & kvm_gfn_direct_bits(kvm);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1fac5971604f..4489d192162e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4391,8 +4391,12 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 			       struct kvm_page_fault *fault, unsigned int access)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	struct kvm *kvm = vcpu->kvm;
 	int ret;
 
+	if (KVM_BUG_ON(kvm_is_gfn_alias(kvm, fault->gfn), kvm))
+		return -EFAULT;
+
 	/*
 	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
 	 * change in attributes.  is_page_fault_stale() will detect an
@@ -4406,7 +4410,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
 	 * private vs. shared mismatch.
 	 */
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
@@ -4468,7 +4472,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
 	 * to detect retry guarantees the worst case latency for the vCPU.
 	 */
-	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+	if (mmu_invalidate_retry_gfn_unsafe(kvm, fault->mmu_seq, fault->gfn))
 		return RET_PF_RETRY;
 
 	ret = __kvm_mmu_faultin_pfn(vcpu, fault);
@@ -4488,7 +4492,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * overall cost of failing to detect the invalidation until after
 	 * mmu_lock is acquired.
 	 */
-	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
+	if (mmu_invalidate_retry_gfn_unsafe(kvm, fault->mmu_seq, fault->gfn)) {
 		kvm_mmu_finish_page_fault(vcpu, fault, RET_PF_RETRY);
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad3fc35703a8..1dffea9c3b11 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13010,6 +13010,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
 			return -EINVAL;
 
+		if (kvm_is_gfn_alias(kvm, new->base_gfn + new->npages - 1))
+			return -EINVAL;
+
 		return kvm_alloc_memslot_metadata(kvm, new);
 	}
 
-- 
2.43.5


