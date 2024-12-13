Return-Path: <kvm+bounces-33780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56BF59F1706
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81D007A0FCF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162AE1F7545;
	Fri, 13 Dec 2024 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bay6huUE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463B21F63D6
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119861; cv=none; b=pdRRzLgVcvMeyBGzfSQ7DCxlSn/1B6lyOIYelv7gIzRaNlBcYxBFVXCEnF77zMteG5lTB51m3xpNbeKGo82KRTT63NcTXbRjP7zRp4mhn9c/yIsLh3+dPZMEk00LAwLEEXElrOtpMTjupsKz4c7Ru2D2+uOTQez7PqDEnqUtxIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119861; c=relaxed/simple;
	bh=wHfh7K6gFGyYV73n94bTnD8g5vAGiS2GTdff0kS95A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKO4YRcNulg/9OWkSoK1tCwD87m/jdmzQrSHGA7ller9BmdNZPsqu9lMSuM6JOaQNTuV4oFLOR0jLpFMcywJuEz+HV5j+9nnSdXOkBhDYC9JbfGzwzlSlOr65InH0YqQGAJA/FL5WrPaQXV70hx973/cFpMjwzbajJHzUGIDI64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bay6huUE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FeUZkTvJWJNVJ5wxxth1jEK6YXIb6JtFh5ta2hZJM/c=;
	b=bay6huUEHpzh+kfgOeSOt+njM0o73404gdktrVR/z6dEOyk5roV62F9/f+kqbPIflETOhO
	enMvZCudhGN4lHZ0+jTRlJFqLABmneGAQZpI+ZtsUseX0T77SrKo+Q1oVgBTXAHpX3O/59
	x3DE+hGwRn45AUsnlBIUeihvrHmf0EA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-HREuNAAoPtu0lgry71KCJA-1; Fri,
 13 Dec 2024 14:57:35 -0500
X-MC-Unique: HREuNAAoPtu0lgry71KCJA-1
X-Mimecast-MFC-AGG-ID: HREuNAAoPtu0lgry71KCJA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBEE1195609F;
	Fri, 13 Dec 2024 19:57:33 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0C141956086;
	Fri, 13 Dec 2024 19:57:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 16/18] KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()
Date: Fri, 13 Dec 2024 14:57:09 -0500
Message-ID: <20241213195711.316050-17-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Isaku Yamahata <isaku.yamahata@intel.com>

Rename kvm_tdp_mmu_invalidate_all_roots() to
kvm_tdp_mmu_invalidate_roots(), and make it enum kvm_tdp_mmu_root_types
as an argument.

kvm_tdp_mmu_invalidate_roots() is called with different root types. For
kvm_mmu_zap_all_fast() it only operates on shared roots. But when tearing
down a VM it needs to invalidate all roots. Have the callers only
invalidate the required roots instead of all roots.

Within kvm_tdp_mmu_invalidate_roots(), respect the root type
passed by checking the root type in root iterator.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-17-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4594fbdd0dcc..c948d344b3fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6466,8 +6466,13 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+	if (tdp_mmu_enabled) {
+		/*
+		 * External page tables don't support fast zapping, therefore
+		 * their mirrors must be invalidated separately by the caller.
+		 */
+		kvm_tdp_mmu_invalidate_roots(kvm, KVM_DIRECT_ROOTS);
+	}
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 140902a7b291..94c464ce1d12 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -1070,10 +1070,18 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_alloc_root().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types root_types)
 {
 	struct kvm_mmu_page *root;
 
+	/*
+	 * Invalidating invalid roots doesn't make sense, prevent developers from
+	 * having to think about it.
+	 */
+	if (WARN_ON_ONCE(root_types & KVM_INVALID_ROOTS))
+		root_types &= ~KVM_INVALID_ROOTS;
+
 	/*
 	 * mmu_lock must be held for write to ensure that a root doesn't become
 	 * invalid while there are active readers (invalidating a root while
@@ -1095,6 +1103,9 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	 * or get/put references to roots.
 	 */
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!tdp_mmu_root_match(root, root_types))
+			continue;
+
 		/*
 		 * Note, invalid roots can outlive a memslot update!  Invalid
 		 * roots must be *zapped* before the memslot update completes,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9887441cd703..52acf99d40a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -66,7 +66,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-- 
2.43.5



