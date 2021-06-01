Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1A397B40
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhFAUaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 16:30:20 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:51734
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234513AbhFAUaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 16:30:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oo80EoWmTIq2QQn3oSPD7eRm1/eyh7ZwheOmmgQCREumczPw85XEF3Ril/ZFUDUvkhMk8KK/IunxwkpCu7wC8GH+mDIrjb0Mhp1REkTv2d9Ufj4NvIb4yCMbaeVpJvBCvqSuuwsxPFLEawRtvQDvROnuBoBLlRiUltjgkRLKPB7SJLfNJ/imyDoEe3WD+4Ni548vYrW2FcqUoOV2kSOJlBStnB/Ka+DDIQZUWquUbCvQ0HiN22EpTetDD6CZc0AVph4trFbDtkkOMM48HGneJZqsZSvZF0MpkDVDO4ntZfgvkPX471znQ6yMShcihe3yU3bKM3UeCNVnqQWX1Rj0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOcwSoGWZcPRTREwuX9tcIDD09PgY3ajKsAAIavGkHA=;
 b=e/UTiRtBOGh15cTa6OVfxtTP8B10+hrjdWhIc8ymibB02vIaoSxWg383zs/SM3H7pqYeuAKYaiGlZrLgrtZlptDewep+g9XnVY23Al1EWW1lQCLCXaXBWWr2jT5XOtFUmo05DSnGfj6m++yJmIO1y8xq7OzLo/wJyDI6p3B1PJzp7zzqux4kPpzd8sbVRVO+86AlTqdyqNBzQbZR461yvQlOz19j5ajbJMTa7lfTFa+KkKaY58zrEdc0/0i6Y+mj8ovafNSGzLume1TIDruaVG6KycjQ98kEzzYpBC/u1lDU52P7eb4qcH7Cgc1joB5S3OtplhPdSIHmg2jmdsZ3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOcwSoGWZcPRTREwuX9tcIDD09PgY3ajKsAAIavGkHA=;
 b=loQkEwU7nq51BGN8pJ7s3zlvlq88EqoOnmAHivfMY7Pk/YTOzzJXjdT0/FEnTXRwEtgJ1iqVoFoeYrdMZTndO9R+zONOqLOEfYe0cCBNC7QEl4xbzIK+ghBSB0uBnOLK6euOq6m4sVcDcofS6lCuz6s5c253n080V9FDCH1A3UBTqnfK++dyFnvjfE8rwJuualPg1ac8lZmtmago04eSM3WasPvpxVjpwVo2RtegQW6ozwMJx17Fw4NnETNY0q8SxDOnNNdkL6y6MPGjExaF9AOCECNYtwtKs2H+DrCs6Bp2RMjwzm8ZMb/frNRK+0Beu23HHgQBL0lrOU7ByjtIug==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 20:28:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 20:28:35 +0000
