Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D7F6A498F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjB0SWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjB0SWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:22:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A3310C7;
        Mon, 27 Feb 2023 10:22:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0IK/m7ghCVQhUJPFKC2Zv5oV/25+/yeRS/lXIgMClLbYwkoaSuti9G242PHPHZR7wY79K1kkJ+N4fnSUm/KRWdFivpYUsDSmprmx05+f+upaiHTYSypjrRuX6MBIQZl9t0hb083KqrAucFYD9oRMLJMk4bp/1PyotnQ5Iblk3Zk3qNZeFvh0ZK9JmcVDbXDzPayECn549ALtDRCRInwcTN1qbM1k6fXskUa1KzKz1r94lCaJVaS9ohQ3lnvasEOfMy38VC5GNugi7EOVGZAvm5N2FusMzrcJDilF3utxDOLYIm4B/5z97U6mfiHG9BZZ96ywamNCncJnfnNGfkKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T56BQAGs6xWwEmDnpHBVlEdeQ2wnuoUaNVdAffRlQGY=;
 b=eV1uM9BofiUS69MOiHwz6668a/tdq3pptui0lny0A+FPPtqZfHSEECHLAaHfnu92VTa6YvR9ONNNfQvt/q1zRgj1LN4DrWuj8dWG7PxCk6GFMJXS4PytfXhsWzZAupGi0Bhi1aSrwdm+KopvgusKLhmVSAPXeFl0Q3YE8FWiEpWhVCJxffGsMrRlnnWhcwZhsGRQORAS6ZYcyTvN0XpyvAVF5ufG9LY/j3W2ny5rlsTWcIkR/2tEP/AM+U3rQb9vlO+lPcCZbjtHJCqVa1sFl1nHqOWDc8x5KDElOQosfQJCckbL9W2BdjlGkwcsqzMyoG1yLBy8K+O0nwRZofjuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T56BQAGs6xWwEmDnpHBVlEdeQ2wnuoUaNVdAffRlQGY=;
 b=JYODY/+O4jPzpWKH6KISz5/k0Ukiw0fZaXjZFNFaaFhctcl6eKf/idWTgb6dqWRE6Oi4wcWlgc3vgRSmxIoA6NC4cfuM6JCPwIo7vdmed2ZjxY2w9Ah76ZNd1w3uKsHkkasS0Pqr7mbKEJCxiUi2870uQo1St2kcdaXIhxeOemPNFnJsq2qqKstRdUODdaYaMIykIflsWAP0QvZGpD/LszKXas/fNfdCLti/Vx1rFU47mrjDz/TQT77dlZU3V1jiSsIC8cXUlAY2uWpPzpxArg22BnLEbnO091GSkWdG2LHMhf6GrGc6MT4ikVnSIwTepD+rA4X9x6tCKyW2E8T0oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 18:22:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:22:47 +0000
