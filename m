Return-Path: <kvm+bounces-10160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A439286A3D6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 304CFB2D9EF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367DC5B5A8;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iN2los5C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D157336
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076071; cv=none; b=ZiB1RAO4P0kEVeojNem5wqvA/x0IZs/IhshL6driR3HdAasC8zJ1oCNRrCxC+YwpRkI5RqRuHUxqode19EFpwfCBPxUsxNLXsxTskX9R1wJLehPHsiKkKAJqbjoX326PPWIUxe/8i4crjm4faaYXtStngigp6D1ON5mopMXHMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076071; c=relaxed/simple;
	bh=pLtVn59cyQbuntetXuEM2l8HbE1V0ERcTrZHvrurl3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idh1tfXTR5djZ+nlebpC/WKG7F+BEiz9Zt+VuOihF6UxTzCgF0QhkvGD1FZCt6k5cqJgnliT3ZC8oZu1Z42tGaA/jwlByknVYjnaB8TWQwWsmMoqyUZgAGeLy8fXX4pZpagG2aEAhXPPhFtIsMvARvSityoHLweZfD/HteDeeXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iN2los5C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHtW+SDyafl3r8UhKOO4YD7Evd7+sKdfgmUWfdfwcR8=;
	b=iN2los5CNVfCtWK9lkPo96SSE/PN7vWDsAFgQOrC6t7bSi8uoOnn3lzPgDrLlGWtPGwYQx
	kku5aWWEQLEkHzPBfUttGA8iqvpktL4FFX7ACeI906pPvs6HgQBsXIFY931jJzY5CxLrbs
	gWkOrB2+KczVpaEKI3XO0ucNkC7iilI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-sk8ZdshlM7qS416hg-28uQ-1; Tue, 27 Feb 2024 18:21:04 -0500
X-MC-Unique: sk8ZdshlM7qS416hg-28uQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD6F8845E61;
	Tue, 27 Feb 2024 23:21:03 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C45BC040F7;
	Tue, 27 Feb 2024 23:21:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 12/21] KVM: x86/tdp_mmu: Sprinkle __must_check
Date: Tue, 27 Feb 2024 18:20:51 -0500
Message-Id: <20240227232100.478238-13-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
return -EBUSY or -EAGAIN error.  The caller must check the return value and
retry.  Add __must_check to ensure that it does so.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-Id: <8f7d5a1b241bf5351eaab828d1a1efe5c17699ca.1705965635.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 55b5e3857e98..3627744fcab6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -539,9 +539,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  *            no side-effects other than setting iter->old_spte to the last
  *            known value of the spte.
  */
-static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  u64 new_spte)
+static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -571,8 +571,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter)
+static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	int ret;
 
-- 
2.39.0



