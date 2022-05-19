Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396FD52D28B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 14:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiESMdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 08:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiESMde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 08:33:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B828A5A8D;
        Thu, 19 May 2022 05:33:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZdBFm7bw7dEGjOo3OkzXYNlu+F4TcED2jf6A43zND7/kBT/RFj0m3EWegUjE9HizKxS+hz4eHzHzEhR/F5Zpu4XovT90L00Ki54XwMKWVb0ThDLnpANUxaogtUKI2zOtaRDiU7JczrDYlS5/BaaSLTdKFm89WFQUpDlRZUfHVZmgCG9WERu/9ETY0c4b+TZdgeSp2MClc/HibehC+/qsdbiMj33kHhgAlR+YCm0YeiMx/NIK80Oo6QCJSvm73Kg7/j2qWY+fJm+naiwi39sx37bpHmWk5zyyDI5ptg/R8h/S54GiIPGAaUZYoR2ZhxmV9Yg1Uz9eQvCfVrFlp9pxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QU2nDcshoWncnVsYgS+ayp34ItuwYSSqm+NPwikmTyQ=;
 b=dxvD+cj1W1djVdlw/wcjVuQv1+J7scUEzBl8zAn7tQwSbOSel7K5sYDhjSv7Zf9UsAZjBMewD8zjqxxEh05+JVdol/VYBhInZTCiqoxmWIoYOPOw9AM0Ua0E3hYHw2XUquQyz9+m/DXGVLwQ6qOKCDdRhvgfTqRfjPBciqIxHId2DAOqaAkgve/lHXY9rAGr6dwgUtA/jp7f7mnTAwuqtIEmDAXq+uBAbA6IUplJve8JLAizKSsiRiYP3oFjM0E5gSfWxxZYoOuoNyDKJ7CILPsja5tPRbltbbn06PxkJ8k7GAZlsIwtEU+WVKKuxgPmBrPYFx+FASlz5Hjsx0YrVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU2nDcshoWncnVsYgS+ayp34ItuwYSSqm+NPwikmTyQ=;
 b=Pdstg6i2gIcxZvKfRbdaCLLrkBZ4IrrvQgJB7WVPXp/9Al6ksuFpfZDDtfI05TbtCKHmqletn9Gi86kjLuKbCPtEbHZlQMsvYD+ueTimdA0T1ROBJgSV/8KJyw2uENY8On+XiLrDnvNkxR2e08z7VP8f9ZjvIZIg1VmNyS4tWbEklxsCW9nE0iIlyhJw+uU4AsdGsYHlUVDlUYhuXcQHt1HifpIe+/qv8PX2pj08+iqZU6LlqVxq2liIn9XnqhhbImIzdS/pUkaLyyqkEN/W4bEN+c5tObom59PhZEdpn54OmouGaHRF9RtedsS93oMTOByQTmYvbOX0WFtCkxEHgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB2684.namprd12.prod.outlook.com (2603:10b6:5:4a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Thu, 19 May
 2022 12:33:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 12:33:32 +0000
Date:   Thu, 19 May 2022 09:33:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220519123331.GX1343366@nvidia.com>
References: <20220518212607.467538-1-mjrosato@linux.ibm.com>
 <20220518212607.467538-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518212607.467538-2-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL0PR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:207:3d::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f13fa0f-2a61-4ae1-e1e7-08da3993c93e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2684:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2684D4456789285D4429618EC2D09@DM6PR12MB2684.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKfhgraPmF5blb5xVYfEnYww46dA3jwCEzilCnltqcxZIAOUAc55OhRU/1U/J7Bwt0+qKtGVm7jCWdkqRgjOQkfQvBadmqZT3z6tJ7pu0jVNsERDGgWIGaXHonvxepMlyw8+cl4zA/dYmPisHphT7Kn6IjXmKcpDCengIfd9HGM1F3fzeI+6hK3f/RIArybH+52gsoDY6SkHMDbM+6TmkvN0ukpxTdsHnT1g9oO/QUdHX2vIU9Kl8ZllOCG+0T5nksp721w1XpME34f+0+wQ4cY3rTY6MykJ6Z6wYzDCyjwEGkuYM/6aE/c7fdMP0aGm1ICaK/5/xiGsmRv3t0LO1wgmPHoAxVolXwehXNYiAR69Kp+V1Vv7x80KCtygy9XfoGRH9zSnVeGeXeJrPJK0t3zgBfee23+kP4mn9hzd2zUWkdrfw3+TslVl5qe1l0y10VrizeXxf3BQYFIsqRMkN+huLoCsrE2Fa6gwHYd0EZwqNUDxfs0LkmtNGYhLNVCahSNyjgWcuENbCB3nKzMQRASPm3p3usKxlH1wjio8YsZLIW04Fg7KMaWIFwZUJDQ6azA+3AaPjhgyuFOfV0Bs2gVoCUZVO7lhzuXwwYPViv/dmQEQJFgCXvj2Uf3TinMsMD5fZSyzfJZHkjIwOqmmTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(6486002)(6916009)(38100700002)(316002)(8676002)(4326008)(36756003)(83380400001)(66946007)(66476007)(33656002)(6512007)(5660300002)(86362001)(2616005)(7416002)(186003)(26005)(508600001)(8936002)(1076003)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJv+bq89jh2MpxDMrXMBoCEDgwTml70qavvFOmGq9Lm9eSgbv6lnASUtq420?=
 =?us-ascii?Q?uOutmf1E1lVKZmU12tJbRUha14w/BMENWiClPorjWOpUtEhJWB8AdbH1SKVE?=
 =?us-ascii?Q?r2KUhkth5a7x/NcgWDhX8ugJ6/tlufiG0SGyV/+E3QVw2kG84Rq6qTnZGQkR?=
 =?us-ascii?Q?8/mJVES8uYm79Nw5Y5RMpnKshJz4yR0UHubizmKKrJImJBZZGjR/z4ghE4Zs?=
 =?us-ascii?Q?Puf7hmG0Bf3R8+Ju0QCBGdAWlNb3cnLWJXRIUINxf3qJio9d3HsBArVMjaSR?=
 =?us-ascii?Q?lOdhCxouc6Q12Dka8CkFy+suCaTvTnjy6RCj1R3qzn2yefxeCk4aMHUiwTyQ?=
 =?us-ascii?Q?mWm9S5aD/xjJPfk+ebJw827zC3hHhevVBJ5KmX7Wc8BI0/cQa5rc+y553Sde?=
 =?us-ascii?Q?HML4pHpwH30DvO1OuuXTViP1HV8RLiXEUUkUqpF6uc/9rTi+gJVwQMpEg7Sp?=
 =?us-ascii?Q?XP9y9l/QbjDrMyOB+s3RQfRNqaUIqd2xhqPCHxQrGJ3nAJOrtsy4o+97SzqL?=
 =?us-ascii?Q?jnAQWBmZjDs/TKBCsYUz0uAlKDZLAiQreDL1vNsBdAkOsxaqexdwPod8pjBC?=
 =?us-ascii?Q?lkdtz33NGCqjVD/if9oECtBTg5Bqtv3GOYPWMDt6rI6RuhMX1d7UialH9WSz?=
 =?us-ascii?Q?BRYeWRCwPxyTUfI5kS3NZrc1EGX5ALZF0Jea+/xbK8dAk20nmTFXhkPAMFRy?=
 =?us-ascii?Q?M8dIZ9BANwxzKZpvC1wBE248JPzTjiv8DnrDD7/Go/loxZU520QLQsrsm76c?=
 =?us-ascii?Q?c2pPB9m/2p4uWc4mMlCq/axhUXpgBMwXPoRYn4j/wZxtQqww3qOCeGRz8Zqx?=
 =?us-ascii?Q?/qQRGr1FPlW3sVGK/0Zx7mYM3RsYJMRAMsR/yqQ8hKcKOi1/s9J6MPULmUJO?=
 =?us-ascii?Q?Bj7bRKAyfCXvNPWAjKRATeLMvZ9UsID7FVTu0lyn+3/culHcIFmGa7RRPmXK?=
 =?us-ascii?Q?kS4Hr8vcw9lf58wP1NBITDV3muRLzSZ5hBb+8+SU1Q+mm+12jg5dU45Y6QH/?=
 =?us-ascii?Q?SJWkjGfvoioSv9J6+P66+xdLGnj1I1InXiV+h+YNk6pTm9oftDaoAYVXmlFe?=
 =?us-ascii?Q?caMYVJ4fztZF+oMUZ8qT/5Ga70I130F/xM7O0c/J80JOyjrxkOXadXgbpxgB?=
 =?us-ascii?Q?ZgPdKIYy4rEceZkT7cQ1VoqUN6ZHa3cAD2w/tFKxtCpNO2S6eBT6q8OGelye?=
 =?us-ascii?Q?+dwjIPhl6CfIJ213uwukA4fFWeOlG5oxCXu/qUBFEwvGsdu+u5bvNAns7f0H?=
 =?us-ascii?Q?XyuskH2aQPdhn6P6LMwBo6e7VyJsnmY9sxooFeJKNOCw762oUMy3dPKNiPiY?=
 =?us-ascii?Q?3+7l7XIjtlUEYTzzJd1C/Dvn1eOr/7qBEt6H7m/vpsJiiCR0O67xBM+ajlUN?=
 =?us-ascii?Q?FF4Q1efJZrujGkRVE7GXAhBBDVszhaOBZn7fqE4YYzvix6fTNz+YlNSXsH8K?=
 =?us-ascii?Q?pdDL/HtlFVEJMcg0Cte9wn7RSdLucdId01jGLsczTZnZf4iKfIcKeJJ9JXRp?=
 =?us-ascii?Q?UVBLodGE39TXb3IUuRZ6X7op+Kvve16GBcC1sY2c5juPJZhSPUbPZzEK9NcC?=
 =?us-ascii?Q?VNML3LKCAMUmCWqIG9GWJc4OIbYbH8m7ROnBajHLrcLcSSu0M+aYx7hwJyHs?=
 =?us-ascii?Q?wIrO3noaUz3wZhkkvnWl+UwT62PY5jLLb/bRvapLHF9jMoxVCjhiUPI2dyLe?=
 =?us-ascii?Q?YL8ZEH/+uZ3r9aATMfeGIlYetrVbye9IgGR7BfdiE6SXdFkog/Og287dA3qk?=
 =?us-ascii?Q?0dPMicNQSA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f13fa0f-2a61-4ae1-e1e7-08da3993c93e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 12:33:32.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/5Quyb1iblClBL5aR8IfFcLtBmUlgSI9eX9CjeV0dk1W1jjxDK0pXX6wOh1IxIm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2684
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 05:26:07PM -0400, Matthew Rosato wrote:
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
> 
> This fixes a user-triggerable oops in GVT.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++---------------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 38 ++++---------
>  drivers/s390/crypto/vfio_ap_private.h |  3 -
>  drivers/vfio/vfio.c                   | 75 ++++++++----------------
>  include/linux/vfio.h                  |  5 +-
>  7 files changed, 56 insertions(+), 154 deletions(-)

I'm fine with this, thanks for finishing it

> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e8914024f5b1..17a56bb4cf25 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1196,6 +1196,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  {
>         struct ap_matrix_mdev *m;
>
> +       kvm_get_kvm(kvm);
> +

[..]

> +       if (kvm)
> +               kvm_put_kvm(kvm);
>  }

This extra ref traffic is not necessary, the kvm will have a valid ref
because we are under the group_rwsem here and then the function will
obtain a ref when it stores it in matrix_mdev->kvm.

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..272acb62facd 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1083,11 +1083,22 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  
>  	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
> +	down_read(&device->group->group_rwsem);
> +	if (device->open_count == 1 && device->group->kvm) {
> +		/*
> +		 * Here we pass the KVM pointer with the group under the read
> +		 * lock.  If the device driver will use it, it must obtain a
> +		 * reference and release it during close_device.
> +		 */
> +		device->kvm = device->group->kvm;
> +	}

But it is a bit ugly to keep the device->kvm in the struct device
without holding a reference count.

It is probably worth adding a comment to the definition in the struct
as well that the device driver must reference it or never touch it.

Jason
