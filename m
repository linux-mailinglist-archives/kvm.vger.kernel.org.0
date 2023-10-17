Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9AA7CC77F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbjJQPbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbjJQPbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:31:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5B89F
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdILN7j7S9+DaFgwkNqEjjRAaMABOsshzEhLUS+LFZAGHzYwMGGHs/kjYoNO9M+VWz+PO4d2fIRTkBKMaV0JBu+GWdU+meVfbyVs7kmi6e6K1HgeOUC76SdEdyw9+W196Zjkb+LGeTHFOlYEjTYOi4biZczYBOHmrHx4TyXJ6rg7EtefGXeaThfpytWXQvJtyFrpNtnO5PZk6AY2EbFJDLyn52sjA8uuURSP+4CO/UZFEZbVYl25rizTa0hE85Wa4HgN2ohSBplzRSCN/mgW+4sMQHgYNq92qpE9CQA/4Ur+cRVGI7CqsXnLSAPWVcWc9L5iE7ohvpUqh8rWKfFf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/zGI7KqooqhEX+dNx1mSby65ApO3/rAqQb0xo8XcB8=;
 b=dzf01QgYA6/KirzMjcffFVC5M5Zn5h+y1Ebd5VqkGBFty9y0VCQZmjARJU9yGJhbQI+oPen3GCeQMrv4lbGAgSm+l9dPWO66uBRSxNjly9SJbxYeYwiv0NnjqGukNkRg4Km1GmlOt5WrR47GCpR4gACSTTKI+ncEKRPDHu740ZxHS+Vr5KmcqS59X7SuLSXI5cjRZYNX3PemcROj6gMufMTkKDQDAE+1clfTVNGubmR7VaXdpvYy0QZ7chwzpHYUqpWqRx620Oz81Up+x3ig7+jdA4RP0zwxW/f0wYS/69yBBHBBumQBnWhuRDIbFLW5ukRDWhHyrikikBtYquYh7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/zGI7KqooqhEX+dNx1mSby65ApO3/rAqQb0xo8XcB8=;
 b=fD+lqmkA0GHJCXr1oxz8xPaIBKewltKj9DJqn+RstnlhOHrOOXOtYyg8ldD/pfOZENlenvHeIkto0lIFlHXAR96/sKXesG3RVU0lnxXmb2p4Tp4NLu9nYxE/b/+x9hrw76oRb3ey/rSdZJZ0kVc8nT4v29SCkrudD5n83dhrI3Ujs/7cN8J7wLwlDbdUpYs9dX9bkYEPAoRV10HmWEjF3VqXzYWs4rr34+7czywfMxYsLqoAEIPyZP7pGnRPMPoxaGyv8EH87eRBJIJ/EZbDyu/WMrlv6zwKe3lgpT56cMeU7vEHR//f19tsIPZAybHSYr8dI1joR7tvYAGLEvG1Gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8876.namprd12.prod.outlook.com (2603:10b6:a03:539::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 15:31:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 15:31:31 +0000
Date:   Tue, 17 Oct 2023 12:31:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Message-ID: <20231017153130.GE3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
 <20231017131003.GZ3952@nvidia.com>
 <832449ab-1704-43a0-828c-5b6eba2b84af@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <832449ab-1704-43a0-828c-5b6eba2b84af@oracle.com>
