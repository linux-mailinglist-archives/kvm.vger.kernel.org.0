Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2AB3E02C9
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhHDOH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 10:07:58 -0400
Received: from mail-bn1nam07on2050.outbound.protection.outlook.com ([40.107.212.50]:20827
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238412AbhHDOH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 10:07:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mt4EfXRVLpMUV2z4FAey22mvEaPU/MxgB2B+RjKscSHW/QgYt7lG5dv3Mg5gXJ10znmby7+V+Nzg8/WMhTrXytY87sLHGVJLNvlj3u0oMq3kDRZ9xy6IxJGAV3BRs2V3MSob/VxT9ChE+LGug5gxLluPjNzkV9B5PL8pmOTgrSWgW75oLgYrwsqrgU/Ez4RNCjRsKcqCgFe0UgAePX7FGBC+VYdYP+L6pRq08d7q6uR5YMVFAaXXgnCHKzGdHiMKx4r8kdPBNGWjak+RInqoa9MRog/MYSok3rTLWd7Crdp3eHrHq54VQzf+CBWSI2G6OBTmNK71ZvmtVB8rMM32Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhZB/s86kU5FCtqSktiqHXGf5HkVqblO0W988md5dUY=;
 b=nQjrlTuQXgQRWchU6DufNBRNE6sI26njelBoHMu2umB1oy+VXs6Rqj6hGcqQ8XLmKcWawIGQxd5swkNk/b7AprsTL8R1UlzOUgdCX3r/K+L+Y3NoTbjH7PSRiJ9I0bSA9i5owuaQfZA6HMzSmdDrlNShdwjCYwVpOk4XDaW0SufHx8LC7LDr+KJdluEa1YCJdOpP5sV/Gor7/GduXzu4MnF+d7ZIsR7T84KpOCOUbD/dJrzhgxl5f5WgynBUFWHEPeR8ZKnLohtrtHTgLx1l0Lbx4qzpsfvErL3ODTLMcXRZSsGKB+1b0uADALfQG9kUlAGoEKtB2wqszwe7tYpS0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhZB/s86kU5FCtqSktiqHXGf5HkVqblO0W988md5dUY=;
 b=N6CTaAkbuzmZWORFNkCH656jTHncA7NwmmsK5lsczJXfXKl2hifXu+qE0HzfG/R8hr8eFQt503fY4wMWH7HUktFkVaJKFRMXERTZ3o1yHNAK8irOaWUPbPkGqlXTRg3SDJPwxGuJaU/EZlGsL+UAMwNytYuNkRjpEP419+mWqsSICSv8hvaE/nInPcF6hSZwGbBEc/aDSJOhnRvQYUOCsju7yjZeQ+hvb41aqaWOUJXrfAqehawScTKeuWw/WDp6XCcyrQqmMRyvenWoHqzQBN7nNqwL1/jVQeI6BNkutJwzHJEx4tu+4/ZxFjNzkkLw0v8tMR1qVjChwJH5TlAmWg==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5119.namprd12.prod.outlook.com (2603:10b6:5:392::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18; Wed, 4 Aug 2021 14:07:43 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52%9]) with mapi id 15.20.4394.016; Wed, 4 Aug 2021
 14:07:43 +0000
Date:   Wed, 4 Aug 2021 11:07:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
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
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210804140742.GI1721383@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <20210730145123.GW1721383@nvidia.com>
 <YQii3g3plte4gT5Z@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQii3g3plte4gT5Z@yekko>
