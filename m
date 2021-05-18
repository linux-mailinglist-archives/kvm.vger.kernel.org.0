Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1D238801B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351732AbhERTAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243382AbhERTAW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3I+sRgsUz3jPt3eJWkIzspXHxTfKP9apTdFMbo1EQ4=;
        b=D3T/kdOBui1Go/AjQlLpFBKCXcVgG1jqnBDZb5hHX93JslcNCKLrE5glcZ7OZo5o2NAahM
        cf4h56GDHFdr8ELQ7fiooSyQTG4FSL8GCJSX+/CzIheLvxGPFP83jhBNxIRT+69S94O74v
        FWzoCB/k5aNztUGo3Dehjc5XgogVWrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98--oKuxaE4Nhqt5xTqP29FOg-1; Tue, 18 May 2021 14:59:01 -0400
X-MC-Unique: -oKuxaE4Nhqt5xTqP29FOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09369192AB81;
        Tue, 18 May 2021 18:58:59 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20D581037E81;
        Tue, 18 May 2021 18:58:58 +0000 (UTC)
Date:   Tue, 18 May 2021 12:58:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 2/8] vfio/type1: Add a page fault handler
Message-ID: <20210518125837.6de73631.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-3-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210409034420.1799-3-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:14 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> VFIO manages the DMA mapping itself. To support IOPF (on-demand paging)
> for VFIO (IOMMU capable) devices, we add a VFIO page fault handler to
> serve the reported page faults from the IOMMU driver.
>=20
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 114 ++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 45cbfd4879a5..ab0ff60ee207 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -101,6 +101,7 @@ struct vfio_dma {
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> +	unsigned long		*iopf_mapped_bitmap;
>  };
> =20
>  struct vfio_batch {
> @@ -141,6 +142,16 @@ struct vfio_regions {
>  	size_t len;
>  };
> =20
> +/* A global IOPF enabled group list */
> +static struct rb_root iopf_group_list =3D RB_ROOT;
> +static DEFINE_MUTEX(iopf_group_list_lock);
> +
> +struct vfio_iopf_group {
> +	struct rb_node		node;
> +	struct iommu_group	*iommu_group;
> +	struct vfio_iommu	*iommu;
> +};
> +
>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>  					(!list_empty(&iommu->domain_list))
> =20
> @@ -157,6 +168,10 @@ struct vfio_regions {
>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> =20
> +#define IOPF_MAPPED_BITMAP_GET(dma, i)	\
> +			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
> +			       >> ((i) % BITS_PER_LONG)) & 0x1)


Can't we just use test_bit()?


> +
>  #define WAITED 1
> =20
>  static int put_pfn(unsigned long pfn, int prot);
> @@ -416,6 +431,34 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *d=
ma, struct vfio_pfn *vpfn)
>  	return ret;
>  }
> =20
> +/*
> + * Helper functions for iopf_group_list
> + */
> +static struct vfio_iopf_group *
> +vfio_find_iopf_group(struct iommu_group *iommu_group)
> +{
> +	struct vfio_iopf_group *iopf_group;
> +	struct rb_node *node;
> +
> +	mutex_lock(&iopf_group_list_lock);
> +
> +	node =3D iopf_group_list.rb_node;
> +
> +	while (node) {
> +		iopf_group =3D rb_entry(node, struct vfio_iopf_group, node);
> +
> +		if (iommu_group < iopf_group->iommu_group)
> +			node =3D node->rb_left;
> +		else if (iommu_group > iopf_group->iommu_group)
> +			node =3D node->rb_right;
> +		else
> +			break;
> +	}
> +
> +	mutex_unlock(&iopf_group_list_lock);
> +	return node ? iopf_group : NULL;
> +}

This looks like a pretty heavy weight operation per DMA fault.

I'm also suspicious of this validity of this iopf_group after we've
dropped the locking, the ordering of patches makes this very confusing.

> +
>  static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>  {
>  	struct mm_struct *mm;
> @@ -3106,6 +3149,77 @@ static int vfio_iommu_type1_dirty_pages(struct vfi=
o_iommu *iommu,
>  	return -EINVAL;
>  }
> =20
> +/* VFIO I/O Page Fault handler */
> +static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void=
 *data)

=46rom the comment, this seems like the IOMMU fault handler (the
construction of this series makes this difficult to follow) and
eventually it handles more than DMA mapping, for example transferring
faults to the device driver.  "dma_map_iopf" seems like a poorly scoped
name.

> +{
> +	struct device *dev =3D (struct device *)data;
> +	struct iommu_group *iommu_group;
> +	struct vfio_iopf_group *iopf_group;
> +	struct vfio_iommu *iommu;
> +	struct vfio_dma *dma;
> +	dma_addr_t iova =3D ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
> +	int access_flags =3D 0;
> +	unsigned long bit_offset, vaddr, pfn;
> +	int ret;
> +	enum iommu_page_response_code status =3D IOMMU_PAGE_RESP_INVALID;
> +	struct iommu_page_response resp =3D {0};
> +
> +	if (fault->type !=3D IOMMU_FAULT_PAGE_REQ)
> +		return -EOPNOTSUPP;
> +
> +	iommu_group =3D iommu_group_get(dev);
> +	if (!iommu_group)
> +		return -ENODEV;
> +
> +	iopf_group =3D vfio_find_iopf_group(iommu_group);
> +	iommu_group_put(iommu_group);
> +	if (!iopf_group)
> +		return -ENODEV;
> +
> +	iommu =3D iopf_group->iommu;
> +
> +	mutex_lock(&iommu->lock);

Again, I'm dubious of our ability to grab this lock from an object with
an unknown lifecycle and races we might have with that group being
detached or DMA unmapped.  Also, how effective is enabling IOMMU page
faulting if we're serializing all faults within a container context?

> +
> +	ret =3D vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
> +	if (ret < 0)
> +		goto out_invalid;
> +
> +	if (fault->prm.perm & IOMMU_FAULT_PERM_READ)
> +		access_flags |=3D IOMMU_READ;
> +	if (fault->prm.perm & IOMMU_FAULT_PERM_WRITE)
> +		access_flags |=3D IOMMU_WRITE;
> +	if ((dma->prot & access_flags) !=3D access_flags)
> +		goto out_invalid;
> +
> +	bit_offset =3D (iova - dma->iova) >> PAGE_SHIFT;
> +	if (IOPF_MAPPED_BITMAP_GET(dma, bit_offset))
> +		goto out_success;

If the page is mapped, why did we get a fault?  Should we be returning
success for a fault we shouldn't have received and did nothing to
resolve?  We're also referencing a bitmap that has only been declared
and never allocated at this point in the patch series.

> +
> +	vaddr =3D iova - dma->iova + dma->vaddr;
> +
> +	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
> +		goto out_invalid;
> +
> +	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
> +		if (put_pfn(pfn, dma->prot))
> +			vfio_lock_acct(dma, -1, true);
> +		goto out_invalid;
> +	}
> +
> +	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
> +
> +out_success:
> +	status =3D IOMMU_PAGE_RESP_SUCCESS;
> +
> +out_invalid:
> +	mutex_unlock(&iommu->lock);
> +	resp.version		=3D IOMMU_PAGE_RESP_VERSION_1;
> +	resp.grpid		=3D fault->prm.grpid;
> +	resp.code		=3D status;
> +	iommu_page_response(dev, &resp);
> +	return 0;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {

