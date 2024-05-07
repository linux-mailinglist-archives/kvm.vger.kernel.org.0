Return-Path: <kvm+bounces-16911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A73248BEB2D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 194FDB2755E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6E116E886;
	Tue,  7 May 2024 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fq1pKcNy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD55216D332
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105258; cv=none; b=q4Zkk4nesltEJVakUaosLs5wxt9PdEV6LsIzpgPIVPVtRdPxXM+oJ/WJRbF5mL9GQzSmEEkCCedhn4Py1nlgeUESt0zmkOMgIyjT52MBeJepjpBZC/4xKtkcxXSYMw8oAimoLKmSQYiNo11k+fOepYMzpicKnkyIv9BsHvP/q/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105258; c=relaxed/simple;
	bh=dYXAYcUEcTSalyaMCHp6wfpYZFB5214Afajx4bi1OuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgadThRkR9tH0qUKF2q8cheOuaKWOvqPacZtwOVb0+p1FXoEDvsuDrJ/vQVRPrz3uB8CjABmpGi64+ecbhPnb/2+IJK5z0/DU35vFy7r8wgSwi/FHoYumgn7zOAzKj9qMDQZKigCLfxOhZDkWXF/ppjz7fsN04VYLDKYcwSHUME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fq1pKcNy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=haoWzAYgu3zjEQH0/MBl6b/4BmVPvoYTenFPpRWObq0=;
	b=fq1pKcNyJJgMQtcx/Yd5MyMq0nCQSWWuG3roP4RVjxWOoJhLDSGfdr90qEYvBAWkp5xSrj
	v920gUK670YuQUVT5tJN/ddHBdj25AQrIEYO3o7wchE9BnCJfTvEpCNReDl9RNgPBnmIoD
	gWEvazhxJJcnLSXe3UKl3eGuj/C2czM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-PxmMGZHFNb6dR8DgG3h06g-1; Tue,
 07 May 2024 14:07:32 -0400
X-MC-Unique: PxmMGZHFNb6dR8DgG3h06g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44A2B3802ADC;
	Tue,  7 May 2024 18:07:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03F3340C6CB6;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
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
Subject: [PATCH 7/9] KVM: guest_memfd: Add interface for populating gmem pages with user data
Date: Tue,  7 May 2024 14:07:27 -0400
Message-ID: <20240507180729.3975856-8-pbonzini@redhat.com>
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

During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
prepare newly-allocated gmem pages prior to mapping them into the guest.
In the case of SEV-SNP, this mainly involves setting the pages to
private in the RMP table.

However, for the GPA ranges comprising the initial guest payload, which
are encrypted/measured prior to starting the guest, the gmem pages need
to be accessed prior to setting them to private in the RMP table so they
can be initialized with the userspace-provided data. Additionally, an
SNP firmware call is needed afterward to encrypt them in-place and
measure the contents into the guest's launch digest.

While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
this handling can be done in an open-coded/vendor-specific manner, this
may expose more gmem-internal state/dependencies to external callers
than necessary. Try to avoid this by implementing an interface that
tries to handle as much of the common functionality inside gmem as
possible, while also making it generic enough to potentially be
usable/extensible for TDX as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 27 +++++++++++++++++++++
 virt/kvm/guest_memfd.c   | 52 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1af069ab657c..1ae65774d9fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2448,4 +2448,31 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
 bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
 #endif
 
+/**
+ * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
+ *
+ * @kvm: KVM instance
+ * @gfn: starting GFN to be populated
+ * @src: userspace-provided buffer containing data to copy into GFN range
+ *       (passed to @post_populate, and incremented on each iteration
+ *       if not NULL)
+ * @npages: number of pages to copy from userspace-buffer
+ * @post_populate: callback to issue for each gmem page that backs the GPA
+ *                 range
+ * @opaque: opaque data to pass to @post_populate callback
+ *
+ * This is primarily intended for cases where a gmem-backed GPA range needs
+ * to be initialized with userspace-provided data prior to being mapped into
+ * the guest as a private page. This should be called with the slots->lock
+ * held so that caller-enforced invariants regarding the expected memory
+ * attributes of the GPA range do not race with KVM_SET_MEMORY_ATTRIBUTES.
+ *
+ * Returns the number of pages that were populated.
+ */
+typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				    void __user *src, int order, void *opaque);
+
+long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+		       kvm_gmem_populate_cb post_populate, void *opaque);
+
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index bfe437098b79..5d6c87bb13f6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -585,3 +585,55 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
+
+long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
+		       kvm_gmem_populate_cb post_populate, void *opaque)
+{
+	struct file *file;
+	struct kvm_memory_slot *slot;
+	void __user *p;
+
+	int ret = 0, max_order;
+	long i;
+
+	lockdep_assert_held(&kvm->slots_lock);
+	if (npages < 0)
+		return -EINVAL;
+
+	slot = gfn_to_memslot(kvm, start_gfn);
+	if (!kvm_slot_can_be_private(slot))
+		return -EINVAL;
+
+	file = kvm_gmem_get_file(slot);
+	if (!file)
+		return -EFAULT;
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
+	for (i = 0; i < npages; i += (1 << max_order)) {
+		gfn_t gfn = start_gfn + i;
+		kvm_pfn_t pfn;
+
+		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
+		if (ret)
+			break;
+
+		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
+		    (npages - i) < (1 << max_order))
+			max_order = 0;
+
+		p = src ? src + i * PAGE_SIZE : NULL;
+		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
+
+		put_page(pfn_to_page(pfn));
+		if (ret)
+			break;
+	}
+
+	filemap_invalidate_unlock(file->f_mapping);
+
+	fput(file);
+	return ret && !i ? ret : i;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_populate);
-- 
2.43.0



