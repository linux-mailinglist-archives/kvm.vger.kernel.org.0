Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A575F7AE
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjGXNBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 09:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjGXNAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 09:00:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974EF5251;
        Mon, 24 Jul 2023 05:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwHEAiopmsMurIY96HolgFovVJlvkbGrv1hqWXIUoyPT6kkjHF1NetwqroJ00HEI0X4NVqBYHL4/jQNI5DhxEygFr9wrb1qAmYcjh8YVhtGodIzOQBP4IEx2UMPVtVaVUxKPp5YIdl2VtpG4B4Q8A1C1PY5oxxTBDNzSp+Vc/yVTLAU1ulL55/kAxbGROjcwlc3HGmLOx8oWtePhdrYg7+dn5b3Jxxf4xLb4CVVrMfx9utQqVnB1bvr8vY02jxPEpKAmh3MuynY5wrxJYbo4h3/XAJeASHmclJHuiVlQnCeuqkmq5DWgAmnRdla8XjQ4BwsPgiVFpJiU3I73471InA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NivB9USOaJnht1rWZigAt+gxvf9g/XVQAX6Le4PNO2k=;
 b=mdmeCrvrSV/lpj08pIh9nX47P0/dmds65kjs/ARRpzKl9U0DdC37nqBXOW6LZbbQdDLfq2764jFkG9hLrn4GbfdDXoOMPZR9QY8VJ6SjsynmTvI1pWGfJ561fn1b15ZJ4C+R6OEzLE3OEbTBOMxlxV8XL/dvsHFNbzPp2+usLVVoMG4cjcB5v4beAZcSTGBYVhNuoIfTZ7ZodGq2dZrXS58VPPEV7qfFNxFmsps1g2VhnTauAxAvSBJpPXRyjnXJYoXCKdpnrVyofydKIAANybfiwKW6KsQ+A9QTsqGh40IojGr1re3vl64e4ddJyfgWybcIRBnyIVft2NmAmsNFcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NivB9USOaJnht1rWZigAt+gxvf9g/XVQAX6Le4PNO2k=;
 b=Ni9ha0lRw5we4Si9YV41A2TFr2ZLInyV8suWY2rbOD9C9w9g3bb/nA4uCUbSko9kNbiaP2wwcztydhGpK+9kdAV/HZ5T3A80Trm2SkdN3rcGVixlZJ/Z0bd3wATKZ7UJ5snMnV1d4j9dV79JjhuAuNMFJQKvqjzTw5HsRFfKfTkSjC51m0q/eRJ49cSm3DfyvQCKNYu/JhIfO+axVvSM4FHMuit8jFW/VKqhlVXHKhabLxmGmDKA1I1FcAhijsWTyn/A1T/kD2RlCarIY9OU0+SN3tKeX1fgXV+iiBdVxqfLaJQtNZFIk+gCoUSzSgy2Z05B0WfZCmlv1Rj8f0OrdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8582.namprd12.prod.outlook.com (2603:10b6:610:163::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 12:58:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 12:58:04 +0000
Date:   Mon, 24 Jul 2023 09:58:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZL51Wl3lTD/7U1i/@nvidia.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
 <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <259c5f0d-24bf-dfd4-a1c5-102944aecd4f@amd.com>
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8582:EE_
X-MS-Office365-Filtering-Correlation-Id: 06053f0f-4d1e-4b6b-8b3d-08db8c459e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdeX17lsr6ilx0uOvHN8Tj2d2zItNq6gpzvYMkZaHtqrj/9SSu4gRPKxraaaoJZYwMSh4Qf1xDBn0rEAq1OFikjyA9dHASmD/3/HRORvq1u/jTsVJqyCdAgskBhDxrWC3SPs+3TFCE2FKq8aQJ/ar+K1fvZB9z7tIIOKPUQfNM+cu8evU7/lgGRodq1QInX2yRBvNDlh9oB3Q81coHetMSK3Ma/KU+l2EmLm3CyhjZlTKUebHTWbT3o7Sy0eELj+cNvQ+c3inxQZxT+aXD9PymVzh87DfpFDr75IvtslBx4prwDd4oOYoFE4hkxvLbdWkST7lrd63pbvQbymNNdSrz3c1jRTUHIbvCCrDNs6DyBdUuDoCyh3MwyldSVXqtE+AQhzOu+LXUCf72aEpzud1tLoXkZbGtZ4OFBTeSQVK5K/bPhz5c52GDaR67Q6ri+fY0UouRdO0Tv7Oauu5o/f4gFuTaH6H7gQJ+TgQbKFaCWktQ954H+V9iTvPhjTob3QXeosGsXp3tVGDC4PMDk2CAs0+Nq+diyJQcOmiVHmfLeyYHai8Df1PMl3R+buL9W5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199021)(38100700002)(36756003)(2616005)(8676002)(8936002)(5660300002)(478600001)(54906003)(66556008)(316002)(6916009)(4326008)(66946007)(41300700001)(26005)(186003)(6506007)(6486002)(6512007)(66476007)(4744005)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNiqcPEkplxSjisTkNQGcWAxiwHg0BzDo9fm9D6Yc9fbUz2e9x4u5b2B83zf?=
 =?us-ascii?Q?/G9N4KRtkFg7+NyKrZfKhj0rwLctLBisKiN03thJM02+Y/VgZt3q+G+c6+QW?=
 =?us-ascii?Q?JZ7BAq60DbMSVRmxTnPK26E3NgsCYnPUeiklIyqRXby6qIMa2RdYfbIF/5a5?=
 =?us-ascii?Q?fpJFjq8HiKJNDFrCyn34OMqRsYL3kUgUoPSgfK8jIpZ4h4dWDe4rpwJHQfGG?=
 =?us-ascii?Q?rjBY58pP1nwxUjYfWxFY+B+OK29d3R7oHNyc94S0lgB6DHhgdnAIRqJVozNP?=
 =?us-ascii?Q?+6Cg0mFEH1zIp7iqboGMf7o5sOojHdHvNUsRPp/RtrBRV3rqOlQRwu22JHWL?=
 =?us-ascii?Q?D5VzuXK5FAl3h7baS6jotN34oLNojlQbXo4hUl+mGSFSUd7Hp55ab6oslNHN?=
 =?us-ascii?Q?W0NCXfFuLPbuo+IsDgI67RaupTRmjaF7nKIWmDQ6gVOSKM62Kqz92p72CgaS?=
 =?us-ascii?Q?vjGoQK4cTNDNVlqihme2JJEcffl2855M+Aqp7fiSJRnYPrMc87DdF+H5qQMj?=
 =?us-ascii?Q?mkytft0BKVxe4DAPuxbp4c5SXiLl2OOQylJkXtdN0wHnQ+WIc2fb8AFZlTnQ?=
 =?us-ascii?Q?TjbTJ6mN0ixaUK1ErgrxihZFZsRPguS2t8c5iqZbWVVKdNGCZNwwCL5H5fmo?=
 =?us-ascii?Q?Tyfdn2MP3v006fggGAZGJoSrWDepzli7riwHjjfKtRM+0CIkEIT0RyyLM8yP?=
 =?us-ascii?Q?3grOK8T+XpdLohfXUZljtS8udSgVDWoY89v0DveLGuEn6+crjTzHm+vq/ohw?=
 =?us-ascii?Q?yDVKzAYD5iSw2vDMZfzjLqYQ3XXDnW3JV7rU4fLNnTKZp5FC92cEZIVidTs3?=
 =?us-ascii?Q?3/cUSt/2tt/tDGlkcFZzbhtwMVjUmIRmeLzI6DoCtaPezU40+tGXniXjRHsU?=
 =?us-ascii?Q?XSzs2IGKRazB917tA3tvDsvCBHViBQb4udu+/YpWlsbUdssX7QTs18aHUitW?=
 =?us-ascii?Q?uMDmYcGEJbFWoKZ4skR2n+uChLL1Z4LQGAUJrWju+X1vcp9gWkw2QECYkSDu?=
 =?us-ascii?Q?aamX1BPApix9HBYFJbJFw+I3keYpCkTYmQJE2nsdvlwoCJos68TUvXhwugHi?=
 =?us-ascii?Q?r62Mr5DQEmE7IogC9tucRN2VQIqHqKhdeGWzKb/eMiTH8S0JyPnDfh41iqKy?=
 =?us-ascii?Q?LqeXANRP2/KOsSJooF2zg31mYux/LcAYtrEQFmpQVIYoaK4ooWre+qG1c8i9?=
 =?us-ascii?Q?FRw3zwb7Yge0/VaPYAalJN6DkLQzYzr4uYkqZLd6HQG/afoaQbtFoPbh+iXq?=
 =?us-ascii?Q?6nrXCc1lXZrXOMl6kOAiWQtH2C6QmJQbFjeNo2/h8N5E5KvZljCzxWmoITy7?=
 =?us-ascii?Q?QDmQwTNouJ/6imAPNsr/63cTy1xp5O8KNOtZzLiQHPIQczoeipZ/QYot8Ctl?=
 =?us-ascii?Q?CZXXY5Lpe0O8Qo1h/N+ox/mTsDIlyYLcRMiUNm+MaaZvkfU0T45+nKrPhjxA?=
 =?us-ascii?Q?KE0X/FBBmaOlA6TPUUpb+cOTZQ4ndcIKXutmHhu5Lwin1r3HSRr5h5eQf2kx?=
 =?us-ascii?Q?bJsMggLvloqGvBd/aJgFxyq8J3lhIerRrK7iezl/W/IVXnKTTvmi5GjPYZnB?=
 =?us-ascii?Q?QEfOY35MZRpIh9lQREM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06053f0f-4d1e-4b6b-8b3d-08db8c459e42
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 12:58:04.0737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayFlmY9ff6LIP1cZRMjGO0ifG/DXHEndNk3Jd3CO50oXczPLabf51kfpd1LzIN2B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8582
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 12:17:34AM -0700, Brett Creeley wrote:
> > I wonder whether the logic about migration file can be generalized.
> > It's not very maintainable to have every migration driver implementing
> > their own code for similar functions.
> > 
> > Did I overlook any device specific setup required here?
> 
> There isn't device specific setup, but the other drivers were different
> enough that it wasn't a straight forward task. I think it might be possible
> to refactor the drivers to some common functionality here, but IMO this
> seems like a task that can be further explored once this series is merged.

You keep saying that but, things seem to be getting worse. There are
alot of migration drivers being posted right now with alot of copy and
paste from mlx5.

Jason
