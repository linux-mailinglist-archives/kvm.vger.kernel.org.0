Return-Path: <kvm+bounces-25085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B138595FACD
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666B41F221CF
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329B119D8A4;
	Mon, 26 Aug 2024 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRhodrri"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD4219AD7E
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705051; cv=none; b=H0Ey26y//mOI+up/9/eJPfPArxmQBaOR849qQRpwKDxusXHfPW9GfbVR7ANW/it407b6rY5lsO+nyxFv4z12rTbcV9TniDCI6RoH7QmO/cceqQuUCizhEYHWpJnpuzlEW7TzQpWf6RIWodI0hflMQ6FC9Vg1curR2F+y2hqbOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705051; c=relaxed/simple;
	bh=B4CjEPEBNhW/7ay+iPhYCq//7mfGSaIpgiOs2kdAYJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H71KcEso55ilbzznE3kSKc7wI92YoBoA6jbhirUbuI1vSS+IOxQ2k8izrlB0IuCGXwC0WCdzsxQkOcWYyfo0pUMG5v9RLgs4t7qnwaH1rFj6gWuvcQO9Q4C9LhqhNpfaV9AhX6rW4x8CtjP7x0JlqBCjF8bLQLpwg3Z59/QHZCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRhodrri; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFHgAMnpeJHqDMa0ADr1pyvSduy44GuxF04BOe5aqcw=;
	b=PRhodrriEksh5vkQhp6TNKCFjCEmQviivZkIYfyfSdsu3iLOiFE3rLCiat840hn8AsUYtI
	mrAahOnD5KnoS7Cv2yguSMHLF3+tnjOkxihh2ch9kSDjoi8Z6kckxVcLmrDBJ98/B+UpiI
	ryPMwZscBjKd09hfP+G0iK90KMPIiwo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-WwII-ndHOpCLLgneJNl2JA-1; Mon, 26 Aug 2024 16:44:07 -0400
X-MC-Unique: WwII-ndHOpCLLgneJNl2JA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a1de8a2adbso643965085a.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705047; x=1725309847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFHgAMnpeJHqDMa0ADr1pyvSduy44GuxF04BOe5aqcw=;
        b=PrgL+ZFpeWG0wqoAfesuI5qV5Hjs4moM87X8B6umKErJXAxswBaDKEi3weVDCdj4TF
         MliencXTVkW1bJn6a3lPwWdrkOy3QFeDH96VhG37IgXK2yWricCrzRyF38r7X/xHpH4Q
         ivg6sTReY6UlulYrY5hsXud87+w0EHQowQDs127QDljPgW2zYgFtj8miA9pihzwEseKQ
         5oxZWYbuFRVyn08H04FTKVR7ZE3PGpE7R6V9Q3Hbyva09JctgMw7rTOY+1qK03u0RzEt
         IhtzIGT7sOL7l2Vp6eYbU8K5fMG9+U9A1xbTlCS99W9upHQuY0YddxuhXEyL2sfbKqm4
         a9JA==
X-Forwarded-Encrypted: i=1; AJvYcCXseu7q2rckjU+LUzy+llv3PPpysXh+YEckhLDMG1koqjQbHvqOLZo9DMoEe+uTITOCt9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YybjM3AXWBnzhBfdvoQU1exwkmv9b41Xgx9bIvJ6v1UbKlaUhhJ
	K0H0ki+Yu7xP3hCW+KhxRGh4SJcx4XqdUnRlKZgOSR+2ghsTU4KW3YPTT+urgXYc82I9qsoA0Ur
	OYnZ7CPYlgvKcTyHELMyqt5VZjl7wyDXi2hRkgxUi8zHvF8eQhg==
X-Received: by 2002:a05:620a:2a14:b0:7a2:ccd:9672 with SMTP id af79cd13be357-7a7e4e6144fmr67568685a.67.1724705046879;
        Mon, 26 Aug 2024 13:44:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG++rZwRsHPi3LEX2hBpbUb+Bhnwx97nv6F7Fy5QJm5RgQYxXJ7nF8aD8ykhSm+rXvWrvbUzQ==
X-Received: by 2002:a05:620a:2a14:b0:7a2:ccd:9672 with SMTP id af79cd13be357-7a7e4e6144fmr67565885a.67.1724705046455;
        Mon, 26 Aug 2024 13:44:06 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:05 -0700 (PDT)
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
Subject: [PATCH v2 05/19] mm/gup: Detect huge pfnmap entries in gup-fast
Date: Mon, 26 Aug 2024 16:43:39 -0400
Message-ID: <20240826204353.2228736-6-peterx@redhat.com>
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

Since gup-fast doesn't have the vma reference, teach it to detect such huge
pfnmaps by checking the special bit for pmd/pud too, just like ptes.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/gup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index d19884e097fd..a49f67a512ee 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3038,6 +3038,9 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pmd_special(orig))
+		return 0;
+
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
@@ -3082,6 +3085,9 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pud_special(orig))
+		return 0;
+
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-- 
2.45.0


