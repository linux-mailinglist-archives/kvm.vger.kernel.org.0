Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6FB72EA94
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 20:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjFMSJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjFMSJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 14:09:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68E819A7;
        Tue, 13 Jun 2023 11:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9yUfc47+odFy0jLwaqutKqB1ZtxBlzeEEirIE/nLvgho4I4MVVmCqokFQWx2GSw0OgZV5Nq8068DEIXZ0QivW6GJdh4kl0GEo9zAS/mPywSYUHSo+C/pJkqh2NxUPMySKeI2jC3q5lpzSnXn59XNoheXQVglGurHu+zx8wwa3bnRnLgcKtLGDN+ZcpxhPyPLrt1JUfxdbF9Uvh3exLuH3/bgdsiCwkoypG0xoWuC1KCeFGE5jegSpx9BX6dPX7OGYFg34hPTwRjMGvW5k45qxl/lgiqCLDHqyYdKqLpHPrMWtJjGG1p73hrupROEwfvuKgZlxMGWNIqmDWGGzawZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te+jFXPBW5BYObPxkKN53gyKqKMkkqrerXnYiYj0wgk=;
 b=EZ/u7XQqHw4dtWP57S1gdnZk4lLw4WTrRGJimjyCIASypDht5fRFG0l9Vyym2n8JdTyJDifMX5nGpTzzPOo1+KfYHZgQSW4czR6sf4q/2b3mFvZ0ti9qmk07NkXvaD0Tn+QgTRN2i4s5lMkDKUpB/ki1K911Skn7tYtH/HSK9KOUQWPHJKkWumaZmBIB45cMe7naAQBKs4ouaBptHbVLhj6fo30ZY1atiObUJj2GkabfEz9VScYpZTC2m7vJlL1mGM7NrHQyi4K0814D2e0Nv+TmQo3YTLyEdM0HUDFgfLBoVCHQLS4kveghv8ht62njNjEPOwAsrxeCtx/coPX1IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te+jFXPBW5BYObPxkKN53gyKqKMkkqrerXnYiYj0wgk=;
 b=sY/eYtFOsny2Ik7gPyc9a1ZqmHNlyrfj1CI4/zweMJ4s82UlJgZrTQh2mvQp0PDZVYsg7ctFl9b5VdZDPgeBi5cpGojrTcbPmOOObnfCp2bOHwYMfTUFjxG5jJaKXG8I9NMXBcLFbSylS/gAUCTMtbenIwknzXiG3pPiqZRyNKbQju8vvXwiErekA3tC347RG7nDDrk2CHbUDpuMS4FurBrwGsdfBfqHG35gvi8AMJfnho2Qw+zNtf5rJmPDJD8gCTkGytL1N1okHTx/gWjrzq9fv/BmdROEQBxXo4jT9az5cfDM3pQd2pXs9rDJ0pGg3OvnpuBH1oKUkTqVdIf1vQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 18:09:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 18:09:26 +0000