X-ClientProxiedBy: YT1PR01CA0119.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::28) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Wed, 4 Aug 2021 14:07:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mBHYc-00Cbeb-8p; Wed, 04 Aug 2021 11:07:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f517d78f-8317-4717-5adc-08d957513a9b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51199A01D73251CE91D1D443C2F19@DM4PR12MB5119.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jx79FUnO170epGbKFNocENWz1pKRZkjbIFfZVw7hXlK1xu72XH24I0hMTQoe0rWrl4Henk7mx6SKWoYte+j88r+9PE2oxfShhCQ/qYzxVJL5oLI7ZHv1uAp9CiEc9JmsEuw3iw2k+olCXz05bC3tB2uwn3dMQ4v0Ax5O5twQvpNMG5LupsU/ELUT6bKgs6OCWUv66KyaJTH21sE9wNpKi/2TT4Mbr9lh8FpaO8ER2pwmyisVt3CB2uoNLBcfi3wshewTQo2aYEdtbqasCluJviUYmDBN5fg1CjE0eqwqEN9tVhJxd+1t+F5vMwgbELfQWU+UVtTxxCBwXpjTxWN+Xam5J+oeHBDTAYGmbZiQHF+MHvULltXngLpFFWPvfgPzjyhR9XybKtyLpyNKa3Wf1WH/HMkQlGIxuakcwvirbYQuLeTo8ZCJXehA6ysrForeN+IQazrR3tLclSG/upCa6yVeIy1B+onIkYXkaygtIeAvktVc8bL61Yp9N8zpoRJVnldzKLrdzjOFj+uQKQ4l78wDNYur4Kzkxa7uobRvgJ5lYsX09fSAfb7mDss8BJQez7jK3HFL7wcEjM5QjCvbgShr9ZHVl0tLIyNcY7fFUx4CJrCEt8fGKux07npnLtOTKopf+sF5xIku1PmOcu+oTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(2906002)(4326008)(7416002)(8676002)(6916009)(2616005)(316002)(36756003)(426003)(1076003)(4744005)(66946007)(5660300002)(33656002)(9746002)(26005)(86362001)(38100700002)(8936002)(186003)(54906003)(66476007)(66556008)(9786002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWF8xF/FDYjfB19lyA/rpvjLtcdidwOuaJPgYHXab4KDS8QYo6WWy6pUfID7?=
 =?us-ascii?Q?bN55Jx1m/cmMOfvCazFQFepNRHdnup1HVbHbj6zwjIcUCp7ZCdACvA0s1ZZ0?=
 =?us-ascii?Q?kj2RAXows1GaFM71LBRtdv6pqFiodbHPutWUOp7HWDnQeSsxMen3LXnM7fbg?=
 =?us-ascii?Q?B21k/IYI04rY0k4VwYd+szUINQ+xhOtNGgMrSFfzJ5B6WOPqRWOji8edb8zc?=
 =?us-ascii?Q?CoG1AyHywHcHtkck1Y9SmWj7ccFMikPGrajzHmZTfB5zWCe2yyhd7q+MWvWI?=
 =?us-ascii?Q?80Icb4fgtcLE/euPo5jlr4wNj17e7uNwVppbiyiqiv8SxL9ZDlfe1CCaWCWB?=
 =?us-ascii?Q?BCs0cIHw/SPY/Jz4T8TEJYAq3819vjuB9j0eK5qbMnIOaisjj+mkwKQFhX1K?=
 =?us-ascii?Q?1TraoCK4GiwGRrTdAmFJWUcEp3LiUKCdcLdBIlG14HbjjbeTmZBoEOrUrDaH?=
 =?us-ascii?Q?VrInpDSaRoUHkTf12Ef9eDWVrgKF0rzrMqIwNeqzNOlyipAutKEHPXqiRvIP?=
 =?us-ascii?Q?Dd4KYXqGTO9u68zZnspIdlTbWi74+3yyQ26ZS+h/ZicS4rs97tQir3S4/Y4X?=
 =?us-ascii?Q?10cNSLqsIGRFPHxfHFxYe0P2ln9g0mzqSF/cLVclHmpDNFBPA8rrWFrt4Or1?=
 =?us-ascii?Q?QuQL4dWRgUQTHw6opvPw8MZgJXfoTjYYU/v4/aRoQMWt1RpbuP+oKZ7T9Svd?=
 =?us-ascii?Q?237d7uKko5KjvR3pkTMaHQCpPErRyvYaABtDrnpx/xzOItDAfqYCl28Cz4qx?=
 =?us-ascii?Q?xSHDIeW/nrA4/dcOjR09EhTQIwkUOHtu/kEBWxvd7Yl5YoQfe0pF5sU+DgA1?=
 =?us-ascii?Q?rPj3XYfat7eL+iWs5Qk5/H/nMCRoDE31eMHe11w323kWLaxHGN1f54e5cjdX?=
 =?us-ascii?Q?j2pm4/HqIHttGiWPQ3CO/ygPpU5V/PLoejVW05++WObt+59bbgHH4xkIwf8h?=
 =?us-ascii?Q?oI0XtJcZJxvAzapXA8Bw+jkvs9PJfaPh6bbVmCeiHjF7fr5B0e+XR1s4RajQ?=
 =?us-ascii?Q?isMQfFL9uiwbjJ6wvzud2i1H+nwKvY+TZ1JKrCkcMBpnQH3LwCNkAzMLD0Ov?=
 =?us-ascii?Q?k8uUIWQZ8p0CV/dbGViko8jfIiwd83uWCsRDExZ4xF5QupAx3VQ91nCNyhCm?=
 =?us-ascii?Q?46KzfHB80PVb32jPrK0nkCHsAcni59CeMQWyUIq5wcx50BzYyPw8anD/TUrD?=
 =?us-ascii?Q?XVZsAGU3c2dKf98KSy3dlRzlC10j6db9HpAmWGbUByd6ATZDu+rhSDacJt0g?=
 =?us-ascii?Q?14Itf5AMPH8CidIStylOQbhiGiDVpk7WyyLaODhhDsFtCkNCtM1US7yvaSQ3?=
 =?us-ascii?Q?dOZ2YoWazWAxx9SCAFtGQHkH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f517d78f-8317-4717-5adc-08d957513a9b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 14:07:43.8476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBcMy25Tk2z8R03VTfvGYB+TSw53ZV3DY0cyCm81LtRC2g1Bv1gswei+E40+FZTw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 11:58:54AM +1000, David Gibson wrote:
> > I'd rather deduce the endpoint from a collection of devices than the
> > other way around...
> 
> Which I think is confusing, and in any case doesn't cover the case of
> one "device" with multiple endpoints.

Well they are both confusing, and I'd prefer to focus on the common
case without extra mandatory steps. Exposing optional endpoint sharing
information seems more in line with where everything is going than
making endpoint sharing a first class object.

AFAIK a device with multiple endpoints where those endpoints are
shared with other devices doesn't really exist/or is useful? Eg PASID
has multiple RIDs by they are not shared.

Jason
