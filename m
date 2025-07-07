Return-Path: <kvm+bounces-51653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8ADAFAC1D
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D23E3A448E
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D0027F007;
	Mon,  7 Jul 2025 06:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QeN9lzcF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E02627F9
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 06:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871014; cv=none; b=N5xEhJRjihLlCrwTokqb1aKQXBurm/qKpeKzGXb4UpTpSsAkcMRLRjuRyrJOk8VgRl23tytHuC05jiABoT0pvIi7t5tZVNVCE6R6bPXRtvmanzbDo6lY0+e1DGBPb+9vtkASIoDCgUxvVswD7UQIWxmlmW1UnTI5obdHmrbO+eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871014; c=relaxed/simple;
	bh=yySkyAzKw9ZyNy7KrfMmwyacolQBHXtTfXNgEj0CYxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCqqliHTw2Z+Tp+nCLyeeetLODx3xF5nfwI3Qqx+Dc/hp/v9Y2Um6+nPntEvGmsOsPZTHvTYblc9biZ3UO2t4z9VTUpseDD59jYF4ENV2Oyn/zIUBPNuXbGTwgpP84rcqeJBvpjnY05noPb8P7l/msRW1x7e+mAUX0jP6oUg21E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QeN9lzcF; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2350fc2591dso24562115ad.1
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 23:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751871011; x=1752475811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e83zaooyctJVGMAyfqno/5MLE5GO1gHM6Xp57jXORKE=;
        b=QeN9lzcFeolJxlBX+zujzzwobxK2Gg6SiwflUy05DPo4ug3gvEMhonmN5vdSkicxeR
         pHEMI6SwATKY9gYMbgZgiXstVFINEMrB24meOeTUtl6P4RHKC8hLf9bVMOrmu5Gsyn7b
         j1K3z+yxVMsGNtDL8aRntfd6d8qM6NMFRgJ48U1uioPY4XFVlKYYbTLpETQaCA7SAeDU
         tw6KtNxVhHVzp8nIgUCLbDYHsDPpuDW7Qvk+rSvnHtnTO7Jtix5qcWcC8ikzAsA6E91D
         wJez2vn7Ise6yJlGUmbNuja6Kodpmd83lT+X2Akw4YGa0VWqdEDTYI8KL4J5DY8x60IQ
         b7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751871011; x=1752475811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e83zaooyctJVGMAyfqno/5MLE5GO1gHM6Xp57jXORKE=;
        b=qmQBWQ0MAy4+PppgqLRP9//3TrSan2D4Q5rwfw5cr4AKdiVscDwyd9LK6b+wPcznjq
         vmG/3PpJI0cdsq140nyPGOpvspqdIHI6rmM5pLtZLDGxi6+LpW58BoCdvWDJ3KFLRI4f
         rufAsA7rx6EV3Fb58N9oLd8vgalw2ddRSpYmyXa38h6X7eQqeptDa4Sct0VsIcI8N9Jz
         UjQ2wI0TpDofyxE44HBDYm8k5Z/Cs+33YHcrfxpg1SXVrZM5CV/jOvWcZSzLWyMWHHDQ
         t8uODRbv8ySNDlT+8UaqXdrMds8t3IT8a8zfLxsXsPXE957Xa3+4m445CGGZGx5FYR7e
         KbDg==
X-Gm-Message-State: AOJu0Yyns5GghUDkNjOz/9prR2joCz1Unq06tFwkE7JuoICASRDi8Fud
	oESb7Z2RdbLjwmww2zxOViCV1vTN13+02o76KLN2rzcRrh03/hKJQrRkosTzCx8fbac=
X-Gm-Gg: ASbGnctP8v3m6kzwjxDSMpGJG7aLsbrlJlMlTACqMzIuvWd6QBkK8e+nyqJWsCoj8/i
	ka+UEEwzcuvVgJEfyGUT+9i7bPDNWYwYMwR2SBdxKkwZGZxCsVwDv6T5D8RRE33Mje72ThvCciX
	CPAITimVjxRXQZmEVlx21BtF8/Fx1YSCMladlMdsg3w6psM1PDQKKKiuBDD4Er/WHyin8cOQnes
	DUZFTXZ+y7L/3l32ZxY7QQBkfI6vbpiwgusqpRdw8Yvgu3puXfou2wKWgDrd9RvA1vo8nKvUiGM
	mcWyfmSzQvWSdARn85X6Kfix7ja9zgeF2XHuszL6Y0bCXnW0KREc2Ez+y6OVwkn4TDftO92MCTQ
	+0QXi1kQDEPGO
X-Google-Smtp-Source: AGHT+IHZIatv+CFtPNahfbucN1jWL70KTS2wbiORevgf6e2vHgPOO4LbLUKtKdQFdYuPICyB+irnmw==
X-Received: by 2002:a17:903:1ce:b0:237:e753:1808 with SMTP id d9443c01a7336-23c84b9a123mr186936395ad.20.1751871011205;
        Sun, 06 Jul 2025 23:50:11 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a1aasm77377635ad.15.2025.07.06.23.50.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Jul 2025 23:50:10 -0700 (PDT)
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
Subject: [PATCH v3 1/5] mm: introduce num_pages_contiguous()
Date: Mon,  7 Jul 2025 14:49:46 +0800
Message-ID: <20250707064950.72048-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250707064950.72048-1-lizhe.67@bytedance.com>
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
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


