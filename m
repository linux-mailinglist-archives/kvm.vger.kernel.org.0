Return-Path: <kvm+bounces-10158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE36686A383
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93D2B1F22F82
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D87B5B05E;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5e8faDK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB456B94
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076071; cv=none; b=o6zExfRhfLqNi0s8h7iroz9OkyFvjRu/VwUqSKp77xGDoxNsjh73pZJZynf4vO2p3ootIEcxCDdpvwwBSh3PMwsH4pRDDnJBDsmmw8MlXMUX9VGPr5HKTQBeeKtOrXIsC/5KH39etEBbm5iMRPAwYBQ5z415uDDmyr2Tyi9p4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076071; c=relaxed/simple;
	bh=p/JP/QGMe6e0T/PI6DjPUbUZdUsMnpQL0OaG3VJunZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LEoMFO2ezaR4bOjMNdge16wwqjipsP38Wv1uWv31qi6qHiK5Zao+dHNJe3DBtT2yoiXzwAFL+WiJQhqfx+pbSoqtAyNxGEnEUA0SeAZA6Qnf5F6N+2wkClVcNdP7boKBa+nUHzXejBt/5Ek+9UWjnuALPtTNG+TDvuh1wHzvHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E5e8faDK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gp15/1o40tx19f6g5lxcL1ZqsKDK8j34/b7p8btRGpA=;
	b=E5e8faDKdX95wV+JWi05G4Iq6kCNVkEOJaXcs86uREeOME0fMp1bRKrOGQT/RbiRxYiooc
	ZwjSpRpgWBIKzjoMdNso3zo3yOmYJEnn08o+GtqPMv9DyCqEHHIPZfFfGwCFDIk6DxjJPJ
	EfgOhFcVJ3K5t6SfB4gJyioDlwaihFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-exvMBCBoPyGkfuGQOqaNvQ-1; Tue, 27 Feb 2024 18:21:05 -0500
X-MC-Unique: exvMBCBoPyGkfuGQOqaNvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41F3584AE40;
	Tue, 27 Feb 2024 23:21:05 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1512BC1596E;
	Tue, 27 Feb 2024 23:21:05 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 19/21] KVM: guest_memfd: add API to undo kvm_gmem_get_uninit_pfn
Date: Tue, 27 Feb 2024 18:20:58 -0500
Message-Id: <20240227232100.478238-20-pbonzini@redhat.com>
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

In order to be able to redo kvm_gmem_get_uninit_pfn, a hole must be punched
into the filemap, thus allowing FGP_CREAT_ONLY to succeed again.  This will
be used whenever an operation that follows kvm_gmem_get_uninit_pfn fails.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  7 +++++++
 virt/kvm/guest_memfd.c   | 28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bf616b7308..192c58116220 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2436,6 +2436,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		            gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			  gfn_t gfn, int order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2452,6 +2454,11 @@ static inline int kvm_gmem_get_uninit_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
+				        struct kvm_memory_slot *slot, gfn_t gfn,
+				        int order)
+{}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7ec7afafc960..535ef1aa34fb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -590,3 +590,31 @@ int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return __kvm_gmem_get_pfn(kvm, slot, gfn, pfn, max_order, false);
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_uninit_pfn);
+
+int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		          gfn_t gfn, int order)
+{
+	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	struct kvm_gmem *gmem;
+	struct file *file;
+	int r;
+
+	file = kvm_gmem_get_file(slot);
+	if (!file)
+		return -EFAULT;
+
+	gmem = file->private_data;
+
+	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
+		r = -EIO;
+		goto out_fput;
+	}
+
+	r = kvm_gmem_punch_hole(file_inode(file), index << PAGE_SHIFT, PAGE_SHIFT << order);
+
+out_fput:
+	fput(file);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_undo_get_pfn);
-- 
2.39.0



