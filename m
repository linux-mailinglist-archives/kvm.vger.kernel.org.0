Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F244041AE41
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbhI1L4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:56:15 -0400
Received: from mail-bn8nam11on2060.outbound.protection.outlook.com ([40.107.236.60]:17984
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240419AbhI1L4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 07:56:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx2U+uPkXe7ZWfy0dtK4y7tuFKU+pKrxNmMpo8N53vseis/n1f7XWegyz2shNRS9SyCduZWN3FKUi2NcZKIbXB8QUBofEBd7iWcGKsFoQxhNDBo5lalnTO3B5vd50BJG4VSYYRTQqGtiN0aauFdnDJYpong7PbspDJUtFynIxOyUNEa+mAH4uR8GFyeF4UD6Qd3sVgWnzYhgilqGZewbAqg60vGQZly1ry8qBHeCkPmpOg3LxdH6vycVMnq3yNA8n7x+7RUpQCvAYXoJLD0mGbNfkAwdlK2DwyMbHJrB7aSeKZhrOTsvsCbXv8WO196wpwKIwWzFzAi7bIwHj0EckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dxGEg8x6yiuqRKHW/G512rGBK3E5gAqNnE+WEn7Yick=;
 b=n5/mf/HWxlSdQsrTk2emnCubA0KeSOdmjmigm7rRxaebWIn5l0ZNzEw9dy3hDmCb0E3oHtg5nKVF45AfMMRz/7KkMN+GEnhI3QtL8KDuuI/u2lOacUuzEBFMPvVF2jpYz1wIqWGS8+GSDimly7liKRPO8fHpomqnHyiJ9vO6Pp4TeHO0cN2x/RU5kHTaqoI1WZaa5H+WgZ+cQL0CJ0JjPnBoTW9uFHqwMsXkP4cOjcGF7QL4yuXRWPUlzOfd5poDcFO7ygQrA9QxKmSeC/PsCTBp2UOJA/mUWzraS3+oBIjukI0fIDRV4kwgT6HQZH5VzP/ibp+zydceRrvfk8qA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxGEg8x6yiuqRKHW/G512rGBK3E5gAqNnE+WEn7Yick=;
 b=P2TANX5Y88U6/ivR+sHGfNcmv8Qpc6hTQA3ZxMB/kmQ+6SZX4RttCpC649FgamLMiPJyWfTqcdEbZoiYrlztkS7AQn9gm0DE2NBSdXFg0cC6rdCJabuuLC5CbIMiAFvtXg/iMaU7gAv5V4fDtIgrKpUBAo7f4kH9kBKpB4zPODLJJsBDKFV5wEcrXp7HwLcJZfUwx1gUDulU0pZoBRraIydZLsfO1boxes7EyjMHfiPpermVZWydsugP4FPPynPUretC6LcaUmRCyyW/uAizdRvYaZgaoaBEYBsBg2zvm6wnL1pcxoCYxemgEUoVqcmiQRkmbL3ECeu/2HZ5MT91JQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5507.namprd12.prod.outlook.com (2603:10b6:208:1c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 11:54:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:54:32 +0000
Date:   Tue, 28 Sep 2021 08:54:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210928115431.GJ964074@nvidia.com>
References: <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927130935.GZ964074@nvidia.com>
 <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927143947.GA964074@nvidia.com>
 <BN9PR11MB5433CE9B63FD6E784F0196B68CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433CE9B63FD6E784F0196B68CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:208:32d::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0044.namprd03.prod.outlook.com (2603:10b6:208:32d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 11:54:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVBgt-006wxP-Ny; Tue, 28 Sep 2021 08:54:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 989a851c-7ed7-402c-79f6-08d98276bc37
X-MS-TrafficTypeDiagnostic: BL0PR12MB5507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55078F4F4F48A40D925F4AE9C2A89@BL0PR12MB5507.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOP7hpGy/fmLPK4e7te1nFWOjB/0FyymBfApcDvQxJ2GU+YiJxfiEJoXzOhYA6LwcJBeCffp1de2kTUsWkheddggNINEgbJzSTXJBgD5iXKzEN2UCLyyBnGMv2apaLQvh9ZZoesUufHd3vT35GI+jAgMzl2obB6c6+c9v1CokPhCVlOBXtdYfX8djnsXkpzQw/b0/qUcEpFzba19b9hIFKwtieWz4EQeVjoDSLXMbLjpMDjCDob0x7pLvf2C5TUNQM99dEL4Y2+Od14T25YcIyQw6EH3EvQV1PDjaOhgOTG2o3N0b6kl/eO5PVnLJ3M3i+W2EXHckF/TXSPNTkekegNF94+3ZaRBxU8cDfIz5GOOgIAimDIMdi8Gwi8AQTdamV8Rd9/3MOeK5dhSukrrLT1Scy98r1z2L3ELDIIJcNkSc3KG/os1O8R2Xy7lHGqhzcX1XpyqCQl9v41n7aeGejzi7FixjDq05ebBBarflqwjIfgB2u8POY1lPqwhmT9LqZQbdIFAt98S3dpqIrxfNL3qIsVzScbjjAE2tJB+gGF6j+wVsKgWqli6Bd5egBseZDV2RZPly5umo6D+6k4yUM/9PMau02qHQVwNCBcBBFJc112DMn7JvLV0ehhoTedTj/Rk5A5SYVp8JbS0WAK78gsvg5tVdl/GlYBnNG3TKWArnpbK+M48P0JFIn2LSTce
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6916009)(2616005)(316002)(508600001)(5660300002)(2906002)(7416002)(33656002)(36756003)(66476007)(66556008)(86362001)(83380400001)(4326008)(9746002)(8936002)(9786002)(1076003)(54906003)(38100700002)(8676002)(26005)(186003)(426003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+VKJQu3YZpuZiEmoZaKGEJY6EqS0udGquoIrBWUmdC3/MbRxGZItsaTaDB5k?=
 =?us-ascii?Q?z9UPUpuFyj1SFPQIlvj2oslqtRn25hAoqqX1lfEw1tgEKhNgHAu2CEJw/pGm?=
 =?us-ascii?Q?b7NuQdjBO+O03vnxPXqd9OwScxGheQuik7+F3p9B2ufX1bdRX9Ww7xRrkjNg?=
 =?us-ascii?Q?/VDZSCRhc65y4vIb99879MS2H4TCKcFIblJbogtaW9dkw3NWS4LAnhPSp3nz?=
 =?us-ascii?Q?7cxt4rfIA4/kfmLA4Xd76t8JB6bJbwFIn52EcgDJKPyS9+mfeT5qx2kH++A3?=
 =?us-ascii?Q?gH4LxcpUE7Bs5usUoD2zhj2VEuoCbYkKN9PdBXFnCpwXMWgtqI5iQMTQacoa?=
 =?us-ascii?Q?9pkYK95AsJlt83IBC36Hp7IOf+KDAVwpA0D3uN3nzznrDUkLKnksRGQZATmX?=
 =?us-ascii?Q?Q6WF5CApwxPn5wLpIMmctO0GafhojpQvlz1Ho4SvaJVT0JWMuKw7/sRJ/Xyd?=
 =?us-ascii?Q?Uwil/fuhgedv/+btlw6FutKemrFtddyFcjs/Zxy1aZYsid9hri68/Rh7naDc?=
 =?us-ascii?Q?OQQl/BoTC6+Qo1tOU90BAKJwqFdeVhq8jqj4FdRwWc7skVnxpVSiKk99CGkL?=
 =?us-ascii?Q?AX5ydW1YUDh81eUOcFtGUfZwF2scEbpcnQlTRe0MP0F/Nkyx0YTEKe4PmZKv?=
 =?us-ascii?Q?bGnTwjHaPa3tusG/75lBWiISUnx3+/Nxp3vXC2+eyFJbDNCIV4dGvrseMl37?=
 =?us-ascii?Q?k1zZYr6XosBpfQxnp7OLIDqZgPzYKUzLQ8sfqO2kfnvIOZ89okuog3mdSH9+?=
 =?us-ascii?Q?4w/LlEhz+0gBqb683HaUFk0KxfrL2j55KjN1dn3RU+o/YZT/xuNgXLdA+DnE?=
 =?us-ascii?Q?bdAhXAM42u2QWYJocwWkuXUm86OHU6spHlbaxJtWSk3GON85ajICO20fBuuw?=
 =?us-ascii?Q?ltIVdM4Symv/L0T+DfTLwrgxfl1FkfYmW7e4YC/fUo91p9gujnuqok6Nk7zL?=
 =?us-ascii?Q?29dwuxxULm70br+hgqu7JVla0tsefu5IIP0Zy0rh5JC+rb119tndR9g6q1jC?=
 =?us-ascii?Q?JEY2zW6b5HlTRWQRaj8G/pZuJqgzNBFUEXrvIerFbp3hvBg1PbKwldN1neQN?=
 =?us-ascii?Q?/RYVAUCjd9WtJhn2rqFCnG9tQ42NwHp4PipfuB0Q8BE/5rxoeSN4Yw0YAQJy?=
 =?us-ascii?Q?EDQHHsgNWQVQ8e/Fud+8qb6hXaOgQLu7u1cw1Gszpum5V7yNSB5tD1zY2Nh1?=
 =?us-ascii?Q?NItv8/e4F4jURHVqg3mFEwUWVrapXxFRaa/xOhY/0xUjOySaiLajIPyYdhZe?=
 =?us-ascii?Q?GPpLYFzJ1pArIEyY5EcYoyBySTyPOXmZZoHETuokur103vWtvSLIuSb10MQm?=
 =?us-ascii?Q?0CkHbo9iCfGB5j8874w06wly?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989a851c-7ed7-402c-79f6-08d98276bc37
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:54:32.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: buA4yaYRhU0MFMaGpsv4VUVKSnq+CieHwy594pEwmYH7yTmhIWmSch43ocKMUYbK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5507
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 07:13:01AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, September 27, 2021 10:40 PM
> > 
> > On Mon, Sep 27, 2021 at 01:32:34PM +0000, Tian, Kevin wrote:
> > 
> > > but I'm little worried that even vfio-pci itself cannot be bound now,
> > > which implies that all devices in a group which are intended to be
> > > used by the user must be bound to vfio-pci in a breath before the
> > > user attempts to open any of them, i.e. late-binding and device-
> > > hotplug is disallowed after the initial open. I'm not sure how
> > > important such an usage would be, but it does cause user-tangible
> > > semantics change.
> > 
> > Oh, that's bad..
> > 
> > I guess your approach is the only way forward, it will have to be
> > extensively justified in the commit message for Greg et al.
> > 
> 
> Just thought about another alternative. What about having driver
> core to call iommu after call_driver_probe()?

Then the kernel is now already exposed to an insecure scenario, we
must not do probe if any user device is attached at all.

Jason
