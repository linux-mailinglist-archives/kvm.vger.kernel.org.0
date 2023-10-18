Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932317CEB28
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjJRW0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjJRW0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:26:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E878113
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:26:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ih/oybiz9m9j8gct/BYinPn5ESHX9MFhdtvXubooDk+iVNEBlB3Igg7WQ3yfhlyrJGeop85ZdBggJGDC82EZ8k+Kj3RqdEpc/OpzcjS9PXwbGN91/ag3S0IVuJ1sEtNRJk1eYEt0B2JzcsK/fdUeH5lr19jnobAvbeICoOo5yeksqe+vp8qwDcLrun4B9pxia9/UY/RVubQxidmT3aDp5Hueyvvuqua05ifWg7POhUj1ABgriTuQhu74zzaX3/uyFSGsWIpNFtiJMd1ygftFaPbJ0pZWzQL3mIn3dTb1IbOL+PyQh7fVZblBauw4NWtqTcolbFYOIp3+PqrqMOgquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKRpdjWKnFfkYeGqteI0Ywq4g5S8bIHz97B9o6Mefm0=;
 b=RGsYgy70wweX2s6DHnBgHs3JPE15CWXiEziMG9WvQ2ivtMZaWlbakkewqsdPovAxSun0YmS2RH10G8fUtrKjJ5Qms0rDisZHhZ/x3eem6gCL4wO1in0ATH5IlAHG7NCcTmsEng1J9dyERU+TJG7JjUu4NCPvr+5jtfiyLEPwj1+UXoJk9di6fB44yqlO3lgUl42eeMnEl1rJlEWLv+B6cMqaXJSIFttMYuWLaULRlb5+v6WzDhi4q3P+FGnDKuECcUgSUVlaMwC+7K6mU8WnC/KJuX1ILTcaNezwSU25TeRQA/VypBPvspB3bQ3bdir4TDgF/CzF4W8q+SscSBy30w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKRpdjWKnFfkYeGqteI0Ywq4g5S8bIHz97B9o6Mefm0=;
 b=X7SwtcL3f0UO9Hhzab7oKnhFEB8/R3k/iYaOkBotWZquegxsfbn3DSnKysKHYYaH7PnUzkEKCmXGKxZ2aXIH7a9resd+cTWPNhr6FGLTB36EYIzzujwPwcptkZU26OcnFrlggsBrNg/0sM9tzXC+nsFeRYeQtg6orZjDR3Y387CsZLud+ry+CTR8mDsNPVU0rsZY34JPLCoryy4N7urrxnuaLoJbwPd16DZ7g6Zr6Felm/o+qiK/H5n9834nJxg+eD6/PW+wnwoHII/eyM6wfgh/eG9MU/Aiz2MKhxWsK2NLs4N/rEHc7NzXrgviwuwArcsLLH158GO2n4gSJU4kCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 22:26:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:26:41 +0000
