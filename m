Return-Path: <kvm+bounces-21791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EAF9343F9
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74EE41C21AC5
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4CD188CD8;
	Wed, 17 Jul 2024 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RMeOFSPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C618C33E
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 21:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721252032; cv=none; b=CpYrGP5n3sA/1CZe0Lxi16Q5nNptYIy3dAiNPK/Lnrhaeeb0CYFxoUmvtFt5OQtxxnNjPXyaCmt4aB6v1U7nADTTEymMjjEOQl4wGz1ANEa3kE0UQVwSbmYHkrMxIwnQ8slmJdm3SxWHo/WVHIGWbLRCdzPZaqIMdbRUnbR8bsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721252032; c=relaxed/simple;
	bh=FtL2WLykniLMH2iZnDeKB+u5uJJnWt1fxzXfySze5OI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JYih5pJfKpdruygIzTD3xoQEUHQGqNprdKG2pjE3w9KR4EyShP4Z8zW0A/O5b6wahf0OIDS34YWmgzgKbjZ9Ao6MHyVwSoqHiYnc029lKLHu9gW0pDERPMFps3drLEBd2hT19xtb093Ydu/iEceR6Qqfpm6fhJuZIyCtWWksIys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RMeOFSPQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--axelrasmussen.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e05f08adcacso424245276.0
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 14:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721252030; x=1721856830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rLtZj5tEts3mR+eoKmaIr/Y89zsbNNxQ+zwQ1LS5MPo=;
        b=RMeOFSPQ18fD4vaOzqmWhuP6WcU58VwGkM/zPE5MKvd+ynHfi1vPfKov84Aj9o37Md
         xd6G0njHZ/ZCs9pD2qVyvJVsbtMm0fvKfptHgbbccDlBx0LxYMZ+VMY55UNTD7NL2Emf
         jCUfcL3ld25fiOnjTvf+ma0rQcACO/mSL7RKDxB4535BCsFalyPUQYRot0o2MqRDn/ie
         DEB2TgkroVWMtrfMiXocu8Nb2siklskL5UeU1DazUpJ+4BSTvcsROELmnYLdc67Xq92B
         zKEDg5d1YyTQgXpBLUeSw6Uuz4DHtqo5cP/JiTPJh6WQzECruTCRDd9K5n1YnUy3wXvY
         fSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721252030; x=1721856830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rLtZj5tEts3mR+eoKmaIr/Y89zsbNNxQ+zwQ1LS5MPo=;
        b=K11p1f77sbws/nw/5coqrbvSYYOs+y2wzV+6uHyJDo/Kf9ad7MsZ0MGqzLyhfLJ1fJ
         gYgyP/do7ynaTLQHTaTqUJgxPm5pdU+hrY7m/IEzMgCwLCHdCMELsa7eSt0oilK+ZvAJ
         sKaxMYCl+zwnxK63EyTH3crTlBeV11rp08e4uKnqA2tfzYvbewufGBrv4IlAFSZH392J
         Dnaqo1gEMeB9ZOevbpZboDrji77oLl0h3VTC7EfkcNGqJV34BceVlgHc1Is6Y7LfpMiI
         dFTaHtk68CyMn5z5bVtaxhw6YVdAmYGTM5PykNhTUr17FaXGWqK/2D/qheXMqcDPkxso
         KC+g==
X-Forwarded-Encrypted: i=1; AJvYcCWclTENpYBcZox6zUSiGsxJ5JT8aGafRx+9JnDJovoLxxFK+AFideXdyT+duJxtZKd78b4UBQPQjnDkndTOHUTaBg8I
X-Gm-Message-State: AOJu0YxT7PEzi6yqnJiTLXXRoB3JsUcmhYOwaR/+Y+exrPOi3eOrCglV
	YN58u/9F+PSujY8lfKROLK6d/dzI9WcTaANCLfHduQtQj/lQKquX9+0hpCpv3LMCRpums0DCK1a
	+bC7BIGEfVU9HzW1HU0IL0tI3oBWJVw==
X-Google-Smtp-Source: AGHT+IHE4njs2DlarzKbQm9eMkmED17D/9sHKkJxOr/ao4nCy9IEICWK9iZlriPw9z3+uBXfjriRyfh4WAQDV+e5utZ9
X-Received: from axel.svl.corp.google.com ([2620:15c:2a3:200:a503:d697:557b:840c])
 (user=axelrasmussen job=sendgmr) by 2002:a05:6902:150b:b0:e03:f2ea:717c with
 SMTP id 3f1490d57ef6-e05feb87b5amr1284276.5.1721252029671; Wed, 17 Jul 2024
 14:33:49 -0700 (PDT)
Date: Wed, 17 Jul 2024 14:33:39 -0700
In-Reply-To: <20240717213339.1921530-1-axelrasmussen@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240717213339.1921530-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240717213339.1921530-4-axelrasmussen@google.com>
Subject: [PATCH 6.9 3/3] vfio/pci: Insert full vma on mmap'd MMIO fault
From: Axel Rasmussen <axelrasmussen@google.com>
To: stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Eric Auger <eric.auger@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Kunwu Chan <chentao@kylinos.cn>, Leah Rumancik <leah.rumancik@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Stefan Hajnoczi <stefanha@redhat.com>, Yi Liu <yi.l.liu@intel.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Alex Williamson <alex.williamson@redhat.com>

commit d71a989cf5d961989c273093cdff2550acdde314 upstream.

In order to improve performance of typical scenarios we can try to insert
the entire vma on fault.  This accelerates typical cases, such as when
the MMIO region is DMA mapped by QEMU.  The vfio_iommu_type1 driver will
fault in the entire DMA mapped range through fixup_user_fault().

In synthetic testing, this improves the time required to walk a PCI BAR
mapping from userspace by roughly 1/3rd.

This is likely an interim solution until vmf_insert_pfn_{pmd,pud}() gain
support for pfnmaps.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/all/Zl6XdUkt%2FzMMGOLF@yzhao56-desk.sh.intel.com/
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/r/20240607035213.2054226-1-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 74a3499a8a2e..e388c974f9f0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1659,6 +1659,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
+	unsigned long addr = vma->vm_start;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	pfn = vma_to_pfn(vma);
@@ -1666,11 +1667,25 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	down_read(&vdev->memory_lock);
 
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
-		goto out_disabled;
+		goto out_unlock;
 
 	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+	if (ret & VM_FAULT_ERROR)
+		goto out_unlock;
 
-out_disabled:
+	/*
+	 * Pre-fault the remainder of the vma, abort further insertions and
+	 * supress error if fault is encountered during pre-fault.
+	 */
+	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
+		if (addr == vmf->address)
+			continue;
+
+		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
+			break;
+	}
+
+out_unlock:
 	up_read(&vdev->memory_lock);
 
 	return ret;
-- 
2.45.2.993.g49e7a77208-goog


