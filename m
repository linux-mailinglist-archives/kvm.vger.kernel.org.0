Return-Path: <kvm+bounces-33766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D869F16ED
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57DAE1885D57
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163101EE00D;
	Fri, 13 Dec 2024 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQJ3M7d+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281418FDBC
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119846; cv=none; b=lLKdELqWUdJnECT0MqCOqbwdJ4KPYZhRqn1TJjKvtbXmjqKZ9ekXDEXkFGFdrJX/jrmDe7VMXQDm+X7SB1ekt+Fafw96vjcXtdNpSVKujJ7dJrTdxXqKD7hhZDef27MSZxC7cKWQsPJ6JZkUg1b8TN0XuUpED3xP+7eToB209Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119846; c=relaxed/simple;
	bh=W/UxWOuO8L1iMCEWCYsemYhqF2fZal9Q+Xa5saGOaF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elN+HLbrQO3cHxkSfFf0VbFosuVDeEwJWorFvtixqLNCQarqdUujCVIAVnaH5nQVtLZ03UOdSKnvX0qeq0f4IN3RFL+QMKXDNXdsyVm+KOUv2mIsPahqn9nx/24QId6PGulGV8PmRev7RrN8bPybR47zkZaSW0wyoXjuy355pBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQJ3M7d+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gwnxQVgBGCByMexknyy/62oaKaxSV2VVmlXgI2Qnt4I=;
	b=IQJ3M7d+nymeOm6uEXosSK3gQ820CUgr+4FFcoaRLNlYWTi7IhIGmNY061EyjqP1vbHLRa
	9URXY9O+1DG0xTASYthrDcsPqSHe/YVCkSYunIjaE13sT+PrlF9Ap8pBVQqlmwCiBWTcr1
	J3XwmTPSlOdnCGCGzhII98MAfAzcFFo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-N8eewPVwNZG2Pur7Z3a80A-1; Fri,
 13 Dec 2024 14:57:22 -0500
X-MC-Unique: N8eewPVwNZG2Pur7Z3a80A-1
X-Mimecast-MFC-AGG-ID: N8eewPVwNZG2Pur7Z3a80A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0915919560B2;
	Fri, 13 Dec 2024 19:57:21 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 16960195605A;
	Fri, 13 Dec 2024 19:57:19 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 06/18] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
Date: Fri, 13 Dec 2024 14:56:59 -0500
Message-ID: <20241213195711.316050-7-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

The kvm_tdp_mmu_alloc_root() function currently always returns 0. This
allows for the caller, mmu_alloc_direct_roots(), to call
kvm_tdp_mmu_alloc_root() and also return 0 in one line:
   return kvm_tdp_mmu_alloc_root(vcpu);

So it is useful even though the return value of kvm_tdp_mmu_alloc_root()
is always the same. However, in future changes, kvm_tdp_mmu_alloc_root()
will be called twice in mmu_alloc_direct_roots(). This will force the
first call to either awkwardly handle the return value that will always
be zero or ignore it. So change kvm_tdp_mmu_alloc_root() to return void.
Do it in a separate change so the future change will be cleaner.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20240718211230.1492011-7-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b2a6cddde643..9b6c28b30298 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3675,8 +3675,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
-	if (tdp_mmu_enabled)
-		return kvm_tdp_mmu_alloc_root(vcpu);
+	if (tdp_mmu_enabled) {
+		kvm_tdp_mmu_alloc_root(vcpu);
+		return 0;
+	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 633c07c63fa6..0d179653f959 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -224,7 +224,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -285,7 +285,6 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 */
 	mmu->root.hpa = __pa(root->spt);
 	mmu->root.pgd = 0;
-	return 0;
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6d7cdc462f58..51884fc6a512 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.43.5



