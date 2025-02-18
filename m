Return-Path: <kvm+bounces-38501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2FDA3AB96
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E8107A2C9E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163091DE2BB;
	Tue, 18 Feb 2025 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7nwf3Uj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707631D90A5
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917354; cv=none; b=illW0R4r4QlT764cibqtpfaWJJwfS6Rk67R7rNmHgzTHyKeTv5g5CdxFdifGsWM7KbOWjJbjMkvYZpVoJLsToTrlp2PwIHnmF5D6i/CtAAq15agO6RLmGNp3d5iBQXVZ2R3pz6vYsNXx8IPNj7bz3wZa+W//xnIOOD9fvC6vfSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917354; c=relaxed/simple;
	bh=MZi0G595/r9xUXjZTCGwzF11A8teSxnnD1Og3r0T5v8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KJzeDkwUAVMQ8eGOpIb1wQbghNIrfPBVFpaMnJJfm0QdbIn0qwPILwbeSBGZLiSZwE3oWroaPTxAx3fZYCZj9eXMzRBveU2tBd6eQuWKcRLMjeIWV9YqjlRLJxhg2htpyCc/c/UdxUdcUtpcMeS0Sg6sIaOYc9bXi1K40eb2vJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7nwf3Uj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739917350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=efAXFa+L6vXYh488YwyV1z4UrGp5zEEawYWAKbu8b9w=;
	b=H7nwf3Uj1PEfII/uvrbQnAeQm/xWR7tUJxQqpWMKDy6lLZdiCrHBiIrTAiHyWRiOTOs3vO
	CkkW0t9Ddk6Q55KaVYTT/rT2+S69DSB5QwdMSyKEVYLp6PlkI2jGN3T6h2iWLhITTqDumx
	nx3D1jQ0tjF5ORLPGPWruRb6i2WJMk0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-PBxebS9QNbq5q6NhHJoBKQ-1; Tue,
 18 Feb 2025 17:22:26 -0500
X-MC-Unique: PBxebS9QNbq5q6NhHJoBKQ-1
X-Mimecast-MFC-AGG-ID: PBxebS9QNbq5q6NhHJoBKQ_1739917345
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8476180087D;
	Tue, 18 Feb 2025 22:22:24 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C482300019F;
	Tue, 18 Feb 2025 22:22:15 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	jgg@nvidia.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	david@redhat.com,
	willy@infradead.org
Subject: [PATCH v2 0/6] vfio: Improve DMA mapping performance for huge pfnmaps
Date: Tue, 18 Feb 2025 15:22:00 -0700
Message-ID: <20250218222209.1382449-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

v2:
 - Rewrapped comment block in 3/6
 - Added 4/6 to use consistent types (Jason)
 - Renamed s/pgmask/addr_mask/ (David)
 - Updated 6/6 with proposed epfn algorithm (Jason)
 - Applied and retained sign-offs for all but 6/6 where the epfn
   calculation changed

v1: https://lore.kernel.org/all/20250205231728.2527186-1-alex.williamson@redhat.com/

As GPU BAR sizes increase, the overhead of DMA mapping pfnmap ranges has
become a significant overhead for VMs making use of device assignment.
Not only does each mapping require upwards of a few seconds, but BARs
are mapped in and out of the VM address space multiple times during
guest boot.  Also factor in that multi-GPU configurations are
increasingly commonplace and BAR sizes are continuing to increase.
Configurations today can already be delayed minutes during guest boot.

We've taken steps to make Linux a better guest by batching PCI BAR
sizing operations[1], but it only provides and incremental improvement.

This series attempts to fully address the issue by leveraging the huge
pfnmap support added in v6.12.  When we insert pfnmaps using pud and pmd
mappings, we can later take advantage of the knowledge of the mapping
level page mask to iterate on the relevant mapping stride.  In the
commonly achieved optimal case, this results in a reduction of pfn
lookups by a factor of 256k.  For a local test system, an overhead of
~1s for DMA mapping a 32GB PCI BAR is reduced to sub-millisecond (8M
page sized operations reduced to 32 pud sized operations).

Please review, test, and provide feedback.  I hope that mm folks can
ack the trivial follow_pfnmap_args update to provide the mapping level
page mask.  Naming is hard, so any preference other than pgmask is
welcome.  Thanks,

Alex

[1]https://lore.kernel.org/all/20250120182202.1878581-1-alex.williamson@redhat.com/


Alex Williamson (6):
  vfio/type1: Catch zero from pin_user_pages_remote()
  vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
  vfio/type1: Use vfio_batch for vaddr_get_pfns()
  vfio/type1: Use consistent types for page counts
  mm: Provide address mask in struct follow_pfnmap_args
  vfio/type1: Use mapping page mask for pfnmaps

 drivers/vfio/vfio_iommu_type1.c | 123 ++++++++++++++++++++------------
 include/linux/mm.h              |   2 +
 mm/memory.c                     |   1 +
 3 files changed, 80 insertions(+), 46 deletions(-)

-- 
2.48.1


