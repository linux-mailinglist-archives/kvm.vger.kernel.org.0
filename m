Return-Path: <kvm+bounces-28609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB47999A13F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 12:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 748E71F22CC8
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D2A21501D;
	Fri, 11 Oct 2024 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eg0IZHMX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17DB212D09
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728642311; cv=none; b=vE9wfr6t0CS1OrmDXtQP59cO/gzGtzUH/YIbkoCNJeKvkMcYW3bFN+qUz6USP5NihAaM3ggfUMttXkFCP3Ypk1TL5cnwMypeOrMAA2XO6gkKHzbkd5iY1YT88VB7APiFCgxr30vTcXPjw3HG3PU+KfO7ZrW/e/E5zTd0tZhF4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728642311; c=relaxed/simple;
	bh=1C83OOgMcgqb57Ddo8ncVhTx9jAr8iuBqE28xGsal7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0Ncq1WlqT+xHUIYg/L5DVpvvq1bc5T2evVMLtbJ+lW1uzkl9En1iO639oRfT9Xbn23o51vL8UjcvIDODwmGfAY6yfEBvMVDC7rprbst+YtpzTEgN/TUKTfAm9FxHFhYX0s6iAB1eY7fXmTZIOvyszJIh7ufte2lV8WMVt4pAZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eg0IZHMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728642308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UZ3IdlQSiC9SBRAFeIkUjQ3G20iTXPL8FgSwyp2DDL0=;
	b=Eg0IZHMXIT2pR11GyVUKzabwVHslxYHCT9x7YwXqKVku4WrzDVACHKWinBkKlyMrq66OJR
	h1TOgeQOWdsc0QLTUlc/VkJdn2SQCEOkHXI2TQsCeUscc/wzbhgZlU5KWsRmin1NqCunYu
	/Vu1hg5nRxeet4FwJob+8SSSQvZA3ts=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-AWsUiTUhPfSrctqTbSxh0w-1; Fri,
 11 Oct 2024 06:25:05 -0400
X-MC-Unique: AWsUiTUhPfSrctqTbSxh0w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D7D91955F3D;
	Fri, 11 Oct 2024 10:25:03 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.4])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E484D1956089;
	Fri, 11 Oct 2024 10:24:58 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Thomas Huth <thuth@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Leo Fu <bfu@redhat.com>
Subject: [PATCH v1 2/2] mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
Date: Fri, 11 Oct 2024 12:24:45 +0200
Message-ID: <20241011102445.934409-3-david@redhat.com>
In-Reply-To: <20241011102445.934409-1-david@redhat.com>
References: <20241011102445.934409-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

We (or rather, readahead logic :) ) might be allocating a THP in the
pagecache and then try mapping it into a process that explicitly disabled
THP: we might end up installing PMD mappings.

This is a problem for s390x KVM, which explicitly remaps all PMD-mapped
THPs to be PTE-mapped in s390_enable_sie()->thp_split_mm(), before
starting the VM.

For example, starting a VM backed on a file system with large folios
supported makes the VM crash when the VM tries accessing such a mapping
using KVM.

Is it also a problem when the HW disabled THP using
TRANSPARENT_HUGEPAGE_UNSUPPORTED? At least on x86 this would be the case
without X86_FEATURE_PSE.

In the future, we might be able to do better on s390x and only disallow
PMD mappings -- what s390x and likely TRANSPARENT_HUGEPAGE_UNSUPPORTED
really wants. For now, fix it by essentially performing the same check as
would be done in __thp_vma_allowable_orders() or in shmem code, where this
works as expected, and disallow PMD mappings, making us fallback to PTE
mappings.

Reported-by: Leo Fu <bfu@redhat.com>
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 2366578015ad..a2e501489517 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4925,6 +4925,15 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
+	/*
+	 * It is too late to allocate a small folio, we already have a large
+	 * folio in the pagecache: especially s390 KVM cannot tolerate any
+	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
+	 * PMD mappings if THPs are disabled.
+	 */
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+		return ret;
+
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-- 
2.46.1


