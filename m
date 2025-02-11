Return-Path: <kvm+bounces-37848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F27A30B68
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C3E188CB4E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6FF2206B5;
	Tue, 11 Feb 2025 12:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R3QDRiSI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BC221E094
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275898; cv=none; b=cvUNYsAFeOhZxXypRdM24xG8yVxKqSclOaCKB6ta3RrsHlFln5+zqV8p0C0IgQ+FjmMz/4YNwwWzXSm3HilqpA54snhJunhLkqWajGIdL+ACI6ufTG7jdaiR3GG73cz/SJjRIt0+JBd4gFuQYxCtsw9AEf0hERdLyGDpNqVyuIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275898; c=relaxed/simple;
	bh=DjLAQsoXdnPl6GrE+/GdZCahvPNjPTRXwCDe2y5OqLM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CCtXbofcyG9+4l1TlRNi8AerzxGpRrSRQn99bKyFlgwQvXXsInnp8dYZwznCRaR/N4RNdUZwMpbW7Bie5pC3r1LLToOrqXroUNYXDcr7ZgIJABpMYsqrc3nIJLFM1OqCi+q4jMG0XGMcdPY440hiUFkY0uOQC6Q77YCw2DwDiFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R3QDRiSI; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4393e89e910so13393655e9.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275894; x=1739880694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWMrByBHh6bCcS+Ah6m7GoQirIP0Jem/nT3gsSQXFpI=;
        b=R3QDRiSIQRlhy2Tp9S0t4jmSLmVCcEXaTaeYftpPN5PFtcpuFrDn1TljeqpZWchmba
         kln1J+33DsBKa+guDyAuOUdU5LQSyQV6HfWQNgbtPO/VQHDMCaOWKUUl2CViBZwA21Q8
         cCmaOGjuAWl/ctV7iIGXhGVzEGtWV0eShd1YIvZjIIi0oBajOw48Iu3hkkgpva4JmCWt
         HVMRm4k+AdAyyPtH3Hm4YMDmn2U7hreDrTZMWRR2rM4py2pxlo4IydmzW3ovv5NvE2Fa
         NU8dxe9Ud7rGZmvL4nwPZ8PF+eg5GMesNyUgvmLDSAILlQN1qvKShTfTysSaNPv+5ipj
         ngfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275894; x=1739880694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWMrByBHh6bCcS+Ah6m7GoQirIP0Jem/nT3gsSQXFpI=;
        b=dR1LUCOK3snenYC46znQKBw8ij8R2g2DetHuzMWu9ZRD/0yykkqCTUcF2xegOWP86W
         UwRIdlbME0x/g8aNxnyAp5/ugTYtcAK88gInQbh16hrwxzYS3BIcr/FEY1CC4/SWEIeS
         VQulcRS6SAIt9y9UK0gT+MRTZA95kO2UBjd7+s63VvO1OOWVixNW2rvSnIFvAP5IrK6u
         +1NQbwI/XddMqHmcdfSt+/EEeeikSMQoYWeK92dCVAs+9kh/GjMnX58JIw5u+WKMUrgF
         ZPHEyQ1qBi6Swv4asp0hsmea5YJZDOisiwPS6cuuTaq7s89Y0rijYwHXVMVYgsdqSnll
         48Gw==
X-Gm-Message-State: AOJu0YytakWVwokp7QbYCt1Gkn/9JF3x3/EsfrIqcvbzJ7S45iAPScsH
	tBypS4Ve1eG14ardEhw89L6fAO/ft4OGmPaFuYKhTwHpI+w7m4ihLWXcmXmapnU83geqmpDDS3J
	tUJ2AjucWE7bz88iZYELpOoB+r8RjQ0MMAXpDMBZKxOGxIAr4poQAeplnVDXYACNZ20+p8eUlCD
	BGUyl5DNJwycUAoJwIevy7Wzs=
X-Google-Smtp-Source: AGHT+IE8Ghyq44OOrdMI7rTy32U9k2qC1vm1QBwY+iABDYDzlSXr3Wt1H56p+D7BVdWhTRPrbKtMom5fBA==
X-Received: from wmgg10.prod.google.com ([2002:a05:600d:a:b0:439:432f:cc11])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:ccf:b0:439:56f3:d40f
 with SMTP id 5b1f17b1804b1-43956f3d5c3mr1028375e9.21.1739275894075; Tue, 11
 Feb 2025 04:11:34 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:18 +0000
In-Reply-To: <20250211121128.703390-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-3-tabba@google.com>
Subject: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Before transitioning a guest_memfd folio to unshared, thereby
disallowing access by the host and allowing the hypervisor to
transition its view of the guest page as private, we need to be
sure that the host doesn't have any references to the folio.

This patch introduces a new type for guest_memfd folios, which
isn't activated in this series but is here as a placeholder and
to facilitate the code in the next patch. This will be used in
the future to register a callback that informs the guest_memfd
subsystem when the last reference is dropped, therefore knowing
that the host doesn't have any remaining references.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h   |  9 +++++++++
 include/linux/page-flags.h | 17 +++++++++++++++++
 mm/debug.c                 |  1 +
 mm/swap.c                  |  9 +++++++++
 virt/kvm/guest_memfd.c     |  7 +++++++
 5 files changed, 43 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..8b5f28f6efff 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2571,4 +2571,13 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+void kvm_gmem_handle_folio_put(struct folio *folio);
+#else
+static inline void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ON_ONCE(1);
+}
+#endif
+
 #endif
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6dc2494bd002..734afda268ab 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -933,6 +933,17 @@ enum pagetype {
 	PGTY_slab	= 0xf5,
 	PGTY_zsmalloc	= 0xf6,
 	PGTY_unaccepted	= 0xf7,
+	/*
+	 * guestmem folios are used to back VM memory as managed by guest_memfd.
+	 * Once the last reference is put, instead of freeing these folios back
+	 * to the page allocator, they are returned to guest_memfd.
+	 *
+	 * For now, guestmem will only be set on these folios as long as they
+	 * cannot be mapped to user space ("private state"), with the plan of
+	 * always setting that type once typed folios can be mapped to user
+	 * space cleanly.
+	 */
+	PGTY_guestmem	= 0xf8,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1082,6 +1093,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
 FOLIO_TEST_FLAG_FALSE(hugetlb)
 #endif
 
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
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..c6f6792bec2a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,6 +312,13 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
+}
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 static struct file_operations kvm_gmem_fops = {
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
-- 
2.48.1.502.g6dc24dfdaf-goog