Date:   Tue, 1 Jun 2021 17:28:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210601202834.GR1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:208:32a::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0119.namprd03.prod.outlook.com (2603:10b6:208:32a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 20:28:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loB06-00HaO2-PT; Tue, 01 Jun 2021 17:28:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 873b715a-9c25-4b4b-290f-08d9253bd4e9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5240:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52400A8C7A1340E572FFE543C23E9@BL1PR12MB5240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4e8xS6q2MHIrLjjw+D2N42FqO4aQkn05v1WLOZKjlPBFEYEGMQA/tsCXO5KIdFB5ittS5oILb7CnwC8pBAu4BSkLMIuwbSNsJAJj69Yh5gSZ2XT/9CE6voLSLcy3Nh2HPgWBOiv8F+quSrQnIeSMDxAvZNECEEkUnBqb+HSuru9PWK49QR/BemnYXXLZPADnyw/wLB9/4Czd2Jna1ly8mvG68db5WPgL/R0gQju8h4QYbmt0Lu3YkUOrMUCnre6on8e8f+JW6rogs1gVzn/1tr9JxkdHKKB2Egdw5ePjoL/3fJJRb7tLfj3Tgu2PpMy/xwFIJt/NR1JGxrgnjhb0Dl2n947eAIgng+CgEL9qnxq/t0rZ/swKpH5d2FTtOM37LecY8+uEnjkRK58Sg67ktCzKWNRToyKrnfPfC0mEYqw8xXBqFUdtY3YsO10QovhOfHjxQFTG3q1pZKTqyT4skuvkeDEVkSHqhqrKr4BJpOPcuZ/ZDT3Abg6pfE2b8ZNBm61nWEfA6S1iN2QuBENuslVKZChoLrDglBNkpUuP6nq4EW32G5BDukpTJKNYypwTPrFIkdKOO3NTOXxkp6HnGj97G7y1dCv/hojVQVNdSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(316002)(66946007)(6916009)(7416002)(9746002)(9786002)(83380400001)(66556008)(2616005)(54906003)(38100700002)(4326008)(26005)(5660300002)(8676002)(186003)(66476007)(426003)(478600001)(8936002)(1076003)(86362001)(2906002)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UHSd72/pBgEHA7Y3jAOZjW5TPvQJPtmf14bOT3yvlpmxPuWT78qu921wrmsO?=
 =?us-ascii?Q?1pmMkivme74rOfp9AfRYir2DbvAht23/Cx6FMvjsPfx0iapUQ75Q16kwr47Q?=
 =?us-ascii?Q?vwMwzwck+IcjoRvIY2tAvK81iXFITG9V7mh7qU6ciw3T+8Qr5ps7OBcv021b?=
 =?us-ascii?Q?htqOATA8C5A3iQNItxymuK4NfJffBkLmGrwo/MswaMYey/hjY87tWnWMdtJv?=
 =?us-ascii?Q?Wcw3DRMipTYkA5VM0EIZAbLxDiyhEirldueN7HUIPvz1q1H9wfOsLVRs/SWS?=
 =?us-ascii?Q?5Mx4VQZz8qg3W411Fco/VM7uC7WDsY3PPagEvZYnwXa5hpc+KGEJ4Bt+nM3L?=
 =?us-ascii?Q?8kM8Xei8eY1FtFfhEDt/5/ThNiKhREUtM8BAMqL3NBGVlUavzp4zwY9YGskV?=
 =?us-ascii?Q?2ObSoDB/YyIJfL7SspqRnWxlGM7NDUw7QTQcADF78UyP/v3Sm1eI+TnNADVZ?=
 =?us-ascii?Q?8aTQLHYGDlqfjSl8yQTTl9kYXTBOyxqEM1ALpgCQrcDmDBbA+M+OJ1MMf2gU?=
 =?us-ascii?Q?oSFPhQCTr/9T6bkyycnzJ+Y0ko9DpVyARiu4kM2v7pSPCTcXKFbEYUE3ufY5?=
 =?us-ascii?Q?Y95iWFyiF0bQ14QXfHZqJ3vT10an1OdJBb7Tik9ZA/0QclPbl//uW0TSdOE0?=
 =?us-ascii?Q?vnGgXQGr77w2eYldyUD0xKZBD+pb/9krgzdjmq2toSCZmotHTAKPnLiJ5qjH?=
 =?us-ascii?Q?2B9EQ+wMnBqAy9ebQZWKit7ULOET2LfXjLD6HfvqJ0dQMnhZqsY8hmAdkWWX?=
 =?us-ascii?Q?mCxweHybHC/Rgvd/8A7/8wWJUahtasAXyoUXsjGPhoio89a5XpnMc0Nv3UF+?=
 =?us-ascii?Q?+4Oez1v8rxXT7yqzryLbby7MFofOyhFySjo+aDNs5eEW4tH2pPI2Fji2QVgu?=
 =?us-ascii?Q?vNdiCzOG3cW66mIf6JODb7262SNhv09VglbBokb/rvf+ZZiVaXszxSK/dJfG?=
 =?us-ascii?Q?1MZVYCAyr8rz7RcJ9tCXWhIATsLPCOtXbJmhwsipytQrwjpo1xs6x+yMWpJR?=
 =?us-ascii?Q?dTLnLKAmd6zr8s9IlMBuh2NLfEv2b6y5Kclyu+edpIsyKCtOAtBf8YH8CWaj?=
 =?us-ascii?Q?dhynzH2VU+7W71/egaJ++moDlUlvNDPOjuQFzzTvRC0YXUUjQzYfKzIY50PE?=
 =?us-ascii?Q?dTTAd6fLpBEOu7Oa9+RvPJ/6FZtvVJlziK7kysQ8nWCDrYwpK42UCqikMEg1?=
 =?us-ascii?Q?8EScEb6NfgpDHtT5IJNMWHrCRSVZIWWBa+9sdNDPimfPaHdnK0Sne1xO/9QL?=
 =?us-ascii?Q?wi2fgiLR6+BV5VRcvYDXUZA4QxdzQCF+0BoOMaYzV7D34XKiEe3Qu0dkOjW8?=
 =?us-ascii?Q?UlDc3XG4X0b/JLygS8jK2cfM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873b715a-9c25-4b4b-290f-08d9253bd4e9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 20:28:35.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FoUeSFRMn0EABD54SuerAxGVbYhseAO2UVIxc4ww9x9INWRUoLIKt2hRLJiUYe1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 07:01:57AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, May 29, 2021 4:03 AM
> > 
> > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > > /dev/ioasid provides an unified interface for managing I/O page tables for
> > > devices assigned to userspace. Device passthrough frameworks (VFIO,
> > vDPA,
> > > etc.) are expected to use this interface instead of creating their own logic to
> > > isolate untrusted device DMAs initiated by userspace.
> > 
> > It is very long, but I think this has turned out quite well. It
> > certainly matches the basic sketch I had in my head when we were
> > talking about how to create vDPA devices a few years ago.
> > 
> > When you get down to the operations they all seem pretty common sense
> > and straightfoward. Create an IOASID. Connect to a device. Fill the
> > IOASID with pages somehow. Worry about PASID labeling.
> > 
> > It really is critical to get all the vendor IOMMU people to go over it
> > and see how their HW features map into this.
> > 
> 
> Agree. btw I feel it might be good to have several design opens 
> centrally discussed after going through all the comments. Otherwise 
> they may be buried in different sub-threads and potentially with 
> insufficient care (especially for people who haven't completed the
> reading).
> 
> I summarized five opens here, about:
> 
> 1)  Finalizing the name to replace /dev/ioasid;
> 2)  Whether one device is allowed to bind to multiple IOASID fd's;
> 3)  Carry device information in invalidation/fault reporting uAPI;
> 4)  What should/could be specified when allocating an IOASID;
> 5)  The protocol between vfio group and kvm;
> 
> For 1), two alternative names are mentioned: /dev/iommu and 
> /dev/ioas. I don't have a strong preference and would like to hear 
> votes from all stakeholders. /dev/iommu is slightly better imho for 
> two reasons. First, per AMD's presentation in last KVM forum they 
> implement vIOMMU in hardware thus need to support user-managed 
> domains. An iommu uAPI notation might make more sense moving 
> forward. Second, it makes later uAPI naming easier as 'IOASID' can 
> be always put as an object, e.g. IOMMU_ALLOC_IOASID instead of 
> IOASID_ALLOC_IOASID. :)

