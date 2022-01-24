Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF949875C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbiAXR5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:57:17 -0500
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:21088
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244534AbiAXR5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:57:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo2bEVWUo/+skGmfjo2Aa8b3bfrtAnJ2SxpZo+L/Q1VwfH7f8JENjZcC5IIu8CKLPvAkzGbDnCt+qzovyFFY5RWi7WkgA+q/bk4E4UWo8zCggnIFZIY4qNgza/HN/kBsfs6saveP68utdbRejcnF+lmTOX8P3J6g/Sf4JoEB5/d1FXfZEsiGItxeLAowZO2B/xgNIA1m5dxtoTUjqnLomGhiayiu2f02G56iDYV1zg7lhy3hxOY5gx7+VmMEX2u9/aC4gbDMFvuOxx//poj0hCTlWfOTggvahqFq/WD0x2Sa91Cuw6/Z3mbqfEr/EF5xpl/kbXn5VmUDETvoUXXxnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBKefysRSB4qMqXWg0GdwjiostldjogtGTiaQkEZLxQ=;
 b=mxWG94922w0dh87ESxOn97jX9As6iZ9IfcP7VwGzZ2/BNrj+pFpCbV8998VQ4e7IuGsvIN2yC+lga2VSHDqZxyE6P+iwHfnpF3E7Rb5BFUDKMPta2H85z6aVpPsoOV8SRMHfL4YcNU9oV7B0cjdlk2dw31B4o58fCiy0WeyveKpkDMfnFH3hoMnRMl4c3NoaMCWHro5Q0wG9OR4JMcY06c0sAeBf8ONGppVxhnO8nQlwizWiZEDacwMh6hq20NFq5SxoKo6JE1rtU/hXpwGzjQwk/qLnpVw66uBGl5f/iO8O922CsH3aMKcaNsQ5irEQACYS6bX3LAVYzBiDdVn49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBKefysRSB4qMqXWg0GdwjiostldjogtGTiaQkEZLxQ=;
 b=WunjWke/MWYnKlvYLsfPGqbHDbIADNcuePpyiSwda1p64qL6fsRRNAUtCed5RHmWx9rTbwL5nEYgaL0s+kHiO+5plJgg+b107UY5W6rVyUZwdtFVy90VXsAMGz9yuBG+nz2JWX6p3su0R4G8CKfkXgOEyqIN/0BU6hQ98tjlO/F9J8SiputVEPDJQ5MomC3ckAbgc5ZKcuCsY0i+1xVISXAfQrvZKJ2h1r7V1DdYjf4spEgatv3Q6ly+Q5nz6ULiFFEb4xXuhIGeiIh6JP0GpvnVooxrR838i3lDO3i9VH0Ke+yy1Celh/gcBf9TSSNpTVUDeBXW4UF+NDPh6gvMJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 17:57:14 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ad3f:373f:b7d3:19c2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ad3f:373f:b7d3:19c2%7]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 17:57:14 +0000
Date:   Mon, 24 Jan 2022 13:57:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220124175712.GB84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <20220119083222.4dc529a4.alex.williamson@redhat.com>
 <20220119154028.GO84788@nvidia.com>
 <20220119090614.5f67a9e7.alex.williamson@redhat.com>
 <20220119163821.GP84788@nvidia.com>
 <20220119100217.4aee7451.alex.williamson@redhat.com>
 <20220120001923.GR84788@nvidia.com>
 <87fspdl9cv.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fspdl9cv.fsf@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: accbe4d0-f806-41cc-beb6-08d9df62f3d0
