Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E2662F964
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbiKRPge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 10:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242310AbiKRPgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 10:36:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32E563CEC
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 07:36:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g06Kwze+yuYR8B4/6z4smzDaoDOq1FKiATPu/3QnN81aqTpzaRX05QcBG3J3VB5d5tGPzHdRvWKkemVzzh13uOcuU4/L3o1yQcEot9QJuIUxhoWLfTUtgb0bw+DlsIxcMaF4Oe+3k/SBOuWwxk5ctzLmTvpV4E4sUUVkpZrwDen82uO7Dil3O5g9n15sEIXVC5sBBuKv3T1a91E+8btKKy1bTT3tUMFML0cZetR3If7uGeQX6K+oucBhwfN1PybgWbjrTIHQZiBB9zgB4fnOmjRcApYbg27dXLYGOAVLYTHyqZezl2+kBLmRX8OT7mYkVB/4/n4fmOC2URgk6C8mLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0D/dFPsZnhQ4HeEwma8gLsV0wIQ3iFES9B9bcUycVs=;
 b=BjmDYaaaPY1lUo65S3cwajlMRe33/Eq0RfnaUO1FAyhu0JfDSIxra0D9e3Ea2zpA1ZwBi2UBZq382s/LM5FOVTECAd3nCAUVfUexPFkMNMlqZ9XafzxNYo12jNFbbi1MCrvOlssRduuBUbvcgVMGUNXCAJfllUD1H4xoevHZIchI4pUoSqm0LrWZg0nHmMhkadtfclyPAwWAQMkcyeCNvjl9hum/+YfvSGoPN6P2E+1fYO04zAwi+XoTpvCgciQJDFYiciPIEnra6dTnsKsRh0dgq7W+g7qdDC/s5GAgVPr0B1nu4k+hhqtBoNP1lRWee75l4LwJoVTH9aYHpL8DLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0D/dFPsZnhQ4HeEwma8gLsV0wIQ3iFES9B9bcUycVs=;
 b=HO6ihsgxlXWZL621nA5NwWWxztj87XIAdf6YYuOEljzeMBYJbsSKXYxsH1mkY0mWvFkwWR+r+YyuztGhQ7Lh8S47Gi2/N4EBmjC0AbHJZTDaS2kOl41aTUotrY9vDRNFTx4P42DrZkx1oxdcnGdV6I+25yiifpD9YpLbvpjA8lVjnbop5Nb84AIlj74rPYc8arXrU036R55ceG8rucqvOKIbGAmdjssSzQTIijPGzovrYznwewJPggz+rZOSD3yXGwueaiGXJwKIP01QkD1rput72elSrL/0sZ6i5Pg9nOV/6kbTtj5GkFwrG2qr2gLhd4nxG7Gzd84/fkAidorkHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 15:36:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Fri, 18 Nov 2022
 15:36:16 +0000
