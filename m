Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68135429571
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhJKRTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 13:19:51 -0400
Received: from mail-mw2nam08on2084.outbound.protection.outlook.com ([40.107.101.84]:29825
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233717AbhJKRTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 13:19:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo8pMTbrPd4lt+Oos+T1BHR4sHUXTchuorvOZkcPz+COCwGRcl8zeIV/fAUnMQmWldcob5iMIC7ryxL4Y+X2mdGBKEa31smqWZkwgCxvg4nsIdwUVnQK+/V+XPVC5Fs3n6dH1anLkA13zJ2vcP7fXdM/cZ+YVhInP/BMx/v+/yF7Da1KVx5/y+2aPzGgwEP7+A1epH151HGKV7JsOL1yi81RVC5+nrBWX8azjp1ptdxXncEC4gTdo4RddT63eOXDyeRi6Iidf2XBWzdDLjD5i3mAhNa5QP7vfd88OrKlNgkISikvQkKNa6iYhUPEEKnAJuboEw6CdjJKaAY8aF9apQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIPAi1/Tqp4+yGK4RKqT4TtWsMJNFIJhuxLqWXwfYZ4=;
 b=cEv18eHfPR8kn4aHbaB8tht/Fnje94d32D/XZJrLHJ/QBYDYM0m6Y5AiSHdcMbCogQmqNg1gJhA1yB5bXiQUXFoQjl94WjUyjYLkFL13VzHJqJzF2IM8TBcK/5ddWW0mRZ/Ma7K+z/RKMi3yOzLkpVpg2sg3+8pPQr+tAmKW9Nv8sT5p3+NNNgZmPgfh1IXMOMEZJhHAJHgJepo0u+J/NIWXa0zkkxUD6EbAbvLb5tp1PGm8ofK4EtqO4clHrdbyBeCgHW0bG+3ieCMBRb6+AEsDOyM+8w08a/Mjjyb7XupJbTWRsBnVRsrLR5B/pLKIHfLwFOPHbnNJCoxGjd/aAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIPAi1/Tqp4+yGK4RKqT4TtWsMJNFIJhuxLqWXwfYZ4=;
 b=s8oZdSg5m2R8Q1/ncI/3988HNY2kebBzkPDPXqHwHmUmV9FSTX1KClwFRiLCr/r5io7O+w7T2RA2mj0fLlVPUtUYiS3cdv8SGOhDInOiEuVnLfEqguoW1WZ+fKwSo2VSouh6gYlm2zpa+8oe/XdFf3JEobRfCDBJ/JLc0NurHOLu9Ydmje0gloHEh8ICMenWKemcFnxpQKN9oV02GMpwjdd94lQSj1j0gaiKvpL4coRBPggNSC4Q1vjQTrxddOilziliK8Bp4tXANvd8Leez/aO5dIlG/wFIJss+YjY7N2fC1NMgDKRuKleYkSii7u/cG+Ck/PhoVYG3/8iCRJU9eA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Mon, 11 Oct
 2021 17:17:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 17:17:48 +0000
Date:   Mon, 11 Oct 2021 14:17:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20211011171748.GA92207@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
 <20211001122505.GL964074@nvidia.com>
 <YVfeUkW7PWQeYFJQ@yekko>
 <20211002122542.GW964074@nvidia.com>
 <YWPNoknkNW55KQM4@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWPNoknkNW55KQM4@yekko>
X-ClientProxiedBy: MN2PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:208:23c::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR18CA0027.namprd18.prod.outlook.com (2603:10b6:208:23c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Mon, 11 Oct 2021 17:17:48 +0000
Received: from jgg by jggl with local (Exim 4.94)       (envelope-from <jgg@nvidia.com>)        id 1mZyvs-000O3x-1S; Mon, 11 Oct 2021 14:17:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7deb26a-6f52-49f5-2ae2-08d98cdb0c8c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362B1600A67778C353CC241C2B59@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckn/2tJjzXvcn1dYawN+FTTsSwSjrDjqUFgVAUoC5E/+FyhU1e4BjDH7wxyIpm/Hf5VEjAnSi+IoeXupDTzhNC/1tOoLAmdn+jewyIHQmvPwusFwfTYi+fO1IjuXfeBk66b/xTG6iir3cDDC0T2Eecvjgnyz7j94k728DwevEQj1ymrpyuibNigoLdhTVDdRgigo84sQy/EsJLHdOA1tAqnwNVaw+whfVrDk+HUQxl78asmlUzLk//M+7Zv9QdbpIQpsGfD+myj/SxfQFZ/5pXOkASX/eLl+K5it1Q/r6fiL5JaKIgYiUC3R8iTOKK1rfpIgs0hL/rJJxPmaO/ijGrSQu2K6YhOosZu2QbC2git/l1jiVBQENKY8TRRoysbOsTD1zqv8xQRU6m/EIa9bWPMF0rx61tvwofR45ZNxCE8Cql9Rb0Ohgzl01Xwwl4uM+pT3dss0tK8PZAnj/2gF8BO9gjbY2OSruUZLbs5y7a7IrJlOHf9AuJEbSLqP/SMnxGCDTAyLfgCFRge1xAe/WKbyB5tmyh75mDGCqKuShPzW7ybyjHFL7a2J6GzjlqQwwAB9yWBIK+50QJBYnUU4nEXg1h700LykSU5SRAXVwx3UDUe38xH2hQLQbY+teShoWS+hBYSE1Dt/XU5NtEOTAxml6+LVnh0+69hCTUrRlrTM6VBFTi058+vBUWeq/S3s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(33656002)(8936002)(54906003)(426003)(107886003)(36756003)(2616005)(4326008)(26005)(9746002)(9786002)(316002)(8676002)(86362001)(186003)(6916009)(2906002)(508600001)(66556008)(1076003)(5660300002)(66946007)(66476007)(38100700002)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T/JyIakPeyuEDo4BHdRHH5c4/UKCPNpsI2Nx9/DixYG04395+QAmS/4rJdi0?=
 =?us-ascii?Q?oxZrZfWlkqK7ckhJ71fKQbJxO8KVrKrtBWMNTBIdOh5mpmJlQR2Huyh5hqVN?=
 =?us-ascii?Q?dim8cmAgoskPAmBcoxz5JB7frywYOBzh1SgTJQNkp8FaNVi9cYVOBnFG21t4?=
 =?us-ascii?Q?OpsY63OFGWNWplDOQyJcAfuZh4V2bcS/700FmjARJPO4bALunrJHhgrk4e80?=
 =?us-ascii?Q?nG7i0rgHXp/n85hkB/Znhp5k9voas5UBwX47IaklW/VrTujvYGtWQkOqOfLU?=
 =?us-ascii?Q?w4pBm4a/OYVNBK9WhrxTfIBOhOpyKMSzvfMCsQWObIRPGLejkv+CLu9dqI6S?=
 =?us-ascii?Q?/wbJ2v9r3qEiKTOl3FdV+NjDRlZ92fbg9eRciqPe8wcy3BrsdDhyuwhvyA5a?=
 =?us-ascii?Q?LZnONdww9TqxFijzr2EpRUmIVQLwF1rm64bFredB+zsVyklwV11cwGBvoJlc?=
 =?us-ascii?Q?tcO6a381UFy/cCwtEsnmSDZ3BhDG1Yf8bMGC3FPgPYJu1jB1qje2hY6oBIed?=
 =?us-ascii?Q?z5GQL21lOO4gfvbJiwh9FoJ3SiNKCCJS5wQfIU1IVRvALoMtSnMxtlNYGZkU?=
 =?us-ascii?Q?3ZR5a4U9ThEQPH/S+LA4JsVn1LrhwBpuD4mFH18kph8NL9fhfVmJ4Dn+7q42?=
 =?us-ascii?Q?HN5rkjlbHUuajZj/txuWgvcD5TiXxDJBx/ki/HIc8tguQ3/fMvwCd1l4girT?=
 =?us-ascii?Q?73NpQbVr+HannE841KmQJ0dcx/+2bPEbW0izo4wKTL9bU/Iy6ljpgjAQhdwB?=
 =?us-ascii?Q?TXv4S73Sat1dZ9dE9vLpMesxOfdbTM0/UKj4Wd3sGw8mlX6ZkKoSwSPQapAg?=
 =?us-ascii?Q?ISjZETSYepfk62SJvb/YVTnKOQyWdas/shWJc/s2rnJtkGSP0E276DeYsshc?=
 =?us-ascii?Q?m24RrMdeK7pN3fowWmcsOhlZyFCy+bKEE2vmXpY9Ab+j1g978t+GPe7j/aaV?=
 =?us-ascii?Q?pPdMqDmQ4cYGVmzCTSMckdbawvCE8e46x7Dry8MJqk9Qw6P0ij+99YW2d4fq?=
 =?us-ascii?Q?0u0mHHnecFeMuwHs5eY+Xfp1qartgdj+CWt6VaK6ndA5I3r5UPZnKEJ5A/Zv?=
 =?us-ascii?Q?FkggVOS9S2c2TdvjzRTvh1qRu+lJW7U6e5vNsYJ2pfZym2XEKjEGQ2dPMkd1?=
 =?us-ascii?Q?KkspWhZdKMQ/sAegmaG8rRZD/e8YOJJwYAU8Gzo5ogkUEPnsuOwFVPRPui56?=
 =?us-ascii?Q?zOtagzCkymvTxs1zQtE4YzsA0LmdL4bxxZ6HuFqqN/alE992GKNzSv94Bjr1?=
 =?us-ascii?Q?mBsLC5V5gUx/GMODUcZQY5rdS2r3Ej/DB9SeKkE1cU2bepSptI3uP3VM3cPU?=
 =?us-ascii?Q?Sxd2ZFiOjsMgLKQrAmrM8X+L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7deb26a-6f52-49f5-2ae2-08d98cdb0c8c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 17:17:48.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8w/fM/NVn7+0mb82RdQ1gMDYIsb9h1no7I9Hz2iZSQWcMBPgloCclrxqjdpky5B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 04:37:38PM +1100, david@gibson.dropbear.id.au wrote:
> > PASID support will already require that a device can be multi-bound to
> > many IOAS's, couldn't PPC do the same with the windows?
> 
> I don't see how that would make sense.  The device has no awareness of
> multiple windows the way it does of PASIDs.  It just sends
> transactions over the bus with the IOVAs it's told.  If those IOVAs
> lie within one of the windows, the IOMMU picks them up and translates
> them.  If they don't, it doesn't.

To my mind that address centric routing is awareness.

If the HW can attach multiple non-overlapping IOAS's to the same
device then the HW is routing to the correct IOAS by using the address
bits. This is not much different from the prior discussion we had
where we were thinking of the PASID as an 80 bit address

The fact the PPC HW actually has multiple page table roots and those
roots even have different page tables layouts while still connected to
the same device suggests this is not even an unnatural modelling
approach...

Jason  


