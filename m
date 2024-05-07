Return-Path: <kvm+bounces-16913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE378BEB33
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EB0A1C23322
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5875416F291;
	Tue,  7 May 2024 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iw50Pxqd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955516D9DC
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105260; cv=none; b=oq0X0gH95zuTEbgfAiY+UBRodfXg3GVrAaDJzhaA0NAIGgYAtiznozBSxLFNqpF7L9ujxZd0CbGw1G7wh6yO//Uw1mjKgF5oDqbPdEq7dZHuVdXqiFlqzNn8084fcuwHguiEI4f5FDYUSUr83sEkMKgjA/xwCitz/uz6e8BpUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105260; c=relaxed/simple;
	bh=VkYVgValE1VC3CCVs0mqhqX97gJycl4Mli4kr12E+yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=movKxzcxigV1AaWwgdG6z7YNWeNgbleIuqn8kSUuAcuF4yMatoWCanJXYiJORpUfDaRO2I5TFvvAcHex07xienI16osjZzTlSJEtGh8oTqSg8VYhbeCGEgSmuEWaGsNxNF8nIu9ANp6obV+GLnOWxNF91vx36NUK0hDVVv9ZCRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iw50Pxqd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grd8SBcJY3NN+0PKA1+3T49kM48ek86tDr075GyjEBo=;
	b=iw50PxqdJHpmK5ly9XBqfgVKEbfIp1gACH13ebyn8yXCebTyMgDMN8vSXpv0KISax7iaah
	ADei011MSLliu451RWXAQmIoiQJxVB6fiUmpEIPyhnXqJWm1eEG+/KjicmSnK0UwSTWaIw
	6MuNVlSIFPp7Nvu0a+vnXuECFdoM+Tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-Jmearq2FPQyhzBHrqkUTHw-1; Tue, 07 May 2024 14:07:33 -0400
X-MC-Unique: Jmearq2FPQyhzBHrqkUTHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EB08101A554;
	Tue,  7 May 2024 18:07:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E3F840C6CBE;
	Tue,  7 May 2024 18:07:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	yilun.xu@intel.com
Subject: [PATCH 8/9] KVM: guest_memfd: Add hook for invalidating memory
Date: Tue,  7 May 2024 14:07:28 -0400
Message-ID: <20240507180729.3975856-9-pbonzini@redhat.com>
In-Reply-To: <20240507180729.3975856-1-pbonzini@redhat.com>
References: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Michael Roth <michael.roth@amd.com>

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Wire up arch-defined hooks to the .free_folio kvm_gmem_aops callback to
allow for special handling of this sort when freeing memory in response
to FALLOC_FL_PUNCH_HOLE operations and when releasing the inode, and go
ahead and define an arch-specific hook for x86 since it will be needed
for handling memory used for SEV-SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231230172351.574091-6-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  7 +++++++
 include/linux/kvm_host.h           |  4 ++++
 virt/kvm/Kconfig                   |  4 ++++
 virt/kvm/guest_memfd.c             | 14 ++++++++++++++
 6 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d26fcad13e36..c81990937ab4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5562a2443c5c..c6c5018376be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1815,6 +1815,7 @@ struct kvm_x86_ops {
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 972524ddcfdb..83b8260443a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13605,6 +13605,13 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
 }
 #endif
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
+{
+	static_call_cond(kvm_x86_gmem_invalidate)(start, end);
+}
+#endif
+
 int kvm_spec_ctrl_test_value(u64 value)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ae65774d9fa..b43b96f876fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2475,4 +2475,8 @@ typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+#endif
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index ca870157b2ed..754c6c923427 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -113,3 +113,7 @@ config KVM_GENERIC_PRIVATE_MEM
 config HAVE_KVM_GMEM_PREPARE
        bool
        depends on KVM_PRIVATE_MEM
+
+config HAVE_KVM_GMEM_INVALIDATE
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5d6c87bb13f6..dfe50c64a552 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -343,10 +343,24 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	return MF_DELAYED;
 }
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+static void kvm_gmem_free_folio(struct folio *folio)
+{
+	struct page *page = folio_page(folio, 0);
+	kvm_pfn_t pfn = page_to_pfn(page);
+	int order = folio_order(folio);
+
+	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
+}
+#endif
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+	.free_folio = kvm_gmem_free_folio,
+#endif
 };
 
 static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
-- 
2.43.0



