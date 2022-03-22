Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF34E4901
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 23:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbiCVWR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 18:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237625AbiCVWRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 18:17:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACD9C54BEA
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647987348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Plq65sjLL0seJ7WvmjtQdv4sWgADshYNALH0Py3ngKI=;
        b=iMXaiUen2xwE73JvBxpJgEZDin78wKILHzSWCz5yQ6I6KpPIgKJcjM6/Pj0+k34hHBj3yL
        B89qifx6cdE45/0jJc53HxdIu+apjS1wNX7GhQ5AnVm74FPth3WnHmsSJ63MruScrO/ZtM
        PYlRAZ+b5VkO2iWRdQuSE6JWdCdHukg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-ZdFqIx5hMbiNjLscG08mgA-1; Tue, 22 Mar 2022 18:15:47 -0400
X-MC-Unique: ZdFqIx5hMbiNjLscG08mgA-1
Received: by mail-io1-f71.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so10394451ioo.0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 15:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Plq65sjLL0seJ7WvmjtQdv4sWgADshYNALH0Py3ngKI=;
        b=ESFIrNXZoj42k3502qs0bKrFUqFKIdJKkEaDzfJ+simtt7g9jOIo8jc/ZIUWBOG5TW
         Z8qgh9dGp/8+QpkVYAbR8P9ShYhF+3eTfhNHWPLkR5Q3gjm57ohx1TOSMKBJuAxrXJy6
         ywTH+wPNDjuG77USenbzNcKeWj2wgN40S4lb2bkm0wS3yKLPpWTY/jTJ6kpWduObrMAt
         36QCj4MHpnHKdh6O7ZA3aryz2k4TS+vcPVEm3yZqfkVwGh5okCX9hjXl9fOIGv3neNfM
         4FOsyrISKBXiQU2P/HHxjuLf9za4oXOnThReNTl5uxAht3mZYWtulDJRzur8Kv/0jy6m
         tnWA==
X-Gm-Message-State: AOAM531Y4iIu1x7LLxdCzMIJC0lX4zCVfURa5fLg6LPL1G2ANAv1Y4gi
        Efpl7G3wZ3D7CEWvzpnZR7DOYTnE1xbt0Io4DQ3kYtCM3HsmoCLrOYMBbnI/t9OoyyNYBWk000s
        KDxaKoBtIFz3c
X-Received: by 2002:a6b:6902:0:b0:649:d744:e0da with SMTP id e2-20020a6b6902000000b00649d744e0damr992073ioc.211.1647987346869;
        Tue, 22 Mar 2022 15:15:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxjk0g8Sn80FYrVpeaQccm0Nksq/bB6kFNnm5nbL6fD3Uhbg9fTikYRNK1AIqrXjXzanDEWg==
X-Received: by 2002:a6b:6902:0:b0:649:d744:e0da with SMTP id e2-20020a6b6902000000b00649d744e0damr992055ioc.211.1647987346557;
        Tue, 22 Mar 2022 15:15:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s13-20020a6bdc0d000000b006408888551dsm10103375ioc.8.2022.03.22.15.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 15:15:46 -0700 (PDT)
Date:   Tue, 22 Mar 2022 16:15:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to
 PFN mapping
