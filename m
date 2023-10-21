Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E47B7D1E3C
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjJUQXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Oct 2023 12:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjJUQXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Oct 2023 12:23:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38EFA
        for <kvm@vger.kernel.org>; Sat, 21 Oct 2023 09:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh0PpsUC+ODNUm/fftepKpo0EW4kSFd2B3LwL5o+KMWIzi6PeiStqKATbto2qXjWTQDdQoalVTvkh20So4fDfpOweNIBrh0lQ6qWmJJTN8e6zkq23kBqzXRjcn+8k+Oe4bIh415QEchkAG3zweAj9TFb/1HE+RqsQsI/rfzn9yMZHA+A/ruGORCG/80ZIJn21v4ggcsdtLBkPEGVysOFTx7wB8XtGx7K0NDNbwl0ZuCRRxim/T74BCUqx3UeMbVC1wms35ddW8YeE85xZ3OIudgwOIvnF6JJK6jf6oA8KFMNmSAVYsmPCqEbcIurrm17Nf31rblPSiE3yW3/4G1T7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCykWdKKmPONPmib+d50IjbEXoX4bCx7FIZvWygWsD8=;
 b=Ofn3/Ksf4i5lRqacwWTU2liHkTgFTKCVNLBujXclAzC83yfXRyYtJWRqoz8EMQYsRug1LhEX+e6ZWv4o3wLZ2F+Z0Rlw3N/w8l/dCHv2meMQ0xDf0VQfnxeYJ/AYULEwC3INQJm46PcTi2xah7ReWiOx0PomOOya6dfH5SIQRDylIjIEc2K8YseIQVQV1RCAvxLDZXNHzFIeIIqB3cvS1qBK/1vZoP4zVpDxrims0tuCncTLeGno2L/aHfHyGDC/Aj8tqjETQvFoxopb3235FCLjgG7hKXL2l6kPcCLdHyK0YrafFBaX/kNF0oZ2kjfXMqX130/sD7U9WOs/XODs0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCykWdKKmPONPmib+d50IjbEXoX4bCx7FIZvWygWsD8=;
 b=apJ9xu+2kVCDCOxxPPcEaNP/FiVqwAKzEo4In2N0srXTgRPhgVJvtU3Jhpvmp+WF5WsmQsMrWR1CKGypTTGi3ZaJZZIo4aHZuTRBOPCEZgoQN8nmVE+imfXNvSUtERqOmcI80T1EVIsfvQTcXNaEm27y5kKRXKj4FvwiDSS4Y3YnMWroJZPB8YYzYfbtYZc+T8I37AFia6m7+0y6EjLbX9qXuZ9+3VfYW2TT/Gzxlbg/LvVK5u0IACa6vEER6VLs9kiDoKtebtpF1mnB15V0jgb0+H6KoYjZyGwah/oJylo2cg3BwXwZ8xWICuHxFCAQYGnRU2/D/hPuYKaS96y+lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7232.namprd12.prod.outlook.com (2603:10b6:510:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Sat, 21 Oct
 2023 16:23:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Sat, 21 Oct 2023
 16:23:23 +0000
Date:   Sat, 21 Oct 2023 13:23:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <20231021162321.GK3952@nvidia.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
X-ClientProxiedBy: SN7PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:f2::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb0e96e-90b0-4988-ef58-08dbd2520c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zqFuAer36kups81JnRKIY3LkzibeKRcuMl+VMutvKfXiWjXK9HzamQ9jhMHwn3Xu11wWas3H1wxhII4NWWi51uyVNFZdVuBOYu7ZKaCbiFpMJaS0w44FhRjTgxQCoRRBpX2B45mxGZ2Q3gIu0rDtcwIHFjjGKwTHA3KIrJB9mQaAsJT2oA7u/7yEETxLRUpV/1yq2p0A1z474wo9LfWVhH/iUoPiAXrDlqABw1/sEJ9TSmZ0Ix5HBTT2KXNYUc5IQx1t7UlxmWpboNOZXgj2gsmYccgqcJY+TcMdq3xGKfxlDKnOJEqpQiG6WZu2G1kKC3Nk9mm6HhG8TMGDh6K5MrIy1qENau5fJwKhQSbcAESOdS2wM/PKiBX/tMXlKsRISbSgATI7ZBQNN1/L+rUgudthRn3KFsamcEh5BLHnOuNRZUgpmWUiGXTlXPCnMYbEspcELSTmhNxSLmYBtEwx9QW7RDKJ7s1NP/aLOpn1cDVjbvvLSufsAXmuUy69sIP/76itCOEYzp0fQxlzyEhxYkdMHIR5dBgF/zTCVfYOgzBpZJi3HYr9RxOTNUABcslnu5RiXOuDM2QsLTL6OzqdezW8BDX922iaCyHpL621PS4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(7416002)(2906002)(6486002)(6506007)(478600001)(8936002)(41300700001)(5660300002)(4326008)(8676002)(83380400001)(54906003)(66556008)(316002)(6916009)(66476007)(66946007)(36756003)(33656002)(26005)(1076003)(6512007)(2616005)(38100700002)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HgXtPYJ8qLLnPjzI0+bl9W2DwIOKYpmct/OQ2DJ8YIv9CGG92M6Cu14hI+Qw?=
 =?us-ascii?Q?5BcIFUqew3fAVCGpIPRBvAXx5meDhbVDwbbxprfJXEGtfaPKrYQF/CFSzYgt?=
 =?us-ascii?Q?o7HHqev8acCTqZCG2X29G9AFoT2+uEKDojOJLHj+h7ju2uEKZskzI2PgFCR3?=
 =?us-ascii?Q?ML34DI2Atupf4EnO0jvV/vB4G7C2FWGUVIBOM4HQiYPLnODrIduxVg1kDzKA?=
 =?us-ascii?Q?x9ogFN/TBNlQ9YxxTinInSpYx18gdeY6DmeCIi0IxvHnZ66J7IcUvTHd5Qxu?=
 =?us-ascii?Q?47k06d55/+HOwXtyBTl/4jGNSyM982wYsfaJvPNWH6pAmPnLeeucK1cBbz7C?=
 =?us-ascii?Q?hBg+PElu4X8Oz5lAs/LBGcljg1NK+6LUiJjW7b//VOyYzEjhLpFK3uOkatWq?=
 =?us-ascii?Q?S03yumIeZrwo4oPJw94T+j9O+X9MMZrZ5OWOR3bE+/fi9Q9VqAMEmn/S6exM?=
 =?us-ascii?Q?6QY4jmgIJ5VA8AScwXV3eOf8hwFiKpZnAUzrGIcSLQAFZrT5GDv4ufz7T1iu?=
 =?us-ascii?Q?0o2hFihyS3P9khLt+w9/c74NX82JiPc8Ck/fIOAeZUddaKPCWfWLUrA8DnIO?=
 =?us-ascii?Q?24fajTWrBOV129qaDEd+Du6BVdBCG0vH1AKfBiBJYSE/J2Ep5Zuwt6YYm/sC?=
 =?us-ascii?Q?boy7eqWeH3dhPDsuToK2cAGldkjvHz3jhM/ArNj5wT9GxiceLwLVh3bwJ8xS?=
 =?us-ascii?Q?yXRi/vfcqyELqhKd8xrvfJl6MZ/AZE4N92cZJgVhLV3nXsYq2OdaPTwgsF1J?=
 =?us-ascii?Q?7aN5Rq+5dsF9mlE3L8afY4nHta3bzGPdAN5qFzx995lYdiqH9zizYzw7m8Iw?=
 =?us-ascii?Q?6Vjftgb0zdq/trCNp8TqP0edgEhGbNESRk+qZ5IdIcxVrDGZglCwpW/F3/9W?=
 =?us-ascii?Q?/EDawP05/YTneqNnbE38dgqqyCsacF8/KXa+KI/sTYWlddVik8duoJnCwnRO?=
 =?us-ascii?Q?BDBWmQkTvsnrDNAPpZj039Kg/XbLf8GQzDdkfCE2Rso89e0Zoa5WlefdU89Q?=
 =?us-ascii?Q?DsRurMtWCPI3G4Vw/KGl5BaaS06amo8xuPBhwc57UZGWTJ1jY6jXGbdc6XnA?=
 =?us-ascii?Q?BKF7LNcIoNQ2bHOiJxlEeczGz057pW+/a/jhyhD3+3EmhD+p1+nRUkt/RgbY?=
 =?us-ascii?Q?N3fesouH9CObD/EmcmGHD8yXJj2y1WYjSuRR8v/a/mKEuiLr4SzvCouK2YjI?=
 =?us-ascii?Q?kYTQjUh2Cves+bvFKtlx4a/EsH0mHPYY4wVOctMCY+wZzVqnHFWlC1LEvzA+?=
 =?us-ascii?Q?EIkTugP40kbwLoEq0frWGHH1MxQhzOHJBxmiGjSBr2boSEeCfHLjc1U7nwLu?=
 =?us-ascii?Q?XGWMB005Ts8YFSDsdVl7WuaqEBMIJ+ZMRqSRL+ahez1ubKJUDIY8bmw94Hox?=
 =?us-ascii?Q?thYIRh7feh+k4FpKHIxW52COc6jwGYFaMyw6Oz/STOn58llgVYuEu2jJdgmQ?=
 =?us-ascii?Q?/9MDsgQB1tx9vJHajY97KW4DRfRJLXt40vuXxXHlQgAYxRpb7vWZaGvzpcCC?=
 =?us-ascii?Q?Q8/c4iFgOTdLiLv01wB4vhDUc4wq0Qv3i2xkJfHrb4sRh99C22OjK+JksDSA?=
 =?us-ascii?Q?d+Yl2ubEeI+g9zAWtAg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb0e96e-90b0-4988-ef58-08dbd2520c12
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2023 16:23:23.6035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MudfszNY2nLlgyLvQVQJFhu3bhvDeutPPCNMfTtYPN71X2wSw7/3SyeM1ZiNzVYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7232
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 11:27:46PM +0100, Joao Martins wrote:
> Changes since v4[8]:
> * Rename HWPT_SET_DIRTY to HWPT_SET_DIRTY_TRACKING 
> * Rename IOMMU_CAP_DIRTY to IOMMU_CAP_DIRTY_TRACKING
> * Rename HWPT_GET_DIRTY_IOVA to HWPT_GET_DIRTY_BITMAP
> * Rename IOMMU_HWPT_ALLOC_ENFORCE_DIRTY to IOMMU_HWPT_ALLOC_DIRTY_TRACKING
>   including commit messages, code comments. Additionally change the
>   variable in drivers from enforce_dirty to dirty_tracking.
> * Reflect all the mass renaming in commit messages/structs/docs.
> * Fix the enums prefix to be IOMMU_HWPT like everyone else
> * UAPI docs fixes/spelling and minor consistency issues/adjustments
> * Change function exit style in __iommu_read_and_clear_dirty to return
>   right away instead of storing ret and returning at the end.
> * Check 0 page_size and replace find-first-bit + left-shift with a
>   simple divide in iommufd_check_iova_range()
> * Handle empty iommu domains when setting dirty tracking in intel-iommu;
>   Verified and amd-iommu was already the case.
> * Remove unnecessary extra check for PGTT type
> * Fix comment on function clearing the SLADE bit
> * Fix wrong check that validates domain_alloc_user()
>   accepted flags in amd-iommu driver
> * Skip IOTLB domain flush if no devices exist on the iommu domain,
> while setting dirty tracking in amd-iommu driver.
> * Collect Reviewed-by tags by Jason, Lu Baolu, Brett, Kevin, Alex

I put this toward linux-next, let's see if we need a v6 next week with
any remaining items.

Thanks,
Jason
