Return-Path: <kvm+bounces-53897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B2419B19FD9
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A45AC4E11CF
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E499624EA80;
	Mon,  4 Aug 2025 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Kn+j3llP"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1187E22D7B6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304130; cv=none; b=Xd1ZACdQQVbq1Fmzf6JsAa0VRjhUHDqx0E3wFfVln8IVbz7LhtWMcPY5pPCH+uMjSFi+c3JTk22sxDPabwM2p4VdeeWZHMW8qzfhakMf6rg0WG86y7qTJIZhmDLLMYCW3/u8kUNfoS26QSrbOPVfs6OiU7l1MNYgwOScBXEjYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304130; c=relaxed/simple;
	bh=L8PQdzDdW/6Y+49l9RJbZKaIE6ROwBxyYslwlLlkXb0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dN1Jo2hgxC9SOcB3Yt3/aHwx8Hc8pmZtHz+Q4/ps0eDHKy3Fe7swWt/Azh5auS1YgCXxmFPu1CwFzgLQzJHFWRtpSfBESNvyYCNLhxgX5GwjLmel3Y1OFIGzd4qAlIkhIgppzSw/gETovCN0EWelN/WaFbs3FU0v9WPI40uKH28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Kn+j3llP; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304128; x=1785840128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RNxYYPEdCy2oDvyA8Z1xX+7JrlMJjrWMwrBVPOXKyLI=;
  b=Kn+j3llP0Eb29Cfh5BfIWWJvmn4/09pnBOqLo6RBowNEbK8w0/CpNZ1C
   zHaPaf2f/1ehb0U1wmloL0uOGS3qqB6gorhp+FcK+XKi5sPf+4GkHMVSC
   MUNk0tALr+sw0xGSe41aP0IvzcNZFV2vcFEaTKCfvbk0zzXMjm6XI2KLI
   brblQU7gWplg7lBGsEKb0GZX/SYtoLxXAQEBkP4mBZNQ5BYxlnHtNQcvr
   TBkaWM5qL8pfTR1kpg9kfkgCAgXN+uPreKP7oCctv49PkzjN6yaI40kJQ
   KUldFxWY4Zg/zHynLFyTNbxQsYORqH+U1djLRzHpb+MKJj9Nqhr4FI+ml
   w==;
X-CSE-ConnectionGUID: 4SiJzRKlRDiF4T9SXEZcZg==
X-CSE-MsgGUID: TmM3ir17SjuCOhQH5VR1+Q==
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="529744"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-west-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:42:06 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:8853]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.135:2525] with esmtp (Farcaster)
 id 61f97a8b-7729-4fab-865b-314bd13809ed; Mon, 4 Aug 2025 10:42:05 +0000 (UTC)
X-Farcaster-Flow-ID: 61f97a8b-7729-4fab-865b-314bd13809ed
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:42:05 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:42:02 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 3/9] vfio-pci-core: rename vm operations
Date: Mon, 4 Aug 2025 12:39:56 +0200
Message-ID: <20250804104012.87915-4-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

rename vm operations from mmap to vm to avoid confusion with the vfio
mmap naming. mainly because we will reuse the name vfio_pci_mmap_ops
for the following patches.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcdd..9a22969607bfe 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1641,7 +1641,7 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
-static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
+static vm_fault_t vfio_pci_vm_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -1696,15 +1696,15 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	return ret;
 }
 
-static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
+static vm_fault_t vfio_pci_vm_page_fault(struct vm_fault *vmf)
 {
-	return vfio_pci_mmap_huge_fault(vmf, 0);
+	return vfio_pci_vm_huge_fault(vmf, 0);
 }
 
-static const struct vm_operations_struct vfio_pci_mmap_ops = {
-	.fault = vfio_pci_mmap_page_fault,
+static const struct vm_operations_struct vfio_pci_vm_ops = {
+	.fault = vfio_pci_vm_page_fault,
 #ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
-	.huge_fault = vfio_pci_mmap_huge_fault,
+	.huge_fault = vfio_pci_vm_huge_fault,
 #endif
 };
 
@@ -1792,7 +1792,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 */
 	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
 			VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &vfio_pci_mmap_ops;
+	vma->vm_ops = &vfio_pci_vm_ops;
 
 	return 0;
 }
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


