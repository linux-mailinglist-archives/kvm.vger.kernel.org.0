Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F5C6379C6
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKXNR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiKXNRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:17:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D90FCDD2
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:17:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4jDImq/GIGuxokHRkN1dxW2orBT074G806InzLn2Pv1ta7L8rPeEtYOCJicwm9bDckemXFftWK40L5hCMNFaRrHJEME6IvZt7+zMoIUV/hEEPp7bbvjnuqDBPqvlxNlzo+2Sy174lBllpeoo9Hr28G5OJaIRMFhTzAm4TgmfXzGcFiKj1RDYygMq81mlQtNvbVTlZtwo1JNr7BUECpV1ODpO/rX619ymM4PRgGRD0LimupzE0ze6lJFt5AJ+8utun2G6fF2Q4iWqodv5kkCZd+koWsuBdZSgYf7LNPiiUvasfe/iOv99YGV+tC2bL9npzNhAIawCSD+cYP671z4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I82NoeNj0kvqKD49Z8Q+7ZktANh7Hzz/Qfg/K0vW0iU=;
 b=GwnUPgx+qJVkWYJOtWj4SbjkHNS+Ob6Bx+qhw6YQXTCyrkf6ZIWpmeyGOSCi+ctDEsEwsKOboRWRixrgnXejpZVQ3WBej9hXSu3JEGGyiYAa0K22uW1ivLnh/K9YZe11H6Fj4YCtKietZzCkDz35SI+FLgoaZXB41I1Y+Nf1/hG45m8GuQsnXOToGMZj3LDlYy1EzN81kOEPmLN6GPKq2oGY12ansLKXaO0ZoWtOzFDHT18C1yynxxKJ8kQdu34OCICt4bJG6QpkZObx+bUPOezUIsNtEyM0G1Z8cwNba+NK06HAJIkvHGwj9kqRwsNSPS/I9/oUU3R7Vs5z1nc1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I82NoeNj0kvqKD49Z8Q+7ZktANh7Hzz/Qfg/K0vW0iU=;
 b=QS5BA60RFpbqPrRMsDPZ7pYjlzui0v8S5Sl2VJVVvJm5HQdxP2NHneMsiMYHULVbTXy6LtM9GxZiqhXNd3t9nvTxNpZKYytB56JbQ+yN6EsYm7XfDyzEb5aH0/sxfJlCfkYkduiT7QYa4pR4VPIqDWKEwyTrSLmvw6X0GGIDWfWtsiUns3okgRCRw5foXl1QkoIoBJiDj5nx8P8lVEv/anawSyoCNrTzJbbf0PZIK62T6SlZGfC4yvjMInQIBbqmajvYovtDYlwt44vBAnr75LJa0XTNR1iQbPT/doiOVD8N7mJV2noEWhiH0SV5gSE3p/VHJbmJrWGaCCc5x2FQWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 13:17:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 13:17:20 +0000
