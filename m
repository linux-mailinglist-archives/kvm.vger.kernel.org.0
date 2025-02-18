Return-Path: <kvm+bounces-38463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B323CA3A437
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8759218950FF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCCD270EBD;
	Tue, 18 Feb 2025 17:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M81hSJK+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC1B26FDB6
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899510; cv=none; b=VHEVLuJq4JS1rRaQRoNIFOsd8GZuCBfRnu3akDBXhioT2T6YlAxI1gd+7HcxQxH09wFT0dUrYATlXn0FYbj+ojGmu/C1MIJ6TvWa8BgqIzgoaVpzoy21w1Im9SfoaohpKucuznZkI58sYu7Em0lw+Pc2VosiovkN8CgFTn4ZTyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899510; c=relaxed/simple;
	bh=u9WeaqoYpfHKmRmmzcElNWGZqz/3dlVhJ0TSKGp8j+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ALtNs9PB4Cy3VwwtA4Tbt1W/EcAVwLxV9Xq6f9poyhtcDI0N1Jni0GtQE+NciuBbJbuzrVwwvq0aFQ+IntCV33adsfaLo24oEIk+6tG9v58+JvIdL3opHtw0qf1wtqUtrJNqoNcqg8gy7sTwaSFmIGIAqmHJphI3eDbDmFiN4YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M81hSJK+; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f36fcf4b3so2183355f8f.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899507; x=1740504307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjftRHL78GvMAxQBgln24N5MOtatVF4iZ/akwpMzsOQ=;
        b=M81hSJK+Q3sdWgxFFg7/KDKl7c5FavjxZTmh5qYf8B3CBiY73MRawH8fGp487TjXiR
         ASlSwI2wJSJa/YylPBTq2oELgdnn0dfOI3YcoadzrpV3WCObIzmlsFJEQxvw0oVa6s6Y
         GVuxxMlNHTG/cm0TG/JSq1Ot59eLXtCVZrA8/Jn1BO9+HmXpZgGBxniJYUwiNmvhM+TN
         tvHVu5RXE3dnXdsFWrsY3JikmYUlQtCMuNfkJtizyktq6gmcNmEv4uMXJTtwSjPjYDtB
         ZEJr/pIl3/ismJAVzhqHJ/QRbW/uamTVhIGCVDBogyzxvQ2voLYBNWYzgYEO2QEDLME2
         hF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899507; x=1740504307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjftRHL78GvMAxQBgln24N5MOtatVF4iZ/akwpMzsOQ=;
        b=k6KzsFEflpcDm8ROJOgrVdUcSy4GBkteVUC7POOpMzlte2LA6gUymXgZV+sMbUcW+R
         VP/pEm+tZx4EGVrMVXRHPpvcxIsUjuBZyG9QSLnTs2BBLDdXxG0U52oq5+I3w+DB9aj2
         i9Df5uq8fXtRLjnSqJJHiZzVO7BeMoJcK+CBjBhtaJ8dLYLJuXaAUtM1gW/6AcA8CkMu
         nrGWl/wN2xQk4DLJgKDB5tKJK7x7eavU8bYptwKdl2veEiRNAe0N/++UQphUYLFP0ofk
         dTkoooCQCjcynDBJf1+AwXcQFU7tUni9S17pjBNyk5NDjNUjPWQyKkWvYB66u5UwA7t2
         MNrQ==
X-Gm-Message-State: AOJu0YzPtoIYrdK+4m60tXiR6LZ8olTF7gc0xLk/tITytmX+cQL0F10b
	Y/06WzGKZnFujA2OdgvjpbcL8Ic5QCXZwvTb+AXc0S0uc8WKiHF7pN5X/PG4aFtcWJblsYdTJlH
	1kUZlOpEC2f6YBc8yg0yaePC37c+BuX+Xn7kRGidtXBL+sk2oAHQTzYiueHhYZ+4jP7DIITI52p
	TWZ2D4HXFxnP/lT+HqcuBgJi4=
X-Google-Smtp-Source: AGHT+IGtq1vI9mi82FBNTYUNeT9g08nt9Gn+a8vjX9kYrGKRZeaCmPiZJOk8GXgumjV4Sq5SnZyiJoW2cQ==
X-Received: from wmbg4.prod.google.com ([2002:a05:600c:a404:b0:439:9601:298d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5850:0:b0:38e:90f3:475a
 with SMTP id ffacd0b85a97d-38f33f55023mr14469841f8f.51.1739899506921; Tue, 18
 Feb 2025 09:25:06 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:52 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-3-tabba@google.com>
Subject: [PATCH v4 02/10] KVM: guest_memfd: Handle final folio_put() of
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
	jthoughton@google.com, tabba@google.com
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
---
 include/linux/kvm_host.h   |  4 ++++
 include/linux/page-flags.h | 17 +++++++++++++++++
 mm/debug.c                 |  1 +
 mm/swap.c                  |  9 +++++++++
 virt/kvm/Kconfig           |  5 +++++
 virt/kvm/guest_memfd.c     |  7 +++++++
 6 files changed, 43 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..3ad0719bfc4f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2571,4 +2571,8 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+void kvm_gmem_handle_folio_put(struct folio *folio);
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
2.48.1.601.g30ceb7b040-goog


