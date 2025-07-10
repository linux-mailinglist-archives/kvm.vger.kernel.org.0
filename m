Return-Path: <kvm+bounces-52021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC8BAFFCD7
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D10E58572D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4605D28F94A;
	Thu, 10 Jul 2025 08:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="C1gasASQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB0728EA4B
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137653; cv=none; b=PMcmXSiOZnYca/2k3+Om+L1O6aZ1/WmE2uXkt4zbDYYc0zzshH7cRvdTerOdFXMzbmUVF0+XgefdEOOzdYsG0rPBAwL1zVXuIDfYISNpFx8bcsQ4eNm3qHBcux4AH4q/Y7I1p61g1zhNGMvgAXb1SCohnk8OD13nCA8sKPDociE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137653; c=relaxed/simple;
	bh=0PVCuB/OvGXxkc33B1dLuwyIQOpnfJD+l7vZ5f9Ss+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu+Pvx5bR9z0w+cCHaaQ5da94IgchDdd5+mZ9dSUZRm5leAp4mySBoN29p0/MDTnuTnmi2IFxoPbTu80ixrW34zy52/FYzuHOz8RqOBTvJF2Tq8NkWctZvKbOaEvvzZ+rmkF8XqhJecreZi9H8rnf2x2kF9Hc4surwEH35ClgX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=C1gasASQ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2352400344aso7037235ad.2
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 01:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752137651; x=1752742451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUKujTie/xgtNbVO7AZBjb1RhL5nzywDx5C8kGbmtCs=;
        b=C1gasASQIwtHVg5001ryHxZtam1La1Qi0Fwv2hJ8ahZdrQT7JeoOs9M499n4+dFHZa
         Tchs5oEjcMmas9dXo+CLs5LK2Gh0rOoatm81SvZDcFlXAKPOeMK8Ro24iAGlxsrH2WiI
         1LzaelgY2zkQrKgTCpXzb14L66RlArspoOGa15ZHXs25mRmNM8SbO09fP9Y7HAmNoLAT
         6RD3qxNwXEsj1Cr27fIgXzE8++Aijj0WDz64Au3UOU79a4PxImMK8NI4+S4f+FXIgnE8
         9AEBpV23CwsyKz46cIZnDWS3YcTN+0FdQH6BVEN0GQR3dvvbdpSL0O+Ys/6PsgpyS1Zn
         E27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752137651; x=1752742451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUKujTie/xgtNbVO7AZBjb1RhL5nzywDx5C8kGbmtCs=;
        b=H0OAIvKCypeGp8/sWonIKulQ3lxOmL1GYetAexoptyUfKwHU+XnOv9MGVuJKKEjk8q
         VFvPrToMHCzWXhk3MYRkMyfa3TLqgFIgkWDN1zRFT0hH9P2chw9anX8NPGhM5NuWMYCx
         wovHLsarNxK3Rb9lIIPg0KoFu9puwMjJ/nDqjhQKlcfM650x3EzdyS4T5dpgeMgK5KyS
         C9iWZrwSmi6JfDVpF5IpJBAaLjN2vXA460mJrjm7umeQt5BzGTQ2a7lw7z9/HQvBXxep
         YJIdjTzNEb2Pby4po4LLF/NoIQldKXCsUsxTSkq/i78hNXdQjxkWGgV4dQRKrahd40jf
         x1aA==
X-Gm-Message-State: AOJu0Yywi21wk83+FfKcVU1i8C86EylvzVRf/PWDYn3ypU/UE1EkAbDU
	AYAY49r6Jzvy1E1nq3V7+p4gEdUerl/CpEYYi7AOd83dYiGy2x67um2NTY6zFgx9aSM=
X-Gm-Gg: ASbGncuYRUUmQ5Dtqb94JAo9u6dZFwLwu0IyO9op4bqSdjNJEx7aCUBbYR9D6/b0FtC
	NsobavrDCrmqQZoXzbfd3uj5led+w0PUdtgZXPUKdbS1Tsm0azLcmhdqw3aY4BPQX46Rfu69wKw
	WeBaz4yub20aJdBblI4Qc95N5lkuqtWe/vvKcuyrF2A5UJTnHfgp/qKvDeEzmX2iHVPUqlZSAxC
	1HKKlyJMwMj7A4J/PmyEGTYWsXPkwaIh7r0pZFHJHmAKu9P/M2FnAP6oDrA+RmQ2jop+gt6kkfS
	A9iSQMrEyzIH9TrIaE7p0rgiEOJJLPnqJBFAgex0FS7CRSCpAOZ+3fbSF15lNVeZZVU4Vn0GWK0
	JxXNrCzKP0MgA5w==
X-Google-Smtp-Source: AGHT+IFBl6XWSS3SCRPprWFOA1sj7pbVIrvseX/rWxTSbGo3aaOmi/r+s3MsC/OYlpN25M32JL4H2g==
X-Received: by 2002:a17:90b:57e5:b0:311:b3e7:fb3c with SMTP id 98e67ed59e1d1-31c2fe0ee60mr9144636a91.31.1752137650816;
        Thu, 10 Jul 2025 01:54:10 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3e975d41sm1650228a91.13.2025.07.10.01.54.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Jul 2025 01:54:10 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v4 1/5] mm: introduce num_pages_contiguous()
Date: Thu, 10 Jul 2025 16:53:51 +0800
Message-ID: <20250710085355.54208-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250710085355.54208-1-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Function num_pages_contiguous() determine the number of contiguous
pages starting from the first page in the given array of page pointers.
VFIO will utilize this interface to accelerate the VFIO DMA map process.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0ef2ba0c667a..fae82df6d7d7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1761,6 +1761,29 @@ static inline unsigned long page_to_section(const struct page *page)
 }
 #endif
 
+/*
+ * num_pages_contiguous() - determine the number of contiguous pages
+ * starting from the first page.
+ *
+ * Pages are contiguous if they represent contiguous PFNs. Depending on
+ * the memory model, this can mean that the addresses of the "struct page"s
+ * are not contiguous.
+ *
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array
+ */
+static inline unsigned long num_pages_contiguous(struct page **pages,
+						 size_t nr_pages)
+{
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++)
+		if (pages[i] != nth_page(pages[0], i))
+			break;
+
+	return i;
+}
+
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
  * @folio: The folio.
-- 
2.20.1


