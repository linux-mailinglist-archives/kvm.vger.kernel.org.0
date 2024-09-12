Return-Path: <kvm+bounces-26686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E98D997675D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 232511C213E1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731D21A3AAF;
	Thu, 12 Sep 2024 11:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqy5RZrK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845F01A38F0;
	Thu, 12 Sep 2024 11:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139776; cv=none; b=dVkyfUHAEl0urBaETLSBRQIKrw2rsq0nQrVe8hiuSkZ92WdVkWvSiYvXY8hMV4pqCc2RAKKnmlNcEPFySjLSoNoUIC/KWDh/9RrntE0IXusCfjlexux3ERHew5yKuvKalKG0jMjUU685J/4DudtAz591bGIPvYlqk9+1StJT0M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139776; c=relaxed/simple;
	bh=wOAE2cOF8fAnldbeI2zuqZ+UOONgwZZm16iJWxrv2PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofkoh+z3YaCBqn726agZjHTSuc3mhdUljK85yAcIRsWzlD/FixZMHPVfiUUvK0zsA/N8Q0s6w6qC43Hv8X0yblKiuZxYz3gqpwBg7Y0yDAHLLdGRa8l/2rBNkpTTEfqdUd1GkSe9TuUfJlW2VckIPgstp/ttWo6o24RQIbQwAcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqy5RZrK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577FC4CECE;
	Thu, 12 Sep 2024 11:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139776;
	bh=wOAE2cOF8fAnldbeI2zuqZ+UOONgwZZm16iJWxrv2PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqy5RZrK9GLnKls1wNDOUPi+7NtU2JS4w8JdmoFHMUazCDp35ubbfNk+eD2Ky3+kD
	 c9dh8XOv6xn8eUdWkXYq/ky1ASXhJwYbPSmlWO7OggXZokzWbb0xc++iuMk1NnstOZ
	 9G+LadC3Vfaio8VU/li3IVUb1dbRspKdNLjwGfwSKTIlBcbij2YVopnafSpz+igh2w
	 8q3vtsyRvLIliApnPdT+nobPr5chNkY+1N1mtTKAQdsI0f3f4yiiv78QQi0zQHlzvS
	 4okcMEZtIu1uoplQgT2/NieLqCfTUhXBYZSEndngVTH5rsuHS4qYvHNtl2e/+MdkFi
	 0ds6D1OQO+Iuw==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 04/21] dma-mapping: initialize IOVA state struct
Date: Thu, 12 Sep 2024 14:15:39 +0300
Message-ID: <cae6ddc4bad0045919758ae3a65f98ef84f6406d.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Allow callers to properly initialize the IOVA state struct by providing
a new function to do so. This will make sure that even users who doesn't
zero their allocated memory will have a valid IOVA state struct.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f693aafe221f..285075873077 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -76,6 +76,20 @@
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
+struct dma_iova_state {
+	struct device *dev;
+	enum dma_data_direction dir;
+};
+
+static inline void dma_init_iova_state(struct dma_iova_state *state,
+				       struct device *dev,
+				       enum dma_data_direction dir)
+{
+	memset(state, 0, sizeof(*state));
+	state->dev = dev;
+	state->dir = dir;
+}
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
-- 
2.46.0


