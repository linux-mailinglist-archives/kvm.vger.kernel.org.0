Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA838558980
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiFWTp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiFWTpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:45:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA32BFB;
        Thu, 23 Jun 2022 12:39:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3QvLSBu+2Q2LQ5iiRMkM/gKjlzalhZLvmGYpDG9PWrJrcsm+jhSiAS2sD8izPK7a2KhlMn2g/UPrclfVz+DiKx6yBe0+hMDK40JDAl+A9D3OquJYKG/nOUhMhbFy14IqaJvyJ/QekNM1VKLkOz5PuMvgACn2LI4p8AJWJG48Ue3k2oGo6S93K2h8+bOtrWiOumMv9gPZiTKJUR+sVcjTE8pSZo8VX/7xjpfLEAkYCW3SykrN4ENl2DW1qXR/LfaS+sjf2BjG6qgxRXH3al4zpJ3+RaDbBlipVcLE5GC4MtQYEesPaoyTuJvvWZecMzqMGKjqUPfBErpwJHqNXnmvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJLyMrYs3HWzM59jHKPE+S36nuir0buT1TaJdJ9nyFQ=;
 b=NomnrUpLXxQ53FzwI02LFkIOkyz3kVAvfeat9mjgpZt16NtsubbvOjAvOmUMmVlg9GdTMoTUcHC1gsBvNBn6LX7J+xdo5YanI4ePbxZI+PyNvaM2BGFe8js98TFRH4ekXjxP29uFqnMQnpOXgZjQRdozsL87xgMSyfL4BIxklb1CeZq3dn/TyAv8Nu9KUDmDkksDC6l0arhLMEdlY1eHpPKFhqjVB3hp6i4VU4ZAfvl6FLxysXYaiKP/L86l9dEAhOE3xO6ri2FE6T98W3gpmi8Tu+Zoc5y41EHypQeWo20w41QmLNsAfxKXCQztRtHaunXfLMX1Z1ZwK7BypiMBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJLyMrYs3HWzM59jHKPE+S36nuir0buT1TaJdJ9nyFQ=;
 b=sURSJz5/sG6ebOoM6YzL1tC8AM2QYODAHAFZKbBHf7LOrLQKI4hRaOF5ckNXiQpeDuhMEmvEM2bikZCQP3lV4eUHID36asiIcsLKgP25bJVFTNH+9XdGmXxzOgA0WmKxqW7uxZPXs7gohtbOerJUX54raDpq5ZofvUqD6w87PxyT0i7s1tfDuvIdfkezFW7Cw+dJuIAn7wMcpgHMzbPEWvSd2RM/zcJp/9mZeOYJhJe6uVcFpW2qbW3O3RJhkVlcyRlvjpJW48FqAhbBFDRKdcwfQXwjXCufa44hJXo8Q1/CCCALnDjyl7Q20k8ajwTqPCDUmFuVBiaz3h0fIgssLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Thu, 23 Jun
 2022 19:39:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 19:39:31 +0000
