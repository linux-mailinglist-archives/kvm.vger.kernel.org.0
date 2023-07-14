Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68B753D21
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbjGNOVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbjGNOUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:20:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBAD3C23;
        Fri, 14 Jul 2023 07:20:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxF9npEffC6rRJcFzVgYb5Hm1EaTIbNYXkjWXKYEdeEqiJW9VDzSO5+H8okAcb7N/V/AFHF79lzyPesjh9yC/3XpaHER3KIz3lMn6DDPYlgaRX1ZvEgiAz5o/V1Sx7DcP4E8Qp9/jd5NvH0IZ75t0mlbrINAEPG6isOy3U8sK/zdqMPYBXh2Y1Sgu8s/fOQ6PKh6F5ostjpznQ0VlP1sRQGV0NQaniTEld5y2MGbE3j2+YQbr9CAw7vl8DTuiZWukjM1sk0bw2zNshvrgAHUW0uWWwgKSVPUNOo3eeiuiJ3UMAPUKEAV1I7jd3a720js+hlTftZKx8SfsWFY0/BE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0gHx+sNROGeohouozKwADQS07kFX6//oqKxIRAyW7Q=;
 b=Wl8BPi8sPK/iyE/4u6WPbBk/aoDSUymdAk04asORDId6tJ1ccavp0aD9497qKqRRIv57WGoFZt3rTTOekjGdaJUZbaKx80TGrvtmoMxVapdm8L0OPluyUSTpQ2hz/IjToGfjRaPRySQuR6UlGJCqkoCJe9U0pZC/RLKHNJiH4bP9Z4kBO4WGRa64kFSfwz0DbkpLEyzIdn4LSfSU7c7JtKTpYUuOOFHTppIUCxM23iQB9Rc6QYbIUrFrIVgIv+AvRvdV2oNn9vTEqAOBfel+iFaJjqE6feOq0KQ2AmFT5MIz4rXk3JStvoecip+dpuLI807jl2bOwRcQ2JIX9JKDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0gHx+sNROGeohouozKwADQS07kFX6//oqKxIRAyW7Q=;
 b=D/GRfiVZfO62/aiGqir5quzsjoEveIcwFgXHodnyLkAKgIbcn//4VvVE5frrjWp/TpYCm5GVaS4Nmrwjp1QSxKX8EgTscT+DNfcO9QhxpOIUzUUi0EZXbwRxXU/zEJAiFeXMI1rkp2X1cwc8sHNy64IPPoK7emmipfkSZ6FPif00AyuL3sCCBuEuTc/tDGCtMz2w9XSMJzAU/JbIyzUyE7NxsafeLeXGp0cOBPDyREr1BO04hK7QUUy9LvjREHlE4GWRRvZqWIYYsfhRGw6mefJm3wBQtt8APzh8S/iMOAbiGQAdZVJAEKoC8sVMbwIdUkwEppAtsaZs79dsAqp/VQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5073.namprd12.prod.outlook.com (2603:10b6:610:e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 14:20:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 14:20:34 +0000
