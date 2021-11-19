Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF2456F26
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhKSM7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:59:23 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:56416
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232020AbhKSM7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:59:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6/zFhzyemyE8ihmiHp5p4varYCUlO3bFh28T6vck30S/N7x6k7SVrDuc69CeZ6JwoTFnGpAvUf4o9XC0QFXtAXSI3lGI2+Lh5bYjWfH9QULYDTKZAU8JET5i0Mn9hJ65Qd/0dyQgcg1jWSVQ12M24kUrqo4FD8RFnGvDOar1jg8z5pB2chr3BjcNNRWNR9c1rBPGQEH8qbYu2iZwHcC0yqdlsC4mk/TpyEudffnUHEfyungTviJMqBP0nIvTONDxRX3bRfUEabYAjKCMr3Gjat8EH2ZwyGy/+BZGSu6Cg8m2wsQnjuZGDPWniZj8U3UPrCKgFhgAh7pUfEiv6SU+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waWO4esmW1rZN0jKQVTNJUZ/+4abaXfg588B+b+Cghk=;
 b=kVKcI0HyZ6O7ybQx+VpFJNl0kvaurizdqNF2zqBOZcxyGMWsGHRcnwlSetsNqTF9ExyUmEiWMY7dhCgQax87bA2LQKAhKeFrJbZ/Y3D/8srdTLvOKboVG2+1PhHFOHFus/81/WvFnxzS59Z5sSEnpkPlwx3bwdHRrAxl9R88b7jD3Zgh2EwX22FwJ5bsQTV/UN8rRFbDGDTPT9MIPGiRPyO5piptLM9j2GN+a1q8/vWiBFQ0JICjuuphCz6tg5MTLrgXP3NciEDfiE/dxfkpO+r6digsWNbFce0wYjDhCkSd6CMPvcLqTh7Q85U6BuuC3QZbzlETSNcrAeW38sDQaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waWO4esmW1rZN0jKQVTNJUZ/+4abaXfg588B+b+Cghk=;
 b=m9ZyHhZN2JGVeQehSUFWRPXGNbI0GPhpmS7GaaR2Tn/FC5R9fy3Tol1yp4k7elkYdfqv20JUiN40fwmdbdpdqZD8WI7GW59PD+ZRRvwcRZL2xU5jbsfM1ZuTcD9a+kM1/dY7yzglDCcKUcWx/ZUzItyVMoRBnpw4InEOT5OoEc/mqHQnC+W7iNF8hpq7l/rEP2PBJRl/S7TrTPa2NXc2DDbeU2KNNh5MZf51wqSMdidsJfzWGfuzZhMief9CIQUCRyKfx0sXwqXnLG4B1OfbyoCmc85cKkzeP43MkERpHn8XTLTlSJiSvWRh5hN0mXKSt4Et1dr6zXMN+zzFzbIgQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 12:56:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:56:19 +0000
