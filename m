Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B524134B4
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhIUNqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 09:46:40 -0400
Received: from mail-bn1nam07on2078.outbound.protection.outlook.com ([40.107.212.78]:60294
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233289AbhIUNqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 09:46:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R75jtLS1xM5yJxXr+PE8H+2Ec/+IN5lW+HuuXEaprKAbReg7bpg/77fd+F4/qG4atPHRX5P5dn1RByW2s/o0iU6QklGpmAgO9fE8gJhzyMCnocQz7pd2F0bH4mQfvW4KsKYkgAwpfvfHylwszTumTnzq59icZ4lpiCzUisSmw+E/iBMVDU3g4d/8++AnmyrbInge7m9Oi/jSt1yIUGS6fCX265vPrqwAzDy+na7sT/hrtXlvjCl4DEZZktlI+tXh6DA1mPhY+hIO77G2gagasyS266g+0n6c2YmUIUV76H9t+Q+G2k7JiqC0cK1DJ3ljXExm8EyiFF+BSw2uz4BPEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Nc+1R6n9uacoJl6dRDPvcVxljHhtW21u21zWiNRIc78=;
 b=X8fbqMs0Q1T6PlgE6OTrgaWr2Fvo0ZPuyo9RxF0lPwdxVLaVGepwjkLUL7Kev69EZnJfeS5rk6pP+kfe9RzHTfjhU0D14A+RCH+5QSxv6841eYf/nvM69iDYoLps+NicE+ht+eqaap3xnfnrDSA9rLmNxA6oClbmO0pnNxQORDl40SSbIT7Du0dCr8rAcOwC/5AE4bzO5kw0L4YN5uz/gpxyz6eIfiwCP7kaDaqj+yi5mrwz475Qcx6ALNNE2RSVr1EG6iw+VaC/yRlyf8VoLIJ+gIdeO9VY2kYRsuGz/sQ0PEiiozOpZDIXq1nceAITkLOYxz0SgCOd8R8XLFPHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nc+1R6n9uacoJl6dRDPvcVxljHhtW21u21zWiNRIc78=;
 b=YznDBPPMOY0/eE58uGOFreNm69+PS4NZNJSc5Po5wYBhUqQzCcoJ+t7VzBD8n50oBKmxRZG3dX/jPh9YZ83LYW4LV5lpsKMmUMcD4H/c07g9U+B6ohmj7WD6kMFfcqzKH9NQqgUnxGgrrAKNN60RzhSKvTXisZptp3n8+ixW33JOcVI0vuu6cmr5tHmbGtTx9ldfO6rkjoMHxgpiXgn5MqJgenxZDe1ISWIDNy+c0pBUne5l1Lotv2E6cRf8uIwHYTwAC4xSvOaRpsAKPRxiz+oPeKsPm6SiJ4+qN1Snaaq9BoeEIPvPjeCR3zlfS+cFtHD6jai8hfST1arqQ9mJaQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 13:45:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 13:45:10 +0000
Date:   Tue, 21 Sep 2021 10:45:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space
 management
Message-ID: <20210921134508.GL327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:208:120::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0018.namprd10.prod.outlook.com (2603:10b6:208:120::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 13:45:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSg56-003Shl-Vn; Tue, 21 Sep 2021 10:45:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d615b4d4-890f-4ce0-29f8-08d97d06077a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5221A7E41CA9A5DB2547F497C2A19@BL1PR12MB5221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPD36VXbO9At6kr/wWl+CaHqx3W1u9u0tjqhKiSaE/TXQRTMpczesMA3ZfF+9IzddYwbVNKAQJ6EPfDx6Nsrq5wXg1BneqmbfLFvZtGnN8wdQ2RtbgWVhY6o7cA+q8zWBjzPilQTHGWlkDt3Kp+QmmSjmV/eNv7ilMLo5LsWrms1Ho9YVFBdkGJPbIDYzybIF8kzWw1WfGtqtXrOQiMWDhQDC+8fmtyRFLVI9NHsC66PxZKDqebYaTguSDyfvLwOdYua2Lgr+sxrU4AsZQDNJgDwYwq4MtoOyVqzeg2JOHyjo2RUrgrxjOs0OfABa2O1he7TsYUwZwyADuSC3eH/n88hqFqrSUon9eVAzbbVUBC68saeuwvv8d5AqQ3nOQBJUs5ZhNtmTCNla30avfWEIzNwujq9b6f/GMJdPoyBkZNpMr6ApMVXUfA4QPYYGlarvASXKyU8/kvEQZaGQFBhgyUJ67KFzFAkgTVWlD00QH2WOtI/2BHPpX8E0HoulHFRzcR6quM3b0Ozzi0vEFwL7hppqiGJavcGQw6AhLc8Rfapq0q6yKqS0vdBA6EETw3mKXYuGGOhSpXHWl11w6n8cLkobahRyj+Z0FM3PVZW48LrU3ChmCua+CnQj3Zq5jpuu8b4ZThs/xV9npWiY9Suht4r/lfh38Q9S26HKq4t3S13eujbouPp2n5wQKrW3l4d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(86362001)(26005)(426003)(1076003)(8676002)(2616005)(8936002)(2906002)(66946007)(66476007)(107886003)(36756003)(38100700002)(4326008)(83380400001)(33656002)(9746002)(508600001)(316002)(5660300002)(7416002)(9786002)(66556008)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNlgUgIKJuwgssXD/cYJ6xuD64uoug/UV0bEXfN6WmVUtb381FpRPvgtqGwZ?=
 =?us-ascii?Q?eMmCJT2sO9oZrrp5s01Osnudj9AiQU7we5xtbZSDZ0oHXgWVllI4WH6eH+Vq?=
 =?us-ascii?Q?GV1u4mpPMA6r9LnssxReahgqZgrDy6dPYNl3tOWLckPibWNLz93/818fqc/x?=
 =?us-ascii?Q?8t9IYkiqMgsDlTLS5w2Jvy2mo651a747pcblLfGERJHrDvA+OHQSE4cfo9TG?=
 =?us-ascii?Q?lyNGbO9U9SWH98b3t3xeF8nHPzo57owzNSDBtrbN1T5UTi/GjJFw89IEQYFP?=
 =?us-ascii?Q?FDMYmwB2FuD/rYGhqBa78RF0wfykr8zmbj74cbNo8iW4OWQj9nzms/f1t9ns?=
 =?us-ascii?Q?qxezLyuXe3e++uG7ReBTsNbPLPObV4a3aKT8TVSMcryzbea48+1xcIH1Sv0F?=
 =?us-ascii?Q?J3npZXE5m4Q7cKDUnd3rV5hoDcoL6aSOjX6897MLPtxvMkm0iMfOA7DkHxPv?=
 =?us-ascii?Q?p22rKnSRyKPYT1GwiZqA5hC1XtZDnKX/FW6cP9i3nP2r6L4aOROBQ52l9xbV?=
 =?us-ascii?Q?XGm/DZrKIdLgcK/K2jhsFiP93zsRBIpFm1sTeKR/uVgOi/dYOEC8/0gEQDmt?=
 =?us-ascii?Q?BAUZ/WYbJFv4sGgVe8+PL52uHiPKUZ1LBic6qq8OH1POJdFeWZ4L9hgITVno?=
 =?us-ascii?Q?8SZWt0521WssI59rUUTDdTqxvUO8/FqiQgDc+rzjmexIqI6avPa0g36pemJ1?=
 =?us-ascii?Q?bHQwR/qyE9O3SEV2Dsa8zPS0w8CoeKLkwzxhCWqO6xjIOS/OAXCaLYJOBxtt?=
 =?us-ascii?Q?HbhvZAkwvG7UvaBy7drtSOSWUyZSfNZwDIgtbEpUUFTIOqhF7ViUJJFTQ0jW?=
 =?us-ascii?Q?w0iWVTFaigZYlugRhuEFmozs6N+w8WcizeRLuug3Tg8bgou4ufpRoWQZSTFY?=
 =?us-ascii?Q?xhwYIA9ux5oTiT36J464YOMI6TqUdW/x5AIFMV8dPM0A27CARVWm6kupPgAZ?=
 =?us-ascii?Q?H6uNPRB7CthsqWHUU9p0Ld7J5fEC1SEQQjpe3o7JRp5lb4HwBQZ22GekPZ3p?=
 =?us-ascii?Q?Fg8lJC2DrYNMVQW1HsnMTSML+i86brhC8QgdZ4Zts1Swc6w4BVE+ajHgHi2p?=
 =?us-ascii?Q?aPw4K+74lzLHzQcCXVN/feRtaobNii2BxJsr3tY4JLUVDtPl28oUUok2Ih0t?=
 =?us-ascii?Q?DWg/FPr89uWDcOEpGn7Hx3f+UbcNKdFZIe22Mz1kY8Isvs3ecvruGY54riev?=
 =?us-ascii?Q?eQ2n7CdNfU7OmoPaGQhlxDJ1P3aajhazzryWUkAdyZ7t9hcDtEHg+x6/Kklw?=
 =?us-ascii?Q?GXlRI8dAzC8itf9n+uGOnBdR+eV7EZxLXsQwtt4mdFU0ta3bY84tgLcJeiNu?=
 =?us-ascii?Q?i2xdwMoqOg8opHiDctpf9znz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d615b4d4-890f-4ce0-29f8-08d97d06077a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 13:45:10.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phWVkSgZ6pg1QXj0j41IVwWqGBcQHApB4o833pkXQnur2ztxA5Vly4PPti0im5oo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:28PM +0800, Liu Yi L wrote:
> Linux now includes multiple device-passthrough frameworks (e.g. VFIO and
> vDPA) to manage secure device access from the userspace. One critical task
> of those frameworks is to put the assigned device in a secure, IOMMU-
> protected context so user-initiated DMAs are prevented from doing harm to
> the rest of the system.

Some bot will probably send this too, but it has compile warnings and
needs to be rebased to 5.15-rc1

drivers/iommu/iommufd/iommufd.c:269:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (refcount_read(&ioas->refs) > 1) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:277:9: note: uninitialized use occurs here
        return ret;
               ^~~
drivers/iommu/iommufd/iommufd.c:269:2: note: remove the 'if' if its condition is always true
        if (refcount_read(&ioas->refs) > 1) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:253:17: note: initialize the variable 'ret' to silence this warning
        int ioasid, ret;
                       ^
                        = 0
drivers/iommu/iommufd/iommufd.c:727:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                if (idev->dev == dev || idev->dev_cookie == dev_cookie) {
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:767:17: note: uninitialized use occurs here
        return ERR_PTR(ret);
                       ^~~
drivers/iommu/iommufd/iommufd.c:727:3: note: remove the 'if' if its condition is always false
                if (idev->dev == dev || idev->dev_cookie == dev_cookie) {
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:727:7: warning: variable 'ret' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
                if (idev->dev == dev || idev->dev_cookie == dev_cookie) {
                    ^~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:767:17: note: uninitialized use occurs here
        return ERR_PTR(ret);
                       ^~~
drivers/iommu/iommufd/iommufd.c:727:7: note: remove the '||' if its condition is always false
                if (idev->dev == dev || idev->dev_cookie == dev_cookie) {
                    ^~~~~~~~~~~~~~~~~~~
drivers/iommu/iommufd/iommufd.c:717:9: note: initialize the variable 'ret' to silence this warning
        int ret;
               ^
                = 0

Jason
