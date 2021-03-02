Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D36332B56D
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbhCCHPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:15:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8980 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349743AbhCBRYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 12:24:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e72d50001>; Tue, 02 Mar 2021 09:16:05 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 17:16:04 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 17:15:55 +0000
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Mar 2021 17:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UisxayQgSA4FpKnGtW+fwOD1zHuG9pxno1f8UvK3TayBvQfA/B3qHNSK1k2bGzM+8+WQhfB5Enk/sw70aqR7+UXXqUbrWpkTlTc7C+CXag1ttev4/9kaG9KuxGRkVyWG/tSCrOH7nRuBAsLOHpSw0xad5qSF84BXzV/VQfm/YHRxb3mUVTACPdqxNytTsHpuF9MBeWj8PgMQWOD1K6XwelAvp7Zm0zqw85FVehCcDmdlH9ouInRMtjfX872vL2emqH+0eKf3qVRvT9sWstyQ1hXla2DsbegJlheBuTz5ZN7ppSdlmi9XVkih0ydn+E/zIJNtpufAsq7NM8hUuUnjMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oQlEGY42G/OLU9PJunjf7j8qctAJH22IeNnf2g4K0A=;
 b=H9sehWf05Sf5GZVlBTRSY/Tq7Wyxbj+Lkl92ZvFvPE2rOWtdutBAJvOttbaUaUNcN1rEhJoeLbziwmQC5no6tGf836ZMlln0bX90NaL8mCyPO5h8rKE1q6sZtrwXdb4OhLVZAUkk9gNZMkaxI6igcY/vYtyFMFCvn76Q5ws+vWyx24VkjNvWfnn5sXSlsHHwZhhDaAF4iKSmeVFiQppWZAGoefW5msGACqo+LT3jmsmUQm12kFA21KtGsFeTMkodPGn2noskQcllHb0Ni3o27Dlp7jALLXF3OJUzMfxxqn12PLOwyk90eDLHbpe6tEkN1f5vyqocqDe/G3AjVuoq7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 2 Mar
 2021 17:15:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Tue, 2 Mar 2021
 17:15:52 +0000
Date:   Tue, 2 Mar 2021 13:15:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     Liu Yi L <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
        <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>,
        <joro@8bytes.org>, <kevin.tian@intel.com>, <ashok.raj@intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>,
        <jean-philippe@linaro.org>, <peterx@redhat.com>,
        <jasowang@redhat.com>, <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <Lingshan.Zhu@intel.com>, <vivek.gautam@arm.com>
Subject: Re: [Patch v8 04/10] vfio/type1: Support binding guest page tables
 to PASID
Message-ID: <20210302171551.GK4247@nvidia.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
 <20210302203545.436623-5-yi.l.liu@intel.com>
 <20210302125628.GI4247@nvidia.com> <20210302091319.1446a47b@jacob-builder>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210302091319.1446a47b@jacob-builder>
X-ClientProxiedBy: MN2PR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:208:178::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0021.namprd19.prod.outlook.com (2603:10b6:208:178::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 2 Mar 2021 17:15:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lH8ch-004GgH-1X; Tue, 02 Mar 2021 13:15:51 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614705365; bh=3oQlEGY42G/OLU9PJunjf7j8qctAJH22IeNnf2g4K0A=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=fZ3amAQSGUUdVYItRVwWYaLI1JP4P62+SmtzHY5gHB4qez+BySeNe+yYRvYVUge1/
         7op6B7HL6ypWZsrxjF+juTNXMUfbDRfH25iehP+bf97T4PmsoaJEBIK+Z8j+G94NFu
         ChMBKeqM3A/I1fI4EQoraiubzH3yHH5mNulT9Kua35O9oXpf5aHLqrErqVwoOECqMR
         qW+vVaTzxnxawQmZ9I+V0PVFFfXpM/bn+5jGMbH500WaqytBfwF6Nt0XcrR7oBCPj6
         LW7ZHBmkrdRmVfqbX4uO5vHKF7Sh63iLiZ21kq7fN8B0tVl+K2B/Ynf7T+3VSQzSM4
         diPkj+o9/5/Jw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 09:13:19AM -0800, Jacob Pan wrote:
> Hi Jason,
> 
> On Tue, 2 Mar 2021 08:56:28 -0400, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Mar 03, 2021 at 04:35:39AM +0800, Liu Yi L wrote:
> > >  
> > > +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
> > > +{
> > > +	struct domain_capsule *dc = (struct domain_capsule *)data;
> > > +	unsigned long arg = *(unsigned long *)dc->data;
> > > +
> > > +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> > > +					  (void __user *)arg);  
> > 
> > This arg buisness is really tortured. The type should be set at the
> > ioctl, not constantly passed down as unsigned long or worse void *.
> > 
> > And why is this passing a __user pointer deep into an iommu_* API??
> > 
> The idea was that IOMMU UAPI (not API) is independent of VFIO or other user
> driver frameworks. The design is documented here:
> Documentation/userspace-api/iommu.rst
> IOMMU UAPI handles the type and sanitation of user provided data.

Why? If it is uapi it has defined types and those types should be
completely clear from the C code, not obfuscated.

I haven't looked at the design doc yet, but this is a just a big red
flag, you shouldn't be tunneling one subsytems uAPI through another
subsystem.

If you need to hook two subsystems together it should be more
directly, like VFIO takes in the IOMMU FD and 'registers' itself in
some way with the IOMMU then you can do the IOMMU actions through the
IOMMU FD and it can call back to VFIO as needed.

At least in this way we can swap VFIO for other things in the API.

Having every subsystem that wants to implement IOMMU also implement
tunneled ops seems very backwards.

> Could you be more specific about your concerns?

Avoid using unsigned long, void * and flex arrays to describe
concretely typed things.

Jason
