Return-Path: <kvm+bounces-62749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1174CC4CE26
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 66F7A4F84FB
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D493334381;
	Tue, 11 Nov 2025 09:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUY4+UF+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C5E2FF67F;
	Tue, 11 Nov 2025 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762855101; cv=none; b=G5QV0PbLu/yQrGLSo0dgyova7sZtWWzNdmRvr7Gqm3++5dvfUytvWkNbaokjnT9oL3LEe34dKg4hXQpid8b43gUJ/TcqgvfZTqI5sbGlnjZ2JzfIcr0S3wIdMA+nuSyEeoYYZFT5lj3ShukzUwocT2ogayPsJqJ5MWoZDsxZeIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762855101; c=relaxed/simple;
	bh=JMbrxy8ypHgHgSl15UdeV2RJ/cpbWX2+AcI5KUR48AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEtWnyFvbeRSUpixvGh09Jfhgo8HmA2IzjvvBbnzB/hJ38DWN53jx49bC20yNwf8mgo+yQrtFmWGi0gdAo9IQtfNl5hmzYDc6MwINb6cV6pM/xT5z7TKzfTgINUpBHCeNiwpD3JIv7mnMl3Fskiatlw+6YB6JKX3TnCwcO1F2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUY4+UF+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801D1C4AF0B;
	Tue, 11 Nov 2025 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855101;
	bh=JMbrxy8ypHgHgSl15UdeV2RJ/cpbWX2+AcI5KUR48AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUY4+UF+EXRnN9Hujwe0c68EGBioGoHuy1cdoWJuF8I1px8uJXFiLZ0D5bTmQLjjL
	 ntAQ/6Iy7rATBH57keQpKd1R3hKAxm5d56qGewKfkkdq4spN0tw4OwoV4xcCX1M5Ka
	 4lpv5E5Z5QKl1oo6Km0lBQFlDkLusuSahHnuF0pgBdKx9XCHMAJH4J6vZr5tebdySA
	 LKxI6as0rnpaBsPi3KOv65cLe1UuP3nUNHI0VZ0hsDYoQ9upWJKYnWrfCnfjysg4Qd
	 miwMVbEjUk68yDfPp3JdEN7Tf8jtNacP4AjGu2LlagXdkVEveJcxB2wBW6AphBQ5EE
	 2fg3iLBRhFzJg==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather mapping routine
Date: Tue, 11 Nov 2025 11:57:48 +0200
Message-ID: <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
MMIO physical address ranges into scatter-gather tables with proper
DMA mapping.

These common functions are a starting point and support any PCI
drivers creating mappings from their BAR's MMIO addresses. VFIO is one
case, as shortly will be RDMA. We can review existing DRM drivers to
refactor them separately. We hope this will evolve into routines to
help common DRM that include mixed CPU and MMIO mappings.

Compared to the dma_map_resource() abuse this implementation handles
the complicated PCI P2P scenarios properly, especially when an IOMMU
is enabled:

 - Direct bus address mapping without IOVA allocation for
   PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
   happens if the IOMMU is enabled but the PCIe switch ACS flags allow
   transactions to avoid the host bridge.

   Further, this handles the slightly obscure, case of MMIO with a
   phys_addr_t that is different from the physical BAR programming
   (bus offset). The phys_addr_t is converted to a dma_addr_t and
   accommodates this effect. This enables certain real systems to
   work, especially on ARM platforms.

 - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
   attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
   This happens when the IOMMU is enabled and the ACS flags are forcing
   all traffic to the IOMMU - ie for virtualization systems.

 - Cases where P2P is not supported through the host bridge/CPU. The
   P2P subsystem is the proper place to detect this and block it.

Helper functions fill_sg_entry() and calc_sg_nents() handle the
scatter-gather table construction, splitting large regions into
UINT_MAX-sized chunks to fit within sg->length field limits.

Since the physical address based DMA API forbids use of the CPU list
of the scatterlist this will produce a mangled scatterlist that has
a fully zero-length and NULL'd CPU list. The list is 0 length,
all the struct page pointers are NULL and zero sized. This is stronger
and more robust than the existing mangle_sg_table() technique. It is
a future project to migrate DMABUF as a subsystem away from using
scatterlist for this data structure.

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   |  18 ++++
 2 files changed, 253 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 2bcf9ceca997..cb55dff1dad5 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1254,6 +1254,241 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
 
