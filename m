Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB420EF5
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 20:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEPSyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 14:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfEPSyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 14:54:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CDB3E308FBB4;
        Thu, 16 May 2019 18:54:35 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F293A5D985;
        Thu, 16 May 2019 18:54:34 +0000 (UTC)
Date:   Thu, 16 May 2019 12:54:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 2/4] vfio: vfio_iommu_type1: Define
 VFIO_IOMMU_INFO_CAPABILITIES
Message-ID: <20190516125434.7dbc4b3c@x1.home>
In-Reply-To: <f396492c-5815-7fd2-0e78-7681e6380591@de.ibm.com>
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
        <1557476555-20256-3-git-send-email-pmorel@linux.ibm.com>
        <f396492c-5815-7fd2-0e78-7681e6380591@de.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 16 May 2019 18:54:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 16:57:42 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Alex, 
> 
> patch 1 and 3 are s390 specific, 2 and 4 are vfio common code.
> Are you ok with the common code changes? If yes, would you prefer to have this
> via the s390 tree (Martin) or your tree?

Hi Christian,

The vfio code still needs work imo, and I'm not sure it isn't somewhat
abusive of the iommu attribute interface as well.  I don't necessarily
have a problem with it ultimately going through the s390 tree, but
let's see what comes in the next revision.  Thanks,

Alex

> On 10.05.19 10:22, Pierre Morel wrote:
> > To use the VFIO_IOMMU_GET_INFO to retrieve IOMMU specific information,
> > we define a new flag VFIO_IOMMU_INFO_CAPABILITIES in the
> > vfio_iommu_type1_info structure and the associated capability
> > information block.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  include/uapi/linux/vfio.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 8f10748..8f68e0f 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -715,6 +715,16 @@ struct vfio_iommu_type1_info {
> >  	__u32	flags;
> >  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
> >  	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
> > +#define VFIO_IOMMU_INFO_CAPABILITIES (1 << 1)  /* support capabilities info */
> > +	__u64   cap_offset;     /* Offset within info struct of first cap */
> > +};
> > +
> > +#define VFIO_IOMMU_INFO_CAP_QFN		1
> > +#define VFIO_IOMMU_INFO_CAP_QGRP	2
> > +
> > +struct vfio_iommu_type1_info_block {
> > +	struct vfio_info_cap_header header;
> > +	__u32 data[];
> >  };
> >  
> >  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> >   
> 

