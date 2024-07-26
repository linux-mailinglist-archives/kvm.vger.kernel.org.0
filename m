Return-Path: <kvm+bounces-22344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C5093D8AB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA521C21243
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603F214F118;
	Fri, 26 Jul 2024 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B65qwNnt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04710149E1B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019933; cv=none; b=CtNbnVh1oVA6AS5C4zgubi1gpn2w5DZNz80ATYYX0VDYDw8ue36EAXqAFxYOhR+Hfy8GS0/zvkJf6Pdivyx8ENKK1iP8SZ5lemcZlLxcKbFFNZgvgSlcOt3oubRDMEC/SCc3fsq1L7u15VHtqZKPa6ayMxpIIu30/S7wyFOzugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019933; c=relaxed/simple;
	bh=6tNs2cHQ2RFZtPiBUBUq2AcBiZQsQu9np+t8r28UwcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRvWaFrmwo+TSegV/yfCj6FGfKsOyvqhOyOYiQukEtc78gD5sHWGsOFmVHMJXR0NTkhnlLzWCxNZnx/71wfUcc60idEzb79+VI2uuYLQHEdUWYATckIvS81cm+46yXaVgmhjijdB9wRlWiI64tdPKz0MhSR4j6YYgB5MUFeLT30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B65qwNnt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=psXS9EhBP2n6eAzjDDe2ar1r5ouEtqCtOES7FlMuMI0=;
	b=B65qwNntt/JOTG10DFbMOqUL6a8r9SU8O4H1XKR3Pj5YLc8UvLWaGnZIKUqGbmGB20QJa6
	hFu9uR7HLZ8Y2HyFdT9Kzv7kYNgSaapFHsYEv9Zqhg7BkKS8BBfb2xnb1s/Cy029CWMzXZ
	x00ANlO1nXN2LMs6ryM8fz+bVfEfXwM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-6-kXwFw-PTmZsx-pm4QQ0w-1; Fri,
 26 Jul 2024 14:52:07 -0400
X-MC-Unique: 6-kXwFw-PTmZsx-pm4QQ0w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FFE11955D54;
	Fri, 26 Jul 2024 18:52:06 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD9653000194;
	Fri, 26 Jul 2024 18:52:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 09/14] KVM: remove kvm_arch_gmem_prepare_needed()
Date: Fri, 26 Jul 2024 14:51:52 -0400
Message-ID: <20240726185157.72821-10-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

It is enough to return 0 if a guest need not do any preparation.
This is in fact how sev_gmem_prepare() works for non-SNP guests,
and it extends naturally to Intel hosts: the x86 callback for
gmem_prepare is optional and returns 0 if not defined.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  5 -----
 include/linux/kvm_host.h |  1 -
 virt/kvm/guest_memfd.c   | 13 +++----------
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4db18924b2f2..ef3d3511e4af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13645,11 +13645,6 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
-{
-	return kvm->arch.vm_type == KVM_X86_SNP_VM;
-}
-
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
 	return kvm_x86_call(gmem_prepare)(kvm, pfn, gfn, max_order);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 344d90771844..45373d42f314 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2447,7 +2447,6 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
-bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
 #endif
 
 /**
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 444ded162154..191fd42067c0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -29,16 +29,9 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 				    pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-	kvm_pfn_t pfn;
-	gfn_t gfn;
-	int rc;
-
-	if (!kvm_arch_gmem_prepare_needed(kvm))
-		return 0;
-
-	pfn = folio_file_pfn(folio, index);
-	gfn = slot->base_gfn + index - slot->gmem.pgoff;
-	rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+	kvm_pfn_t pfn = folio_file_pfn(folio, index);
+	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
+	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
 	if (rc) {
 		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
 				    index, gfn, pfn, rc);
-- 
2.43.0



