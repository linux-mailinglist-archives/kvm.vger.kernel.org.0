Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769E466C367
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 16:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjAPPQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 10:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjAPPQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 10:16:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFB925E15;
        Mon, 16 Jan 2023 07:03:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbeSfbJc+bvuMkQYrPcwI2XJy3aTPD/5UPM6uCpy6NXCkZaKhYWgwllTBG1u6fm/nuh5YUSVSxuh9j7GNiEqZhADTHtxg6A0Cge08XG2+opztJDDchx3JY3Trt2yEqZ7ROboVD3lQP0vw+Zh63sfVpqx5hbQrBi6i3sdw71+gxD4zrpAamVefR/mmPoxMfAbz4cuRiFhg/ZFKYWCR4xv0gbXAjAQ5rZdLmijxZohgSVuGp4myW+J/2Pu1vaY7qLSu+LJx+4nvJfQjNl9YmECY3fDWCu84cCuJFoRmc3vWhkRv9BaR1j2mDe6o8pDUKFfEDhXYpi9fnk/shg1yV3OBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imNkGh9XdshFb14s0ae1rasFa98cXLoebQv2I2rlLCU=;
 b=LhmMAyLprMZvplFjFrSLKRVY+RtHsd/SpAHuUlBIYkOPx/dJMNtd6jL1URVWe2lqbXxGjDfccsO9B2M3BBlwaH2QIwqRiAfptN2nKsm3B+jjTyfLj0nbbarLdXxQ0iKB2/jl3EhcjXG77I73RKysgG3QN9S3ERuvsiGP+rWogapnvDkmlb3UdqLZRWsnXHxP04XadgzIBhLp/5jsdhYv2jBRgr3r5HV3WUNzR6FeSjM5i342GzDMkKlrceNOZ9lBBYQEtNAknWmomlMtM5vr7M17ldv/S7B/M+NNkuYmyAXh1lTuNRNtbUcLJy4ZXHON4mTXMBqnUfIDxnRx82iC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imNkGh9XdshFb14s0ae1rasFa98cXLoebQv2I2rlLCU=;
 b=mnEUkAxrKnmKTHuXAq9g7HvULoTBcrh/gtHqkCgLbd/btMQrGbdHiyeXG/d1vC2PLr/9B+dRnJBs0zPYjaCKcNJ+LW90nhFMCLDfS6pfImvkFcxT0GsgD68yG1UFhlnmYwNMK7IHcV9FQmDZQfETu7K1kqHiQoNwKk4inSYErVHgQ9tXdM9Bwz5yDX1BO5g+7ZIE0x44s5Kc7hX9Z0vsFTzdRe5sal7RLX7tGTJZaqQBssTGpj5qjwlKdTdhqY/tIOwU6vq0vORvmw2jasUXY56cUELKyMdH3RGiNTuRec02mHl8jtRET+S8kxexvPDP0zaVLU9s96AoKQeX5AiHCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Mon, 16 Jan
 2023 15:03:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 15:03:44 +0000
