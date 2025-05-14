Return-Path: <kvm+bounces-46585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6D3AB79F7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A2494C7C0E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5152561A2;
	Wed, 14 May 2025 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCqPUwQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC3A25486E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266227; cv=none; b=MvxTnYnbyG3Fl1gafdo5rgaX8RSXuDME7PaVCOcE0Mm01bp36Lg3fvpf7eAd4j85gnDuwtMQlsxy0FeNIfg7e3k9azJjZK4yhPoOvfMssgdYnifhV6IEZokV899L/XeV3qWPxKOiw2oAbKK2ufC+g5FTXA+M1SOw/3N39eXyzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266227; c=relaxed/simple;
	bh=2eqGb+Z54Yf6chN7C9tBb9iG2LUsZRU/FE89bpzSmJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f2rc/sn3FRi283Kx+nnbhw8zWv9tJuekKhIAk6Zu65O00Un/nXAITiIHDYHM8Zb6PU8lW6TYTs5woi65QEm41gX5tTMKdC/q8AhM1IKla7l8yAOKAZbLdFQrJnWtiSu9k/CDpZjCy6itu86GqtxTYfVN1mo000QR1X/LI29B5/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KCqPUwQr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c371c34e7so404309a91.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266225; x=1747871025; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lZHhjGByLJzVXtoqJOTMMGXn3R5joV4I6usoUliN7uk=;
        b=KCqPUwQrMuJMRWe/XWofOa4NFCn1pDOzJceOwidle4kRJTiVj4wpJyhJ29zjPibFx3
         Ksx5Wb/bliHFYam/oFwy59qR5jxQEVUl7A8mDFLPYDlDGNqof1k1AqjeIUT0KcfdNgwn
         bGEfSgTtKJ0roXvwTt3qb7SgJzwTkxbFeebZLsIpr49NgAcM4H0trO5fhP+215l6OkJ1
         cCXcVxEJ6u198H47SB49B99EmrtOybBIH0NSt/TwKLTKZ5/zI4L6zLuJTduh4ReC3CPQ
         K0/ZCQRY54+EBF7jgCVGUj/rLzrlD7xh429379aIJP7kiNCVAho1RWTtz13DZ5qGjA30
         EyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266225; x=1747871025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZHhjGByLJzVXtoqJOTMMGXn3R5joV4I6usoUliN7uk=;
        b=rpqytyhNDQjWrI83G1Os10cHQZ3Xq9sUJNZe4FTMonqEZY0pAHqIerjXQ/kwWpixKa
         FvzjQLh0kcAqrWsvF3rMjbI69VWEoTkItnXbGh7+OvR9Cnw8LmbfZUOl1tMZeH6dqY1K
         QMoVWC6nFCp2EACzxwLeVkpLeJ/Hj8fEXw1wNcmgegDghj7OlsZ8tW9TUasCiy5zF4Aw
         mM5Lty9eYBDqnBQenVn6GgTV0xRPsUGzNRbjpc+kUXGiif9J99iiODfT+ja2GI/nL0Kh
         YykaudLX3dtinf2r5DtOQNOv66X2ZAmu7nmQRg+ewiN/GzLpwxXkZbzoghhjvdwgSzmt
         oP4g==
X-Gm-Message-State: AOJu0YxYP18E3hRyskcm5sWKX3g+Rb/x/HGsXC9DjAhXYe8Xxhlydv9w
	3HJuBzsSNNfrHRAZ5vQaOFg2tfWZ7BWkJIUKZBTfawJTd31ToEV1QEz10F0i6SnolOvvppc31dG
	MgnYHI7nqYVHfT1r/P1SapfZSdqtVJkY4c0A147j4DbTXzXX21uAjU5xRxp0rTI3oclr1AaMM6H
	qnG+i6l0dO0DYEQXjOF0JOVRE4pOhFe8PERzN0XFK8JWn7LwryfdX9WMA=
X-Google-Smtp-Source: AGHT+IEyquCcT5XxZ9BgIpP/32+sIegfX+nvFI1VSjxlaKftnmHI/Ogt7pc+GLW7KEnHncBj/7BeWAroc3//byxO4g==
X-Received: from pjq12.prod.google.com ([2002:a17:90b:560c:b0:2ff:5516:6add])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c51:b0:30c:5604:f654 with SMTP id 98e67ed59e1d1-30e515873cemr701793a91.9.1747266223852;
 Wed, 14 May 2025 16:43:43 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:09 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <cebe2aa139ba2cdeabcef69eca235cada32b4a70.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 30/51] mm: truncate: Expose truncate_inode_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

guest_memfd will be using truncate_inode_folio() to remove folios from
guest_memfd's filemap.

Change-Id: Iab72c6d4138cf19f6efeb38341eabe28ded42fd6
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mm.h    | 1 +
 mm/guestmem_hugetlb.c | 2 +-
 mm/internal.h         | 1 -
 mm/truncate.c         | 1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e4e73c231ced..74ca6b7d1d43 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2530,6 +2530,7 @@ extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
+int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 int generic_error_remove_folio(struct address_space *mapping,
 		struct folio *folio);
 
diff --git a/mm/guestmem_hugetlb.c b/mm/guestmem_hugetlb.c
index 5459ef7eb329..ec5a188ca2a7 100644
--- a/mm/guestmem_hugetlb.c
+++ b/mm/guestmem_hugetlb.c
@@ -4,12 +4,12 @@
  * as an allocator for guest_memfd.
  */
 
-#include <linux/mm_types.h>
 #include <linux/guestmem.h>
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
+#include <linux/mm_types.h>
 #include <linux/pagemap.h>
 
 #include <uapi/linux/guestmem.h>
diff --git a/mm/internal.h b/mm/internal.h
index 25a29872c634..a1694f030539 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -448,7 +448,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 void filemap_free_folio(struct address_space *mapping, struct folio *folio);
-int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
diff --git a/mm/truncate.c b/mm/truncate.c
index 057e4aa73aa9..4baab1e5d2cf 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -176,6 +176,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	filemap_remove_folio(folio);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(truncate_inode_folio);
 
 /*
  * Handle partial folios.  The folio may be entirely within the
-- 
2.49.0.1045.g170613ef41-goog


