Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F243AC051
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 02:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhFRAyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 20:54:51 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:21728
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232959AbhFRAyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 20:54:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5HZkWLbxj+BaLAyQqd2vGgxE/N15e0eTRZZMol43tV5WzF6LpYCyeACys+nZnoL9OH4lC89cGPO3V32DQhdaUtmZg6aNcnMDtOfferRtx8WWe5SDTNQCFkwQh60YmzDrxAvJgGXBSNQUaqZ5EbkJ9K7RbhtQlocwAVGggcC5l5wnP67TE4i1v5oACVDowGMR/UkptWIZdRqJjKrnOP2xcOTaMP9bqPLFYgr7ryQsNLd+UZVZkAv2JXXGSthkBA2/nscKH0FXrlZkebGVAT63Xp1xDRP638yWGXBnnCXyvM+A6XwnUi8LUSGGNxOppcWe486bL63V1u/qRFY6ogp3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vCMBZ0bOuKGttL83lEJrGNngAggVUwUCputWthZxyk=;
 b=LnsySy2x8cZ1T2k8jdVUbR+aAy/UJzysDviBNY25X9GGi0Czghgha59nLApUT2wDvw21gV8jrcaZLjSZCZXzMkZCV9IVWaGXR83TeQYteKfDgpweJ36GaITY8k83vUhF9+pupxvVZAopyhJ9sopG6Cd9IthLuPpgp84T6+FVzAVQ7vCeJh7LCtmi/PNTLak0v/a7+1skJnEjSRk7poFBBx8eXQcyLLyQiH5pTdYcjqiBcy4wL7vjoDnjiHb+TyWx8p7jkr4h6VPyKcIuX4iWyq55audjL4LFBwp0AxDGR1D7BYviMm6LCHx81AkI9tJv2dn1zagAkQgY63JTFh/Lwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vCMBZ0bOuKGttL83lEJrGNngAggVUwUCputWthZxyk=;
 b=cWEoNdkqxoEZUxDEswSUbi931J1zNrcWSX+vKyCx/ktdGopMf1NhDMLzqzWsDN+Y1c5oTGZICa4pARNp31yYYwMhClsSAYC/VaZKhIG36c2I0EKN3DeWk/LDAS/5y2nxK7Z5NncLopJh8otxtBd1rB8L3vs3M5tv+LUdCRCkAd27F7zGuzAjxNcihdj803jv2Lq7HSHVqxq92PDq2Uw4mygtUDTQ2tJgw7LUjXLBi5WLof5KtuSGlSPIIeZjjbaXnhsY/3D40ghDrIBMLBPa3XR4/SBbUZ2Pb6BRGoJVJImPYWgEi5CgjaGPM4tKyTSIoY5sRJbuJ/aTyPbWnwi1Ow==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Fri, 18 Jun
 2021 00:52:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 00:52:41 +0000
