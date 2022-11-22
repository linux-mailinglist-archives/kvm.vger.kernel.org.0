Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F44633247
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 02:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiKVBlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 20:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiKVBlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 20:41:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D97CE2218;
        Mon, 21 Nov 2022 17:41:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANfyWAGi5mJlDHmcj5HMcXkycC672y7SrPTiwG0oLqRNfwxu32xuDl2ak6R8UKXXYZhJUW4K7zWoa14Wa7LusJvPvYqmEykGexl1gdtmNecHNE7hgvFnuKetBaGtJxIEwOVz11d7Pv7RiR/j/f1lB2hrTh5hBV8274FS9KUdU1RBSmeAphoCMEeHTwkl0PEJ9W51JGR2Uksi2sXh2kFyvc44r71/0OiQUDifDsVujvMOhWb9RHcNv5TX8Hbf+baozdEX5hmOD6SC6qB4V2x8xkvopYITZnBXehE2/mESQ/VgSXhPo2aBjCPQ0Lj6h90LJTGMtrSYkrCL7c4ThTaIpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wANtQZ8QXfrJjwWQfd/uIzPHSS+6n+kcWeSAxC0i7bQ=;
 b=amLaG2jQHNg5W9qr2EC0xSmCn+PYIZVHKPS5Ht0LzAe3tU386zN7UvSfOFMfRrKau0NEcR603eYMg98IAk7rqihbIYfVz2f7Doqx9SJtSplPf6dMAFFjcAfh5fNLpDBdPiJjoKGpG5IlF8avRKUBC6tfRUHR4+2wSKWXOLR1Gt6fN+LSmEJlvLuXOzXRJdkxsM0+8jKLTa+4z/fe8L5Yv6oxCyVIdsxOq8+FLubrtq0Jr/UzYLS9ESGpfFugBc5JsklHLKJbFVIrgFUuxxqnqtscJ201Abemd2V9uQXtLodz0WBUakvRtK9xWq2y5AUvcMULCcZJfCYwJPMOkK24Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wANtQZ8QXfrJjwWQfd/uIzPHSS+6n+kcWeSAxC0i7bQ=;
 b=cVj2tW3lBTfFU7CW7U7bIXGPJHWtEi/11bHfMEMcY3OcpRu9PBpuiqM+sQWXZLw86PqLLkj2fTNFWYxO9v2UQvBwdWwGzUwr7EgnCT+oXnRLAV7cIBvkBvg69bfPOsERa5X7XeukA12CDCCu3/PMdOoXdzbKwhRdUZo9gE47aCLNguKkJgNI/MLeSEK/WONJXs8AR2pRVTIimX0Q6aBfWlFkpNgRP1vykWXSPI8oVULGoE3PrCIW6qY6umVoyNXXkczDAPghXMbcoESCvYUZCfoOIzz44mAwGKGMre4fStoFTe02jUjhxeCCZPGZU7+R9cH/iwvUjlMWmNfsjYT42A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5260.namprd12.prod.outlook.com (2603:10b6:408:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 01:41:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 01:41:07 +0000
Date:   Mon, 21 Nov 2022 21:41:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 05/16] vfio/ccw: replace copy_from_iova with
 vfio_dma_rw
