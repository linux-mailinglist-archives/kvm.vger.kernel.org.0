Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F9341975A
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhI0PLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:11:10 -0400
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:57889
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234972AbhI0PLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:11:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDYavr81NKBq5plZodLomf1LoFxJ+t3sA9RCjV0LJ75b65c/dfi3dtmnCugE7d0OEHE5FPm+bZ4fMvkoYOxfyVormwuabQAMu9vn3wZ3txo1dCCuc4Rm7LAOeywJe2Z6gWL/K/KIGlhA3WRZrRyRJ/BAzdk2msBixwp4ZCaceV7UxGx9+DPNPs4sfgowOQnUZ6zxNVerEb3S/Nksn2OKrzvz/tngVJUyr9K1mghDE6B2gqeR7/oX9jXf1md24hwquJfI/TEN4BDIq94ds8YCvS6T3VrAtkBSBWAUXhr9n/T2963lmT+fgcwfyJB4KNx6BGy53oqEauDUxHwlaNn3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l/bm4ttqEwn495jrv6wBS+wY4PQ5uN6WfKQI50l/UHA=;
 b=BviOWsDY1NHyjUUljmmIYn+ThFaOELtYEVLVJU5Lto7Ih3bN9HBInmpz4cI+Z/j8sRyq1wH/a/96MtDDoYIpfIos7u8x98ybmgKl3JmJYLQYGpd5wcDjYP/gRCvsTgOQR0his7osVwOKWMuGaLQTH+MsSXM/gTRKdY7Ir+kAxIvCpg/6AwposV8JrLakaxg1clodHoGnzDdNqoU6m7ABiWyNhIOZ9kVzgDI1mQ1oNEz9EXQszbm+4kxsWvJvJvsUXY9dnbVYEh/cVwL8ez+1bSqE8DHWaGFruL2VPdTq3j7csy4sssrAacpX8OsJAGzMCqm8c2JXjukolEJeHA6oaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/bm4ttqEwn495jrv6wBS+wY4PQ5uN6WfKQI50l/UHA=;
 b=B2r2ub3fOnkJR21EuRY7Zk1NOmjjBHb+C4KZldEJ9LVcGHo9FcBiate4CHFoBSTCkDhdZ2HqYBpXCa26mqs9EkM/IY8h13X1nSzY4hJle+h6yFXXR4MOeahKAorC8bffJU8eFXACn39698dyCndxLcvAm1Q6mKVk839PjkqbtvckDmiHm++uDwo7XrOZI3Wy8Sl+UUWmbp8QTlPCLtrgB65ojRj2CS3CA26PBsSP7Mpw35XZE6GRH3ltP/k+078oK9XhptxoJuCbgJNcPMGAz87znLyAxYNTqVlvwtnt27cW8A6faCoGFgAr5+tYCZy6LNhiltRrG7bDA+wzj5MVnQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 15:09:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 15:09:29 +0000