Date:   Fri, 14 Jul 2023 11:20:31 -0300
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
Subject: Re: [PATCH v14 20/26] iommufd: Add iommufd_ctx_from_fd()
Message-ID: <ZLFZr7hOTLktRthU@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-21-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-21-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 535b3991-6b09-4a15-d8bb-08db84757ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98HfLLTDZEW6kdzi3JHZ5es4y7ITLUQkp9YAsPB+9aM3FnXI4JFQvELFvG907Tilmr/KXLCzLFJGgL1t2Ha7c/DscaCBZN1kLMsqdL1O4lVHPlyQjalGF+jwHzUICbOJBcMF1/af8Hw3ihZec5sHxFjfGkKAQ+Q5jF/ZG8617BaI9ta6gpzFgPdzokXx5dU7Jqxve+XaQDwCoty5fHzcYsOhYSeGTzXppH5WN5NNrkZ7sH5kIJwxR71V3EJT7aFod6KhvzuS/X5ynKtWetvnkmRjEWKVvx53JuM2gjUhN7BuqV7VmhIIJliMk85URBqxNpULthZFbN/93aO3kVKnFCYNaClyNC4o9Htij3w+6pKS6w51ElpduRasJnwnmA3hL5PojiMFBtCQQlP2uwZk34HTYhlNw2lnAxMpqFVjI22cEsOIabrmNRzKTIHh6usjGQuFskiQv//wxvwAd/cZ9rRgkYMEsXywW2jMD+1MTd1yy34cjMSvWj+W06kZpE+17YWnsh0Y+av/VQrt5x7kDpjVV4TWCdsdkWP7z0iNq+d9Xawr2Zux6mUKeFEYt4nW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199021)(38100700002)(36756003)(86362001)(8936002)(6506007)(5660300002)(6666004)(7416002)(8676002)(41300700001)(26005)(186003)(2616005)(2906002)(83380400001)(6512007)(66556008)(316002)(4326008)(478600001)(66946007)(6916009)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wS4tIJpMxz8OQ07Zvrt6Rq2AyLVILWmlgLG9c8IQnSPz8uQdsPzczwmWoJB6?=
 =?us-ascii?Q?Sn8WNyjZvzMxp+D12t1qS5vMuhd6UKdBOMj0gmM++sXF8RM7mU5DWiK8PIaG?=
 =?us-ascii?Q?z6GfyKdo2rFy1swX+9PuLqJCzrOUbDbUCtK/UEOkFdQoNZRbi7eVtjeMZzFC?=
 =?us-ascii?Q?Uy/089L4SYsK5g2jYTVCQTb+5t9lNWovD6IT3HEkDNO/diQ2oeBiHsv8Wzmf?=
 =?us-ascii?Q?netkXLM+qyqVdkXuDjVXJ4m7CY4Qa13jgS4f0n5+Lgoet9sQVELlUiKR19S4?=
 =?us-ascii?Q?rQZF9WPJOzHEHUE2UWv68a7nBWNuJKx5RW9ybu6nSQn4yQlLrzRpYx3ONR26?=
 =?us-ascii?Q?xqlha38Kq6vDWmtvgbtxuSCMSZCEuld6qVYSOXC2YUHYDTQdLBeJFw3N1+8Y?=
 =?us-ascii?Q?APsyUAgkwRRaNhlLTnFu3yNyBDYQmCbTEo3ULQQQwoaaWCQB6snhfrHiX2Ze?=
 =?us-ascii?Q?RevNEjvF+zV3qrSyOsRa3urM1LQFr9U/6121JrRYoyzgLe5IfbumkOudx8Y2?=
 =?us-ascii?Q?kNLOaI69vKEj6zk1f7ZjiaztOIq/Erv+wcUJDuwItvyTJp+ylUhu9JP5hvIW?=
 =?us-ascii?Q?XHz7lIut2V3GrMTVImFTUv+AUJDYfBaSU8w5jdi4DHN1cqiConORj3o11jTP?=
 =?us-ascii?Q?FL0aM0MCVui6Q7N0AsGlYXih18FnWg6hQobD5dyH3PSSNX37SWve31VapNHz?=
 =?us-ascii?Q?95C8zx7CJBjOwjepGM+sv2XaYAvs9ubKWePsPfebpOC6TaMEa3fAzyJJvJtU?=
 =?us-ascii?Q?ptJ2M08g4hSnMtFHIxubx1qoXqgznRf1Kshd0R7In1/jRMqN2X+lQzMBh+5s?=
 =?us-ascii?Q?6RLwwiU1Z9+U1TPKJZJEsSg98j798vA0sx0WJPPGMaDE2dM+7hvsZweFPBB/?=
 =?us-ascii?Q?BRTLNWh7ospza1/hNfLX2vLRzI5icqvJxxxLv92DH7ShQSFQ3Uffx5f8yLDm?=
 =?us-ascii?Q?xnLgm0Bf4M6Lt9eUq98Hzil3XwHpJrgbLqRxEPKeHwBpV8HSrZKCmvijKFlY?=
 =?us-ascii?Q?CevcdEMMDms/rfUYBRwjFGLR8n7ZhDVRRfZki/yFWy8KpyIl5Qf979syao4M?=
 =?us-ascii?Q?q5I3Q/UjrrYEqc5RDWfjPfa2PTQdUzu03CSbStnWCfDQmQw7OQgkXSbr6Aa/?=
 =?us-ascii?Q?44JKwVLWedui+b+0zBd6EKiTmxziChBsd0J44su9b4C2vvQ8tdIhcLJBaZfy?=
 =?us-ascii?Q?lKnGV4FewRjTpgSkTwgrOE5SSg+wm/igMv5CNwwVl8pPfw6ERrGZEIaov03N?=
 =?us-ascii?Q?m9jaV190fwII5tpc4sBgEVvoEKhzTfE9rmLHrh5lta0uxpqBGU+WkJSNMdhh?=
 =?us-ascii?Q?6nZnhrRu/EZwYCcoVmGthPTUQH1Snf3E1AD4FkMV3M9mHGDilTektcSzDi/I?=
 =?us-ascii?Q?E1YPyG4FaZuh26bDuI5WUlxqPPi815CIoFoFsr8dQ2fcett/ooidO+tbA5BW?=
 =?us-ascii?Q?bM+E7+I/PqMFCy9vh48GGE96rHRW8HPxsaDBnng89NeIPxXrSM73NpRPPXi+?=
 =?us-ascii?Q?rtFyjRgzdACKNuslbPBd15uGu1oOUjSZtraWC29vNb2lWOP1G/POK6PMprJ2?=
 =?us-ascii?Q?miJxyQAvPNYD57AJDISfcRuA52KcR1HfPAZvyGAh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535b3991-6b09-4a15-d8bb-08db84757ca1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 14:20:34.2069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ctRvl46h45d6YM2+HXMssimX0Kpp3x9Smp78He3PHSbEBNOVpjg0QWWM4Rn/5vc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:59:22PM -0700, Yi Liu wrote:
