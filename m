Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6036CF3EE
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjC2UAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 16:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjC2T7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 15:59:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FD16EA1;
        Wed, 29 Mar 2023 12:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELgJQqYj3b7GFZVCXWygnGwGJJUjY9j5LNhgCRP4b6qIi/v01iDOtvcur0L0uPLEgK5Li8ecYkckvMWymW4xq8NjJ9uIcWOuQl5D/Je6XsLYXHkzDUWya7VrTjRN+Rcnj+CSLywxD9Ajw0zRO+T7hHlta70rW/1kgDwROG3JSwDEhRkXH3LOq/qIOguzfV5lAdXR86HIiecLKkh6xe6mEm6S4cFHoMCs+16B2b13rgsaZjSr/o+n5xkPzcMCZ5wgmd18YtlLUOC1B0i7W3OhM8qRdT+GW650UVdlUZSk4CYJ+RL/85iqCKBsfKz/zX7vzmSi5oHHoITMkBh2CKFqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvgIXfLw2CX5GRpDiZKf3PWcQQ2cnumQO9I08lP6GjM=;
 b=a69GyUYj9+V1tHqdsIL1Y1T7etgI4gz52lYM23+myokkt4AArusNMHxq7DaiOtFHjksnw99ahQ5DfHCNMmmDgm69538ee9lBtQkFiiSU6t2dZDMzoCmSrIFEzPbnkltg+g1XSPKisW5BlpIvsY7Is6H2JFtbINlSwONsiacIbHc7PGn1SlHBNbSx2w1ysaHMTusrOdb4KJB84zSSZKzIh6hJWLLelhP6Cgjjlw7ex11GO99AJrsXsW2HCB1+7WmOnIforetDpNXzQ9NpCI6bXZiKbrRwPGwdOQkQZO8UUFIuYw/0HO8Z1Arq9P7yphl1FjP9xIDb8xXdWyQTPRf0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvgIXfLw2CX5GRpDiZKf3PWcQQ2cnumQO9I08lP6GjM=;
 b=LOxuGyldN337OLSFEdF49e/lLvP/Ig6Nh0CiRhqM3JO3LqsuviW+k0YdVcHHbWOVPt+5Vd8rW8gVlqdRoC3Ea5lnb5k3PFBP9qDNFP86ggIGCaVKgl0OtY2Tpu2BPYValk7TqaX4SrrtTyZlMCQx4Uf1HQp1nQNGbhmWgrWqTvJRRhjCcEzI2KGlX2N70Q/E26DBL0gx9QQDjcugg12/9t8GXrF4NHp2Y/JvmSI+VSSDY9HMmFqYcvFisZXIhzRYv3hKZH4SzURqpmdqtOrxs7/fGZMJicNvFoU8WfPpQs1lT9SR6a2wW87kfMu97nSPNJ5UnQqAgawKaNZ2YIq7mQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7247.namprd12.prod.outlook.com (2603:10b6:806:2bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 19:59:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 19:59:39 +0000
Date:   Wed, 29 Mar 2023 16:59:36 -0300
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 2/6] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZCSYqHIo/QrFL70C@nvidia.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
 <20230327093351.44505-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093351.44505-3-yi.l.liu@intel.com>