Date:   Wed, 18 Oct 2023 19:26:38 -0300
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
Subject: Re: [PATCH v4 04/18] iommu: Add iommu_domain ops for dirty tracking
Message-ID: <20231018222638.GJ3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-5-joao.m.martins@oracle.com>
X-ClientProxiedBy: SJ0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: bdbb2e66-b499-46fb-3763-08dbd0294d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+/WLZb/IMD5xyeIc2Bp6uAjwN12FLIumbFuIBoXBieoGvYs2RSKdUoUUksSbT+AurYBSvS+5GhpFE+LDVmpL4o/D1fimUpz892FK8m3TMOF7ahKckBfUtalBzvmLPJrqeRAGTg3u9R+JJpzvdTJjmFFCNTv62YB/FIcG8ThpWft1lXyUiUyyKMs+6QYNo7+EBJq7lyee7DPWYaE2d21ZTXshDsn8s6S1NIcKppvR8b/IvChsPleDAfis8eyEuiOrwm1lYhik0eeg3Sqd42FhFfRNe7kDTURo5fyxUNMoPL0WW+3et8FnsiJkWjuthKjz+/gmK0pGMJsdPDZbSpIc3Phpz2IPUE6/jYLJKz6Om37T3qu19TD7Nz6pDuLdWYDheEaxWjynBrwHDpwDk+Ckx4yB7lJSkhrAbKU4U1bvLIidudFyOk6fQ9+6a7uSXEFtiEgFRtvbK9y4wd4pEXTiaD9oVnUMEmsXL2TiWT7wxzKGafA1yccvY+MSBl80mn+QYo+CrLwFxdngDA/Z5n3Qn3it4nbHtrKmJ/xmqXVEZW5dICi5wHM73x2BmHuDKz4psVUh/gxpbyOB5ZGW0WTw0uVeSArUTrvZUzG2Av+DlU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(39860400002)(376002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(26005)(6666004)(4326008)(6506007)(83380400001)(8936002)(2616005)(8676002)(5660300002)(41300700001)(7416002)(2906002)(478600001)(6486002)(6916009)(54906003)(66476007)(316002)(66556008)(38100700002)(86362001)(66946007)(36756003)(33656002)(6512007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kkZBSUkrCJtFFqFKgQjq7FX8O2xVem+SzOz6G4Z9HXa1wB5hyBy2VcgCxhv?=
 =?us-ascii?Q?6rcsCg+u8vZv4BzkgbddJOhx2U3rEbes1BUzRrjq8FOLDp7+qBBsCD7qYFQj?=
 =?us-ascii?Q?cbku2iRpgCwEXu6+t3wOPNXF6+JVjOWxIr82QQ3mEKhU+sa3H5KG1c5mgFMm?=
 =?us-ascii?Q?1jF3HUejWP+psqkmKNLeI7CJW/8eELgTpBbXRFDUJY0F3E1Lci/YhVPStQiM?=
 =?us-ascii?Q?vhgZz4iXba+k3GaR9z3tguCsOqax8YEp/SEpzivyHV7/FfBsBrIg/9aHVEN8?=
 =?us-ascii?Q?KFGp+vtedVBiqzMNyyrYA21EjGZ0WbUEyyIyxL0kH38q/G/7HxIuIve4SCYo?=
 =?us-ascii?Q?WS9K+CRJSi5BwSHue8fx8Rozhn4+SrHHbvwkLJkpQYD3ykSvfnoUQ+usNVud?=
 =?us-ascii?Q?L3W25RqcitO/3VA5twF3iaIb337e7h+KVWbtTFgVB7G1mRqWTauJ89Wyteae?=
 =?us-ascii?Q?2tApSj4JtRqGHqGeVc4H/AkKmTwPJ8PY7R2PBNJZdQ7qViyAv7xvVKvfN1Tw?=
 =?us-ascii?Q?BrBi5/9oz4MVGd9Mv3kfMiKg77KvjxSvwvd8jkWaDr72UVCMq/Ig69f3faGP?=
 =?us-ascii?Q?ykVyQm/SAFG/0+g1uVoQWYcwo2MReLRZjsFWStWgGYz8f2xYyj5MaRziWiEr?=
 =?us-ascii?Q?GYoEeNreccbBVQS4Y5z3+LmcHFKB7q7SzFfEfIeO0CspCsvw4OjgO5XWQ9iQ?=
 =?us-ascii?Q?KAFDoKHsNcIrYQi6LhQ/JN5uBB42CHSWPngI9o2ZPuU7TPKc581JHLUiEgfw?=
 =?us-ascii?Q?5IzsXi+L1knDpVbGJc7hiAmCyCU+bBJ3yrXXgLMSM+jSdUPPB/HMbm5HXU2y?=
 =?us-ascii?Q?oh0mQJf9mtb+XuAJrl5H50ur320wrGPVazwTb3YHvvxFRc6mSkCifikJb4RV?=
 =?us-ascii?Q?mPxIxD36oetv/gVdB3eTXKPEsvc1TO+/QTpEZq+Fa7P6grJ9jOQNScUBvLt3?=
 =?us-ascii?Q?uKeHaiYv6xFTNKyoNaWqbEVvDbH+fz2Bt+Z5em9siXMhDiWXcLtuF0ML/I9J?=
 =?us-ascii?Q?b/pzODtrhUnMoj+C8ARbAGB86jsyrCZj+9yZCJhT6uHm3bfVKLP7FZb8m9lI?=
 =?us-ascii?Q?x+fpG2773z00VUtRJhEtMQcc5gtcU52mIJnx0P9zZztq/A0z3yUBomQqxzRM?=
 =?us-ascii?Q?eKT5xB9rMhUewsQ1z7Uy/GMWOH3wkhI0SHD2Vgf4mncTbqFRRma+Ha6fBlk7?=
 =?us-ascii?Q?lO+WpEYndKPmgfBXumzvu3JjKYOHf2p+hVCjI2qOWAis0QfLuZMH18lF7V7A?=
 =?us-ascii?Q?UHzANmPpsDwnR5AtIeuUMccxluCrTrHpICDXYN6hOpBYzJfv+BhBKViPlmg6?=
 =?us-ascii?Q?3GiaEgNtKW+eRTO4mgVItwUVNIwNzcwJx1dbWf2lzzvEqY6SHRnXuxaDIt6q?=
 =?us-ascii?Q?wovmzQS5HmnWY8JuZF3buug0ABEWi5Di10BHJ+EVTUk+rjt7AKOxl8gXi7bM?=
 =?us-ascii?Q?M7sQ5JIZOIrK6kJnZ0bLqRGkZQTjOKyQlZoz2A1E4AW6k6E5Tpqv9w8HSnYk?=
 =?us-ascii?Q?P+xmwl0WIMAiWCcLtMyYTl35RRn+/LYwvsxbbn/Aaw6FMohyXtHGmxQBsWG0?=
 =?us-ascii?Q?sjUjUqcKo92s1NOwOQyyAlKQC0tI/CQ1M51uyaS5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbb2e66-b499-46fb-3763-08dbd0294d1b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:26:40.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tePHsUlqQTlshb9Gp8BprDkz/dx7aNjbvKfklrmibyu72n9AReDcylkPkdsPrV5m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:01PM +0100, Joao Martins wrote:
> Add to iommu domain operations a set of callbacks to perform dirty
> tracking, particulary to start and stop tracking and to read and clear the
> dirty data.
> 
> Drivers are generally expected to dynamically change its translation
> structures to toggle the tracking and flush some form of control state
> structure that stands in the IOVA translation path. Though it's not
> mandatory, as drivers can also enable dirty tracking at boot, and just
> clear the dirty bits before setting dirty tracking. For each of the newly
> added IOMMU core APIs:
> 
> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
> capabilities of the device.
> 
> .set_dirty_tracking(): an iommu driver is expected to change its
> translation structures and enable dirty tracking for the devices in the
> iommu_domain. For drivers making dirty tracking always-enabled, it should
> just return 0.
> 
> .read_and_clear_dirty(): an iommu driver is expected to walk the pagetables
> for the iova range passed in and use iommu_dirty_bitmap_record() to record
> dirty info per IOVA. When detecting that a given IOVA is dirty it should
> also clear its dirty state from the PTE, *unless* the flag
> IOMMU_DIRTY_NO_CLEAR is passed in -- flushing is steered from the caller of
> the domain_op via iotlb_gather. The iommu core APIs use the same data
> structure in use for dirty tracking for VFIO device dirty (struct
> iova_bitmap) abstracted by iommu_dirty_bitmap_record() helper function.
> 
> domain::dirty_ops: IOMMU domains will store the dirty ops depending on
> whether the iommu device supports dirty tracking or not. iommu drivers can
> then use this field to figure if the dirty tracking is supported+enforced
> on attach. The enforcement is enable via domain_alloc_user() which is done
> via IOMMUFD hwpt flag introduced later.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  include/linux/io-pgtable.h |  4 +++
>  include/linux/iommu.h      | 56 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
