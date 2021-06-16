Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B1A3AA7A5
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhFPXqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:46:50 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:27839
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231389AbhFPXqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9zfBPmCqXh6C9NbJyajBOUUpPvDt87GHkrxOUt/7eexka+Hm70K6QnoDpcN6yetjJw2C89GhFV4w10TrqaZ6Nic9qoDkoTlGqQMSulbPw0f6E+l3RF6xJsmWohHjuX7MNmVWAFWm3K4ky1xTUhkbqHbCvsOfmMWXYRHJEUKRKnBucA9ivtpNKseCpEOfzh9Pou8/mtmLE4zJBPpIGyXz6L2x/ddRWcIjNN0nwwUq2T8cY4tsC6u115U5GH7hCNgad4a7blBE/bOZjQWwEaX79M/Hd9/a1YZNHN1PRb/rPf7uxEyESzqnvtzOB9zRlkX3iqj08W3zKM+CGuIV6I9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTh8lA8rv4u1zCzN0+ow9iN8op9JSTqWz/I+7m+4TTU=;
 b=ad/78G7eGpvnf8GOKIItBUlDvjtC9jFLhFyihUmx2iOEk3eLgpb3pBHgd689qn3N8CtOVQ8BvMwrrtyP8o6g1f0XqbTtiqFAmDdMGDUQ1n+y4pNKrQZNsVdPvToXXBGgihsDUxELf3CmskrhVnZRs7Sr/3bPyX6a+NCpOJBoNshmd6BcP+KNoixJbCsDzNsKyS6GjI3O0l8G5C4Qli+E92qYr29f0vYCCHIfpASRXCUtruXkiYiuhXSmGwgH/yPS3I8LAWlP4AgBUL1cLsAfr97gajHAGbNYYNQnaWRHnrDIo5RG8TEGJUxryUXj4SSe/TV3vusaQVuwxrh644trQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTh8lA8rv4u1zCzN0+ow9iN8op9JSTqWz/I+7m+4TTU=;
 b=J8WRigwbfGCw+CX8y21RxERG8xiqnv69OzIb154QFYVH39YeIx+W/xKQydvjE6YGbdsFtnf/34D1rK1kqpnZfBecMLl6n8NrcrUzhm63UYe3Wtn1SNlyr48kVG+MlG8B7CXD6FIDgyBW43M7/GWIJ7ve6EKFYBuGCsBev36A10UC8Pc6MNA2Gkhrc54ZyOS//h7ardyLZ/Yd5efIylFzT1JACpqb4XHXJqoF32l/8ivsRELhIlb6BHMzWMsPAG+Hvvrahg8eYnLJGZFSBA//YwJhCHxbg2V3g/Vys4uUraxCyVl6GcJ6x8P6bkTEuPYFoGNDDdAkoboJKWUouunFJQ==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 23:44:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 23:44:39 +0000
