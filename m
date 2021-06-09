Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1723A1D1C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFISvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:51:42 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:41441
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230052AbhFISvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:51:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odBMacuqoAA6Po/33bzZ1rLcaroWxWI6mOnKR/uQ0wrVPTi1nnDSjRNEdyxWxoiOu/L/sWHy/RL4amKK1iwq+UV5kf3kOmJmsE6xpkNNCRJC/HakR9gIHtPaKMcV+TBfUd/x+hBUEZZZWxCHfgJe1WDvfA3eH/XaBDNMaPJPOWKjcMiqedMnNRd/9aNTtusFpBiLFWNKXY6EY7LJ/PfspBvavvMkIuWrh5wBHc/AsRVzTjnjLnzohbiwsDRtz3rWsrWnixganB/V4L4zREVrUVjTjrtqSeZwBIkIua87CD3/iMS0kKKSDHJ6vu1B2CVf0laKT8G5fzG/9wRDvggGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDh0DBZneE5IR+M1bq8uPrLMkDN7zzcEJI+WaBwOGxU=;
 b=YSwhv07HBkVBXAKXCl8UqaIxY/h/2TT9CoV/FPM4FMaDekVICvj23wvzX+AUHV6+vAkNp5kkrvZ++q26vMIW4893M8cNdyWPsBAnw7AiJxVZtx6umUEzGsiQuc/7ClEI40HwdvCyzzqdIX1GX3LrsPmHLoFbcjO2kQG8la+ReU0PtlQos92IfJv/DTLwK7a8oqWRwhdaic2bpdknyOpy97yBLmWnxUrG3zJA1gQA+JBaWt/is5TV8B2yizlEOZvka1t4yQdXTS3IQFxSK8aSAH7MMclabMpGwL9KXHjct6R0BnLHemTnECbuyjCs94FpXZSkyxqBIrRHE/Ee4VLysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDh0DBZneE5IR+M1bq8uPrLMkDN7zzcEJI+WaBwOGxU=;
 b=AqcGheMc6akFNCYX6Kuwqp5u8kiOKPybjMwTI6zvvolfNrqYYAR3v2ALFDLr7aXS6HW0imYJURSQjwRLruUQwfbXbcrC/uwkiqvr7MQtK3Idbbl8OtNFVwb6hQeMNmTlWfJ/Cz/14RmjblcEunlj3Yib1dc2EZWNLQTg5s/CfcB2D8V2Q6OwIWcUe/p7heQVOTQD0+ZyVv3TRI5TCc4UPtPi01nWljhnxuD37hujH9nYH1un0DKaSMuxbf1VUIFd8xnnHpZ10zA6bQAIN7/jJxUK6heJ1ncH0I1v577HMMGqs+zFSkQ9dgZLw4e8v3/bK72ZACr1aQcMbxv+ZM5pXg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:49:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 18:49:41 +0000
