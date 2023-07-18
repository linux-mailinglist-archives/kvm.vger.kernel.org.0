Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0066758291
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjGRQyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbjGRQyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:54:38 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B10199;
        Tue, 18 Jul 2023 09:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2Ebr1BOMQOixHlBXFN3rTU1GnwSNUPJDClQymAtjl4cl84Eczee/MKOSRI63nmywYXfnyFgWRlfAFig5w5qIUan25Iq68RdTtT37gz1Z2MwSDl8tp57IyiYjcMjX15ld6k4e11dlo4b65NYjTe1DVMdsGja9BL3TQ23xTg+RdijFqDK5ghJKnGjVb59ed8ruPtUKoBuPRLvionbkYGmyMXy7NH8EZuIJiE7ihgajH3pa1Fr1pkSOk1tk7ahnDs11li8Sz2NtFMWicyK3Le7vAZuCBaT0fRZTHzjLn6SLJXQNWRtc2bBeU+agwLfcfiK5Vmxk/HZYqHLxcacHGD/KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzhmUI3ZnY89ioDsovVs/i3fA+ZiVVUpRhXr7ctVnoA=;
 b=a4dsSWatJyboXzMK4DUuJ2SsSdU5dskCYsyJ6MXzE7tY57IDG0ETACvdJdsB1TOJnym+tC6ruRSKcvTdxkb3u5KjcBXXb1TJmttxhuX9w9Ic/lLbtnOw+Q4q/REle88t5Igk6RcjuPLlnW+A1iwjx+cZlYOe0tOsRO14dt83ZU2Vqv6s+Frh0IbA8YqkNerTnP2AT2krwYmWOAkqK17Sa2q4tN9jHTaTsR3IRRfVJMjHXsFAz6oOqLSgoJ7iOT9LKsEs3Z4oE8KW6Y3K3G+WJaK7Tt+WsQFo0OZpzbpbAf4+k9oOZmGrluZS5fobAkuwYm0KCr9qxQGLdMBYa9n/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzhmUI3ZnY89ioDsovVs/i3fA+ZiVVUpRhXr7ctVnoA=;
 b=WtJrxNa7WHCnpV2WicvKZ5ziD/mGHRNaxIK/j4cZFFGgbm/zRZqIzQpI3XzL5lZbjR6sM5DFrgPG34GQtKrdznKVEKoLqQQXqRk7ypoLhSxJCxE8l90PkrFU7yfcWomnJ2nOal+jpeOVk6XTEBNFdPnC0rAYv0YEII6TDH08/1w/Gs0R/5IwZeMmgSqkdmYWCdONa49jNKySETWlrudji38PM42lpQC7HvTdMw/q+mEW4ksykiOBi+x/4thYESWT5Lot0cRPG37JtXexMLZmm4YnKMNilTOrYs52pP6nZCofTzNySnBImfj89qfD+2T1d6ALb08tbSjgj9yEbGpYkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 16:54:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:54:33 +0000
Date:   Tue, 18 Jul 2023 13:54:30 -0300
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
Subject: Re: [PATCH v10 09/10] vfio/pci: Copy hot-reset device info to
 userspace in the devices loop