Date:   Thu, 17 Jun 2021 21:52:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210618005239.GB1987166@nvidia.com>
References: <20210611133828.6c6e8b29.alex.williamson@redhat.com>
 <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:208:23b::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR11CA0001.namprd11.prod.outlook.com (2603:10b6:208:23b::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Fri, 18 Jun 2021 00:52:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lu2kR-008LYG-M5; Thu, 17 Jun 2021 21:52:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bd1e5f3-668f-4cb8-898c-08d931f36021
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223439331F1D4C76BAE4F25C20D9@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9QVozVCrze0eDNm82399gc/RfUVr1bBPqxwaQBnBIyiXKbwktZrU+SolYv/qEht2AwH1ykXSPt9bMUWTxD6IVSNKiscv7h2mCksBrx7N1dO3apznz/UXr3FBESZfcwkEW2hbsyoBkfNPHZ8BFnwuGU+aeWH41seLQ2ARWoWbthdc9rpYdWiz5TJtGp8wQzEFmPCJ9xA487oo5rG3tDCVc3iGrPA7uAVlj9Ezk92lYu1yMPMcL/JTLOKOfoPMnDHAL4rLrdbk7/CDYpIdre5gq0MiT39VMyv33C57ma2n6VIeUBQapbYUZGfMvcX+hflPG/ZQUtlhBb6Fwd/bFOPXd+lmVrX26yRojChpuMqJNOSYx7up8CkO3FMMlFmeUKx+KEOnBy1nSVmfMe7zIKsF6sYViDBdgiYS097QVuaRnbkCkvBUWmnS35UB8VzC5TGLOsDkSBLf+hArDj+O1nlrzV8stND21YDoK0XjtvZwkgHIGd+xxs8bR3cvuZJsAJ0SY4lGrAoNGO9FESZQc916QdP0afd4R1mXGLRQyNlhFZLoL7I7HZAnEbDAVWKcQwjyiaYJ68blLHSAgJGhnKoUxD0eCjHKVsgTPOMq3mP/vY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(66556008)(316002)(26005)(426003)(6916009)(9746002)(66476007)(86362001)(7416002)(2906002)(8936002)(5660300002)(2616005)(54906003)(36756003)(9786002)(83380400001)(1076003)(4326008)(38100700002)(478600001)(66946007)(33656002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FBMIcC21qPTJ0qBk75ylnOhMxyeJ8OzPAMp893q71DXNTB83/J5dB+tTnrjx?=
 =?us-ascii?Q?m2+00CFwg8Rh891vysgLSMWkI9uit08tVHDt//W5qAaymouzgyrthbynH3Tw?=
 =?us-ascii?Q?gd6atzCysOFbpvaZmCsQcQ/nuvv46J8h2GsphmLMwGop9IWIpvFMwVcwUJCd?=
 =?us-ascii?Q?GZSmW5CYiwH268aamy1UCIwq/FdLHbGsisqMcX5k34X/thDoA4LjsrAalIZD?=
 =?us-ascii?Q?lZ7p3PuqHSVB7nOf/EnLxAwkw9mefvG4pPq1lnrVMW2kqd4EsEAE4g8MhGk6?=
 =?us-ascii?Q?k/OD9rMoMkCT91v3aZnv21Am5qjNUC0Pw9VmbAx2/4u3njHACpQ1MomUD6uW?=
 =?us-ascii?Q?9dBXabHEVHASlnQ3Ql5pBxesmkV2nEOAVDb0aos5FdZIaO1aEf/Ijn4nho+1?=
 =?us-ascii?Q?gFboiIuJYdE+9un1P8VHqLh/mzhZ7dpMymnzlqSdttNTJYM9JGLKA5mtk2y3?=
 =?us-ascii?Q?OZjLQmBnccgY2JB7xoHK+M/y1Eg0lBUDKvjhK9vBEPSerFlgN+lwxseigFhs?=
 =?us-ascii?Q?fOw8RWCY1rF/Uf9g154gNcoi4wiL/tMjraItjhPdUAXrL8whypTste+D/iKD?=
 =?us-ascii?Q?J0YF1MII0PFxmhTioOG/wxUvyID+UbPwSlK9HpGsrwI55ObpdpgxZlJWgFJM?=
 =?us-ascii?Q?X01BGn0GVCRjt4fxb628WhE7r1ePei/E4OdM1HRcRFuDtVKhzIQQtkijIPz4?=
 =?us-ascii?Q?htFBwspIOXtajyxaH/mVKW0oa9mTOyhTNFBKWfH0WKVxltjcziOtNZ8QCoK2?=
 =?us-ascii?Q?d1QYBpvCaZu/m+cnYl/FkTpEDtUhVsfplS2x5rlXrLdJo+1p2LMSxycHNt3x?=
 =?us-ascii?Q?KhsdDMoSnGLwUnK6B742UxtPipP/z+00K8CbEU8VOTKIop0f+o2eQsUpKOTa?=
 =?us-ascii?Q?6+2z3XxLot62IClxiUI88FciYaZfUn96LEvxuBrCq3IhrbUMsyIENQxbRLB8?=
 =?us-ascii?Q?GDiJRDwVBrwmg1f17eTNM/L45UTeQAjAHCn0zXV8isM7t6WF4cN60Zu81uj/?=
 =?us-ascii?Q?A5AFI4j6X18+e4khIPmVaThMarwuorD7ht2U77F5IURby5uplRCmMkRE0hkV?=
 =?us-ascii?Q?OYHNyK+Y9c0f3stjx0BKNuxHJ520qCnA+pXllBfClRWNPumiVegR/FlcaKh1?=
 =?us-ascii?Q?z4kuKc9e+Aku/S3xRkapfkJfC1PJDA88Z1/Td7gNKstKiYTb3LQtdEQtgl54?=
 =?us-ascii?Q?toD9kY0WNszQz6arkxCAZU/ZuM9ZKhDy+Dh7D6SGEi2SSg5mhJnhM9PX/IRW?=
 =?us-ascii?Q?HqULusl0T2VR+NUuH2QV5gL6wBhlfpnqROkAxeqUEVUEQf2ZxmWJJWfqlh2n?=
 =?us-ascii?Q?+AlBIgUQbaxeJ83shw0AGXsc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd1e5f3-668f-4cb8-898c-08d931f36021
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 00:52:41.1908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1lGA85chrB2/RICKscT2UlHVU8b4Isx6+XHJnM66J1Sv+PMCXdcImcwuLjAXBwa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:
> > > Yes. function 1 is block-DMA while function 0 still attached to IOASID.
> > > Actually unbind from IOMMU fd doesn't change the security context.
> > > the change is conducted when attaching/detaching device to/from an
> > > IOASID.
> > 
> > But I think you're suggesting that the IOMMU context is simply the
> > device's default domain, so vfio is left in the position where the user
> > gained access to the device by binding it to an iommu_fd, but now the
> > device exists outside of the iommu_fd.

I don't think unbind should be allowed. Close the fd and re-open it if
you want to attach to a different iommu_fd.

> > to gate device access on binding the device to the iommu_fd?  The user
> > can get an accessible device_fd unbound from an iommu_fd on the reverse
> > path.
> 
> yes, binding to iommu_fd is not the appropriate point of gating
> device access.

Binding is the only point we have enough information to make a
full security decision. Device FDs that are not bound must be
inoperable until bound.

The complexities with revoking mmap/etc are what lead me to conclude
that unbind is not worth doing - we can't go back to an inoperable
state very easially.

> Yes, that was the original impression. But after figuring out the new
> block-DMA behavior, I'm not sure whether /dev/iommu must maintain
> its own group integrity check. If it trusts vfio, I feel it's fine to avoid 
> such check which even allows a group of devices bound to different
> IOMMU fd's if user likes. Also if we want to sustain the current vfio
> semantics which doesn't require all devices in the group bound to
> vfio driver, seems it's pointless to enforce such integrity check in
> /dev/iommu.
> 
> Jason, what's your opinion?

I think the iommu code should do all of this, I don't see why vfio
should be dealing with *iommu* isolation.

The rest of this email got a bit long for me to catch up on, sorry :\

Jason
