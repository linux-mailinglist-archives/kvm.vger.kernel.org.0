Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4876A4A41
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjB0Srz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjB0Srx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:47:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E823AA2;
        Mon, 27 Feb 2023 10:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hU+hQMNv3aqLXIhoBYVqNrXvb4MkzYmoSzgv1DV+rSzUC6tUS6Qz1SBY1R1Tx9KJfjjnfNJNjelSIUhTde0zFGmudwpDQUzvnRtp1CefeCkDvPl7RKQGU4ZkYrnkXUHOH5tZNZ53lJTr285QZk91Dl6tycuhTcis8kUOrR/GKPpFuiSNVIDRipRSexeoNdy2oVJDf10UILyRv3jYtutOgOJQe9FB9h6/Q06kQ1vf/Kn0AiBo749xF1RSAIyvOduAloIgyQujMiFZ0kx2iGTHKnuK0fRS7e5lGzQvM5+iK1Mi2DvmpeRmC3cst3cGlg8NKo/xQ0C3oFtBHnJTqrRl6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxPjikfuS9pjI0AYTmIBhX7tST+h9PBfB1aWMqpDvRw=;
 b=S3OXd9GOkW5o5bym8ztcQdCstZA55+cYcA17BRmdFLoDDYl5xreUoCjel0HGVasHJDbrCK+XrlajXvg3AHhqkEOajTXPT/n015VzDNbl6TxVOl8S/qv6TrU0cr3b6JScfOqoXdjKbWm8fhkb3YEVe4tX8WumC04XLyKWDUidNXuAc6vOl1DeQfBsfkSxME1dPFdRikGG2wPdb4vZkJ9f0TizHUNif9lkNbabQX1cxKMw9Gr7LrmtPPlR62Z50sWPVYsM+w0XRiCZliJfv3n1VZdaoWI1KOCLu8DHDmbeMf3rt28o3WcOOI2esYzBBqBIrDe21pNg7c6ZA5MfZNyFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxPjikfuS9pjI0AYTmIBhX7tST+h9PBfB1aWMqpDvRw=;
 b=n3A6CEeoB/kXuEhRgqoyplmZAh93TdpAZcNqNR+zT3rjQ9IEPmrxAG52vttRO8R731Fwqxa7EBjziVrphXE6lTPvfluPslx4DChhixH73cxhfkZ/5iKn6xsXgsmpZGtGcwAd+LNB1LNJwRB/aorCK8vtjEIOB97nmS3DipYVRA4oX0gkJKJjKZldviCs+ZzFaGQfVLhU683bBhHS91stAETNvA+6JjQgzimKoG2VGUgoT2n8SAxciXoAzgkFZiVLtMIMnFrhOCYiidKL3DmQ0e1Qy+0HpzBdIvjnEjtSle8zKGrxu9+rEKmpskDOdsN9pQhZ58umDVhjP8kv2pYSSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 18:47:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:47:50 +0000