Date:   Mon, 27 Feb 2023 14:22:45 -0400
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <Y/z09fQAW7Rs0uIc@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-10-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0120.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4118:EE_
X-MS-Office365-Filtering-Correlation-Id: 6811c882-d244-4ab9-5aa0-08db18efa061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KafOiOoigqPANGcgDRHyExRuX6omgKfu49KfUVVmgjc+LoFIF3WYbKl4uMxZVL6DCNCjWfE9Fb8HSw+Em3FzCVMMnnHBicMyxUcCs5I3WOqvy37l7l7f0i78AV/YYKO5VbRcbEG+TnP3FaqbVJFQlvv4g0Sz/GSzgITb+Tb/QypdXSJ2TGbRzZ51G9HttZMJNyo2mpZQVRQKrMdd0uP6qAdOuBklxI6j/LiE6fvXh7MqOqdbnp1pmJVyvyPhIwpRf9o3ovXd4LAtDwzSt9zkOme9CsqW/m1Xhb70K/EnyakO1z9HuARBVtyEUug9S8GK5i0HUDlSI6ncVMBb2u6oFyUTWUWQkIJ+h/Mh9vpQjnF9oVm3piW5R9qU7r80y7xhGM8WNMIxyihpT4T2L9MHSYa91sKIZFr2RGGcQkyCf4XPTf2lbWVzVQdSdM3r1Hpgd8bWSM4mK0t6stYECbFZYqo8vGGlp8OiEYPYiCAue/RlHxAIutzGt93voEh8LvXjeSaso4TKfOzFKwGPihE+t8+Wqz+lbVMT20mFTmqMHGZGyMJ5nZ/yMhjakBNSg/BgtPGSgCI3G7XePAQn4Kl0zG5RH5kzt+JVwnNG8ixo+NgGjVIgG2wxdykc6z2fUr/xJ1hbfTStghT+9VuQbBjVCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199018)(66476007)(6506007)(66946007)(66556008)(8676002)(4326008)(316002)(6916009)(6486002)(478600001)(7416002)(36756003)(5660300002)(86362001)(2906002)(38100700002)(8936002)(83380400001)(2616005)(26005)(41300700001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCa+Z6rI3rSq9+A1PfPRH6sMtJGu404Ba2js6HLQboJN8rvY8mOYkEFaGVm0?=
 =?us-ascii?Q?ufcwptrSFTZqY06r9aXn5l43D48GGAxRMFLvO/EgaFfqAExFt+EGX2llCcLd?=
 =?us-ascii?Q?7+DW7quJXJFsqM92U56C3EIEqgMdSTFK6YrY3dLlUTeWpyTUmJGLtrr0HHdC?=
 =?us-ascii?Q?WKO0Rq9KKgkn9yboxH2eVxqujnKOwgJZtOhe+dpi381KB6rBzYwEISUmjucp?=
 =?us-ascii?Q?o7Ch8JPbSNDFw4fjZbj6VBzp14fVYP3ctrUcnDUsPn2ytqpHY/08QeNucseN?=
 =?us-ascii?Q?sqqqISlGfBi4abHlM7CBE2EQFWEeyRQ3DZJk0Fva8sYKG6T358DzSHMYbj47?=
 =?us-ascii?Q?sdcp2DNtVktnOIXpcxY4HIlemxdcllTnkwxnB2eDa0fsbgKFhVfwk0/dnfXB?=
 =?us-ascii?Q?D+OgWXpXDwpqmwKH+ufO649H5TSz7qdm7bF3aV30iE5AO0rey9xa5g+bh/NS?=
 =?us-ascii?Q?yXa5VNwmDJdR4SjJzOVbMqtkpG/5zc06IhMTxcMFm3o2kZJrAe/k3i3mmnnh?=
 =?us-ascii?Q?0lvuqyccpVPzCazv0rri59E/ED4h+HZjvdsY47aU44y5nqHck004tFt0Sga9?=
 =?us-ascii?Q?GumL90Zoq1wiIhN/Qb5Y/o9WtAvTPy7l2v2HuKr7jSmTHgGexMDAiGEyrdgr?=
 =?us-ascii?Q?4xxEu9JWqQ58soQ3fkpGY9cN11apVl95ye2kxJsPMjcmrLAFV99nqXdMQS1s?=
 =?us-ascii?Q?AxPzMjW5qUdjUM20630uCvTj0RyzFQnehzLwHadnGa3oR4j9v8MRtmoDdOBP?=
 =?us-ascii?Q?HUFlm6Jir7Q8PzDmORqE8C8TFAMN43/wgfJ4gZSKqDJpQGbHt5GVe9EQbCjG?=
 =?us-ascii?Q?uJ6gLX2mpl1MEohNwEx9RGBu6SwWxIChV9Y7AwupVtFjR0Yi6FTUSqXsoTvD?=
 =?us-ascii?Q?HSd4XOzGcNMGwlgazbgd3dyHcxF21716ZxX3RZGV9u1UXKGDjvmcAwUH0Ufs?=
 =?us-ascii?Q?1rzp3XyGDBzCMQePw+798jbUqx8XLNfu/JefokTKNfN/2yZC7l2qaFvjQmcV?=
 =?us-ascii?Q?yRTXTN2ish7o7nRxs3zmrfxwZuzrLBUyec45uIazgQIbnQFQoPv1OpqtmRNC?=
 =?us-ascii?Q?AS98NEX9nra1c4SBzzPGL2fWVgdQWOiX+iTbXlmNKckY0lw8sf1iKuPepb5y?=
 =?us-ascii?Q?ypd0RWKKNiVz+QP/+QQwCo3K2zfIRtAwVZU0mSrw9MmArlIPnK4PoYNns+By?=
 =?us-ascii?Q?E5/+pXJQWJ2bukMkK01XhdtRREFmW2zj8YWVgDpXirBeQtwgFC5l/ZsGVdQU?=
 =?us-ascii?Q?br4tiiVIhhLgV9aL479zNQCFoEP1fWAeiA7pxg9FC/LenAKSVkWDC//ayozb?=
 =?us-ascii?Q?3OFiEyrR0W3gLJTNT1CQso8hBWQsjJnLE6+Z4BQc6kfDsSFgSNZToAmDVagf?=
 =?us-ascii?Q?uqRCM05glO9QqcspCsLeccEr1Qbe7BZGlkHz7NXsnqSpEEiIvEbwehLhM5Ef?=
 =?us-ascii?Q?aSlzEFjpX/EKgeoDW3677hsRVdWFckRuv9UPPwKtL+AEKUw+V3wt1k+v7LCO?=
 =?us-ascii?Q?bfK6AvcO+Rx57FlSAOCVlVNFNZ2vSq96Z/xkZly/bDXG3EEcTg2I2949v68F?=
 =?us-ascii?Q?bhqnXoyhHfAdgdWcS1FQ12IshYIq0V4CBJRMJOQd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6811c882-d244-4ab9-5aa0-08db18efa061
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:22:47.1916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhEQ3om7LIYCJy5KBfowTUQy/Pn93TaP7Zucsb6b/+jsMhgcPxUM3eonBToCb6ye
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:25AM -0800, Yi Liu wrote:
> to indicate kernel to use the device's bound iommufd_ctx for the device
> ownership check. Kernel should loop all the opened devices in the dev_set,
> and check if they are bound to the same iommufd_ctx. For the devices that
> has not been opened yet but affected, they can be reset by the current
> users as they cannot be opened by any other user. This applies to the
> existing group/container path as well.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 111 +++++++++++++++++++++++--------
>  drivers/vfio/vfio.h              |  11 +++
>  include/uapi/linux/vfio.h        |  16 +++++
>  3 files changed, 109 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1bf54beeaef2..e0ebe55b4df0 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -27,11 +27,13 @@
>  #include <linux/vgaarb.h>
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
> +#include <linux/iommufd.h>

Is this needed anymore?

>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
>  
>  #include "vfio_pci_priv.h"
> +#include "../vfio.h"

Don't do this, put vfio_device_iommufd() in the normal public header

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..4bf11ee8de53 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -673,6 +673,22 @@ struct vfio_pci_hot_reset_info {
>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>   *				    struct vfio_pci_hot_reset)
>   *
> + * Userspace requests hot reset for the devices it uses.  Due to the
> + * underlying topology, multiple devices may be affected in the reset.
> + * The affected devices may have been opened by the user or by other
> + * users or not opened yet.  Only when all the affected devices are
> + * either opened by the current user or not opened by any user, should
> + * the reset request be allowed.  Otherwise, this request is expected
> + * to return error.
> + *
> + * If the user uses group and container interface, it should pass down
> + * a set of group fds for ownership check.  If the user uses iommufd, it
> + * should pass down a zero-length group_fds array to indicate the kernel
> + * to use the bound iommufd for the ownership check.  User that uses the
> + * vfio iommufd compatible mode can also pass down a zero-length group_fds
> + * array as this mode uses iommufd in kernel, and there is no reason to
> + * forbide it.

'forbid'

Rest looks good

Thanks,
Jason
