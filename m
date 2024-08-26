Return-Path: <kvm+bounces-25097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D51AF95FAE8
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 537E11F2407D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E4D1A0AFA;
	Mon, 26 Aug 2024 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xnryqcbg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248E1A01DB
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705076; cv=none; b=TbiQw1lYOjJfnKRbZpQCU2wp20qjIw6KHXvGVCZrMfptluMf+bTOXjvmeCaV4ufKE2JJ5DeAQ/F9mxXyIaLCSDXExYHxntSTHEDvgFq6U7F6ARRTTxTpQZU/GER8bny9mj3EIytm4MQY8B4PVkGRSeNrLoBG74ZyAXHwFmN4+rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705076; c=relaxed/simple;
	bh=wO6hxJPqfj9KTLTi6qw+v+hbYJLMemjraAGsqutmV4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naHwl/kO+MMEBPD67qa2JqeIa/OshpMZJM0sbxkMo1YBFbx6qh+BqXcjbb8Sasj0Iy30kT+bTRTTqDGCJYyMtX2G02Ao6sRAAzBfnafTDuzLXfTwnyo8K3ZEhmM/8Jja5cTSrYOMyxA8FdNUscpFK+ZjIMYMhm1yqN2LUUQDhB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xnryqcbg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IC5gYR+7Z4BwAPnZp8TN8XZEGypCYGRNkok3NV40z5s=;
	b=XnryqcbgleFQu7wsb3ArLf6EE3uUSWK//GXhMsmI9jW89K3rTSNw8kygWmA0SGqz0athRd
	P0i+HBcJyIOLsfUVtZBF9Mdevx+gcNdBbkaevSQ3/zDJYfmURFjtntrnfHi53v0EQHdB73
	oIVlDZAi35dyCKAnpTAe3PGb1GScXck=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-lrBThTgZOiuBEcvW-3fRfg-1; Mon, 26 Aug 2024 16:44:32 -0400
X-MC-Unique: lrBThTgZOiuBEcvW-3fRfg-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5daa93afe1bso5814885eaf.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705070; x=1725309870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IC5gYR+7Z4BwAPnZp8TN8XZEGypCYGRNkok3NV40z5s=;
        b=uQjlsE56F7hkcCWBaNE1xWo5RdEcCsG1VkkQqW6JEUkie2es1gAvL1JRKuHuaelB2k
         PFkiTGKKo28AZgYI2SWGaAdyV30Img/OgZH9pnt4drGOvBOziU7R62TUNU5DhMroYAsV
         piC2NElakSXPwbE9+BwEJ0B2Y/xAGpDXS7eDIPW8bNfnCkm83ULuO6LeaewssjpUrgY7
         yzonpSZdWmPHJgiR8+PAyojIHBiNrMfnQuNd7s2eIjeWa1eJkflxhcqwtem/7sArk+/i
         c3OSZfMRDUQRwX6t12KfyxbvYGCUQg1GBYaJZCx5mz/49Dm4p8isdxsO41/QkPqwMEC5
         mxmA==
X-Forwarded-Encrypted: i=1; AJvYcCV4gDPJMfgLT7lX9mrwpFduNzoxp9kLZv/P2CLA2JwN1ugSqncWG+7Lo2oQyPvkCVhDAlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrFnHadzQzSugNdg8LCo/Ft4tCIcqKrBF9TFsDeRRzQIP7runE
	hAgY12Hs+KbClh4t5wyDpMmKNpmyBEFyCq6jx3cxmfVXgGCRsLej1tPJT8QGJ1yuPtDFgpPG3xI
	Eury6IvBE8R0vx4dJF1q0eguz+yBFy8PIEDAjFftxXOsRILfI1w==
X-Received: by 2002:a05:6358:70c3:b0:1ac:f00d:c8c6 with SMTP id e5c5f4694b2df-1b5c22ebd07mr1493541955d.27.1724705070547;
        Mon, 26 Aug 2024 13:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWRaHJzCfl4jAxAoYVG6HBrfG1+v3SSmaZHfZSlba6wG4sR68STMcFscyvu7mDZcazVEGWKw==
X-Received: by 2002:a05:6358:70c3:b0:1ac:f00d:c8c6 with SMTP id e5c5f4694b2df-1b5c22ebd07mr1493538355d.27.1724705070146;
        Mon, 26 Aug 2024 13:44:30 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:29 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 17/19] mm/x86: Support large pfn mappings
Date: Mon, 26 Aug 2024 16:43:51 -0400
Message-ID: <20240826204353.2228736-18-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Helpers to install and detect special pmd/pud entries.  In short, bit 9 on
x86 is not used for pmd/pud, so we can directly define them the same as the
pte level.  One note is that it's also used in _PAGE_BIT_CPA_TEST but that
is only used in the debug test, and shouldn't conflict in this case.

One note is that pxx_set|clear_flags() for pmd/pud will need to be moved
upper so that they can be referenced by the new special bit helpers.
There's no change in the code that was moved.

Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/Kconfig               |  1 +
 arch/x86/include/asm/pgtable.h | 80 ++++++++++++++++++++++------------
 2 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b74b9ee484da..d4dbe9717e96 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86_64
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8d12bfad6a1d..4c2d080d26b4 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -120,6 +120,34 @@ extern pmdval_t early_pmd_flags;
 #define arch_end_context_switch(prev)	do {} while(0)
 #endif	/* CONFIG_PARAVIRT_XXL */
 
+static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return native_make_pmd(v | set);
+}
+
+static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return native_make_pmd(v & ~clear);
+}
+
+static inline pud_t pud_set_flags(pud_t pud, pudval_t set)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return native_make_pud(v | set);
+}
+
+static inline pud_t pud_clear_flags(pud_t pud, pudval_t clear)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return native_make_pud(v & ~clear);
+}
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -317,6 +345,30 @@ static inline int pud_devmap(pud_t pud)
 }
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SPECIAL;
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SPECIAL);
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_SPECIAL;
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_SPECIAL);
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
+
 static inline int pgd_devmap(pgd_t pgd)
 {
 	return 0;
@@ -487,20 +539,6 @@ static inline pte_t pte_mkdevmap(pte_t pte)
 	return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
 }
 
-static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v | set);
-}
-
-static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v & ~clear);
-}
-
 /* See comments above mksaveddirty_shift() */
 static inline pmd_t pmd_mksaveddirty(pmd_t pmd)
 {
@@ -595,20 +633,6 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 #define pmd_mkwrite pmd_mkwrite
 
-static inline pud_t pud_set_flags(pud_t pud, pudval_t set)
-{
-	pudval_t v = native_pud_val(pud);
-
-	return native_make_pud(v | set);
-}
-
-static inline pud_t pud_clear_flags(pud_t pud, pudval_t clear)
-{
-	pudval_t v = native_pud_val(pud);
-
-	return native_make_pud(v & ~clear);
-}
-
 /* See comments above mksaveddirty_shift() */
 static inline pud_t pud_mksaveddirty(pud_t pud)
 {
-- 
2.45.0