Date:   Mon, 27 Feb 2023 14:47:49 -0400
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 06/19] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Message-ID: <Y/z61fZRO3S0MtXe@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-7-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0080.namprd02.prod.outlook.com
 (2603:10b6:208:51::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: a8738b4f-8a9f-4488-3f7f-08db18f32089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyJH4rKhqEYkAcMuMc60DdwVFC5+BYJ+ijaBJY1gXS970l7syKrLlOy6JlxFeDJu0g4ulsbUIH/ZeRpuBtkwEEDhbVeZmoJqSOWKepXIuSjBXHIyGcOYz9zis1fyHVqF0S87z3Y2fWRBt3Qn5DSufllx6jIctWH3sgGm0wwAclt+cEM3vmJCTxU9b58wr4Jlqna4z9yv2cy+/br7vTpwX45gjjwl9iYoFGCKGmykXdtqdOk9IyGybzRFvs34Qw8f277iC8tfKqtDa2DM2T/gOLbckE/pak40S5DHESnKE0F+YdL7cTzfLIb0pOknRR3i0cUEqOVog6GtKZlN5bv7se4GPwucJvi1AnjW5shC6gKUzYJ9rzkORC44eZ+IR/XFzLolFtx14fwwLzfkA7FwJammDP6cRyjbeGEzmD7VZb1Nej9I+NrkrEszCTSw8kQHQWzKU/Y/P0s2Mg8hCL3PN2fo8vhIxgVQdU3OJNqYpvJIg//lMEqA9rHEOBphzqOu9oKQ5ldTOfoXv10dD/GUScDXXe61RFQbYDRkMR+7tro2sON0IaNE/sssfowyTQmrNNGYKkNNoIvnkoOUmIHjV5R4rXVA5TcfmStSEkzbTqRxQy4nCMbzFq9nzxO0uyF/l1RegNe+gYmZFT1bweDB7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199018)(4326008)(83380400001)(2616005)(38100700002)(8936002)(4744005)(7416002)(6512007)(41300700001)(2906002)(5660300002)(6506007)(26005)(186003)(316002)(86362001)(478600001)(6916009)(6486002)(8676002)(66946007)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L8G53zK0gOsSI9TshJKOJSjt6ICq2bCX0j2nUfRSddcJPYzagKikW60z/StR?=
 =?us-ascii?Q?eYMBfxfkvq+3AEdnDyH5tT09BS096lIMxz6p7rEl5PeIBbrt0NJwvNis57R8?=
 =?us-ascii?Q?eRBK0clzqSHl3mM99V90Ku3EfaTqrGt/367l5nW5SkiVb6J4YzgtjJbbnn1h?=
 =?us-ascii?Q?QSXopVrUquL/6fCkxnEoX2etxRCb/XJ8Wsy6WqFKGQ+4H+e0stdZI0mcIP7H?=
 =?us-ascii?Q?8c/+chKDpoi7zaus7/FZrl4lcZ1RZAV4/E+Mz2eZy7ZqvOIK5BvcKA7M6SM7?=
 =?us-ascii?Q?XH9+pgkul9DVjXbdrE7GKk/rvUwUJyzwLvuk9yz9nIfEKqnTd8QNM896eyZX?=
 =?us-ascii?Q?PQRqXHfoxcc8+inyBSnBSfQjJCIf3AOKaGjSVacxbX4Hrfz6pdIr4UXNOAsY?=
 =?us-ascii?Q?ZsgqW4lnVpEdS/5nDnkbF1dPjAX6BsQa0iizajxcQ5yXAgfz2jkxibSoR4vs?=
 =?us-ascii?Q?4AnuMTJ60f8uca59VLDWAsfg5gd19UN/Z+txn/SvK521882jbM3136HV+vIt?=
 =?us-ascii?Q?EV5OLvfT64brmwzT3T1FnJon1UExQaQVyolf01/J8uBl3ayaXRRcWNu5EZN8?=
 =?us-ascii?Q?RsrGPo8YIiv4nKvmVKCc/uc+PuhFErn+3cuIPh2ehLJ9PMk9BrC11CSSWFQu?=
 =?us-ascii?Q?hIjarNMr6HBVzxIlxB7bVFiHUyYIafGFTdjoYVCmF49P0AMCyv2bZmdLAMCg?=
 =?us-ascii?Q?Vf/3oLD0CGcFSlfyn6uzfR52z9jsi8VWUMUiAxvtTZWhJ2gSmyx3tKLnZr6h?=
 =?us-ascii?Q?hng9U0Mt/TCOjVZqsxh9H/2XEEItg/IIaQXGWjS+2Hmy/bIwmMh+otKh4BNA?=
 =?us-ascii?Q?PXIQjfM/k/eI5FcRObwp/5CkBk/weg2gKCZd6WynieY0eEljFKnwxWmNiRZs?=
 =?us-ascii?Q?tVJA/vMQKYhprwfFjFfOCAqE48Qpoxt48KjZVWUej7+ufO2l9cYMaKPSwIST?=
 =?us-ascii?Q?i2+cOfyS2pN8EzDToc5VATYhBxCkHLwd5VKApvxpjyme72U3JbMxR0zKu8QT?=
 =?us-ascii?Q?IfdORwiU14383uUoLQkbsJY8t0vv0kBhgH24DVmhwQxa/EvYeJ6g1llw5A7V?=
 =?us-ascii?Q?yhapJRRGBT441M8FFLDiY6M0XAJKwdLJJZtjDUwikocfTHCV+FuP+JjasgvD?=
 =?us-ascii?Q?Ax10lekVSbFId1BwstHdLKCQhdhL/pRF9OlhsX1wFpWFf/+0nlQjYKb2HpkH?=
 =?us-ascii?Q?bsIak1MoFgXui/btLLLclPbLWui1gIC3xfpb7KEIczRf/m8QiNglLF62og6H?=
 =?us-ascii?Q?czvepiECZO7gM166Jr9o/nZnoLXntmKFCPasVkWBBQ77Gpg0f+2BLdL/MY+0?=
 =?us-ascii?Q?yvIe4H+4EVingpggs3KvDL/mKTwBptXZc4F7m1nUFKWGX7lDjb6J+siroYSQ?=
 =?us-ascii?Q?HCT9BnYc16aZhFIb1VtZQmZq/sjZNpQbrauLp5LBViSrhZccGlJuNZCbJf9q?=
 =?us-ascii?Q?xNqN5J+ZJqOeJJxerRN/9zr04u93UaDSX95eP5cdGk5DDLbMcrbq7o152kHx?=
 =?us-ascii?Q?oNaO9nEGXbXjYopJHwf3AnbSSwDtcj6H5gT2cl4a+koVtscmZz/nWkHB8HgE?=
 =?us-ascii?Q?PAgu3ZalXjQ/DEmZPXF11TkR7Smb26V64CTS4fxj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8738b4f-8a9f-4488-3f7f-08db18f32089
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:47:50.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hT2V5k4CfbEE1/TxFor/zQR33NZO5sr4q79ADDfPKPoaOZqbCyzGrqa4nQeEiRrf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:22AM -0800, Yi Liu wrote:
> This avoids passing too much parameters in multiple functions.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/group.c     | 19 +++++++++++++------
>  drivers/vfio/vfio.h      |  8 ++++----
>  drivers/vfio/vfio_main.c | 25 +++++++++++++++----------
>  3 files changed, 32 insertions(+), 20 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
