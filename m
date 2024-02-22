Return-Path: <kvm+bounces-9398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0041D85FDB4
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9490B1F26D90
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC6315099F;
	Thu, 22 Feb 2024 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p5qUwkNV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EF4151CC1
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618258; cv=none; b=Yp3i6BTO9TPxn2EmdnQj4MDF8WtWmvn2GP98Nt40tjAZl56AoBhU6lsS4gAEt1dthFpAXSxhD7Yn7TVX95zWJ64fhdSx1Q+Nz+eu5+44V4Rv5ZRrSBk2Z6G6Zdtir6GRVP6cqmvcQGLONOjBxjbVrbzuNg4mdq4h32j+X+O0e1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618258; c=relaxed/simple;
	bh=L5WT52gMMJoNFswLSJnRNRF/xTYkLi12ITiLgSSDiDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6SZDfqJ6Y7Jtp5elWBi+5zFnI99vEZ73VYOIX+DwoeTVcv0VSbah+GbcnjS3CTNcIoX9h7gKfoh7MnFaSRpRTdpHrDbkjKHJL30XTVk6Ar+bYDB24CT1XiKcoIOcydyr0WUpnUXpd0fYFEc5f7CiykuZupOuhW3lk75O/1q4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p5qUwkNV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269686aso12494007276.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618255; x=1709223055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YmtKJX2F3rSkV1iqMOa4w31T6JycNyoitnxkU4chz4=;
        b=p5qUwkNVHpIwDXMbO+n7i87Y1UqHXbHdNXUy/mwQaj2QLd4aJ4w3Fcl8o28YQzGtRN
         YOK9pELKyuDO9DL8M1L80OGwOHO6TNElDIA++/nTNvTGsiJ6SkcoxX51mvXi71Q7chpD
         V8k4kbQCq46b8fgANWjbmoeQFbqOPtIQK0rA06ByLXrypjS7QWEtA64SIKiq0NhCX0w8
         VFLova57hdeijRfEt6FQJyuLSRWqrvKV9zJW64kLVZqszhDVUOj9VH5+kGbPnvesDMdk
         FrBaEHzTSe1xL3XWcUZYrxzJ6B8aHC/D6Nlt20fVtPUXWRrXtVUs2P9aMK/sL+t8k2v8
         Df1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618255; x=1709223055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YmtKJX2F3rSkV1iqMOa4w31T6JycNyoitnxkU4chz4=;
        b=XlHYcFhuqGdLdPb8l6RswVh2WN/1w8CUggWCUfZ9c9hNzQSminVvBvDHrRyM4lVVau
         goizE1jopJzXxdFSKqnXIXw6RB4xaDeNwT3xz+dCoK82wyLbSoMWoFm3/lG6xE9FiOjp
         iFehVJ9GGRHPgynVUhO2SdVS2OB5SaQw4EnfB410J8ndIYrS5sjHoIgYafiPDZpslw0q
         0pKwiWRx4ixKmltZ0KAPf3VPIUd7xP1juvpT7oSOWUJ9d0q+By4iYu/YM9aiVr+TzSHO
         lqA1aDzoDa45NJOAuc/yMuKIBCsDG6GdRVWOi7iuc5NH3N5Gp7o3RWT+2iC9KuRnktDv
         0kFQ==
X-Gm-Message-State: AOJu0Yyd1qAPV60BH3DeH9ji4SaVCE5BpvaaF9FA4kbDoOBug3rGvTsc
	nX0TJL+W6xEkdAIfGx3z4P8iVimQ6I+8GNgdw09/3k/5jgkPWtCQzTo8xrE533OYEHo/gF/GT/H
	63cOtNo7LyPVEOUuN5nWqjKd+EqWQtJaFA3EA7mjQ5nJjWLzsSSbC2tX8I/q8G9t2afZ0B8lzrs
	Ij+eNHXKlEP9SBzEvgMt7+sBI=
X-Google-Smtp-Source: AGHT+IEJ5uDx0DBdRtl2OUTBaLLNNcO1acG4EdiHb1aZlJ2UWKKk0H2LLLVqC/b2Z95QlvaYQ480iTjpKQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1146:b0:dce:5218:c89b with SMTP id
 p6-20020a056902114600b00dce5218c89bmr123764ybu.5.1708618255038; Thu, 22 Feb
 2024 08:10:55 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:23 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-3-tabba@google.com>
Subject: [RFC PATCH v1 02/26] KVM: Introduce kvm_gmem_get_pfn_locked(), which
 retains the folio lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Create a new variant of kvm_gmem_get_pfn(), which retains the
folio lock if it returns successfully.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 virt/kvm/guest_memfd.c   | 21 ++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4cacf2a9a5d5..b96abeeb2b65 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2381,6 +2381,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2389,6 +2391,15 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, kvm_pfn_t *pfn,
+					  int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..7e3ea7a3f086 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -482,8 +482,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
@@ -523,10 +523,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	r = 0;
 
 out_unlock:
-	folio_unlock(folio);
+	if (r)
+		folio_unlock(folio);
 out_fput:
 	fput(file);
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn_locked);
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	int r;
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, pfn, max_order);
+	if (r)
+		return r;
+
+	unlock_page(pfn_to_page(*pfn));
+	return 0;
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-- 
2.44.0.rc1.240.g4c46232300-goog


