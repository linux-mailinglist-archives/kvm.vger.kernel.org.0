Return-Path: <kvm+bounces-18363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 915988D449F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 06:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5AC51C2137A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 04:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FABA14389D;
	Thu, 30 May 2024 04:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7w0Eojt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668D2CA8
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 04:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717044766; cv=none; b=aHrVMtm+jGpjKfFY3Rf0bMh6wYi0qDwPuHhxPNMY6OYtlst4H5Jn7yL/XY+tY6aUl97X6J4OLMHNr76kc/eUnhIXyOdTSr+U7md3HYB/CqqbYXeFk40cfWC8tZHy4oXUxw4xEIKRpQarFyCtdLLKxlRNbmJLXV4KDIWuCKu81hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717044766; c=relaxed/simple;
	bh=FryIb9LdDf6yO4y3dba69qqaDooFzLeFGzSwV7ZnrNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BiBKvKNrRef3aDVd3Kl026x1AKjZG27Zz/hA5DuZeptyN/gN5DcYq2Uwz8niSCJRH/mocFFRrVn+nhjSd9feVlx1ClWDkPq+dwOuEVZuppBzlitw9loqHb7mb2fvi2sFBlmgEteJkVuFbRSy7gao1m00Ivv6o4zHryW83UIYIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7w0Eojt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717044763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TtUi/0CUWjiS+hFe2EF2PKDtAM9NcpkJTYemICNF0jY=;
	b=L7w0Eojtwy+xGq9gxDAo+4bFTN6PUwT/3PjXeueXd0D9mm//jx5C4CvJfgJ/4HGV1zxzoD
	rvOz+OjYj7+yL+yGYdXgS0jRwoE2FzakU8KxgWHqyleFx0b9ldT01J7NiPBOA6zm72cSB5
	Ptq3Jeh6SZf9a1rh8ERJk3kGQJdiWwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-BnLj3FkEOU2_ooLYBGJ4pw-1; Thu, 30 May 2024 00:52:39 -0400
X-MC-Unique: BnLj3FkEOU2_ooLYBGJ4pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ECEC185A780;
	Thu, 30 May 2024 04:52:39 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.52])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E433286E;
	Thu, 30 May 2024 04:52:38 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	ajones@ventanamicro.com,
	yan.y.zhao@intel.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	peterx@redhat.com
Subject: [PATCH v2 0/2] vfio/pci: vfio device address space mapping
Date: Wed, 29 May 2024 22:52:29 -0600
Message-ID: <20240530045236.1005864-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

v2:
 - Implement the changes as agreed in [0]
   - The redundant tests in vma_to_pfn() are removed as these
     are already performed in vfio_pci_core_mmap().
   - The vma_to_pfn() function is updated to return the pfn directly
     (proposed void return in thread but this makes more sense).
   - Comment preceding vfio_pci_dev_set_hot_reset() is removed,
     comment in loop is updated as proposed.
   - Kept R-b as these are minor changes.

[0]https://lore.kernel.org/all/BN9PR11MB5276289D3F06F90E3F9E71618CF32@BN9PR11MB5276.namprd11.prod.outlook.com/

v1:

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
 drivers/vfio/pci/vfio_pci_core.c | 264 +++++++------------------------
 drivers/vfio/vfio_main.c         |  44 ++++++
 include/linux/vfio.h             |   1 +
 include/linux/vfio_pci_core.h    |   2 -
 6 files changed, 114 insertions(+), 211 deletions(-)

-- 
2.45.0


