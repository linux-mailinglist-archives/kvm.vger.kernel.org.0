Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2664DCCD
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLOOU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLOOUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:20:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEFC1D319
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:20:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+x5Okn2hdxUoBClPkHILaxYlGawTdj5lW2pC0mu/FSvfj+xEvQJniSmn9wwtRTJh9Eu+FFN4lZwCJk60zVBMSnDV4E70deL6DyoQ81VnnWsYQrsLFkzAPXDYVWsx0mNRFqWD5ThrRHqfOzLqZb6zFZ/ZT2PRbQR59E0EyRwczmrBwD+JA+zb7k6B3po9gXNzdBrryLvQeix5sRjOU+f3ayj39wBog+xt2vHGKP/dIt7PUE84SedeeJnie7hiUvP1bEArv5JvSES3jOE7vYcwZj54ZykSUylG68Qh6MSOf6rV9HwLeTmUf1XsUvmnESnM9ymBSO2/f/mJicY+udgVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxCR2P2rz5Ji6jDOqNsB6K+J9bA83q3n4v22S2vDB5A=;
 b=T3VvjH9h8C8rqQUsDmBCHgfu6S/agyLWXu6CM/Cp0nmFfafqYDCy2kmQieWiJrrXanxIkT8T/8kck1/O1V15dmoLdLw7xj5ulaLkx4+XdUxwJ8NWh4tGgCeFI/2yPCk+j3o+viuR5ooq/Y1Ki/UFe+dke/sc6JjWnU8+Bav6lP/yXk/77OECYys4fsEnFAN92biBWJrEm5OfKDO0UOGI9FRjzpQuoG1w/ciotRYXkZGAjg/gFaHhUVmcSD52E2V4Tco3luPWK9w8aW2E4MJ4NZUKJqYOlofqTCACig0wDJuyoou4mYx4qByHrROV7YroPO5NCmbHFYVGkBTsOx1EBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxCR2P2rz5Ji6jDOqNsB6K+J9bA83q3n4v22S2vDB5A=;
 b=si15Sf0g1sZART+2veGOs0slYuJ6j8H1FrlWqFCrbyLWykVZyAA1WVXcEzQnOf9SoH0xjJVRLxZAOWrLe8JEVxV+fUl3jEtb2I3/yt5I6NeQi7HLR/uHbXw4u+Qk0/d8OdvfCAHGKU37ORIxoLKnxiX5z/pp/ComnAV9m+khdhNVeDlA8bEIn5v2eo6f2vN+MLuH4hs/VWvUfiwE2EYxOmyRwnGdPHVaLXrbY1Tyka280opuQstLEYXXh+IGavQ/HL3fPnOKQ/D4Cj8i7AEwmLyPUqS0cW8UhpRa+Hz0CH25RfIOwRD8GAr6hwPDng63ryPwEAvM8m3+eb5DOPkWJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6774.namprd12.prod.outlook.com (2603:10b6:806:259::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 14:20:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 14:20:22 +0000
Date:   Thu, 15 Dec 2022 10:20:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Message-ID: <Y5stJHFWK/ZLzA1q@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: MN2PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:208:d4::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: a1174b38-96b3-4969-9e6a-08dadea77fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZuRAk2ag5C9BwSVEO/lp9aPTXsu4MINj5KkQ0Wd0bOs8vRYOHz5bo8dQXLBW58quRyU7MVzWfX3F8HfnOGqZnPaA2BYjRYrTq5H3XqVqbP3eDLDVNDswD0SYs0BOkuWsSRpDaK3cm0g2vzT2l9utO0f7K86CXZ87UiTRbpOiCWVLaZHMICFvgnf7k+vESBrYMuWsWOUl9X3MdMtrw3l2Wsg6m1FVf6vUE2I78VfuJpo7KL1fZsnUaYHxuPcMbKG+dZoKtAu2Gvw/nz7FGpyaTfZek4EgABB7q+9IfigCMnwgwMxs/E3BLXuKUbzJ8aGWmz9kNH133+PJG10VlpvGL18zkSDQzxw47fv6utDqY8kGkJCPC2AHmTSgYqhZwHDbCzcxJE8uqo7HnMtTioVZ1KP0CKLF2sEttDjfrOhaUZrTDyCGs/8PehxIpanqPcCUxJcFcbRQfPBQAy7cC3RUa3BSw3+I8Z32U6E+MIgb8rDnCn625xn0lmsbfS6r0cYXoZLCXwOsBfVwVaSjjDoWwP9dort84LASOwTTQNkfQ3FBpnO0HgFz/AFcu34r6gJxp4BJONW5bVel9+4oOywUeZ8m6TN456ozXjkoJjPx9nho+/ayw5rjRWoMm5IKUpFYfDqyQ9x+d0duO+KJPIU/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199015)(478600001)(2906002)(38100700002)(83380400001)(2616005)(6506007)(36756003)(186003)(6512007)(26005)(8936002)(6916009)(41300700001)(4326008)(8676002)(5660300002)(66476007)(54906003)(66946007)(66556008)(6486002)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1kLyKhSp52OpXfBMjHinJTrdtQ+WVk4sES09YRYvgeC03ZL/rKhgXz3ZIvXF?=
 =?us-ascii?Q?4iIKad2PsZvzltaYi7tPgRJPs2BAd7iV4vbxr9pyGQBsVViPmvGTfNhiBknM?=
 =?us-ascii?Q?sgmEKc3gXfS+65ZK8Ai/3I4Ljr5zi3MSti8hNTZouQ/TZiLPywTgcVjHEw3c?=
 =?us-ascii?Q?z7DxCETxF8qBTACADqm9dQfa6aPS9/dJ7rd/zeXOejjFeoDV7Dr4autbIFYe?=
 =?us-ascii?Q?dTYtAFkEqM0idXyDFiLhEmV+lmrOA2267LjgFXaKuZNVoGDcrIRNrvAnPFhv?=
 =?us-ascii?Q?x9GtENcq5VFvhmNg40seT4i3VfH3ZOPtYEupygT5Mlj/6PeCWVzTQsnek+dW?=
 =?us-ascii?Q?yJ03yLTC4Nhf4HOnVdvcfUfgE2cnj+UAngyjZFPvbi8iw+HHTrkbdF5vdlCh?=
 =?us-ascii?Q?1n8bGgWpX6uUQBoMpE1eh0kMv+kqacoT8LXSIOWzzcwvcKHwejAZ+vb1E0Iw?=
 =?us-ascii?Q?A4dOPHdT6Q43o63bwy/OWLYfflaYoBgmDMJyE2mzZtKWWlEPNguu074+kDMG?=
 =?us-ascii?Q?VRQDvOJe2M7AO5Bd0nJUcpUUdYEe/p9gnBO5FkTdS8PKzFRdAftYoGN7SpDR?=
 =?us-ascii?Q?5XOatRXT9mf2D4MiyIJ36ugJNRjvQmumaxxPY/NSsULkjpeJ2pjz94+2gsN3?=
 =?us-ascii?Q?KiCecvEbyD5yGAUiDrZp+sZgoZ5ZDzyIH36PUNBgcU9wva1Z6LxM1KXSNBpC?=
 =?us-ascii?Q?3AHHEVnjgPR9+moJ9myL10jrlC1iyQaD0EhlIY65vSjk3H5sJx8eRBDD3IGm?=
 =?us-ascii?Q?4zliXN4It3kOUBeWjb+XJ1AH0/1JHHBPMU9QCg8oEjQoRO2pOkhh1GETyrWG?=
 =?us-ascii?Q?rEBh2cM1OfhVAXJyV1NcVV3qMmzQb1W/9aFgDrXbF0VzXMbIQrmR2hCG51C5?=
 =?us-ascii?Q?/8s0Az2uUiV/ulAgYHAvRuAEm8GZIL+KBRj1f1KFU2jNxTeZfwOrWLXcbHps?=
 =?us-ascii?Q?Rs8Eo4pxT4rbevBD6Sian8cxXqaAEHU77We79Tsx+IEdYBbv1GlosCqGLcgL?=
 =?us-ascii?Q?UgXIhlySnwl46wdxLc+uT7uQnj+/nJGFCSbCNqXFKPsbSsVgaAXm+mUa8yGK?=
 =?us-ascii?Q?DDqS89R8pT04AeM2Iiva1qwyuGB8eQpZXjprrOqGBWx/I9wj91b5WblNSVIJ?=
 =?us-ascii?Q?5gyCym9l9Ptt0Zt8wlU7QhGYYBCOi5JhYi52HGWnJVI0PURf/xKNpsnQCuWl?=
 =?us-ascii?Q?BXFzgxIGDoS8CgsispjUVov6IqbHvmvk5FzlfwcZFkB83h6pdCjTrHeYIpCs?=
 =?us-ascii?Q?4m797oCyLL7Ce0uI2rJGoaTM4j4If0eSdwQwyHCSuy10nm5Y+R4Jbdxlk2yp?=
 =?us-ascii?Q?wfwoyhiBxBFuFEgFdjy/Oz99giY6gw6w5woS44HV4VHMEKSfclwGWmdWJmYB?=
 =?us-ascii?Q?oSi/a7zygV4KYiIU0v0VsmzfnCavJM6QSue7yQmy6/Fz8JU/9UGYsBgNj1vf?=
 =?us-ascii?Q?GiDHvmdH5EAijUvIX+onb834TdEhXqcWHjfKQt/GDgYa6K8sEvpsjh0IZWgb?=
 =?us-ascii?Q?CRlVnprtRBi35eJ7Rdaq8djppVQb408rKKKJQ13A7Ld7jHKgmXpFdwFEHJ2c?=
 =?us-ascii?Q?RNVFACI2t6kDvziPh0Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1174b38-96b3-4969-9e6a-08dadea77fa5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:20:22.1505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6P56Ea1sL5YGxMXtJi+KuqMVVhuvP+32SM33Qgn7Rcu+ve004DMOVp8qpO+pKja
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:24:54PM -0800, Steve Sistare wrote:
> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
> dma mapping, locked_vm underflows to a large unsigned value, and a
> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> 
> To avoid underflow, do not decrement locked_vm during unmap if the
> dma's mm has changed.  To restore the correct locked_vm count, when
> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
> the mapping's pinned page count to the new mm->locked_vm, subject
> to the rlimit.  Now that mediated devices are excluded when using
> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
> the mapping.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 50 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bdfc13c..33dc8ec 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,6 +100,7 @@ struct vfio_dma {
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> +	struct mm_struct	*mm;
>  };

I'm not sure this is quite, right, or at least the comment isn't quite
right..

The issue is that the vfio_dma does not store the mm that provided the
pages. By going through the task every time it allows the mm to change
under its feet which of course can corrupt the assumed accounting in
various ways.

To fix this, the mm should be kept, as you did above. All the code
that is touching the task to get the mm should be dropped. The only
purpose of the task is to check the rlimit.

That in of itself should be a single patch with a clear description
that is the change.

Beyond that you want a second patch that make the vaddr stuff to
transfer the pin accounting from one mm to another in the process of
updating the dma to have a new task and mm.

There is no "underflow" here, only that the current code is using the
wrong mm in some case because it gets it through the task.

Jason
