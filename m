Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B83F6ED1
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhHYFbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 01:31:01 -0400
Received: from verein.lst.de ([213.95.11.211]:54747 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhHYFbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 01:31:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C5B196736F; Wed, 25 Aug 2021 07:30:13 +0200 (CEST)
Date:   Wed, 25 Aug 2021 07:30:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc
 helper
Message-ID: <20210825053013.GA26806@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-5-hch@lst.de> <20210824234050.GK543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824234050.GK543798@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 08:40:50PM -0300, Jason Gunthorpe wrote:
> I think the non-"success oriented flow" is less readable than what was
> before. It is jarring to see, and I was about to say this is not
> logically the same having missed the !...
> 
> How about:
> 
>         /* If found group already holds the iommu_group reference */
> 	group = vfio_group_get_from_iommu(iommu_group);
> 	if (group)
>             goto out_put;
> 
> 	group = vfio_create_group(iommu_group);
> 	if (IS_ERR(group))
> 	     goto out_put;
>         /* If created our iommu_group reference was moved to group, keep it */
> 	return group;
> 
> out_put:
> 	vfio_iommu_group_put(iommu_group, dev);
> 	return group;

Fine with me.  I actually repeatedly switched between the two flows
because I couldn't decide on one.