Message-ID: <20220322161544.54fd459d.alex.williamson@redhat.com>
In-Reply-To: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 14:27:32 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> +/*
> + * The area takes a slice of the pages from start_bytes to start_byte + length
> + */
> +static struct iopt_area *
> +iopt_alloc_area(struct io_pagetable *iopt, struct iopt_pages *pages,
> +		unsigned long iova, unsigned long start_byte,
> +		unsigned long length, int iommu_prot, unsigned int flags)
> +{
> +	struct iopt_area *area;
> +	int rc;
> +
> +	area = kzalloc(sizeof(*area), GFP_KERNEL);
> +	if (!area)
> +		return ERR_PTR(-ENOMEM);
> +
> +	area->iopt = iopt;
> +	area->iommu_prot = iommu_prot;
> +	area->page_offset = start_byte % PAGE_SIZE;
> +	area->pages_node.start = start_byte / PAGE_SIZE;
> +	if (check_add_overflow(start_byte, length - 1, &area->pages_node.last))
> +		return ERR_PTR(-EOVERFLOW);
> +	area->pages_node.last = area->pages_node.last / PAGE_SIZE;
> +	if (WARN_ON(area->pages_node.last >= pages->npages))
> +		return ERR_PTR(-EOVERFLOW);

@area leaked in the above two error cases.

> +
> +	down_write(&iopt->iova_rwsem);
> +	if (flags & IOPT_ALLOC_IOVA) {
> +		rc = iopt_alloc_iova(iopt, &iova,
> +				     (uintptr_t)pages->uptr + start_byte,
> +				     length);
> +		if (rc)
> +			goto out_unlock;
> +	}
> +
> +	if (check_add_overflow(iova, length - 1, &area->node.last)) {
> +		rc = -EOVERFLOW;
> +		goto out_unlock;
> +	}
> +
> +	if (!(flags & IOPT_ALLOC_IOVA)) {
> +		if ((iova & (iopt->iova_alignment - 1)) ||
> +		    (length & (iopt->iova_alignment - 1)) || !length) {
> +			rc = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		/* No reserved IOVA intersects the range */
> +		if (interval_tree_iter_first(&iopt->reserved_iova_itree, iova,
> +					     area->node.last)) {
> +			rc = -ENOENT;
> +			goto out_unlock;
> +		}
> +
> +		/* Check that there is not already a mapping in the range */
> +		if (iopt_area_iter_first(iopt, iova, area->node.last)) {
> +			rc = -EADDRINUSE;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * The area is inserted with a NULL pages indicating it is not fully
> +	 * initialized yet.
> +	 */
> +	area->node.start = iova;
> +	interval_tree_insert(&area->node, &area->iopt->area_itree);
> +	up_write(&iopt->iova_rwsem);
> +	return area;
> +
> +out_unlock:
> +	up_write(&iopt->iova_rwsem);
> +	kfree(area);
> +	return ERR_PTR(rc);
> +}
...
> +/**
> + * iopt_access_pages() - Return a list of pages under the iova
> + * @iopt: io_pagetable to act on
> + * @iova: Starting IOVA
> + * @length: Number of bytes to access
> + * @out_pages: Output page list
> + * @write: True if access is for writing
> + *
> + * Reads @npages starting at iova and returns the struct page * pointers. These
> + * can be kmap'd by the caller for CPU access.
> + *
> + * The caller must perform iopt_unaccess_pages() when done to balance this.
> + *
> + * iova can be unaligned from PAGE_SIZE. The first returned byte starts at
> + * page_to_phys(out_pages[0]) + (iova % PAGE_SIZE). The caller promises not to
> + * touch memory outside the requested iova slice.
> + *
> + * FIXME: callers that need a DMA mapping via a sgl should create another
> + * interface to build the SGL efficiently
> + */
> +int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
> +		      unsigned long length, struct page **out_pages, bool write)
> +{
> +	unsigned long cur_iova = iova;
> +	unsigned long last_iova;
> +	struct iopt_area *area;
> +	int rc;
> +
> +	if (!length)
> +		return -EINVAL;
> +	if (check_add_overflow(iova, length - 1, &last_iova))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->iova_rwsem);
> +	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
> +	     area = iopt_area_iter_next(area, iova, last_iova)) {
> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> +		unsigned long last_index;
> +		unsigned long index;
> +
> +		/* Need contiguous areas in the access */
> +		if (iopt_area_iova(area) < cur_iova || !area->pages) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Should this be (cur_iova != iova && iopt_area_iova(area) < cur_iova)?

I can't see how we'd require in-kernel page users to know the iopt_area
alignment from userspace, so I think this needs to skip the first
iteration.  Thanks,

Alex

> +			rc = -EINVAL;
> +			goto out_remove;
> +		}
> +
> +		index = iopt_area_iova_to_index(area, cur_iova);
> +		last_index = iopt_area_iova_to_index(area, last);
> +		rc = iopt_pages_add_user(area->pages, index, last_index,
> +					 out_pages, write);
> +		if (rc)
> +			goto out_remove;
> +		if (last == last_iova)
> +			break;
> +		/*
> +		 * Can't cross areas that are not aligned to the system page
> +		 * size with this API.
> +		 */
> +		if (cur_iova % PAGE_SIZE) {
> +			rc = -EINVAL;
> +			goto out_remove;
> +		}
> +		cur_iova = last + 1;
> +		out_pages += last_index - index;
> +		atomic_inc(&area->num_users);
> +	}
> +
> +	up_read(&iopt->iova_rwsem);
> +	return 0;
> +
> +out_remove:
> +	if (cur_iova != iova)
> +		iopt_unaccess_pages(iopt, iova, cur_iova - iova);
> +	up_read(&iopt->iova_rwsem);
> +	return rc;
> +}