Date:   Mon, 27 Sep 2021 12:09:28 -0300
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
Message-ID: <20210927150928.GA1517957@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0005.namprd22.prod.outlook.com
 (2603:10b6:208:238::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR22CA0005.namprd22.prod.outlook.com (2603:10b6:208:238::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 15:09:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUsG0-006MzP-EK; Mon, 27 Sep 2021 12:09:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae576e4-c0a7-4e0a-a3d3-08d981c8cd85
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB525660A1B1E66577523F6E33C2A79@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URcKVQzoV96HRi5ayLccS6vKbzJAmfKSvvYURVW4xAlsoKS8EdsG46kXNh3uvpytu2yGxvgxDp/B7Tp7Zu/0v4f99UlhHkDYQox5YN/E6TDQ1cytZamM6sVXIgD71oEambP34uLmeb7W/kiTCd0r0jD/2NZXH/tLBkFXfATLeMgKSErlmcXsryP+rBgXmofkE/yqLFt5nv819cOfL6qQnKQzjO8jXs5ukgwAtZnokFje3KCdivQBRCpF64SJ3a1ZjvEXb+xuZYvE9OJkJjQIHQGwS7SDnYtEqe6HM24T83w2+qo9gb6gDMvo5sPf9/GrCUWe574fcA0LQSSz1FCmDzC/tHCOnDQ8lDO5Q1oshygHVrRJlWCEobe0OE93Rea7yN0ZOVhwGgxP1xgvUnAIBMpP1xWTA8rjMqn6mi6qTBR1yiVN22ei4jeHVTvYDGj1ktt3IzrZ5ZiV3p9o1tzFBwOx2sblYVV1Wgattkq6/Yk6e8l1mneumEP9J/4cV4kspSMvwFaFa/1PWw0XtNAjVtrWKG62W4sEI2+qM2rYoPncDuGDcYbYxZFETY8WSfC8X3e2Gss4gfAEJzy7qW/Thjzt1v43pFHELObjPpdY4266WNOgdmQYcm0cS1eoz4U7wDMEB308ZZgJaJO7QzSwkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(36756003)(86362001)(426003)(83380400001)(2616005)(26005)(186003)(508600001)(316002)(33656002)(5660300002)(8676002)(38100700002)(8936002)(54906003)(4326008)(9746002)(9786002)(66946007)(107886003)(66556008)(66476007)(2906002)(7416002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vBkYur2JhgJ/hMToyO0s4HO+hBqSqURnJ0tpVwfVlVnds0047ym/ZcADDbM7?=
 =?us-ascii?Q?FIyhU3a8/YfL2sLBDBYkHFXRETeZGz1oewxF+B/QcOFxJ4J7vyAwdNRynC5S?=
 =?us-ascii?Q?QXrCluJsQmIoWJWcX0x1ajJe4uEF1ZL5ytILWrtzFDg9Q6GXHxWZk1601rqX?=
 =?us-ascii?Q?ki9ClW37lSDKPIiPXS7iFupV3glcO4pINmxFeHQp/5QvnfHYIxWp9dzRe8ib?=
 =?us-ascii?Q?00H9y5bDMA4iN71YCklRCYLDw+AHSgJKfiYMj7Evyt2MabbqvVaVc9R1xqPA?=
 =?us-ascii?Q?FxhSURZmuLPFknoaCgur641FZSexhtgMayB17EGY2d+vsT4VjuQiWcEuGC2/?=
 =?us-ascii?Q?18fXq8SO3z53yFQlfkmcHD7xetn9kMq9juKTgklU1l5yhhSoRz/YpSqed7J7?=
 =?us-ascii?Q?XQ0/kLezl5lTqBjCwbIrrzpEPInIhVpVSutXOVQHkwBZurWPd4mKG28QNban?=
 =?us-ascii?Q?JOWrgKPCP5vTiNcNa8CHYbSn8A696I19EK2Xuo/Nb3OoHiMgY+MBr+ZWKrbl?=
 =?us-ascii?Q?/6r+tuD0HmzaHdr9nhQrYT9MO4taCs+AXM2ce5vvxp5c6UzKfwTApDT4vEXh?=
 =?us-ascii?Q?bwX6iIxds8wkf8U1ElyJkz+b6YTzMYDdPx4GBvDKlrdec3ooqRd7X6LcewdF?=
 =?us-ascii?Q?6MgFEgLK0+M9koLCut+84QWzA5gekerj5r0M4he23XJpsdEtglTu9m8QQvQW?=
 =?us-ascii?Q?AA3Fp7pVYV6XJlItTmUhJlBDVeJh1t6Ai/M5T1iqEbHKs274B2SHGkbDZccV?=
 =?us-ascii?Q?Twl82iYShjarV8+J/4f0W+usko2g2ypyv4Nl+b9PJvTMoEwksRtEDkp6sNvl?=
 =?us-ascii?Q?6hvb2rlgc1IHdfER/3P1xvnp8EG2bU6n8UHMvhkSjiql8Dd5iutdbA0D8Rbm?=
 =?us-ascii?Q?LpgIuzaVFxFzFgbusVu3m6OFjfPWc0DVzyqdd7GBoF/EgtCYp7b1GMYYGakI?=
 =?us-ascii?Q?hfC+vtaW1hGcskJeW+bVbihX7Tu+QKxL8Kl0PY0EgOYHIb5X2hE7aZ6GORMc?=
 =?us-ascii?Q?JiXTGRzAmN0NehCmNTYJL/aNczn9CC1aq8vOzHx+51af1KsXPuHvJ++/pwrh?=
 =?us-ascii?Q?DUXdYRcMYmwvB7kNSriZ0R1zTnRTWSAWFN/DSd04IK9roZMW+SS16V40BmY6?=
 =?us-ascii?Q?boBEc8mDZ39QPUcHgwis/Y/IRNkS3eMSTbmXc/MBZJE77oWICP8EBG2MMDW3?=
 =?us-ascii?Q?apg66IzJjZAPOuYjTAoHDXic5aWzFgzFCgryyDvEW0CYE0EL46/C3YFvZb6G?=
 =?us-ascii?Q?H1L3ptatFymUuL7ZvdwItOp3eu09IZmahGHGyOmzGzZIjOTUvFTKCYLPzRdL?=
 =?us-ascii?Q?5AN9T8R7YuDFonvNmo7SoknH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae576e4-c0a7-4e0a-a3d3-08d981c8cd85
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 15:09:29.4859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFQQ/A8stHEOkF7pH4AZF9U5kn0D98sooG1SX1gFNjL9oV9UHaKqdnXSDMR4ggqg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 09:42:58AM +0000, Tian, Kevin wrote:

> +static int iommu_dev_viable(struct device *dev, void *data)
> +{
> +	enum dma_hint hint = *data;
> +	struct device_driver *drv = READ_ONCE(dev->driver);
> +
> +	/* no conflict if the new device doesn't do DMA */
> +	if (hint == DMA_FOR_NONE)
> +		return 0;
> +
> +	/* no conflict if this device is driver-less, or doesn't do DMA */
> +	if (!drv || (drv->dma_hint == DMA_FOR_NONE))
> +		return 0;

While it is kind of clever to fetch this in the drv like this, the
locking just doesn't work right.

The group itself needs to have an atomic that encodes what state it is
in. You can read the initial state from the drv, under the
device_lock, and update the atomic state

Also, don't call it "hint", there is nothing hinty about this, it has
definitive functional impacts.

Greg will want to see a definiate benefit from this extra global code,
so be sure to explain about why the BUG_ON is bad, and how driver core
involvement is needed to fix it properly.

Jason
