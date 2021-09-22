Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E620414A95
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhIVNdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:33:52 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:35616
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231758AbhIVNdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:33:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaiI4/c1WrvBIk08E3nhshNGgq/ejoYF+/m3O0zMZJjqPPvlr9llouCPZrEVxQooug6OPFW84CN424FIiGtpRTYAO3Saj3sOZovDMLUXra3TbHR5gAAjDryj1D/q6SFcMzrzA/jXIh/QY8gJA7CvNzHwBTuwG5T7rYyUl5WFK48FyNlcGQQUcl0Th9woRslH9+Vv9Ddd/Jv39DVGcIE1ZD7IXybbLKGs3ulwtKRhCpH0fnQqo82kP8QBHnySyK/9WevTBVoGg7qt0rNgBDXlXeAKloZhX6FftljiR1kQ5Hu4kXsNgJWnB+W0tOrf0LDDY5XLLiVY2DKWUBDHxuQEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=06IUb/I68YfTxGmU/HtvuXAJWL7SnefPNfvhPrvKBEg=;
 b=GfHQJYgMhIP1coBfww4byd788142fEtE36csehUCjp6ctoJJEQ/S07H3JbMcNT3Wlyj4pihQGrs0gMU34aCpIoi6rSPtzV58P/ruWgrYiKIakBI3UN6VF1V9W06/7QzmZZIMSq/45592CglzsiQLtndv0UCF78ED1X8IzDTtMeViehrALPsHSuCUAXpkqSyGNdUt0ekHu9IS2l9H15PvHGp/iMTOtyoCZfYzmpICkvqmiwB1Ecgd28TwB12MtMUhOXf+7vPz5FxHiL9q8Jh8RidenvCAfvTsLpORhUinH7rCb8c/eja8Reg8Qzk4tfB/G3CEyXP67Wf+bt58JPU3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06IUb/I68YfTxGmU/HtvuXAJWL7SnefPNfvhPrvKBEg=;
 b=beJjvVk2gnNqUAj3kLHEToO8X5z74sGBwiU36LhtWdOhUZF3kW3hSIcJ2XaSOhH9l6IPPcK598HghXBoD8pXLUhuByzfn9xwsx0kKhWVei2IiYRvsR2Hwyct/3GVRLG548lcbAScYyYtQs/E5mk1bsSjhO86W461pL8ek39Zvg4qHwM/3ALfLkmMznvetO4t4m94cozG40XObQEQSqGtWeCCxRuiJSfFcWF0OwHK8o4LsnaSRDy94hzHXUjShbBqgdRCX9AxWEIi16ynqlOTpTAE1kBjlHE/MzYj3i43pW9nJtxVz39TWh7BoDKGqNFex2VxhfMFaYLmHhJZj+RONw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5031.namprd12.prod.outlook.com (2603:10b6:208:31a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 13:32:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 13:32:18 +0000
Date:   Wed, 22 Sep 2021 10:32:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20210922133217.GR327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <SJ0PR11MB5662A74575125536D9BEF57AC3A29@SJ0PR11MB5662.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5662A74575125536D9BEF57AC3A29@SJ0PR11MB5662.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0270.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0270.namprd13.prod.outlook.com (2603:10b6:208:2ba::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Wed, 22 Sep 2021 13:32:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT2MD-003xrX-DJ; Wed, 22 Sep 2021 10:32:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6d4ff1c-0587-44ad-8031-08d97dcd65f3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5031EE2704198E795AC991ACC2A29@BL1PR12MB5031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJt5SCSluI7uWtpHCiXbCPLiABUAm+YsW06nSL9an2BePAirsHtq837NiKnUxoqA7VYokqjzQC2Gopc2Lkuy46wVKCq5CpgZFQpsYcHAvsvrC5WvCCiMUtxP7unMt7tCLwdvWDCj1omgFXk/u2dXK3sJqUkxoywBbrakWTEbSk4qw6b/AxZI5bb+r/biYiOkYAtlysvlh1dQvH9y6mxg2A7qkqQoy5k37HOzxi6YizSjLKon862uZ1TuSyR7WxhiQFD8cWqZyjEWjN89/K9RGXuSNfdCsbE9MP0TN0Xy5VS4Nh16xks3DTr0RrT/I2aK6FPgRYoeuRBdQVO/MD9enariVDn9t15+4lPtCgYhIkO1ocpUN/eTI6t4B+HprZuCnh+ZMGg+DJL65wgfHwfb9eqlbxk/A6fA17md//o26cPhF6JI/nTUtAU1fN942l97xbjDP/5vPoBnAWZYPli/x4K0nRajljyY/9LnOLPdg7vGp+hz4EsMqFiXRrqkwYxdGdvibMXHs1pLsThYGDRYZK0s0sTf4ovA9e8/B/7eBykuYJQSwQnjcwEUZVd4JBW/EiSnNROkkaA39bM6DkI3LqPxXejd1249Ygy8tFp1I2MsKCL9IhVFMup3xrigiWS11FRN9P5JeLi5PS+uypynDM4gFFvoBpMrsqhFIHu4CtGExHgIi3dOtCLPmzD1na9qYfx8LPluBQXgD9jw+2GfAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(66476007)(83380400001)(508600001)(426003)(316002)(66556008)(66946007)(1076003)(186003)(33656002)(8676002)(9786002)(54906003)(6916009)(5660300002)(26005)(7416002)(86362001)(36756003)(4326008)(2906002)(8936002)(9746002)(38100700002)(107886003)(27376004)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SAQORveg4HhQAcjCr4sl/yQN6kZ9AWFmjdXJu7Q+d6RvfWrhUJwiz6HnnOZk?=
 =?us-ascii?Q?NkyoQQvC2W8yUbPLgU2cR3q8a6eUjFht0yWRjz6wy2bnm+oHkNSvFtlh8UR0?=
 =?us-ascii?Q?NWpOhZMcyfIqRMUUzSUL46nYiXO1NxWCpYc85RzZMKyw50FewbOgq1ATKbkA?=
 =?us-ascii?Q?khTp1KjsuvAtRAyCY/MYay7RN2G4i4jNF5oLGyie1PhvtR+dpggwmOSUQqNa?=
 =?us-ascii?Q?baaq6a1Q/1pgkJL5aYZJM6ba4Bf9BBed9ONfG0p3yK9v9P6ClgWgWQQnjAPm?=
 =?us-ascii?Q?XhGEcOBnCSe8H0uwEVc8NomjYPGKhwswHjTUEadrOAocUobMH5ky+Ka0/1we?=
 =?us-ascii?Q?Kr1EAOIFkoPk3lIa5zdfV3POIa2pgS7CdkPXYRcErG8am+jEiqnkgGoXIYH3?=
 =?us-ascii?Q?if+U+3U8Rv4EwIghjdwiouds7To9zqUjK35Sa5ok/CB3aztAAqV+HjBfVrAY?=
 =?us-ascii?Q?AvnjJ3XAeEyovla5wgEGJvTj/+VAL4wJ0HF2ZPiJQzcy8y3bNBsemkIWugb0?=
 =?us-ascii?Q?2WUjqBQhea8FIT5XiS6nAcmhaKJB6EQ6ZAyOVnuZUDIvA48KiBQd4SQAbnBQ?=
 =?us-ascii?Q?NImiInKhHiEvIZze10foC/UvNDUknj8MZI4MOHv/mlgjCKKhYBftsBQisf/P?=
 =?us-ascii?Q?HQVVUmoWnLEVuqWCCjM1hfNeuvJcacSmwysuNBUuIor36jqW2ZVwUzluYqLS?=
 =?us-ascii?Q?nnjqYHpnCjfpomx2u7AwrspxLl4qJZ8gxw8KgPPenzsr9XHHf94qFYPj/yD3?=
 =?us-ascii?Q?niFb299jvuAUXu4T4nLmli1odcGU45APMKUwz2fqzu3h+EaNh6/3FMthBkIa?=
 =?us-ascii?Q?lxEoXJnjgjSwJoAqY5N3D2qzWqEfjR22x0jwJsyFqTyRIab1CBQRRTWaVKZw?=
 =?us-ascii?Q?5W+7tZi7vfODthaBcpW8AKrsbZ0pX2DEB9un+/6dVwz+xqqKRqDhE6el2fia?=
 =?us-ascii?Q?LofpRGGNXrOLk4Jjqp2qogKW256l3+eTgI/bXoJxkPX+hbobxrJq8E3Wk96K?=
 =?us-ascii?Q?8XU1UfXIclMs4lP3LnPPWL8u7+l/GPeOpUYIIBGiSrIl9kuDmDwzskYvNM9m?=
 =?us-ascii?Q?wQmNTTLJZN2wSDlY1vUVFAHRTPCfGgVTVBQKJdObYsgl1ivXT3TI7TNCR4HN?=
 =?us-ascii?Q?V4Rn4DInTfwf4jCRBbWT+W003UVJLxewSaQUQ4vW6gDBN+Oy1AsakYKiP+Du?=
 =?us-ascii?Q?SrnRTUy4c3ew/bEdHgmFPptekqfh6SANgpfic8oAzEoYTw0o5pLvPCznbk34?=
 =?us-ascii?Q?VQA1nMiXxu8Uk/WVytp+Oc5xUdrdLCX+ypnzHL92lgjE4yuah5Xs5X/ygo1e?=
 =?us-ascii?Q?N137yLHjxAtzfWzxn3ZGeGxc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d4ff1c-0587-44ad-8031-08d97dcd65f3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 13:32:18.4628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUJeGSaXaRlVYIgCWoL5whynKMPbvcMpjg++Aqi76WZJxTNR2EZTq+z7A+stVVms
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 12:51:38PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 1:45 AM
> > 
> [...]
> > > diff --git a/drivers/iommu/iommufd/iommufd.c
> > b/drivers/iommu/iommufd/iommufd.c
> > > index 641f199f2d41..4839f128b24a 100644
> > > +++ b/drivers/iommu/iommufd/iommufd.c
> > > @@ -24,6 +24,7 @@
> > >  struct iommufd_ctx {
> > >  	refcount_t refs;
> > >  	struct mutex lock;
> > > +	struct xarray ioasid_xa; /* xarray of ioasids */
> > >  	struct xarray device_xa; /* xarray of bound devices */
> > >  };
> > >
> > > @@ -42,6 +43,16 @@ struct iommufd_device {
> > >  	u64 dev_cookie;
> > >  };
> > >
> > > +/* Represent an I/O address space */
> > > +struct iommufd_ioas {
> > > +	int ioasid;
> > 
> > xarray id's should consistently be u32s everywhere.
> 
> sure. just one more check, this id is supposed to be returned to
> userspace as the return value of ioctl(IOASID_ALLOC). That's why
> I chose to use "int" as its prototype to make it aligned with the
> return type of ioctl(). Based on this, do you think it's still better
> to use "u32" here?

I suggest not using the return code from ioctl to exchange data.. The
rest of the uAPI uses an in/out struct, everything should do
that consistently.

Jason
