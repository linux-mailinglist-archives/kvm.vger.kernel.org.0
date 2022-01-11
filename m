Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D28A48A43E
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 01:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345861AbiAKAR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 19:17:56 -0500
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:29665
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345849AbiAKARy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 19:17:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYSzzcu9r2eYKNs2dAxsY9qeztOLE0akvsvdpuoxf5uVQ4NiIagAvjpSq1FUQNwA4LN9r+nndvyI0Y2gREK7D8dKeD5dgJjUgMWGnU5Hhmw1rvTtlBwIOCOH065xOfTJ6QCPNPr2fJ4nFx+jHfqBphOmuyidS+96Z14gXNUHRjHzR/0qZlpSBkq5ecRzK0sDZAc+JZMau1CliT8P50GYGH8j3FxpoKwG7CblM6vJsLP4/Fc7t3TeIgX8agDsTCI84/k4HVJxh5Kp71ah6C7Ymwkk1dPXYC4PtI430s1KpD2wUucaKAYskTpwihp5vqMeK250D+AqYrcDhqoX0LJtBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MUCI11mOLwo/tYd0941ecqziC+8FoTVfhL59UDjUjE=;
 b=VUPODcHgaC+Ufxgw0RRclQ3BUk0XRE6TELj6Iehe6l7jsNRXr8YnyP2LX8BqWuR6aHSIGESU3NypdQ5Zklyk9dbvPjSvL+MzXmqD1QgES1sTd6X+97iSznBY8U2d7Yrs9gqBoW7jd6fVb7cXatDTzV9rQyJ0V9rU5XOCr/iicJxT+xPYeKRZribopX/THu033u7uuMaTy+KQeHu2lrv31aIkX1pMWIzZQNcZ3m1ONilqTKV91Sez3F6zOOOLsc2TNYle9htvC7smJf5LmvL27uoC7jXLYfiNyDkYfjCalgWhjNUaMcNaahzo5B3umdM4nCDVDcL+kNiuu/+ADOagcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MUCI11mOLwo/tYd0941ecqziC+8FoTVfhL59UDjUjE=;
 b=MDAFOsrn8cAmgOfUMbmSboUL+ORZ2Ba8DKIdfwo9B5rNxW16UWDi3oywXdDO6FY8zu371iMtaDl6ND7VidguUI+FDFNV5dsQkk27Z8W89UnlCPA+dbklXEKiLi6biWBCwObdwTCUYbfjfQbUSbl65c+YQnT1pRtzSNwyIKApHgCP00qyoL530u0AERg5+MjAJZXMchXddtck548MlqCq7tuJZkvTAGbYYeVp0eJXt7TjfbbCW1wsO/qORq6/KCMqT6DRCgat+Mvdm6YNQuDBAe3Sc6CImCzJDqIqPA6e6EtC2v/W0YkhRV/1ffsFGILxda3pkBu4PB5dxWJYPgljpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 00:17:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 00:17:52 +0000
