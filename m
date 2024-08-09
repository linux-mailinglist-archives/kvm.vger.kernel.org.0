Return-Path: <kvm+bounces-23716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8B194D442
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE19D1F22A8B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D240A19B3D7;
	Fri,  9 Aug 2024 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aG5sFqPh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9294719AD71
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219778; cv=none; b=s4CjLoIIBXWWOqWX5Kg/8d9jxQjIC0SgN44t/Izg23fkIyDkrvbzLtzZpjOSA/ipM6NQxU31pfKTeW437MnMCq2OzArcX7utjJz6ICDeUhMBRaHhfWKI9rCiA9gQStmqi7ff5nG3JnonOv/yiV8rhLZnwOcvxdLdBx2MpZ/vUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219778; c=relaxed/simple;
	bh=HoGYsL9LSVsYg/VMQEnaKHTD8IFeuEK3k/nOrqKlNJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIodtesacBibJgXHef8LPYkBIKymBG+UkITQXIiFzKs0wd5pRvyVGJXxYb/NzvbP5md0G+3r0GfgfRowSqMTiJ6WZKR9LBbLmEp/mC0nhMbVw9ebF56zbaVwNuh59GATpquKAMAG7Tm1wh1bKyOXitShXGHWi4UX7Ml6CFjOP68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aG5sFqPh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nP4ocM4VA1bHw0KaG7AmUa9593dVgU8QzxEKB9c5vMc=;
	b=aG5sFqPh9l8eF/bWDsFjKfp5b+EfhPGstMj5jJ1J9DP/at5l6YFnTAzK/fYzRkgGbTtL3u
	OrIN47hQJAIkjR+xypvZJdZU5uKIALROc2eITmZNTPY5UWxtI9kHlR2EDyYmHSNrRBrezQ
	BU/akbUa3rWuqtGfCImRdnxm97pfNCU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-DCRf7DI4PXuZ9-cIrvCOiQ-1; Fri, 09 Aug 2024 12:09:34 -0400
X-MC-Unique: DCRf7DI4PXuZ9-cIrvCOiQ-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-44fee12c33bso1777521cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219774; x=1723824574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nP4ocM4VA1bHw0KaG7AmUa9593dVgU8QzxEKB9c5vMc=;
        b=mMGoqNRBS6fkNgzjzu2o/pVTINKey8h9wz53owVEgMHh5y97/97lr9ax+qdL2II4+Q
         3ONTKcrYXoB1zaVwfmKMdBI8a0ZJAP7j7mnSM9YDkQwnDd8U5/enoN4Usp4J3wgi6VVM
         C6ONHteyiDR07kuiWk5cVWzYz9XCUjKOCUSNRQwDefjnjIsQeIaAo+p/sf81qMBgqWMf
         LvdEtn1xIrWjcLZelMNdTLBlMsGZMA4WA8VL+ezFz+4eBBam3mp1HeXNdTPcMeO7wBlL
         r18tO0Md5qx5ujS5ZAKZ1IbRorcckf7cP3aNOQOG+mmz5hT996SWGFdP7VJtgjFrtebM
         m2Rg==
X-Forwarded-Encrypted: i=1; AJvYcCU+Zujrq7aV3IZwjnIcdFOeuSTweXIEDAr8afef0TWA+D/uqeWAT2oYIhfd9YpTNz0uZVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtiHn+jIdS6dJUYBsKrjOsdPHjNc9820xeUDiBPaHy66a6xYzY
	miLISfta1ZAFfLtsIvqt4K8vFl3VI1mMx3uUcwZZvVw28/YJz1Gkd9OiO55oHl1hK38FyWWskdq
	9ypfuMyO7tii+u+XlBm8OSz8GfZgflPNIvVN3k7QS7oT2MyJhiQ==
X-Received: by 2002:a05:622a:386:b0:450:21b2:22e5 with SMTP id d75a77b69052e-453125745b1mr14927911cf.4.1723219774010;
        Fri, 09 Aug 2024 09:09:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLMln6bbvPWjvF9TKd48hi2B1jMtNjQrsP4cRdycFMZCE1oQ0WYqhx5h2X//7ZLsXT7ckFXA==
X-Received: by 2002:a05:622a:386:b0:450:21b2:22e5 with SMTP id d75a77b69052e-453125745b1mr14924951cf.4.1723219768577;
        Fri, 09 Aug 2024 09:09:28 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:27 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 06/19] mm/pagewalk: Check pfnmap early for folio_walk_start()
Date: Fri,  9 Aug 2024 12:08:56 -0400
Message-ID: <20240809160909.1023470-7-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pfnmaps can always be identified with special bits in the ptes/pmds/puds.
However that's unnecessary if the vma is stable, and when it's mapped under
VM_PFNMAP | VM_IO.

Instead of adding similar checks in all the levels for huge pfnmaps, let
folio_walk_start() fail even earlier for these mappings.  It's also
something gup-slow already does, so make them match.

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/pagewalk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index cd79fb3b89e5..fd3965efe773 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -727,6 +727,11 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	p4d_t *p4dp;
 
 	mmap_assert_locked(vma->vm_mm);
+
+	/* It has no folio backing the mappings at all.. */
+	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		return NULL;
+
 	vma_pgtable_walk_begin(vma);
 
 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
-- 
2.45.0