Date:   Fri, 18 Nov 2022 11:36:14 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y3embh+09Fqu26wJ@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117131451.7d884cdc.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0006.prod.exchangelabs.com (2603:10b6:208:10c::19)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ce86e9-833e-4d71-ae8e-08dac97aa17b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5i688KoQx+CWCL+Dheq8Q/057S4UNeQpWSXfmb0UyTZredIl2TKl7LkE0/8qvZxneJpkIZxm8aoynjXP/w87Snw+TOMP3dAZ5NGpObVAWte1HlJ5YRnOdbLJCaTIU0RGjTKflM6MAsLS2h6KNeZ1tWacRBz8ZSWhRaO00GYvYqSsm2MWeLvDyW1IZsxH57qThd7TNw/H4xfKfu2AeySntvjPp699GO9AT639Cv4yH8SEQ5sjuoUTR3k8F2V0UYrJbVsBk9D3jb2SzrLVBFSllL3hJPdzrSNIaY2wgNFR+gC5SO/8TYV3i1L0FESK3T/V4fa/wcuYcux6BSBe2wz18JIzZjXyiDj4Q+iSPNoc/ikJ0XQS/ciDSfbxiBzk0en2wrmpN7DwEOB/gh0UBdLenAWMGIA+tDQGvZU8Jk1L/MjJqoA1cf4H95JmKjnlcoLSDZgBSnQLbfxJQfkBRyCpF2y0i75jcHbuJEtKm2w8xdAC5SeqYfBHRnwFAvy8ZMkkfdwut6JMe0NLDijgPnKfybhpI/1xmoC/F82HL/M3zBRCzPwqvlNpds3Zg4M/pCeKrSq49xze/ZOb4vHGVN9DWtouZYXvKiBU79B/WXd3khDRNaGgVhHL4CZGygC/NVRmGQb+JK8WCcW1QbPvv0eIFTYOSCStUaVQ5Rj//kM7Uy+cMs+AQfCOLsOWyXSjmvGP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(478600001)(54906003)(6486002)(6506007)(38100700002)(66556008)(4326008)(86362001)(66946007)(26005)(316002)(6512007)(8676002)(66476007)(83380400001)(6916009)(5660300002)(41300700001)(7416002)(8936002)(186003)(2906002)(2616005)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QmcWZ7xx56NG5mf56twfaY86ATUQjlb/e+Q6+1mi8eFN2ZorlFTdSABAYIQj?=
 =?us-ascii?Q?4jTeN1VHHbnpFdow5CXXE0QmwGzjA4WnIRLbX/oQ9aU9SfOKmtWXEntgSiP2?=
 =?us-ascii?Q?jTHYYf37WE5b5sGxyOVM4bge456++VEq3ufKjab9MWRh7QRTzuhZmrS3eRyD?=
 =?us-ascii?Q?DfuEjNh0Kkvkri5WstFZt/CIpIcu9/4rB1BnkyKU0WeI4DLQ5x2Yf5pzKkqy?=
 =?us-ascii?Q?AvY96lZAZRb4rOK6On+JFgCLJ/WhJJ8jBL3Cn/XeDSNO7bSHleNqNGSliLce?=
 =?us-ascii?Q?zKvTznRbvMiOrmgCVAX5rwrpmmk1cYOi4V6i2pxfhUFyCx1mhJfdEExghxWc?=
 =?us-ascii?Q?7vAIqNxIupCUyaFnhGul+b0h+SnpEkS4Do7jj/4PWDcg8ijbUtp4o1jxGvKd?=
 =?us-ascii?Q?2KB1etk3T83Sdh9fv0dUq/iZ7upPYIF6QbNXS4iaACcg60afRmZhCi0rO5Hm?=
 =?us-ascii?Q?VwFsC6XY1w6T/tkw2LhcaB3/pe1dfPQttMGLN8y9j8RXfOJIlxd/fhQpSLn8?=
 =?us-ascii?Q?+MZb0uaYhJ2yHXOtTGhSY14EGGevOBV5GDvv5RMAeLQ+efFgeWzxObiVlKaO?=
 =?us-ascii?Q?H8IZUGp8dpbqhQcfDh6Gb0m6hPwZqgEu1/JOyDHxMxf4n1BeXhFeMVwnHCrb?=
 =?us-ascii?Q?PPsO2Ko6MHVeG6CVV3OPAne411CaVn/jpv8X9Vm6hzKB2rPG1N36ZI8IgHpZ?=
 =?us-ascii?Q?Bij51vpCMSLi7+8H6S7wHq50PhYcYx9Pr5hSi47BwKp0WoMS06Hr0dMddctz?=
 =?us-ascii?Q?28PTyvOCDYw0h3RApDfcfsvD29+Adk8MPGzkC7AlIXrd0hcCs9AtSxJ/tblE?=
 =?us-ascii?Q?6nU2J7GgzHrWot6ju+jYKA0Frd2JAUajAzB0QulOFzZzWcwsrOGICV8xxUuR?=
 =?us-ascii?Q?y+93l7qO1kz0adYJFuWfdJND/t6JlGb4hSBTlE0v8WZl8iryC6JwiuV+s5up?=
 =?us-ascii?Q?holMnH4qHoqF0lZIFQA4tqrGhpa98zuaOS8p5AlrZxR3sZr4vldu0KxCqmUL?=
 =?us-ascii?Q?EghrZAUtIqqQVqhYSu2TImIRxwAiBsllOD0o6fbdcDBK1UmH5cl17JB95O6A?=
 =?us-ascii?Q?1nPn2iZy/aNNAAaYsat6rhiCY7qyFgncv98qN1o6oVKsVl7X1Cxa+H9uNpxp?=
 =?us-ascii?Q?/2FVuqPqZoKMkoyDueFTtYttZxwU1Bdg3vYkmFcaIgXP8vnZUFozaPX7gEsX?=
 =?us-ascii?Q?t28qui4NXSPvf9VAoq6x4XgEB5td5ixa/ZaGW5U82748ZhLWqMJzEQQgPtI9?=
 =?us-ascii?Q?tASDgDxL4GeR4zfm5iFbiWHLMa5UpeRvRcegEZ3hrLlewe93M1Itmm6LuN6S?=
 =?us-ascii?Q?rU/1/aagMHZ/GLihB4JiJ2Zi4eEdnEOiXxvpTrxXuqwdNNwRlAV/DXT+flQp?=
 =?us-ascii?Q?u2ZhILGH8ihld+3gJdmjuOSEugFBmmhCU11Vi2pgrgzQ/7a7S2yaJVLYGpVk?=
 =?us-ascii?Q?Za0e+d3nUsOcupkhzKmXbpRESjlGHvRsGP21tUdxPazl0etjIiRxzggguaM8?=
 =?us-ascii?Q?4Bp29lqx8sN9Cd5xkDe4E6NmElTV4GFx+trSXlTB6cGJ91vRXEb8ZE3fhuQI?=
 =?us-ascii?Q?lLrAZyYV66+7bKb/jnQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ce86e9-833e-4d71-ae8e-08dac97aa17b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:36:16.4158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zJgemzwmmqdcnA1B1eScgZftVUHXOcnwg6dPB9BCshf2hxNF9+mxiXd4EQomFp0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:
