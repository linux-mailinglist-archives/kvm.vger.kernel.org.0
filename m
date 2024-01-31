Return-Path: <kvm+bounces-7617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D01844D04
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 323671F2D182
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B3B46426;
	Wed, 31 Jan 2024 23:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cRBN8eyo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8453BB50
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743862; cv=none; b=l4IG1lrZu/FvM5pKTeS7r6uoakIbqAEzRLZ00SpEdxSMmFbQjcTaDclNtqN+yyTWkXEx5DTslhnRuh3IawLowTw4cKdO2DQ+r6/KcPuEvDDtdWjx3laSDIECilOoX5jgOa2QHv8fwPKN8FS7j47WcEKtDm+zyR7UwsAkECmuLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743862; c=relaxed/simple;
	bh=NhyqOTC+iPTISMZZnFTimq/nANv46xw9EN49JJUfr2I=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gx573dCvkRkF+z6Z09jgyehAR7xW24Gv4oJttZ7S6j9R3S1BDZa7ZC5hfbiI0acubgPTKVGcDS6yNTpEG2R9hh+FQSUnO4wNDPjkYAdt73vdQdNl3hOoz9RwAqnyBaeoh5RhPER6FM2whACe4PwyAqC6CfrkCkGpH1oUPjy96Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cRBN8eyo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJvE1SRsR/qR/by5RcNBKVAxpeGKj1Pas8p9l7Jbyao=;
	b=cRBN8eyo6tqjTVtKiGaRH7CI0paisv8evg9c4Q8VyWw1BHHOT1NItqfv5tJjqH9hYE4qdU
	roLXwghOXoXAY/sWQwDOJtPjt9bjBUjVnk2lPeCjds90g3NB70+2v8lJMpQpqXuEYu/5HK
	ErRnWSKwjUAgT7x4SOj7xNekrZe/TTs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-P_n42ALDO4CirAnq__DfYA-1; Wed, 31 Jan 2024 18:30:57 -0500
X-MC-Unique: P_n42ALDO4CirAnq__DfYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ECBF101A526;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 071C6C2590D;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 3/8] KVM: powerpc: move powerpc-specific structs to uapi/asm/kvm.h
Date: Wed, 31 Jan 2024 18:30:51 -0500
Message-Id: <20240131233056.10845-4-pbonzini@redhat.com>
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
References: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

While this in principle breaks the appearance of KVM_PPC_* ioctls on architectures
other than powerpc, this seems unlikely to be a problem considering that there are
already many "struct kvm_ppc_*" definitions in arch/powerpc/include/uapi.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/include/uapi/asm/kvm.h | 44 +++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h            | 44 -----------------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 9f18fa090f1f..a96ef6b36bba 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -733,4 +733,48 @@ struct kvm_ppc_xive_eq {
 #define KVM_XIVE_TIMA_PAGE_OFFSET	0
 #define KVM_XIVE_ESB_PAGE_OFFSET	4
 
+/* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
+struct kvm_ppc_pvinfo {
+	/* out */
+	__u32 flags;
+	__u32 hcall[4];
+	__u8  pad[108];
+};
+
+/* for KVM_PPC_GET_SMMU_INFO */
+#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
+
+struct kvm_ppc_one_page_size {
+	__u32 page_shift;	/* Page shift (or 0) */
+	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
+};
+
+struct kvm_ppc_one_seg_page_size {
+	__u32 page_shift;	/* Base page shift of segment (or 0) */
+	__u32 slb_enc;		/* SLB encoding for BookS */
+	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
+#define KVM_PPC_1T_SEGMENTS		0x00000002
+#define KVM_PPC_NO_HASH			0x00000004
+
+struct kvm_ppc_smmu_info {
+	__u64 flags;
+	__u32 slb_size;
+	__u16 data_keys;	/* # storage keys supported for data */
+	__u16 instr_keys;	/* # storage keys supported for instructions */
+	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
+struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+};
+
 #endif /* __LINUX_KVM_POWERPC_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9744e1891c16..a5458aeee018 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -810,50 +810,6 @@ struct kvm_enable_cap {
 	__u8  pad[64];
 };
 
-/* for KVM_PPC_GET_PVINFO */
-
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
-
-struct kvm_ppc_pvinfo {
-	/* out */
-	__u32 flags;
-	__u32 hcall[4];
-	__u8  pad[108];
-};
-
-/* for KVM_PPC_GET_SMMU_INFO */
-#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
-
-struct kvm_ppc_one_page_size {
-	__u32 page_shift;	/* Page shift (or 0) */
-	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
-};
-
-struct kvm_ppc_one_seg_page_size {
-	__u32 page_shift;	/* Base page shift of segment (or 0) */
-	__u32 slb_enc;		/* SLB encoding for BookS */
-	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
-#define KVM_PPC_1T_SEGMENTS		0x00000002
-#define KVM_PPC_NO_HASH			0x00000004
-
-struct kvm_ppc_smmu_info {
-	__u64 flags;
-	__u32 slb_size;
-	__u16 data_keys;	/* # storage keys supported for data */
-	__u16 instr_keys;	/* # storage keys supported for instructions */
-	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
-struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-};
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
-- 
2.39.0



