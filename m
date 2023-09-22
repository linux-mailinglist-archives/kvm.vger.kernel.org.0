Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC727AB23E
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjIVMhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjIVMhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:37:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E6F8F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:37:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guvO3EkUbH9C6Hr9Xh9N6nn6X++QwAQJ+O7Ighh+hxqHeRYGTtqsZwLT5nQC0IeUChjPmqapmc7/RVeoazDXyvUw4gCXoqPiFPHfXGa0nsxE+ifNq7P9tEJUoHbX5ZUzEZTh+BIJAgpP9Ritff2gQvgV6Y+EqcgqyekLppX1zRI7BwJCgxOvgN6GbQ33BeYGj7QhHdaiixcNzBtI+WqweY5fRb6tDGOi6R9wDRurKG5grB0oUMyiumet/DgJNV9g7UKNMj0VhZiO5wTjNFMZUCXkYhtR7ALYd9bqPGeyNpmeTLhQZsQ2UHXp7dGHAE6obpgf9ahnaQyrJ9X4uscaew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooE3xVSVSCt1qbEzD4GyVRCzMCId7ELkbt8jGwVHPVc=;
 b=dpZJNpDhsnn2qHvn0+asoMOr9ysCPQsryKvWP+wYoTiUGDfwRjjw1+nNL9c27FT49CRcccw+C4TbwkzdbzZc9zPjRQKPhLRpEKiwgLzIoDgoLgXEcb6SPKvF+aQws+XE6XIZWsnO8S6BaV4a6mv5GjYHqvE7Xgg9QBBUw7xcwTdXRYfPVZi58XS9+E+59nQcts54wg3QUKIETd9bi+HYZljyTve6zzgS0GT8dhyF0SZWB74GdGeQdwJLmRfumKSj0ZHhVXthb9pc/eZD6GSK3zwouwQ+VBc8blieE8gmSFzTsrAwIOj7mplyL7hp7xx2rQCsSzIBCMhcUswIZc1MWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooE3xVSVSCt1qbEzD4GyVRCzMCId7ELkbt8jGwVHPVc=;
 b=JJ62Jk7kfkSPy3TkHCj/A1axOyV2EsDk/ecOSpK/H5zYyR9pDVTo5L6IkLMndPSxE1+6IPLH8aQijWHJfKKnjBN986oDY2ZqDw3vzbm4SSCv0861CpYNdfIcRKFlHhhcb6sv9EqQnuT/Nkejd9S0i9BS86bokxRa+rr0BLczcsoUfql8HmV/rNr8bU4DhaimsmmOsNuvJf3A8qnerAhC/sXqf3R80onxuM7vLIWw8H843D3IeVcD71vk/ZidrCV+tGMzkVk6s2IjF+qaewHqTSF66Nn1KwwWY3TsiIhlCxEbv5OkwRzRgaL8ivYKDetDe2t9lO8g/XnQYztyD7cgjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 12:37:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:37:09 +0000
