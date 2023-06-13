Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA0772E1F1
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbjFMLrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbjFMLrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:47:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF391BA;
        Tue, 13 Jun 2023 04:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbEFYKMrZ2SrYwQAeYrKfGGXts2TQ4rRbDx6B+yDlPwpr9JmZutC3s5k6RMmXPBDYBJIv65hhdf8CasaqN9CPDyLqfPbzmuq4LR16QvfuvApWrbAhsFz7r7llZr2HuYHDAbb7J3Jbo2qwM6kf6rd8o6d8dPK09hyC63yT6+pcwxVQ0UxbPio1FvrqKH6NbqY9PfoxTOSejiAnInQx/te/5HdssWRubwn5U6HjqNLfcRmDDGCTKWIIPcFf+jiBwhEFuR8Gc5kKmorVeza3opJ6subvsPN/FR0n8Nv6y4NtlVQC+CPalryB4Y6TtPDkXBWN3frr7YEhzOyudqdBZlScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TS8bsdO6mfDTNSqXPH7sr9SSnCtrr93jHDIVi8+QkoU=;
 b=GGA45yc7vl4Exxud/f6GwLA/yPuOn7P90qWr1cK2r0U1YJ8GpWQaym7BHglXpVpqGIDntuvr6OuBnnVJAuHzs+iXUMo9XXjy5RO19wxOpxww6fliCUAux8o/Im6vZUN2CRmdJEK3IjdiGxmqB0La9xGDs0ybXWWzmK5b7bMT1AjPyDTxHhYNU+fUJMtg0kRLBEUoyvO+yk8sp6aOPe8S4hS04h87kONiYJYrST4oOmWioQCYLJPH+oGAbwWZaxvYoaZ5+4Dlfd2KOKvZymIMokszwpolm4p/2qhJU7qDEJzyKq5olegVABQsHrKFSqi3PZUBxcfQ+Gpkc9Ep7mnNyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS8bsdO6mfDTNSqXPH7sr9SSnCtrr93jHDIVi8+QkoU=;
 b=sxisb5kNr/ObbFIAbtChjsDhb8CB7aMeNkGskXZPrEtjBZnQ+Dz6m40oTEt7sFxxE3mUAnmGBM6s+/mNi1yxUnLWMW79T1IzfUZPFr0GbnB7QSVlFP5YKbUtclJ79UdDRTNiYWyFtADcf836XKRiH7Xkb2nL6DFQ1AWV+v7XjiA9YzBQ/xnEL8ejTOrhWLAW0TN9uVdqIAe8aSv/zAQLBPZhn/AR76bPBP3nwopySSHzIgY4sOPRnG4vZvNhe59hXO4LoOaQAB5pO8o5LdBwG0j/Z1Bhz8iwnyDW1WnakFcOpgYBEGqUaJg8e5Jvj255uDI5divFrLHLrKRRvZCk7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6628.namprd12.prod.outlook.com (2603:10b6:208:3a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 11:46:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 11:46:59 +0000
Date:   Tue, 13 Jun 2023 08:46:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZIhXMmYjCyUdlGxe@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-9-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:208:23b::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6628:EE_
X-MS-Office365-Filtering-Correlation-Id: 87fbf277-aff3-4e57-cbce-08db6c03e563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUWa81DvUxZx4/Ci3Rh/l81HU6D+zuEYrc+wMPQELx2nYjJ2OH7BCiPNrcdnYp3kYaJI0u98ozcxoqQ6gU9ZQF6K3laQYJJyKQd5Xl7uaokFo8qlZi+rBxYnk9pxkrZPuT2mdLVQ6upm0EY8jLyRFgCojf8D+pFdkRZvEY6l5qqnnQan0HEFFhzVVgiupAgZklpEMXcuwAapsf8mMz21A56rAgA1DKGF8BflaxdA6YLoDkIHMj80uFS2QnWMJ0hGXc9bNqMKouypHJC/cXcYDIswfXGkmeixFVkbh4XaJrMBY6FWqFmXm4uwMJ39eDIMdEoYOQ73bZZs7l0vUYrWcGCnjqaH8AyGEHwSSlZ8piWPAAKTwuc5oyl7yrsu9wamP5c1ZvtpMgzaDL4phy13MrGgKEF9Y4JFsCbyOzEHPS0PFb6aA/8O/fdceBD0mvwazEgDoY012/a9wT154r33fNJ2dQbk8EG4iw5hWJaRE6GBANszJ1FpaTrUAqInNsMQZ226TfiGUKZK8HLveH3fWNblJIGWDlcRqEPaz2qjXh5zz+BDoxDi5//NOoJUgoGd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199021)(86362001)(2906002)(36756003)(7416002)(2616005)(38100700002)(6486002)(83380400001)(186003)(6506007)(26005)(6512007)(478600001)(66476007)(6916009)(66946007)(66556008)(4326008)(8936002)(8676002)(316002)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2dLTJvRwOgVynU76UfI53ixq7aHwFpuKqQAmYg/9nh+SZQZ0EDbwbxQ713Tu?=
 =?us-ascii?Q?ZFVqSMVIJIHYiZO8tkOY9fkd8kZbGwaRSw2leE4u4NcciDlJQNRIeha57SY6?=
 =?us-ascii?Q?yPKH7r2vHBbX19IpGZRcWL6YT+kBVjR2pET2OeU00TrXwq94N+yTPExi5L37?=
 =?us-ascii?Q?KL/xg1ef7CqBIzvm5cS4Bjgmx9orAzNwkEO2UMhKaKBPDaDohGsT5XVZuGGr?=
 =?us-ascii?Q?vpTKRxekQb1xF7bwzIvghquY3EQlPMGcT0H8tMmyAHoVUdFk5v0EAJjlLE7k?=
 =?us-ascii?Q?VY4PBWe4jlj/ZNChSBjMogCiXaiRI/jOALHmgCpfp2LDjA7fSdSgvYBTrZSa?=
 =?us-ascii?Q?VNqWHD3g5d3aqfvcX1Mhkokjh3M6MbuVWR8eFgrRFRaWMxyktvzhZTCnLbLb?=
 =?us-ascii?Q?P1BRe478ZH6TI1C/K2OdyFiOXPvYKJ67Hd28C+CXGSUlWiKU5XeQiRWTdkRl?=
 =?us-ascii?Q?leygM0tPX2ZVUOtefqRGIO5WaJLwY3O1gSHIy6YBJ4lTmhr/gIgYnUNm+3Ce?=
 =?us-ascii?Q?JSaSn4dyoC8mVGFNSZJizPH8O/O5DlLjbmnRmccQmUvwzCboGGs6J3AkVs+U?=
 =?us-ascii?Q?hnL009cs/f1A9aNuvEN5PrfLffQduNopuQCcTVBOXsTzEBQggxyt3Iohsyjc?=
 =?us-ascii?Q?l4vitH7YOcsPa90uClFss8ZAYQX7DhJihBrATvNHUYEz0uBeGszW55aRFPiL?=
 =?us-ascii?Q?6IhiRhjANBulwvmH4zsOc/e48bCPemreVztJwINpWPgMXtW9B5BhdmX3U72F?=
 =?us-ascii?Q?nBg8WoL5nZ3cuJ2od79KxnGEnTVGK2HFrbpC5zZKYvRqAZwzK9CccS19JJzG?=
 =?us-ascii?Q?wso3Qob3OGF/CiRKGzAhs1YWodb4T6eMKcArDibYMLKpXlGQA3jPXPO/AezV?=
 =?us-ascii?Q?/Hcw/ZbdaaR6VxINnnD+7qY1zg20C9e0YrLkYahzBbdN0vrV3qHc02bvIhfJ?=
 =?us-ascii?Q?nnMxNudeKAgkCbIhrhBZfmub94QYvcYbiAlpKh+yY7Sk2Z0MIrtNok1kN/BQ?=
 =?us-ascii?Q?RlV1QMF4mYOuoG50u5684q6BvXn9ZAMbRpBLIcNCATYLLulMSiwKahki1snK?=
 =?us-ascii?Q?P8srga4WQi/HHWNssxDker6pK6S4zEJaI6dMZ8XDxUFeSdrRu5nJ0AB4G1N/?=
 =?us-ascii?Q?BRvEfzRMuSOhYVwMV0SmRmQD9CiNZ6McHzNI316VJGRXGbOLj7wRaGo1mcXZ?=
 =?us-ascii?Q?BoCpQNvHH4r+5ah4YdQjcrii18HBxNORKZ6MYBDp/Wn10heNg+bAHDtsSKrJ?=
 =?us-ascii?Q?g87B7ufS5/JFdTEroOCMZ1Z20YWmCR2a74xeOqbzmRIHlZe/SRRP56FkplC0?=
 =?us-ascii?Q?e5xW/MpBJlphhC+f7Z469rrHjaAR4xk4dLGsMet6TZ7eJTSrSho64GVk+zRy?=
 =?us-ascii?Q?yVpPaC2Ohw8NkL6YCreJKGx+HLlpCZ1vK5/oVevjNtLdyiCdg/ZkHrui4U9T?=
 =?us-ascii?Q?BPgZkHjpQjYI8+QfddLeSs6OT5DtvRT/K8APITUdFxTyGjuyNUY5A65iImIT?=
 =?us-ascii?Q?e9HrYgZ50n59kZg9xfdaNg2n1aSgFlPrH0xoqVrRwij8JEgBcY7XBNaMpsPR?=
 =?us-ascii?Q?sBwT6ZaTQ0wZCEVZ5HZyt+3I1ryr5jdrGQF2twtT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fbf277-aff3-4e57-cbce-08db6c03e563
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 11:46:59.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFNM5Ae/3CVZ+mnMrziHDVSC6Q/TR8MPE4d7Ym0xSRJftf1ChLk92P83JIgIApVr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6628
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:15:14AM -0700, Yi Liu wrote:
> +/*
> + * Return devid for a device which is affected by hot-reset.
> + * - valid devid > 0 for the device that is bound to the input
> + *   iommufd_ctx.
> + * - devid == VFIO_PCI_DEVID_OWNED for the device that has not
> + *   been bound to any iommufd_ctx but other device within its
> + *   group has been bound to the input iommufd_ctx.
> + * - devid == VFIO_PCI_DEVID_NOT_OWNED for others. e.g. device
> + *   is bound to other iommufd_ctx etc.
> + */
> +int vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> +					struct iommufd_ctx *ictx)
> +{
> +	struct iommu_group *group;
> +	int devid;
> +
> +	if (vfio_iommufd_device_ictx(vdev) == ictx)
> +		return vfio_iommufd_device_id(vdev);
> +
> +	group = iommu_group_get(vdev->dev);
> +	if (!group)
> +		return VFIO_PCI_DEVID_NOT_OWNED;
> +
> +	if (iommufd_ctx_has_group(ictx, group))
> +		devid = VFIO_PCI_DEVID_OWNED;
> +	else
> +		devid = VFIO_PCI_DEVID_NOT_OWNED;
> +
> +	iommu_group_put(group);
> +
> +	return devid;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_device_hot_reset_devid);

This function really should not be in the core iommufd.c file - it is
a purely vfio-pci function - why did you have to place it here?

Jason
