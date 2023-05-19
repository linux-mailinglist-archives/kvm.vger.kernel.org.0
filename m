Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49A709865
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjESNfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjESNfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:35:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E858BA1
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0PO+71REfb/5UePn7zqvK7b1sW+TdOt1Rh+Zj92wpdroRUVUfHGunNs9Zi/ERYrkljTH8IQmTiygp2QdBQagm3iCioEFX8tpfZt+AVR9MGJhWAxXwkSYOXVoYq6b1UMwBZuDBMld6p2DDvyVIAdOfoz6eHhfRlqLQnrQRv9EIoNS+82mQZYApHWjdt7szuOLyUlysERE8Ejk5M5/YEQO5SzWlvPlcPja3RdtSR+J+zP5w3VOTSg+zqD09OA4pBRSgVOzDQ77ghJKRrSO/0dWqHqvz9t8KZtOVDrPxFdPUpxs1hcyolt9J2+B7W4Cb0ZQu99NyQh6RF1NyoE66nPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExwoZW4nd1uIL99VkSs4cvm43o1mvEEWfysRMjWlU58=;
 b=gI9Vs+l4jmfMtUvhaG3XWMvbdxLXHWQPoLKF+YjqewF+KN5uybsvqvTLwPQFEF/jMtIga6pLTdOdkH2E5Zk4Mmz7pDqw7gtQbMdGKQMrwCSQJY9hxBBRWLYiKg1v+tll2Da5i94VwhsadhChI3byeeouH2EAf1IsNIhP7nHn3rsw1SbDOhTekhCU+ElT0BYYm4qBnkWrlfVXXh7Wq5jyCqHlam4VPBSyN8pjeuwoV0V0gZ7vWQZ4CMZZe4YKizVFl1Aij8xIkscJGe1KoarvmZ8jvqI2P9f5R7wcMT+AzRXgvVYRWklMWdeAjONP7zJt49TWRptkXvp4EFQcapwl1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExwoZW4nd1uIL99VkSs4cvm43o1mvEEWfysRMjWlU58=;
 b=T2iqkiT1m45tLMaXati2330Cordok5KasNJeo3j6SoRGE8ncn2D9YaPnLoEep9oW69dcWn9TV7lWN/K0MyxwMjt2yBxOhZguIJlzSO0rWl3qSDWe0N3X4wGx2kBz0Y6E9C2VP+aR0qZ1m0oYqzng4KV63sC9ocT6gIEm+9P7Fil31esZ6Ycc3XR1UHKC0VDfoY2A+a1cVCFHPix6gdw0q12NjnaDMVFQ/+tS78RRI2cQYdDGlgYDj3avBopkGpQS/vcTOyp7Dm8WnaFgWeh9KYgo1MhgrGcr6WOshZhVuNChId0kGTys972yJu1fcT2POglhgnLXuuIDunHALs4dlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:34:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:34:57 +0000
Date:   Fri, 19 May 2023 10:34:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 05/24] iommufd: Add a flag to enforce dirty
 tracking on attach
