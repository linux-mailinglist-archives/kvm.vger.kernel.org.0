Return-Path: <kvm+bounces-53228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 692FBB0F2D3
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50549548AD4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BAF2E7F35;
	Wed, 23 Jul 2025 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETK2qZcN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B572E5B2F;
	Wed, 23 Jul 2025 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753275720; cv=none; b=RFmXc6jzv3KOhJG2lJFSPhV92sWrl8AXhdjVw05+4LHWm7fJkdDRqNy+TjdHqlWin/mZNgztDQes7c7R5Ijgq3TxOOwiawdJO0+PUmmhR1UuO0YUUMYyjfzAcWvXNj8Wi5POhjG9MzeJcY4HldvWKeBxyIN7tju0Yc2pa5pH0Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753275720; c=relaxed/simple;
	bh=DdEPBcDoyZyAyQmgxVcA/USPwfaH12G0OefCJEr49ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZCR194sXZBA8vAWt+FbE+TP/8knJtta7HK/RKYpDyJ+mBQvesXwKbYLYWOOYRLN2sPGh5yOwPc9IZgLjlqt8VhvgRwmpRlzASdE4tpfQxpWSyvg0a5PXeSTPE+Ym6SBZqKJutW8fljyBDOVFmyqq8h8m4rKUmDuLAv9+UNVU2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETK2qZcN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762A9C4CEE7;
	Wed, 23 Jul 2025 13:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275720;
	bh=DdEPBcDoyZyAyQmgxVcA/USPwfaH12G0OefCJEr49ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETK2qZcN6+sQYJHSkoLVV0k/yH8twcRhKOYJgr93JPgv0nrXxZCzfFwSW1/G62IK+
	 dHXoqPt/Wx9t/L3G4sdDyxTDD3f4GLS20xqlO/uiD8S/BJbeMCdXOYPXBGSX5rWv8h
	 uU36XgMIC3kZdDlUYy2xEFpyQkWd7Ao9AI7MS+qm7TPCbsSNBulQ2TAtVt47DFfyvb
	 2rHJLTEmxms3qV80raVb15Ef5YlYHRpwCIAejwL3MXphMFCzgKfNnc/M/MphZcoMgV
	 btntopHEIl6egN2Hxfn87m1H+IhrWppCwky4m3zkIqrXkZG2T894pcTMD+L6pjBS5w
	 +ULHryOUF5DNQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 01/10] PCI/P2PDMA: Remove redundant bus_offset from map state
Date: Wed, 23 Jul 2025 16:00:02 +0300
Message-ID: <c1a4acd69e040fc2cc7e552849f4d922f5f66325.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Remove the bus_off field from pci_p2pdma_map_state since it duplicates
information already available in the pgmap structure. The bus_offset
is only used in one location (pci_p2pdma_bus_addr_map) and is always
identical to pgmap->bus_offset.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 1 -
 include/linux/pci-p2pdma.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 8d955c25aed36..fe347ed7fd8f4 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 {
 	state->pgmap = page_pgmap(page);
 	state->map = pci_p2pdma_map_type(state->pgmap, dev);
-	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 075c20b161d98..b502fc8b49bf9 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
 struct pci_p2pdma_map_state {
 	struct dev_pagemap *pgmap;
 	enum pci_p2pdma_map_type map;
-	u64 bus_off;
 };
 
 /* helper for pci_p2pdma_state(), do not use directly */
@@ -186,7 +185,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.50.1


