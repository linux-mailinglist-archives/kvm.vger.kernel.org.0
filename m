Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1446A588
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348372AbhLFTXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:23:06 -0500
Received: from mail-dm3nam07on2041.outbound.protection.outlook.com ([40.107.95.41]:64897
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348367AbhLFTXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:23:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTBhWCTNcDEx8GswSifHrpSP1G9yDTMTLhrAvY+q5LjTVPBrkmAQmPz1GU5P2hMTlBvglbseFSUXL8ERDDVSYkvmFQro9wGoGOWZaffkKytt9k4C8+VFhgQlpofGK2JRye9O/G3o3Sr+iSfv73tGVf8MU1qHza06wCRlYkOSIFqcQAWPcfbNm6RGLzS3OK3s1GofV+2WY6N+5uGRIzjekkhkot0LrqQRX9P/y7O1XlpwogAp57VdSBp+pg4pg9OqkIJB7isDaH1m5ou7hCJwyBbiuDy+0Hm4UGLxZdqsgv9OOvwKgz7zmLaQ9TkXn1Z5TQSJmdAYjbReUSk3qxRSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qu0e1hi/Z0UEZbJMHhRJEiexsSCdyK0Ojk+6P1+5F8=;
 b=SQQiqTvxQVhwTuhAfUOCIS0k0+flSBGIdrdEkJNEM6Vb+71uwNtXWmh/3zMY6gqXz59UqS1qT9SJPpv55EYga0Noz2jomwhVQ4aWzcAXTGWYzXJI+algNKa4Ixg2ct+PeEQm/3/rgn/jVUqMCWpVK8zXzV3CfbcHI9H4+4oi4xR7QVT/ziQlo8Z0FDXO7L0BdNed34+qhlF/+MApxB06IyIZ6mcZhXNhkibZNP5WbsZ03EPAvDAm4XrJpLgIE09mg+hlVp9i6Nelu3qgYtVOlwRdJR8ZaYXQ3XneTb6OCRTf4ZIxhnQaKFhOfFBSe3F1k843nGopG6P7W+IZm2qviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qu0e1hi/Z0UEZbJMHhRJEiexsSCdyK0Ojk+6P1+5F8=;
 b=F8ztIgDxyhDiBveHwV/tFZ/dRUHJ0KVWIAh18X+jlO1gpsawxdeC4HxUd/U9aGIkw7A3sqscefvqSS+AmzMs80+aWf53edLUcbqIGVuiu5gH0kgbqlYwkIj/n+JoEuQeoS2Z+OAYhNEEHA9OuNJEDjIbnZX2v2LSTWrpuy/jmgjPPhXL5Lo99jMApjals6Lk2GagOIVz2UcCd466k4AEO/6AJTMUClhL8i5Fx22TiorAd8tODxi+mOjX5P17I6wealAoO+b67Helx5Suno7pEOepfjSYDJ63GpxrJ1aE2aIN8+5GwqofR29ufTuZwwlK/kcgRLJjF0C4WnyDyAjqjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 6 Dec
 2021 19:19:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 19:19:34 +0000
Date:   Mon, 6 Dec 2021 15:19:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211206191933.GM4670@nvidia.com>
References: <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
 <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tufltxp0.fsf@redhat.com>
X-ClientProxiedBy: MN2PR12CA0033.namprd12.prod.outlook.com
 (2603:10b6:208:a8::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0033.namprd12.prod.outlook.com (2603:10b6:208:a8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 19:19:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muJWP-0091YU-38; Mon, 06 Dec 2021 15:19:33 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 716f9e0a-ae68-4797-4567-08d9b8ed5652
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5189FF78A6045634967B2BA7C26D9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkzZ1j20Q2Xq8HZFaCmF9bHmcJq0ZDisp5+iZ2iMb9GC7eyeCe7OXjmDorOrHrFKtrm/uCMOcPWpoGKRMnx0F8oi/dUjr7rEUAfmluXKSn4gSfpNJnTrKcRynVWom6+lWUS3OsAw68h/tu/0TPOVIlPRQPb4h1/8vyL++iJvGf472cOq5X042QTNcBLC23iY5nHQK2JKkdlqXDKoYyBEMmXf8PFk7lArPeqNRKy7BJom1rOw+oQDqpUiNYy3h75/VQ5sOww1t7M3ZxtJsBvj+DohSZTf98YurbPzFDEUgYkCJVyXZ6mD01zH77J0UF1sU2iwTqdLHUMi7V5U+u3yvUuKI8VgLmHZLZpUg1oinXnRPFbUeHH1CKVCnpAiEUiYBQArVX7mGcqH4xYDbL4j47w+Wh/EzFlNDENGwijGEd4vOR4T45F6rCj5KyfycCl1ooQRrjZOzZnLwAivkXnBd0gG6Z3v1cMyHw/cy5Ujul8XH9TAmk7T2mRAmzRE7XxsTRebJXOYzGV0+55VjwcI69UTG1i55FnjqDAidVS+bpa9RHv/ZaTCz65eJbQXeOxyHtrEx/16/Zg9+JARWNrzdktwbWSciaXAdf9N54Aso+XamxwLk0G34B6DYJfPfO6n8aoxkDq3btr1qC/eZEgzXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(508600001)(66476007)(2906002)(66556008)(107886003)(66946007)(316002)(426003)(4744005)(26005)(33656002)(8676002)(5660300002)(6916009)(9786002)(38100700002)(9746002)(36756003)(2616005)(4326008)(8936002)(83380400001)(1076003)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FhMSdpbWOqdpOsbZFj0VQBKdJFK7h3y4O/sblO5mUdgelrnJ4UsBIs3wHzl/?=
 =?us-ascii?Q?ZdOuXNH0uco5vcYdQzcj7rUodrE8cB0F3W6vKFs1ZEsnlETtqt+kk925kz6O?=
 =?us-ascii?Q?caAgrWSW188JbwMl/iE1TxrLaq4Amx7QheN/kjuiU+yzQMPbmfzhv9rzl4U/?=
 =?us-ascii?Q?mWl/VwIUnrlX9Gwthj4Lc6ExSR7vey+eS2PG/ktSPYfNsKON+RLAoR3+Hkcy?=
 =?us-ascii?Q?rLJwJWr69+DDmFrJNttW2/HHvuiarZtigASnXxDtl8ou9/Trq9BVn3lMYhtZ?=
 =?us-ascii?Q?jZjzT7uISTwCCGK8FkGhb5VhFaI/9tAQNLKB0HP8Q8UqBnEaNyuDkZcTiRmw?=
 =?us-ascii?Q?AdWXweXvq2z55olhjCH1XqSlj7ZbfRuIlBmoGUxLqwThqcMN5XidDRpylobz?=
 =?us-ascii?Q?aqcAptwQ510kh/oTAJkUEa9dOSWJqshWOloN3A7MRxJ+GVMnZo8jA84lL2PL?=
 =?us-ascii?Q?22MOhPPlLafQq+V5FlUeMH+xtAzyRmY3Tb0xQIPRAenxKEiBU91af8Fgvoci?=
 =?us-ascii?Q?r/Ai/smWAgJI9G5v7SgwE26I3UDICucEXkYJ5dgrLIoFBkWfeXbP9edtIIoN?=
 =?us-ascii?Q?qQAW5Zstoof9WPnIoycWQy+QLtHdGC3fO6inTqx9FdO/3/877EZQUJDAkeO9?=
 =?us-ascii?Q?025nrkKrO+Xsm2KxorGGytnLzRZXaGRXZe7wfJzoe5be7B0ugNyfX1e2zXUM?=
 =?us-ascii?Q?jI4PlPZLFBdwO4BatOr3ButUuCXB6Wna2TxPWr9cwP+LZltVMdpB/MoCDFHn?=
 =?us-ascii?Q?Fhz4yMGYWKUgbpJ/EDCa08CGcpNpl/L+YkVKtNAQaAMzEM/9Kog6wxYe0GVU?=
 =?us-ascii?Q?zfxzsIsoPBfLt+vfq8Cd5fpAFq0zhqcVUq/LFTD1ntDEAtlyROBZjXjCwNhf?=
 =?us-ascii?Q?Lvl2P6nUG1z3l1QUXYCmH1fGjCggRt4DAI68iHaGENUjTsxsBkYVvVYElRyw?=
 =?us-ascii?Q?qN8uRpY255GDKv/5E18ozUSdOQ4z3VtaVXCEHGkaivxL6gNuBb2JROFcivRy?=
 =?us-ascii?Q?+/RmNBNG8h0E1n9Zbfx8Z/vCN8bnIVRCSIABTUb/8EYsAoYg/Dv4+cbQp38f?=
 =?us-ascii?Q?iDaO2u5Q2YT2EHbZtZSEJaq1byorgIylmpLl1UemSRurDiOPnmihtfEcSAd8?=
 =?us-ascii?Q?o+Y7WfXmCZ+kUotK5O59jx6Fd26qRpS2OvRjmUC57sUZ+/sl3Maq/wnXtt1Q?=
 =?us-ascii?Q?yT/ql8R1rf4hq0T5yTPTMZUMFDa8GWDVZZ/aOPn+kn0z0+8wG/i02TBzNDgq?=
 =?us-ascii?Q?aTdiZ+KopVcZZ+QyYYR+jNbi+4+gZiAch7MMK/YuRFEjazdeMJkygru9grBX?=
 =?us-ascii?Q?H8NrRZuc4Ky5K2cPVP0A5dKqbzpcF1GzQ9wD/oKLFMjvUhEgqtc3ZCrzg/iH?=
 =?us-ascii?Q?0KH0I3qZJzc7Ox9WAEQp5GaAEV4GDcIeb0IUdVH2E52bWZ/N3gDV7oBX79ME?=
 =?us-ascii?Q?EIcFoRw8oCDLvBu+pviUW5NsLq5UTfyLZEOCKZ+6T8DQLnxenVtGB10oW+oC?=
 =?us-ascii?Q?ajykXyIWwSY8bHFiiwylkCHXaDkL8Lqm+XekZFe8Sbmn712iEHE62ELW1UIr?=
 =?us-ascii?Q?gHX8Uyr76brEW8VFEpI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716f9e0a-ae68-4797-4567-08d9b8ed5652
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 19:19:34.6179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uy/KUCBITFxQQqAJmQwVTXv+pok2TroPXwAb9uckXhM3ZzT8MvnGENa5QxNk5kUq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:

> We're discussing a complex topic here, and we really don't want to
> perpetuate an unclear uAPI. This is where my push for more precise
> statements is coming from.

I appreciate that, and I think we've made a big effort toward that
direction.

Can we have some crisp feedback which statements need SHOULD/MUST/MUST
NOT and come to something?

The world needs to move forward, we can't debate this endlessly
forever. It is already another 6 weeks past since the last mlx5 driver
posting.

I don't feel like this is really converging, you two are the
maintainers, can you please drive to something acceptable, whatever it
is?

Jason
