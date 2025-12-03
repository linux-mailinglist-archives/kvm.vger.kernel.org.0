Return-Path: <kvm+bounces-65189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC4DC9DEEB
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 07:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 99349349A8C
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 06:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F44299920;
	Wed,  3 Dec 2025 06:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="PLn1CPE0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780528A1E6
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 06:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764743421; cv=none; b=HsM/qS5ALQLiGsMu48GVVrwiVT531cwiyHqGlh4uhYnxD1GTW1waCVoiVWuQhok8FlABtPEt4HsfKL9eZsHv4neItLep9CLtADqcv/2rpSpAzBQ3QKTaBANz3DRAtyzj7oTN1jW3FJr8hE4wvl3Fl8N8twHn23y/oghc9JtALE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764743421; c=relaxed/simple;
	bh=ZmaIspEXMwBdXfjv08IdBm71D9jsdKqj9x2IAnZtq5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KH1j5DVdlNfxjSVACO87jIVhrD3T2swnBma9zL0YPnEkyN5Fk9zRJzn746Ddvgk+NiaOYP5pkY14VchAzpQeq0QKzlgLhdQgNCg6g52gdb7ySLEHaS0d33yoWHmpcbn+05oPxBY8BQqZNuAtQm09WJFoLx2IRYO2d2QNEFqkL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=PLn1CPE0; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88057f5d041so56209796d6.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 22:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764743417; x=1765348217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zA8y4i15lHs4OWfRLesRXJafbhw/AjPpbVqRC57AGyo=;
        b=PLn1CPE0OMA3PHyUK7s2SYdE0/F5RFdl60goKsP45kCNruOUrrXToEAdVIxRXx3kAe
         eHLrrgVD5g9UuAl1JXKxmgNgMEkTH+7bocrg+RJrsYlEeEG1SuwWVfjt1C+bAdBUEnKv
         I1tPfrHwU0oq2Etbhwe2ZZj+VMKRasAzV8at95ekLHjssWymb4rP8ey2yyqYdw5jyJ1z
         ZL27w2P39MaDAfFsMswiw/p/msfDkYhVsmVuf+a4bnMm3hi8U0EGXOo7hCAG3d1chA5+
         Khx0GBZMmbe/iIGWbPCGNA1k23iYhmuyjAgO3vFZ1SoMTAKrSqOxxNHlV3ZP1SCBE7nL
         8DfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764743417; x=1765348217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA8y4i15lHs4OWfRLesRXJafbhw/AjPpbVqRC57AGyo=;
        b=ImSclFQjBDC0ZsuVmwmC5qeliJOgU4oPJsdG5OpVt9idm4diIy425QsOcnFu5FvsC3
         vzfuY6ZL37cBhnygUvSF7jEEW4UUJA84fE6u+jr14eXOHjkx+RH9aY5EBwAinNrwXZGG
         isyJrNmLCDygdBrg6NIawj8An+9M7PuWAaUVUIz8hbH6H2J1Lg06gYz46sTe+P8s/p4w
         5kt/HdK7NE0EDNQAudklL7rLz4vKJA13C/I854oi4cMbvWWfleggoOGNVU/vxw4SaFhb
         mUpP7w/U3ZS16ZBiid7AlYyBHlvZnma76dvENMOikLxaqkubAqkW0XtDErhK4ghVWSFx
         zpyg==
X-Forwarded-Encrypted: i=1; AJvYcCWnUiKCfVvezatmxgeCOLdUSPkVUeb9swPlkt6g17hsFZK/A89nMj4pCEEKMJ6JJtZ/pWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvRj+GsMT8oVfQAe9fDjVN+TCtz45QCLE8bv9O133WZXcGzn/P
	aHR7riD53W4egfcCEBGG1ijf6M91+aDRoQPg4E6tQkaS3jarWGsg513xJOpS93F/GN8=
X-Gm-Gg: ASbGncuLkPYsKrenAfE0obSXGohkxnrx6nTI8JlSofZCzaipOK/xUJtE7cMqOOQ7KkB
	L7MKx97t7LfTYYg1WzDzyKxc7ysqpYJfjCEJeYHUHdjGZobyRc8GWGUUvB9bEVLnNQ3Ij8f789Y
	wI2jAcp3WtoFW06tC20qPmxhr9aHB2rh6/WkVco1wUYnutvL2qP23ScSfahlD+yhd0YVQDPtImG
	mmKTn/BaxRu3zZSDW2C1vLiOZ8NDoL48UL/jnLm2bl3mMRhgfguIHgYTckmyhxPf2cOmhSicRCb
	Pi5TfqAxoMf0NbKtQvvXWHyY4KOe/RioIe2WmFVl/vexC0aiIWKrXvxDutV02TzHTLqt5hhW7xd
	jy8ik22viAI5BzgPXw/KUXLTrL/hqTqz/8jLUVs+MThZO73JdqG9VMkseIn9ulv5yLO20P6BUvH
	aNStoGyyau0T1E19GLIIOvcELoFWmX6EcpTpLZvqoiAgYrawgRlMTfavR9A+IL5DBF7Gzhz+k2Q
	hD+iVgGtyFIOw==
X-Google-Smtp-Source: AGHT+IF1GdXPSabAZHw0YMxptT9SRN1HvIpeNLe4gzMuYc6tHsW25MPHAsf8Dnnhll6yIyHsxXJH7w==
X-Received: by 2002:a05:6214:d0c:b0:880:5867:45b4 with SMTP id 6a1803df08f44-8881949a8b6mr16086076d6.13.1764743417043;
        Tue, 02 Dec 2025 22:30:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524e4b15sm119791806d6.15.2025.12.02.22.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 22:30:16 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v4] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Wed,  3 Dec 2025 01:30:04 -0500
Message-ID: <20251203063004.185182-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  This will cause otherwise-movable
2MB HugeTLB pages to be considered unmovable, and will make 1GB
hugepages more difficult to allocate on systems utilizing both.

Instead, if hugepage migration is enabled, consider regions with
hugepages smaller than the target contiguous allocation request
as valid targets for allocation.

isolate_migrate_pages_block() has similar logic, and the hugetlb code
does a migratable check in folio_isolate_hugetlb() during isolation.
So the code servicing the subsequent allocaiton and migration already
supports this exact use case (it's just unreachable).

To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
(Scale to your machine's memory capacity).

echo 24576 > .../hugepages-2048kB/nr_hugepages
echo 4 > .../hugepages-1048576kB/nr_hugepages

Prior to this patch, the 1GB page allocation can fail if no contiguous
1GB pages remain.  After this patch, the kernel will try to move 2MB
pages and successfully allocate the 1GB pages (assuming overall
sufficient memory is available).

folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
other users are debug or init-time allocations and largely unaffected.
- ppc/memtrace is a debugfs interface
- x86/tdx memory allocation occurs once on module-init
- kfence/core happens once on module (late) init
- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time

Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 95d8b812efd0..8ca3273f734a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7069,8 +7069,27 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		/*
+		 * Only consider ranges containing hugepages if those pages are
+		 * smaller than the requested contiguous region.  e.g.:
+		 *     Move 2MB pages to free up a 1GB range.
+		 *     Don't move 1GB pages to free up a 2MB range.
+		 *
+		 * This makes contiguous allocation more reliable if multiple
+		 * hugepage sizes are used without causing needless movement.
+		 */
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.52.0


