Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA333CA166
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 17:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhGOP0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 11:26:25 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:26304
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231438AbhGOP0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 11:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilaw+MTJaAAu6H0HsXMdS6XAuuzdVCmxYtMckkCn/woV/4IWaEk4H9AzD4AJpbCIWEknhCKNJFUeaHOW976CyirgTiPMq6oreMW7DsLIWr7J913Ir/juAnX9n+1Gjt0e9EmFVULxln3tq/fj7WM+PAqLkqMcarnPMalSZmj1l/WJ9b54I5nrCFrN7ywsmwThv88V067OdHUZ0Po02jtFBiy9M6MFNnbCJt+X2UEhRbWkbrfy16/dn2txlkyAllF6Y9Tf5PISqpduiD1ssz8r+brn91v9oYRxepYzymW7wJ96DN6+WblmvescdL6/cXo79cvefr8F0w4kVDSzV+7H0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDOMs9645LbwKHJphhKgsfJVMcdvlpjNUnV63Bmr3PI=;
 b=Lq8hxMcRaM2dzyPuLPGTtIRbKggl797C2XZGpPjkq+lE6sEBrXOTn9O9/4xR+W6TesVxrUOQfOFPou77Vp0n/l+sGwKrqoy3RgBNtNb189E4Za9bowmhjnO0wc86MzRUO0uewBMPSpl3ln9ptowtloihKR/by3KTifOLpM41x0wIofXBsODJJYbK5NlykEbJ6vuJpIUz9m6c+pWsNB7OJmLrFlSZ5keiL/IhPpeMiNZHbWQLW+ZOJPIDIE4E1pVbBwQNQL+SlQ9s88K8Vo3vrOhnppl5LNWPyjHCS1NjqG8VEhXyrZgNv4zSn7sjwCGLC8DFY37S2yO/aTKFsb2wXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDOMs9645LbwKHJphhKgsfJVMcdvlpjNUnV63Bmr3PI=;
 b=klXmDCKFIjBgAFvYvVLUam3di7mEXnyPCuGyhap/LijG7BVVr+MDHoWh4NBDrbRetS68lk3rr7zzNPfa3l1bCoca62q7ho7yZ0lGD12YXhTdHgRjoBVJU609cS6pbfD4duZZ+DlfoDouy0RqfmQLhubstWDPXR4dOXN7sO+ByxuvxOhDTt3EDIXckKiN/45PmQuvZbsYu0Gf8bt7TR6PrJepjulFW+hLSo+lu2wO9UCqSXZ+0Zmz2yaNVkm+1Untq+kLKfGYbyS87QKUcZY7VxSt3f5HBiaG3FgcJ/QpHM54iaUwkng/A6KMCvcc53wyFGViLSuGxwdXmLij8hXQDg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 15:23:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 15:23:27 +0000
