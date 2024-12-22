Return-Path: <kvm+bounces-34300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 213149FA7AF
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F84D188567B
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC13191F62;
	Sun, 22 Dec 2024 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TzSRCRAz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9E14375C
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896096; cv=none; b=Lf7UHWXir24QusWiRVF6LH8L90CqUufePPnm+TPsHFWSsKRMshUTKdQxmk+0FoNZVK6AOKv6/9v1qJ3kvwT6whHBkjYQfodwFbBPy+fTSfdhgBaIr0geDNKcSEgRkfoUxxbWY1wxwxbJvjl/knPAFos9qQxj0hwEsqAn7tQltXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896096; c=relaxed/simple;
	bh=BExx9aXtod0wH/HEDI874xkn3GBWMSI2TWnsyQJZSzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hODvtWN1HsXBfUVRVombCLPGYNCoa1axH+s1nymhVgR8h6AQVcyENLMCe7jrIVWh5dSutxM+h9wNg1540aS5lyWHbH5iVH4YbeOA3+JTECLnGYc8D+LcXU3Nt85L1BYQ0DcYw+B7uAYZZ2ikOlCHaZxTjor/vQ1kvjnvyao8vlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TzSRCRAz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W4M9n9jDxLnyVMvN/STiA9CFut4+c/DWk6MkRlkaOkg=;
	b=TzSRCRAzjsF3xMo8B1cf8zlEm3/db+6DOqrgngN95QCy4Xff3eC3L5HExImxc6aJtC3hLJ
	nzP97SMTDheSaREQ9hsmqHpm4pCqY3iT+uG7MRMqHLbK/tV7bS4/bZ9w960maojuz/kzC1
	wd2UmXVe/FKkNSQ19FayuxFS3RAVBNM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-ou7cttReNYaJE9GEnSfPdA-1; Sun,
 22 Dec 2024 14:34:50 -0500
X-MC-Unique: ou7cttReNYaJE9GEnSfPdA-1
X-Mimecast-MFC-AGG-ID: ou7cttReNYaJE9GEnSfPdA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3466619560AA;
	Sun, 22 Dec 2024 19:34:49 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 145581956088;
	Sun, 22 Dec 2024 19:34:47 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 01/18] KVM: x86/mmu: Zap invalid roots with mmu_lock held for write at uninit
Date: Sun, 22 Dec 2024 14:34:28 -0500
Message-ID: <20241222193445.349800-2-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Prepare for a future TDX patch which asserts that atomic zapping
(i.e. zapping with mmu_lock taken for read) don't operate on mirror roots.
When tearing down a VM, all roots have to be zapped (including mirro
roots once they're in place) so do that with the mmu_lock taken for werite.

kvm_mmu_uninit_tdp_mmu() is invoked either before or after executing any
atomic operations on SPTEs by vCPU threads. Therefore, it will not impact
vCPU threads performance if kvm_tdp_mmu_zap_invalidated_roots() acquires
mmu_lock for write to zap invalid roots.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-2-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2401606db260..3f749fb5ec6c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6467,7 +6467,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * lead to use-after-free.
 	 */
 	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_zap_invalidated_roots(kvm);
+		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2f15e0e33903..1054ccd9b861 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -38,7 +38,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * ultimately frees all roots.
 	 */
 	kvm_tdp_mmu_invalidate_all_roots(kvm);
-	kvm_tdp_mmu_zap_invalidated_roots(kvm);
+	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
@@ -883,11 +883,14 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
  * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
  * zap" completes.
  */
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
 {
 	struct kvm_mmu_page *root;
 
-	read_lock(&kvm->mmu_lock);
+	if (shared)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		if (!root->tdp_mmu_scheduled_root_to_zap)
@@ -905,7 +908,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * that may be zapped, as such entries are associated with the
 		 * ASID on both VMX and SVM.
 		 */
-		tdp_mmu_zap_root(kvm, root, true);
+		tdp_mmu_zap_root(kvm, root, shared);
 
 		/*
 		 * The referenced needs to be put *after* zapping the root, as
@@ -915,7 +918,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		kvm_tdp_mmu_put_root(kvm, root);
 	}
 
-	read_unlock(&kvm->mmu_lock);
+	if (shared)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index f03ca0dd13d9..6d7cdc462f58 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -23,7 +23,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-- 
2.43.5



