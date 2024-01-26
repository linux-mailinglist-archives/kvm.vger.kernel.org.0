Return-Path: <kvm+bounces-7135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F390D83D7BF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8A231F30F7D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3AB874E2D;
	Fri, 26 Jan 2024 09:41:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E626DD1C;
	Fri, 26 Jan 2024 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706262065; cv=none; b=c15fgPDMm45QZUDzzXQZy4zuxA9996z6I1ZeN/uqqxa+nq7giKOO0dsUp77MDd7mxCXHVgq366yCXoCW9xBsyBYV3J0AEnmglAPWF7bkgFBEr83yW1nKWy7XzR3ELmbW4bMmWbTYlOgD2SWR4m6b1z0uEgLASZ6T5pcteOPHk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706262065; c=relaxed/simple;
	bh=7/sPTPfkh5HHh0Y4qWFhRtQv2Pg/0WpZTZgfJ7Tl+dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF3gtyO3sLA/d8RwNgspE/AvYTtVrYjOnCQhlcXlca0bMEFJKyBx6ozHHFYq2NEd3HX8UpB+d6XeTVV9mgkcbO7eP7rvsYWfhBqrl2/S1JeZkAnMz/CLmveaFVXYt065d7TP5KW+vIbZ+foGnppSLU+5vaaANRmuscE7H1I7nRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: by air.basealt.ru (Postfix, from userid 490)
	id BE0392F2023C; Fri, 26 Jan 2024 09:40:53 +0000 (UTC)
X-Spam-Level: 
Received: from shell.ipa.basealt.ru (unknown [176.12.98.74])
	by air.basealt.ru (Postfix) with ESMTPSA id 0033E2F2024A;
	Fri, 26 Jan 2024 09:40:24 +0000 (UTC)
From: oficerovas@altlinux.org
To: oficerovas@altlinux.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kovalev@altlinux.org
Subject: [PATCH 1/2] mm: vmalloc: introduce array allocation functions
Date: Fri, 26 Jan 2024 12:40:22 +0300
Message-ID: <20240126094023.2677376-2-oficerovas@altlinux.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240126094023.2677376-1-oficerovas@altlinux.org>
References: <20240126094023.2677376-1-oficerovas@altlinux.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexander Ofitserov <oficerovas@altlinux.org>

From: Paolo Bonzini <pbonzini@redhat.com>

commit a8749a35c399 ("mm: vmalloc: introduce array allocation functions")

Linux has dozens of occurrences of vmalloc(array_size()) and
vzalloc(array_size()).  Allow to simplify the code by providing
vmalloc_array and vcalloc, as well as the underscored variants that let
the caller specify the GFP flags.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
---
 include/linux/vmalloc.h |  5 +++++
 mm/util.c               | 50 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 76dad53a410ac..0fd47f2f39eb0 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -112,6 +112,11 @@ extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
 
+extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags);
+extern void *vmalloc_array(size_t n, size_t size);
+extern void *__vcalloc(size_t n, size_t size, gfp_t flags);
+extern void *vcalloc(size_t n, size_t size);
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
diff --git a/mm/util.c b/mm/util.c
index 25bfda774f6fd..7fd3c2bb3e4f5 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -686,6 +686,56 @@ static inline void *__page_rmapping(struct page *page)
 	return (void *)mapping;
 }
 
+/**
+ * __vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return __vmalloc(bytes, flags);
+}
+EXPORT_SYMBOL(__vmalloc_array);
+
+/**
+ * vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vmalloc_array(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_array);
+
+/**
+ * __vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return __vmalloc_array(n, size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(__vcalloc);
+
+/**
+ * vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vcalloc(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vcalloc);
+
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 void *page_rmapping(struct page *page)
 {
-- 
2.42.1


