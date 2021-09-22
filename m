Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88541491E
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhIVMlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:41:04 -0400
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:14049
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235834AbhIVMlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:41:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cenC1dct0s88Pobc5FWCVX6JrMMgVZq7axt0w5yxaxk22M4w6rQgQ5EobWYZDXRyNegpahCMtlIU+ySF/0HG3wFECvkZo3SKKwchxTaRbrRkUKeDrTX2Gp9VnAUBph6Q8E4saN+9YqNraTVkLPPmrbvW4hkO3Eh9LU9SrtH9vpij8yUGinj+cSvlQ85IYJnVLAOuFnNlh+KHzSCDcjIyfzOANpdwHMnzqIeBx1fWd7FoDYNRIc8LKf+NECQceUFt8Z0w+gGhlkL8KytP4zoUfTvY8C6dECSEF2kTf0H93xPkVYpc5Hyl6Gj4Jw8a5zqSfHxnm17QKKhST0V4geWmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yDIAW2WLbFmU8KTv/a1YmOFch/yG1cTGJy255IXnLgw=;
 b=ZTYzZZJkq8VkiHPDnhwaSy0jvIQ5LjAeLJCxulvpuhP5pSu3lVeOa0NuRDZxajDUZonAZBU5jO86zyOSWOZQFhgPK64IMT+gkFSsV5aD+fcxDnxSZI9pTpvx/bgkjiFuy/aYdsumoIrk8MN6WHGyb7LzYgPIWrwF3/WP1jlfKXLEGtBxwkcYGEwJrW7fK4IvxqBTKwhvTHdQXULsW7MHYofF54coRXfDCysVBn4GcbLJ0dLP0xO315VjPDut/adkBM3YbnCNf82gdwD8LOOPlowc6+Ts2p0SstNHOjRwJCGuMaIbPWA3bp31G50VTYmkz7zxrJtaNkxfaWhDkEVUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDIAW2WLbFmU8KTv/a1YmOFch/yG1cTGJy255IXnLgw=;
 b=Fo/DJbxC8XmZIKn4v+2PuLT0lT45S5F+Qdc3gktJ7aSIydDOdrkqpmYvN9dbFrVRQJXVylBqGv032QZvq6MviQU0dIWeV69LSl2TPWzpncpLrdTkp316dktLcx8lGAm/zz0cDdi6mCoqzYtpwB/oX8mCAtN2WdS1iQNAH9mupYM7QgOzw6mvUFrGh+ZgHTfKABtakvreOmsSLV6D507mcDPgnsYmroxBE7qE1VaSf21p9wmABMhlFnl3ltn547X1ExKPIPDIK+nobTiXBBVY5RwAbd0aMuWBgnS7BcAFVsDQxl7fy1pScLNMzRq9y4DzTJBb6QUW53qwQxV/KJFgUg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 22 Sep
 2021 12:39:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:39:32 +0000