Date:   Tue, 13 Jun 2023 15:09:22 -0300
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
Subject: Re: [PATCH v7 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZIiw0ssaPBpL7hEf@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-10-yi.l.liu@intel.com>
X-ClientProxiedBy: BYAPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:a03:114::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dbb76d6-161c-4e1e-90db-08db6c3952db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqkFcCOQOH4ulnwY0OoTUaK9EnS0FuIT0S4z+yo9dvwSKUkh+adsvSPeyb2tTHjhqyQ3expZsImjeDhpUsQ+K2/htO/u0tpA2yYQ9WuTJ6WPphhWQMxZ4p38OngYq6qTs11i16wB4yBrrainJANRixu96CHYV4Bgiib/agI5/xQj9MP9KIlywK3SoytHRLNIkDnJFsr1MiNxt0yorwny+o/HKmVu8s7cp5XOhq8auo1qycbBHFRkCPl3C1/8o2VmFxUDxICtXf+sBSkJnxa0iVD8srZ43jmsmI8Bgxkaw95vfakClqnlvaIzbLj+XYGlR+GwfAVWcTRwWgETDDWC3I4zSClsUxjlO1Gq7satGpRq+DNCyC7osBqu3B6gMr0rzb+SeOANzjXKc0fvaxkBHB5WWXgziNn5Zt5fTQmoQN2dR2fv9z0UDSJDoX5wVkazqvJWcJVeQaWxc0jjXa2NTCcK5p73/8VQR68x+JzuGrd9eQ4P4KDqZZws0EhbGc6xbZlRxFzmJbuVpqqd7CR4QnwzHE2IrO80HhDbZjhYzrwdwT18KBN6H4Skkdi7/kEv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199021)(7416002)(316002)(66556008)(4326008)(6916009)(66476007)(41300700001)(186003)(478600001)(2906002)(4744005)(66946007)(8676002)(8936002)(5660300002)(6666004)(6486002)(6512007)(6506007)(26005)(83380400001)(36756003)(86362001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZ0Egnjty8Oyt3UPcG80gdCZlDVlbuO9jf1aPQkYbYCDqkkHVnB8nfa5X/SO?=
 =?us-ascii?Q?4y/40tBq7PBoCWaYDkOh2fz7Up1Y7oKiOhbg6EvwB7eS7vUmnzc4Qd3bY1B0?=
 =?us-ascii?Q?sUjvYTysgFmGqpnGmSW0C5cSLRtcOkPfqX7lxOzg0PAvZ5xS3gFj5AV6lFTF?=
 =?us-ascii?Q?HsuTAIzlY6RmzVgljUyHMCQELzSxY9tsUVVCHO74pJT3YVCdsMrmgdK5VHTi?=
 =?us-ascii?Q?o+IzMIrHOoatoASLqOcAsTmjDdyi7LZyEOTwn473H8vizgbMCnCsTty9YOEX?=
 =?us-ascii?Q?Mv++Dln9EdC/NywHVttIV3/WIXI5lj5HXZhym0b21DmBKEf9BErOkBlaJI0n?=
 =?us-ascii?Q?YOtRDFAnHgJN+iIFbD3M8gRAtWRSfKS7bSQzgDNemXQMDlW+hn8518I+TSB2?=
 =?us-ascii?Q?8u9fZMCSoMUdOf2u8tIv/q17I9dbO+zNocReSjzuSRCIJ0XtPqNKUMUz91r/?=
 =?us-ascii?Q?0Tv1EBTc3yfF3VHAMt4rrtMTHtpOQ3ztu5rHvG6yyyytIIkbHS4Nd2eZ+Qx+?=
 =?us-ascii?Q?mVMaYyDDgxR4QeBXp0K9nZsnU+Q0rBCau/eNHvIO8SJMzbUf9pfOndW/yziC?=
 =?us-ascii?Q?WiOmEVDEgZ0G0JYBgaF1L5ab+Y/3OXillWSj/mBa88kJm10wRrklT9SeRDjj?=
 =?us-ascii?Q?KLTZj5ZHdnLhEdnCjDHBCifWmb7TAzxzwEAnJVQGk0lXHHVun4jv/qK4RiXg?=
 =?us-ascii?Q?l7hLO978br9RVj1bbmhM6WZHO6EHcth2keh+5cdml6l2CG8poT37jpEb6Kkq?=
 =?us-ascii?Q?VMEkZfmhmrncJ0f+/lfxHj7iy5fR+FmjgCccqUImmMCbehbwJPrNpjzY4gJ7?=
 =?us-ascii?Q?0SCHFO5UrNW7XvAOmBJ2qPr6cWWNnbMvIZWNlbNFgNSS8zZ2nEBY+s6QwAEx?=
 =?us-ascii?Q?f5nebt01WDtrSIctuBJWy80gi+a9LMYHZ7DDiSKk7AgdeBR7o1MbxY1E0mr2?=
 =?us-ascii?Q?7OvNc9zOcg/KtH7vAstI/6frl4UCWmdActyKsK37Sb4nva+PB+tiAyP02ZbK?=
 =?us-ascii?Q?hf7AYLMpTARaEZDco1vFt/3C+YJctbKpXB595QTDoFnAFY4st2+yK/rAnuMi?=
 =?us-ascii?Q?LMdnaXDaeNjmPj4TnPQRAgxu4xG/HA9s+rDrmmds3Cvea/UiQSQabvnQWZwj?=
 =?us-ascii?Q?OKbwGmYqI9SjgpCrhhR+PD+N2TggfBCjTVZ+hOqzXbE0qnKvpbdCEftKoQzS?=
 =?us-ascii?Q?4vPXaTaZRiP8NDaa15mnNC5L3hOVQfh7nHnGHbykZZpYSxoJdQ0deDJ96Oud?=
 =?us-ascii?Q?F14VD04oGWz8mFMDzZelYIqolwnah4l1AwceSdsd4Y/U30VGwWpKGIgClHYY?=
 =?us-ascii?Q?YyedMYnBD1eVsJDN4i8SS7O458L36C3YMXJzkSPvFjD2ObhbdYyg98eHx27P?=
 =?us-ascii?Q?uKiwsQIuofOpzuEoBLD2vJjtI6iuUQqBFY3rF90k/Ub4uP2jZhvChaS7CBEI?=
 =?us-ascii?Q?KKX8YjQ7KiCVupfGlnkN2F35YEfLtYs70DBJG6Toeda9Zo4Gz3NM+mafumAq?=
 =?us-ascii?Q?OFL47CV9GOh2KwB6YSuojZFAfZ9PSnlzT7MVVdQ7rAI8MNrQJzttduXiFxVA?=
 =?us-ascii?Q?baBDxgH1J8DZnavM+liY4+DWVYlNokr5/hA/1Hqa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbb76d6-161c-4e1e-90db-08db6c3952db
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 18:09:26.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhvbCUxdZcbQqcH2ZCUrsUVG+mR2DWLUsbs/UVJXgC9ocvU4CxXRmoKGw0x9BWyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626
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

On Fri, Jun 02, 2023 at 05:15:15AM -0700, Yi Liu wrote:
> This is the way user to invoke hot-reset for the devices opened by cdev
> interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
> in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> hot-reset for cdev devices.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 61 ++++++++++++++++++++++++++------
>  include/uapi/linux/vfio.h        | 14 ++++++++
>  2 files changed, 64 insertions(+), 11 deletions(-)

This looks OK but it should be in the cdev series..

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
