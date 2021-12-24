Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3625F47EAA5
	for <lists+kvm@lfdr.de>; Fri, 24 Dec 2021 03:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351000AbhLXCum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 21:50:42 -0500
Received: from mail-bn1nam07on2078.outbound.protection.outlook.com ([40.107.212.78]:64834
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350885AbhLXCul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 21:50:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUKrsO0+8K6dqR6MKJrTSiVdjQKs4FYd7zJmkHzz0H5QMcOQch2wU+SXEdfp7aMLhpAeTVGc1NXrMwqoLH9jlKJ9Qb2B9LcdH2QY1G32WdSblcJN+ULECCsMFibSc+gV9wQVZmTjC4aWZ0PM/m1jNtkcK/khvL4H6FnU5kSsMrhvocA2IlCMfKOA3uPih7v+nf9pUk1K6ZjH3WDIZO0SSnoHRqIESh96mbGjN/ieXdnXldqVuxElVyi7F02Ze9NfYwSxhj4OOMdAmusoXAmeCl3243hj9XgrdAswwE1/evasMFRyKWj1ZsxiO+jtgMKoXFBi56wjLjLU83TsOfzGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcgCT2Z8fo+N7Fhombpe1mL3S24LHC2LNxt2IsC0hUg=;
 b=cBWc9OClJPvIqaFjVUo5x8a4ss7y9Q6D/D+KPloZ118y/nPJ2o8no/L0xSNmzdKtb6Jfcb6MaqlT9dom8kQoCs2jF/i/LFXm4HBguG4oy6mmPsU6gzF/xDJ8irk2IFrkS8Kjnh2bXvLpdsrgC+L8BCh0fRzpqz4tQkZCHQ4Yc2yD/DU+v3saVtgGvCrF2ZxEWyZh5u4n9/fOlMcNC1B01XUp2I5zDSfSNJ1RLpuL3Gt14XMiScdwFGvzCCEhoZOR+H1XGjPPyM80p/V5FgGhX4SyweRVSwWUrsX4bkcbgo9G9bg9AiBkUW9nIhHhD2QzG5I8Tm4UVWpo+mrwWjPm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcgCT2Z8fo+N7Fhombpe1mL3S24LHC2LNxt2IsC0hUg=;
 b=Q5DDKtcDNLE8kIcde2+I7sebTLDZrL9+jM1axAMjHBW4+jYe1rVGrtCOOwK2gxuk7zyext2Opt+2pLmMhnZ5AIHr4M2dKB81d+d8BfFwp4kG9zeUSFLCRDMnRG6pjqWQuXbc93c1xeKXrHK5kEJ8K6jWFk27BJO4a/FnqIhlvBhGGSVpJFoiPoOeW9GkPQnmwRQTvJc0CvuFZ+32C7jspf0cV/MsxzsoYwUSdE1NBchUXoCKxwJTvjXyqvsoyKvdOoF/y/RTzW2A1Uhs/oQ1ZPgXEpvK3AK3qoebhZdg7bcfLCJxC7WHPKyH/EcDFsW5OcCKpI9fLNLpDismdCkDKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Fri, 24 Dec
 2021 02:50:38 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4823.019; Fri, 24 Dec 2021
 02:50:38 +0000
Date:   Thu, 23 Dec 2021 22:50:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
Message-ID: <20211224025036.GD1779224@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
 <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
 <20211223140300.GC1779224@nvidia.com>
 <50b8bb0f-3873-b128-48e8-22f6142f7118@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b8bb0f-3873-b128-48e8-22f6142f7118@linux.intel.com>
X-ClientProxiedBy: MN2PR16CA0004.namprd16.prod.outlook.com
 (2603:10b6:208:134::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3c78d8-9f96-45d5-69b0-08d9c6882a82
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB533696E6B7C42E178E322574C27F9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whKNVD/pznbTd0ZXR0nZxS/ILsl9oL5gkhiEDw08CmJ8hM3hx55Vqj8wR3zpZXtfpWOFZr7+9rjKYiaJIFG3SK6N3+r3xDCBaOplvrrH9IjWSRPMJCtQVIpxi3B5s1iQTnVn2I+evOK3DMaZEafP1ombkyIFWbJr4VSbzMtvn2Di4H4hwgf4Fb3AQKTKPeUp7VE4NVrVMAFSi2LeB6v0GaW1lyxCXfFzgfiq6M+CCWi5cI3C4UasrIrQLSoFt3TFlbNT/F9rLfJKlzb2L2htXPHye/zIPMghlLGfySw8zgVF9BLcLe/8exXfty74WABooxPbV/Xkxy8Tyo4cfeks3yMPYAMbXVDua0EvnvVJbwC4zPVAkxa/ouN4PXcGJmFrNjZfIRM4xi4cY3wzTsqln12nWz//pDYiOhdryATfhMsU65usz/H2LMQNCGG7vwdNNLaIs9IhUczvfOatHptPOpr2lODvw3+R6zzaqx1637A0tmEXexbkXSixEjDfFRDAZ2ZUibpVGtq/USJkvRxwJ1XRtiKWa3ptzVCRfspGPPiFXDAmVD5rN50Nhe283OppgQ0rC3flzCAVrZAlDKhVXIg9JK5oJdc2vjWtTNYxppqTp10EpIfxfQKv4HL99PL0ikt06ueIZnPDPejJujWV1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(186003)(2616005)(26005)(508600001)(5660300002)(6512007)(6486002)(33656002)(8936002)(53546011)(66476007)(38100700002)(7416002)(6916009)(66946007)(2906002)(6506007)(54906003)(316002)(83380400001)(4326008)(66556008)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xN+JxGmzyMHn1Sgl56ROULEyf/cVDjbZYECfkhLDIchvkQNUtDlF4F1vTHCN?=
 =?us-ascii?Q?pCyvtVhpHUYFWE7CMVRZ6l6kgJjR0BGxvLKwS9Oz5FyZcYx1B7Syfwugw+Uk?=
 =?us-ascii?Q?idg30uGg8GQKmoitOL2fBliMtjzFon+khLZQLqtrHNEpjh9fRNGhkjtpigeH?=
 =?us-ascii?Q?na2Scy/cMlOFhrlWcmDiucWiwldkhfGdxvTYGqnx7na8KVaosmIGfuaEmalq?=
 =?us-ascii?Q?gN6oJcP8Oixm3glu/XEjolUp50lL36woQHg+LHOAq0ZnrCCXIQbEF25P+/TI?=
 =?us-ascii?Q?N+GtgxgT2iiypcZMl4riHvRoE3s5mXqU1SgkgQRHejxfSlYWsI+pdv3w33I8?=
 =?us-ascii?Q?wV3qzPUYf/6mIdxCabJkC6yjoJUCLYBgHtFG84DxJKfXw08KY/R86es+CW1z?=
 =?us-ascii?Q?qPXu2VEp4s7nPlfZbPbITXn2SZYDprzrNYfvaxrhBDczoFJOxJ3kuVnsEUoh?=
 =?us-ascii?Q?R37mjXgGa4g9vXcd+eQr/t2bGS+LR+QsRtYt+sOUC1ihv+SzfZHCQr10ynrG?=
 =?us-ascii?Q?J+fctkPqC7/H1I4CyOndHPso7biHkjK0z4VLdfQzgFeONt6M4XeTxDCh32lc?=
 =?us-ascii?Q?YOJTlrXrpzyWYOw3vABeYIjFNfSktXuFuLy4b+fDaeWqcpuY8tHMfY+lbMtX?=
 =?us-ascii?Q?JDH0YXWPfxJSmwsxR3mDzzk4uc/aslOGFzH3oHAK6ledHvbB6hPkDYa/WOMl?=
 =?us-ascii?Q?yZtuYgg/p43hTBQxnw3H7tMNH0vdambn4yttYzdmwVtv9juELBDMG1o1P/pE?=
 =?us-ascii?Q?8GFILQjk9w8IE41rNmm3thXO50TQtoMQttuBd9T0U/NAMbLI3sKNausoLj7Y?=
 =?us-ascii?Q?UgQKjWq0YpytCHGj2deoAhKG1I3LV1Z2JnwgL5T/Y4o/i7zIruYSHTYQHgrq?=
 =?us-ascii?Q?10/R9HYksC/bZExazP80wpYQTmf9qLDVImlWoJo7V4F6e7sCFlSYBKdUnMdd?=
 =?us-ascii?Q?AU1T1V6m+/1F7RMdplNIsNOkIhJk0XT2Ru1ie+zqCm6PTlH6Cijk44Tx6QmL?=
 =?us-ascii?Q?IzuaAXTwNoMVW508G1+V8+gNhi2oTam+zyA8Q/P3XjKtfUr6xGJMqafojSfT?=
 =?us-ascii?Q?G9ojaCLv/bY5EQBM5xeaTFnFs8F+dtO1XDuPsjGggmLmhtpvoukVtpANhFWK?=
 =?us-ascii?Q?tjppKpFDA5uR/uteFlcWOdSfHncHsw0GXWJ8tZRWAWUERZ00iA8y2zpflwEo?=
 =?us-ascii?Q?km0hcvCk9D76In3fgz/rHRluyLuI1ilTuCCowEWmrK53DD7GK22Bp8XH9a1R?=
 =?us-ascii?Q?HeA8wmpeJoGTd1G9/9MolUoGvQCao9GuHeByM7EiBU5NO4rUsAcIebqOBcao?=
 =?us-ascii?Q?jPpXqVeuQMizM5lUQXyscmx6ivV+TupjRWYOB+njfVUqLbY7n9G017xVHq8A?=
 =?us-ascii?Q?J0LhIly6koL/awSJ4GNOBDNvX1W5h8KKuvqq6G2IlZED86EvSvVxGwtBmf+2?=
 =?us-ascii?Q?NIKgwWRGTGq16DBUo6g8HVlT8joaFSIaiLccwBV8M6EgMDQdio6/MK7IswMB?=
 =?us-ascii?Q?hn6JZClE2LcIE858J8aWuzojch4nj7mjOZ44gFWf5ecgitL09PsawjrA5Z6v?=
 =?us-ascii?Q?AVEh+ZshDVuhYAo8Lnk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3c78d8-9f96-45d5-69b0-08d9c6882a82
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2021 02:50:38.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTz0yz5t/XzwnIL/LHm8GuyRdTG6/pRS6kbdnEcZtp3B44/N2VVLaCPyjfUcAbQp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 24, 2021 at 09:30:17AM +0800, Lu Baolu wrote:
> Hi Jason,
> 
> On 12/23/21 10:03 PM, Jason Gunthorpe wrote:
> > > > I think it would be clear why iommu_group_set_dma_owner(), which
> > > > actually does detatch, is not the same thing as iommu_attach_device().
> > > iommu_device_set_dma_owner() will eventually call
> > > iommu_group_set_dma_owner(). I didn't get why
> > > iommu_group_set_dma_owner() is special and need to keep.
> > Not quite, they would not call each other, they have different
> > implementations:
> > 
> > int iommu_device_use_dma_api(struct device *device)
> > {
> > 	struct iommu_group *group = device->iommu_group;
> > 
> > 	if (!group)
> > 		return 0;
> > 
> > 	mutex_lock(&group->mutex);
> > 	if (group->owner_cnt != 0 ||
> > 	    group->domain != group->default_domain) {
> > 		mutex_unlock(&group->mutex);
> > 		return -EBUSY;
> > 	}
> > 	group->owner_cnt = 1;
> > 	group->owner = NULL;
> > 	mutex_unlock(&group->mutex);
> > 	return 0;
> > }
> 
> It seems that this function doesn't work for multi-device groups. When
> the user unbinds all native drivers from devices in the group and start
> to bind them with vfio-pci and assign them to user, how could iommu know
> whether the group is viable for user?

It is just a mistake, I made this very fast. It should work as your
patch had it with a ++. More like this:

int iommu_device_use_dma_api(struct device *device)
{
	struct iommu_group *group = device->iommu_group;

	if (!group)
		return 0;

	mutex_lock(&group->mutex);
	if (group->owner_cnt != 0) {
		if (group->domain != group->default_domain ||
		    group->owner != NULL) {
			mutex_unlock(&group->mutex);
			return -EBUSY;
		}
	}
	group->owner_cnt++;
	mutex_unlock(&group->mutex);
	return 0;
}

> > See, we get rid of the enum as a multiplexor parameter, each API does
> > only wnat it needs, they don't call each other.
> 
> I like the idea of removing enum parameter and make the API name
> specific. But I didn't get why they can't call each other even the
> data in group is the same.

Well, I think when you type them out you'll find they don't work the
same. Ie the iommu_group_set_dma_owner() does __iommu_detach_group()
which iommu_device_use_dma_api() definately doesn't want to
do. iommu_device_use_dma_api() checks the domain while
iommu_group_set_dma_owner() must not.

This is basically the issue, all the places touching ownercount are
superficially the same but each use different predicates. Given the
predicate is more than half the code I wouldn't try to share the rest
of it. But maybe when it is all typed in something will become
obvious?

> > We don't need _USER anymore because iommu_group_set_dma_owner() always
> > does detatch, and iommu_replace_group_domain() avoids ever reassigning
> > default_domain. The sepecial USER behavior falls out automatically.
> 
> This means we will grow more group-centric interfaces. My understanding
> is the opposite that we should hide the concept of group in IOMMU
> subsystem, and the device drivers only faces device specific interfaces.

Ideally group interfaces would be reduced, but in this case VFIO needs
the group. It has sort of a fundamental problem with its uAPI that
expects the container is fully setup with a domain at the moment the
group is attached. So deferring domain setup to when the device is
available becomes a user visible artifact - and if this is important
or not is a whole research question that isn't really that important
for this series.

We also can't just pull a device out of thin air, a device that hasn't
been probed() hasn't even had dma_configure called! Let alone the
lifetime and locking problems with that kind of idea.

So.. leaving it as a group interface makes the most sense,
particularly for this series which is really about fixing the sharing
model in the iommu core and deleting the BUG_ONs. 

Also, I'm sitting here looking at Robin's idea that
iommu_attach_device() and iommu_attach_device_shared() should be the
same - and that does seem conceptually appealing, but not so simple.

The difference is that iommu_attach_device_shared() requires the
device_driver to have set suppress_auto_claim_dma_owner while
iommu_attach_device() does not (Lu, please do add a kdoc comment
documenting this, and maybe a WARN_ON check to enforce it).

Changing all 11 drivers using iommu_attach_device() to also set
suppress_auto_claim_dma_owner is something to do in another series,
merged properly through the driver trees, if it is done at all. So
this series needs to keep both APIs.

However, what we should be doing is fixing iommu_attach_device() to
rely on the owner_cnt, and not iommu_group_device_count().

Basically it's logic should instead check for the owner_cnt == 1 and
then transform the group from a DMA_OWNER_DMA_API to a
DMA_OWNER_PRIVATE_DOMAIN. If we get rid of the enum then this happens
naturally by making group->domain != group->default_domain. All that
is missing is the owner_cnt == 1 check and some commentary.  Again
also with a WARN_ON and documentation that
suppress_auto_claim_dma_owner is not set. (TBH, I thought this was
discussed already, I haven't yet carefully checked v4..)

Then, we rely on iommu_device_use_dma_api() to block further users of
the group and remove the iommu_group_device_count() hack.

Jason