Message-ID: <ZGd7AG5ibIYN638w@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-6-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-6-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL0PR02CA0122.namprd02.prod.outlook.com
 (2603:10b6:208:35::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8b6106-b57a-4c8f-0dee-08db586dd63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mhTAKnjaL5bc/EGAQVryOpEQvpOwFmqdlzo9NvJ4COxffZTxzEcWn6rg01O0mdlLHaLDiWfJbtS3lFEzsHxa9O8vPFufUFVh/svADX6tclw0yGomsyBrHhKg+lFS7aLovjaTL5JhAK1LZdEiifcgCckN4HmWpq33EaYP0vD1gg5SLdGusq8L0V1rJEAjshwy9qFJ1RlEYnJ9Ja5vSUrVClYXSPQ5K2oFqDUVvpDO4XR/fKZZWliyIJfYK3QkOjKqRqtE+zKOegISCZ7INKNZUBySBeZtO6JDS0kAQkhVL4wJE5zNZYPLaX3MzFoPL56V6k9PcNMIwdhBeRC9ohTxTej4TgNO3hAeW+wD80L3+jyNCrzZ4ybgsKg209q+QYqtE1OtSJeOn9MRY1DR2BNT/CciD3cNNH89OE02VT5DwSq7aEsITMgQ27w8HbmL1DlPrdcMAkUDNkEJugRt9izbkCIVN5ZnckUgHZOxQdY00VyQfA2tDM0OXQGCWZbx9M9WHL9tFvpFB+qsItAw9kFKZ0NBTBKhZf5a+DBu0HTdQt2V582OFT/3dzkSZW5FsXbRNzC68IkWtz7OEAvHZrVU+uLU728R8LX5EQeQTvwCrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(2906002)(4744005)(8676002)(41300700001)(316002)(8936002)(478600001)(54906003)(7416002)(6486002)(6916009)(66946007)(66556008)(66476007)(5660300002)(4326008)(6512007)(86362001)(26005)(6506007)(186003)(83380400001)(2616005)(38100700002)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ke4NeiJPJ4d9+8HuMMkTF4LDI9funR9f/+GlYULqZ6gNQs7SGixCBJPjNk/1?=
 =?us-ascii?Q?ahDm+y2r2NRPWYkekijK3uJn2NrFjH7KpO2IWwcAYQrcOeNleyHbm4BsPYCm?=
 =?us-ascii?Q?m3ekmt7nkNAHN6YCne73lCw/cpp2CU2mKcmLOzxZ8y6kvo0D4QLHllyaSKE2?=
 =?us-ascii?Q?rR4i5OT0UKVYjEjKP41xPNjIuUsV1VdFPrFYO/Jg5a53BfsOD9a/stuEu64Y?=
 =?us-ascii?Q?EokeHZqhc8sxHfu6yURFBEBUPKCUXcQxo6NibBxXWpjarNbOlTBkJPhdoEce?=
 =?us-ascii?Q?5gm1pl+wtCTufyy81SBkQRObUC39MQpWWv7I0ZD5sbtgDc9rx3NFoYqDOlWb?=
 =?us-ascii?Q?X6L4KsbqIJRgyrPK558wQ21wcBarIQaFM0HFQ/cKDdyoVmGR45UVRLFjKo5b?=
 =?us-ascii?Q?0QkUXqGZiTo9eFJfUT0DL8rp/R+QF04Bc7SyMDewDviFWennSGuZ1nS9H8FB?=
 =?us-ascii?Q?cX2Z28iOMPdIDNZDJJ23Rg0t1L9v7K651amt5zhAdlIGebs+hz+C+SX3JV5+?=
 =?us-ascii?Q?aLYnZsWzZ9MGElaGnGdvJjFIVSZotg5VwEVbKkVON6jrrqaZuVqoXbaDC908?=
 =?us-ascii?Q?dZsZAOOMbldU4QBl8AEw28NS+93GhZpBG5bLZuYoJrp6D6+GxIqUpQpzTn6s?=
 =?us-ascii?Q?5BPWi6L12QxTqbM0gV0HyJ+lIYuRf9cHDxnmIhPJ5XcnPyc39V1M2GJajArU?=
 =?us-ascii?Q?Pnbv8oDRoeqsiGDUruIO334UCKyZlnJc585sYhw0cAPIhEeyhRg8X4y39B5p?=
 =?us-ascii?Q?1lrbJHlCFuf2ytFMXGj1g5WvmRkmeX7PylE1jX32dRObDGSFfcyMzU/Inz+J?=
 =?us-ascii?Q?sQNIKPx2cz6NVuXsbmPEMMOsXFeq8g0BSN0ps5j9X8MVAE1df3R145ZK2dKg?=
 =?us-ascii?Q?EC1Cb4WZBtj9ThOogTtrSnE+acM5sVRFuwwba2hq+/zc4iuEScIkXROZ0XtK?=
 =?us-ascii?Q?gi4u2LFaUOdPW5ogr8KcaxneVw+lv6y/hl4fU6jLvpOJx1vxi85RZh/rCtFP?=
 =?us-ascii?Q?RatYNIocR2CnkpkPgXpHA7y5UbpalrXHrjnWV8lNf2CnIuLTGcDFyZdcNNYf?=
 =?us-ascii?Q?8yL/3gp6nXF8rSeQ+Ldpg9gP6dmsAU5bLKwKrO39QtCWb7aUxv/GMLXNkLN8?=
 =?us-ascii?Q?3z7hCgHuw4aB6aaFa0cXc71Tgal6CRPLV4E8kXm6JHsOfno/ggIx8U/OsTHo?=
 =?us-ascii?Q?YAq8Apy1FLVAk1zQ8jBWA095uuVcDitgBDohg/pmSnDH06xULbh1VgRZX+Gd?=
 =?us-ascii?Q?U23xT9gJZDh6tKOQUgFf4EqVoEO2JwobPOgDY6udNOZrjFtou/ebKAcb1i9Y?=
 =?us-ascii?Q?lg2LLXx9VZHzu85ejBNidmsRNkDNNADA6Nj/kINyyNDLYwQFhgl0jfOzRX2l?=
 =?us-ascii?Q?bUBOLT4ch6bejiULi/gyBTMX4wjYl0CtHVInbjfPqfBR+l01xcemGk919zvX?=
 =?us-ascii?Q?eIg0iQ+gzsgRD6tUSW1zsF1+63w5GOOyyCdK+5boUiweqKL1FF6nBDDGbGCx?=
 =?us-ascii?Q?nf8xB2yiJV7hhMyNIbysLegv3TZswfLPcCKSs1cCtxrskQXOh+K+nSDGHRDM?=
 =?us-ascii?Q?fXTYSYfdD9S6ajGbX235DGltMg9GdBZJ64DUta9P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8b6106-b57a-4c8f-0dee-08db586dd63c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:34:57.3573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6Hm5Ietarwn2dp2vMjf+/B+aK+yBOUmIveYcWFsX3nbkdn6iFr6Bb1ldey3elZP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057
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

On Thu, May 18, 2023 at 09:46:31PM +0100, Joao Martins wrote:
> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
> guarantees are needed such that any device attached to the iommu_domain
> supports dirty tracking.
> 
> The idea is to handle a case where IOMMUs are assymetric feature-wise and
> thus the capability may not be advertised for all devices.  This is done by
> adding a flag into HWPT_ALLOC namely:
> 
> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY

The flag to userspace makes sense but it should flow through as a flag
to alloc domain user not as an enforce op.

The enforce op exists for the wbinvd thing because of historical
reasons where it was supposed to auto-detect, it is not a great
pattern to copy.

Jason
