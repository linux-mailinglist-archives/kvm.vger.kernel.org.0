Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7FE6EAB3F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 15:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjDUNJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 09:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDUNJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 09:09:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDFA9EC8;
        Fri, 21 Apr 2023 06:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTty/+uqX85Nw1L+yO132OCH1tRYUo6Yq8VWg5Ph8mxTfZl8YJU6Vstph42emTJnPk3LfGjZqWaBCGvd2pyHSyqugq+6nGpw/Nu5Nl1ltxKXjBtvyzbsM0POwIyB48zBeV/f7ZvFa73Z0RwhcPZuKra4eNn1OwJSI6suK7Z7Dun7Ab85fMvwcg507BjqA7DhjvqAlSof6ZEIzOJnahdFLlA0DiNcCCoYPh8bcvcPyhUzAPVzd/gFzu154N+KwDzfHMLZhGdkYVWnD7uBZOZn7aLqq33eQo9PVtEqwiZq5tDxKBvNt7/J7OEZogZ2jxqPnrUOh0VcbC0OFI8ADUkS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Agf2ycsFQARsc7DtkvYaYQvcqB1V7k8CY0xXi5vBkUM=;
 b=N0cvnuFdIs8HrrfXCxvb8YZ5affeFeYnv2IHpJbScJZIRd9/Q1JlTshnc2OZfMhOThUCgaP2ZSkWlqU8gE3QVjg1SEB1pd5aqEbaypRxo1nBwkmPT1D9KHSRPHOAgRpkwvieGr5VrVJ3GEw6TFdY0iUObPk1GOOGk+PGrraE9Mq3n0UcB5GnGjaLHxLRipMwj7gloP/QAad5mez5mOjW9mpafxnjFoAfezevZhaWQQfJcuyd4L/lsBVTg81h8AXsaRc2LNquUwlA/GeMF9GXXDkofDcf8ZfvDjVnKQoxvDRXLe/cgvM7P+KEd3e4RhnHJb7BGcrbZ6eaUInW6xFA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Agf2ycsFQARsc7DtkvYaYQvcqB1V7k8CY0xXi5vBkUM=;
 b=uPYC4YcgsqOXKYJSW3pluqKo+0yxn2fKybAgbaaLUj1gGuDYfzAgohf+DdSJCBTBt4BY8F85nvV6brNCHFBLuM2g4dNBL+AJ0FX2fwPyVH53ja1ZL7lXZGGTm5nDRhvFQ2mgrcsrT7JBi4k7eSRzVdj7oYFc1UDPCZxSzbeDuMqru3/jR3Hioz+yU56nd3VZJ7msaPETk/N9Fura0+BgJjgrE0qimFBiwAANOJ49G7bUzWOjl0fmWp9jueUhMd2Jgvnvwo5VcXgdyez6BfIJwWFvQDt2oxbKj/4zEAIQyG5pteve+HGhvJo9hE/Alq+9bEM1CqfVh2nSKWW1QjO2Lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5300.namprd12.prod.outlook.com (2603:10b6:610:d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:09:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 13:09:37 +0000
Date:   Fri, 21 Apr 2023 10:09:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZEKLDzU8C2niNyOw@nvidia.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR20CA0044.namprd20.prod.outlook.com
 (2603:10b6:208:235::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: 2130bb43-ade5-4c6a-9e35-08db4269a86d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCBzv+nykEkS3vuGI67nj27lqaBIG5YGcQ14O/8id6FModp36BsRbDY6pm90C/RSqWvISodqMt+LgKMVxflx1gp+qHAIIGpryDEUQqk48y/XhfR990DGrdvjHyyzn2szQBRkg7A0UXUCVvGMwzGBaC1coQW23wq4xkBSZ36IN7e67o+IL+ljsw6yeBi0NBapU3+TJuVHvHST9NILnB4uJiD55KiS7MSGxhowEeBf0iWjgNJHimFxosZEvzEO1fTlCv/ReIOK7VCGn586Wdo6wmp8duG1EioPBObN3JiyPOUub6tOQE4ZZctjiv/5FKO++yC9QgGGCAxfWw70t+w5ffaAowiw2/QqW64IO4mEVcpGUKwoenub/j9hs3lSFj6jt8OjjRo2qzodp/ld395tAli2xNr2KOpTVRq/YXLVMJsF0jxQZjTQbYP1f2uP9N30wfn2u+u1qPuoyolJ2E3UDeFXxEfZ+6ajU2NkdGjRfwt1TCkgXkOM05REMCTxXAM1YS8SUg84pAtJzHmHMix54sf/2yzHlmI3V3wCD+EBr63lpraqfPq3z9bpK9RMZ6yk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(186003)(6506007)(26005)(6512007)(4744005)(6486002)(38100700002)(5660300002)(41300700001)(4326008)(2616005)(66476007)(6636002)(66946007)(8676002)(8936002)(66556008)(7416002)(6862004)(54906003)(478600001)(37006003)(2906002)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H+1zelBzTCvd5w6JO49GS35fbJuSgf6++2QAbBHAyuJc1MnPxB4OFK4LP4gx?=
 =?us-ascii?Q?Ou7Q1u+aVejFAh1WhrkE8Y1NxFdgNN7qNvi+aa4Z/BJ4X101jUKYbl5S0dkP?=
 =?us-ascii?Q?9IrOP8yRAF3NBH4O326+6Qw3a9rj730rcwHEBWBu545CF2he7DSKOvxbNT2z?=
 =?us-ascii?Q?Sjay+2ws3gAWuJgj+1Uh/LKfFTNs4I/fUVdyll7jOtjrsWW2AhOgj5jzy7hl?=
 =?us-ascii?Q?AgKKVwwnMwFNCAjR3fNrMjlWgc7HadueJb9pTAQcU5MRCFWo6KinBc0sO/oQ?=
 =?us-ascii?Q?Go4LXtMKP8BJ2lLijU8p5OLiLHeCYnSB8nKpZj55GrAiLZS0xc4lPoaojymT?=
 =?us-ascii?Q?QjlkztHlwYIHG3/Gg0Fv6+bEz5HhHra7ItFa4oyG7Koz3WVzv781FecZHUnP?=
 =?us-ascii?Q?Aod9JRbVKW194ugb72PmieKtkLB+1BRtJ+5Y5+HMpSd+BxvB1l5ISIwqtczw?=
 =?us-ascii?Q?ZyIXZ9AL8mHb/fVn1PLmr05vDwMVgy1eqmBwrO3MLJKRSCZE9W3lMjh6jFjN?=
 =?us-ascii?Q?4iXPDojgn95yFZE7ovMTqasHD5Yl39Wz60TcSa/ODSUQ/YF6PbKTF2BwHFFG?=
 =?us-ascii?Q?vMdBk2WNMbR+d2tkeNZTxP/nWTx8G+nuvmCfXq5jZs6qiiyGtczD/KV3sxUv?=
 =?us-ascii?Q?qHgiFE6unY3N30AS7aX/pynf7J8quY0AvgwL+DsIZKQaWbvlRpuU28nU0JQI?=
 =?us-ascii?Q?mai1/k3MggTohNUE4U4kw50Brx4OteDGDb0ALhp8+vWnLH7b4xnMOe5SpXop?=
 =?us-ascii?Q?NqZByT4QSAcWljNuviviVoeK9PboqpMjs3JJdRPLXeMzIjtr3dO4NfcImHen?=
 =?us-ascii?Q?r2C36Z8zOYrp4vbTAWRpOU1FMJtogH/4VYaqIRt+sYxRVo8YPrtkRNBdRH6o?=
 =?us-ascii?Q?KnvcugN/HPxU3j+IPD49HFX85lu+IduDbDlFBldciybYZSJJoxu6rs1n6JMr?=
 =?us-ascii?Q?R4fE64GSBtkO12jVFm80U8NKvfYdhedogOxeoQKJQYA/otAljxYh1SbHC53R?=
 =?us-ascii?Q?sBnrq4Watie/XNNABUJH1/MJjs7ZJIP2nN/se03XExri6sbPjbGXk0E6RZ1f?=
 =?us-ascii?Q?jsgPRNzJxPDWvk/n36B0ilA71osy5C+yZo9ycDj+6v2qvrVEYXY6vtuMKrmR?=
 =?us-ascii?Q?re/JCpfC2Pbltf9WDDcLwwhyjp4n0g6AjLZ4mebqllcM1ETcolc4KQTSHsf7?=
 =?us-ascii?Q?CnuhGnJXI1+M5Rz1GabIWJSVY34QMfz/SsSRzR7hIs55IDdj5TNJs4pUN3gP?=
 =?us-ascii?Q?3YMHZAdep5v3HVqQ+w70YOU2mFlsi0/jbxmy6MIohyjlkp875cd17lQC7KUy?=
 =?us-ascii?Q?/PxWPenj4IPXDZnQFmS5ZkJlYt4SwEXaGtC7uEkLgj+02wF+Ig+TS30YkmxF?=
 =?us-ascii?Q?/8mrlTlovD7etlo/cbIJ8o1679RB9oTS1pOsUJFXk+rxay0KuHHPRHjSCcgL?=
 =?us-ascii?Q?KhsTvHqerefjeuBhbUfaxLaguaVL4Ns3wyiTAb2perEZiDae62YP7rlPsEBS?=
 =?us-ascii?Q?YXOxd+YadgIHg0F9nYB3DH6Jh+fxs47LoLiOisvr69n+zbFpN6ayhi03oc+3?=
 =?us-ascii?Q?2Ft9rA0d3lv8LAHyYLamQSPuKX5oEmfc98nZ8ere?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2130bb43-ade5-4c6a-9e35-08db4269a86d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 13:09:36.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNntpBGzwr117KbeXckVQPpq0nB+xznn8OOs4uUO019bJWQe3mvNhKePIzOuWvsE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5300
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

On Fri, Apr 21, 2023 at 01:20:13AM -0700, Nicolin Chen wrote:

> +/**
> + * struct iommufd_device_set_data - ioctl(IOMMU_DEVICE_SET_DATA)
> + * @size: sizeof(struct iommufd_device_set_data)
> + * @dev_id: The device to set a device data
> + * @data_uptr: User pointer of the device user data.
> + * @data_len: Length of the device user data.
> + */
> +struct iommufd_device_set_data {
> +	__u32 size;
> +	__u32 dev_id;
> +	__aligned_u64   data_uptr;
> +	__u32 data_len;
> +};
> +#define IOMMU_DEVICE_SET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_SET_DATA)
> +
> +/**
> + * struct iommufd_device_unset_data - ioctl(IOMMU_DEVICE_UNSET_DATA)
> + * @size: sizeof(struct iommufd_device_unset_data)
> + * @dev_id: The device to unset its device data
> + */
> +struct iommufd_device_unset_data {
> +	__u32 size;
> +	__u32 dev_id;
> +};
> +#define IOMMU_DEVICE_UNSET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_UNSET_DATA)
> 
> Maybe just like this?

How would the iommu_ops backing this work?

Jason
