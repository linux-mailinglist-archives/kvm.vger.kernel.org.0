Return-Path: <kvm+bounces-39903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD7DA4C97E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1695717E18F
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9D222E3F9;
	Mon,  3 Mar 2025 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bbFNaiSa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB1E22E410
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021823; cv=none; b=G3+2yUiTDVrclwhLSDY+BuqMzK6mmOoMzT6CJqQL9tdJIJTwpr7vZcQLR+jA8S3eUAnAm9BVHrT5eN64WOCfNOS0bgGOADUtg0Ck7os1XZBeFZIobVEYWZDehuj/pkKCdYDATn/ZnQwmQHhQwcw5WnQwDHcUZQTJiPA3pE0CvlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021823; c=relaxed/simple;
	bh=28EFBKCZw3l6FNCPthRE40BpPOj+wO1/hWE45k0kfu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O3hy+/H7XOBepUOF6DjZozbuiBaFU7DXeHZOfLulwBsxN4pces1f4e4OrVDjxHpaul3QGzS6jLs6aVRLBSekswhVS7f6J7kji9uce2jFPHhj6GmM2FauaeGFTFaEANBrlAda38OgPo9AGMrnDvzl5LbEUPMGS9rEcOzFgTEDPBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bbFNaiSa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399a5afc95so18161475e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021820; x=1741626620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRXCGSvCKi8KFNLeYd6jvsHWuv061HBQkZp/LgnTXzc=;
        b=bbFNaiSa8ywRmzNGwqIWi/7Arl3e/avvW9QTmCIl+OD0rvzqAGDrKmJ9a65esS574R
         7UZ64Ew3Ks1B9wqomF4x/mJxm55k8ZK03cGa1HWoSCu6hc07v6y3vq6RzJFSb91WBDeD
         dDRShz1dptcMECBEglHCH0kyMK5lIkxzS8D84QteMm0p5wD4qb4SjI5dv9L133mLACeK
         57Lz+7TEsbul1CLex0Z4ilbD6HhKtWZsPIQlqNxZ91fKl3WYTxpSRr23peCNiHm93jlt
         B/VzyPkfGPw1joUHYpdzsvxJjRqjNRNXOYNgdhdtrbpA4nbvKNFGu3VPKVmsZSzR2IzO
         5ONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021820; x=1741626620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRXCGSvCKi8KFNLeYd6jvsHWuv061HBQkZp/LgnTXzc=;
        b=GnMpa0I9JbdW3zS5p/m0vmTdZThkBSjmkxGXXffCXlRCK6Mu23Zq0Qn53FtgjL+JX8
         tTTBv0jmCiSIEXSoKnp4vYP39grE5EtSVnqvZ9e/TRaxSEJZg2G+sLBvO9ri4HUvLRdj
         K85+GsPiPYqC/11oY9/0I2OMLjCJ3Jt5lMBNSNC/vqCkLA5Zsjlxl2Mw5pn3udayma0h
         H1SbNJg615MZsSr25QfLzAEF/7K7nDqjn0GZQ4ZMr4InVHzyAyHotdCAFxdct1re2G6I
         xti8pxiW5fOfk3juT0BmPaEsKxM5XpEYGCTlK06a86iGxfUJugFuJk0vsxnKMyc10Tot
         c5Kg==
X-Gm-Message-State: AOJu0Yzyp+lTwQm7fwDEfDEKaEBbobuP2NABUoR9k+g1rXYMipUGZimi
	y1S//3jg6oLJRn4MfiJ0Zq71eDDSmsYGAzT1AtxHlV+rCLCIx1Hq2iHQAYmejQMTMvmelTLU5LN
	A/eCZjozgjxumDvPEswcKG/HOq8p7FU39XwjSGGIGeUuoKJbnysgSCDm7C3I6/4WKQs/7V5mVTP
	nPd2E+k9itY07aMA/KVvHjQJg=
