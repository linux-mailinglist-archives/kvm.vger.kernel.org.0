Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C015576E8A5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 14:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbjHCMnw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Aug 2023 08:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjHCMnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 08:43:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32A53A93;
        Thu,  3 Aug 2023 05:43:39 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RGpMz0WqCz67bqV;
        Thu,  3 Aug 2023 20:40:15 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 13:43:37 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.027;
 Thu, 3 Aug 2023 13:43:37 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
CC:     "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v13 vfio 5/7] vfio/pds: Add support for dirty page
 tracking
Thread-Topic: [PATCH v13 vfio 5/7] vfio/pds: Add support for dirty page
 tracking
Thread-Index: AQHZv0DIKUjpx0JJ8UmFiNJzLXvV1K/YkKwQ
Date:   Thu, 3 Aug 2023 12:43:37 +0000
Message-ID: <4167caa5bcfc4e77b5ae55f730909829@huawei.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-6-brett.creeley@amd.com>
In-Reply-To: <20230725214025.9288-6-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brett,

> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 25 July 2023 22:40
> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kevin.tian@intel.com
> Cc: simon.horman@corigine.com; brett.creeley@amd.com;
> shannon.nelson@amd.com
> Subject: [PATCH v13 vfio 5/7] vfio/pds: Add support for dirty page tracking
> 
[...]

> +static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
> +				 struct rb_root_cached *ranges, u32 nnodes,
> +				 u64 *page_size)
> +{
> +	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
> +	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
> +	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
> +	u64 region_start, region_size, region_page_size;
> +	struct pds_lm_dirty_region_info *region_info;
> +	struct interval_tree_node *node = NULL;
> +	u8 max_regions = 0, num_regions;
> +	dma_addr_t regions_dma = 0;
> +	u32 num_ranges = nnodes;
> +	u32 page_count;
> +	u16 len;
> +	int err;
> +
> +	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
> +		pds_vfio->vf_id);
> +
> +	if (pds_vfio_dirty_is_enabled(pds_vfio))
> +		return -EINVAL;
> +
> +	pds_vfio_dirty_set_enabled(pds_vfio);

Any reason why this is set here? It looks to me you could set this at the
end if everything goes well and avoid below goto out_set_disabled s.
Not sure I am missing anything obvious here.