Date:   Fri, 22 Sep 2023 09:37:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922123708.GA130749@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921135832.020d102a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921135832.020d102a.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:160::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: b85d7645-c65f-46b5-76a4-08dbbb68a349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ie7c5Y9hLHGsI9dpEWhfa/BDRj8b819Oa7KUDWsU/hxPveaw80R2FYQY0t73v34YpNUqylWlsqf4oRASr68grXPcRIecQCAm2QzLeMGqk95Tn/KoedtcBAIxjYvEq13cGl2U4u5K5Ohl1za8DofhR/7Q84HDUNJ/wmw8rzDf7IVqMrPRscRURD5I7+8Z+nafK76+JfsVbTmiDZzJHq6tN4cQ7ABSwMScFwLIT5zuf89qXENuBWEK25eUx5kHzrFCC7fytU0Em4+lq1L2DchwH2vYicHF5GzhKPPsBNk9GLlS4ABVLEmVMk1QR8/LczVf8jOQrilmTWwBpnpwRHIYy6G09AeW9oOem/yyL5OqgefQvTDZMX9QGkWHPn2CaTl3b80HMqdqjGqcb8iogOThaN1lEGV/nXRTQHNOvH3EzQ3zp0qkULyhzEh6vE0ByXz4O1JyFyxLAkerqEGIkH+lAP9mOj+wzrzvUCQ+8Qa3G5GNOyeq3LEE7qfZmFjE5tGc/i+uEyzmgxPVFhgx3OGS+qX5rNirPX9/2zNJsqXiugDx8MzAIp7N8He0Tgcz+8S/KUts9Qd1w5Sk6h/vZumxkrshdIX2fK0b/qlZw45WCAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(376002)(39860400002)(1800799009)(186009)(451199024)(6512007)(6486002)(6506007)(38100700002)(1076003)(107886003)(33656002)(66556008)(66476007)(2616005)(478600001)(66946007)(86362001)(83380400001)(26005)(2906002)(36756003)(5660300002)(41300700001)(8936002)(316002)(6916009)(8676002)(4326008)(4744005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qrmBoDQAtkXurKg05GbqxO4MkeZLKN0FWWZv0QAwaq/ECwjgKgdYGXaap1M4?=
 =?us-ascii?Q?BrG9d06S1PqeZ0x/DHGjZECnb3VYRlns7RI91EUxyLs3CAjtDcqUfLM4fdZT?=
 =?us-ascii?Q?zw0FRvSRCfow+ile4Pgh/rPRrRHA5q5gy4GJQk+8u8pq9L33hEJduQ4IQeet?=
 =?us-ascii?Q?IU7mC+Em0dWH88iqPkjuYLTMjob+IAYLwUdpfNwc9Q4ZDAzMwANYpyPjIBBM?=
 =?us-ascii?Q?7jCB9nND5n8aNXo9pncXWoxpwNavAcEBIjX0Akc69xsRDyp80VP1QmttIyUf?=
 =?us-ascii?Q?87hGm6D553pUvjVjXr19mPSmH0nxbTJNhxTC0Iwz3elYnlhCE4BvTgM+4ioZ?=
 =?us-ascii?Q?rsW0jb2G0DihTEJwYwg0obc8AqO0yUAlOHDHeC0AzNT4CIE3Wh5MVT8wINmX?=
 =?us-ascii?Q?0NQHR7EZZdToC/x9xohSA5RmiH1lotbxntY+Gfpb2H8Z8wQcFGrLBF6CVGHa?=
 =?us-ascii?Q?MVxoSEU4lZo9TwClXsJ80OUM/jCQw1VLLCbtVfSyfFyxIJ7vNc9JISd5QCZ0?=
 =?us-ascii?Q?VrZh+DFQsSXMoxBdwGCNDfv6tU0g0nQmggvKdWC2sTBxeKH/IkIK+LcUiYN2?=
 =?us-ascii?Q?DxynwU3ip28n1BFl7deCg1dsUoBXZv8qCW1u/a0mRRZd8LM2zDetf0PQPbc2?=
 =?us-ascii?Q?ZeEjLtDQLYgUgYIwSumGzK0vwtTJLdjK6eLJQdjxsnk6AX74POx2oLQfqqFg?=
 =?us-ascii?Q?8P/On5eXDxFvxWwz79sg3Vp6k1BQzgMk40wyhDNQL4MCiqXyiyXzQtmhj038?=
 =?us-ascii?Q?f8PVDf9t918+S/mBb7XS15q8cM7jE1wMoKgEfIR6uxJnlt5gGAUg49SEdTTm?=
 =?us-ascii?Q?EpGzWfLyt8/qOa5BLVgZ5rBDH+3Ljwkqt+pilw6NAiv2tdtvENAUfteeQpzM?=
 =?us-ascii?Q?TZvxpuskD/zt52BBaHoXif98OJ2wDfAWkqNMZQot8Esn+JBHkHuJ1ejOd8P4?=
 =?us-ascii?Q?vmvGtYUlL2e1IvRuZPDZoT0ytMQ0dGk1ekDCQTFVzYMw1vzIRh/EEv99bmo3?=
 =?us-ascii?Q?uH0+dbFbFpKEbAIgMdygMIkhOC0vOYdOLM83vsh4Q8bbNV4ljxeJhXt7eizA?=
 =?us-ascii?Q?F9ZeWmqj5JNc7Ug6Y0mm3DLQ8NtoqpQPPFYViy6w9R/8m3fas+k19+chARDf?=
 =?us-ascii?Q?MvLwk5noasBv/aJOyXsMznNur+HrVeDdfZZ0F9hbviUtOJokGs50ry3rj+s7?=
 =?us-ascii?Q?8rM+A2+11npYOoj0OuzZHg7p2pAXnT3KVyF1AjFZjzCmVkvyQq262VMiP4oG?=
 =?us-ascii?Q?IeVKHrh4KsZCZsm4A9sLZqUmrMqwUeHeedlsCOGj4lE1wn4UMEdgipcQoutm?=
 =?us-ascii?Q?X3tFkEreWMGHC2FfMpvMA5NJCiwVsiPcIDyalmcP9NMTPMJIo3jQkCR9hLu7?=
 =?us-ascii?Q?GSdue6VJ604It+3jolEf4d0ZPbODzc/D3BNq4a8szaMPg1e2Rav9+Kre83ps?=
 =?us-ascii?Q?RdSLuRbZhgEbPxGTCrfT9KcA4xSA5eHClgVlXKhpscjAvRkAthdVJq99Wy2Q?=
 =?us-ascii?Q?YmdKNEi/1YEqMzTNjtjJP/NUHeNIUwY5A9CIsmZVFlPSTK/gUWo5vS/CmIvX?=
 =?us-ascii?Q?98t9/y3foB6W8Yo0EyQ87q1Am5MZNnhhNxADR4TT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85d7645-c65f-46b5-76a4-08dbbb68a349
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:37:09.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: No8Y3ODgq2sKRHZYlQp7ywm3MnHKhFrWkWOcEHv8TvW4vs4YeLgPrLYW+ThlCKWH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:58:32PM -0600, Alex Williamson wrote:

> If the heart of this driver is simply pretending to have an I/O BAR
> where I/O accesses into that BAR are translated to accesses in the MMIO
> BAR, why can't this be done in the VMM, ie. QEMU?  

That isn't exactly what it does, the IO bar access is translated into
an admin queue command on the PF and excuted by the PCI function.

So it would be difficult to do that in qemu without also somehow
wiring up qemu to access the PF's kernel driver's admin queue.

It would have been nice if it was a trivial 1:1 translation to the
MMIO bar, but it seems that didn't entirely work with existing VMs. So
OASIS standardized this approach.

The bigger picture is there is also a live migration standard & driver
in the works that will re-use all this admin queue infrastructure
anyhow, so the best course is to keep this in the kernel.

Jason
