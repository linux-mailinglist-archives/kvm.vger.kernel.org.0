Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909743C9EED
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhGOMvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 08:51:11 -0400
Received: from mail-bn8nam08on2058.outbound.protection.outlook.com ([40.107.100.58]:49665
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229595AbhGOMvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 08:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yor17O3Q+G7qIRyUQgOGfNmdYDP9zli6vOGy9z/83d01XuI//RGf0aRkwuGrU2a3rRf2m8EAqVDNfr6Hb40DfUkWaYSO4EYAavl+Sv2rnHHStoFHN75mAXbq5NDLxZomhFyAiFSjf5KInbXTGgM6HInMEYYH/yKBfmiHEgY1djCB3s/C9tDal78HmJ3rZblFx+QdsLn3sPAdZZtf3AreNzW4FHlRy3t9BcUDFhPv5XPonhIvFUQqkLWmWfZzZIb8c+0axbntkF0lKu4nJfRDApvoG/8d9Aq70tDVqRMYFpoSuzBF46PleTYyaTmTJrER0G9AZzDGsB/w5M/C7RRSPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5s58ylgyYa7V8DgLiR0rngwQRcuAJ6z0shw3fpfPHEE=;
 b=kmoNIGwcCUof7mNdXNJ/29ADXGSnfLBVsXl8dDz/eLySmYcolFR1QsCUUmpPVXW1qc3/6eFzjIE7bcpkgDXtUBCssH2PzOotcePZysxVEQwvDHYehiMgWBHTRb9JfSotZUMjnNUsebK2muGje6o8+0Y13Yoe56zbfq7/hRMlE7Ve8/znxjLgsiTLt/KrQC8wshhvxnFYH0jIdl8SqlC67I+fkMrL1yPAruFTuRBH53EEKvOCsWf58E3W2B5xz2S4Av03CvLkmPNzJxK8SQ9noa5xle3hUWByKdFxqQFVP26daKX40k86lbSs0ptYOkFJWLj6XQSluZsO0MP4zuvxNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5s58ylgyYa7V8DgLiR0rngwQRcuAJ6z0shw3fpfPHEE=;
 b=B3img+kLVV1mrtAkkWCuTdwWOqQgp3jOA5nTo+uOii4/D2L74hAjywmFNaSeP4b8drbx7SOfe+X0nOKWiWJ7UWuqutL0Pjb/43oK0T5P/t16VY13Ytp88j0ILY4s8DixpNaSodQ0XqRq8ICbmMeonbQ9+QPyV5DLLs3kCUtSUxwjWvflFcmVrRw8EDiueGVJ0KJZhy7ftOr/nZKLKZhzIwOAwqWnW2tG2Wm4kRbIuJnstzuuIFQl3FirB/2mBsgfHOqxe35izT2fJL6ssX/5TyWHbC+OK5xETLNckr3tZyxsvpRD9nl7dLKj8eqmmElL1B7ZzCUsg20gvc7lkrA7tA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 15 Jul
 2021 12:48:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 12:48:16 +0000
Date:   Thu, 15 Jul 2021 09:48:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
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
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20210715124813.GC543781@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BY3PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BY3PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:39b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend Transport; Thu, 15 Jul 2021 12:48:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m40mj-002evu-A6; Thu, 15 Jul 2021 09:48:13 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75ddfc5f-232d-4d3f-06c7-08d9478ed06e
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5555F13E045AC1423BE0DE6CC2129@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cDfOCxj9HZuXNROadDzalAVSnoXQ24Wr42Hp0nIwtnyKIbZmNjSKToNC4NVzkaeIvjG8vgi/R89gfdhcrEpCFCHOQniwPHisbKi17NLvbWfkaUu6qiPcZ9XLrCbYodTKhLQMZOGPNttgUvL8ccJGRvGuTXQ0XVJGTKALgYA3/CgY41HM7GxLqRyTIHR/tykgWlSU5SBLKXgsm4brxncHe5FZWhgeUqvWkYJ2IDncXtpqilr3Ph5b5F++XtpEtws85Pb4g7/9d1eNP6TMvCSMnRV7vFw4Fkfqw0EG3njmBys9zUVqfF5M4pMuPrA/M+13FsRcaDDj4B4kSWN9TuqFd2ceI0JQWUbrNP0rIYWrODjbLuBTDZgiURXF5XAS+dvCGnMNYot9IvqWKE5hp84lry59jDFArQmA9UsjxbzQcZ4pQUGw9xEGxIu5+QDUlNmfghyEa7j1k382j8XTZXipxjzWKmrBFK37oZBhWdz6/hNZmjWogcRd2v+rSmHXGb5gTbkWrDNeCQr76SjdRNJPUQpefbf8IsybkUI5RUBxdfq/8d5Coj2uz3/0kWfPZaLsQTcRvthVHoQh4sPZCkjNPw9DS9CR4K4fzXEJmUumci8KtFFsqLRwmsw1/UR3Jvv0/0wksLIA2nE/tSk4h96fsngkE2Gx6VVnBmQhhyhu9PaqgNhL1yfiivwAdVSHzJ/IHpaSpS+Be5HTT9R1nguXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(478600001)(33656002)(86362001)(4326008)(9746002)(9786002)(26005)(186003)(4744005)(1076003)(6916009)(8676002)(8936002)(66556008)(426003)(316002)(54906003)(66476007)(66946007)(7416002)(5660300002)(2906002)(36756003)(2616005)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G6N7yBgsLlx9O16qWEDygJQvb3R3AIBBWHtt418caRBaPcVGMHW8WLcg/m2d?=
 =?us-ascii?Q?Jn7HHNDmCT+DDJf9LyFjAVwam4R4vkwcdDqiycTRvWnZaMx63XfxfDm5Fj18?=
 =?us-ascii?Q?t+0b2z+UDKA5xhKcblQMzauahymQRmoKTEGmyL9GemYeMAc2H4yro+4g9NsA?=
 =?us-ascii?Q?jTYmV+ISOXBCPn5tA5j8w/NCsPjkzss/OB3JRS2xMt8XT9wTJ/AXHpLyN0P6?=
 =?us-ascii?Q?WPMpACYD/kWkLFMxXHGzUSHlP5Pjk0hsrf4jrwE8ZkEqrF+8W9FvLxYAiwTH?=
 =?us-ascii?Q?IfcD2aGbt5E+bQvJK+GN2fHmQr4KX7ybQrN42v9j31Nx/JPbXLjaUmcZQnlU?=
 =?us-ascii?Q?VsC2b7JqXYnm+MpFY+yj6Zpq9luGiYhW7BHFYoR3sTT5nlKQVx9/a+xRkyv+?=
 =?us-ascii?Q?pAdvP9zbqPDhcQiyyEcx/G5o38fQSO8aFIztmVlLQDjeShSPY4jgsPdLdVlX?=
 =?us-ascii?Q?BBHMokB+SwemnpgaayVP+pgNxHjBxbakBlotMRIThT8ii6D5jMTCH43lRluI?=
 =?us-ascii?Q?sHMSvg+oV+/8dqIZQV2owlbdN/RJT70uiH+A0qCU0+3Kxm0cAbudYJ3x7do0?=
 =?us-ascii?Q?vnz5KtCtNCO2tr7KLCPZMOkDZZ3VqMQ5XKM1NbJMmbNPTT+0FnftOfXBZy+L?=
 =?us-ascii?Q?feN1hnkhao7T+rnUkBlqT2nKignLN2LILlodTuW/pl1s98Ep1uQBnLButH6p?=
 =?us-ascii?Q?xEsYxt5fUzbz1uhzE9U7G5fdscThL3sPisWojsq1Z+CiFNNNCOoWmwQgQ4Qb?=
 =?us-ascii?Q?JNWM6LfQ1AOj6ZCgMrUFoVQmR7KaU0I3lWp2YL5gRlijEWC5a9MivK3XsYnw?=
 =?us-ascii?Q?KUxOimRj+j5EUC5arEzngKYWDklY4EAgclEghUHHlQc5hwzTYlntdcKWFY4u?=
 =?us-ascii?Q?vnkBbAGTQ7GOGfqIw49Ejc6Oikhv8RVol6/grXoU2JWKjSSUaL3F8kPoCcan?=
 =?us-ascii?Q?tDZNXZfvCatho08H5rq9noDuYdPBMlbLEWejYHgMKll4fcDzUyk0tI4TJtOW?=
 =?us-ascii?Q?UdFtBrXpUDFtQMaNFgVFjUTjm4H8pJznrlJFScaRu1I9yfhNQ25ra+BFp8ad?=
 =?us-ascii?Q?Skhjbt3aQFKrHZu+US8Z1uTx335JuDt28EXHYfLbhHx5YyVrYOUWztSt1V8B?=
 =?us-ascii?Q?GgEByGENUaYODFFf9ytzMOC2cJZpnNWXM/3OPAG5UVqs8Hx3jmKk4+LfhI4G?=
 =?us-ascii?Q?JTwTTTzZtmsMeLWQvkiOTH5623Is3SvgTvYuYINoJyycOqy4HW2PjtiTTB1L?=
 =?us-ascii?Q?fmgV9sC0xjt+uGhAX8zGw4RYJS3YqVBOz54ZX+dmrzvh587lms8m5BySbutD?=
 =?us-ascii?Q?k0gKAI40/Vn1dBZvDFadgSoS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ddfc5f-232d-4d3f-06c7-08d9478ed06e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 12:48:15.9516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMb0vw+T+pm4qeNp4YNNrdrC3FVPfQoD69vg2YmDxKmN8XHJRsXVySNfny6UBDc1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 06:49:54AM +0000, Tian, Kevin wrote:

> No. You are right on this case. I don't think there is a way to 
> differentiate one mdev from the other if they come from the
> same parent and attached by the same guest process. In this
> case the fault could be reported on either mdev (e.g. the first
> matching one) to get it fixed in the guest.

If the IOMMU can't distinguish the two mdevs they are not isolated
and would have to share a group. Since group sharing is not supported
today this seems like a non-issue

Jason