Date:   Thu, 23 Jun 2022 16:39:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 1/13] vfio/mdev: make mdev.h standalone includable
Message-ID: <20220623193930.GA38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-2-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-2-hch@lst.de>
X-ClientProxiedBy: BL1P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 571b669b-d336-4f5f-6b5a-08da555017ea
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdJ5wpccK8nYLIw/iJ52ku7Q+cQgfQAXSrmxePFF6NKKJBfclQplUxYqXtJS6HnmPRyK+iEGgRbr14OWjnalOYMs7f6HWg9zKHI0AO2fPqs9KYyfeWWttg4yOyBiBKlLBL7A9Ra+3rPOt3n3r08wogCgHWY2JPC/n4bgzaIayBXfupLgF03fhdquT2xnc7Zj8O2YrUYQv/R1z50SDCKRPDimDGlbYmEGRnOeVMw9ETk+LNp7q4DuGeOj2pe8iNSuuK12alxTYjeDD1HAZ8vzhYQEPNohn+W1725rjo1qinWRUYBkIfRpqZWwG+twZORUFhd4Bl1d7kHf67uf+aqBV1V5v9fpjhRHo9pljYSUS2FCsb6KK7sHj8cQ8DHO9/BbYsXPYghVSjUZoYkcjcAsyzfJWknLc9t3KzDjhBLQpLdkqafIu106JJPMVcJf619wI4oa7U16gDMlQXbpsCuPA1oIjpab+EnmVMJT4rBmkRs3xeZowvvLAfA8GusBlIU9GtHNthwqYyI1O+nXRpZd7mONm3tSDTQPArU7IbyiTXfqv88tchjzObwPhJSollGxcbMWAJ1rpAQGSV3iqVzSfZaW9Iy3ofnkpTwP+ht7Pq8oe7B+qZm1Ek5C1J5T6fZkU0syk/8zrxbsxIDYn5mRPKyqUVYB83Za2rmXj+Ja5Qb6U9g3vHCz4JYesk3P3MxCK1SU0MMPKUpBpM2CL7Qhg+Vy3tsgxDFQT6RDM/nSDzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(6512007)(316002)(4326008)(54906003)(26005)(66556008)(2906002)(7416002)(4744005)(6486002)(8936002)(66476007)(86362001)(2616005)(41300700001)(6916009)(36756003)(8676002)(66946007)(83380400001)(5660300002)(1076003)(38100700002)(186003)(33656002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37L1l/NcNY5Kc0uwcVp0+PceHKQfjtOy6jWRzXk7j00EhA+PG9BLnZmNKuix?=
 =?us-ascii?Q?OA6Hffm/zhDAQf86AJf8I8i54pVS1pRiz9qP9Hpgo74tLE/eN0+gKe8JNDTt?=
 =?us-ascii?Q?S1UTMdGxL4injOP/yYJsDnahomc6M42cL44ZtK24bLvnydpFinmd0DyxdPAx?=
 =?us-ascii?Q?SMVOouLlTrwXI6NgeYtirbZVv94ujupybBb0ufX5UfgY528SmmFQfWep0kg9?=
 =?us-ascii?Q?nOXEy2H28mQQ+Vf4sNfTBpkpTWe3RXPq8MDqyp1xz3w1wJ/2QSg/HDX+HLpK?=
 =?us-ascii?Q?Iia7nzx7duT2n7zmB+UME9vD8zQAKt3BbT7gLdUCjcC9iTaYaOBoy+IqBrai?=
 =?us-ascii?Q?oTjkXWT7DVQOys5HxHgzINcsgzFEuroNjeimfoYO9B60qSE0nb3TAIxe0Vi3?=
 =?us-ascii?Q?Yt2qqG4UC/+4MhZe4MvSmdv73Fp+buHA1j/ofWzZVTXslnR0kESdMLGvWbbS?=
 =?us-ascii?Q?SMTroYDwBSmRiGJHTfEC9gu3pu2SoC3H5qpXyiUJ2eti1FkMQjByCFeKNCE3?=
 =?us-ascii?Q?z64hV8KPX4GpH7atCjsLGrkNPBxTynD3XU1Pd6wBbgwpEn2Zg6PzWe2n0n73?=
 =?us-ascii?Q?0nBkNhd8DCjUOI8ks2bQd7uRlNAvyJ+nJiRB9itkObt00R1BlCf2Iidjk9+s?=
 =?us-ascii?Q?4P7CR9RuHCKRYo9laZCIJkGG4lKRxLRtS/XuzPsXcqqaUPteDl2w7SdMWsbD?=
 =?us-ascii?Q?2lVmKclc8s5K04cNUkH7FTqNu8sIUK6KZzs2hPm+mVfSkrkoA/0Sdf3Oo6ao?=
 =?us-ascii?Q?Z4ey9bZN4yzIRX6WN9YNEum+87gdpO3nKnSZJzvPyCE+ZcMjJzvQMHAB7w7j?=
 =?us-ascii?Q?PbAim6nLCSL0nIoul9tpI6KL6mCRz1r7zIOQ07biWGXfw5syUd7FCL1NQKOi?=
 =?us-ascii?Q?8mwt/pVV5ctOe0bTbwDDXF69HTa5aljIoB7I1oH9lU/YfFbz3BQktIfW3CK6?=
 =?us-ascii?Q?agVUxuMvvp0QsR1qi6rnsZw3ce/jfcwttvEhGukSCxpl76F4hj4UPYygTiwq?=
 =?us-ascii?Q?O/MizkEz0PoS3jHXUjQ8qj5D3qY6wVu7MEboPQqjICPfrC4Y12QVL7ebQl8Q?=
 =?us-ascii?Q?oLU8fdNckPnhyixJkmaFpQNxxF8pXsWh8mhG/wKvh4kbJKwbgucSOnD9kqIz?=
 =?us-ascii?Q?ApLDekY7vpIe0FQTM3+fhXvfdcHuhs+ZP6NiED6XreQgcgbPyvAUlXmeIJJv?=
 =?us-ascii?Q?M/eJM2ATtfKOD0qNi3Ow/QOngIHQujNaRCgNcwURxGljgesqWeKhzczp2vla?=
 =?us-ascii?Q?wfexbvwOfvBKQ+UjOV4qZ8LKrMSl0elSHiu/zj1woUryv0h5jFVcOBJZaMqA?=
 =?us-ascii?Q?m61HYx1z6FPBUOm/ox3XTuSFytHBVRg7p/TD5golXCNQXousj0OngMd4vlwX?=
 =?us-ascii?Q?8QZMdb5HZduwPA0QaET9Cme1dYCVphpG6nIgxQT0KDkJLVELviwBwfNlqttr?=
 =?us-ascii?Q?1M6O5MJwSXydDbs+mzCAiDz6hst4TZKl1VKIoQ+0I2kbWr3tkhX3FuC9fqAy?=
 =?us-ascii?Q?A+9CdPtJ8gjODh38fUgNJcUiB16jGz+QiHJX5GomZ1XwNCFHDSvotavRKjST?=
 =?us-ascii?Q?hDzgdfRiBVY0yBBMYizXRBMv5enPgh52L6qHEJPU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571b669b-d336-4f5f-6b5a-08da555017ea
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 19:39:31.6611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVjXO/s8BzPGgAXFknEsy7teujKyfxCgEKBsP/QWTmHvNgTe4fYRSXoxndg6erxn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4524
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:16AM +0200, Christoph Hellwig wrote:
> Include <linux/device.h> and <linux/uuid.h> so that users of this headers
> don't need to do that and remove those includes that aren't needed
> any more.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 2 --
>  drivers/s390/cio/vfio_ccw_drv.c       | 2 --
>  drivers/s390/crypto/vfio_ap_private.h | 1 -
>  drivers/vfio/mdev/mdev_core.c         | 2 --
>  drivers/vfio/mdev/mdev_driver.c       | 1 -
>  drivers/vfio/mdev/mdev_sysfs.c        | 2 --
>  include/linux/mdev.h                  | 3 +++
>  samples/vfio-mdev/mbochs.c            | 1 -
>  samples/vfio-mdev/mdpy.c              | 1 -
>  samples/vfio-mdev/mtty.c              | 2 --
>  10 files changed, 3 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