> It's common to get a reference to the iommufd context from a given file
> descriptor. So adds an API for it. Existing users of this API are compiled
> only when IOMMUFD is enabled, so no need to have a stub for the IOMMUFD
> disabled case.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/main.c | 23 +++++++++++++++++++++++
>  include/linux/iommufd.h      |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index 32ce7befc8dd..e99a338d4fdf 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -377,6 +377,29 @@ struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_file, IOMMUFD);
>  
> +/**
> + * iommufd_ctx_from_fd - Acquires a reference to the iommufd context
> + * @fd: File descriptor to obtain the reference from
> + *
> + * Returns a pointer to the iommufd_ctx, otherwise ERR_PTR. On success
> + * the caller is responsible to call iommufd_ctx_put().
> + */
> +struct iommufd_ctx *iommufd_ctx_from_fd(int fd)
> +{
> +	struct iommufd_ctx *iommufd;
> +	struct fd f;
> +
> +	f = fdget(fd);
> +	if (!f.file)
> +		return ERR_PTR(-EBADF);
> +
> +	iommufd = iommufd_ctx_from_file(f.file);
> +
> +	fdput(f);
> +	return iommufd;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_fd, IOMMUFD);

This is a little wonky since iommufd_ctx_from_file() also obtains a
reference

Just needs to be like this:

struct iommufd_ctx *iommufd_ctx_from_fd(int fd)
{
	struct file *file;

	file = fget(fd);
	if (!file)
		return ERR_PTR(-EBADF);

	if (file->f_op != &iommufd_fops) {
		fput(file);
		return ERR_PTR(-EBADFD);
	}
	/* fget is the same as iommufd_ctx_get() */
	return file->private_data;
}
EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_fd, IOMMUFD);

?

Jason