X-MS-TrafficTypeDiagnostic: CO6PR12MB5443:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB544380A5DB144EEFBC5BF44FC25E9@CO6PR12MB5443.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/9BKUCqVO3VqwEIbKTA7f3AfeAlfEwMWhmdnV+jMOVUMfINWoJU28tH3HoIor/Bv8PnqPDR9CgWXWbzVSI7gxHUfpsCc50eHN6HGXeFHbsd8hAM+97N0tvbxV6SuQtpiQRv71PANzOHbSRZQ9Z/qI4jkMbCy4o7qtXQeKBuVFV2a1tmuB94pJZsIrDjSqRvGb+SGXtFi4UOXv5y94BvvFq7dHn6t3UHHiAkURO2TvLLjJK0DjAMLLv+/h3htPIar3UBDIK7Iq/m9VLOtsOVb2PBpXkfvFBwyXB0Mh76zcnFSZAgSpbB3/0TTKRDfuOk/GhlnNBiKZAoG/ETNUYrBoPHSG3yqcLXr62+zGcQ5sx4oYbSm89gmc+7R6qyevCyfpPp9zn7dG5VKnbqNzmiwu788r8gB03GzXiWJeANUncXEqt/B4aBWoGWfioMEBZoPGsxcdpDldBu921vGckUrC8LswghW5/LXfs8Tjof62ZLGmN0n3XGFwyJ3JlUeXU+WZVn9sv7jfpz23vnSZBR+eGFeVAwWrzSZSknO7Sra6xQeGb2KQYqC71wVM4jWnIAu8YoyIERazj0HuO7YlCUKBBXe9xLo+E0qcq5KdRBl/qTh4f8Ljg/EDEX8/CiqTIG5Ws8QbBd2FPOmHv0vgeDulOpjvnonq/XVahKBiuM6pwngLQLVqYNbRakUPIxUPHu5Oczrtho4NVpIJRNZQh4f8gcEuj1ma8LukhKL1D29A4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6512007)(6486002)(33656002)(966005)(26005)(6506007)(54906003)(8936002)(4326008)(38100700002)(1076003)(316002)(2616005)(36756003)(107886003)(66946007)(66476007)(6916009)(66556008)(2906002)(508600001)(5660300002)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alJugEeTYE+Tqzz69iWqCIWl6keNTC8apeA/UbTVhiN+p8oRaQtab9/ydiuZ?=
 =?us-ascii?Q?JXs3syl3VyWGFtsbJgWFK/Erv7vjjfO94Gs07CTn/aazDlD8xIXlvO2KSj6b?=
 =?us-ascii?Q?UrsG4LLRqndkRXkgGgCJDPgSZ68Hl3l7tjjeJa722lunQIDlbcax+kMjdRbW?=
 =?us-ascii?Q?Lg2ER6313LYBWyRuOORXFXlBs/U3RLMZukA+rfnnaPUHqdmR0CnFTYCxhAHS?=
 =?us-ascii?Q?QrKOpBgvmN8GDzD4y8/nqOFce/9bJysW/XowNu0WLpyK9D983YYUky+rAs2H?=
 =?us-ascii?Q?DldYbe2E31OqY16I45RCoBxzfZnJJqcFeg5pCxASG5ly4j47knDIpzy3cUqL?=
 =?us-ascii?Q?Bxi99prbo12M3YEAYTnazJx9FUS5zLKXezhRrsQ3SMEsHH6z1k5fVnC4i13i?=
 =?us-ascii?Q?geiX5sX66WfnVDhrcb5pITnQQAwkPtigchtDwnpSECu4pIvoNQLwho9ZkAAb?=
 =?us-ascii?Q?VqQCeeR8DdjRY6kPol5340J7E23T0NZJEjxVaKchSBDLvuLfbqArAQ+NHzxP?=
 =?us-ascii?Q?fCyqiTklFi04m+XpXnrmNdeGTLMV04wZo5IyI4beH4dEyjQiL1sUYsKzB+tJ?=
 =?us-ascii?Q?Uu000TRr/yGR31EtNaBTOeRlSpunNLo8Qyss7QaXgka3K+OnmE2JlWrbA3VC?=
 =?us-ascii?Q?ndwWYCo6sBBI3NTCFvEZWUwNyVLpoovu6sbwQyJqDPIWITq0hi2K/KD7qP9f?=
 =?us-ascii?Q?aY7IUoNm5OhKDHyAq1YZHB4MPxux7cE7U/zrN/YHFeHikB/uwMzsDgIeaITb?=
 =?us-ascii?Q?inQ71D7arylzQTACsbCiwpzIhADE9ScPzjDGDGur2TIoIWIyiRAG34sQTFNc?=
 =?us-ascii?Q?KtF8sGyzOQjUE+sIvEl652DkvHg4PiKhXEoTCqIfl3KlKASr0Ve2Nzl0/t+Y?=
 =?us-ascii?Q?d0Q7C2/5UcKklAjMPrwfEP1tIvM3bpSFdbfHKGq0i4aOVuWZmUD1mCuH//uk?=
 =?us-ascii?Q?RFIpV7nurMltg5ivuXvWzrBsn1uWmhtJG6VJSPR7TnofUpEOewfGPuobVc0j?=
 =?us-ascii?Q?Bg7wTuy3sWUSzmXR7Tmi8aXvWaltddbdFJh3xNSSK87AGmYpumC740Qnhr8l?=
 =?us-ascii?Q?fMqBABs3XeOmYzoWvj7Libmp5yTUSoZdl7imr/nlB87//ffEYdga/huyNAEP?=
 =?us-ascii?Q?ceuU9h1mX8Oolyl64zEZkn+OkPLxX5wyyukLc6WZL3qWGYlBG93XlS1zL1zH?=
 =?us-ascii?Q?3sZlhOsfLxyB/kGpvmBYxOMrznqAWarAGPq8PIoThyNQCqJTn5udisn5d++P?=
 =?us-ascii?Q?4aZNSWHtMQlIsMLEZIMMv5s09dITMMDsRC9Jw0H6T6KWihXoaQVzBT+SEFb7?=
 =?us-ascii?Q?/PYL+2//ar31XGcmAPo163qxaI2pHIXCV4myIronhLU21/eDe3yVmAFCvwpq?=
 =?us-ascii?Q?JDMJRc/ryr2ks8NxRCFY1+iMIp0lxwfFfZ/zHEVLWzTeAZl++JnzbJ6viIyd?=
 =?us-ascii?Q?CRem8t+O9EV/xjk0b6c7VK1r3VgV5HRbg7rGNAqGonFVxyAsJ7tsKTqi9f66?=
 =?us-ascii?Q?89fIYcPE5rTerTGhs/ox05g3SDYVmL0YnRn3Ck0dEB2o+cmCqVpajOo3IRsO?=
 =?us-ascii?Q?X3ewVFs/2k1Ec4LXTO4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: accbe4d0-f806-41cc-beb6-08d9df62f3d0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 17:57:14.1230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8MqoaFcN8zzzX8fNqjFFyvTIXaUrSd+XWcv7EqHD8g7HKv//4YvNI+JG3PuQlxQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022 at 11:24:32AM +0100, Cornelia Huck wrote:
