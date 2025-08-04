Return-Path: <kvm+bounces-53908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A172EB1A28C
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30B3516DEAE
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 13:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88669263889;
	Mon,  4 Aug 2025 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2heiyEq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCEB15746F;
	Mon,  4 Aug 2025 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754312462; cv=none; b=iaD6fjR3Uwp3kS2kCVihYTmPiIayRlupkUXSDrUXIbMOLWec6qsHTyL8zXTBhK5JWfbP6e+06dJFG9TpGZkublHWG17MFpep/aHAgHJm+u122Dz1wcn/E+DuKQP8yA6UERO9OImEqEtNtttOHmTl2zB8FrOEi4g1vV+tn1GY/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754312462; c=relaxed/simple;
	bh=NGf1AYRJqA3TDpKjHdv56/eFxItdmJcxurU8Pl18z1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6A340UqNlfK0xu9jocjAgV8N8dZt9YoGW3ZUXlnM/H7+qIK58hctE8jpt91JVeuE8nZFKuF5bGV8JHQGB2UEEd66JO0X0lgmTcffxQ1h9WuRQaPm5Q54aOPrQNEsUZr/hfWQrqxoPWCHX4Ednfr51S4+uD6x9UA0MtPRmYtjrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2heiyEq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FECEC4CEF7;
	Mon,  4 Aug 2025 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312461;
	bh=NGf1AYRJqA3TDpKjHdv56/eFxItdmJcxurU8Pl18z1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2heiyEqDcV3a7/Mlnc3aDnSnlB91n/iIZskVpJMq07doaJ4Y/+n8z6i9uQQ97TTI
	 Jwn0N16sASMrrNaXjxejbTLPAT9lGF7/gcaarJFfI95wEN2Kz7h6p1b0JkTfrEfX1D
	 VmbMlwmvB94SRPw2Xf00i3CbnZQu4DmD3LJOwOg2/BnEk/zOGMDtR/fPvAMB7TZrjt
	 D2BZw3t3cwdHCfJg4yEMRZxnPlAGDpPyhGUZmjuuOELZDDsSP1Cj+D3TXKyV+f0pZ3
	 MnJhHXzeBublwqXE+kDR1RxC/k4p4smIMvq4VeNTH7oDc1ta1AFC3kGqyk5VZsiQTO
	 Ve6+Tt4c6rKlg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from map state
Date: Mon,  4 Aug 2025 16:00:36 +0300
Message-ID: <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 1 -
 include/linux/pci-p2pdma.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index da5657a020074..274bb7bcc0bc5 100644
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