Date:   Wed, 22 Sep 2021 09:39:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210922123931.GI327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0374.namprd13.prod.outlook.com (2603:10b6:208:2c0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Wed, 22 Sep 2021 12:39:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1X9-003wvW-BV; Wed, 22 Sep 2021 09:39:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c03ed3b-8908-4e17-0ddf-08d97dc606ea
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB506351805C83E8FDA0F55C71C2A29@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n3j8uoCJhUsyM012dK9CXr8YVzZ87sOFW7QJKZOxkkDYMCE05kNm1USuz8XwaAshlWn8DOZHhsbA3VIs0fBADSiF6FgQfxjZGawQStqKdQhpoesp+9OnJw5i1y7fC0x9kVEOmr7GFkM1q9qyTmXwMiAlordimWhkJp5Ub0/boeevMLV/BAZx67IvbPiKxGfFd79pm6i0Zb1gN6vZHK5rAscRbJo0Vq/1ruOjf902boArOIwvCI1n9U8sxSJjDnW2ldvs9aV3Cua1mXIloixjE/fymYPBll6hcjwanU5oqum0SScYmxyzCVsOG1kjGYLc45vklQdGjJTWFJBVTOEm2857RJZjZ9LiO4JbEzFIsPhbuZ60VMOIAkqmjL0jNumebxO/KPsi6YrZ0TUC48ckBaaPoHH52xRX/mQw1FBDGuNCWPT7PTSif1Dj7I6sRxDW6Ndjp75v6TO0KQ+OFjX2HKdCIcZR34Qg5mXYwi1EfDkFr5lywO6vdPqziX2FwzpBoAb+PA8PAubrAv/9pAxBc5u8iR+5U7JmmMuTXr40nIRMZH1WhKvrnJV1XkgUgblTz9+qvpPUFKi8nPEDMKRVrDzWhElsEG2rYkoYfO+X6PAY/GxdbDNf739RzmlYjvUUMK6ozZyvjrQIeE4VKM++KOh0QumnPEEUTQm7IvLKoRRYxNggt46G+D689VQzVXbF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8936002)(54906003)(186003)(316002)(33656002)(9786002)(36756003)(9746002)(107886003)(26005)(1076003)(4326008)(2906002)(508600001)(66476007)(66556008)(6916009)(83380400001)(86362001)(7416002)(2616005)(38100700002)(8676002)(426003)(66946007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?flNm2Bh7f2SQ83HwLHAo/PVQrmgziJzYZlYm6KOr1wDooJ5zH2P6s5k2LpEW?=
 =?us-ascii?Q?K1fZWrppQCDsbYmjc6DK2zMfpbXnjLWh51IKmU88tUljwv5+wdkaxlILRgcg?=
 =?us-ascii?Q?EyDX7imtcCzWatS/scYwrO8sO9HTRg1bpfy0OhSgZvRR0UXcRCKQW/VU1RbS?=
 =?us-ascii?Q?KPnHmNbVRCGcRRGeslEAzJ4kKRBMVWxbc3+BiMD5BF0TVjkC1TLMD844Sazn?=
 =?us-ascii?Q?d/VjSw4ZQS6ndcZQHkQPeNm6RVEs3yuOZ+fICrUQQZsdKDOZNzRUo9ub9Cvw?=
 =?us-ascii?Q?rXhJ9haw3aQpbFNvFtyoinL3kBmJloRRvk2Ql6eFUDQ2P71sabG5/MGn5NPO?=
 =?us-ascii?Q?70CnXkdJxdnlCJDILq3EKsS3cIQxYpbG0WtGw7Q1tYUq2bLov47rUESv/4Eu?=
 =?us-ascii?Q?uI7QETCc8N52abfgQWXhFTgPPduimHsXT+XZobA6JQe+giyWbjWk8vr/U7u/?=
 =?us-ascii?Q?ygs/FiOwKR7g9FJywCKVzJThncCkbCZUpw1dyC4nlwSbwRNaorJAmAVEhShX?=
 =?us-ascii?Q?abbGB5YfA9vNVFwq0yX6oE023VA0OkwflYPHBxyAHCyFpWNC3sipGb4Q/0xL?=
 =?us-ascii?Q?T0wpce3Vp7TzmyYdZAwSxOmEnNf7z1z4aY6CHmq0hwK5x6GWkF/Dro+/Odns?=
 =?us-ascii?Q?Ig4TTsDHzLR0E/xFnBItSPLRsHFsR71jVrLdu/LiqK1+Xj+TS1SRX0pg1bLW?=
 =?us-ascii?Q?bla0O3EZYHZVfOHUDi+TS/OcUPh33sZC8DC+YrF0RZhKpzXh1FYHsgxXyYZ9?=
 =?us-ascii?Q?DfciO6LVRm81Oz1zSBL0/cbfn4W5sF7AR4b4EdI6kgXCi1QLQ6BMQygJP2i9?=
 =?us-ascii?Q?V5yFVsGVYBv5gFwJD67PhFGWqEr6h666H/ciEIaUMcT6uzc+WPHWu1ni8+3K?=
 =?us-ascii?Q?x2S/vpSXEg2BLKKsB8BNOWl4ax5L57Knh/nDkY1bigaNPYJOmj4kb7cZCViL?=
 =?us-ascii?Q?JXOgcS1bjQie8m+l3ZBYa6OkonPbw3hT2LtcKGYiAnJkT7hz3s745fS13utQ?=
 =?us-ascii?Q?6zfD4qu3PdZuDoVsf5ibaKqttSia+gJ6H+1YsFj0iQNEaSHYdbxYpd7IpCnk?=
 =?us-ascii?Q?Va+sOJLqRIw+pi6gtZilJxLTrHJ0YsFX/uYdkWLsIFfGyBgtmjbnlOpnzKu0?=
 =?us-ascii?Q?Dlwxsqu7CQ5K7JBgjq8WirfIM6SkahdPmszztGI/mey7NgQrDijfovGt2S4x?=
 =?us-ascii?Q?xi0hoZJ8ahWd/8syBPLcNw7RADMnEgMzmT5RcEHbadS6VMxbQ3Sog0OoPaXN?=
 =?us-ascii?Q?KjbT0vAxbdrIoSNnZkTLRuO9ny9OwvJ0uYsNq/3EOTLdXJskxZv3BWQkvyso?=
 =?us-ascii?Q?tZtpNV7tMPauNVEUogeOW/ur?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c03ed3b-8908-4e17-0ddf-08d97dc606ea
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:39:32.6487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7J7jW0oMgg9Q2P1rcJ8DOtZYYJtNWOVtZ0t4OLCyQCp9epp0K4OuRP/TuzriF9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:47:05AM +0000, Tian, Kevin wrote:

> > IIRC in VFIO the container is the IOAS and when the group goes to
> > create the device fd it should simply do the
> > iommu_device_init_user_dma() followed immediately by a call to bind
> > the container IOAS as your #3.
> 
> a slight correction.
> 
> to meet vfio semantics we could do init_user_dma() at group attach
> time and then call binding to container IOAS when the device fd
> is created. This is because vfio requires the group in a security context
> before the device is opened. 

Is it? Until a device FD is opened the group fd is kind of idle, right?

> > Ie the basic flow would see the driver core doing some:
> 
> Just double confirm. Is there concern on having the driver core to
> call iommu functions? 

It is always an interesting question, but I'd say iommu is
foundantional to Linux and if it needs driver core help it shouldn't
be any different from PM, pinctl, or other subsystems that have
inserted themselves into the driver core.

Something kind of like the below.

If I recall, once it is done like this then the entire iommu notifier
infrastructure can be ripped out which is a lot of code.


diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa90..e39612c99c6123 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -566,6 +566,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
                goto done;
        }
 
+       ret = iommu_set_kernel_ownership(dev);
+       if (ret)
+               return ret;
+
 re_probe:
        dev->driver = drv;
 
@@ -673,6 +677,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
                dev->pm_domain->dismiss(dev);
        pm_runtime_reinit(dev);
        dev_pm_set_driver_flags(dev, 0);
+       iommu_release_kernel_ownership(dev);
 done:
        return ret;
 }
@@ -1214,6 +1219,7 @@ static void __device_release_driver(struct device *dev, struct device *parent)
                        dev->pm_domain->dismiss(dev);
                pm_runtime_reinit(dev);
                dev_pm_set_driver_flags(dev, 0);
+               iommu_release_kernel_ownership(dev);
 
                klist_remove(&dev->p->knode_driver);
                device_pm_check_callbacks(dev);