X-ClientProxiedBy: MN2PR19CA0058.namprd19.prod.outlook.com
 (2603:10b6:208:19b::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8876:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a36be80-f3c5-4d20-2ae4-08dbcf262399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOEO2Dvn46irHd03iLB04lDsJQEsT38P2FspdbM+miKq7yKPO9OZMLoCaYwJ7SXN4Tqa0Yl3l8PnX5AJyqslL89Qtf9baCjrLskZ3XAD0H6P7221uKpx2l2rGHl5mbcSrYryLhm2/5Wi2oSuehhqXj0QwcrIQnf+4zL6/XkoM+hUbuG7GGMh4IgaJVbhgbx3ek8z0OgDAXWTqX1rt7WximdgdfOxa08/CyMmyvP+F/F+o5deT36m4SsGxL5CKJSSNE14uzkoRxCq95kF+y5xhRb7soRg21D7e0CLhN0pKusaHNp96tD1whRwLO3fmHRHM4/7+w0U0zckgLjsZ/qrxr4v4e4S9ZQqnh9C6j1MzLneIMIqPz9BZDk5aGv0BDUFkBPPufyOF2hnmIeaCzwVu71mFTaYFbAUSAAepq3n0EeGaQ8/yJAcKDw9qTminZwGkAkyXT50oDPW9NvH+mh6wqkXWy7NYTuUAGdUYCsL2dTLH/YV4SqPvdEj4QAO4b0/b3kL+5LfSiIjI9dAf+DnV7PmFsnxi3z7mC9405Bc4x4Ab2YCWs2TEqvtzasw82493j5gNoJ4ZdEDtwiSuCmk3S/CiDGFU2mE36HMaAtwNik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(53546011)(83380400001)(66556008)(26005)(1076003)(8676002)(5660300002)(4326008)(8936002)(2616005)(36756003)(86362001)(41300700001)(66899024)(2906002)(6486002)(66946007)(66476007)(316002)(7416002)(54906003)(6916009)(6506007)(6512007)(478600001)(33656002)(38100700002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YBkB128QZLx/D4lXI0+b8hiKDsqn4i77fnjW3KcgLII53Rw9LHZoEBUPJ0Fy?=
 =?us-ascii?Q?EnkS3RU/SLgatXDZetktK96z5Dt8KVjr7PhZ/vx3wwHceX1dZeUMm65HoOFQ?=
 =?us-ascii?Q?WVC943nYt++kNMXi7dCmqYRLXG588SRcH8KeKI93CyKixrlrvvhfhomMTBLE?=
 =?us-ascii?Q?oG4AFk7lS6uoiEBcZKZ98ciS8Fsbb2VGgZRjhXzVA8dIwxAs3Iwg5TAkbHIf?=
 =?us-ascii?Q?/jSYAZKkvzd7ZpASIt4AX4ol/WqQIdAZLdm4/vlqCWGM+lopBtx96LW2ZUp3?=
 =?us-ascii?Q?RJt6aIbWYnH7RxyDtIOVDmIWgF4KTNAtUOAWfHSIXcrQWoQZ9DKcfCUIZ3+p?=
 =?us-ascii?Q?SU1XDKDj/hW/PYaGBWZA5f+yIIWRijBt6HWeoM0az0sYm8AqYqh8p/70gfVy?=
 =?us-ascii?Q?cKvc9VniBfo9ZpbasaBz5D3N9droPraz78sQbGOJ76dzmN4ATsd6kxQoG5xc?=
 =?us-ascii?Q?WPtSzw+MG5DiYUr93GA0AswH9We3cL5CB6W0vUW3GgtwxXvuy7d6weeyJead?=
 =?us-ascii?Q?j4AlmICZYefSUX5qtemSVgDYVChM90ls6b826WE6AIoi2lx6w6tPBhUqNpC5?=
 =?us-ascii?Q?0iAtWSaTNe9ec7Du+GVeLeoSZFOV9IPFk54mkhwL4LeAMmHlbKdKEo1+HDIp?=
 =?us-ascii?Q?tN/PkCBnvP6+dmYOHOkH2UAWcSBWwS03Q2T/KVVHv2dW4MZqbGWjWXmXarS6?=
 =?us-ascii?Q?F1PMqPaxePhC39U8s5KNoostDuP8noh7onU1ugXmqQ5oUJ4EHGt0XSmd6BxL?=
 =?us-ascii?Q?+l+LbtQWXWrayi9JESsEMMYEHosQdDuqSdG9d6V6aaV3AoDGC5Xt1GVAOUC7?=
 =?us-ascii?Q?iuHhfXkFazcNqxkTDuamTj5tNEkWq7jF9oKZyMWm0Rj0bOJW9D0K/BVICglw?=
 =?us-ascii?Q?8V36z3mWRQwSNhYJ52ZQxm8XNn8f/r5O5a+yVCd1lbw90Ar9AOMFmUiFyTx6?=
 =?us-ascii?Q?OYwN30CEc2AC1j2T4Dnf8dBMRCaakUnLzXadXmNtz5P0barbmgna4E1yOCrw?=
 =?us-ascii?Q?R9yNJ/JgBllOwYXoK5p2SQfYl5gQJpRrR4yb2AFxfYxh0kFip6nG/+P/CEs5?=
 =?us-ascii?Q?cr4zN48hxOeb33udx7m3YqGw3k5RM83a5igQnp5zIb/RYYOM/XhvnMXzYEs6?=
 =?us-ascii?Q?+9cEOg2nddoI10YW5OYNpy0g4SYZOo6JW3NsFEm1qZ3rQI/lG/ccQBOkh4eI?=
 =?us-ascii?Q?xnr4d4HQFGumEloYd0UXLwoo+QoC74bMLOyi+7KZQUptvwqScoZHUdiCLcuo?=
 =?us-ascii?Q?Jmi6XxzP7RTtJhtFHDHg4bD45UwTFSk2+cLR+hLnSPubsWA9EYNmEAfFEsIS?=
 =?us-ascii?Q?vtNnTkPQy7/aw9oEHUigwsVAwgwg+PsrC4t9lgCwBYC7bLdtAtZe803YJVM0?=
 =?us-ascii?Q?0+NWYbXajW8XDUH+xe7bdPSceF/Ra5zT4WQDr6VvsnDv5fYuzv+CauO20R3G?=
 =?us-ascii?Q?zbHJboVK86GU3aPMyboa9mRBY6jVBN4ODcRQwy8nznzksRJT+PqE2vNcd9bi?=
 =?us-ascii?Q?0eRkVTWheQjHpzzXhIP8IQSVW+nOuktrMrexmmVSNzZXWynKxJLV56PeTVZT?=
 =?us-ascii?Q?K3SYx1+W7anzpT6GYaenpYV0rGtW14CbMVWOAX0j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a36be80-f3c5-4d20-2ae4-08dbcf262399
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:31:31.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Io0JSmbyMaLq5dX8/KpknhZDdXxant3HGyBl0xdhy+pPqgweVNWvNOp1TZQjfbs6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 03:11:46PM +0100, Joao Martins wrote:
> On 17/10/2023 14:10, Jason Gunthorpe wrote:
> > On Tue, Oct 17, 2023 at 12:22:34PM +0100, Joao Martins wrote:
> >> On 17/10/2023 03:08, Baolu Lu wrote:
> >>> On 10/17/23 12:00 AM, Joao Martins wrote:
> >>>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
> >>>>>> need to understand it and check its member anyway.
> >>>>>>
> >>>>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
> >>>>> already makes those checks in case there's no iova_bitmap to set bits to.
> >>>>>
> >>>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
> >>>> essentially not record anything in the iova bitmap and just clear the dirty bits
> >>>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
> >>>> internally only when starting dirty tracking, and thus to ensure that we cleanup
> >>>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
> >>>> opposed to inheriting dirties from the past.
> >>>
> >>> It's okay since it serves a functional purpose. Can you please add some
> >>> comments around the code to explain the rationale.
> >>>
> >>
> >> I added this comment below:
> >>
> >> +       /*
> >> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
> >> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> >> +        * have occured when we stopped dirty tracking. This ensures that we
> >> +        * never inherit dirtied bits from a previous cycle.
> >> +        */
> >>
> >> Also fixed an issue where I could theoretically clear the bit with
> >> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
> >> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:
> > 
> > How does all this work, does this leak into the uapi? 
> 
> UAPI is only ever expected to collect/clear dirty bits while dirty tracking is
> enabled. And it requires valid bitmaps before it gets to the IOMMU driver.
> 
> The above where I pass no dirty::bitmap (but with an iotlb_gather) is internal
> usage only. Open to alternatives if this is prone to audit errors e.g. 1) via
> the iommu_dirty_bitmap structure, where I add one field which if true then
> iommufd core is able to call into iommu driver on a "clear IOPTE" manner or 2)
> via the ::flags ... the thing is that ::flags values is UAPI, so it feels weird
> to use these flags for internal purposes.

I think NULL to mean clear but not record is OK, it doesn't matter too
much but ideally this would be sort of hidden in the iova APIs..

Jason
