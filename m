Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D705398FBA
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhFBQSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 12:18:35 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:44385
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229541AbhFBQSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 12:18:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcT8iGuDM8vLQp6Ibu8u9OKVZBUI9Hw/ruyo2zPFmx2Zj2LACluXoJgXoaFUbb6dS96ZZ70ivi9kyoqfUoV3Xz2sFoOZ9UhZPUzXXcCcRx1xxUIlRZUbfffMO+/mhkRToC2SKKgiNbMfp+vMX4ndKPKjPWDAUMd0fauKbP5pIsOP4Oo+hzAy5ScBNLgLbCWMADuhysR/YmqsUts2sCR82Z9W9NDidXVYI0T0QcmDIPhPheHQ420RLN7x37RTxtLcWZ0F0HLKRh6/wySZcF2tSXyiC1rnlujjk/PUB8VUhJAn7M5ICbmuPIiKBCrNhwrzVgIxFWdkPG/uRKrppT2BXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqT2czsM8n9i2Pj7oiq/ZqZM1NTEmmwCCkTPDn6BcrY=;
 b=TmjH5j7oYG9WRuB2OABxVVMr/ZAXjdWPcQZf2d03bYGvnBvokevMOIjFIi+acO3dwSEXhsjaK9vZOIlhC/wymvoFowGOrVJV1BOaUZw+P9muAnye+wLNMtWNDkknejpno9TMfPzshYMn9SWDXRl6PBw9drvckj7aSqzkRRy1i6//mQwrHGSMTFaYZK18k34F0971SRzW4r5P9nHb02KMXXPJneWCDTHNhlwYI5NP25MEzaxCB2iI7eoK7Eo63CAxx9jaBG1r4sSHALCxlku2bIh3xE6S4edBjKCGXCBO680s2v3N0v4yYaFnxFsOi1f/JtxdCjOBqto2N/IFwHD6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqT2czsM8n9i2Pj7oiq/ZqZM1NTEmmwCCkTPDn6BcrY=;
 b=nIrxxk/Mo8HDPMtumig4CiN0peQ8k8I9B+jxd3VzX1LDQM5U1m+JujoJtLokQhsgWSpfN+O4smmhGVt5olruQ2Y8pfGPaGXJVL1QTOJky70MeS7bzDjTaNK9Y2O8jtfGxPpjTlFZ74Brl6E/rhAcPqlPKtO+UKpBRu/QbIArusWO+YZeUpsWGkZNrG+Gz0LBiy4tBicbq4trqv1GQMwKavj8fPJq3Ak0jzmjjhLvMuKVe+rK4zVqw8f4RSvjmIX5lmhRkUIhAEfYapH+jMsYoB3S+X7f8PARWSRrKEZeitveQchTUdNcVFqla7OjvUR70+qmqNYBf583PBgU/qh3UQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Wed, 2 Jun
 2021 16:16:50 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 16:16:49 +0000
