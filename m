Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA58D41AE4D
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbhI1L7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:59:34 -0400
Received: from mail-bn8nam08on2076.outbound.protection.outlook.com ([40.107.100.76]:10720
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240400AbhI1L7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 07:59:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcpz1iWRL3fEaepAAYm/tj2ewphyKqGj3ilYagebEuzFhjyiUDqZME0oEM/fL1q/ghzlo11OC5y1oSNVLjTuq5nkOVwa1slbgQY9fqOs41nvJ3VkKci2MBzbQBC0MsIo4t9JlSAgR3A3oIvJyWlMi0LRGsFxVBRIE1Phjnb1SvKOvd8vRD0fcbneElpsJ6tw35fgpFbm0XSHLBRfHq64HsU9rkmVUk88dYicEi73I8D3XTkIiYQZi+x60FK/c2i35B+hk7ma9s83EGUVZOLXQTVW9uoN379rfvxRX+MmultaNznJa5djx0EZ2DhDwK4dg8sDl4bYb7PlZ8GeLDNbMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pzZRnPVdaF0ONfJD0FJ6HXHyt0yoWvrHBT384oR8Jns=;
 b=j8wkQuaXiL5bghQC03NxVj9buTI0joIOfehFsUQ32EdXyRmLrfOsQr/oMlP5JkbPb95Xag4cvblQ2zSt5gMK+CRBuvRlMsl+Yts33SnPnPPEYxIQN73M4fXJ1SJ0Jr0K0pePHo1odP4j+tAA0jrL2AHUY8+YXWdIp7EG37HhDrGvSRNqW+yKITjcGSk+6H/8gzyi7jnkNNgD/6wbtBU8WE01EkBfYEXrONmf2iXK+E+xaU+lM2BorwhgiqoCSbZjjDlKM4GmPGIg6y9kVfIOu430DfG1MpYgfd+76d03ow43A0cIpRjrfXdzGuL1oO2UK3R78mBEvs8LPhcqJ7WCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzZRnPVdaF0ONfJD0FJ6HXHyt0yoWvrHBT384oR8Jns=;
 b=kHvzgFbDRMELx9TP3+qufG5GF7UjBCfAFWQ0jHnhpUEElWB0yLWkt0oPEsOzi3q3DSklxu+8axeLd3zoYe3X0TEW8sHdPEca6wtcMAggoqfX53Dy6UmOKA6McKqSHlQvbc58GzoyDzza9OeJA9igJMn3XQn8bZVLjs7hXMzLcXEG80hqywWFhfrN3QBRuQN9sh+cIU3PWhBJqE86KpH9smOlGZlAfOMF3dRz/0lEtZnKFTf/5OwNmNiBUen1GBxWVnUYGiDLJsFki5NT3fHFgVOjTfiFDS+KXJ616Jp4bZIsNVlSZky1N+spNX72xcFkTspyMrLwZkXIO1KeCbO/zA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 11:57:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:57:52 +0000
Date:   Tue, 28 Sep 2021 08:57:51 -0300
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
Message-ID: <20210928115751.GK964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0130.namprd03.prod.outlook.com (2603:10b6:208:32e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 11:57:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVBk7-006x12-Bj; Tue, 28 Sep 2021 08:57:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eda9f959-26ef-482a-21b9-08d982773341
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50942F8673D33794B1161BE8C2A89@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHl/COD5haPHvcVJWyFz/oOxuc4qHz6Ev2JfScfXMVkJDJQR4cJJ2f/vWh4krl1iwDA4Mgz81JyqdBF70Tdii51qtIieJNDBqxIXLWHCwOgJr+68keIygR9h5d6Ui5C76K4WS7ZjiHhDnBsSh/Sc+/G6zwBxcQKozLO1mJoqz8ubsqnc+CKt9hdw4a7dITT5yoSuoNcRTdSE/H2IL37eZauxJOCO6rv/5n4hTShviEW0XFzw+JbU2LQ1uQbU+pPbgBG6tzTjCjtYIIS9+6AaNjk4Nx2UMzHPQS6UFsu985pREDPKtbljVIbAxafqZHFeDI+mn9m8AGzLzEKLPSyXh8z6tmGPyeRYrQFTXfcg+Y0P9xe1KumAk4LeHvJuHBRkp4s7IJH4RI0LE9RrK++DD6g+5x2hpXVQMkrY5F+wvK4buW0a2A7/Pv+l6iT6Y/bqYFxAf9b/Vj/iqFZlupKogt+KjdegCu9oTptW4btbPr/zlKsUBlOjYMejcGf6ZL9+oMDYpysYcrY/CMyoOgbgtVlP3CdhnWlLkTK2CR6WzLR1APWTSihCiwLfYyeTayYISVZ96H8SQwTGB2GM3TiSN2QAH3qj/myAyWwG0LMrJm2VxXTHd7ySwmYXAU6sXyk9VQYue3oI/toQRWR47qPX2evV4peoq2GOIUB90Fu4TEkzI3yH44tk0BEPSjNGVMGA5rhCs5wHVEMBCkrc728Dbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(426003)(66476007)(9746002)(8676002)(38100700002)(316002)(9786002)(66556008)(8936002)(2616005)(107886003)(1076003)(54906003)(66946007)(86362001)(26005)(7416002)(4744005)(6916009)(508600001)(186003)(33656002)(5660300002)(36756003)(2906002)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?agddrfMPxWsa3SXNME758HxHUm4BCVYfKZuxHL66Ep/RcImbNrvDYe1h2Lqx?=
 =?us-ascii?Q?t6FE/JuWhpfbSOeRJ85n6tGjL+IuM+/piM1/ZYHpKFhQXZUbYzHph3fvuUAi?=
 =?us-ascii?Q?4X7NHX8B/ZJv1Nk1xOWL49QU+K90R11ha95HzFJnLmXlXt8vSgU9RzL9+X8q?=
 =?us-ascii?Q?ZZYQ8p5jspodedKj0EKlZ0pFw2OHUlllH43RTrfr4Qo15LywMWsQ157qphY6?=
 =?us-ascii?Q?oRBiQDr11+thY9wciZbXVeKq6uQkC5AY/I42U7PBHARdRUCtxlzOOOC3EMN2?=
 =?us-ascii?Q?unjFTdldKXY8ls9YnNVTNiLFjzWgsK8nbK10i7RSqBSX9UAmhlI6RBNPkdhp?=
 =?us-ascii?Q?IyG1gGM9Gx/yowPBHuX8mCIN7kFAJPRj2xOPRIy406pz3pBzht3iXxneiP63?=
 =?us-ascii?Q?C4fuUKTrz4SvX71A5aSNGm/HHy/g4eNSp66cGyPyDcTF6FyMsrLsytlWw72F?=
 =?us-ascii?Q?3Md7JEk/A8ooodJaJ0cPyYbtX0nFsXPlPVwJ5WOCKonckPgdTIy+tX6ID7NI?=
 =?us-ascii?Q?mhb30aIZEADHTOKFgpcodJF7yoowtGpMLWjgQ738sQfxZAPtXBx9rXDDbdo0?=
 =?us-ascii?Q?2NqyDn7c8txkzjomIA6gkgFjT5vw5w487ZCiUbgH83vT2+cjrzBLeqqVxspO?=
 =?us-ascii?Q?E5/P55k1mTo7mHg8NyZnPwlp8bdIwguxgTztsGg2JjHUMys0vASkq/2Y79oS?=
 =?us-ascii?Q?EZEKUVdzU8HHzC1Uh95atZNX8aHCi2Mml18n4id8/RF0FSyHtH81SS+W5d8L?=
 =?us-ascii?Q?yFH5Xje+RTtYUN403YwFZsTV5Ra5/+uXQAKtKV3t2eoMeNS3DAmeM3rg/NUO?=
 =?us-ascii?Q?47D6QQee1rTqBLMeGxGcYPx/KIq5j7eB8TAqHbgFhVJ665wQNkipJadL1xyu?=
 =?us-ascii?Q?EJ2cP/jfom2t/OD+EYWi4tWxjG9cgx+kvDAI9U4nH+rWl5C/+5KYzRajO6X6?=
 =?us-ascii?Q?Y2LKaHIkBFpfpVk60/Bb2nwWODuwjumcfWYoyPdJxsb+rAEuWHVptOR2zc9r?=
 =?us-ascii?Q?pK9J7HrDIMG3zLKkD4yLeicPrt5WeEOlg/hnnixJceiOruKNvObdB4N3K3Ey?=
 =?us-ascii?Q?sqjt/jV+TUfp63mXU+FQcHLkah2w4GchGTiZeZxF4lzFt7EIDeSkJtsTJBmB?=
 =?us-ascii?Q?WSJApOhoFJ9e8USxKDzzU5MeYxSTOTeDU6zMvQadYUZA/XyRRTIBJPRavvBf?=
 =?us-ascii?Q?fXzRitQvuTc4QgWYWpec+M9+NINHB66KQ5QOB70t0YowJwkLxK8IWfUKb8nG?=
 =?us-ascii?Q?i4XqkVV+X/fuWr9wCNxsJ6IdgNJStASNau5gWbx/bxEpiK1oSPJTuiK0FGbp?=
 =?us-ascii?Q?+7YwfxAbfCksClAEnpkmXRh8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda9f959-26ef-482a-21b9-08d982773341
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:57:52.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PeZtLW8N/aJZ68m+l01JxbNlgHxoPdgZ5kxIz/qgW+L1GDSiop8VNYAYbCCGZFy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 07:30:41AM +0000, Tian, Kevin wrote:

> > Also, don't call it "hint", there is nothing hinty about this, it has
> > definitive functional impacts.
> 
> possibly dma_mode (too broad?) or dma_usage

You just need a flag to specify if the driver manages DMA ownership
itself, or if it requires the driver core to setup kernel ownership

DMA_OWNER_KERNEL
DMA_OWNER_DRIVER_CONTROLLED

?

There is a bool 'suprress_bind_attrs' already so it could be done like
this:

 bool suppress_bind_attrs:1;

 /* If set the driver must call iommu_XX as the first action in probe() */
 bool suppress_dma_owner:1;

Which is pretty low cost.

Jason