Date:   Fri, 19 Nov 2021 08:56:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211119125618.GU2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211118133325.GO2105516@nvidia.com>
 <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0151.namprd13.prod.outlook.com (2603:10b6:208:2bd::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.18 via Frontend Transport; Fri, 19 Nov 2021 12:56:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mo3RC-00CDVX-KE; Fri, 19 Nov 2021 08:56:18 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd6cee00-3bc4-4408-795e-08d9ab5bfb41
X-MS-TrafficTypeDiagnostic: BL1PR12MB5317:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53172E98B89C54E3133C7132C29C9@BL1PR12MB5317.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsi/m2v+SxMVMd77cDLQDu3uZGagYoMmHvqSBVIfIUoH0mfhBRbTJRLjGKDtrmLGbfPCZ836kEqHvEVt9oGHoTxpET75f641VMdJdWoEd8dFoXyaxRGRPPsVILPMefyJaIJLOvedmeTnyS67hJhlvvIF2gSfDuDB3tbRoEdy0pshofCqF74dmxDhsoK99I29b1Ca9JzfFmSeTRxF48mXS7dzSt9r7z/NDSwqPddnJW/P2hb0l+K1EspcTxxnUrR6WMfSBqDJNBSkGRumbqjl6aoVpDhkCx7I9JxeAbBW7cyQNzjxJdBmGgo9OWOXu1f45stVU/9AEFAQRfKSpYI+Vo1uU0j21NM9i/sEiLHlZNSzdmXfkqskKT0y11mB0NHkgIu+2qweFd1936j8B3iEkIEF7Us0PVZmArRlnbZndG8asD7+bXRiFxIxa/vexu+QgaNZWOGGRA59KsP8KYxjMCW6DtARsny/aLDuMh3LV9t0qZv7EbwuVn2pUPYBTrUm14SFW8QsdJIt2eE9QoxvEhLPgSnD4HpZ/ExlPaAxYTzY83lB/1GZwRkUKLk/QyCSl4k0fGl2lVPzumKPabkQpUVdFORFrMq7UltexIHU3R4l5rvnkKhfOsdTB8GVE0xnf3UCr2GeMESE6qJbg6Wmkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(38100700002)(66946007)(66556008)(66476007)(86362001)(316002)(426003)(36756003)(5660300002)(2616005)(6916009)(54906003)(2906002)(8936002)(9786002)(9746002)(1076003)(8676002)(508600001)(186003)(33656002)(4744005)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjSWR7cyFSn5g9DswKoP8QiIbCwnzPor+4i4yeBgK3IfEg1Ge0jVhw2w4jtO?=
 =?us-ascii?Q?5+c37BrCFBB6cxRrj2vVfKzifo9lhTLw9kzWYhTSldfYvLIBEVsKPvbyS/wM?=
 =?us-ascii?Q?q97cvuajLV2nCsXd00IQke313WHEeLTM54EOvY3KdzcaqF/P7OAWp8aqrRgM?=
 =?us-ascii?Q?QfBJHVg/+1z73Qnel3LyE/tTa2e7LVQc1jFCAdtEkIhHEhr5avdHmzVgVsoL?=
 =?us-ascii?Q?ljCtIBP/sYbmSBxPLDvy+hnF8NyGtgLXVRmw9c9EladTG1Xnh9PR13sb7NLF?=
 =?us-ascii?Q?75OzOJykBq8jTesvFqrT/dw5E095ANsvgEywdX3aPVg32KuwRWW39TJT7OxA?=
 =?us-ascii?Q?SyU8E13hN9NZlwOgXKhUPs0tPihHTeKnuH7fVwMzyXYpmtbOLBypk6BbY9+P?=
 =?us-ascii?Q?8WJyb9cMPd3Qq/++09NB9U1h9J+xSRf67E/AOEYk2e8BJ5/0UDzOsMZBzV1/?=
 =?us-ascii?Q?89j0JNb3Yt/OEbUq89/i/k6LoBEel4HYon65hz1gt04Jn4WGHd5PJT/LdT5k?=
 =?us-ascii?Q?oHAcQxzgysx+CkVvKhWFS4xt6K0SUoywBWL3ovVGBbpb681KUXghaAjjGq3P?=
 =?us-ascii?Q?z8zsXbMkNs2Fsn6Y+FG7s0X7uIvw4MS8bxK1qTzoJ1BVOwPMNOTH0xJ1pylH?=
 =?us-ascii?Q?rry1+jeHaFAAWvDI6/s7snO3+UOhsR9dUYInCvKeZyEehchM6GMeRc8yaGKl?=
 =?us-ascii?Q?YXaVluVUMEB83BTQBKa+tlq/ziOhQ1U8jEGLc8wUIE7joNMqslytfnhygdcn?=
 =?us-ascii?Q?j+9zAKk3EuRlpHCz6cJ24WGrUXvE18jaKjJJjqPa+oed54lQkqnEWNTSrfur?=
 =?us-ascii?Q?kktVo1e1nZpU7ObuHPOBPWwJ5p9kQedn7X8Pn17UBj7xURJ3+G4UtYXnb3Dh?=
 =?us-ascii?Q?iNFIb9LZsK/LX9sV7IIRUIxfsvZPDUsyWMpIYME7aVa+775z0LKAskxW6Dq6?=
 =?us-ascii?Q?8av6CSKK1Grh+be9rjiBRPWMaXOGhf9yMWRlSBYl68SnCP/WqoGVu/B9+WLv?=
 =?us-ascii?Q?ztq2VZLmC7joqveDGHFBbvRoY6iMyyMW2CWhrYu8/44z4sqODmHP2rBbGhOH?=
 =?us-ascii?Q?BBLrffydR2QxK/KlpxJkmeOaODv+Ucia6R0rKU4IlmNAUZMuSdnGbw3UhQKJ?=
 =?us-ascii?Q?+L6A3Mlpsf3PNtJQUBjO+STqweQ3ziLlPXyzn2xnARen0U+u7RlUcgC4vVUd?=
 =?us-ascii?Q?rRmHN7zWrmGFkJVSeDwdwHzsHzCLylFgrM2W2DZx9KI7Svw/o9iwHbL+Rmhv?=
 =?us-ascii?Q?QwL/Yj8m2e1cWxhE3xesxVFVam2N2q/TtV/NZHOUJQYwplzNSyEETKyXSw7z?=
 =?us-ascii?Q?HpMZfX8yzC6MgnNCYGfNxsKB1wmT4d9/p4B7dpzPBdYSgNilkJxcgSA6Tt29?=
 =?us-ascii?Q?iyuCfh9wBK5klk0HRkgXclbKXY0u/XZ/Dg8D642GRSoanXaXGBu8OVdHNVLM?=
 =?us-ascii?Q?pXGy553NR6+W4BJJd+yyRb1YeubYhU/fNuYn6QWYu1/4XfeQao5VpoH8tkNH?=
 =?us-ascii?Q?9UGxpfyRTKydf/AVY9e8OFnbcyaL58qWoWtjgB409sIzs3BYIZu9r42mek1g?=
 =?us-ascii?Q?nBcUFWuKJszVevwCP3U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6cee00-3bc4-4408-795e-08d9ab5bfb41
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:56:19.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ks5v0pHJEgPqffsZbUd5t3hZDDeIxU/Jzb/Js1pqKaF+zcJ4h4jTuagCPcpLpqBk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 05:44:35AM +0000, Tian, Kevin wrote:

> Well, the difference is just in literal. I don't know the background
> why the existing iommu_attach_device() users want to do it this
> way. But given the condition in iommu_attach_device() it could
> in theory imply some unknown hardware-level side effect which 
> may break the desired functionality once the group size grows 
> beyond singleton. Is it a real case? I don't know...

No, this must not be.

Any device can have VFIO attached to it, and VFIO does the equivalent
of iommu_attach_device(). We cannot have "unknown hardware-level side
effects" to changing the domain's of multi device groups and also have
working VFIO.

If these HW problems exist they are a seperate issue and the iommu
core should flag such groups as being unable to change their domains
at all.

Jason
