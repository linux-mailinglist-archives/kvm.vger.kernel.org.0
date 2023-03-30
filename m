Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281816D137E
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjC3Xow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjC3Xoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:44:46 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E52111149;
        Thu, 30 Mar 2023 16:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cY5aJ+Y9q2zrYVNOwEDFWFY1ZkhIMSWXjoMqE8j4DiOjtUI2ZuPs32UJwuqdF3wg7SmKK8Y+Paph/JfLnemnsVnkdd4gHF5D3tPV0fYVtFRVt1PasU+kbrk8MiGTIATMQV4WmTKDtm7r6kvgvGm7Z+EycQ0wTxRAk1h4yBLVwADo0hMaKhYPeUZ/zJjq5/WgdEY2Eg13eKzOh+mOkpJIFIqrmZA6ulb7eVtphAZrFJOmwRBJ6Rrj7Lvwfov+e03g1IjoS2tKvF5REAexOVGru/5EgHYcv1kL0c2fpjlS2BiauwkZDU6vAHORNDmZV6g407teYiUI5rzwzO4hXtCU4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkjlRSFKX4ZyAH+8rSaSjf+tejwSaZJ7YTy4VB5DNP4=;
 b=WHQq0hAkV6bdgli4Z+I8aRGShtXPosYwsSWwq9teb30JW/uOswU1iHyM+RzioYaM1swn2HfDXUT+CnHFyW6vSq5WC5HqFlAnJbxZ5HoWHUfVBFkivN4cgOWdVloBhTpvrxiwS/6QXEOi9Lp88HU9H4id2BDUEJ9vrcnX585wixMMv4zn+gbEgoE2nrGuwr5RRfyBAokil+OSQKm/S2gk13lwVSpIjTUox7aaYznAYjk/iKt/LQzt28TVtJWflBVMMwLdhsgDfxxV+YGaIUWwcZQ2KEweKlhMVLsLw9q+XnAsh+HPlQo6Ycp2Q0EuxOswyk6YNcM1rIoXUWwXPqEDEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkjlRSFKX4ZyAH+8rSaSjf+tejwSaZJ7YTy4VB5DNP4=;
 b=pLrMTnkRJRYplmzTpWHSJ5/jNOBp+DdYc6Nm6kDXKqPa0+Aqh5nl+yCgLARPPvYPRl1AbCkwecTeUihBi7osEwOuxO9Qk563bU9nuYyvyVRB4xcWEeFo2JDjKvphEgO1eVF+b98jAztfYcJ+OptUGTWoG8Td9wFvx1Z5vammcQWL+GxyHkrh74/DGGqY6DylYDFaS+spURTfWcJdZuL5JORciuNhwj352q3wJAkKEs5vm5m85m97q9+V8Cy3i818uqUC/qWhMHSsp4rdSUr6BVw3z6pG5taVKH4pH8UftY7MfLHLNmMrnzTiOXvtvRxWf6gUifjN9MakSn6TH2f1cA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7822.namprd12.prod.outlook.com (2603:10b6:a03:4ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:44:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:44:40 +0000
Date:   Thu, 30 Mar 2023 20:44:39 -0300
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
Subject: Re: [PATCH v2 03/10] vfio/pci: Move the existing hot reset logic to
 be a helper
Message-ID: <ZCYe5/7iob1FupRg@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:208:256::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ba3757-a177-41f2-c970-08db3178bae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpdDw/mafHuIFbLTF51GDXu80LivtPrXKzkea3hzheQurOrUKN2g6giWo12jYnrzTkhYMO3vcubbny4MxCkH7OVDhTEzILqhwCqe1JcCn6wcJUXNGWSOSWTmdRbgpNvr1iaRNfPI3BZr5GxeHnHdOFh7Pw9ZdVqNucu/vqWfDT/y+aAIxas9eGqicPQgeEResDL0E9kiX5dVmNr6UAc1dECOtvZ0+/rz3IMllDWrokWBv31zO6rkeJo0otLxK68OO0nJ5lKV0ulqKtscAakWuE4yd4At519KphhKxn/1d9A7bBFjR+QWiKhZ7J+QGY2wjeqNgCqIb2wWPctYEEWIDt+Gz9ZDZ602m9SwG2gW0PcqKpHFcRxbTUuwMc9eO/0efjUDruflrrp1r5IZ36blN7gIlJ0SDdRiwOnaD1njGlKfwf+frpT4jAWVLNuFI+TtsAU2DgTrYAoWuFAauNSixlxMpQ4FwcK/+UyC85ltm2YMGu6E+zpG4mRxbKQHSM7qGpSSSqDffxCU6ZClZy4Z+9TVqxz4iFaLI9jfFirn07E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(6486002)(186003)(478600001)(66946007)(83380400001)(66476007)(316002)(8676002)(4326008)(66556008)(6916009)(26005)(2616005)(6512007)(6506007)(7416002)(41300700001)(4744005)(5660300002)(2906002)(38100700002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lGz6Z5qHoBc80fdV8/sFsX7uUbAL5XWAWkbEKJYrC6kfUavjYOyuGvvK5yN8?=
 =?us-ascii?Q?NXDnw1yXyqQjcudol+K3+g2N7y5/O+fMpGjslAwVFs4YfaC8INkIOSMqBmzM?=
 =?us-ascii?Q?N+G0LTA82nPUr0FAfHrHAgr2ME6471KEPi26XWwJCzTHYe7qGAb2LcLfdL8e?=
 =?us-ascii?Q?qbj2/XPOe9dQBO07SACGikUKGlk7SqhAWMTMuy1Cq6Fz/XGSToxRCn0ymgdM?=
 =?us-ascii?Q?YvHd+/jwmnurGN/jRxmZgTjnoFSYRlIjTlecnTVS1aQyQ0w91Wjk418T6bha?=
 =?us-ascii?Q?qPhsmjhTrMeDtctMiSGlTSeNi0iFoV83mOFuv64XDkQCyFDL7e/sHRLTaHhp?=
 =?us-ascii?Q?i/FHaBcLfygFt/YeNFnVk1JxqwggPqIGMKRuBQzqcE/OBwSxVPXVXVhu14Wq?=
 =?us-ascii?Q?N07tza4sfxjzNfrQdyKoXn+aT2sw5tQhX2yTfGCIijVOxQb28rLMD3XshNuP?=
 =?us-ascii?Q?Lr1rc8ZTBtBjj2+GQEZNFogQy5Q1T0a5kt3XKzo0j//JWCJg3AgQlKV/G6Mm?=
 =?us-ascii?Q?94C98FF3/jPS3klhfH6uoZRTpfGCLO7fxduIVnDBt/rPVEjU4/EXyr+rt8Jt?=
 =?us-ascii?Q?hTOzAaGAKYjmEDV6hFeOKkWkIwMhzHNbEux9JQmp9Y1aPxcslzlmM61SP2lV?=
 =?us-ascii?Q?hQHweERwzZBfgyUIJnPh8RmcSyPL5KYHcWpu/m6q2KkjbIBrJcE33orWkrNs?=
 =?us-ascii?Q?XBRYw8VLhtxHIlGhK23be78M/XVunrG+EKVZYZw13CtulHG+Jnxe74gbtgQz?=
 =?us-ascii?Q?3JfexnnZrFvISufDmHdkoGJAjdvp89VjJWAR6rEJ3gZEcUeH9cK7fS2AWq9I?=
 =?us-ascii?Q?wbv10/K4RUvMI8bjEVJrBwqfIGWEqJ8jB6XTGlqFaYfsIVVRnuaqN262Sngn?=
 =?us-ascii?Q?+g9Tsr6xgSE/E52oBrXz07F4gwNWRWTfhsO9CAlPeAfpS8hDT8aCLKXwk64M?=
 =?us-ascii?Q?rqADV17qcYoULc7XAWpXaS8jKKeRVwxCfhVP/oZcTOMLsreREnurh6EzmMJk?=
 =?us-ascii?Q?BhuKTBqujJ+vJoIVnKyAWTAHCmkEzvrzcgFMD3p/sjB2849bsV55ZqrljN4g?=
 =?us-ascii?Q?6reJIA14rHQbrvd0t+h1MtQia5WjIG8pgG6jEWnSIBIMpZkFDM4aCkVWLyZy?=
 =?us-ascii?Q?SgxNgniijXBXhcc7ZuwMV5xzETLW+reSsVaeDbkNlz9i2vUBQ4mXltfkZvEl?=
 =?us-ascii?Q?PePlbMSS7B21+jy1E/0QxB1QMBoXSO8xsgrxBaZ9wv4ZWhwuJnoALcQY9BXj?=
 =?us-ascii?Q?aiaLmAo1qo3zdPS4Dcc+QsvkrAPYllP4D34oBN9ctrkCqyGeBPPEEdRa1Qtr?=
 =?us-ascii?Q?2+zDxepUkB/3YG35DTaC8UPyZQJESTYPiN9IOq7eQ4zKP0r1SJlQjpr8AxUV?=
 =?us-ascii?Q?eJ4ctDHyBGZFNJ7TXhSuidj5oygkAm5J7KwN4rmvUug8YbVX+lQwOs6gpodG?=
 =?us-ascii?Q?fic+sT3xRHFgClQwl38UI66z/BmUvWcIlF05EDels8CE81sJsyiXqmvlmEsC?=
 =?us-ascii?Q?hVj8P2O3MEEi5bY1kzeYhKgqfxOUurDGfrzYz75CDFtjOj7C+R/TUGZ3m5j4?=
 =?us-ascii?Q?1rE+m9xd7vFUfxVzRHMLpDcjtR1N39wytG14dpNM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ba3757-a177-41f2-c970-08db3178bae6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:44:40.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOTAnpzg71gNMKkXkNuwuIay9RV031TsvMGvF5klElwjl2mTsImjPxztmU9UjKob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7822
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:51AM -0700, Yi Liu wrote:
> This prepares to add another method for hot reset. The major hot reset logic
> are moved to vfio_pci_ioctl_pci_hot_reset_groups().
> 
> No functional change is intended.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++-------------
>  1 file changed, 33 insertions(+), 23 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