Message-ID: <ZLbDxktjv9fjrT5p@nvidia.com>
References: <20230718105542.4138-1-yi.l.liu@intel.com>
 <20230718105542.4138-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718105542.4138-10-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: 6351383b-e436-4cf4-84fd-08db87afa956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3RQwIHJKH6d5vddFcIKPJ1XSEKpkSATobQyIbky6rzD95RCJpWu3PYJXiRnzHu4BLcsjfj2E2lQ/3IRfxa2LW6IzVD82YJz6YfQEkTdZCp2fyCirtP9V/UxgMUYahbWUTVJQmj3LS+FQJzHmrp1e4+MlzLY2x6snY0Dhh/0NQrIF/duN/LPffda1BqM3qo8RXigVlKnDw8voJcn6jf1LeMjalJpxvrWgF2dG6D0D7NzntcpV7Tz9i/FW6eqCeLITfcowelaEQbFdkiJpnz+2qAhYORUE/e8/fjmcKCYArlSh5FPNVJDI8L5xlpcch1EyVA0GEc/QOSX+MkHz3+Vnvw8m/zktRjSsSo8jfXaf3Y8KMcIoNmvM9k7yE3Gi2UfAK8YyMKoTzESlwDA3UjnXCFB/hxg43a9RMW6Zp+utKjvFWYOKd2+Qi0TTasOfiW10xltpGaVJzdi9amU8mUs3baHry5XZfiFVZfV+hV6EUZ6TZvMMzlHcEmFBVj5IjWH4GRfwipB3A0S0FOiRnczg/TP52Kz96Ptcp1DLATJVQv8ZY2JftCMO8HwQr1HmCDj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(7416002)(86362001)(36756003)(4744005)(2906002)(2616005)(186003)(6512007)(83380400001)(6506007)(26005)(38100700002)(6486002)(478600001)(316002)(66556008)(66946007)(66476007)(5660300002)(4326008)(6916009)(41300700001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m7NyoI9B6PDsHQYrgakaEt3AFlOuYpNLtd97+gHx3Pa58FZc6CcZiH+ITSxk?=
 =?us-ascii?Q?Tzd9dFdm3B4aj8CRRDzGYUkKpmA+Pl1frqP5v5qm3ifXZLxc7WFZ+o9zd06O?=
 =?us-ascii?Q?/Cf0wADuXe/mYH462o1KloarsxMhz4CZJscpF3FQWaGoIh8W9mMDP33xXN5A?=
 =?us-ascii?Q?xsmAv+i6nzfui2Z+M96ORrAeH7woTzSVJU4xQ1N7cI/1Fkys7MlYpE+RjEzb?=
 =?us-ascii?Q?6bemGnEXpwWZ+jlaGxbCIHnZSlmp6DKOQmtZWUH/v73hcT6K1vrpiqIZN4Eo?=
 =?us-ascii?Q?2GYNOLqfOoV6KG+Ijtlk/YJy0rFWpqZ3eFjReT4iK/BeOfokSe7C0VKrftSp?=
 =?us-ascii?Q?7N4U3LsgR4joFGVa8nRrZ5Gjln74BWgXClFVkgt4DM9ElD5Ywa00W4SurKGm?=
 =?us-ascii?Q?WYhinQx7AfkjxxF50cbOn6YXYi5yPk0z07ksvE4EB36dZkN1oPdhHkpx1UvL?=
 =?us-ascii?Q?DgG0orlHXSA8KaCB1O2bk0JDaI+3DBfzT5xW8ho4Al9YQ7vPQQB8NS6xQUyJ?=
 =?us-ascii?Q?zLzQxjV+muNGdCpBb4Srt+2btS9vcK/Yfh4w/cvcxqhdwFApwBI+cU5swnXm?=
 =?us-ascii?Q?zGsCi9bby1ul0Es+Gsz9UeSX0An4YW6pYh8BBfZ6YCqaZEja1b4yKdndW2kK?=
 =?us-ascii?Q?Gc8nz0yxME3ySn4KXTiQ8fsktwgWEMfaKFCu78eJTsLiCtQKQzq86Yb8AB6k?=
 =?us-ascii?Q?vXfFbZ0VQ2VMh088wGE47gtPXmV5AL49bVhcaH8G7MkT6BwFCYERDSmo4Bpt?=
 =?us-ascii?Q?5Ou92lf15xDzEz5biTTPPjq46y1bcgH6OThS3JuD+s8K6xoNuNnDOAsAnqjK?=
 =?us-ascii?Q?HFDZh/IXyKOsf8FXkCVCMJadrPIDttUccuwzalygK7SfWQlwPSqnUN2hZgUd?=
 =?us-ascii?Q?KbWwvyVMh23aicfKesgZtRUZjB6XZjMcXcVvhxPLfVStM0MmLSEFbqE6xgHE?=
 =?us-ascii?Q?lLbjRzbW+c7+o2qKDBQy19izwQ28CkJ/B1ScLbXw2BOY0vcq3lsXdh5HVhTW?=
 =?us-ascii?Q?jic6vHm1xGcoXZwzLdiYeZUHaZ6FXxmgqK59OIr+YyNfXd8IJtF+7i9Tauwy?=
 =?us-ascii?Q?AQJhVluYir33uhxyb9lIRLTjXYbHi49bcNxqbMA66d5/aBj+i731pmGKZm97?=
 =?us-ascii?Q?Loz/DM/YucMlNuRbHDeRXzWpHwjL+pBpVTaDhaZyahPS3jaMeDbhBNzsK95e?=
 =?us-ascii?Q?pgHc1g9jDP1LK8Nk3jEqiO55pk+yO4iTP5Mrzn4OL3AZelBAkzi2wBaavhfn?=
 =?us-ascii?Q?9PnQ55eC0WfYy6YntYWxjB7zgdVLJsokiJpJToYeITJaQsheL+xb7Q+wonfW?=
 =?us-ascii?Q?D/w3pkbqX3bf/TItEktb6jc33z3MAuK5nq4lEyKlBmurA0ldkhK7jpCnYZrW?=
 =?us-ascii?Q?JYCDOHrWPefy3dx9hY98oAq8bxDI9TqgybDgYIClMaaLTstuPoDhAZriJ4mU?=
 =?us-ascii?Q?+xEjJmkK3jjyJ0ZYfRFqfT+kLCFnRgpWO6B56L2IjNhL6P6AC4wmhTkQIPk0?=
 =?us-ascii?Q?g6wZ8A6aVQTEaoN3c3JjQ2HFPVG7EYwPI+6nMbcigOkQygVVFHAZ7pHmEf6p?=
 =?us-ascii?Q?KX6P8eAw1sM2agdvD/ps/yfn99cL23wnVVDST0M0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6351383b-e436-4cf4-84fd-08db87afa956
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:54:33.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfvMrJGTvo4sUNt0uJTDMvjRnlSkeaj0Jhp/eM4s0sd3rtXyQpYxnjSYSBG1XpUD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 03:55:41AM -0700, Yi Liu wrote:
> This copies the vfio_pci_dependent_device to userspace during looping each
> affected device for reporting vfio_pci_hot_reset_info. This avoids counting
> the affected devices and allocating a potential large buffer to store the
> vfio_pci_dependent_device of all the affected devices before copying them
> to userspace.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 93 ++++++++++++--------------------
>  1 file changed, 33 insertions(+), 60 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