> On Wed, 16 Nov 2022 17:05:29 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> > it disables some security protections in the iommu drivers. Move the
> > storage for this knob to vfio_main.c so that iommufd can access it too.
> > 
> > The may need enhancing as we learn more about how necessary
> > allow_unsafe_interrupts is in the current state of the world. If vfio
> > container is disabled then this option will not be available to the user.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Tested-by: Yu He <yu.he@intel.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio.h             | 2 ++
> >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> >  drivers/vfio/vfio_main.c        | 3 +++
> >  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> It's really quite trivial to convert to a vfio_iommu.ko module to host
> a separate option for this.  Half of the patch below is undoing what's
> done here.  Is your only concern with this approach that we use a few
> KB more memory for the separate module?

My main dislike is that it just seems arbitary to shunt iommufd
support to a module when it is always required by vfio.ko. In general
if you have a module that is only ever used by 1 other module, you
should probably just combine them. It saves memory and simplifies
operation (eg you don't have to unload a zoo of modules during
development testing)

If it wasn't for the module option ABI problem I would propse to merge
vfio_type1/spapr into vfio.ko too - vfio.ko doesn't work without them
and the module soft dependencies are hint something is weird here.

An alternative suggestion is to just retain a stub vfio_iommu_type1.ko
which only exposes the module option if iommufd is enabled. At least
this would preserve the semi-ABI.

However, if you think this fits your vision for VFIO better I will
take it.

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 186e33a006d3..23c24fe98c00 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -44,8 +44,9 @@
>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>  #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
>  
> +static bool allow_unsafe_interrupts;
>  module_param_named(allow_unsafe_interrupts,
> -		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> +		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(allow_unsafe_interrupts,
>  		 "Enable VFIO IOMMU support for on platforms without
>  interrupt remapping support.");

Except this, I think we still should have iommufd compat with the
current module ABI, so this should still get moved into vfio.ko and
both vfio_iommu_type1.ko and vfio_iommufd.ko should jointly manipulate
the same memory with their module options.

Thanks,
Jason
