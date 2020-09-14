Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983A72691AE
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgINQeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:34:16 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2237 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgINQeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 12:34:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5f9aec0000>; Mon, 14 Sep 2020 09:31:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 09:34:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 14 Sep 2020 09:34:00 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 16:33:57 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 16:33:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNfmd4ZRcJhtQajjjlZbE6+ZHvuSS+c0be//Ke0xxPDdyHHMSEZfU9tk4NtFOT5sTbe+ZdGgz3o3fN+2gIDLs1jjWMFQVIQBUaO9s6przY9IOVe1ndsuychqmHOX9Zytwb1CbgLwtel/lb62XxaNy00KhLOcorD+ajOHgYQyCSVbq79HoJof9/1RkvNOk5tFZKTPlmYDlXCb/eLIlNjYZvpzB0g+OlZeFd8Q8byIXx7IJfHRviMHC9odF5vPTH/8l+royB/65XA1UUcy+LTtnB0vz3WHH3z4ePD0q7sb1bEAsDLuOnzDdv8m1N3/gDpR/U6r3Yv1e2Eqt5df2Ibctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxT0JhxX2EfaG7S0KLgbJ3a9RTwYWT6f5EGhpsvO4M0=;
 b=gE4XfNEhzW7D3tA4hsBFb3b9DiKmLcw2hDnQH1HVSzgchMI3qI8f4TL/3GbJ+sMRDRaoo/Kafp2j5SxXpcP7L+vJYl0JQhKAWvPboJQbVh9xxl/bNHAyehdHNi/Au5DIxbF4kE4MJULTZmsswl3AsRQ71bDWQtM2LP4kY6eo9Ro0t60tMJun7/bVJ8Tux3DV9/iJYy6de9lTWeZ1uXFu32Pny2NqTlZ0LBpFfbl3X79u4EhWoy8JP2Wdvsdwk/tvE2THpPPtqndopZxqRwNxXNOGfUEPMFLkMQAmo2xPzwKdyuw8kPW47h7pR1gle8bzS2i5KIPTJjwVoWzToFSDcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3929.namprd12.prod.outlook.com (2603:10b6:5:148::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 16:33:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:33:56 +0000
Date:   Mon, 14 Sep 2020 13:33:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
        <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>,
        <joro@8bytes.org>, <kevin.tian@intel.com>,
        <jacob.jun.pan@linux.intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914163354.GG904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica> <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200914162247.GA63399@otc-nc-03>
X-ClientProxiedBy: CH2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:610:4f::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR18CA0024.namprd18.prod.outlook.com (2603:10b6:610:4f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:33:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kHrQQ-006ATd-Ck; Mon, 14 Sep 2020 13:33:54 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1615a421-9e75-4087-3d86-08d858cbf932
X-MS-TrafficTypeDiagnostic: DM6PR12MB3929:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3929673BE18DCF6E58FE48B8C2230@DM6PR12MB3929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTwimc9wl/T82fV936SYM/bKZcS0yyPmKMAT6CaRYPPSgmunn8AG5ALBEBEItOSmPFXyfhWTajEZ1MBEEfHFM2PVhVYU7sZH/16+sazPtkoLqRRrAke9z4xITyI+GtRLcCKzZ7qxmUHAL7v7eJqr94hJTLzyPz8gkZpGVlA8hBnug41ZpO9BQLAYax8N3yGlb/gBUhOXp/+iqprgNiY9EyzEvsBeRMpsYdGZ3sgMBtXauT17t77+6Ntn0Z5WnxE0Fi17uzsH1UPUZpCaP4ptLUQuqwndaWEgvMzvu/wJhQY3e0qBiHkYLnRnNVV0dj5zcN+0wCqzhWK5WHznVnGMb4jR66uzgp+7OKKDOAxE86YLfdcPKixVUTCvjHYZKhgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(66476007)(66556008)(26005)(5660300002)(316002)(186003)(83380400001)(8676002)(478600001)(9746002)(8936002)(426003)(9786002)(33656002)(6916009)(86362001)(2906002)(4326008)(7416002)(54906003)(2616005)(36756003)(1076003)(66946007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: USEMpZXahXJ7fjjxZnqVdX7tSoitVrud9ceDcWtRfgCTgq3VB2yDtiF/LnchnLvszGleD0Wh+g2/blptsMSgLMiGU9dTOuWH/9v02uw8t43bfa4eZyAVhB0/gLW9Lrzt66KSH6Itk0tVuL+cm4eUAeiBYu3ACCTSFzDdggvmK5tIA8znvrq3Dwv4KAltpHRKJS/tcSJFhgwCDQElMoO/B4h8CYGd0sG2X/oevPUX4ieoqxJ6S1nohRW/pZ7qzA23vGolm9EuyncQy80OiQhfboms9FpkOy56WnSjh1lKCJwICFUNIZGSAsMf8a2YiUYOQLO+Gzzgrvx9LU7X9WYULyd8fQx3nl7PBUIiNhafpdFCiqaQaCC+TZVuNQmO+AGzBoeKZb7nUjX5juxlhyFFxwV6F6cwjGYEduLVbvq1WhYY8RjQouugElOzTMzNmHTyUKUr3IHN7kZKFIv0NL6cfEgep9lXpQUwuQUJBmV9FkjUQFIeiYTZvMxDG+d1F8Z6V3RJmhL43EzQ2DrtT47gKxfrmBdwphl5Nrkr9nAyZyYJqo4g8QauKcfbt9AnknpXmRfy6J3qvrAy9ZD/pICrVF7BzJKC9JRO8XjTtXr+spRLyDdQt2xqb2b1VtmAPm1MVS+hvXV0QtX2n/YO7Ut1JA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1615a421-9e75-4087-3d86-08d858cbf932
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:33:55.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKj0OBY8dQ+r+4aiRzyD7MO/lcqXm4xN9d0rTtc3d983GwN0Wt/zdypDTZgzLl0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3929
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600101100; bh=xxT0JhxX2EfaG7S0KLgbJ3a9RTwYWT6f5EGhpsvO4M0=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=rd1wi7PTZ9E6NeAZH33oG2qHes2D5BMxXT/AuRatF3CAbH1AN1Di1ptq2jQa4DpG0
         aP0V6EWLAL4HiAOz6lzYbLY2wyqNn/CUD487FfKaNv8XuaQz/6YSj/2KMsm9MQCAKg
         xoEevWBy5ZhMc04e4vX5JRqtk9rNuuWC6vMLCIH4G4N484y9hXtqJ9YpUXlHblh2xj
         5pCg/y4bxvp7PLVt9oX3E2iFXL6HNWAArtyF9AyG4b/wUYx4d4GOYJ9upFj6lcOrN3
         gvEOg8BvkMXb2zbJi1mNMlt5N/qzgleBUAzZNS3vQS9Yh8R9s4ndcbsnFMj8Ec4gJo
         R02OjKNL2tgWA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 09:22:47AM -0700, Raj, Ashok wrote:
> Hi Jason,
> 
> On Mon, Sep 14, 2020 at 10:47:38AM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 14, 2020 at 03:31:13PM +0200, Jean-Philippe Brucker wrote:
> > 
> > > > Jason suggest something like /dev/sva. There will be a lot of other
> > > > subsystems that could benefit from this (e.g vDPA).
> > > 
> > > Do you have a more precise idea of the interface /dev/sva would provide,
> > > how it would interact with VFIO and others?  vDPA could transport the
> > > generic iommu.h structures via its own uAPI, and call the IOMMU API
> > > directly without going through an intermediate /dev/sva handle.
> > 
> > Prior to PASID IOMMU really only makes sense as part of vfio-pci
> > because the iommu can only key on the BDF. That can't work unless the
> > whole PCI function can be assigned. It is hard to see how a shared PCI
> > device can work with IOMMU like this, so may as well use vfio.
> > 
> > SVA and various vIOMMU models change this, a shared PCI driver can
> > absoultely work with a PASID that is assigned to a VM safely, and
> > actually don't need to know if their PASID maps a mm_struct or
> > something else.
> 
> Well, IOMMU does care if its a native mm_struct or something that belongs
> to guest. Because you need ability to forward page-requests and pickup
> page-responses from guest. Since there is just one PRQ on the IOMMU and
> responses can't be sent directly. You have to depend on vIOMMU type
> interface in guest to make all of this magic work right?

Yes, IOMMU cares, but not the PCI Driver. It just knows it has a
PASID. Details on how page faultings is handled or how the mapping is
setup is abstracted by the PASID.

> > This new PASID allocator would match the guest memory layout and
> 
> Not sure what you mean by "match guest memory layout"? 
> Probably, meaning first level is gVA or gIOVA? 

It means whatever the qemu/viommu/guest/etc needs across all the
IOMMU/arch implementations.

Basically, there should only be two ways to get a PASID
 - From mm_struct that mirrors the creating process
 - Via '/dev/sva' which has an complete interface to create and
   control a PASID suitable for virtualization and more

VFIO should not have its own special way to get a PASID.

Jason
 
