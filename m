Return-Path: <kvm+bounces-34311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8054F9FA7C3
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00CCC1885FD1
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC2E1B3959;
	Sun, 22 Dec 2024 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQ3x/zjS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7401B218B
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896109; cv=none; b=Odaen0ouvlGLw3rK4EroRx2buqkFS2k6/SgLhI1VLjqBQYGtNGLwK/+rVHWPP8HQLUr6RvP5UhY/247LFsVB0N/VLq25GefMDgrfwIwk2UYlZQ5BoBiQjmDNm4nDN1JtILhfNrEqJdg7Tbb2FFsIECksF6agFtD8v7txiNAki64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896109; c=relaxed/simple;
	bh=CR1mlLcy+gUqIPDe3RPQOm65Y1y9auQl8+KwZpGN6AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cz20rdZmQHxyUqajB2SabjeThpoHzhBPdHwdeFVz4RDNT10kzKLK0qzr8K05Q0SBMfWCkpZ4rP/tbEFSGhtmgzcM8FKtSxhVLFYnou6ynQ0SIEtCxqo9mPetIuH87YvqDsxZeAibURZV4QqLFGRzVbfzL38SHOu7sVIfBLtdHpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQ3x/zjS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgFTCFCRz2m6WAlhoO5iUkOLgWXpNnpk5F/j2HUpXMg=;
	b=cQ3x/zjSHCcCUBDQc2j6jUJPrEpAsilUKR8q2QpGaHTcGiC7BFzsUQyo7c1meO0XlmA1F4
	MVZY/JdBIPhuwMblxNskWMbA7HykL1DwOUM2GyVNXpHEr2ejqsVaVgQdbV/8/n0OFPfYJi
	8HdEEulBfcC8jSqOMm2gRAPAgw/8myM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-Rh9bUVRjPmmOlz94OQDtrg-1; Sun,
 22 Dec 2024 14:35:03 -0500
X-MC-Unique: Rh9bUVRjPmmOlz94OQDtrg-1
X-Mimecast-MFC-AGG-ID: Rh9bUVRjPmmOlz94OQDtrg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14A9C19560A2;
	Sun, 22 Dec 2024 19:35:02 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 161AC19560AA;
	Sun, 22 Dec 2024 19:35:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 11/18] KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
Date: Sun, 22 Dec 2024 14:34:38 -0500
Message-ID: <20241222193445.349800-12-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Take the root as an argument of tdp_mmu_for_each_pte() instead of looking
it up in the mmu. With no other purpose of passing the mmu, drop it.

Future changes will want to change which root is used based on the context
of the MMU operation. So change the callers to pass in the root currently
used, mmu->root.hpa in a preparatory patch to make the later one smaller
and easier to review.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-12-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9fbf4770ba3e..1634506b2699 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -647,8 +647,8 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _kvm, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, _kvm, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
 static inline bool __must_check tdp_mmu_iter_need_resched(struct kvm *kvm,
 							  struct tdp_iter *iter)
@@ -1083,8 +1083,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1095,7 +1095,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1744,14 +1744,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1773,11 +1773,11 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.43.5