+static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
+					 dma_addr_t addr)
+{
+	unsigned int len, nents;
+	int i;
+
+	nents = DIV_ROUND_UP(length, UINT_MAX);
+	for (i = 0; i < nents; i++) {
+		len = min_t(size_t, length, UINT_MAX);
+		length -= len;
+		/*
+		 * DMABUF abuses scatterlist to create a scatterlist
+		 * that does not have any CPU list, only the DMA list.
+		 * Always set the page related values to NULL to ensure
+		 * importers can't use it. The phys_addr based DMA API
+		 * does not require the CPU list for mapping or unmapping.
+		 */
+		sg_set_page(sgl, NULL, 0, 0);
+		sg_dma_address(sgl) = addr + i * UINT_MAX;
+		sg_dma_len(sgl) = len;
+		sgl = sg_next(sgl);
+	}
+
+	return sgl;
+}
+
+static unsigned int calc_sg_nents(struct dma_iova_state *state,
+				  struct dma_buf_phys_vec *phys_vec,
+				  size_t nr_ranges, size_t size)
+{
+	unsigned int nents = 0;
+	size_t i;
+
+	if (!state || !dma_use_iova(state)) {
+		for (i = 0; i < nr_ranges; i++)
+			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
+	} else {
+		/*
+		 * In IOVA case, there is only one SG entry which spans
+		 * for whole IOVA address space, but we need to make sure
+		 * that it fits sg->length, maybe we need more.
+		 */
+		nents = DIV_ROUND_UP(size, UINT_MAX);
+	}
+
+	return nents;
+}
+
+/**
+ * struct dma_buf_dma - holds DMA mapping information
+ * @sgt:    Scatter-gather table
+ * @state:  DMA IOVA state relevant in IOMMU-based DMA
+ * @size:   Total size of DMA transfer
+ */
+struct dma_buf_dma {
+	struct sg_table sgt;
+	struct dma_iova_state *state;
+	size_t size;
+};
+
+/**
+ * dma_buf_map - Returns the scatterlist table of the attachment from arrays
+ * of physical vectors. This funciton is intended for MMIO memory only.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @provider:	[in]	p2pdma provider
+ * @phys_vec:	[in]	array of physical vectors
+ * @nr_ranges:	[in]	number of entries in phys_vec array
+ * @size:	[in]	total size of phys_vec
+ * @dir:	[in]	direction of DMA transfer
+ *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error. May return -EINTR if it is interrupted by a signal.
+ *
+ * On success, the DMA addresses and lengths in the returned scatterlist are
+ * PAGE_SIZE aligned.
+ *
+ * A mapping must be unmapped by using dma_buf_unmap().
+ */
+struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
+			     struct p2pdma_provider *provider,
+			     struct dma_buf_phys_vec *phys_vec,
+			     size_t nr_ranges, size_t size,
+			     enum dma_data_direction dir)
+{
+	unsigned int nents, mapped_len = 0;
+	struct dma_buf_dma *dma;
+	struct scatterlist *sgl;
+	dma_addr_t addr;
+	size_t i;
+	int ret;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (WARN_ON(!attach || !attach->dmabuf || !provider))
+		/* This function is supposed to work on MMIO memory only */
+		return ERR_PTR(-EINVAL);
+
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return ERR_PTR(-ENOMEM);
+
+	switch (pci_p2pdma_map_type(provider, attach->dev)) {
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * There is no need in IOVA at all for this flow.
+		 */
+		break;
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
+		if (!dma->state) {
+			ret = -ENOMEM;
+			goto err_free_dma;
+		}
+
+		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_free_dma;
+	}
+
+	nents = calc_sg_nents(dma->state, phys_vec, nr_ranges, size);
+	ret = sg_alloc_table(&dma->sgt, nents, GFP_KERNEL | __GFP_ZERO);
+	if (ret)
+		goto err_free_state;
+
+	sgl = dma->sgt.sgl;
+
+	for (i = 0; i < nr_ranges; i++) {
+		if (!dma->state) {
+			addr = pci_p2pdma_bus_addr_map(provider,
+						       phys_vec[i].paddr);
+		} else if (dma_use_iova(dma->state)) {
+			ret = dma_iova_link(attach->dev, dma->state,
+					    phys_vec[i].paddr, 0,
+					    phys_vec[i].len, dir,
+					    DMA_ATTR_MMIO);
+			if (ret)
+				goto err_unmap_dma;
+
+			mapped_len += phys_vec[i].len;
+		} else {
+			addr = dma_map_phys(attach->dev, phys_vec[i].paddr,
+					    phys_vec[i].len, dir,
+					    DMA_ATTR_MMIO);
+			ret = dma_mapping_error(attach->dev, addr);
+			if (ret)
+				goto err_unmap_dma;
+		}
+
+		if (!dma->state || !dma_use_iova(dma->state))
+			sgl = fill_sg_entry(sgl, phys_vec[i].len, addr);
+	}
+
+	if (dma->state && dma_use_iova(dma->state)) {
+		WARN_ON_ONCE(mapped_len != size);
+		ret = dma_iova_sync(attach->dev, dma->state, 0, mapped_len);
+		if (ret)
+			goto err_unmap_dma;
+
+		sgl = fill_sg_entry(sgl, mapped_len, dma->state->addr);
+	}
+
+	dma->size = size;
+
+	/*
+	 * No CPU list included — set orig_nents = 0 so others can detect
+	 * this via SG table (use nents only).
+	 */
+	dma->sgt.orig_nents = 0;
+
+
+	/*
+	 * SGL must be NULL to indicate that SGL is the last one
+	 * and we allocated correct number of entries in sg_alloc_table()
+	 */
+	WARN_ON_ONCE(sgl);
+	return &dma->sgt;
+
+err_unmap_dma:
+	if (!i || !dma->state) {
+		; /* Do nothing */
+	} else if (dma_use_iova(dma->state)) {
+		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
+				 DMA_ATTR_MMIO);
+	} else {
+		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
+			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
+	}
+	sg_free_table(&dma->sgt);
+err_free_state:
+	kfree(dma->state);
+err_free_dma:
+	kfree(dma);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_map, "DMA_BUF");
+
+/**
+ * dma_buf_unmap - unmaps the buffer
+ * @attach:	[in]	attachment to unmap buffer from
+ * @sgt:	[in]	scatterlist info of the buffer to unmap
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * This unmaps a DMA mapping for @attached obtained by dma_buf_map().
+ */
+void dma_buf_unmap(struct dma_buf_attachment *attach, struct sg_table *sgt,
+		   enum dma_data_direction dir)
+{
+	struct dma_buf_dma *dma = container_of(sgt, struct dma_buf_dma, sgt);
+	int i;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (!dma->state) {
+		; /* Do nothing */
+	} else if (dma_use_iova(dma->state)) {
+		dma_iova_destroy(attach->dev, dma->state, dma->size, dir,
+				 DMA_ATTR_MMIO);
+	} else {
+		struct scatterlist *sgl;
+
+		for_each_sgtable_dma_sg(sgt, sgl, i)
+			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
+	}
+
+	sg_free_table(sgt);
+	kfree(dma->state);
+	kfree(dma);
+
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_unmap, "DMA_BUF");
+
 /**
  * dma_buf_move_notify - notify attachments that DMA-buf is moving
  *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d58e329ac0e7..545ba27a5040 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/dma-fence.h>
 #include <linux/wait.h>
+#include <linux/pci-p2pdma.h>
 
 struct device;
 struct dma_buf;
@@ -530,6 +531,16 @@ struct dma_buf_export_info {
 	void *priv;
 };
 
+/**
+ * struct dma_buf_phys_vec - describe continuous chunk of memory
+ * @paddr:   physical address of that chunk
+ * @len:     Length of this chunk
+ */
+struct dma_buf_phys_vec {
+	phys_addr_t paddr;
+	size_t len;
+};
+
 /**
  * DEFINE_DMA_BUF_EXPORT_INFO - helper macro for exporters
  * @name: export-info name
@@ -609,4 +620,11 @@ int dma_buf_vmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
 void dma_buf_vunmap_unlocked(struct dma_buf *dmabuf, struct iosys_map *map);
 struct dma_buf *dma_buf_iter_begin(void);
 struct dma_buf *dma_buf_iter_next(struct dma_buf *dmbuf);
+struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
+			     struct p2pdma_provider *provider,
+			     struct dma_buf_phys_vec *phys_vec,
+			     size_t nr_ranges, size_t size,
+			     enum dma_data_direction dir);
+void dma_buf_unmap(struct dma_buf_attachment *attach, struct sg_table *sgt,
+		   enum dma_data_direction dir);
 #endif /* __DMA_BUF_H__ */

-- 
2.51.1


