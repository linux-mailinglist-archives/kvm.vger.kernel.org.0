Return-Path: <kvm+bounces-21450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E828192F1EE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A871C2234F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4381A6521;
	Thu, 11 Jul 2024 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VTR1fECg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21181A2FB3
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736890; cv=none; b=OsanuVBQY9Z4y5A07OjO1LoAfu2bzwN0TIQip25UV9RdO0euaqx/nw0cAjDPIHdcwuvsEzHNGQanp/j8X+dZw0GjpTmLaXfFXMECrkBSJiTEHjc9UnsiC6+6b1oo74av47Q2Y19wR9x+loTzmCnlmLzsj8+QiI4XfZNxH/g7fdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736890; c=relaxed/simple;
	bh=pEl5heZgxHtlWuvvajR2J+DBVOf+jkhfdZulTczQpYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWfZfqKtL6VJP7pO8+Y6n+E3g76lRxIwVTrvJlwoIMglVuV6lqWh98u4LA+64RFMadXGGPqvtKsjb00jTDB14tbwlfCq6oKFO8eV29nos3t/B/+SCTaj2IrFTYy94G2MEMOXZ6tzvAep0L/L0tJ4HoiJ5Nv5UjBDYyIV7lDQPkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VTR1fECg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H1VFMLLfYUOuUXaenTPqPnVHdgLceGR9dY67SpFugho=;
	b=VTR1fECg0kLZ8mYmX91lCkgawW1zhbLT9MmhGlrPcNZrVdGzEfDklmSybco04VMPuv0ID1
	Dqe3v/m/ninRN9GlazqeTx3O0Z9TqHqFQuLrk0V+6069qtSgB4qJkq9FFehzpqh2QyyIfz
	Cael25psW/WsQNBY2F27aNwHsXvBF/o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-W3ZwWlsdP4SRt5V9jcAj0w-1; Thu,
 11 Jul 2024 18:28:06 -0400
X-MC-Unique: W3ZwWlsdP4SRt5V9jcAj0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1E211956095;
	Thu, 11 Jul 2024 22:28:05 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E80AF19560AE;
	Thu, 11 Jul 2024 22:28:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 11/12] KVM: extend kvm_range_has_memory_attributes() to check subset of attributes
Date: Thu, 11 Jul 2024 18:27:54 -0400
Message-ID: <20240711222755.57476-12-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

While currently there is no other attribute than KVM_MEMORY_ATTRIBUTE_PRIVATE,
KVM code such as kvm_mem_is_private() is written to expect their existence.
Allow using kvm_range_has_memory_attributes() as a multi-page version of
kvm_mem_is_private(), without it breaking later when more attributes are
introduced.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 13 +++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e0e9963066f..f6b7391fe438 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7524,7 +7524,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
 
 	if (level == PG_LEVEL_2M)
-		return kvm_range_has_memory_attributes(kvm, start, end, attrs);
+		return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
 		if (hugepage_test_mixed(slot, gfn, level - 1) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f6e11991442d..456dbdf7aaaf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2410,7 +2410,7 @@ static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn
 }
 
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long attrs);
+				     unsigned long mask, unsigned long attrs);
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
 bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8ab9d8ff7b74..62e5d9b0ae83 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2402,21 +2402,21 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 
 /*
  * Returns true if _all_ gfns in the range [@start, @end) have attributes
- * matching @attrs.
+ * such that the bits in @mask match @attrs.
  */
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long attrs)
+				     unsigned long mask, unsigned long attrs)
 {
 	XA_STATE(xas, &kvm->mem_attr_array, start);
-	unsigned long mask = kvm_supported_mem_attributes(kvm);;
 	unsigned long index;
 	void *entry;
 
+	mask &= kvm_supported_mem_attributes(kvm);
 	if (attrs & ~mask)
 		return false;
 
 	if (end == start + 1)
-		return kvm_get_memory_attributes(kvm, start) == attrs;
+		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
 
 	guard(rcu)();
 	if (!attrs)
@@ -2427,7 +2427,8 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 			entry = xas_next(&xas);
 		} while (xas_retry(&xas, entry));
 
-		if (xas.xa_index != index || xa_to_value(entry) != attrs)
+		if (xas.xa_index != index ||
+		    (xa_to_value(entry) & mask) != attrs)
 			return false;
 	}
 
@@ -2526,7 +2527,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
-	if (kvm_range_has_memory_attributes(kvm, start, end, attributes))
+	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
 	/*
-- 
2.43.0