Date:   Thu, 15 Jul 2021 12:23:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Shenming Lu <lushenming@huawei.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210715152325.GF543781@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715135757.GC590891@otc-nc-03>
X-ClientProxiedBy: YT1PR01CA0058.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0058.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:23:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m43Cv-002ha0-Iu; Thu, 15 Jul 2021 12:23:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91fad6ea-7906-4b51-5f3d-08d947a47e7f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5125CA21D17D60C0601631D4C2129@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dcDuQGnfo0Rf/ybninHetQedXdHHevsbfMcB+OyDSs+B1WQvlxVmKRMUg9FGRRinb4LVuOJD86LgSKC1XNBS7g+UKoimZlmbUinprXoTAp9pKzrfChKbE6rfohpAGr3gFXxWUPNxH/nxQ0cNYEkshj854joyYla3nyzSLx4mER5sA5S7/gPGoUkV3W5fVwnzs1QG34smCr1FDXUK2uDiALSmzJro955UvcrOSztIchF8SZ1IaqJ4pugWxTbbY9o6iWA8y90QoZqfS42l4+AFYcBxhl7F61SwSEyJgf1N0mBgQnE24at03nmoj/o34Jj4cgWx/qMjpAtM8p1p8aI9DqaluDaLAAJ5+jnrrX024oP35owng20aI4QOUk0BFOhIIhvhrnUYiPT6bdp328yfgCHXHataXh3cb9SEVy0pj8JM/UNHyCPLfuccfsq7QHdlggvULgjEGSixt6DNKD5/Is8ezTh7dGVsd/qIhaOetTn7U8cZEgwLEPvxft5L8ERdkS5Dw8f3GhEU4t2a5BnDYVN77iNKKJOSrvhHWpM2RgUjIs71NELq2kxorggQNBjAjdUPZWBTulTV/Oia9RVzNnLSDtw/V99dUQpwSFcob+6jHMJb4YJcroyRuW/bEhK00nmcOPkjNN83JG8WQcx5xxc3PY2MfawaQ9k+d3a77LtNIPQ15A0Oavp0FhVXgMWC4vHLHp6pXKwnWxuef5Z6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(316002)(54906003)(5660300002)(86362001)(36756003)(186003)(26005)(66556008)(6916009)(7416002)(66476007)(66946007)(2906002)(9786002)(9746002)(2616005)(426003)(4326008)(1076003)(478600001)(38100700002)(33656002)(8936002)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+LA1qGvwRrKFy16GnW1mClHVhY30A9XpFkRu32rnOVLQgAcxXt9f+VxEYE5v?=
 =?us-ascii?Q?6RzPvKNdY18YW1AlF9GuuxQ5sSrcvDuPpuOkOwbQ22yL+HF/8sNs+bwhQc5u?=
 =?us-ascii?Q?VPHiK8l0oxf5641w/f7M8OBPcnzjv+JbIn7cgF6AwSuEgnawhjmofEACCJlU?=
 =?us-ascii?Q?vJBX1Hp25cWXMokboDH0vt3tgMQKBNtauZJ/KGu9OSqHhmKGELS14J6buQLK?=
 =?us-ascii?Q?3Z1X7gpF3Erk6QrOsfAcKW1oWAN36FTQb+eLK77tFgbzDgnSQl/6LQA4r4dR?=
 =?us-ascii?Q?AxCZT4b7rvuRy8yTwNQypd5ybBs0bGWVVUj2XogWN3xcHdcuFpHvacgACqSm?=
 =?us-ascii?Q?7NYfx3YqEZ0SWfW2JF/n0MseVpr6BuFbMHsL1ejtdJ+d6FrbtfwLVEDdZcTF?=
 =?us-ascii?Q?DNdsumWa6evjkSQbQXHp7hKYqY6R2OW8+VCEu3Cm1O8rQAr56x/Xo6Ds21xY?=
 =?us-ascii?Q?La49kpSPsGCe+Q82OrYAMc9k+HDaNpxbqSKtIQd2k0JvHijal95g8DWnIlC8?=
 =?us-ascii?Q?fxYpoNdU+w6/D3gYq7pf/TxXlNRQ6fyd9G1PoXn39ktxRTkLf/RhSmEtc2zu?=
 =?us-ascii?Q?pD0NOfr/sa4LjkVOdxsA+5dqeyRCmB5dsclUkcdBZQfo/rZEOSisn5mjNUmw?=
 =?us-ascii?Q?M9T3dWVsuw2m6F3iXLz0gyn6seXJvdhknzjITRZIzhn3eXyghryiF9TjZ73g?=
 =?us-ascii?Q?5Qi5g3NmVeuB12h1Z3ef0j9lSw3o/coHtssnNUaRophFjO9nsf08+Da4QwiB?=
 =?us-ascii?Q?3xfqWBcGkfknMo+jhjtETof3o1A+K79DBaN1LyOMCJaMq9SVifRWxjfCH33s?=
 =?us-ascii?Q?AwtkCyPZGUIiD9I6iseHd8vXYOM5yJh/pWrB03TJ9MyFkO8ps83+X4oFXOgr?=
 =?us-ascii?Q?rg3Pg7b7U7G3liCYsNvN0wqrwOypjwWjxB3cWSyGSWlEH5kWNeOOEhNWh1Hx?=
 =?us-ascii?Q?XbiGQ1uR1VapnBm7NaVuSZBR0qh3cN1RbsTG9rvjqlOm1TVCVp+iZ2Ewkpsc?=
 =?us-ascii?Q?mC0W5kh5yYWrASHaZ9k6KsnyuNyE32aWv0JuU3vYEqAr4McNvWNVWUQz2B2y?=
 =?us-ascii?Q?bG0oZHFfNQBZFvr6sxnMZbYHFm7l0HYFVPb6bERld9SYMlCvFh2OdTKesewz?=
 =?us-ascii?Q?YQa991i27ViD67u4ev2spYpRQH0k0zGZoSYTaXFl/QetkYqE0eWQcTs2TI1+?=
 =?us-ascii?Q?HGwGgUMisg+q4vTBOGuaCEox4uakJf8hpy96cWhT7UWynBnOzCTJTYPeI9JK?=
 =?us-ascii?Q?++lMH6j8Wv4GuRDT6pkqJ5888egJg5jpdIY62cHjKqW8OEV6JD/eKFkjouuV?=
 =?us-ascii?Q?80m+47oR3luFNYhL40A3aPaU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91fad6ea-7906-4b51-5f3d-08d947a47e7f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:23:27.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXq4a+XILdfx4cBdpYSJSpQcgZdGOUXIu7GRfjlQC2FXOzFFd0OyUYW4Hxvcs9ce
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 06:57:57AM -0700, Raj, Ashok wrote:
> On Thu, Jul 15, 2021 at 09:48:13AM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 15, 2021 at 06:49:54AM +0000, Tian, Kevin wrote:
> > 
> > > No. You are right on this case. I don't think there is a way to 
> > > differentiate one mdev from the other if they come from the
> > > same parent and attached by the same guest process. In this
> > > case the fault could be reported on either mdev (e.g. the first
> > > matching one) to get it fixed in the guest.
> > 
> > If the IOMMU can't distinguish the two mdevs they are not isolated
> > and would have to share a group. Since group sharing is not supported
> > today this seems like a non-issue
> 
> Does this mean we have to prevent 2 mdev's from same pdev being assigned to
> the same guest? 

No, it means that the IOMMU layer has to be able to distinguish them.

This either means they are "SW mdevs" which does not involve the IOMMU
layer and puts both the responsibility for isolation and idenfication
on the mdev driver.

Or they are some "PASID mdev" which does allow the IOMMU to isolate
them.

What can't happen is to comingle /dev/iommu control over the pdev
between two mdevs.

ie we can't talk about faults for IOMMU on SW mdevs - faults do not
come from the IOMMU layer, they have to come from inside the mdev it
self, somehow.

Jason
