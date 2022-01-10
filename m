Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC0489EA9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 18:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiAJRxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 12:53:05 -0500
Received: from mail-sn1anam02on2061.outbound.protection.outlook.com ([40.107.96.61]:2358
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238582AbiAJRxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 12:53:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNFjHmFuh+dQTjlH/IS3DRpc3iTHLnaCzxtTYJzZ+dZOgbE8IHXFVqYZ0pCJYTWE4uNWXrjW9zcIK1gfdvITwVB1UAE6R7YxvUssuCrtAd/7rIFG3Z09+XAkrB6mZTKVUaIXnOyB8Ok8VH8Nsj5TkRe8EeIj1sWAlahCbEhFNoO/QGAK1kEXws2I+lfA7vSrFsnslTGAO+OsH2eBNlTdwXIuiRaJoVjvsJH9VvsO9CXuDGIno1s9sALsleJbgA+VyzfZv4svpRHX1uQKCRm50A/xk0pRDB2hfuhUK0G7XdG2nrEOrxId/iq35wd7G1WXfjkn8CHUG7dX7HRlyuzArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HshNqaSgufsObG9sfZgk9HEAvRciQyJohPn7o2ulHuI=;
 b=I2Ic+K5K3KBlFaWIqkVIvGMsRYKDnB2gnaTbTgARW+FjqK3tiRL5X6Nkl4EbTXvtOvPqB+SsRp8byF2ctvufEfL8UJdiqx4jEynf1pUAx1UvobWuyWNKapc9IBwhU6B664DuCSSCtZaot5H+Wtq65OHc+sIOh98nyDQFVkftc2WI9ee5o+KC0WjMmYBe9Q7RkF1c8xd/8FXK1qxtC6fcQJEmFVrQPjKzC+qLbEoCKXnEAo27J8pENLK33nrfFjrQvs3b3QO4zNUePN0RsPAAHAy0oH+irmG84ovHlYO4TAv9j1Dn890mtdpNAHaWe2IIdeVq/4uSNaes3N/kIXiEbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HshNqaSgufsObG9sfZgk9HEAvRciQyJohPn7o2ulHuI=;
 b=apyXpxDpNxm/cBzrbmK+wBiRcqXBPrM0jZ4dL6fwhT3sxv2njW0ZS/jg85SJ/H3sZEZa5+Nat0+Bv4e8XvMb41y8kaP7fwDaxIhY7P9NjJWvYJKJlsIG+JX4oCTN49aMgQ/SPy6dfZ9PPww7/HrmDJyyvJBpP6MITJ1nBBn/1yXTijuD4r8GkU58Y7erLQOHyoB+zVywHqgMjbeNq9cWGTevXDCdHIPmAyqmSc/681r3GElmhyi6fcaK3+0IG/nVwequGpP/enT3eCTcPxFMmqt/bz0PhTEH1jKZOTlOzq9sC1D1MzQLNMH5HaaOLvDz/ta275yInbOJq7eYp0/PQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5538.namprd12.prod.outlook.com (2603:10b6:208:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 17:53:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 17:53:01 +0000
Date:   Mon, 10 Jan 2022 13:52:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220110175259.GG2328285@nvidia.com>
References: <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107002950.GO2328285@nvidia.com>
 <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107172324.GV2328285@nvidia.com>
 <BN9PR11MB52766CFF8183099A16DFEFC68C509@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766CFF8183099A16DFEFC68C509@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:91::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6be50093-524b-40ef-0eb0-08d9d4620b37
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5538DE6A9BADF086331BEE94C2509@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfuAQqcvAcuycTx8et0NZ2l30/NFznC/M7zEcfgpPDuwFMqNLb6DxoM6V9cZ5nnH5R03f9du/+LeWg3qO++WNqpfjJ6JH+4AjoAs6s15Gs5fEErR5qTxtzvTa4X/wkgJWI1q7nUN9rJe0KE7X3VONiOrSXQEzNIQcBANghSjH3SskgmTbe09qIHgZn1Z55TJ7Bj8vHPSMsLS2uXcBN93+U9L2NyIhEVcKR95PlHIUSw0rPDYrVj+WVvEbgO+s1HO2L+4hlIqp38vJwkszNY+OFOr5CU0LGXz2uC0z5CUdDsUQsxiubuvk8slksIm9FK1c5k1tjNE6tiYG2YxlbLLwzftXjPUDYmo8NF4LZiCj5byk1Bs51tIxoR4e0lk55lwhFTKPp7MR1KXiZivKnkTK4FbHQurwDF9A/BG6ZxA4GVf4v4JBzHZKFqLYh3+aTNjbQMXx+nIJo51K5Ik0TqG1EJpD8Er2t29bqDqaB0gDdOcIpOmcfPycv5Ww2O5cvEmkFqyLYaOS+b4fvlultcDk0XYUcknxrfHYPB9On/E/F+Y0WI5ZvgID0f/cz1OZH/Mk9MXR6xJkYpU+1LixotbiJF/P/MIbpg8LXKtjnsVb9DrsLyGjhVCQj9xujgwUCw77VL8UEg5wXyJ27qXyRgcww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(83380400001)(2906002)(15650500001)(2616005)(38100700002)(26005)(33656002)(5660300002)(1076003)(36756003)(6486002)(66556008)(6916009)(54906003)(8936002)(7416002)(86362001)(8676002)(186003)(6512007)(508600001)(66946007)(66476007)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TQ0txDiPbse8g5omALenilg92hEvJ9au9spKRyweHWe/uamHhuJKioqziU8O?=
 =?us-ascii?Q?7fJ+VCld/Z7I2sbKmUVuYHjsHTYbEUiacQQFO15AT//Mz0tqE7mCf1MrJ296?=
 =?us-ascii?Q?91WjSDxrm6qy98CxOBYd93jDE4TrWSmxC1qakeH1U26Ch7n98KFIIdKbm4ON?=
 =?us-ascii?Q?sXPyw4Rj0upvdDTSs178+LDgFU3Na/wtkNsB3BVR7znqDqsIypjtG5kh3pVw?=
 =?us-ascii?Q?IpmbVQR48/gcFM3Uz3/kwVQkpoWGZ9be4t8mP2TfrrLdv8M0+b1wdE2ZuAFS?=
 =?us-ascii?Q?qQn64m/rNOJUrfx7JC2ANAezJaSpzppQBwmLXh9utOO0ADRfUTtAcjdD5Ycc?=
 =?us-ascii?Q?2xV9snn0KCZkDkr0TOFgF7MPDJrCkVI9lxYxIl1FWTUDAyUCb+Lp41nr6Pqi?=
 =?us-ascii?Q?xZSKS3sBDRp4f1Sf8rwBWJRB4RIRwOegnP2e4ww0x0rM99exVAB7W88EglKB?=
 =?us-ascii?Q?EnrPrerN7Ci5P+Np9wrZFVr3p+ueqQay6OfGfPHvwMesQ0Q3SWp5q1lIzBsD?=
 =?us-ascii?Q?rrnFvyvUHjG/tZGLsDUHwqYe1MIWmUqAx+3tqndOW+P+JpRy+PTIOA8DO6Zp?=
 =?us-ascii?Q?RPEz5TKYChjyPD83zN7h3CexXYw6s0cDzGLahL6x3KByGgdz82/+FwG9DXaG?=
 =?us-ascii?Q?+MH0yyLmTIj0KhpE4UUnq3uBilt+QsOlsB7uopxccFUVkmRnpOh3AXyDRg2F?=
 =?us-ascii?Q?5IdnUQ0P+ptkXrdoPg5TuXZU/XvGRS4AibcnpHVfElLcwql2MdxHTNHBygdw?=
 =?us-ascii?Q?Y3QmmixjZq0b42n6psedGDtmPZkDrZ7HBVmB3ObyTsScz888KxLga8hSwNCn?=
 =?us-ascii?Q?WwjwSbn1lvIUVDv9ryQHGbRaFRZzMxo4HDspYq9BubK+iunfzaUkA1yLns8X?=
 =?us-ascii?Q?/Mt7Wit+aJdznQzycAlTtkbfuiAaSLolSMW523fMOZOo/E1MvpTvP5DuJOZy?=
 =?us-ascii?Q?adbJg3ptUUmaSEFM8PwVZEGkxBnQVYf/F6QG5PeXFtKZqdg/wViKaMoqdFP6?=
 =?us-ascii?Q?WGnUQKphZ/9kl6jmOGpFb6cDuEFKTuZksp/MPX86MOHi0AjPfO4nmuM90V4I?=
 =?us-ascii?Q?Uvc1xOhr1HN7g7Gy0YECpQNq9Zi2qZZg1twstgOWoMrFpnYqH353euy//XZ8?=
 =?us-ascii?Q?9QEeaMhGVRJCdXSJMNvwsj04rGTGK/G+Xlk3QLsnde45xBlkxHLkYKJprsvg?=
 =?us-ascii?Q?C2ov2ZOQaoP32i5+G0arg5U9h1UT+UKpn2ldEmEc85PDMy3q5LGpXoRnSIK4?=
 =?us-ascii?Q?jHqCJ6i2rjyW4+2aaHcS8VGtPsrlz/92iz0aqfRt0FjufWVQHd52Lc10xxhb?=
 =?us-ascii?Q?hkwBQqPWZOCA/mtK0BpA1+/jg2Snws5GDiDry06Fbz7MshROoYOx4Ov9t6d9?=
 =?us-ascii?Q?cYQ0GZ1NWLFNRF8GqSSAo8r9KP3SNyjsU3eZ0zmJVCYQCJDkNejalQ9+tC2W?=
 =?us-ascii?Q?PnhgRubsNAU5ko/86MT2whK/wb0c53tAMtcKKpk9fMRo+dAnvYs+JCpHSRZn?=
 =?us-ascii?Q?oJKT4RI2FmKz+feNcdyGPPLrFSR4Fcc5Htx0rs08iUGIttWIRZk1dOshJTIl?=
 =?us-ascii?Q?p394k1qHxV7wfgyEldE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be50093-524b-40ef-0eb0-08d9d4620b37
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 17:53:01.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vSMGwKiV7oDk9uJ7nV5XBB7wBx0W3uhFfxjmnYH+X7zYg1/K0kXVoc4i0oBPaa0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 03:14:44AM +0000, Tian, Kevin wrote:
> > An operator might need to emergency migrate a VM without the
> > possibility for failure. For instance there is something wrong with
> > the base HW. SLA ignored, migration must be done.
> 
> How is it done today when no assigned device supports migration?

That is different, the operator deliberately created a VM that is not
migratable. Operators may simply prefer to never do this.

You are talking about migration which is blockable by the guest -
outside of operator controll this is a totally different thing.

> - It's necessary to support existing HW though it may only supports
>   optional migration due to unbounded time of stopping DMA;

At a minimum a device with optional migration needs to be reported to
userspace and qemu should not blindly adopt it without some opt-in
IMHO.
 
> - We should influence IP designers to design HW to allow preempting
>   in-fly requests and stop DMA quickly (also implying the capability of
>   aborting/resuming in-fly PRI requests);

Yes, I think we need a way to suspend the device then abort its PRIs
with some error. The ATS cache is not something that is migrated so
this seems reasonable.

The only sketchy bit looks like how to resync the VM that still would
have a PRI in its queue and would still want to answer it. That answer
would have to be discarded..

> - Specific to the device state management uAPI, it should not assume
>   a specific usage and instead allow the user to set a timeout value so
>   transitioning to NDMA is failed if the operation cannot be completed
>   within the specified timeout value. If the user doesn't set it, the 
>   migration driver could conservatively use a default timeout value to
>   gate any potentially unbounded operation.

This would need to go along with the flag above, as only optional
drivers should have something like this.

Jason