> On Wed, Jan 19 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > So, OK, I drafted a new series that just replaces the whole v1
> > protocol. If we are agreed on breaking everything then I'd like to
> > clean the other troublesome bits too, already we have some future
> > topics on our radar that will benefit from doing this.
> 
> Can you share something about those "future topics"? It will help us
> understand what you are trying to do, and maybe others might be going
> into that direction as well.

We are concerned that the region API has no way to notify userspace
that it has data ready. We discussed this before and Alex was thinking
qemu should be busy looping, but we are expecting to have many devices
in a VM at any time and this seems inefficient.

eg currently it looks like qemu will enter STOP_COPY serially on every
device, and for something like mlx5 this means it sits around doing
nothing while the snapshot is prepared.

It would be better if qemu put all the devices into STOP_COPY and let
them run their work in the background then use poll() to wait for data
to come out. Then we can parallelize all the device steps and support
a model where we the device is streaming the STOP_COPY data slower
than the CPU can consume it, which we are also thinking about for a
future mlx5 revision.

Basically all of this is to speed up migration in for cases with
multiple STOP_COPY type devices.

From what I can see qemu doesn't have the event loop infrastructure to
support this in migration, but we can get the kernel side setup as
part of the simplification process.

> > Aside from being a more unixy interface, an FD can be used with
> > poll/io_uring/splice/etc and opens up better avenues to optimize for
> > operating migrations of multiple devices in parallel. It kills a wack
> > of goofy tricky driver code too.
> 
> Cleaner code certainly sounds compelling. It will be easier to review a
> more concrete proposal, though, so I'll reserve judgment until then.

Sure, we have patches now, just going through testing steps. 

A full series should be posted in the next few days, but if you want
to look ahead:

https://github.com/jgunthorpe/linux/commits/for-yishai

We have also made the matching qemu changes.

Thanks,
Jason
