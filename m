Return-Path: <kvm+bounces-45273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 500FDAA7C49
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 00:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D5E71C0218E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 22:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AE421B182;
	Fri,  2 May 2025 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3hoan33"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D2920766E
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 22:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746225658; cv=none; b=c52aIuNd+39hbtu62s4hmdtTeAYWZILDITZBBIEZWk5qpgJD1zzi7/tWLD45zLn6pHWHMX2MTLSxjxXzZjCHR8RJAefic5biQC+ON2StnDVndfbDjoMebgOVfFgo7HwJWCV6mYXNACAjeX7kv390HnA4cCvdzpSILrNPrySA7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746225658; c=relaxed/simple;
	bh=zlnZNHvDSKtj61yBY6pXk50K8Zec3Hak0oiG+jfquAg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yx+DBGW7oBMQUKiGE+dMKueKgFi1HyRKFCA7aGtkwfESd3jC8CwptsEsp5K2PwPGN1Xdf4mhYXkwF6trLGubc5csLc1JX2GN61SSRV5H6AbeimREaJTESMrmaPMuSLSV4iwu6x/fLRMKW2gPquBVO5IsOUlGLR9r2Ekd7wSY64c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3hoan33; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746225655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AfTpVow31STgGjbJWRiqCTj7zeM2wTu0PCwlKxMuS7o=;
	b=D3hoan33bqW/FqnxZ6xrNhPT4GIN6dcqqTyYm8dANP8tqnYe7E5xTbGfAPF6TEYkqa+qtP
	8o/WqTFljgaTAOQKlzxrbtVRwusow6rjea3uRXMzA4Jeozo5uxkXXMFD0XcOA/Zfi11pJR
	paXU3sdxovoBJOkB0DL39eACQHaPMVA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-Fbrm0R5iMFedRAm1qMh1tg-1; Fri,
 02 May 2025 18:40:53 -0400
X-MC-Unique: Fbrm0R5iMFedRAm1qMh1tg-1
X-Mimecast-MFC-AGG-ID: Fbrm0R5iMFedRAm1qMh1tg_1746225653
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6C09180034A;
	Fri,  2 May 2025 22:40:52 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.80.42])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E10130001A2;
	Fri,  2 May 2025 22:40:50 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	peterx@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adolfo <adolfotregosa@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] vfio/pci: Align huge faults to order
Date: Fri,  2 May 2025 16:40:31 -0600
Message-ID: <20250502224035.3183451-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The vfio-pci huge_fault handler doesn't make any attempt to insert a
mapping containing the faulting address, it only inserts mappings if the
faulting address and resulting pfn are aligned.  This works in a lot of
cases, particularly in conjunction with QEMU where DMA mappings linearly
fault the mmap.  However, there are configurations where we don't get
that linear faulting and pages are faulted on-demand.

The scenario reported in the bug below is such a case, where the physical
address width of the CPU is greater than that of the IOMMU, resulting in a
VM where guest firmware has mapped device MMIO beyond the address width of
the IOMMU.  In this configuration, the MMIO is faulted on demand and
tracing indicates that occasionally the faults generate a VM_FAULT_OOM.
Given the use case, this results in a "error: kvm run failed Bad address",
killing the VM.

The host is not under memory pressure in this test, therefore it's
suspected that VM_FAULT_OOM is actually the result of a NULL return from
__pte_offset_map_lock() in the get_locked_pte() path from insert_pfn().
This suggests a potential race inserting a pte concurrent to a pmd, and
maybe indicates some deficiency in the mm layer properly handling such a
case.

Nevertheless, Peter noted the inconsistency of vfio-pci's huge_fault
handler where our mapping granularity depends on the alignment of the
faulting address relative to the order rather than aligning the faulting
address to the order to more consistently insert huge mappings.  This
change not only uses the page tables more consistently and efficiently, but
as any fault to an aligned page results in the same mapping, the race
condition suspected in the VM_FAULT_OOM is avoided.

Reported-by: Adolfo <adolfotregosa@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220057
Fixes: 09dfc8a5f2ce ("vfio/pci: Fallback huge faults for unaligned pfn")
Cc: stable@vger.kernel.org
Tested-by: Adolfo <adolfotregosa@gmail.com>
Co-developed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 35f9046af315..6328c3a05bcd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1646,14 +1646,14 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
-	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long pfn = vma_to_pfn(vma) + pgoff;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
-	pfn = vma_to_pfn(vma) + pgoff;
-
-	if (order && (pfn & ((1 << order) - 1) ||
-		      vmf->address & ((PAGE_SIZE << order) - 1) ||
-		      vmf->address + (PAGE_SIZE << order) > vma->vm_end)) {
+	if (order && (addr < vma->vm_start ||
+		      addr + (PAGE_SIZE << order) > vma->vm_end ||
+		      pfn & ((1 << order) - 1))) {
 		ret = VM_FAULT_FALLBACK;
 		goto out;
 	}
-- 
2.48.1