Thanks,
Shameer.
> +
> +	/* find if dirty tracking is disabled, i.e. num_regions == 0 */
> +	err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions,
> +					&num_regions);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
> +			ERR_PTR(err));
> +		goto out_set_disabled;
> +	} else if (num_regions) {
> +		dev_err(&pdev->dev,
> +			"Dirty tracking already enabled for %d regions\n",
> +			num_regions);
> +		err = -EEXIST;
> +		goto out_set_disabled;
> +	} else if (!max_regions) {
> +		dev_err(&pdev->dev,
> +			"Device doesn't support dirty tracking, max_regions %d\n",
> +			max_regions);
> +		err = -EOPNOTSUPP;
> +		goto out_set_disabled;
> +	}
> +
> +	/*
> +	 * Only support 1 region for now. If there are any large gaps in the
> +	 * VM's address regions, then this would be a waste of memory as we
> are
> +	 * generating 2 bitmaps (ack/seq) from the min address to the max
> +	 * address of the VM's address regions. In the future, if we support
> +	 * more than one region in the device/driver we can split the bitmaps
> +	 * on the largest address region gaps. We can do this split up to the
> +	 * max_regions times returned from the dirty_status command.
> +	 */
> +	max_regions = 1;
> +	if (num_ranges > max_regions) {
> +		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
> +		num_ranges = max_regions;
> +	}
> +
> +	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> +	if (!node) {
> +		err = -EINVAL;
> +		goto out_set_disabled;
> +	}
> +
> +	region_size = node->last - node->start + 1;
> +	region_start = node->start;
> +	region_page_size = *page_size;
> +
> +	len = sizeof(*region_info);
> +	region_info = kzalloc(len, GFP_KERNEL);
> +	if (!region_info) {
> +		err = -ENOMEM;
> +		goto out_set_disabled;
> +	}
> +
> +	page_count = DIV_ROUND_UP(region_size, region_page_size);
> +
> +	region_info->dma_base = cpu_to_le64(region_start);
> +	region_info->page_count = cpu_to_le32(page_count);
> +	region_info->page_size_log2 = ilog2(region_page_size);
> +
> +	regions_dma = dma_map_single(pdsc_dev, (void *)region_info, len,
> +				     DMA_BIDIRECTIONAL);
> +	if (dma_mapping_error(pdsc_dev, regions_dma)) {
> +		err = -ENOMEM;
> +		goto out_free_region_info;
> +	}
> +
> +	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
> +	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_BIDIRECTIONAL);
> +	if (err)
> +		goto out_free_region_info;
> +
> +	/*
> +	 * page_count might be adjusted by the device,
> +	 * update it before freeing region_info DMA
> +	 */
> +	page_count = le32_to_cpu(region_info->page_count);
> +
> +	dev_dbg(&pdev->dev,
> +		"region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u
> page_size_log2 %u\n",
> +		regions_dma, region_start, page_count,
> +		(u8)ilog2(region_page_size));
> +
> +	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count / BITS_PER_BYTE);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
> +			ERR_PTR(err));
> +		goto out_free_region_info;
> +	}
> +
> +	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
> +			ERR_PTR(err));
> +		goto out_free_bitmaps;
> +	}
> +
> +	dirty->region_start = region_start;
> +	dirty->region_size = region_size;
> +	dirty->region_page_size = region_page_size;
> +
> +	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
> +
> +	kfree(region_info);
> +
> +	return 0;
> +
> +out_free_bitmaps:
> +	pds_vfio_dirty_free_bitmaps(dirty);
> +out_free_region_info:
> +	kfree(region_info);
> +out_set_disabled:
> +	pds_vfio_dirty_set_disabled(pds_vfio);
> +	return err;
> +}
> +
> +void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio, bool
> send_cmd)
> +{
> +	if (pds_vfio_dirty_is_enabled(pds_vfio)) {
> +		pds_vfio_dirty_set_disabled(pds_vfio);
> +		if (send_cmd)
> +			pds_vfio_dirty_disable_cmd(pds_vfio);
> +		pds_vfio_dirty_free_sgl(pds_vfio);
> +		pds_vfio_dirty_free_bitmaps(&pds_vfio->dirty);
> +	}
> +
> +	if (send_cmd)
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_NONE);
> +}
> +
> +static int pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
> +				  struct pds_vfio_bmp_info *bmp_info,
> +				  u32 offset, u32 bmp_bytes, bool read_seq)
> +{
> +	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
> +	u8 dma_dir = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
> +	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
> +	unsigned long long npages;
> +	struct sg_table sg_table;
> +	struct scatterlist *sg;
> +	struct page **pages;
> +	u32 page_offset;
> +	const void *bmp;
> +	size_t size;
> +	u16 num_sge;
> +	int err;
> +	int i;
> +
> +	bmp = (void *)((u64)bmp_info->bmp + offset);
> +	page_offset = offset_in_page(bmp);
> +	bmp -= page_offset;
> +
> +	/*
> +	 * Start and end of bitmap section to seq/ack might not be page
> +	 * aligned, so use the page_offset to account for that so there
> +	 * will be enough pages to represent the bmp_bytes
> +	 */
> +	npages = DIV_ROUND_UP_ULL(bmp_bytes + page_offset, PAGE_SIZE);
> +	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	for (unsigned long long i = 0; i < npages; i++) {
> +		struct page *page = vmalloc_to_page(bmp);
> +
> +		if (!page) {
> +			err = -EFAULT;
> +			goto out_free_pages;
> +		}
> +
> +		pages[i] = page;
> +		bmp += PAGE_SIZE;
> +	}
> +
> +	err = sg_alloc_table_from_pages(&sg_table, pages, npages, page_offset,
> +					bmp_bytes, GFP_KERNEL);
> +	if (err)
> +		goto out_free_pages;
> +
> +	err = dma_map_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
> +	if (err)
> +		goto out_free_sg_table;
> +
> +	for_each_sgtable_dma_sg(&sg_table, sg, i) {
> +		struct pds_lm_sg_elem *sg_elem = &bmp_info->sgl[i];
> +
> +		sg_elem->addr = cpu_to_le64(sg_dma_address(sg));
> +		sg_elem->len = cpu_to_le32(sg_dma_len(sg));
> +	}
> +
> +	num_sge = sg_table.nents;
> +	size = num_sge * sizeof(struct pds_lm_sg_elem);
> +	dma_sync_single_for_device(pdsc_dev, bmp_info->sgl_addr, size,
> dma_dir);
> +	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, bmp_info->sgl_addr,
> num_sge,
> +					 offset, bmp_bytes, read_seq);
> +	if (err)
> +		dev_err(&pdev->dev,
> +			"Dirty bitmap %s failed offset %u bmp_bytes %u num_sge %u
> DMA 0x%llx: %pe\n",
> +			bmp_type_str, offset, bmp_bytes,
> +			num_sge, bmp_info->sgl_addr, ERR_PTR(err));
> +	dma_sync_single_for_cpu(pdsc_dev, bmp_info->sgl_addr, size,
> dma_dir);
> +
> +	dma_unmap_sgtable(pdsc_dev, &sg_table, dma_dir, 0);
> +out_free_sg_table:
> +	sg_free_table(&sg_table);
> +out_free_pages:
> +	kfree(pages);
> +
> +	return err;
> +}
> +
> +static int pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio,
> +				    u32 offset, u32 len)
> +{
> +	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_ack,
> +				      offset, len, WRITE_ACK);
> +}
> +
> +static int pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio,
> +				   u32 offset, u32 len)
> +{
> +	return pds_vfio_dirty_seq_ack(pds_vfio, &pds_vfio->dirty.host_seq,
> +				      offset, len, READ_SEQ);
> +}
> +
> +static int pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device
> *pds_vfio,
> +					  struct iova_bitmap *dirty_bitmap,
> +					  u32 bmp_offset, u32 len_bytes)
> +{
> +	u64 page_size = pds_vfio->dirty.region_page_size;
> +	u64 region_start = pds_vfio->dirty.region_start;
> +	u32 bmp_offset_bit;
> +	__le64 *seq, *ack;
> +	int dword_count;
> +
> +	dword_count = len_bytes / sizeof(u64);
> +	seq = (__le64 *)((u64)pds_vfio->dirty.host_seq.bmp + bmp_offset);
> +	ack = (__le64 *)((u64)pds_vfio->dirty.host_ack.bmp + bmp_offset);
> +	bmp_offset_bit = bmp_offset * 8;
> +
> +	for (int i = 0; i < dword_count; i++) {
> +		u64 xor = le64_to_cpu(seq[i]) ^ le64_to_cpu(ack[i]);
> +
> +		/* prepare for next write_ack call */
> +		ack[i] = seq[i];
> +
> +		for (u8 bit_i = 0; bit_i < BITS_PER_TYPE(u64); ++bit_i) {
> +			if (xor & BIT(bit_i)) {
> +				u64 abs_bit_i = bmp_offset_bit +
> +						i * BITS_PER_TYPE(u64) + bit_i;
> +				u64 addr = abs_bit_i * page_size + region_start;
> +
> +				iova_bitmap_set(dirty_bitmap, addr, page_size);
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
> +			       struct iova_bitmap *dirty_bitmap,
> +			       unsigned long iova, unsigned long length)
> +{
> +	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
> +	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
> +	u64 bmp_offset, bmp_bytes;
> +	u64 bitmap_size, pages;
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Get dirty page bitmap\n", pds_vfio->vf_id);
> +
> +	if (!pds_vfio_dirty_is_enabled(pds_vfio)) {
> +		dev_err(dev, "vf%u: Sync failed, dirty tracking is disabled\n",
> +			pds_vfio->vf_id);
> +		return -EINVAL;
> +	}
> +
> +	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region_page_size);
> +	bitmap_size =
> +		round_up(pages, sizeof(u64) * BITS_PER_BYTE) / BITS_PER_BYTE;
> +
> +	dev_dbg(dev,
> +		"vf%u: iova 0x%lx length %lu page_size %llu pages %llu
> bitmap_size %llu\n",
> +		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
> +		pages, bitmap_size);
> +
> +	if (!length || ((dirty->region_start + iova + length) >
> +			(dirty->region_start + dirty->region_size))) {
> +		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
> +			iova, length);
> +		return -EINVAL;
> +	}
> +
> +	/* bitmap is modified in 64 bit chunks */
> +	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region_page_size,
> +				       sizeof(u64)),
> +			  sizeof(u64));
> +	if (bmp_bytes != bitmap_size) {
> +		dev_err(dev,
> +			"Calculated bitmap bytes %llu not equal to bitmap
> size %llu\n",
> +			bmp_bytes, bitmap_size);
> +		return -EINVAL;
> +	}
> +
> +	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size,
> sizeof(u64));
> +
> +	dev_dbg(dev,
> +		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu
> bmp_bytes %llu\n",
> +		iova, length, bmp_offset, bmp_bytes);
> +
> +	err = pds_vfio_dirty_read_seq(pds_vfio, bmp_offset, bmp_bytes);
> +	if (err)
> +		return err;
> +
> +	err = pds_vfio_dirty_process_bitmaps(pds_vfio, dirty_bitmap,
> bmp_offset,
> +					     bmp_bytes);
> +	if (err)
> +		return err;
> +
> +	err = pds_vfio_dirty_write_ack(pds_vfio, bmp_offset, bmp_bytes);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +int pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long
> iova,
> +				unsigned long length, struct iova_bitmap *dirty)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	int err;
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	err = pds_vfio_dirty_sync(pds_vfio, dirty, iova, length);
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +
> +	return err;
> +}
> +
> +int pds_vfio_dma_logging_start(struct vfio_device *vdev,
> +			       struct rb_root_cached *ranges, u32 nnodes,
> +			       u64 *page_size)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	int err;
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_IN_PROGRESS);
> +	err = pds_vfio_dirty_enable(pds_vfio, ranges, nnodes, page_size);
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +
> +	return err;
> +}
> +
> +int pds_vfio_dma_logging_stop(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +
> +	mutex_lock(&pds_vfio->state_mutex);
> +	pds_vfio_dirty_disable(pds_vfio, true);
> +	pds_vfio_state_mutex_unlock(pds_vfio);
> +
> +	return 0;
> +}
> diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
> new file mode 100644
> index 000000000000..f78da25d75ca
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/dirty.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _DIRTY_H_
> +#define _DIRTY_H_
> +
> +struct pds_vfio_bmp_info {
> +	unsigned long *bmp;
> +	u32 bmp_bytes;
> +	struct pds_lm_sg_elem *sgl;
> +	dma_addr_t sgl_addr;
> +	u16 num_sge;
> +};
> +
> +struct pds_vfio_dirty {
> +	struct pds_vfio_bmp_info host_seq;
> +	struct pds_vfio_bmp_info host_ack;
> +	u64 region_size;
> +	u64 region_start;
> +	u64 region_page_size;
> +	bool is_enabled;
> +};
> +
> +struct pds_vfio_pci_device;
> +
> +bool pds_vfio_dirty_is_enabled(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_dirty_set_enabled(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_dirty_set_disabled(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio,
> +			    bool send_cmd);
> +
> +int pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long
> iova,
> +				unsigned long length,
> +				struct iova_bitmap *dirty);
> +int pds_vfio_dma_logging_start(struct vfio_device *vdev,
> +			       struct rb_root_cached *ranges, u32 nnodes,
> +			       u64 *page_size);
> +int pds_vfio_dma_logging_stop(struct vfio_device *vdev);
> +#endif /* _DIRTY_H_ */
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index 7e319529cf74..aec75574cab3 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -371,7 +371,7 @@ pds_vfio_step_device_state_locked(struct
> pds_vfio_pci_device *pds_vfio,
> 
>  	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next ==
> VFIO_DEVICE_STATE_STOP) {
>  		pds_vfio_put_save_file(pds_vfio);
> -		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> PDS_LM_STA_NONE);
> +		pds_vfio_dirty_disable(pds_vfio, true);
>  		return NULL;
>  	}
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index b37ef96a7fd8..9e6a96b5db62 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -5,6 +5,7 @@
>  #include <linux/vfio_pci_core.h>
> 
>  #include "lm.h"
> +#include "dirty.h"
>  #include "vfio_dev.h"
> 
>  struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
> @@ -25,7 +26,7 @@ struct pds_vfio_pci_device
> *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>  			    vfio_coredev);
>  }
> 
> -static void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device
> *pds_vfio)
> +void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
>  {
>  again:
>  	spin_lock(&pds_vfio->reset_lock);
> @@ -35,6 +36,7 @@ static void pds_vfio_state_mutex_unlock(struct
> pds_vfio_pci_device *pds_vfio)
>  			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
>  			pds_vfio_put_restore_file(pds_vfio);
>  			pds_vfio_put_save_file(pds_vfio);
> +			pds_vfio_dirty_disable(pds_vfio, false);
>  		}
>  		spin_unlock(&pds_vfio->reset_lock);
>  		goto again;
> @@ -117,6 +119,12 @@ static const struct vfio_migration_ops
> pds_vfio_lm_ops = {
>  	.migration_get_data_size = pds_vfio_get_device_state_size
>  };
> 
> +static const struct vfio_log_ops pds_vfio_log_ops = {
> +	.log_start = pds_vfio_dma_logging_start,
> +	.log_stop = pds_vfio_dma_logging_stop,
> +	.log_read_and_clear = pds_vfio_dma_logging_report,
> +};
> +
>  static int pds_vfio_init_device(struct vfio_device *vdev)
>  {
>  	struct pds_vfio_pci_device *pds_vfio =
> @@ -137,6 +145,7 @@ static int pds_vfio_init_device(struct vfio_device
> *vdev)
> 
>  	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
>  	vdev->mig_ops = &pds_vfio_lm_ops;
> +	vdev->log_ops = &pds_vfio_log_ops;
> 
>  	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>  	dev_dbg(&pdev->dev,
> @@ -175,6 +184,7 @@ static void pds_vfio_close_device(struct vfio_device
> *vdev)
>  	mutex_lock(&pds_vfio->state_mutex);
>  	pds_vfio_put_restore_file(pds_vfio);
>  	pds_vfio_put_save_file(pds_vfio);
> +	pds_vfio_dirty_disable(pds_vfio, true);
>  	mutex_unlock(&pds_vfio->state_mutex);
>  	mutex_destroy(&pds_vfio->state_mutex);
>  	vfio_pci_core_close_device(vdev);
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> index 31bd14de0c91..8109fe101694 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -7,6 +7,7 @@
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
> 
> +#include "dirty.h"
>  #include "lm.h"
> 
>  struct pdsc;
> @@ -17,6 +18,7 @@ struct pds_vfio_pci_device {
> 
>  	struct pds_vfio_lm_file *save_file;
>  	struct pds_vfio_lm_file *restore_file;
> +	struct pds_vfio_dirty dirty;
>  	struct mutex state_mutex; /* protect migration state */
>  	enum vfio_device_mig_state state;
>  	spinlock_t reset_lock; /* protect reset_done flow */
> @@ -26,6 +28,8 @@ struct pds_vfio_pci_device {
>  	u16 client_id;
>  };
> 
> +void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio);
> +
>  const struct vfio_device_ops *pds_vfio_ops_info(void);
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>  void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
> diff --git a/include/linux/pds/pds_adminq.h
> b/include/linux/pds/pds_adminq.h
> index 9c79b3c8fc47..4b4e9a98b37b 100644
> --- a/include/linux/pds/pds_adminq.h
> +++ b/include/linux/pds/pds_adminq.h
> @@ -835,6 +835,13 @@ enum pds_lm_cmd_opcode {
>  	PDS_LM_CMD_RESUME          = 20,
>  	PDS_LM_CMD_SAVE            = 21,
>  	PDS_LM_CMD_RESTORE         = 22,
> +
> +	/* Dirty page tracking commands */
> +	PDS_LM_CMD_DIRTY_STATUS    = 32,
> +	PDS_LM_CMD_DIRTY_ENABLE    = 33,
> +	PDS_LM_CMD_DIRTY_DISABLE   = 34,
> +	PDS_LM_CMD_DIRTY_READ_SEQ  = 35,
> +	PDS_LM_CMD_DIRTY_WRITE_ACK = 36,
>  };
> 
>  /**
> @@ -992,6 +999,172 @@ enum pds_lm_host_vf_status {
>  	PDS_LM_STA_MAX,
>  };
> 
> +/**
> + * struct pds_lm_dirty_region_info - Memory region info for STATUS and
> ENABLE
> + * @dma_base:		Base address of the DMA-contiguous memory region
> + * @page_count:		Number of pages in the memory region
> + * @page_size_log2:	Log2 page size in the memory region
> + * @rsvd:		Word boundary padding
> + */
> +struct pds_lm_dirty_region_info {
> +	__le64 dma_base;
> +	__le32 page_count;
> +	u8     page_size_log2;
> +	u8     rsvd[3];
> +};
> +
> +/**
> + * struct pds_lm_dirty_status_cmd - DIRTY_STATUS command
> + * @opcode:		Opcode PDS_LM_CMD_DIRTY_STATUS
> + * @rsvd:		Word boundary padding
> + * @vf_id:		VF id
> + * @max_regions:	Capacity of the region info buffer
> + * @rsvd2:		Word boundary padding
> + * @regions_dma:	DMA address of the region info buffer
> + *
> + * The minimum of max_regions (from the command) and num_regions
> (from the
> + * completion) of struct pds_lm_dirty_region_info will be written to
> + * regions_dma.
> + *
> + * The max_regions may be zero, in which case regions_dma is ignored.  In
> that
> + * case, the completion will only report the maximum number of regions
> + * supported by the device, and the number of regions currently enabled.
> + */
> +struct pds_lm_dirty_status_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     max_regions;
> +	u8     rsvd2[3];
> +	__le64 regions_dma;
> +} __packed;
> +
> +/**
> + * enum pds_lm_dirty_bmp_type - Type of dirty page bitmap
> + * @PDS_LM_DIRTY_BMP_TYPE_NONE: No bitmap / disabled
> + * @PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK: Seq/Ack bitmap representation
> + */
> +enum pds_lm_dirty_bmp_type {
> +	PDS_LM_DIRTY_BMP_TYPE_NONE     = 0,
> +	PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK  = 1,
> +};
> +
> +/**
> + * struct pds_lm_dirty_status_comp - STATUS command completion
> + * @status:		Status of the command (enum pds_core_status_code)
> + * @rsvd:		Word boundary padding
> + * @comp_index:		Index in the desc ring for which this is the
> completion
> + * @max_regions:	Maximum number of regions supported by the
> device
> + * @num_regions:	Number of regions currently enabled
> + * @bmp_type:		Type of dirty bitmap representation
> + * @rsvd2:		Word boundary padding
> + * @bmp_type_mask:	Mask of supported bitmap types, bit index per type
> + * @rsvd3:		Word boundary padding
> + * @color:		Color bit
> + *
> + * This completion descriptor is used for STATUS, ENABLE, and DISABLE.
> + */
> +struct pds_lm_dirty_status_comp {
> +	u8     status;
> +	u8     rsvd;
> +	__le16 comp_index;
> +	u8     max_regions;
> +	u8     num_regions;
> +	u8     bmp_type;
> +	u8     rsvd2;
> +	__le32 bmp_type_mask;
> +	u8     rsvd3[3];
> +	u8     color;
> +};
> +
> +/**
> + * struct pds_lm_dirty_enable_cmd - DIRTY_ENABLE command
> + * @opcode:		Opcode PDS_LM_CMD_DIRTY_ENABLE
> + * @rsvd:		Word boundary padding
> + * @vf_id:		VF id
> + * @bmp_type:		Type of dirty bitmap representation
> + * @num_regions:	Number of entries in the region info buffer
> + * @rsvd2:		Word boundary padding
> + * @regions_dma:	DMA address of the region info buffer
> + *
> + * The num_regions must be nonzero, and less than or equal to the
> maximum
> + * number of regions supported by the device.
> + *
> + * The memory regions should not overlap.
> + *
> + * The information should be initialized by the driver.  The device may
> modify
> + * the information on successful completion, such as by size-aligning the
> + * number of pages in a region.
> + *
> + * The modified number of pages will be greater than or equal to the page
> count
> + * given in the enable command, and at least as coarsly aligned as the given
> + * value.  For example, the count might be aligned to a multiple of 64, but
> + * if the value is already a multiple of 128 or higher, it will not change.
> + * If the driver requires its own minimum alignment of the number of pages,
> the
> + * driver should account for that already in the region info of this command.
> + *
> + * This command uses struct pds_lm_dirty_status_comp for its completion.
> + */
> +struct pds_lm_dirty_enable_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	u8     bmp_type;
> +	u8     num_regions;
> +	u8     rsvd2[2];
> +	__le64 regions_dma;
> +} __packed;
> +
> +/**
> + * struct pds_lm_dirty_disable_cmd - DIRTY_DISABLE command
> + * @opcode:	Opcode PDS_LM_CMD_DIRTY_DISABLE
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + *
> + * Dirty page tracking will be disabled.  This may be called in any state, as
> + * long as dirty page tracking is supported by the device, to ensure that dirty
> + * page tracking is disabled.
> + *
> + * This command uses struct pds_lm_dirty_status_comp for its completion.
> On
> + * success, num_regions will be zero.
> + */
> +struct pds_lm_dirty_disable_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +};
> +
> +/**
> + * struct pds_lm_dirty_seq_ack_cmd - DIRTY_READ_SEQ or _WRITE_ACK
> command
> + * @opcode:	Opcode PDS_LM_CMD_DIRTY_[READ_SEQ|WRITE_ACK]
> + * @rsvd:	Word boundary padding
> + * @vf_id:	VF id
> + * @off_bytes:	Byte offset in the bitmap
> + * @len_bytes:	Number of bytes to transfer
> + * @num_sge:	Number of DMA scatter gather elements
> + * @rsvd2:	Word boundary padding
> + * @sgl_addr:	DMA address of scatter gather list
> + *
> + * Read bytes from the SEQ bitmap, or write bytes into the ACK bitmap.
> + *
> + * This command treats the entire bitmap as a byte buffer.  It does not
> + * distinguish between guest memory regions.  The driver should refer to
> the
> + * number of pages in each region, according to
> PDS_LM_CMD_DIRTY_STATUS, to
> + * determine the region boundaries in the bitmap.  Each region will be
> + * represented by exactly the number of bits as the page count for that
> region,
> + * immediately following the last bit of the previous region.
> + */
> +struct pds_lm_dirty_seq_ack_cmd {
> +	u8     opcode;
> +	u8     rsvd;
> +	__le16 vf_id;
> +	__le32 off_bytes;
> +	__le32 len_bytes;
> +	__le16 num_sge;
> +	u8     rsvd2[2];
> +	__le64 sgl_addr;
> +} __packed;
> +
>  /**
>   * struct pds_lm_host_vf_status_cmd - HOST_VF_STATUS command
>   * @opcode:	Opcode PDS_LM_CMD_HOST_VF_STATUS
> @@ -1039,6 +1212,10 @@ union pds_core_adminq_cmd {
>  	struct pds_lm_save_cmd		  lm_save;
>  	struct pds_lm_restore_cmd	  lm_restore;
>  	struct pds_lm_host_vf_status_cmd  lm_host_vf_status;
> +	struct pds_lm_dirty_status_cmd	  lm_dirty_status;
> +	struct pds_lm_dirty_enable_cmd	  lm_dirty_enable;
> +	struct pds_lm_dirty_disable_cmd	  lm_dirty_disable;
> +	struct pds_lm_dirty_seq_ack_cmd	  lm_dirty_seq_ack;
>  };
> 
>  union pds_core_adminq_comp {
> @@ -1065,6 +1242,7 @@ union pds_core_adminq_comp {
>  	struct pds_vdpa_vq_reset_comp	  vdpa_vq_reset;
> 
>  	struct pds_lm_state_size_comp	  lm_state_size;
> +	struct pds_lm_dirty_status_comp	  lm_dirty_status;
>  };
> 
>  #ifndef __CHECKER__
> --
> 2.17.1