X-ClientProxiedBy: YTBP288CA0024.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: 04451f2a-b544-4dd3-dd58-08db309020ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwwCUu97sT2ls5G+3jJ4SLPg8fAL7SDnLh/8FxYI4P7dR2VL6oT6cBvPzFmPpmYoMKgkS5ugxiO9+F5eL0mifCMdlksucqdciJ4woVfbobWyxKLv5kHX0SRTE8M3UNV7Nnkl7KuByBS4w4eganfaOD163dhsvCEk18pbDjh/6Dn1BGA6jL42FsSnBIpQfvExMkkoShQryL6YiwJCPyu5FpsroqKBjJuL/NF5xXCQECSnrH88UwVax4rS0LiNsgpqcYw/OuN5JqD079f57yujEU0eNjoRZy0seBsNwgYH/pKGjIecRCE8OBorrrxuk6e7q+D0fg0z3Qz5zKOK8dRDuJwtaGx2JQ19ff3l4OrmIRKwcEFjq4ukGX5jrJCzHewHxNMX/Oc5x18pLNMxoYkAK4YG0589FdH92rU9XV9Xsl3uJ2ReP318gz+3Ubpv73M7Ggk7inVglwpzZyD2QmiCzU0MXuMVFvxcZ5vyPi2W/7XbFGIOxgh0jddU59R+TQoVAN9kI2eTZnPlhKUKuHeZGb9ZrG+imDqYNyDGoKqKN0I4ld9eVYg7qNKoIbW9FCmQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199021)(66556008)(4326008)(66476007)(8676002)(66946007)(6916009)(41300700001)(36756003)(2906002)(7416002)(5660300002)(86362001)(6486002)(8936002)(38100700002)(478600001)(4744005)(316002)(6506007)(6512007)(26005)(6666004)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V456vgEFJcKsX2ECdt4hN7RKDWtdTbnzY5qBEOi39aMMjFIVWXR0BXxhrOKs?=
 =?us-ascii?Q?lk6Puxp7tiiexFtQyqBYMrDUcI8i+EJeXzrhzuttBxnY7UUHhoZ8lkGGfo6v?=
 =?us-ascii?Q?9LhSblUZ7w4OPrHiovMc2jbRRuR1hPnBuwc6S9q5JBwF5TWhsKfVIQsqQVUC?=
 =?us-ascii?Q?SJqCkrE1LeEOgboDAiPrSCGyYu4hZInan9rUOyXyNSrdQ42hhwhI+mJGXG24?=
 =?us-ascii?Q?Sj6hzzmF51cAMzartgkUGhQ7x1Sus69N3lxI8elX5XwWDFNv+ldHSW1Y4vnt?=
 =?us-ascii?Q?ci3kAC0UYDHZfIcABUJMLVjipBpOAZcbzzfpx8rFGMJlhXS/F+LGMWdid1TJ?=
 =?us-ascii?Q?wNXFlNLkdonh9bTrsZVUY1oW/5TjNNJCGxtDw6bXs7kayigrVQF6HucaRdpi?=
 =?us-ascii?Q?xm3qdB8ywSOZmFbNe1pzMn3DP7eEoFQaeCaglJM9tqVvUX+o5AqiKqB0RxD8?=
 =?us-ascii?Q?awjK1Xyoz3dfwpxgdI7QQEyU+5omEtrjZ9wAQ8rQNLs4ZrraRU0TQauOEi/I?=
 =?us-ascii?Q?cXOmha2hGygdTRJ7Tu9756RsTwa0RoE44Nq7+vN5wUBeYx4Vs5qdi6ASmB46?=
 =?us-ascii?Q?l1cXgtMHYRNU+abrvBMrgUQh0Z/noMrzLscXAQ9PbmDVpG0BY049YQ4U+scC?=
 =?us-ascii?Q?901RZduFhrrYHad03jwUX5XhD10w9ScY3Tr4z92EsVT70pR9mBUfrnmClYEu?=
 =?us-ascii?Q?HGfOeEe91cfBwp1XUU8rjt4FpaX57uK/AfiUy7T5DqV8duWNe+ur60yX1sZT?=
 =?us-ascii?Q?DurScpjhGn0bFxnkwN+xR9XmxpkbPE7EgsRzp6RAmxe0bC+5Kc08Vyu+deaT?=
 =?us-ascii?Q?n0AXw0XKtLiln8OqGUZMnNABhPxJ5f9zu6UMop9eY7x8+MquKOkqfpi8cpoe?=
 =?us-ascii?Q?Np596f7TnWfGybfIn+Fgp758Ok/CoFukOn8vX3q76clwjR2WZdaEmhqT7BhB?=
 =?us-ascii?Q?SX5ToDzplgeCxUwh3j4dlx6FM85Q44X+LMxwfDMCK3/IJ3OGSKDop4XeVdM+?=
 =?us-ascii?Q?MwP+v2F8bRF8m/bdHCOM8mGkx+Z8Imc8SeZgg0p22yg5bKyCI0WwYDAyaIZx?=
 =?us-ascii?Q?T+EIomjQH132IR5kh5dCHFPSRygBndpr5iC5UtgfIQkDTEi2cSLQLadNFx6X?=
 =?us-ascii?Q?23AOELOLQ1GNjO6DA5HcHknP8qotTwYa4RwTWR9tL/O7ooecH95+z25PEQHv?=
 =?us-ascii?Q?A9WIUdLlF2hCB3XwG7y+BZpKtvP8PXYkuy68SearBSL4VMnHpGklTQxJ4f1t?=
 =?us-ascii?Q?ToJB1jV4dWoMl1dNRl11H+MYLwsSk98NBqx34X+Boye9WG16q8riVjWiSTsF?=
 =?us-ascii?Q?CT3Nv91KVVAfI4vRY+f33nGFW+nIDf2CJlSMJahQJxDUoVfUdLNe6mY0LRGQ?=
 =?us-ascii?Q?uQlsRodPMcCpAW6Yk5IdnJkSLy0BmtQQQh5MJdE6qF8vC6At58s99jnAeXgv?=
 =?us-ascii?Q?EuSeCKcRy5hJvfulPafwEj666+jx2DLbUt9x1SSu0rhY+tcdnR79F2tOVNpz?=
 =?us-ascii?Q?D5pIBZ/t37zbbAfrkVKznZ+TrRiw9DrnqTeG/6GbNo22EGwkDPIhlSEwg4wO?=
 =?us-ascii?Q?rHFUzLbeiA7txSuX5lKNjNAcZ3YasS/+lbLT5ua7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04451f2a-b544-4dd3-dd58-08db309020ad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 19:59:38.7870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/UYtDy/+fiJVXUCkqTT14MHpHZTYbdEkZdUslf4VM0OLoWZbhDH5ZTZWgOiLIXF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7247
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:33:47AM -0700, Yi Liu wrote:
> @@ -494,6 +479,30 @@ void iommufd_access_destroy(struct iommufd_access *access)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
>  
> +int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> +{
> +	struct iommufd_ioas *new_ioas;
> +	int rc = 0;
> +
> +	if (access->ioas != NULL && access->ioas->obj.id != ioas_id)
> +		return -EINVAL;

This should just be

   if (access->ioas)
        return -EINVAL;

> +
> +	new_ioas = iommufd_get_ioas(access->ictx, ioas_id);
> +	if (IS_ERR(new_ioas))
> +		return PTR_ERR(new_ioas);
> +
> +	rc = iopt_add_access(&new_ioas->iopt, access);
> +	if (rc) {
> +		iommufd_put_object(&new_ioas->obj);
> +		return rc;
> +	}
> +	iommufd_ref_to_users(&new_ioas->obj);
> +
> +	access->ioas = new_ioas;

Since if ioas is non-null here then we will lose the reference counts
already held.

I'll fix it

Jason