I think two years ago I suggested /dev/iommu and it didn't go very far
at the time. We've also talked about this as /dev/sva for a while and
now /dev/ioasid

I think /dev/iommu is fine, and call the things inside them IOAS
objects.

Then we don't have naming aliasing with kernel constructs.
 
> For 2), Jason prefers to not blocking it if no kernel design reason. If 
> one device is allowed to bind multiple IOASID fd's, the main problem
> is about cross-fd IOASID nesting, e.g. having gpa_ioasid created in fd1 
> and giova_ioasid created in fd2 and then nesting them together (and

Huh? This can't happen

Creating an IOASID is an operation on on the /dev/ioasid FD. We won't
provide APIs to create a tree of IOASID's outside a single FD container.

If a device can consume multiple IOASID's it doesn't care how many or
what /dev/ioasid FDs they come from.

> To the other end there was also thought whether we should make
> a single I/O address space per IOASID fd. This was discussed in previous
> thread that #fd's are insufficient to afford theoretical 1M's address
> spaces per device. But let's have another revisit and draw a clear
> conclusion whether this option is viable.

I had remarks on this, I think per-fd doesn't work
 
> This implies that VFIO_BOUND_IOASID will be extended to allow user
> specify a device label. This label will be recorded in /dev/iommu to
> serve per-device invalidation request from and report per-device 
> fault data to the user.

I wonder which of the user providing a 64 bit cookie or the kernel
returning a small IDA is the best choice here? Both have merits
depending on what qemu needs..

> In addition, vPASID (if provided by user) will
> be also recorded in /dev/iommu so vPASID<->pPASID conversion 
> is conducted properly. e.g. invalidation request from user carries
> a vPASID which must be converted into pPASID before calling iommu
> driver. Vice versa for raw fault data which carries pPASID while the
> user expects a vPASID.

I don't think the PASID should be returned at all. It should return
the IOASID number in the FD and/or a u64 cookie associated with that
IOASID. Userspace should figure out what the IOASID & device
combination means.

> Seems to close this design open we have to touch the kAPI design. and 
> Joerg's input is highly appreciated here.

uAPI is forever, the kAPI is constantly changing. I always dislike
warping the uAPI based on the current kAPI situation.

Jason