X-Google-Smtp-Source: AGHT+IHiT+g0b2FcJU3pHgUKOxKohFEOEB1W2gcQabUIaCdSRC5gA7558TblaDocxHQhpruqsN96dOjIwQ==
X-Received: from wmbet10.prod.google.com ([2002:a05:600c:818a:b0:43b:c9e4:2160])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190a:b0:434:a4b3:5ebe
 with SMTP id 5b1f17b1804b1-43ba675830emr94037315e9.24.1741021819910; Mon, 03
 Mar 2025 09:10:19 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:06 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-3-tabba@google.com>
Subject: [PATCH v5 2/9] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Before transitioning a guest_memfd folio to unshared, thereby
disallowing access by the host and allowing the hypervisor to
transition its view of the guest page as private, we need to be
sure that the host doesn't have any references to the folio.

This patch introduces a new type for guest_memfd folios, which
isn't activated in this series but is here as a placeholder and
to facilitate the code in the subsequent patch series. This will
be used in the future to register a callback that informs the
guest_memfd subsystem when the last reference is dropped,
therefore knowing that the host doesn't have any remaining
references.

This patch also introduces the configuration option,
KVM_GMEM_SHARED_MEM, which toggles support for mapping
guest_memfd shared memory at the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/kvm_host.h   |  7 +++++++
 include/linux/page-flags.h | 16 ++++++++++++++++
 mm/debug.c                 |  1 +
 mm/swap.c                  |  9 +++++++++
 virt/kvm/Kconfig           |  5 +++++
 5 files changed, 38 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..7788e3625f6d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2571,4 +2571,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static inline void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
+}
+#endif
+
 #endif
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6dc2494bd002..daeee9a38e4c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -933,6 +933,7 @@ enum pagetype {
 	PGTY_slab	= 0xf5,
 	PGTY_zsmalloc	= 0xf6,
 	PGTY_unaccepted	= 0xf7,
+	PGTY_guestmem	= 0xf8,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1082,6 +1083,21 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
 FOLIO_TEST_FLAG_FALSE(hugetlb)
 #endif
 
+/*
+ * guestmem folios are used to back VM memory as managed by guest_memfd. Once
+ * the last reference is put, instead of freeing these folios back to the page
+ * allocator, they are returned to guest_memfd.
+ *
+ * For now, guestmem will only be set on these folios as long as they  cannot be
+ * mapped to user space ("private state"), with the plan of always setting that
+ * type once typed folios can be mapped to user space cleanly.
+ */
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+FOLIO_TYPE_OPS(guestmem, guestmem)
+#else
+FOLIO_TEST_FLAG_FALSE(guestmem)
+#endif
+
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 
 /*
diff --git a/mm/debug.c b/mm/debug.c
index 8d2acf432385..08bc42c6cba8 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -56,6 +56,7 @@ static const char *page_type_names[] = {
 	DEF_PAGETYPE_NAME(table),
 	DEF_PAGETYPE_NAME(buddy),
 	DEF_PAGETYPE_NAME(unaccepted),
+	DEF_PAGETYPE_NAME(guestmem),
 };
 
 static const char *page_type_name(unsigned int page_type)
diff --git a/mm/swap.c b/mm/swap.c
index 47bc1bb919cc..241880a46358 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -38,6 +38,10 @@
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+#include <linux/kvm_host.h>
+#endif
+
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
 	case PGTY_hugetlb:
 		free_huge_folio(folio);
 		return;
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case PGTY_guestmem:
+		kvm_gmem_handle_folio_put(folio);
+		return;
 #endif
 	default:
 		WARN_ON_ONCE(1);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..37f7734cb10f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_GMEM_SHARED_MEM
+       select KVM_PRIVATE_MEM
+       depends on !KVM_GENERIC_MEMORY_ATTRIBUTES
+       bool
-- 
2.48.1.711.g2feabab25a-goog