Date:   Wed, 9 Jun 2021 15:49:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20210609184940.GH1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609102722.5abf62e1.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:208:15e::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR17CA0019.namprd17.prod.outlook.com (2603:10b6:208:15e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 18:49:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lr3Gm-004hkV-5V; Wed, 09 Jun 2021 15:49:40 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2ef4d03-4c2a-4d75-4fa1-08d92b775725
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51753F984746BE06B940A3D4C2369@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LYnDHMrgBds2oUVF18dF2JZ7mPTkjVhqqp2ng77pA4U+vaME/Ep32PX5Z4+5l/6k2fkZp1O03TKGmj++mnotuJbL+B6RfB4f/wLmE1tTYiZxoEmuId7WZ7IKWKxvzNcv0eHybaf2VaTQL8sb/GLCHaB+KiNFGdMVKJpTZivWnt/Iq2J3R/11sUUBwt8UB7mMiTIP2jtnUttOR8ygbkC464VilGC3GGxDDabE6RjPWc4SJk4E4mngGm1x8YZK69ytyitfvT2eINMrrQNSM/mH+cJk21KMNg+Wy4D0XvyxWiElfJxydRvSSZoz0TSeyK52OeI/kNSKDxO+CYKA/dykHpMmNg/n2ghGfBLwH51tgadjeMzLE8LaNrhV6vWD8GV0xxil5czSq9kCQEQKR4Bnq6IdCiygZ8PT5kknSSsR6cOdCZZhUch1XdugC1t6GhvxJxQnVUbU4L3gJc+MyvVajZvAPkhQ1n5e/stlQRzIkDrA4GeMn6nNetlVRv+x5J5zHC+N2M4YNe/nAhV9noMyABcmDDNRVQGdYgbG1X1sR66oRpPPk46HmwCxTvWA601NAZ+Ue/gecwo8Ccpi7ZsV8EKPWLjuSlKU1TtGfAaWtA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(2616005)(478600001)(426003)(6916009)(36756003)(186003)(1076003)(38100700002)(26005)(66556008)(9746002)(7416002)(9786002)(4326008)(33656002)(54906003)(86362001)(316002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIiCvvUIZGR4nhEb5urv9K440KUjJFpSULFzoNBHrmH6vkKGWgv9NLtxpXGE?=
 =?us-ascii?Q?r2XCwnSaP1WmI+pPR0WMPZ6s0+WsB3MkEcjqodI3WsGQW4NrjQC4D7z2pR2r?=
 =?us-ascii?Q?xd82cdkUAPXnAT1wlU7tuqGE0f1O1noufgLh3MieHaVaW3q/H/+NtkkAy31t?=
 =?us-ascii?Q?DR/3HBt7gTU7AiNEZCSVLikfs+lRvKdpv6mLoM0Bw5GrQpl3RNa631U8kJd+?=
 =?us-ascii?Q?jKLSa3hBlgqNVZyP/vKNm97ezmmPNmbmPyeL1whF6rfjhk9dYF3BE5SaKA1D?=
 =?us-ascii?Q?/+BsJZwDmsUlGx9o/X75Xq40NG2/6Uv1XX2woukO5xufh+Mg0ZGZFv+Gp+Yx?=
 =?us-ascii?Q?9IySwNwiFsmDN5fCMpVZMYSxAunx/U5OQ+E9IgUePVYv2vECavcPrBd5Ik/H?=
 =?us-ascii?Q?tkXnZT9a9LUBKdorAVPI5AHYjsjjzsBHx3mb40lrKu10AQqGVXHZ50pGohJk?=
 =?us-ascii?Q?uPqGHlwePtSf6qytrQrZztB3jzGO7Kva0ysAiKFYkYB5H8cTraPvs0yKuKV2?=
 =?us-ascii?Q?PRdgMoaAEX/JnDl8HFGDoFj6LkR28qrzlxTEbij3/fvyVlJJlY4vvV6vxMQg?=
 =?us-ascii?Q?nl1TylpGaQo45ozsPElDKwahZYE3PYm6C65DkcfqOX9EpGdjsmvml9XSGsbR?=
 =?us-ascii?Q?kkEqr63acoZ7jDVcP1utI2Q6nbYYlcbQppn5EPNx+moiQjZDDKwi6VhUfdBd?=
 =?us-ascii?Q?rxH+y99VCp9suexV+t4oy8LoweoytIcJvbWM9+eCoWXWT+W5DCaNupi2qBwv?=
 =?us-ascii?Q?ToEHbAXLitfXYI1dA1a7evpba6DerdsE62i4hbwjxIbARUfU2q4IHl40IJ5C?=
 =?us-ascii?Q?d0/rgnhHwVU++QxWNhNrgUldPQUu1+slDkon3WzRDB9OOITHXc5yoOW7rmPN?=
 =?us-ascii?Q?Ug3Llo7fo0oab+RJk/lN3fN3UeD2ber5Gcd5GWPzNC943fx7lEaaUEsdPF+L?=
 =?us-ascii?Q?qBlKNcxkNeMKplAu4YadZe5GORxm5Kp7pyjtQXbA2Dm4+jecNJ4JNxuKuSrX?=
 =?us-ascii?Q?fcheAc0Ls8r1GMfuvDmXjAhO/wz7GhVjXxPLuHHEzqdGFM3QhkPEHYHs1/h7?=
 =?us-ascii?Q?zmf2gffDZLjP5+6ZJDj8FReiFd0InePMWThBpIW2rGoXxKGL3uMzi79LxnCz?=
 =?us-ascii?Q?f8RztfbxnhXRTJtF3IqvnUK1sJLA4b7tEFl97J0SL4Bpza5qcyWUJY/6lGZQ?=
 =?us-ascii?Q?GZlQyQ9Cs++jCNKrDV4/LbNZc2WuVW84MI6kveQ7n8jbk7r5u163b/Q409Ab?=
 =?us-ascii?Q?bsTeUDGwmGqdSWW7CxqfcUlJ22zluq9PXzsVHTO2u9lQAQY6PlbGeZVm8SAl?=
 =?us-ascii?Q?kstDl8+W3Q1rgvTXA2Jq31Xa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ef4d03-4c2a-4d75-4fa1-08d92b775725
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:49:41.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VxyjXhLUMGycJrmtDXQrhukAl45AqewrPeNs3xsZjbo+a3spWLz0AHXOfJWHxBGd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 10:27:22AM -0600, Alex Williamson wrote:

> > > It is a kernel decision, because a fundamental task of the kernel is to
> > > ensure isolation between user-space tasks as good as it can. And if a
> > > device assigned to one task can interfer with a device of another task
> > > (e.g. by sending P2P messages), then the promise of isolation is broken.  
> > 
> > AIUI, the IOASID model will still enforce IOMMU groups, but it's not an
> > explicit part of the interface like it is for vfio.  For example the
> > IOASID model allows attaching individual devices such that we have
> > granularity to create per device IOASIDs, but all devices within an
> > IOMMU group are required to be attached to an IOASID before they can be
> > used.  

Yes, thanks Alex

> > It's not entirely clear to me yet how that last bit gets
> > implemented though, ie. what barrier is in place to prevent device
> > usage prior to reaching this viable state.

The major security checkpoint for the group is on the VFIO side.  We
must require the group before userspace can be allowed access to any
device registers. Obtaining the device_fd from the group_fd does this
today as the group_fd is the security proof.

Actually, thinking about this some more.. If the only way to get a
working device_fd in the first place is to get it from the group_fd
and thus pass a group-based security check, why do we need to do
anything at the ioasid level?

The security concept of isolation was satisfied as soon as userspace
opened the group_fd. What do more checks in the kernel accomplish?

Yes, we have the issue where some groups require all devices to use
the same IOASID, but once someone has the group_fd that is no longer a
security issue. We can fail VFIO_DEVICE_ATTACH_IOASID callss that
don't make sense.

> > > > Groups should be primarily about isolation security, not about IOASID
> > > > matching.    
> > > 
> > > That doesn't make any sense, what do you mean by 'IOASID matching'?  
> > 
> > One of the problems with the vfio interface use of groups is that we
> > conflate the IOMMU group for both isolation and granularity.  I think
> > what Jason is referring to here is that we still want groups to be the
> > basis of isolation, but we don't want a uAPI that presumes all devices
> > within the group must use the same IOASID.  

Yes, thanks again Alex

> > For example, if a user owns an IOMMU group consisting of
> > non-isolated functions of a multi-function device, they should be
> > able to create a vIOMMU VM where each of those functions has its
> > own address space.  That can't be done today, the entire group
> > would need to be attached to the VM under a PCIe-to-PCI bridge to
> > reflect the address space limitation imposed by the vfio group
> > uAPI model.  Thanks,
> 
> Hmm, likely discussed previously in these threads, but I can't come up
> with the argument that prevents us from making the BIND interface
> at the group level but the ATTACH interface at the device level?  For
> example:
> 
>  - VFIO_GROUP_BIND_IOASID_FD
>  - VFIO_DEVICE_ATTACH_IOASID
> 
> AFAICT that makes the group ownership more explicit but still allows
> the device level IOASID granularity.  Logically this is just an
> internal iommu_group_for_each_dev() in the BIND ioctl.  Thanks,

At a high level it sounds OK.

However I think your above question needs to be answered - what do we
want to enforce on the iommu_fd and why?

Also, this creates a problem with the device label idea, we still
need to associate each device_fd with a label, so your above sequence
is probably:

  VFIO_GROUP_BIND_IOASID_FD(group fd)
  VFIO_BIND_IOASID_FD(device fd 1, device_label)
  VFIO_BIND_IOASID_FD(device fd 2, device_label)
  VFIO_DEVICE_ATTACH_IOASID(..)

And then I think we are back to where I had started, we can trigger
whatever VFIO_GROUP_BIND_IOASID_FD does automatically as soon as all
of the devices in the group have been bound.

Jason