Date:   Mon, 16 Jan 2023 11:03:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Message-ID: <Y8VnTu2cNfoYmbv4@nvidia.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114000351.115444-1-mjrosato@linux.ibm.com>
X-ClientProxiedBy: MN2PR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:208:178::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd8a3d6-e982-4974-6cfd-08daf7d2dc49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LR050yawXwhPC/xUquXcizFW0ewaGS/4qx3i6QVVm3eL2+FI4nt2bBY5rsoZzPTao/9lOhwIbGBJ5zXouDUTD8AlyE3+5pIJKnedgJgjboiv1km3av9r2ryDR4DtG/pxU7sXrgC6pUTocuaowtggrIjIQjT48UbJ05IJrHnOSEemknY6+efAQcvQ66TFKk4clOSIWPK3glVJQFgmxpc6nCzxwNjn0s7HPYI2qms9FTeikxXGiiSmymlwrWtksGE6V3oub7eba5Jr4Jfk6YtRD2/Cpi/RIz6ENXPOFg7E9eOej3UV6kZj1zEpUVEiY9v3DAyUBsjmRoZcqyC1NKLPqcjBoDIsbKTNSgLMid9rz3ZyrVjFR1Y7rHmvSqHNHihNsDXbBH7LMeh5sqxTbLIaHk955JAKEvo30X7GoTzcBczzAgWeUdO8h2gnUdzy+BCidNKWHUO6X17cy2LUFDjviYqjhXY6zcvch+vZEEUdBBM3E9JdTkomLAfAdsDZcY1Dov2CMXQgfSUCMmKkI9oe4YH76+kqCxpWFRrUWmVl3IomqUV5lL1lAs8JjzJZe/pY/oJ1JHskykXaYa5S8cSgqpRL4hI4Hloi8PLbs6G7Tqcm1Or/FTzXZp1CFZhAv6aM68UbrRz467PFq4HyWqUnOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(4326008)(36756003)(6916009)(41300700001)(316002)(66556008)(66946007)(66476007)(86362001)(83380400001)(38100700002)(478600001)(6486002)(8676002)(6512007)(6506007)(2616005)(26005)(186003)(2906002)(4744005)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IWkBziMeN8byZG1pSF7lPuTyu767LEnzc0/jjSMcC2dvis76mWL3/BmKdRl4?=
 =?us-ascii?Q?2cYIYgdT9sCvuvvDeMW6eSyMV47QLjn0ftFb2hJiugGINtIlFGdhUbPRHh1N?=
 =?us-ascii?Q?8v3kdII+V8UJymlHsmvgl/qhGcxDuVthEAKS2FTyns2HeuEo256dyLcujjYM?=
 =?us-ascii?Q?WRxvbYQyLlG2XYEoCQs4rC1OV18dL2Yd/ay0lVgcqX6RVv81KGeEEM3um8i+?=
 =?us-ascii?Q?7B2DKFCWZop4nFHY8iXa+XctUyKFEp1PKYtDwYJNa8QqyoCEXAHPXL3AqYkn?=
 =?us-ascii?Q?H2sFGJ/hTbIBdsiaTKqFcQX/12SeVP95eIXbMmNm7qoyrDUQNsLG07rAKc5/?=
 =?us-ascii?Q?+xrMPesokzlZbWsdXV79/GKxeEEySM3JQUryIsv46UY6ILTzdtcXRJ1KKXTX?=
 =?us-ascii?Q?Uq1bHuUKNZ47GCUu1FPYmuci0634hIZKdzgeJ5uIiO/k//5J9HPESR46V1OM?=
 =?us-ascii?Q?YLMsJKdsL7aA8XhGB/V016g3fyMT9sxyMSl36q7nlTl5m8vIoKe6VMe5MsEh?=
 =?us-ascii?Q?aHIWhLORWgqvSuJgH+/nbZWxjihBi6z60DA5VZCxtzuuTf8XV0qC0vsJxQa3?=
 =?us-ascii?Q?hfZQXJZSvLCroeV/q4M5JMLEwkgoFYJ2y2E10cc4473mZTilnPsb4W3GDhRr?=
 =?us-ascii?Q?vd0+8h7vRMCVTj1pDswv2Q1xKEY6OmxTc/Lhgi/kk/n8sBQXdYXHmCFIWn6I?=
 =?us-ascii?Q?QHsi2QolezqlNPLYnKstxOy872/OBfmilITfgAfnL8Nyt5sUG9J3PYQYTYNF?=
 =?us-ascii?Q?YWRsa5pDVRl3lbRubSFra37QdZ9ppIZFazw0MJjb1PvjpYDhuBSM01AAlQWx?=
 =?us-ascii?Q?tURULoBJKn5sKB4D+Bn5p5dxFJYQJLckEeteR7nl7qOKShF2lrB0CoCSDDLr?=
 =?us-ascii?Q?GpOKPcjQ8JDnwhAjw2iA4DRnm3VOk/P0r8CTc0aJvTbhSb+wgmaYjuazn7y7?=
 =?us-ascii?Q?h5cu1lV3vMWvi251uQOvh7PGwHR9HUiaGHqhCVHLjgzVErvbsao9U8WOv4Hk?=
 =?us-ascii?Q?ls4UXTBVqfGSPDijJaKmS6HPkk/xX32O7osFOmHgFXfjIMQo9X0aJWtfksbX?=
 =?us-ascii?Q?KDQMYgje0TGHSsDXLEcepGs+PPw+iywtJ/Ks1vg4R5YJC+B3Ys3/nxZrolRg?=
 =?us-ascii?Q?/vLtDL2Hobmrn9F8Q9dHKZ1G0x3CL36sxltWMZU/Vb7oyvHBKZd0gLQVG8Vc?=
 =?us-ascii?Q?+vNfhvbWUhiBlpWuutAmfaKwuVd2gL0FnY9k0S+6taWNIqd7tcuoWEtJy4SI?=
 =?us-ascii?Q?iWOOZEsSxJcNE+yz5ibbBqe6/93KIE+9elacAC7X5bIzdTDVcRBMqkeGJWIA?=
 =?us-ascii?Q?VacZ11RXcjdw4vs4wIiL9Fd6l+25+h93utPdEx04cKsYbyNbbzAMcAs9psSl?=
 =?us-ascii?Q?pTYrD3zEUUsVY/kDcbE0711pxh0RA5x5PEg1v1jymKzivW14mIRVKh6gIDfC?=
 =?us-ascii?Q?LSKRDDgtosUZzTfS8CjAU54QM63nIXAg6BU0xvae+L0dD7szoDBoxhiBntsi?=
 =?us-ascii?Q?I1WNZ8lR3B+E6Nitpaf4BO+/YFRRiRH8eS3npGr69nO5S5b0U2R3jsEdNmes?=
 =?us-ascii?Q?lH0r3qrirn6DA3liULc+4NNGyM00/03mXIXE7geb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd8a3d6-e982-4974-6cfd-08daf7d2dc49
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 15:03:43.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ch14lyJN3wPHgumvuSAzxoXPv7FO9UT1ZqXIX9hCC3VuOpYQ1IPybnEsP06U3IRp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 07:03:51PM -0500, Matthew Rosato wrote:
> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
> 
> kvm_put_kvm
>  -> kvm_destroy_vm
>   -> kvm_destroy_devices
>    -> kvm_vfio_destroy
>     -> kvm_vfio_file_set_kvm
>      -> vfio_file_set_kvm
>       -> group->group_lock/group_rwsem
> 
> Avoid this scenario by having vfio core code acquire a KVM reference
> the first time a device is opened and hold that reference until right
> after the group lock is released after the last device is closed.
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