Date:   Thu, 24 Nov 2022 09:17:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 03/11] vfio: Set device->group in helper function
Message-ID: <Y39u3446TXjcxkUz@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124122702.26507-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:208:32f::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: 480479ed-fc7a-41cc-7fb7-08dace1e37d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+KkZwzJ0WOxtN7MFkBRJLLSUOUqtaltFkDMrabNy0pOEYrBKVWG/gbkjr2YA6G8tl89/MeOENINayFSTTQfgohV+oeD5PhhNUyEtJZOj3C/COBFGtJrcuUkX8MO/Hc8QpaGGAc27MiNjvJ7HtqU+eFlPcQZhKi6XOF+qiV86KkneujP+q+SttsDeKYzcffc7rXUsS6EhGw0v8rtvex09uPL4PLB6xMLxenL4kgUp3B5FGVsL+VxjUGkDcqeZYCyU4nNg3Gj5EwDEnb8dm6KysL+XtpuZxNXiiBoJPXi3Gd4yQI2Y8tqAgWbQpPCW+Id78E2/kB3ZsXHTMAqIPfVxeKHWQ7e5KnwMyY1EWtBPPBFkycVx42UqnDtsf3HcT0WM4/czAgHcMxy01xaiAn7TZlrnFL5KolJlRy8rwLXU5nx+iip/DQmke5+f6iUtHvLDVL7qujOpqCr1pGu6hlj9aZAqrAjylR4I/Msji932gbqru+LmoV5vNyejVCAcOBTf5cH8qwIzgFtNEmVJ1jwiB19pKal1W6uRGbfAjhOHOPt1+a+c+j7cYB8gf9D2vbeorC15kwWan1JNvj8/yldBr0UHkNxlMFiBrMkUEEL1hXLP+Zbq4/wxpXg65EOjhA/vufuqj5Bs/Lo2boorrpGaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(8676002)(66556008)(66476007)(4326008)(6916009)(66946007)(316002)(5660300002)(2906002)(186003)(41300700001)(8936002)(6486002)(83380400001)(6506007)(478600001)(86362001)(2616005)(26005)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/5RmrgSMXyvc2FGsFPdrnAe3HzfT34H8ZWSfJMZ2M9vnN41wygsdKDcxSucs?=
 =?us-ascii?Q?R4TSD0OCbv7S4eOYMKO2wJrsyQ8VF1Vqf017oC40fTzoAF/jmMUwtq8bheNX?=
 =?us-ascii?Q?X5mSuSGO06zEhWuQpDKBSOLvDCgwexdj7DHWmL1FS+4YJ67GwNoeYJ7ppYs1?=
 =?us-ascii?Q?gfdlWOHiOKB3nGQucWS0zbN6+m8iHhB5eBEFb/0W5l7gqQoo27JbfvbZSq8h?=
 =?us-ascii?Q?HiQJJ7y96/M0HEzYlSKqFCsPagDfr1nOkUTosXHZkZPl4Gw5hVC85ivKzokd?=
 =?us-ascii?Q?yW3fQfNY9f3C19/L8tbC53dwT9vIcn1Has1DW99i1pYYVSd69sRAnSocpRNp?=
 =?us-ascii?Q?Ym5eAxpT6IExwQ6cAF+CyrYpjZCJ2PjARigiwGgC0+Pcf90NwvyzM8aAM87h?=
 =?us-ascii?Q?vEgx86qqz2xiq1m0zMI/kpeCNGEjKjFugpnzme5elckr+fY6u3hwboDFUHtc?=
 =?us-ascii?Q?Z2rZX2/vQymUN8am20zfJ/4IuCttQMwXNSu9L9NIn83DPAehU1caUbC/JD4I?=
 =?us-ascii?Q?9NZNsIUiATmMmy9sMUw87jC3oR1nhGtRZiuAW0m+ZxDY5qJOv0y9lCciyUXv?=
 =?us-ascii?Q?g+a6zM1zvP1NKuB7E0WBek+3MVCiajpaPz1AUxY8KlrdArK6+KiNJrq13eVq?=
 =?us-ascii?Q?D8ogMcKxRFlC83SKEW6eDAeyqXxhsc793J9RsOUBLhPtEg7LMmDCD4ruvaAf?=
 =?us-ascii?Q?Pra1jJn5QB2hueoKa/qSm8Em2RKZtfI18kklx+VQLyrA4Fl46m1Ad0MfTEmW?=
 =?us-ascii?Q?8SD1wVYcMozjLJlce7TYJ6zV+QZxoIdug6eLGufLbXEhaE8toV1XMp3xi6wG?=
 =?us-ascii?Q?+rV/C+d+Z0n1FsPQbqAcXSePfHwDCag6o9euHNefaVC0jhFDEMCuRUaiVVjK?=
 =?us-ascii?Q?e1bhBeRwPYedw8LGjNpeQRnb/Jrhs3VxrIEIt44/Ge430f8qSXqBUuU/rsaB?=
 =?us-ascii?Q?r7EA+jy6mHwg2ohb81V4AD1nPlEkMl0PdFx4ftHMMblDO9OMvIFT6Kq1z2x+?=
 =?us-ascii?Q?yCaW9gHGnmeVWf1juzkWsNdlOZLhBUP2kN4Bc6oOCySD9pY4Pwfs1XwaUD0M?=
 =?us-ascii?Q?RG7fMUlRf1RFbOEzHNFeuWp/KCmX6sXFq8v18jl3eRwAjg7PMe/v1fDLsYBU?=
 =?us-ascii?Q?iUTEkElrVTkJcyksCEOWr/s3fWVmkaVtrWT/du+lINLCYXat0Fek4ZeqKXpw?=
 =?us-ascii?Q?LE/H3pOA1UFkhTBbfGFxad3CLoNaixsvfAgcNsChN3/Zy1qQ6fGclDHSDuAb?=
 =?us-ascii?Q?HAgl5Lxm5wt6W6e0mSxcKcf/khQLsNhYagrVS2sxF3UEJ221DNDqGbXV+Vxb?=
 =?us-ascii?Q?ruHmshji/cIlkJ6lLSPQm3PphNYK2EhpfdBLDmKWZ/aKp+1Z57lHEyVSl+Py?=
 =?us-ascii?Q?ORYsxykJywfjbcMNFWcEwvEa4l+zqkyP8rRww5hrKI6r1K5erFXV23qP4eSi?=
 =?us-ascii?Q?fbjhw9XCV6TrDLeq6Dxp7pqsnm9Npcix4CwBuKvVsI/5TXO02viI6+Ocox72?=
 =?us-ascii?Q?yCjaBeHnWjo3c8U63n4AiLL+CUQE9RUxPa/VEI58sGQV7f1OUd506lU/QnVF?=
 =?us-ascii?Q?gGsxmuCyv/A4pH9YkZs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480479ed-fc7a-41cc-7fb7-08dace1e37d5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 13:17:20.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pw47NDpvJjoUttE77wl3oHlpeWv8HIJXwY80EGVjbXVUA0jQn+iePEzu5TiYws6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 04:26:54AM -0800, Yi Liu wrote:
> This avoids referencing device->group in __vfio_register_dev()
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 7a78256a650e..4980b8acf5d3 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -503,10 +503,15 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  	return group;
>  }
>  
> -static int __vfio_register_dev(struct vfio_device *device,
> -		struct vfio_group *group)
> +static int vfio_device_set_group(struct vfio_device *device,
> +				 enum vfio_group_type type)
>  {
> -	int ret;
> +	struct vfio_group *group;
> +
> +	if (type == VFIO_IOMMU)
> +		group = vfio_group_find_or_alloc(device->dev);
> +	else
> +		group = vfio_noiommu_group_alloc(device->dev, type);
>  
>  	/*
>  	 * In all cases group is the output of one of the group allocation

This comment should be deleted

> @@ -515,6 +520,16 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (IS_ERR(group))
>  		return PTR_ERR(group);
>  
> +	/* Our reference on group is moved to the device */
> +	device->group = group;
> +	return 0;
> +}
> +
> +static int __vfio_register_dev(struct vfio_device *device,
> +			       enum vfio_group_type type)
> +{
> +	int ret;
> +
>  	if (WARN_ON(device->ops->bind_iommufd &&
>  		    (!device->ops->unbind_iommufd ||
>  		     !device->ops->attach_ioas)))
> @@ -527,34 +542,33 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>  
> -	/* Our reference on group is moved to the device */
> -	device->group = group;
> -
>  	ret = dev_set_name(&device->device, "vfio%d", device->index);
>  	if (ret)
> -		goto err_out;
> +		return ret;
>  
> -	ret = device_add(&device->device);
> +	ret = vfio_device_set_group(device, type);
>  	if (ret)
> -		goto err_out;
> +		return ret;
> +
> +	ret = device_add(&device->device);
> +	if (ret) {
> +		vfio_device_remove_group(device);
> +		return ret;

You could probably keep the goto

Jason
