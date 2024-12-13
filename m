Return-Path: <kvm+bounces-33777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DE39F1705
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7C0A188C239
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DC81F667B;
	Fri, 13 Dec 2024 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9AEtijT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F831F4E44
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119858; cv=none; b=MEk0WIVN6azx0JDWxQ39IqzYKpHnhBAGKzoViJGf+RaU6md0V4LjaW+3lzO1i7PCX5BzLnqxkUwuQQYqB24X0Fz+US6ejBcSiQ8dA4Ms37LT9FX1FezvgFGZJ3tDuQwazd7ZurI2vtvvLCZ3s2iOVhxGsoJP3y7WlQNiZhLQ+40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119858; c=relaxed/simple;
	bh=R+GgGImnl5RLUUxYhPe/wARl135tPvMy2/OQSgbSI9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCukclPSQTFBYA/bshApzqEvqQxZLEoAim0UM4tFc2OGIfYr1ecZQgToFoaR66YRjNFUe0+z2wInIrtjNalMt88eFfqiteforUDuivAXaJM9RMHzRXfMgWisvsaWlREKIt8ICAtRDBHZFstkF8YX29fTDhtDBg0JT6v9Zd4e5+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9AEtijT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywI8hJsEUIv/q7FZWYHPIIFlWFSGoTCQ0D0fvGLYHjA=;
	b=W9AEtijTI+/g9nQO4pZ4MIHYnbuDF475vXOlwMb/15uX4muS9vn4cdLs3N1U9mdK8jHbNj
	lsyi/IXNvTfLbJQuHjWbao30hhjM5x9ro3LU+b9KiOZRU2CmMAZwZLvuVV5ZuGnpB+KxDF
	9lxYONgIsBgc8p4ItterBu6F3ElkXRQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-d6Hqs1fyNX-3hUzv-07zpA-1; Fri,
 13 Dec 2024 14:57:31 -0500
X-MC-Unique: d6Hqs1fyNX-3hUzv-07zpA-1
X-Mimecast-MFC-AGG-ID: d6Hqs1fyNX-3hUzv-07zpA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A12819560A1;
	Fri, 13 Dec 2024 19:57:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 180661956086;
	Fri, 13 Dec 2024 19:57:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 13/18] KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
Date: Fri, 13 Dec 2024 14:57:06 -0500
Message-ID: <20241213195711.316050-14-pbonzini@redhat.com>
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

Teach the MMU notifier callbacks how to check kvm_gfn_range.process to
filter which KVM MMU root types to operate on.

The private GPAs are backed by guest memfd. Such memory is not subjected
to MMU notifier callbacks because it can't be mapped into the host user
address space. Now kvm_gfn_range conveys info about which root to operate
on. Enhance the callback to filter the root page table type.

The KVM MMU notifier comes down to two functions.
kvm_tdp_mmu_unmap_gfn_range() and __kvm_tdp_mmu_age_gfn_range():
- invalidate_range_start() calls kvm_tdp_mmu_unmap_gfn_range()
- invalidate_range_end() doesn't call into arch code
- the other callbacks call __kvm_tdp_mmu_age_gfn_range()

For VM's without a private/shared split in the EPT, all operations
should target the normal(direct) root.

With the switch from for_each_tdp_mmu_root() to
__for_each_tdp_mmu_root() in kvm_tdp_mmu_handle_gfn(), there are no
longer any users of for_each_tdp_mmu_root(). Remove it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-14-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d17a3cf1596d..9a004c999a28 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -193,9 +193,6 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     !tdp_mmu_root_match((_root), (_types)))) {			\
 		} else
 
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ALL_ROOTS)
-
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
@@ -1172,12 +1169,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	enum kvm_tdp_mmu_root_types types;
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
@@ -1217,17 +1218,21 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
 					struct kvm_gfn_range *range,
 					bool test_only)
 {
+	enum kvm_tdp_mmu_root_types types;
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
 	bool ret = false;
 
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
 	 * this helper must NOT be used to unmap GFNs, as it processes only
 	 * valid roots!
 	 */
-	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	WARN_ON(types & ~KVM_VALID_ROOTS);
+	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
 		guard(rcu)();
 
 		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end) {
-- 
2.43.5



