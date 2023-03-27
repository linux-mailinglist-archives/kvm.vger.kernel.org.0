Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629E26CAABD
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjC0Qfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjC0Qfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:35:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2730D1A1;
        Mon, 27 Mar 2023 09:35:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgSqAuyFlDQw2xmEokexn2tXenSeo2J9o1Cxb83DxASYevxNkM13thL0oK1d0dP4IZes3o3aKMn2GsHTr7/CvSKBx/RavaWKdA0PFDzhSa3rftGaERsFF7+I7Jxbje0cbLlVqjgWcrRUkdHxVVcxHhR+3ITE3RjPIh0Ap++Z4wrWig2n4N0og/OPnHV/QjmxUDU8C3YBo92/D0H8mzW0Ey6NiROJfel4MiMZlvm5bZ1Vg93LyzEzhOdB7mrilkvti1B2NGffpzt9O7Aqu1iMuJgMBlFuUZBV0ErKTRkDouZi/SId9ywafKME4lTd/CH6vWwKdL8XMWCHYIkrFirpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTbWUv2iuqfAN99I3OyNsknOXLcrej7ZMcrqjRngQOg=;
 b=BTrIcmts7a6BCuM80FeHekBAitnZKmliiylCf2+DgkvLvUFWcma7iAl1wz1jxog+ZI0S/vmf8y9WwZb2MG+HZVkfGPx5H2Q9N3LDN5Pl4NXw8sw06h87W5BNeFQ3udwCkqZhThE6ZvhLk/P4SRaMeLrEqlhC+b1v2bXAuRmUOWqMgnEGbCGQTJcz4cZTz9X+X1fA2NDBojBZ233eDCvkUt9VhJX82O4iMFUllPhXUG78LFVcumWUcofJ0O9YFHS0jw1YumpFRLSeycbkeIa3vpcJZx2Xn15EV/Q8hFFUUqhjy9RZ2janhOpkx6fCgABUWi2rPow5XTHd+ZuFPkom0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTbWUv2iuqfAN99I3OyNsknOXLcrej7ZMcrqjRngQOg=;
 b=guqnyC7y4ZYZ69572zVc+YKPzPsOG/kYih6pmSh2RIdcGbI/dX+qlLGNDR1LG9b18DPGNT1jAItUUmBpDOYQyluZL/WSchq7vpbC4lQU9GHP+unJgNt7XnioVMrIkUYoy4+16c5v+febIm+wxfw069OvgWr/Z50qWl1wjGVHzD4arjXrxQ0vL4JTwG0KQ7lvvyoazQqCUkJgc1xrmIABZL1nSC8i5aXtqDyyByWF9Bld0WX8Zy5eg8If2TWO4ZqaoIQa8pqYd3Wih/AW2dhGOkr6uv+c+O1CKe3W09OZse72lF83TuvlD0+NLy5QZimz65Pdg5qLuwFeRmL3q5GxtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4295.namprd12.prod.outlook.com (2603:10b6:610:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Mon, 27 Mar
 2023 16:35:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 27 Mar 2023
 16:35:41 +0000
Date:   Mon, 27 Mar 2023 13:35:39 -0300
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
Subject: Re: [PATCH v3 1/6] iommu/iommufd: Pass iommufd_ctx pointer in
 iommufd_get_ioas()
Message-ID: <ZCHF29VYiS1ZaKdj@nvidia.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
 <20230327093351.44505-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093351.44505-2-yi.l.liu@intel.com>
X-ClientProxiedBy: YTBP288CA0019.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4295:EE_
X-MS-Office365-Filtering-Correlation-Id: a4265063-a1e4-4f65-9e19-08db2ee14df7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nYvPLBuOELdjYo0OOulalqAYbmFUZQ1hEjDMuvrTgqoqtXUGajtJqP9TYdX2WxKmEWJ70tYBAnpdQ+DDB/9fQ/FQPMfwB+mNOt38wKYdlTMbD/3R9WjfqFqlvbFicTemNYFdM3xTemU5347l9PKJijQSJjeHwZi173yiALqckbedZhmDgJ4x7d8fhkUTr3au1Q1gkIN73sTLmgCQqeOk3p/ngDd00b9Cw0337og7xss7Ch3qrB8O6jIPblOPCLoY1Ny2EBqiEPiduqpcJC58Lu3kCG8Tx2eaerir6avB96sApxoo/2+93TWJCeno+JEZpxK5dq8OzzE/FlY/2yrCN6WWvDJ9g+dlaf0CFnsg7cjKNZSgWIBJjBg09lOoy29sQooGZjNo4Hebp42GPPtLI3Bw6hz83wD5B1c6DT+BD0rTtN7JTajYWraYPG2noq3cyf1AZwcIyot/nukjVokWG7jkkWmfi3NqH6NLgXuE5d8ZAuYBLOJmnQc/E32qip3vtX01UYp3APXRtVhG/fdSlKk1Y9+Y6mF6jAOi7pgwfKHX4g5SRqQJucc1K0kOUI+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199021)(2616005)(83380400001)(8676002)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(6486002)(478600001)(6512007)(316002)(186003)(6506007)(26005)(7416002)(4744005)(86362001)(36756003)(41300700001)(8936002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pp8zxUsnyfGoKIFfFYFMDNhe54URJuLVk2pac9Uc3Iy6nh11SzWJaGc/Cz2O?=
 =?us-ascii?Q?w3C1X/luTKDEMvhjYQcBmCwTIeZdN+m8AgLqQOGS03t5wYaJd5rOV17m5UAx?=
 =?us-ascii?Q?4ByEWlLGG9VWcGgWtwFZm2ruy4dW0HCvaQfln0iexCJLGjyS7krObOP715Y8?=
 =?us-ascii?Q?LkNeKJTdXB2Y9057jx5HJZTLcJbRiWJ5Sj5vxHYeuhQvsnrSyv2gA4gJ490q?=
 =?us-ascii?Q?IW2YyPoOh8ld8L5UkDdCGzmVBl0U97xcFYf5uFCU8OgtTIXbVbmi3E11sh84?=
 =?us-ascii?Q?WganJB0LXnk2zCUSLMbtWqyHGPmkUbLAP+TN7i4yHdAmuLLR9P2UbWrX4SzC?=
 =?us-ascii?Q?65qWoKluNXlLx6326mVfENG/fyM5bu2O4zgCXolPgtIqvHuVuQyiACjmOpPY?=
 =?us-ascii?Q?nsdFPZLz6sjetUiguk6QRjozfP86bSd+K+6zHt4MaGHU2Y0V680pEJjTXBXa?=
 =?us-ascii?Q?Hf86bmVZp5VRb2H0XsWwEymJTpM8Pr9RlrJ1bH3DUFVaflqMvZ4Egjh/WMP1?=
 =?us-ascii?Q?pWKLZThx6fj50GrS6a/x/mg5iRPL1SYAjMDmjAQE2s4yptpzQPjvyONoIAtq?=
 =?us-ascii?Q?t1Szy9QPh9OHGDe4/cUxq8ffku8qI/qdej3L6/AUePbs4uWjT1pST4pT1PtR?=
 =?us-ascii?Q?USMib4uxdZAHyxUhhANdKEFGzplesDuVhk7rzAGVaiH46x6od0dusJMKjwJR?=
 =?us-ascii?Q?9s4qz7YNGBxhuH1rRvR+7wI8knnZEiEhl2BoE3F1a61F3EFYDyFgwTqt5fvw?=
 =?us-ascii?Q?wj/p+kejPmHLaQDbwMDHdBbMQC+rp0qa3lCIpWGRrLmc2qTHPbQ5FqAeXvAU?=
 =?us-ascii?Q?Xn+W7pKX3ekfEY2MTecy+hb5AtJpCHhRw6oavbuIpGDYb8g2Ue9esmwRZj+n?=
 =?us-ascii?Q?kYstaKbqCwfLA5QtybmJjcJSVqo2calGosJ+cKG9V2OAbEHW2HWzMu6DWJHd?=
 =?us-ascii?Q?IpaRk6D0dUevg2j9HEWs7zKf9ut7vQqgC3V20O6Ol9cqihUF+LB2flaaKdpo?=
 =?us-ascii?Q?AprLE7JLlGxkaVnK4LZ7dem+UktEkYsFaYEEwn5xS1sDQLP5+1REgWr2kcHB?=
 =?us-ascii?Q?st7TluJQWVfaa4/CFux1RYbe0AKOB/Fz7O1+t6/ssRIkUT4+tdNmdsdTBU64?=
 =?us-ascii?Q?1poZEHVu1fDWG6ZaZbz7UyUix4OfpVPcxo3VIlFhrnWlYuwc8JyfOu/SD5Pj?=
 =?us-ascii?Q?vCGW9o99zlaMG0X6XvImVXRFQN0chS8okRx0u8vJR30p4AmfUfIF61Sq7+6Q?=
 =?us-ascii?Q?6votstDuIwSvoPYXACUoMJdL6xT/NI2b+b69SD9ORw2EeDmwfdPSYFGnQhfE?=
 =?us-ascii?Q?ibhIdWHgedA6DLKCal0QGv99kPeRR68yWQMFsrgeDuGXdA2mHjORwgxMZDeP?=
 =?us-ascii?Q?MQ7mPnjZYkg1r7m+mHxebqfYIHTKRuacPbMmoLu9XXSZvfMPYpQYeojoMvX7?=
 =?us-ascii?Q?qUFUeeqAS58dlN7HbRR1XN+MMnDo9EdtJXwOfgfdrh6x0gtZbeLin9eS/dM4?=
 =?us-ascii?Q?O9dnzNrpJBmOPHo+DAh4IPXpwkNyTRMfwfW8FaUy9/wDVETOPyTP2jaOpsj9?=
 =?us-ascii?Q?YCkV+zUAqP348hahp3Y3c1n2gFhcceAd+yAB/HQB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4265063-a1e4-4f65-9e19-08db2ee14df7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 16:35:41.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onKL56FIgk86huIYvGcp7JCQA/49p1pk4RWBABwe8UaZIccXMFZZ9sFlSgTSqJnA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4295
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:33:46AM -0700, Yi Liu wrote:
> no need to pass the iommufd_ucmd pointer.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/ioas.c            | 14 +++++++-------
>  drivers/iommu/iommufd/iommufd_private.h |  4 ++--
>  drivers/iommu/iommufd/selftest.c        |  6 +++---
>  drivers/iommu/iommufd/vfio_compat.c     |  2 +-
>  4 files changed, 13 insertions(+), 13 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
