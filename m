Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D91219080
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgGHTaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:30:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726215AbgGHTaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UJjkq/41DYBOCSHo3nTf+zUI4aMZSKM39jLWG6kR/zY=;
        b=Gas97tBRq2VmgRA9lWCmxibWy+rA2YBpeE1hBU2Eq6EoySIJrk37REDecRPoVLTzaA/skZ
        gJICwsJenHdJlUizC6WXjBya25XDplXEWC0L7n4Wm1Bkgq6NdA90oN/rv4BqS33nc1p+u2
        xjCK+7olvWmRTQ9nr1U+MLm0MN39fSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-fQ7c72TkN5irDaNSzxo8Vw-1; Wed, 08 Jul 2020 15:29:57 -0400
X-MC-Unique: fQ7c72TkN5irDaNSzxo8Vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 165AF107ACF3;
        Wed,  8 Jul 2020 19:29:55 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 686162DE60;
        Wed,  8 Jul 2020 19:29:48 +0000 (UTC)
Date:   Wed, 8 Jul 2020 13:29:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 04/15] vfio/type1: Report iommu nesting info to
 userspace
Message-ID: <20200708132947.5b7ee954@x1.home>
In-Reply-To: <DM5PR11MB143531E2B54ED82FB0649F8CC3670@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
        <1593861989-35920-5-git-send-email-yi.l.liu@intel.com>
        <d434cbcc-d3b1-d11d-0304-df2d2c93efa0@redhat.com>
        <DM5PR11MB1435290B6CD561EC61027892C3690@DM5PR11MB1435.namprd11.prod.outlook.com>
        <94b4e5d3-8d24-9a55-6bee-ed86f3846996@redhat.com>
        <DM5PR11MB14357A5953EB630A58FF568EC3660@DM5PR11MB1435.namprd11.prod.outlook.com>
        <DM5PR11MB143531E2B54ED82FB0649F8CC3670@DM5PR11MB1435.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jul 2020 08:08:40 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> Eric asked if we will to have data strcut other than struct iommu_nesting_info
> type in the struct vfio_iommu_type1_info_cap_nesting @info[] field. I'm not
> quit sure on it. I guess the answer may be not as VFIO's nesting support should
> based on IOMMU UAPI. how about your opinion?
> 
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
> +
> +/*
> + * Reporting nesting info to user space.
> + *
> + * @info:	the nesting info provided by IOMMU driver. Today
> + *		it is expected to be a struct iommu_nesting_info
> + *		data.
> + */
> +struct vfio_iommu_type1_info_cap_nesting {
> +	struct	vfio_info_cap_header header;
> +	__u32	flags;
> +	__u32	padding;
> +	__u8	info[];
> +};

It's not a very useful uAPI if the user can't be sure what they're
getting out of it.  Info capabilities are "cheap", they don't need to
be as extensible as an ioctl.  It's not clear that we really even need
the flags (and therefore the padding), just define it to return the
IOMMU uAPI structure with no extensibility.  If we need to expose
something else, create a new capability.  Thanks,

Alex

> 
> https://lore.kernel.org/linux-iommu/DM5PR11MB1435290B6CD561EC61027892C3690@DM5PR11MB1435.namprd11.prod.outlook.com/
> 
> Regards,
> Yi Liu
> 
> > From: Liu, Yi L
> > Sent: Tuesday, July 7, 2020 5:32 PM
> >   
> [...]
> > > >  
> > > >>> +
> > > >>> +/*
> > > >>> + * Reporting nesting info to user space.
> > > >>> + *
> > > >>> + * @info:	the nesting info provided by IOMMU driver. Today
> > > >>> + *		it is expected to be a struct iommu_nesting_info
> > > >>> + *		data.  
> > > >> Is it expected to change?  
> > > >
> > > > honestly, I'm not quite sure on it. I did considered to embed struct
> > > > iommu_nesting_info here instead of using info[]. but I hesitated as
> > > > using info[] may leave more flexibility on this struct. how about
> > > > your opinion? perhaps it's fine to embed the struct
> > > > iommu_nesting_info here as long as VFIO is setup nesting based on
> > > > IOMMU UAPI.
> > > >  
> > > >>> + */
> > > >>> +struct vfio_iommu_type1_info_cap_nesting {
> > > >>> +	struct	vfio_info_cap_header header;
> > > >>> +	__u32	flags;  
> > > >> You may document flags.  
> > > >
> > > > sure. it's reserved for future.
> > > >
> > > > Regards,
> > > > Yi Liu
> > > >  
> > > >>> +	__u32	padding;
> > > >>> +	__u8	info[];
> > > >>> +};
> > > >>> +
> > > >>>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> > > >>>
> > > >>>  /**
> > > >>>  
> > > >> Thanks
> > > >>
> > > >> Eric  
> > > >  
> 

