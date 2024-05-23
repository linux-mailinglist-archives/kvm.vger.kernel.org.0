Return-Path: <kvm+bounces-18079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4B98CDB22
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 21:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88213B2218F
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FB484D02;
	Thu, 23 May 2024 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYS1dPjw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4676384A36
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716494206; cv=none; b=vGMLQ+iNHu+JfLkBeWolC1QcCTyeB9e5lGHIu/OB0t2ESJcNMX/CbWq1M3YPBqq20EhTrWsPiDVg93H4plDGfF6mvtUTtDi6V82GNlsV51cI9SWmhBqOF5AdDPMm5/QHbu0JfKJG2j0sN978TpyS1y85rCx3I7xeDU/ZMewySs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716494206; c=relaxed/simple;
	bh=s9Y0qLmtXWuO2B9d2CvFP63TH6uKM8kqPX/Eiuv/UwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yc+ZePJFORFE2fOtFg5sM2q1wxFlHx7jWe7mAXwoHDV7hjKpTm1VDAj1/0JmIniU/YnnfF8ZJDKIaEm1YmFFm8IizRFRVNpu+GqfplEuBfAzo/Q+bRUq4Jn5+p7Jp9sSDwAfwvgAmPHzVkiTKGg687apSMGVdzuKyMWvNWS521k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYS1dPjw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716494203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l9ijnQGpSOAYTU8hzrl7HfnTn30gk7E3YM6Dvrh3xJk=;
	b=hYS1dPjwAj6GrQvOYzkdGMPniSLEBoVNYPNITjRIom5aOVRxf4rsB2j/Se2hjKLaqvnWcg
	LhgH8C6BuRr5FOICyw53NYciXUIqAqIZSYRremPTNQwI6u0I2baAWFwD9LmeGOfXEgdHGY
	NWuBxEnEFUiCcshahM1qb2Uz/XNUICo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-JTHBbli7OfiKymcsMWqHPg-1; Thu, 23 May 2024 15:56:38 -0400
X-MC-Unique: JTHBbli7OfiKymcsMWqHPg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 452318058D1;
	Thu, 23 May 2024 19:56:38 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEBE492BC6;
	Thu, 23 May 2024 19:56:37 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	ajones@ventanamicro.com,
	yan.y.zhao@intel.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	peterx@redhat.com
Subject: [PATCH 0/2] vfio/pci: vfio device address space mapping
Date: Thu, 23 May 2024 13:56:25 -0600
Message-ID: <20240523195629.218043-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Upstream commit ba168b52bf8e ("mm: use rwsem assertion macros for
mmap_lock") changes a long standing lockdep issue where we call
io_remap_pfn_range() from within the vm_ops fault handler callback
without the proper write lock[1], generating a WARN_ON that we can
no longer stall to fix.

Attaching an address space to the vfio device file has been discussed
for some time as a way to make use of unmap_mapping_range(), which
provides an easy mechanism for zapping all vmas mapping a section of
the device file, for example mmaps to PCI BARs.  This means that we
no longer need to track those vmas for the purpose of zapping, which
removes a bunch of really ugly locking.  This vma list was also used
to avoid duplicate mappings for concurrent faults to the same vma.
As a result, we now use the more acceptable vmf_insert_pfn() which
actually manages locking correctly from the fault handler versus
io_remap_pfn_range().

The unfortunate side effect of this is that we now fault per page
rather than populate the entire vma with a single fault.  While
this overhead is fairly insignificant for average BAR sizes, it
is notable.  There's potentially quite ugly code we could use to
walk the vmas in the address space to proactively reinsert mappings
to avoid this, but the simpler solution seems to be to teach
vmf_insert_pfn_{pmd,pud}() about pfnmaps such that we can extend
the faulting behavior to include vm_ops huge_fault to both vastly
reduce the number of faults as well as reducing tlb usage.

The above commit seems to require an iterative solution where we
introduce the address space, remove the vma tracking, and make use
of vmf_insert_pfn() in the short term and work on the mm aspects to
enable huge_fault in the long term.

This series is intended for v6.10 given the WARN_ON now encountered
for all vfio-pci uses.  Thanks,

Alex

[1]https://lore.kernel.org/all/20230508125842.28193-1-yan.y.zhao@intel.com/

Alex Williamson (2):
  vfio: Create vfio_fs_type with inode per device
  vfio/pci: Use unmap_mapping_range()

 drivers/vfio/device_cdev.c       |   7 +
 drivers/vfio/group.c             |   7 +
 drivers/vfio/pci/vfio_pci_core.c | 256 +++++++------------------------
 drivers/vfio/vfio_main.c         |  44 ++++++
 include/linux/vfio.h             |   1 +
 include/linux/vfio_pci_core.h    |   2 -
 6 files changed, 115 insertions(+), 202 deletions(-)

-- 
2.45.0


