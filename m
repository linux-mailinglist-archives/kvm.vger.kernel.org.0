Return-Path: <kvm+bounces-25081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F5495FAC1
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B024D1F22DDD
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E385E19AD6E;
	Mon, 26 Aug 2024 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3fg5EpP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF61991AD
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705043; cv=none; b=G3UIFCtHNDLdFR6n43BptXm3ZMphorlUoo317yhAK+y0kV5zi80p9CNGOrCsdqO3WHYX0dIHAGKCq5np4ll0J6cr6tx6CyOSO6+arcORTCl6joNBdJhwRnOYZ3BOugB10ZoN4lwcX2DnCuY/BZCgKjjA1hKCA0NT+sNf8SP6JNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705043; c=relaxed/simple;
	bh=bqt9KW78i0VdjWfmtysLtEN3zBnedLCNShRvlblkAoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iszhFdfJrp86GDQo6vnyLtbGxXimY988Lm6tzslYc6vJZi9CJ8OveIsUYRNT7dPKDFaM8m+SdY5HuI+ROktwjzOFf/iBROs/zBwgIaOgJPxdKd5fG8TlOPewloAzHfO/ZwviLMwQ0+E2ji0h1Lfz/a77aSHI1CNo2URxSO1BDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3fg5EpP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iIRbDNVyj1lHjlop0tZMw2JlHFFftRtxMxE0Q8z7r8=;
	b=c3fg5EpPMAJICZzAXDP+/qtDO0C1D4KaRU1POn9CQfncMnMJ+Kx85jVXZSq3Ur1J6oriyh
	dfXh0yGD7IIURES8z8TJSkMoKXNayXjuox17jSONloLARvB378svLZyawivjAR8ITBw8tg
	925LPXb66qEnH20xdjxHAQg2R5QOpSg=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-YAVOKIf2PJewiJp4brwPIg-1; Mon, 26 Aug 2024 16:43:59 -0400
X-MC-Unique: YAVOKIf2PJewiJp4brwPIg-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5de842f4435so3259462eaf.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705038; x=1725309838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2iIRbDNVyj1lHjlop0tZMw2JlHFFftRtxMxE0Q8z7r8=;
        b=ni9jrMPDsVMBM3jF5Gt2K48IILY0IB173bqxKmOh6Nh/kQ4Trp5zKQt9cUWt4ySFui
         KVqHx/ZBiuQ+ngfqXwmZwMg+X/KWrbyzRA1iQya93B3LSVKniXTp5IGcDZhYdy+rKxUn
         qHIhxVfhCzzmwtUCRR0CNWdZqhNBL9Ra8dEVJ5C9fi2wkQgDi9Qx3jE8zdYX8wnpek0a
         9Fbo2dodO+EfnljNCYPuED4H5hlqlicxaXiadU47m9HqFvncnRUreRGwAW5HAJ5F4Fof
         GYRdB3764v1mdxIWR+0R40B3Nzs7VQvm9eK6zA2u8ylQAltGxuqEX4V081I0ZrW33MWX
         1xvw==
X-Forwarded-Encrypted: i=1; AJvYcCWX1QEb8KBQclr8XgzVONV4BGw6YNtHMwh1912x3kAkByhSQiJKPx44ebD2vi2/JF2dGN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAQ2re69/8ACY9V6fIeF0FD+l3/x5PhoVPJC03HeOasgJuQhmf
	HjeE+MsfA5zmlcVwunCuhDDN72vaBdb0Pp3udxhJGk4VA9a3F3uzyldJqgak8DqT/MauTZ87+va
	peTPa+fiGgTe/Q5mBHixA0bqfm6+P+H5tKoeYprxC905p0+UBrQ==
X-Received: by 2002:a05:6358:52ca:b0:1b5:a032:9994 with SMTP id e5c5f4694b2df-1b5ebe5b1b3mr113535555d.0.1724705038384;
        Mon, 26 Aug 2024 13:43:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkrFRhmUpfOOmJ2YwtqClR5K8A29/GQ8sXabHeZ52sv0b77XENUJCQ9LJLwxTjS7HZUYg0sQ==
X-Received: by 2002:a05:6358:52ca:b0:1b5:a032:9994 with SMTP id e5c5f4694b2df-1b5ebe5b1b3mr113532855d.0.1724705038035;
        Mon, 26 Aug 2024 13:43:58 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:43:57 -0700 (PDT)
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
Subject: [PATCH v2 01/19] mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
Date: Mon, 26 Aug 2024 16:43:35 -0400
Message-ID: <20240826204353.2228736-2-peterx@redhat.com>
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

This patch introduces the option to introduce special pte bit into
pmd/puds.  Archs can start to define pmd_special / pud_special when
supported by selecting the new option.  Per-arch support will be added
later.

Before that, create fallbacks for these helpers so that they are always
available.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h | 24 ++++++++++++++++++++++++
 mm/Kconfig         | 13 +++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b0ff06d18c71..d900f15b7650 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2643,6 +2643,30 @@ static inline pte_t pte_mkspecial(pte_t pte)
 }
 #endif
 
+#ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return false;
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pmd;
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
+
+#ifndef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return false;
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pud;
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
+
 #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline int pte_devmap(pte_t pte)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 8078a4b3c509..b23913d4e47e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -875,6 +875,19 @@ endif # TRANSPARENT_HUGEPAGE
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+# TODO: Allow to be enabled without THP
+config ARCH_SUPPORTS_HUGE_PFNMAP
+	def_bool n
+	depends on TRANSPARENT_HUGEPAGE
+
+config ARCH_SUPPORTS_PMD_PFNMAP
+	def_bool y
+	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE
+
+config ARCH_SUPPORTS_PUD_PFNMAP
+	def_bool y
+	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+
 #
 # UP and nommu archs use km based percpu allocator
 #
-- 
2.45.0


