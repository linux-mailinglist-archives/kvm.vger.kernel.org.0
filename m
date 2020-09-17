Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D3726E348
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 20:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIQSJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 14:09:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6249 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgIQRbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 13:31:48 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639d340000>; Thu, 17 Sep 2020 10:30:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:31:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 17 Sep 2020 10:31:11 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:31:10 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 17:31:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkztDCqbZqfaKuZlXu4oSXIDCBFsXeBVv61Dfc7+Lt1o/4N0zVNbfvr6C0DiV2NXCwabJcDUbWHHj4z9buIzE/jtu2rDa0F47IFjFeaFWuHvcu0cCg/C0Tmj9MXJ4u8MK+DYqHUYWBA8Bm9oyW6BSH+j+MGvKpYV3hsYX6Ak1RP7AQcLoYFWX950fwCSJoQnMeNpmDDbf4AVzwBcWYYofMLodvMuhypRlwngtCuewj1BZZ8f7RML2akOPoL6KamXqqGkHZg0dSVhWT5EUa9G+GxScNO6z28TnpBwDpkSQ4KLurhu26qM9dWKmrXRvdgbJ7Kp+qo10H3fS9/thgx6Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQk+NU9tptzKAgCnJQ8TJlT6ZUiwCJVGmhoughIgboU=;
 b=EVmMMK/pbrzs4hGr8BmYWkQk7WxNNWHlcASb+L6JNxO9qalVAK2ALUYmViM22xMmrwrrCUVtttZMJMNVVFPxPvPRlUDcEnNvslFaUlHSLfrBsDQSz3bCEGjm0Q9VXus7qLOG9wPyYtnZbex+dKXUw7So/bTNTsQap3eZvf2NY9VJa0hUgT505xn5n9r0cpJiEFwjndkgXJEdyquOnKp+UOVeB/mFbbp3Afmi0HTkdIXQYC1hmU5KYyi1Vd0G9V34pGv20WoCeQFGddginNyHgg2cpJEA1YIjVpt1h6z83LRWeFWVIl5d3DJ23VFuxhkxD4IUSL5AXU2NlJyK1iHqXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Thu, 17 Sep
 2020 17:31:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 17:31:09 +0000
