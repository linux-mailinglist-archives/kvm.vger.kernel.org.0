Return-Path: <kvm+bounces-42177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E28A74DC7
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76B39188F5F9
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969201D6DAD;
	Fri, 28 Mar 2025 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLcyzWLS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841E1D54E9
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175902; cv=none; b=Son9jBEqPwpiY1QX/joQM+cF09O+dINTOUKmJUM+926CW/nq692frIhhUEZmgpY+BlnMcnS+t0TZKH82vH3RlkVnJdz5Jj07XzCP+X0WRdVUR1BLZtG6AYfoLZVRLqXyOqkCRmsTDpr6Tf9qoFQ4zVRC5ucBhKLrv1gsTAVR37k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175902; c=relaxed/simple;
	bh=pft+SQyppK60oO6cviL7FEd9sFkZha3RWok0vnNL+cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EQPgVPqZd6juSl3GYnJKevcS+QC/boIkfSHtPB9VccgcwxVi2wZmKQ7WNdzNgZs7LsE1n2iD+7h/Zidus/OH9YS1V/8L85vrYqJuoNQhDs4Oo1OG1nrIA8WF2NRMh5DEMSqKaB22+2hYju5I/2xHzLOd4vbH2DGcofSYleaU1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLcyzWLS; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3913d8d7c3eso1272144f8f.0
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 08:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743175899; x=1743780699; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zBwVWT3bMzuxYkVzph9Re975E4ZOgPSLG5vu5hERwkU=;
        b=xLcyzWLSFHcLUHCq//U6TZtgA3IGs9zpj/xWrPMW9JAyoGzOqtLe4LuJ5gOfTdRW6P
         pCHXmAOIqoB0Ql177ynu9Gtjf9FcVpDeLcDD1W0rMm+/uuhzFGSpdzXfPzIgecqvxTXS
         o+QWeqr4BZQk5uROCGWraC7HW8VzurPAlZPYPbuwZPC+e46DS+FNiLC6d7ZKvctTlI4c
         GdgoRhhtMFBkDmZGOO4+k9iDVVj/H4Nv+f9vakWbowE1p8NTIeHfl8njTeZzsbPw12Tq
         w9hU3AArh7UoJLS+bZDBhYDkFy6ZadOhljAft3g+ownfg0KyikDtGfw77bLhUE8UhABk
         y3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743175899; x=1743780699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBwVWT3bMzuxYkVzph9Re975E4ZOgPSLG5vu5hERwkU=;
        b=KXy29NJn3AwrXTeLhGUUPUgkLbrI1GDVHetljKh5YCySbMjnORRQqLAeAvegmCL3jv
         hiuZSDKlW5eJsavPTTOZcK/votw87v1IYeh8Lo2Wevcd2H9FO2vYDl8VmOXNzgNBuJ4Q
         8lfq6PJjnbyrMvWU2ZKNkS86JQHNhSPi9kQ2CilbTS4nd3gh26SWf7IAoZpUMl9rp3rk
         DVMyFmqSgKc9eN1j4XfIOyG/xcypyPTVumlEBQK+NPFFdmyjNmcQo0H4aANK1e2pDGVr
         myC2HCV+UK3uGsWImvPQTHn5FNXP9I6kgL17Iiok5BMH7v1OhW9EWhRLCTtu32F09Wch
         fm1Q==
X-Gm-Message-State: AOJu0YzShertZTvRubDFXceMZM+4DOGtBA+JFLsz0JqtOnYunpHo1KYR
	6U6tSyuxptG6RZ914ZDzpwKT0YYsQiitrr7rmSYiKa8sMmc6vM8tTrJFS4AwA4aUUZG6t2YSFh5
	6r6PWeoZ5xwfZ9Z4VnWdKEhLhok+1Illwc4FrxCBz1uRsCfK17QXLQDSaeC5hlAQwROV62gOrOT
	sh1lIA0KXZm9WSAUiyPlDJmVE=
X-Google-Smtp-Source: AGHT+IFjfxf6/c4YGYpRR8ebQgMC7nETbgoP7o3HpJ1E0q7VHYEiUY/Sncl1PhAsgk21ab/L2t0C6VGu3g==
X-Received: from wrps2.prod.google.com ([2002:adf:f802:0:b0:399:7a0a:493f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:18a8:b0:391:4559:876a
 with SMTP id ffacd0b85a97d-39ad1794cd7mr8199077f8f.46.1743175898942; Fri, 28
 Mar 2025 08:31:38 -0700 (PDT)
Date: Fri, 28 Mar 2025 15:31:28 +0000
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328153133.3504118-3-tabba@google.com>
Subject: [PATCH v7 2/7] KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(),
 which retains the folio lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Create a new variant of kvm_gmem_get_pfn(), which retains the folio lock
if it returns successfully. This is needed in subsequent patches to
protect against races when checking whether a folio can be shared with
the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 virt/kvm/guest_memfd.c   | 27 ++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec3bedc18eab..bc73d7426363 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2535,6 +2535,9 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+			    int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2544,6 +2547,14 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, kvm_pfn_t *pfn,
+					  struct page **page, int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 844e70c82558..ac6b8853699d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -802,9 +802,9 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	return folio;
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+			    int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
@@ -824,17 +824,30 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!is_prepared)
 		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
-	folio_unlock(folio);
-
-	if (!r)
+	if (!r) {
 		*page = folio_file_page(folio, index);
-	else
+	} else {
+		folio_unlock(folio);
 		folio_put(folio);
+	}
 
 out:
 	fput(file);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn_locked);
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order)
+{
+	int r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, pfn, page, max_order);
+
+	if (!r)
+		unlock_page(*page);
+
+	return r;
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
-- 
2.49.0.472.ge94155a9ec-goog


