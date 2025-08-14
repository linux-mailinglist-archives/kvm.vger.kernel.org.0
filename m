Return-Path: <kvm+bounces-54643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A87B25C2D
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50F525A64D2
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642722586CE;
	Thu, 14 Aug 2025 06:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="S8qNpEEk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85592257AFB
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154071; cv=none; b=a45mxrNWgousRobr0vELzKdsY1+awurieXVTHWAhBKxhD/McyrKexhwsWt7CU7roovXD5ZYzoUNof9qUXzCvaoE7JbtHGuimZjEAjUDhVjyfqVhdGn8e6xk9kzB+URVAzoDIOAcgnpGe3lPonAwIGon33utdfcb7ZTv3n0t9TOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154071; c=relaxed/simple;
	bh=7YG8l/oHGNJ9ZssK49/8Ebm/WdYEF4hWkC0NGsYca5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofDYLfcMRAcMEsOdEn/iZa0WHjgUIe/om/v+8shwr6xcMA/b2V6GuyD3TvrsAcXrSmQod8YRO6I7LNBEqeX5mCiDPb1tQoXZuB4cVWWwo6HGBVnY3StzG04s2zXU2vAsLo7Jw887PR2DRTpMkYG+TJfruQ0LQJtNNqHyxtbfapc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=S8qNpEEk; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24456f3f669so7001595ad.1
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154069; x=1755758869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jr5/c0ih2aPBl1Sup9MkhjI5We69n+SvmshTmYr92Lo=;
        b=S8qNpEEkWyyzOZgg+5B6BBOtVpYWzvtzX5v5jvWB7ZLYomYLdOpzBEO1eYeybzCySI
         H53a0oItAxNdrjCRm1jl1zV9kBb7sge7T730qLrVK3snVV0uhUDzft11my2pK1MrqZ++
         HL8rBjOIYvpjfnT1yRrbNVhicadg7tKXpNUY2F9ZoSKwB14u6RoeC63FHghbQuud1LLa
         lNllgimoaZPdTeVBDBESkx+hZ0hRvIjGfBYqyvFqXyyZDT18+ahm8W1T1Sel2eta1L+w
         +NIEpRl1oYbEL95Q/Pe1R+VdklvSSoMHNTxtNTkM0CyBuWJEIgBx3Sw2CW+T40oQGBJy
         hsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154069; x=1755758869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jr5/c0ih2aPBl1Sup9MkhjI5We69n+SvmshTmYr92Lo=;
        b=LnAiTso8BPKasAbgTa5u7MC8gqpnRU8n2s8hvcGeV/nR0pu2Vv6PmMqAv83VVXWKkj
         F7EwLFpS0t58eC91wZxBepN/gOQ6+Yjabi3l3IOFd/nx8x8qauLcCUx8KuH0+CQbCdjT
         r4xxOqvAFr0a22plvm6o08WtPV7xrsI3i/sHLFoCl5ugV4xXy0/QJhbWx8IObd1Ao+/z
         scGvNlC6IJdPjqScEku9M7hbrcNy242cSLPGyBk0FYPlPP2ceFDNgEvxLfL8wgllb3ci
         eFlZqvy0pFGl6ea+YjD8+/ZR3e9REndQaHnHQn/VMpa2ApCDHKRTrbtoN5zEbi3f+kJi
         AMwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4+EIlYP32NOmbJsnD8zMP2ta7nBR0Bj3oWHnOrX8EpcmHrfbRN9jBMwZ91kd7HMPWk4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZAAdy9plughGI5GgV532Vwvdl5BGQ+fxWVRt/aIzojayL32hu
	k35zvjA8fCKZe1e39fq34JwiUjzgsBWbdmMB+j9Ig+DkvbrCavZ/xr7h5v+e+7lSB/o=
X-Gm-Gg: ASbGnctkPrvz6BOyDXRr7iN4j3v9g0JbxXW1qowXAlKRm9r9xN0rfe3/t37xSndnwt2
	lvQVwnOqsnD2MYUkluT1mUyn+m5/tZqO/lIhY9/cxf0J2IGLYyeI96mw300q6J9WPB7mq3nAcG4
	D8ccysgJXJi1u8AmhSSkwQBBJmKfO0+ZwIZVgxCzWqJdd5lG8jFURxRhq1x/ChD0bnXJ4fvGPWh
	cIyi3BAeCjmKKj6Mvs5PssW2TVmDKNkGPpvffejvD6vkmouIT7TGJyLA3u95FxiHHOgzl5oT7D+
	R0cGIu+RIFm8MxLCjsns8o+jROybK4/h20yN1QdWhA6CbHLir5AmiJvZc+4gvdWr8gbxW8NGdnz
	kC+ZMbNhUgxhGj8QnNILrdauIBSOaakHs1pv0Kl2lL+xB1GRnrQ==
X-Google-Smtp-Source: AGHT+IFcMJ7Qsm2ilcv/Nmo7NkFkz9T5H1au+m2D6Cn5ycnQi6y/Vpy+QFsu7gjfy7KrvvvRuX3J0Q==
X-Received: by 2002:a17:902:cf11:b0:240:86fa:a058 with SMTP id d9443c01a7336-244594c7a56mr25154165ad.7.1755154068655;
        Wed, 13 Aug 2025 23:47:48 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:48 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Thu, 14 Aug 2025 14:47:10 +0800
Message-ID: <20250814064714.56485-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Let's add a simple helper for determining the number of contiguous pages
that represent contiguous PFNs.

In an ideal world, this helper would be simpler or not even required.
Unfortunately, on some configs we still have to maintain (SPARSEMEM
without VMEMMAP), the memmap is allocated per memory section, and we might
run into weird corner cases of false positives when blindly testing for
contiguous pages only.

One example of such false positives would be a memory section-sized hole
that does not have a memmap. The surrounding memory sections might get
"struct pages" that are contiguous, but the PFNs are actually not.

This helper will, for example, be useful for determining contiguous PFNs
in a GUP result, to batch further operations across returned "struct
page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
process.

Implementation based on Linus' suggestions to avoid new usage of
nth_page() where avoidable.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h        |  7 ++++++-
 include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..ead6724972cf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#endif
+#else /* !SECTION_IN_PAGE_FLAGS */
+static inline unsigned long page_to_section(const struct page *page)
+{
+	return 0;
+}
+#endif /* SECTION_IN_PAGE_FLAGS */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e..5ea23891fe4c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
 	return true;
 }
 
+/**
+ * num_pages_contiguous() - determine the number of contiguous pages
+ *			    that represent contiguous PFNs
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array, at least 1
+ *
+ * Determine the number of contiguous pages that represent contiguous PFNs
+ * in @pages, starting from the first page.
+ *
+ * In kernel configs where contiguous pages might not imply contiguous PFNs
+ * over memory section boundaries, this function will stop at the memory
+ * section boundary.
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = page_to_section(cur_page);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (page_to_section(cur_page) != section)
+			break;
+	}
+
+	return i;
+}
+
 #endif
-- 
2.20.1


