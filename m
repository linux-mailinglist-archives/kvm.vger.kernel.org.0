Return-Path: <kvm+bounces-56397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF06B3D73B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6E313B492E
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 03:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165162192F5;
	Mon,  1 Sep 2025 03:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="T2bNxZ23"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659601482F2
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 03:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756697143; cv=none; b=cG+bdUehfP4l2Sjo3PiDF51tBO9GM2rgW4zvHqyKXtZq2YYnDQTC0IeZmRf72QAmQX3AsVnEDi65xIhibqrr0sxaN8XErVW6iLqYKI1HUcjuyg0+IBm1BM57RSUH2sRxqzsvCcTl5035Ply5FsevvCI/LQG6Cz7B1aPLkH2oFNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756697143; c=relaxed/simple;
	bh=4LafQ9HfxIGEpssb2jrANmLl6TK/eI3b5iH1GI4ZXtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4z78c+v/++Hxp6dlvm0qUbllE17K4i+Z3Hc/pEaX8t2qRQOjxUak4NsM8tJpko2dTghmiPqw9OlLbphcX0N60iD1fkisS7uZiqMN+oaou6/gRJa+vI3bjY0tY7vtOhRkCRFDLTO4WRbL0fQmKppnZO1nG25dvg9Z+B0LbbZdGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=T2bNxZ23; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-248dc002bbaso31980415ad.1
        for <kvm@vger.kernel.org>; Sun, 31 Aug 2025 20:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756697141; x=1757301941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdbJEMSI35G/FS955a1XJ0xytM4aPwGPHfG0Feot3XM=;
        b=T2bNxZ23IZpz+NYWLyMeiBom+T99AnwQ4n7tTW1+q9ijIGbph0QrYm8y+rXPBAHEal
         Nm+Tb1uiFBCh01KjD5w80byj5+U8AP+D+sFToO1X5AIUsE544eHKa307gV5at4T2/AYs
         SmKB69C163MeJCwUk5ucZKWxwCScVawy4HG7pNhG2Do27l5+HjA73MnVSCxq0FP4WoFL
         WGWAXpOn9QakeB76iq0kXbzeboYs8ej8Xcoh0t/Z2gO19mbjKsxY+yXcGaD1aAUM328i
         8+CWM63DAZ8XB0Yg5dbCYdrsxlVKD2qaE3TTLYyvqqERzGu1rBfaQjw/kqTGw05DJetO
         nmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756697141; x=1757301941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdbJEMSI35G/FS955a1XJ0xytM4aPwGPHfG0Feot3XM=;
        b=U5Pw0ayIY2xmJb72s+0Jj51HXKLtDzsxIrenaV7Z+HU3mAFxXN9/v5XWp1Ln7f6II/
         6tKH+ePYSOmAHPsPBzjyQioX6oVuppCSyEB2rV4MA28nCbYgcBhOBoWAtvGsCiigHYwS
         +jTYdEHWoz08Kb7zgc2+FuBVCmgZACQME6QvA8cxUUpRYgcQ1sCPbM4WKYTCq3WIdBap
         1Y+1+6uzNOG+vMt7hTimXPoM+c6R3TXfZJ+OjQ7i8OeLbZpH596bLMHXZVuf2WgWhkNo
         V5Hj5YCen/YUsK0Ruu6mRas+PohVsxgH0kKWaJeBv+cpvsuY+xLQ0lTZqoSDXZPzUg0m
         qvVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+FHVUKDe+pQeHP1mxRmWjdO/8dllr2qmidRs0KoYkkvgI0J+R0PUoCeEooVoRqjZ/LdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YySZ6V7AzuHPMlvRMKmz3ELhja3ss9PwOCeUNRtA17T9A1J2hrV
	CtjmXfsbKmt9XZf0sqZcPD6Ixq7/uz6dJac/kepf5cs+xADGVkmOgIwO6GZwolQ+1LA=
