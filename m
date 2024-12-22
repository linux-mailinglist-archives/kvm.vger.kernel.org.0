Return-Path: <kvm+bounces-34302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9ED9FA7B2
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 20:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2F211648A2
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8E11991BA;
	Sun, 22 Dec 2024 19:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BIuhaFam"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A9818FDA9
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734896098; cv=none; b=DSo1pT33JCtHN47fsMlaBWVw54sZLMJU1SerkvCSxiKeVBkeQVZOG+JGISfhu+VB8jGNFa/UvWSA3XP1yBKLDa/IBCUvWrxfy9jiZYoGHuuwYma0kH6xBoH7dDfhHoy/ULLu97uaM03JhjiCaCjGnEg4j6o3+clpvGAT/PE7LyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734896098; c=relaxed/simple;
	bh=YAqwZRLXFi8t3u5dj2HCuxZkJBnY+5Q0eK02rCwcKHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPeDNCeDnaEw7Gn3b+6bVGEU8SdzwohfDp9Pi/vXXY93iWAnBCjkvoiWCJxEiB41DwLfjN9jYQ7f/fieb5pm4WzkwfpaYdD9LRrXn4LWpaBQJ55EVFg9K1XBD36B4Sw8Jd79Osj5sR8JobQ2J7SIWQ+v2CokbSn97Ie8JNrmYas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BIuhaFam; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734896095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSURQ5skVbJB4BaezFHGl1Fr9+462ymQtr3vxlCxzX8=;
	b=BIuhaFam2cANUb6LjzASbwwp5Z3NxJ9OObFN3G8SGYPVxdOmBvxOOu9Fp2W0ENsM5GjIE7
	67ZJon/Fog+k4X2EjFeruUFfE16xwmzaEmog53gVwAYMisF22A849bArHcyJn/3ekHRA57
	RT8y8xoKO3XYxipDU5p0Ie20Sg8OE08=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-psspLQGONPKmplsH11HRRQ-1; Sun,
 22 Dec 2024 14:34:51 -0500
X-MC-Unique: psspLQGONPKmplsH11HRRQ-1
X-Mimecast-MFC-AGG-ID: psspLQGONPKmplsH11HRRQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6544719560B2;
	Sun, 22 Dec 2024 19:34:50 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 688E21956086;
	Sun, 22 Dec 2024 19:34:49 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v6 02/18] KVM: Add member to struct kvm_gfn_range to indicate private/shared
Date: Sun, 22 Dec 2024 14:34:29 -0500
Message-ID: <20241222193445.349800-3-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on: enum kvm_gfn_range_filter
attr_filter. Update the core zapping operations to set them appropriately.

TDX utilizes two GPA aliases for the same memslots, one for memory that is
for private memory and one that is for shared. For private memory, KVM
cannot always perform the same operations it does on memory for default
VMs, such as zapping pages and having them be faulted back in, as this
requires guest coordination. However, some operations such as guest driven
conversion of memory between private and shared should zap private memory.

Internally to the MMU, private and shared mappings are tracked on separate
roots. Mapping and zapping operations will operate on the respective GFN
alias for each root (private or shared). So zapping operations will by
default zap both aliases. Add fields in struct kvm_gfn_range to allow
callers to specify which aliases so they can only target the aliases
appropriate for their specific operation.

There was feedback that target aliases should be specified such that the
default value (0) is to operate on both aliases. Several options were
considered. Several variations of having separate bools defined such
that the default behavior was to process both aliases. They either allowed
nonsensical configurations, or were confusing for the caller. A simple
enum was also explored and was close, but was hard to process in the
caller. Instead, use an enum with the default value (0) reserved as a
disallowed value. Catch ranges that didn't have the target aliases
specified by looking for that specific value.

Set target alias with enum appropriately for these MMU operations:
 - For KVM's mmu notifier callbacks, zap shared pages only because private
   pages won't have a userspace mapping
 - For setting memory attributes, kvm_arch_pre_set_memory_attributes()
   chooses the aliases based on the attribute.
 - For guest_memfd invalidations, zap private only.

Link: https://lore.kernel.org/kvm/ZivIF9vjKcuGie3s@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20240718211230.1492011-3-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   |  6 ++++++
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   |  2 ++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3f749fb5ec6c..a8f75971d3cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7452,6 +7452,12 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	/* Unmap the old attribute page. */
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		range->attr_filter = KVM_FILTER_SHARED;
+	else
+		range->attr_filter = KVM_FILTER_PRIVATE;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9df216943eb4..c788d0bd952a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -255,11 +255,17 @@ union kvm_mmu_notifier_arg {
 	unsigned long attributes;
 };
 
+enum kvm_gfn_range_filter {
+	KVM_FILTER_SHARED		= BIT(0),
+	KVM_FILTER_PRIVATE		= BIT(1),
+};
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 18c87feaf68f..b2aa6bf24d3a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -118,6 +118,8 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			/* guest memfd is relevant to only private mappings. */
+			.attr_filter = KVM_FILTER_PRIVATE,
 		};
 
 		if (!found_memslot) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..164cd4f7f8ba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -594,6 +594,11 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.attr_filter = KVM_FILTER_SHARED;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2408,6 +2413,14 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
 
+	/*
+	 * If/when KVM supports more attributes beyond private .vs shared, this
+	 * _could_ set KVM_FILTER_{SHARED,PRIVATE} appropriately if the entire target
+	 * range already has the desired private vs. shared state (it's unclear
+	 * if that is a net win).  For now, KVM reaches this point if and only
+	 * if the private flag is being toggled, i.e. all mappings are in play.
+	 */
+
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
 
@@ -2464,6 +2477,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
+		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
-- 
2.43.5