Date:   Thu, 17 Sep 2020 14:31:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200917173107.GV3699@nvidia.com>
References: <20200915150851.76436ca1@jacob-builder>
 <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com> <20200916150754.GE6199@nvidia.com>
 <20200916163343.GA76252@otc-nc-03> <20200916170113.GD3699@nvidia.com>
 <20200916112110.000024ee@intel.com> <20200916183841.GI6199@nvidia.com>
 <20200916160901.000046ec@intel.com>
 <69ec9537-460f-2351-fa90-c31aaeef3c4b@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69ec9537-460f-2351-fa90-c31aaeef3c4b@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0039.prod.exchangelabs.com
 (2603:10b6:208:25::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0039.prod.exchangelabs.com (2603:10b6:208:25::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 17:31:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIxkR-000aqo-Sp; Thu, 17 Sep 2020 14:31:07 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7263bab-e2ca-4c70-c60d-08d85b2f76e8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4388:
X-Microsoft-Antispam-PRVS: <DM6PR12MB43882D5E3F7E126233A0510EC23E0@DM6PR12MB4388.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9hWiaTnrf99UTmxHShe6DSkCCCrb6GLio3KK1py741Fhbuh60rX7LKvcBVzUKWonxsAJ1IkfADX2uctfpREaxCn22xlhuDuUNYlh5eG7s2VxwS2N9ekKq7p8LlxnSGA5Yu5Sy7MsqhiKeZ2ggn6yvh8aCNABOF2Me94IpMdm+3Sc4ykoaAolmi3HP6RfqmUxMit4gkjQIdRhJp/DamCgx/W2OiPINqMJugLWWq8e2iBlOmw612q3AyL/HoZs+xK+W11baAG522DQ0BwbbfhtFg8TsKXNcQTJTgGXQRpJwxNLiVLGy+xIR2Qqw5WAw8LK3KORYdJo+t2XhnkbGkFlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(9786002)(6916009)(186003)(4326008)(426003)(1076003)(36756003)(8936002)(478600001)(66946007)(66556008)(66476007)(7416002)(316002)(26005)(2906002)(83380400001)(54906003)(9746002)(5660300002)(86362001)(33656002)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nnzIWKZYPbp/FrTdAUhXfoXPNlYpTRn9nmm5L+61Oshawm6zGRlO7KEY1DtE7v9K+ucRM/k9dnqZH1u6owDWjrMwMhPi9Dxy/uvD1Cr6pnLLiRFzCUD9T2Sh8OE8G4TZWeKMUwwbaBq5VBV0pchOJ5Eq573Z6a5OGXMLZQCHCSOKagMQpgBTaTsqaHEGi+DMtcVgmoMGtq5bub19pCmJToeGIsgyOidnlly6DRgs3a6d9qSV//NUANuddebJvza65gwJHYE0jk6Cr0U4sd0/tXBAZsONEtoNRSCzfUNlGtOJUsAJ4trN5WcdWDl8p4xiQ65l46lnNdFP1YDyDOxCTpMoHap8Vk5gFDD0s17Nh+UP13DLxDD1VQRFjDWQ+bMSm593Zij6EUwrw+ysMi3/LUOHBHkQuIm0P5EWzKSnqMbI/iN+m9U8+/0t5I2OV9oSdtY9cLOO0pA+MB4cbcSJlzJj/6a9RaLN4K0k6ZZeOt3O70Zr0iLf6OP0LOTj+Y8qlRjgoctmahTJUZxyo3Urq120qIFzbdh3TgxV9JCKVnFuE1b92glmdnOtdgd0EY/AkgY7foJuN/c5oZR0Cuocel9kOZWti1X/AXyOciIA26z6JTiOZdiNM7YOaHPLMXD4bB+nF7FNw/Gk0zTOorD+xA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f7263bab-e2ca-4c70-c60d-08d85b2f76e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 17:31:09.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KpQUChnyb7fluWNYTSLP24X+qBVyvqWu4BO0fuRhqLDRYJWhTc6hbGi/MKvfDqs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600363828; bh=LQk+NU9tptzKAgCnJQ8TJlT6ZUiwCJVGmhoughIgboU=;
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
        b=bRXYU4pVUW1rYGPUhp4Z4u4MBVPfMKr4N9Q5rozsnC85a+kTEaMZSLnFHlzfcXBTW
         cE1xmIZR/huGwDmCHEHEygV+a6gN2Gkf29pyhN5QyneYRSgTrHeWP3G8/koazI7L3/
         L8fsHYbJrHebwLm/UO/LdnnY6wDhANwfrEFwX0CUCF1suFZznEbVSzzI76XnUTEDhO
         64827TvPrv8V9U39sCawaunOYHZiPeAiZGIk1Y8HmLkQt1pg567f7RYjpwUHPMop6B
         BbkCHi+1fqPDW4V8mhyTA0JM/ENbSYH09/dMLF6vMfDUFJUYBqJaQprwhU7DaBxFI8
         jTRrZfm9G2pPw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 11:53:49AM +0800, Jason Wang wrote:
> > > When VDPA is used by qemu it makes sense that the PASID will be an
> > > arbitary IOVA map constructed to be 1:1 with the guest vCPU physical
> > > map. /dev/sva allows a single uAPI to do this kind of setup, and qemu
> > > can support it while supporting a range of SVA kernel drivers. VDPA
> > > and vfio-mdev are obvious initial targets.
> > > 
> > > *BOTH* are needed.
> > > 
> > > In general any uAPI for PASID should have the option to use either the
> > > mm_struct SVA PASID *OR* a PASID from /dev/sva. It costs virtually
> > > nothing to implement this in the driver as PASID is just a number, and
> > > gives so much more flexability.
> > > 
> > Not really nothing in terms of PASID life cycles. For example, if user
> > uses uacce interface to open an accelerator, it gets an FD_acc. Then it
> > opens /dev/sva to allocate PASID then get another FD_pasid. Then we
> > pass FD_pasid to the driver to bind page tables, perhaps multiple
> > drivers. Now we have to worry about If FD_pasid gets closed before
> > FD_acc(s) closed and all these race conditions.
> 
> 
> I'm not sure I understand this. But this demonstrates the flexibility of an
> unified uAPI. E.g it allows vDPA and VFIO device to use the same PAISD which
> can be shared with a process in the guest.
> 
> For the race condition, it could be probably solved with refcnt.

Yep

Jason