X-Gm-Gg: ASbGncuDhtovwnra8K//J08BUsJQLDpaTz2g1lWQSd0RPkL9gjXgsvQR0f/qbJbRa1L
	8iF5o4K8eIOCG3n+GkUCOMOIjl3YiQFuH3zaAJhKa2nvozol8y+Wh2rOXhlp5WK3R+e85iaS18o
	LM3HA59fUtg+q+fzTdbukM/MH8XLIJJghkovTC1NP69KnEZ/sATPdaudnlmXDEzFEZ9grWqvSTJ
	1TRiZOxINqHLbCxVTw6zQvFVnEalYgnJ7Mv72I1H2oCEJHjAJzTCbwWgzaagXQ9IBRng/f+v/XK
	Tcw1YVh09jBc1Kt+6/p88uI5R89uUsJEdh4J+zaRP0nMDbKRquA5/xA20/XX7PGXCCNphWLq+F6
	sph9c6M/hD29pk7bZyQyETkrbEZxidTJvDhwbCwntB8UEZiEKsBevAzg=
X-Google-Smtp-Source: AGHT+IGBhrAz87yzolI5FAkwrsomrC2UXs7e16pnJjcARJWPI5VwmAVxP6v/krxP2r2wuBusOxthhA==
X-Received: by 2002:a17:903:32c3:b0:249:c76:76db with SMTP id d9443c01a7336-24944a64ae0mr87780325ad.21.1756697140498;
        Sun, 31 Aug 2025 20:25:40 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903702729sm89862055ad.25.2025.08.31.20.25.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 31 Aug 2025 20:25:40 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org,
	willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Mon,  1 Sep 2025 11:25:32 +0800
Message-ID: <20250901032532.67154-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250827121055.548e1584.alex.williamson@redhat.com>
References: <20250827121055.548e1584.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:

> On Thu, 14 Aug 2025 14:47:10 +0800
> lizhe.67@bytedance.com wrote:
> 
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > Let's add a simple helper for determining the number of contiguous pages
> > that represent contiguous PFNs.
> > 
> > In an ideal world, this helper would be simpler or not even required.
> > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > without VMEMMAP), the memmap is allocated per memory section, and we might
> > run into weird corner cases of false positives when blindly testing for
> > contiguous pages only.
> > 
> > One example of such false positives would be a memory section-sized hole
> > that does not have a memmap. The surrounding memory sections might get
> > "struct pages" that are contiguous, but the PFNs are actually not.
> > 
> > This helper will, for example, be useful for determining contiguous PFNs
> > in a GUP result, to batch further operations across returned "struct
> > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > process.
> > 
> > Implementation based on Linus' suggestions to avoid new usage of
> > nth_page() where avoidable.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >  include/linux/mm.h        |  7 ++++++-
> >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> 
> Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> changes page_to_section() to memdesc_section() which takes a new
> memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> mm has many subtleties.
> 
> Ideally we could also avoid merge-time fixups for linux-next and
> mainline.

Thank you for your reminder.

In my view, if Willy's series is integrated, this patch will need to
be revised as follows. Please correct me if I'm wrong.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ab4d979f4eec..bad0373099ad 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#endif
+#else /* !SECTION_IN_PAGE_FLAGS */
+static inline unsigned long memdesc_section(memdesc_flags_t mdf)
+{
+	return 0;
+}
+#endif /* SECTION_IN_PAGE_FLAGS */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..bb23496d465b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
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
+ * In some kernel configs contiguous PFNs will not have contiguous struct
+ * pages. In these configurations num_pages_contiguous() will return a num
+ * smaller than ideal number. The caller should continue to check for pfn
+ * contiguity after each call to num_pages_contiguous().
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = memdesc_section(cur_page->flags);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (memdesc_section(cur_page->flags) != section)
+			break;
+	}
+
+	return i;
+}
+
 #endif
---

Thanks,
Zhe

