Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC41486F95
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 02:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345102AbiAGBTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 20:19:34 -0500
Received: from mail-dm3nam07on2079.outbound.protection.outlook.com ([40.107.95.79]:35937
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344075AbiAGBTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 20:19:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJ2TKwEcqW6JxhEYvitExCu8G8Gii0xbrkwIh7KvGn962ri6Z+Mz5aqC/tEipO9H5ONdGoc0ZqurBin+/ktRUTDfW72cgerqV3kwGgyYfdHco3PXYNTRTdDyOs7sU2SBvDVO4EWNNB6Ixd92VhkaYtM/yGi6f7ZRW+kMk+6IVJHjIXaVc+wiW4KwOwjfsojE3et7In8f62S0FzDlpAjbf7H0nP3BaKduxkVzT1Emp4YNVUu6GxU4hw1mgEoPDdNTatNvW97A/uJAXqYWaTHvE+3lfvDC9ghS0JTtd6iBqeZyxJz6YqehGOdKY99WpOrT/BDmbdOQJKYsDNKdISqEmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9X4Pig7Bu9n5XCLsLMD+kw0r8y/2t5Hf/AWC4mkho/g=;
 b=FLlECGY5HpRVw+USslWCs2OyrI4p07tSRqneAcV5enqWsM/hPFlMJAbmPjPVrgLOxOrUR9EG4waxDJa9PK5iAcOln4A516eBSGBeBU/6358oCkA3t5kZZ6BClzEjBo0IdzZIizf69ptH6glLnFpetfsnjmSNRWjd5G7MgcPHE3fokMrEWml43ClxvAyuZhAIrnEkyvdFg4g118cr9Z2KaKxALbACce91yUO2DKGioKzDM4MlZPJJ+EdggZT0vEpPgFX3e451wZTiLK+BSqV/sbMWAYXcZ4EsJcYombwjqFxPVH/ZngG4YJgCYlLK4sYXb7AfKUiNO+YpR6LQF7EVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9X4Pig7Bu9n5XCLsLMD+kw0r8y/2t5Hf/AWC4mkho/g=;
 b=OGrejDEkBDsjb27lvkqnykg1+YcZrQIN9kA1CSKcTScU3EHKit7Bkwd+ErzyOHbvK1mV+1g+iTqPLOQy4ERvcQL1+GzCZjddgQ83xYDhSSqCX5S+3ZydmZX9lnw2gBwrrQ1O1dZWyYUCgI/BzatJOFzLMxHrhxRbZ3jtTzOsx0KQUUriK2WjLPnmrxG76NkbF0zPfVn9BrhSGlFcr8HZuirLIDjNYc+aknDMzn9tL4al7E+VYHWlChvPmjEMwcrzrWPydOhdbjzj7HFLTnwZ3XOUh2Uo8GheahtPYvlp2enIJqaFRWmYPaVgBRsqpVE0gpKFh5dx3VIb730eQPpLaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Fri, 7 Jan
 2022 01:19:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 01:19:31 +0000
Date:   Thu, 6 Jan 2022 21:19:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <20220107011929.GQ2328285@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <20220106172249.GJ2328285@nvidia.com>
 <ec61dd78-7e21-c9ca-b042-32d396577a22@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec61dd78-7e21-c9ca-b042-32d396577a22@linux.intel.com>
X-ClientProxiedBy: YT3PR01CA0090.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 065c5391-ddc0-4c7a-28b2-08d9d17bc1e7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5379:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5379FC5EB482B22B26A5C7F5C24D9@BL1PR12MB5379.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HGhPvSST4nOovEtTeoFcbQ0TEZxnGDqKpeacRcMwhez2GeejPjwOHIBIE3xh6IFOcO7+le9Un0sdnP60vQLlrpPRz8HA1AzusD5flRrfdp2l/CAkuBXbDwPpG14ucfaESD7VNeAP2hntinPE/fJNER+V/Psvs/IvdEXrCun/QfbvT1gM1JaH3U6ep1Ibgo8FpEoRPFCxS9q7+3mpko7y+pKgwkyGd9248DM7QayrG2I/kSFrh1fYZMXRIF46KcYpqCpg68Ym+JcxYSUiNu4jpPmikGIM3JBKrxVyk8ADqYZ38gDPMF8q4qC3J+hxaC7LNoKbasAi4EDzgOFnmwlt3kPQWh1ueTvCV8iEhNqmDcMQe3X4pFDMaFuCt5KGHbpu5cyzm/fjHiD8wJ4lBNkNKlrZ0Qn7NL2HSDO75QXUNz8OdYpUkIpLrGojlts3/XHEOT0mgHQ+dhnviDdUNklhnax5G7+5G9RqbUstkPCyeWuRwzJj+slQ3ISG/uqmwC2tGDb7v9eRL8ApXcjXcOVCv7KphgersTtuS0gYXwgi2AooNjMpmkcnXNTzUkjzKT81ptm4zvYpEho9xTwaWoKtPr5q1QLCEVGN+XiJOm6sS5nr0rXYiYc6I6S7a0iaxmluOvdhlbjoucwCVspaaVEmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(316002)(36756003)(4326008)(6506007)(26005)(2616005)(7416002)(6916009)(6486002)(38100700002)(186003)(8936002)(8676002)(54906003)(66476007)(508600001)(66946007)(66556008)(1076003)(5660300002)(33656002)(2906002)(86362001)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7LVNNTekpZwTZP2Yi3uCCn2q+ffSgMt2kVn8xPs3oXwrxdIACWTPz+VQmVq?=
 =?us-ascii?Q?v4mS0Vfiv47+M/1a79AMyxKwChHZt4qzBJ+KTWgh+0LhVeQpWZfXsiz7ZCyQ?=
 =?us-ascii?Q?jEVFCa5ovSsNFvQlfQTQdoZUTJU19hP+Z5aYrkTLnDYETPzFDqg67pCagZYm?=
 =?us-ascii?Q?PxkJJPuyI7i77k8hXiXwVZANGEI+buvXDVmXcDwrR8cMeSsmih1S0+0X1f20?=
 =?us-ascii?Q?zL7usjiTrb1UkNToVdSVN+rBv2hOQVJn4/zMmL3iZSLDYuW9WAozzeD3VW++?=
 =?us-ascii?Q?Qno+PpqF1KYq7uRqnS4bSqQHl7e1x8YN7lxzIgeI9DWGNm37qUVtkY7Ucbqm?=
 =?us-ascii?Q?lNMMCfRhbvyVYXkJQBeNQKsAftAh4cx3AI+/BIsurAG3JefiRRckh7T8tgrf?=
 =?us-ascii?Q?V21c4qG0QmFkn8sN4rmQeVeIIFgfHvPl4cHzrcgydh2ybehBvl/MP+hE7yNr?=
 =?us-ascii?Q?A25Ja34XOB7nNC/XwzV0HbtUOdTIvgCdzXL2B5A9gvBSaD7GICOfWSiwaCAF?=
 =?us-ascii?Q?QdPbWbi6oNr0H3MUZtkWnXsmYSKs8MmLFC3rQh6qL2mDGW0sCkiYJpaVUOvj?=
 =?us-ascii?Q?c/A9o6IVHX7BJCplGQrfeSl0wNVN39qD6mi5tg/KgqBy2/gRwUmf5YnUpoY2?=
 =?us-ascii?Q?edj8ByQxNkhF8Cg4RSxFVQdHLyEczqSVmWQk2fdq1c9v5EB+wBWjzSbMLA5O?=
 =?us-ascii?Q?hAnRBZbjdVlziYZgi7HNUKMubsTSb8at9mvNH1HM2NAsbHzyNLMHjEupIIgC?=
 =?us-ascii?Q?rnG5WoDQPTQoadBBU+i8hPm3kgU4lfdvH45BPKKk9SiYQ/pBpsYdHpsLVIL/?=
 =?us-ascii?Q?YhIEoXGwJc1o7TUZOygOVlQVnjP6VLy2b3JlD+JUIXLXY7RToHrJGQPl0L5X?=
 =?us-ascii?Q?ZUtCSzifqrx1xKraCDwC+2OyL/P03gXwfwPX+ZK4/ntIDZFvc/01DDERekku?=
 =?us-ascii?Q?H4ls/iuKi8xzKrYtKAVxdgUJ9oc5mLBHxaMN5VOfY6fTt1XWvW4bi+Fd9mPA?=
 =?us-ascii?Q?8OHIMjxbRASeBvbaTw/XImTlyQBYcD2Ak+40szLqXCIK65MMmmZjZKVxs/b+?=
 =?us-ascii?Q?WOuVBlMWP6z0IU+WB3UuE1TZX111E56opRv6MgWxLZ5SAkzq+QwIlbaPHvXX?=
 =?us-ascii?Q?E3XIFSDV2pEvqPIe7gtoyyzhHfotpmdWskHaRlEfe3dr2kS+gP1x2wJm/ysv?=
 =?us-ascii?Q?NswfG2ZTLN1hB0hrY1TUdBg+AE2StW9PBj79IrYzle/OB60YEqmyMizu5Sl7?=
 =?us-ascii?Q?D5jvepXlWe8/K6YsMFMCFBZrlPT23KHlI6+smf5NKoXkp1qbrmBVun4S0miC?=
 =?us-ascii?Q?w/QooqikF1BdMrz6fRilstKxECwNUAbq5XK8EeHoQnq9ZOhxwTWfe4nW+5rb?=
 =?us-ascii?Q?JVK0oTgd+dJ+XlNwc2rW69lR6cS5pZXw6ujpfcn6qaLRTenU5eRLffpGVIpz?=
 =?us-ascii?Q?ocrRMNfwbq2ZDsuhLLOiWvVtWqstxRetMcBn29OMcuRxujMIh7FRNASlh2/n?=
 =?us-ascii?Q?yV35F2OrDnNpJPQjIW7TNmCKq2x2hq7LQrRKGFYHZUXVQh7LPPpOg4rFzs9o?=
 =?us-ascii?Q?JlwPeaBS55K6V/2B2a0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065c5391-ddc0-4c7a-28b2-08d9d17bc1e7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 01:19:31.5845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2Pg0gANPZFi7UF9Qv/r7VryAiETQV0INGaMHa9hc6cxImcln87zBEzArIbbrZL/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5379
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 09:14:38AM +0800, Lu Baolu wrote:

> > Once we know our calling context we can always automatic switch from
> > DMA API mode to another domain without any trouble or special
> > counters:
> > 
> > if (!dev->driver->no_kernel_api_dma) {
> >      if (group->owner_cnt > 1 || group->owner)
> >          return -EBUSY;
> >      return __iommu_attach_group(domain, group);
> > }
> 
> Is there any lock issue when referencing dev->driver here? I guess this
> requires iommu_attach_device() only being called during the driver life
> (a.k.a. between driver .probe and .release).

Yes, that is correct. That would need to be documented.

It is the same reason the routine was able to get the group from the
dev. The dev's group must be stable so long as a driver is attached or
everything is broken :)

Much of the group refcounting code is useless for this reason. The
group simply cannot be concurrently destroyed in these contexts.

Jason