Date:   Wed, 16 Jun 2021 20:44:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210616234437.GS1002214@nvidia.com>
References: <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
 <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
 <20210616233317.GR1002214@nvidia.com>
 <f6ef5c0c-0a85-30ca-5711-3b86d71c141a@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ef5c0c-0a85-30ca-5711-3b86d71c141a@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:208:32e::7) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0122.namprd03.prod.outlook.com (2603:10b6:208:32e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 23:44:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltfD3-007wiQ-K6; Wed, 16 Jun 2021 20:44:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fea77aa-32f7-4d3c-2f7a-08d93120b48b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5064:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5064738A3188F12511510D22C20F9@BL1PR12MB5064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: retil8Q0VIJvgoYnrLc8Z3fzg8nyYTGY4skbgXtXipmugZxeO6XAmUNa1rXPPEStF/hox4JSZ35emPL3oXLguJPiWMzIdeocjuVqcM1slzQzv3HlJmolQXSJqQQei50yZlJkfQ9BT7flxql14m6IhOkYryx9agZNicwrS19YEt+hgItoc4HlBB/PHyLmAGCHYxgGFQBhDvXhr4PhFqlXkpzNWTXSIPSeeYayOuCrmxVX63hLJsHSZc+Va3Uy+cW0ZW27ThUxAz6gZUG8xKtNSZR/BHnd+LM0mXAC1f7kK64excI+MuAgxjXSbPBEQKUAnVDVY3vsdKCuoAID/Zozn8+Jgr5mduGDes6svx8vkReluco820ldPNcmqJdiytakEjMhAuvvLbUTP+4LJJB/MSPvQhHQ9WARWxBUzH83o5d5ucQt+c7ExF938AEmBwWFGG0FZ+akFYWGe0LQGHZk0xclpayuUqzdt11RqJ/cpLSIrEiudTH6oKdugn3ssE3kwWAQyDU9qKev0ONrFbgmIR5mOwG+oZ/m8G77bWhazxajbvrOjVYhp0pR1qrdT+Fd5rdYMSRF09ae7BMpnv+m5r0o3FKfyOrHJsA/HCNIv/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(2616005)(1076003)(38100700002)(6862004)(6636002)(8676002)(2906002)(316002)(9746002)(37006003)(4326008)(9786002)(8936002)(478600001)(558084003)(66476007)(26005)(66946007)(426003)(5660300002)(86362001)(66556008)(36756003)(33656002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Elv20Epv9JfGIWbKBTNPydO5t0G5YkClQ2WFS/EGJQ1KPL7fI+6GJgl4M9gO?=
 =?us-ascii?Q?T3gLPJQevzseCjkc/qgFkjhGzXsnMgUyuExrbnL0aoHf6VD2s5OGAs3+bf8s?=
 =?us-ascii?Q?HEIn81qF23v59qKzY5HjyzCnZbjNRRNDDva2hlXDhtye/NjxkfQOz8x68zrV?=
 =?us-ascii?Q?8swClbnUVYRASvcCj1If9n7XGF1FnJ6DdYZjaqiL0nrbU8I2x4eIE0Bcrbi6?=
 =?us-ascii?Q?OzlwMV/DMY47m7NuuHAApS9okKA0dmP7EI2Ej6LyKnXkXnEAw9cheVKuQwbh?=
 =?us-ascii?Q?Wb6+1y13uMMJG+lqIrFeIn/TH+eMKmmQ855qtTR8pL6F3RetP7t1uF/Q3tWH?=
 =?us-ascii?Q?6vfX8bkTTY7xSneYgAWvNuBi2P+p53nBqVDsmbFmJJtIQHm38T3V9Wqdpc9C?=
 =?us-ascii?Q?WBynTvz19BQ4GM2a/iE6vpoM4irSqj5NxFhKh8PxycPvBvsVv8k7Q6wQXKAm?=
 =?us-ascii?Q?er7ITo9BjSrKDGZ01OMM2PwH5db65l0rBvO3ZCg12JnYg9zyXohENHRICB/2?=
 =?us-ascii?Q?URnj5Mu54MGxy5LstczpJM4lRYsboiCZ7hNQyE2gV0uJ5aKrQIN996V8sDW0?=
 =?us-ascii?Q?JtqTOQJV76MUeW6/sFa14Wm4X7n2rnqG2x1deZGRd2iGwPfKXOqk6dGt87iW?=
 =?us-ascii?Q?DxcT0jhftJZh63jcP8kXw+FuzerSPN6LdN+BFT/KQQOocgQ5gK9mQ0W8qOrE?=
 =?us-ascii?Q?ouQx5ClTdX2U8tT7cEq9Jtac5JLWYnZB9a423hh5FuHH83nROlo6lRshHoyr?=
 =?us-ascii?Q?wRpzNKX7DOe2YXOSUQNJJYxkKBT3zzU8Zgpn9bVXpgaFqZRLilORa8skgjEl?=
 =?us-ascii?Q?T/1DCDfvtDvEuYxKLJDkjdzGGOuAAQjKhoFmQDNsv43PKG4Z1/AW8JGO2rt9?=
 =?us-ascii?Q?KRwoxSDS5gwqHHRCyFZcCxTw6zJBgSP8U+geSIB3Jk8Pkx98Lte1aJ0XtCtw?=
 =?us-ascii?Q?NB1VMpot1fJR1uedKaWSHTAtacJkbqXLzXw2KaOTl8+0wvAuB88Q4Lft06cB?=
 =?us-ascii?Q?01rSsDjWLaYKCEkhXRs6xCPq4V94GR4WI/L5ZYND5HSSopE4QFGDvPwXpNWC?=
 =?us-ascii?Q?figiNg5l0iwB94OzJfaU2q4Q+bMr9UT5oAbTSSh7lC9APUdMAKoRc5UCNSRj?=
 =?us-ascii?Q?q61nfDGSJPznSSbYUio8WAZ1pQ9HXcgGSwZiseuOnJirpivFKNwiLWqqa8yt?=
 =?us-ascii?Q?irAaM0/ZXzQSCQEo+9rB6UZ1zPfzulbuAarYmJLnv8XTaHABEbypQyKR8W14?=
 =?us-ascii?Q?9f6Up6qzsjVhj6hY4HDxjwk1e6PZ5yXsfY9E2TnJetByiSBtRmrCqNYDrzFg?=
 =?us-ascii?Q?niIJAOyX3IKsT+XwoO6nEpGp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fea77aa-32f7-4d3c-2f7a-08d93120b48b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:44:38.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/CQk9gPbHxLiy4gCep3j09AyTynsSNt0VK4/OjMzvQ7vcvZr881cvV6PyWMF73T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 02:42:46AM +0300, Max Gurtovoy wrote:

> Do you see a reason not adding this alias for stub drivers but
> adding it to vfio_pci drivers ?

It creates uABI without a userspace user and that is strongly
discouraged. The 'stub_pci:' prefix becomes fixed ABI.

Jason