Date:   Mon, 10 Jan 2022 20:17:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Message-ID: <20220111001751.GI2328285@nvidia.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106011306.GY2328285@nvidia.com>
 <20220107030330.2kcpekbtxn7xmsth@oracle.com>
 <20220107171248.GU2328285@nvidia.com>
 <20220110222725.paug7n5oznicceck@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110222725.paug7n5oznicceck@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0033.prod.exchangelabs.com
 (2603:10b6:207:18::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 103632ad-5eea-445e-f0ed-08d9d497ce92
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52538D28AB11D68FA67DE1ECC2519@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkW8varw/EAnTjfDndElbk2K+ZxDKFXDWjgtMDniq8N49AMcltwitwglha/SkdYitu4kDY/SDi2mNY+oH4lgyeA+ZEanoME0U0xocRPKW7kqFZ6vlYt8AShpa2oeNb9BibElHD4Mdnj0c1WU1gdI6G6vm4HRKy4zR+BCGwvCgtinaatRbZul4+k8yekGpDaHO94vmnPAvBePIeEO/0BNSEt1ubKRVSOFArMU/nnRwfMfM+Oa3h4MzA9zcdvJuH0cAiguIVTs/MOAX7/AfNuiA2ilpKmD5mc49UCHf6DXTQCraGPryqX0n33WNfZbZ9sahHBpXBAA4jOV2pIADzDhhj0ufe1bXl+EJMDMXKXz05Sz2hlQU79xYZvLCR/GItdjZfTxt3hVvKgEiyErc0ttFr5M6scvdpGAt/vOTmR5GSDo9BPGQwBY2nYB4aFzIHkAWS1kTLyuXqp03ybm+mI4hZ1Jy8nSZATw3CY+CsoOsshZ3UVwBKCixa3SFSV64G6DzITcd2VkQ3vfBlJWu8dRl+nTn/lotn5RQPfgTFEAqgxB0NZySe9GwG4fl9G9fHT+0TK++aSdTuOzTGWgrmDdXzgIydISIGQM6tjWnDflh8a25UEoYLSN40FV2fGvrebTRBpjsbYHHh2PR77gS9KxQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(36756003)(2616005)(6512007)(4326008)(83380400001)(54906003)(5660300002)(66946007)(6486002)(38100700002)(6916009)(6506007)(7416002)(66556008)(26005)(66476007)(33656002)(1076003)(8676002)(2906002)(8936002)(186003)(86362001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L2kowSqlbhxAZkHbbWGM19fnUS33taYHCAdd6nSRHCqCsU4R1ym0PuVDW7ep?=
 =?us-ascii?Q?tSTJ3ihc6nYHn9usOOlBA8aTfD2nft5pmMRZdBYcsWtSGh/rVkiR/gNHsbe+?=
 =?us-ascii?Q?hLb/FPmLFRR0P7INRtauYkt6TtORfNdgBb/UCvXNCLHHDn5JBILhmIPEtJC/?=
 =?us-ascii?Q?psjfhnAdVJ5/NEVmR0pSiXRsKgTHbILz2itAjw+/j9hBEkTO9klzuh0faPlu?=
 =?us-ascii?Q?dk4hgCm/rLO4WUEnX4SqgQvgY8xgz/zxkdjkT3qb9cx+Og2OZCpgPfJiXaof?=
 =?us-ascii?Q?QdYtwA22xLT0MWsNWglcA1IXHOUsHlOOfS8nxg1bPk/oTK27/bcQmT+Ca57s?=
 =?us-ascii?Q?WRY6kp0x0BZcfE3450C96vfR5RdafSN6D0eedH9FEf0WB7FV5Ws8Rs7m5Qia?=
 =?us-ascii?Q?cEdKsS3WS36AGmuoJQzFXZQJ7D5zOAfhRZKm5L9hbAGk8HhKaZVtOajGx/Ur?=
 =?us-ascii?Q?75RIl4XSzjQLui/bmjBWp0pNOQI2jeDBXRQFHL7lJDgFEM9IarEnlVNfbxFA?=
 =?us-ascii?Q?Hsq6qHxHD7e2sh3qiaEjmybA6SQ0e03yJ0Xc75/nTiLFrMKwKjX32E0d7gCe?=
 =?us-ascii?Q?kYLyfHPGworuPtWiIuj/ISoYF/fkm2tiy7T/xg8LZbSgHRV2vHY5jzu74gfH?=
 =?us-ascii?Q?L4XBZwwBlpwULCt6OYJdU3CMWfdrKD7/PP+eTICjmHrrPvLkWZT/RkdJI9YY?=
 =?us-ascii?Q?THr/Z0YGBEbYbiOQeiQCQMrC6co1heR2f2ZOFwhkOJBhxxXsKkRCEEUUI/Al?=
 =?us-ascii?Q?HKhHmk75NiGWj0qVzajmNKXatYC+FUv2u5Rb9uE5QpIMVBXRyokPfpD44no8?=
 =?us-ascii?Q?cmXfKOlEv7UMBE5es5jAYgQ843HOpMubfVh7FXKdma22Cz5VLDonMkGIUQfA?=
 =?us-ascii?Q?pmynFDj53Vdk96k0afeVFbWBIl3kFl7b3zKOgiAkmV28Y66vcbL0JqCKrO8/?=
 =?us-ascii?Q?lZTnT5vnEeqEK2AA/U+EMUhJzheCe4+VDFzv23QStzJjIsOD5zJVC8hf7uz/?=
 =?us-ascii?Q?6VMaTR5XN8OeaOrL/VLqvALTmLzMY/VZbHW8cf//w8rynwpciJ4/MLnHuhxN?=
 =?us-ascii?Q?fXbGjLcXUrox9HqSw/NFt+yNx6Lb6rm2Auvnj+nkgQoi3cjGiCr/GLyMyBSi?=
 =?us-ascii?Q?b25uWPLHTtuF6aXgltHRXdwd6L9d01JfKwTu1TB6l7fAd8kfBmFqSHL5QRfL?=
 =?us-ascii?Q?WdH8LqSFGQQBeF5PmZbqRkR9c06X32Ib8CKEVYg2F/guRwAnirS60IvaBv02?=
 =?us-ascii?Q?DJZfAsHgqpn8QQhMoHGLzkpx71OcyNxinDWnWUWR5ijwIiwb+yzTly0HTgpN?=
 =?us-ascii?Q?x3JzF3xA4H1NcW3a8xXAfk0bb4TJ1eboaPk1zK1wmP2bUeYS7Qmd+/mnZ/UI?=
 =?us-ascii?Q?7F5pwmv1LvBv8DQPyH4t9/PQwn8lFaiO6N+Dt9At9H3KjJKVKCmrlF42qfR8?=
 =?us-ascii?Q?xVFIm8MAB2NZA4kzt4J9OtGXD9UyjpqaXCbYbiODxeM+ROjjExhBq11mxGuO?=
 =?us-ascii?Q?kMFW4BzDUr8Q0pTcFMdJNQuU3JhndAf5eR9NcvDL7h78IglbOsE9w+7aIrit?=
 =?us-ascii?Q?SQQ3IDvZ3BhyfQSU9fA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103632ad-5eea-445e-f0ed-08d9d497ce92
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 00:17:52.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 036OsMzFCHOHyNo+4uNyxhqFLNH2xjHDbxlglId9cGmHPcYslfLa2BuVD59lTXDZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 05:27:25PM -0500, Daniel Jordan wrote:

> > > Pinning itself, the only thing being optimized, improves 8.5x in that
> > > experiment, bringing the time from 1.8 seconds to .2 seconds.  That's a
> > > significant savings IMHO
> > 
> > And here is where I suspect we'd get similar results from folio's
> > based on the unpin performance uplift we already saw.
> > 
> > As long as PUP doesn't have to COW its work is largely proportional to
> > the number of struct pages it processes, so we should be expecting an
> > upper limit of 512x gains on the PUP alone with foliation.
> >
> > This is in line with what we saw with the prior unpin work.
> 
> "in line with what we saw"  Not following.  The unpin work had two
> optimizations, I think, 4.5x and 3.5x which together give 16x.  Why is
> that in line with the potential gains from pup?

It is the same basic issue, doing extra work, dirtying extra memory..

> > and completely dwarfed by the populate overhead?
> 
> Well yes, but here we all are optimizing gup anyway :-)

Well, I assume because we can user thread the populate, so I'd user
thread the gup too..

> One of my assumptions was that doing this in the kernel would benefit
> all vfio users, avoiding duplicating the same sort of multithreading
> logic across applications, including ones that didn't prefault.

I don't know of other users that use such huge memory sizes this would
matter, besides a VMM..

> My assumption going into this series was that multithreading VFIO page
> pinning in the kernel was a viable way forward given the positive
> feedback I got from the VFIO maintainer last time I posted this, which
> was admittedly a while ago, and I've since been focused on the other
> parts of this series rather than what's been happening in the mm lately.
> Anyway, your arguments are reasonable, so I'll go take a look at some of
> these optimizations and see where I get.

Well, it is not *unreasonable* it just doesn't seem compelling to me
yet.

Especially since we are not anywhere close to the limit of single
threaded performance. Aside from GUP, the whole way we transfer the
physical pages into the iommu is just begging for optimizations
eg Matthew's struct phyr needs to be an input and output at the iommu
layer to make this code really happy.

How much time do we burn messing around in redundant iommu layer
locking because everything is page at a time?

Jason