Message-ID: <Y3wosiTNk8ZB+56G@nvidia.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121214056.1187700-6-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0329.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5260:EE_
X-MS-Office365-Filtering-Correlation-Id: 5070244e-f14b-469b-7808-08dacc2aa05f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0G7SUmsCPYm5KqpIykj1SvOE11OalHBWmXOnhjFKhxyFWBagGQ8Bj5VGJa7lJak6v+Usn8frEEWSnZYjSWHf46Zkiww50qlJ/FSXy2SBrl7mwVCOXr1QS2M2Y/KKhpawny3AiALMz8OA/VhSTzNfWI3fcNOs+LEkLYcSXjCR7aCHkKU7JQBFQSNXtCzm9gghEvcO4W8BQGfdI0XnBqOtJtLWhbwqAspZ8AInJx5t1bSe3k7j9wfXFfxEQO0pyP7S1DJ69HQAjanUHzB4Jxxtg2bfc8ZKpiUrRqe0Rmsxg76y2hQC5CVtquOp8zlU7f4JPuXqdpgwRsXB61opqd/721J5LQPLnG5AaffsSD2fKXGwxAxLMk5ZmMVew85JxGvC7xwpktMJ2Kyw7e1L8hoZkpBO2wVkZOZ43ZNTmBo76A418PY3hGxKHVbdpd4YUA76tG+zQouRfRxxSmgFHRGJfHJ0mvpKDcAo1POev7/FdsuqzWgXmE4y6+Lr3+2TYVQID7R+tc6F831hkQzq/3RpZEi+GRVSxtZzqqK43iNjmz1FMPtbgL7G4GXcp3XziCh6EDTEGh8zkS7yA/rallrIZvVN4g5h2gYRuIM3kKsaonLdPby7RL30KFsfatjejH9zAKfU+0Jthfr+CMoNmyuLDnR8b0k369+0O6oZBD5m1AWgMIUNvPYKwTxL1ji+c/CkdObnCsxzMVu8zfFDqjD7d/VgG7irb+G75lyfC2hPyljZnr0pEChNaGRuwYWWkMWBxSouOTMVj8HyF1zxbt1Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199015)(86362001)(36756003)(186003)(4326008)(2616005)(66946007)(8676002)(8936002)(66556008)(41300700001)(7416002)(5660300002)(316002)(66476007)(966005)(4744005)(6506007)(6512007)(26005)(478600001)(54906003)(6486002)(6916009)(38100700002)(83380400001)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8jjRXJ4UUe7SfHYtjYuP813JWBU0/7y0YsJx5Oq/puTf3Q2uTVW8c8AUmxVy?=
 =?us-ascii?Q?7a7ZMiF/TMxyJqy2lvn6356vA753XExTPsUgwPcLJXDWCyT3kSvDdQrdMdle?=
 =?us-ascii?Q?Ep+5YnjrB1a6NCboFFHmSUcVxoJidLgaMPud7iH7Mw+qN6zMX2dGLipE5zvh?=
 =?us-ascii?Q?DYhG9w9xv2CdoMMBpd9qzISj/qVgPhTI0dGpmWnMp+gOQgyGEIrXKng2qXpl?=
 =?us-ascii?Q?AU7uQILXTGFV4X7mogbbkj9P4dEwj/Mxl6cqNE1wepT0uxEXcc/LJtkYqfHT?=
 =?us-ascii?Q?vvj9EadtiD/GTxGdZCJItzFzD9fldU+LU4+Rgg/ZfRTuCY1tVGtyvn/Cq5XX?=
 =?us-ascii?Q?HNjuiTvDIpkNNzJ1j4yuAhdsvIVrgS5d9GeYCpFZfYkrVQM8P2Pn45LOdaCj?=
 =?us-ascii?Q?aJY0SRQFg4aCdbBdx7V+qI1wyANU6dNAz9n3BxwJwQK3fOHnzmtf1/qvMnYT?=
 =?us-ascii?Q?W2CZGbNSKIsGrCrKHGDmG5cqQnrPWkbnnD8Oc7HH81AL5Z8cx1hXLEifF59R?=
 =?us-ascii?Q?JmcXqlszVVek9RxTBASVHvQQcXhXHQU5BrUWyqa/V8MdgnWcoB6yQg8Sk0Pi?=
 =?us-ascii?Q?YUmYYa70j9+BWWiq2OABsqJY/tRs6N8EPTJJQ3peD1Wf37g5a/NixuHKNHrw?=
 =?us-ascii?Q?kbY39EX/FfLGZ47VdpoDq/ZWn/ZpFFjR1eO4KuzbHx9RLxt9R/9X5iG7ZGh8?=
 =?us-ascii?Q?O64YCecd//VLsHn+xBUeuHeSZ6df5qU0huSX9tPQBcWjmISlo8Rgya5qa7el?=
 =?us-ascii?Q?zoxyG90l0lS6sValUlBdzITLa8eZlIT8qeij+MZqaaJK+Y9fSP1KaKKAf1Jy?=
 =?us-ascii?Q?0XM3jkQppparG1lWalcOWitq34s2gDHrWTIQeh7jonwTL2qRwmRA5nj+w8fR?=
 =?us-ascii?Q?O2yu2ev5gJI8N9dbR4u9kCMSng10sLYAXIQr+SUIDnbccii27BaX2XYH/O3l?=
 =?us-ascii?Q?aJYBSIARHpsP6WUoGamcRUc7PZFgzt6HrDua5XpFoPnBunazUS3S2JE5DNxk?=
 =?us-ascii?Q?HGMcAPYHmkyPfCH3IsQQ5YUi5ufhzZBEjAF902s0AVtuDEpe6Bde9AtNGLFo?=
 =?us-ascii?Q?3/smh+IU+Anv5+m0Jc1lGX48dDOYeDsYvHSCYwsb6Z/HI2W/1PAKbgopniZc?=
 =?us-ascii?Q?GeXmD/yD34/lhI757SQXxf0VpaUxs42o0J2EJ749PDa/7GxyKl7yM401GPMd?=
 =?us-ascii?Q?ZlVhFSXZ39sk5LeC0Aza5ySnt9ZS/sANexKK6bVZQWQfhVFdrumbJYb6Iaxl?=
 =?us-ascii?Q?1nLuXOsRTGcvsyh24LRb5GmyRi++KcM2Dtl6HWlH1OYpVHnddhhi7esLmfuZ?=
 =?us-ascii?Q?ngaV3liZob01MFQARoTYgRzRLQh+8WvCmx5C4R+HwYdU44t6w00rflibI8h9?=
 =?us-ascii?Q?ha5/HVY34RWyrnqC4JWvwHQUicHt47MQ3QlSaCitZceFhUTI0HxVIQwn39i6?=
 =?us-ascii?Q?KxKBLXypyKwJsOIY/Dg1raZw9M9dhWBNwgAoZ4u+rnrXCMbq8Uc6V3/N8MSq?=
 =?us-ascii?Q?q6m7a2QhM/grdU95/P3hY0eZLtju9p//1gu3Er9uawe5ln033pmBwfGFkavB?=
 =?us-ascii?Q?XDFSrcFLTMkBWqzZUes=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5070244e-f14b-469b-7808-08dacc2aa05f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 01:41:07.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yGXYXR5BP1iVJk+qABNB7PUvNSwf0mNRcfWGoyfvuBiesiL0i4L+j/7Khv4jqiH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5260
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 10:40:45PM +0100, Eric Farman wrote:
> It was suggested [1] that we replace the old copy_from_iova() routine
> (which pins a page, does a memcpy, and unpins the page) with the
> newer vfio_dma_rw() interface.
> 
> This has a modest improvement in the overall time spent through the
> fsm_io_request() path, and simplifies some of the code to boot.
> 
> [1] https://lore.kernel.org/r/20220706170553.GK693670@nvidia.com/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 56 +++-------------------------------
>  1 file changed, 5 insertions(+), 51 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
