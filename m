Return-Path: <kvm+bounces-34316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7918A9FA7D0
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C10991885F7F
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE65A1C3BE7;
	Sun, 22 Dec 2024 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gva4oHMn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F01B87F3
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896116; cv=none; b=dtGxSmsV5YWfjQ+34ImZ6GIQ1wByKIJ2dmzSORlkoFqnA97xUqfXFVuRljkJC1PHV3J/IjGiGZZCuK74GwmZFsWSKrvkzPVph7qEOYFOYInqHouyWpgmh9EW1rEFRGr50qmArDE57vjYZBF0Mq8V4puvQNnznTzrgRZDZUTFvKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896116; c=relaxed/simple;
	bh=jSMJY0vMKTWYqTVtJcv/uiXm/BQCd6FBMOEVFKw82qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IcXR5B7b/nuRXDSdol06n9Bq7mLS53hHByXGz38K4H7NzTICEClYTH5rR+aLKmfryqjYD6LZYT5PBmZrHn1WPX0ObBipH6HwAX7DfcNxHcuj+0N+tw0R0hgD5MXelz3IFOhncBCD2BnHgXV9K58r9rNoZ8rQne1jwUC7OpQk0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gva4oHMn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLwEAICvhIVqnDAiL0NQsLiVtskrJgDik8M1gPuZRV0=;
	b=gva4oHMnS8bzkzPO9Tw2C68FX7djOgNTUcQtcQ5zn6QQutemQObrhmE9t/USrMIMPRlP5Z
	WGgMqn8OdH8r08xLeXPEmavv3Cro+O9HVD2EhD+BYSgTRcePij6N+PRdHZqcALm08b3AEj
	9GvDPRTuIN4k1ltBYrX823jpQKXNAhk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-Da4o6a7dN9qIAu9VZiwtUg-1; Sun,
 22 Dec 2024 14:35:06 -0500
X-MC-Unique: Da4o6a7dN9qIAu9VZiwtUg-1
X-Mimecast-MFC-AGG-ID: Da4o6a7dN9qIAu9VZiwtUg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8142119560AB;
	Sun, 22 Dec 2024 19:35:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 889A219560AA;
	Sun, 22 Dec 2024 19:35:03 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 13/18] KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
Date: Sun, 22 Dec 2024 14:34:40 -0500
Message-ID: <20241222193445.349800-14-pbonzini@redhat.com>
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
index cf623ec00637..8e584be64523 100644
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
 
@@ -1177,12 +1174,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -1222,17 +1223,21 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
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