Date:   Wed, 2 Jun 2021 13:16:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602161648.GY1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <YLcl+zaK6Y0gB54a@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLcl+zaK6Y0gB54a@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0158.namprd13.prod.outlook.com (2603:10b6:208:2bd::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 16:16:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loTY0-000HUl-Bi; Wed, 02 Jun 2021 13:16:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41b3ae50-9342-4252-3b19-08d925e1d392
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53188201752073693995F5B2C23D9@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98c48qY31G4ammsUConkIY1BtxKMtgxCA876O5VmyCqU2xpkwiUsYtlbBJAWzPNfBhbyq7XhG/qm4Zo8O4W3hWRF2DMmM8xW1f1TmEsRdBl2wqKPKhhlq2N7inYRyXUaxmqwyMvXym573oQgjaJEnkq96VgRWN2PekJ4ppPJU2/kLIWpBVNJ3NJyUXudUibV0OMsSdL9KkfKMZhu/9SrsygbesUfwMT/GMsbRzPhSy8Y9F2Ar87cWnSNcXR3+ZjQN7KDBuCqbX18rxoJlcSE7eLQw8ZXtX4WBbj9FW0Ayv/uvsKUSm/iSkR1Z+SVBnhcBbUutX094BX4w3nVv0aj58go2FXtlQwSjLkcyX2OTj/OAe4IZmmqDY524Uj0CPc9ZoiIlt/nP5md0nh/1o2xNTxDohW4PfO1xjcK6ZG6GmefgPCbU24jGDzsTJ1+qTdMKP4Yccj5Ssn79uOhwZsJ0fAn5Zw1wkAwmsZ8Ryd86bvdjkfDb6088HgxVHhFlzurc+Rc0Ykh6j0yHs2hw4rn6Pl+i0+RPGzRjnRH9rGFChNChc3GMVDyJq7dIm7kb7FVAiKoQBuVtahrEwFRMxlr2zdghFHBfyemh8O1CMs1mQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(9746002)(38100700002)(6916009)(66556008)(2906002)(66476007)(186003)(9786002)(86362001)(7416002)(36756003)(54906003)(4326008)(8676002)(5660300002)(8936002)(33656002)(426003)(2616005)(66946007)(26005)(83380400001)(478600001)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+ZZNffdHbMiA9g3lSfKzdY2U/LaUsOTyiLPna79t2JeiKBAr7gp9Zf9xVSmr?=
 =?us-ascii?Q?/WY1MLRNrh40GVtqrMKxq/aXd3V6zJ2w7C796QdepC1fHTsmCH6czy8a2mUH?=
 =?us-ascii?Q?Gkrkr6+fCqvftzA0aVgJufKkvrpbCKTOd66H1oLCRpv75gg6SLji9U4Jb62Q?=
 =?us-ascii?Q?IdaPmpa6xL1Nsl4rnLiBIkCYtdnqRdaKm0MQTSnnIiWiiPY9FceIww59FTMh?=
 =?us-ascii?Q?d4eoFVMfvXq5yeILTo6gyglAUoxIh9toVJ0fKR6vv28E5FqkkE46mYpqMv2I?=
 =?us-ascii?Q?iYNJ0+zRqgQZa7viUP7t7udj/WFkmvXYUmzeRLtQoUaGW6i9GetvrVETO7nk?=
 =?us-ascii?Q?hE9NOsJlZVhQEM+2L6n+XH/Rh8+HHEp0KwQurHlNqVQbFR2Xz9RZx/ghZyEd?=
 =?us-ascii?Q?fmAUei0o9r1lXRyHtPsGcuUfLMijPdnYDVosz3yXCIPgBM/vfsgvEHzDCRuR?=
 =?us-ascii?Q?qibnNhUR88Z8WJOlpGAJ5KHEXCdepoyK4Uhct5wHVNqEWixdeef112Q7HtHX?=
 =?us-ascii?Q?5eN1GOGVLHB1hXvfjEiQ3fzi407wHSP0A0+3CRyH4CS/BkfcTifBVWo0tAud?=
 =?us-ascii?Q?2p/sLasFod0xCiWSTgEsNGaJtdwgnUvTAszdjt7GnLPlSJSV7IWvzRggvPGq?=
 =?us-ascii?Q?u7WMf7chYvjjCQNBsyMNNvaAar1JsOmo5MA3YF3xt+xs+89Wp6I2oAzsM1ut?=
 =?us-ascii?Q?gvc+IeVo89YpyZ6uTwACZP7SsxsbsNqSXTHx7DvS+mwkkMQPx5PfG6Nwahs+?=
 =?us-ascii?Q?3BGE38PBe//rRF0+viGSAh+6P8kovWaJmduny5hHZlWg+BKy9yCnS1Ey16L5?=
 =?us-ascii?Q?B39ECaryf7K3hX/pB7hrEmd5WF+SwjHRQcHrN+eOTNvpmUetoxauVsDbSHLr?=
 =?us-ascii?Q?lPeT1VsTtBX91NRHU/Isgv7N/+XSm+gT/c+cwuXQ9jKc4lOtqnYdCkLuyRL0?=
 =?us-ascii?Q?6sUIkOYgdJVKdCWL1oETCwrrrUROd9JS4RT681CeDnNFn3Typ9s7gK68G9+Z?=
 =?us-ascii?Q?8kgOWTPqbozvDe8r867bDfroJgsBFWFwbyDPNfLK7GKbTS9UGJyX09FyH5Oe?=
 =?us-ascii?Q?vjwCAX0zqa+lsZuuKqKQlNE8Hr3+FvuwKFKsbfdjL+p7bIYLxXeGhp6hfcNu?=
 =?us-ascii?Q?CFL9b653SMQjbgQwPtzqRf2r9jVWmbhkGUXi85vEdnc0VHq5SOcQn+L/7Jkg?=
 =?us-ascii?Q?ljeaNFEB2l8biREPQ1gHpFSLIqCKWJsE+Z7t9VD0FNVuqYMlYVxDp1rk8PLq?=
 =?us-ascii?Q?KJ6uVFup7Osgl7CcViqaJzNIixe5axeHm2x6YV4l32LVEmFe9AD4qQn6KlZn?=
 =?us-ascii?Q?VknCL+lI9jexbavEH6Os4K5X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b3ae50-9342-4252-3b19-08d925e1d392
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 16:16:49.8614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uthiETI3cHEhbUtJ9j5rHpHQNw7OX/sbqLKktAvPANmlT8WxD74xTY7qja7pA0Qi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:32:27PM +1000, David Gibson wrote:
> > I agree with Jean-Philippe - at the very least erasing this
> > information needs a major rational - but I don't really see why it
> > must be erased? The HW reports the originating device, is it just a
> > matter of labeling the devices attached to the /dev/ioasid FD so it
> > can be reported to userspace?
> 
> HW reports the originating device as far as it knows.  In many cases
> where you have multiple devices in an IOMMU group, it's because
> although they're treated as separate devices at the kernel level, they
> have the same RID at the HW level.  Which means a RID for something in
> the right group is the closest you can count on supplying.

Granted there may be cases where exact fidelity is not possible, but
that doesn't excuse eliminating fedelity where it does exist..

> > If there are no hypervisor traps (does this exist?) then there is no
> > way to involve the hypervisor here and the child IOASID should simply
> > be a pointer to the guest's data structure that describes binding. In
> > this case that IOASID should claim all PASIDs when bound to a
> > RID. 
> 
> And in that case I think we should call that object something other
> than an IOASID, since it represents multiple address spaces.

Maybe.. It is certainly a special case.

We can still consider it a single "address space" from the IOMMU
perspective. What has happened is that the address table is not just a
64 bit IOVA, but an extended ~80 bit IOVA formed by "PASID, IOVA".

If we are already going in the direction of having the IOASID specify
the page table format and other details, specifying that the page
tabnle format is the 80 bit "PASID, IOVA" format is a fairly small
step.

I wouldn't twist things into knots to create a difference, but if it
is easy to do it wouldn't hurt either.

Jason
