Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1553667D64
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbjALSFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240250AbjALSDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:41 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2064.outbound.protection.outlook.com [40.107.212.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7E25C914;
        Thu, 12 Jan 2023 09:27:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDMxsEuoY5b/D8HBIH/+I6dRcg8oH2hSe6jlHC1ZIbTtPogWLUbE13PS12Y/6MGIQa6kXpte/RF3p4guwH6FOgCPrlIrNeT7fc25i1lUPYtiPaWua7kQPAMKuaKBkrGd4IIfPzdiz/SNUDNEYUI4hTNQZHoKLL/eAoEVkViEBKKpP+QCtb3Gdnb2Tnss1mbEO9rgvv7HrUAIH4m2VJ5bR8tnu64DjFFguFQN4Pa4HTAk4MQLccXx9yl0fWtV2UgAHFD4WtTjyKg3C19frHhOmytpN+3pgWQp1ICEclKzdkp8Y0DBVc3i0wEzhbS7bD8zSlNjKakBHnK9DEKddY3Tfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgG8s95c5VJmO34B6QjgfBvoCz1p0SQOx5xuTgtIwWI=;
 b=XSGjjGAWoqtsG0OtqHW/Bm7eZWZb+vJh6MIvOYE/xHi29s/hhH5K2fOja52283uEuO6cSE4N42WLqOcO/iPLqR3vOYB19+55LUf0LYHta3cl8KAm+G+6gVZtXguJDr7BVwLD2ARPLei43r8swGw0VnX0PWB1BpkRXeem1j0c045KlHfLKgPUf7ym1Mml+pbbpK0RHXeSxV2ZYY2rKM7z7usfsezb6b3GH75Iq7BcRV9l6A2GIL1s3jwzzupxK0hYZnQLqeKAYvma+JmLvEhizbn6pwT+Ef4qMXZ8jA1N+pS4flQ7RSh5QXx1SXk3/xn6LC3Hq7d+7k31Lnhnddkp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgG8s95c5VJmO34B6QjgfBvoCz1p0SQOx5xuTgtIwWI=;
 b=uUdT2yYrRxuy9kV6JfAra6Zbj3yZspNNWqmDGTpQNlCVXNkmxCYHz74coU68B+XB8EN8Qi/7N8Zc502EZqmYG/xMJv6bvKbHaWUD0zZL6JwcY1+h3AaEYo0Fac9A+esJ2Hy1HhMVe0laS1pphtbH8BVP4NAdCWlEee2lVcrxPHM0F0yS0Pr1XPqK507dF0E9JHadmPvkjBHXH/6fUYqE3FQTjlrSRnaN6ymnHh9RbNmBSrwokic8zHqPAAZSaUM0CZlanHwuXdyMDIS8VNwRhoOS3FqBbmJMMPWpHewb7F+8yw5efxKbgzJPdFavJS/j59O0cIpAjEq2+XNxxv1iYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB7463.namprd12.prod.outlook.com (2603:10b6:806:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Thu, 12 Jan
 2023 17:27:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 17:27:42 +0000
Date:   Thu, 12 Jan 2023 13:27:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Message-ID: <Y8BDDQi9W86UfszF@nvidia.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com>
 <Y78UCz5oeuntSQtK@google.com>
 <Y78Wk2/P5+gLMdpk@nvidia.com>
 <Y78hzsHiwaFpL60+@google.com>
 <Y8AA8r5MzKQIF8I7@nvidia.com>
 <f7c39317-92a4-520e-8e69-a8606cd40e9a@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c39317-92a4-520e-8e69-a8606cd40e9a@linux.ibm.com>
X-ClientProxiedBy: BL1P221CA0011.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f46d4fe-62cb-4b14-8df2-08daf4c24f6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNeLnxMM39MrrWEa4uEn8eEcAbGVCUonAJJR48nXUsHdr2mpyBiCzvKTaqRcQUq1B63Cu93KYscGooK3q1rjP9hbjUGv32SVctsq2cxsW8pAVXLlU4e1dSAVwE1mbVjLez7cfI19oBKFCztyBFu8xpjSYy0mldOFvZdLrQD1PUHZvp4cj6rQuZHO4K/hVdwDtH2Cq2LVp3P7f1jr2lcgPkN64SiHB6RhHbiUFnd5jbulnGFqyBB2YY/DJO5MUFfUcNdQT3A4pQ436B6bpGqSLg9Z+vtWQmvUP7obk5W4jRrsfzb19SvyAd4ezJwQIVQxPfiKxT11ooazeCvBv0eBhsnGBcvhOSS6K6Vq2JDrWaa7ue1B83e/qwuYRJwhArc1Zl1P+W6m9o2q/9a0lZfc3opr8qkMvSv7h4tKpafg3slfw2eiXL1q6suJDmb995x1iPkpwBAymUmnHjEsNZQSK6ZVLSr3HpD9kooZK1SayBQHi4HdSMJ9oVx7WLnZaEW3V7/Z/jDpR6lLivdeY4UC/UJHNSPx5ubvI0kXjoQWrmgMU7Mva0705wVlO7WUwzCPCiRctpQsO+50RF19zW9YhGJiuPVKVpcELl9MPpyYqItYcAuU1/0nydVAiZI4u0SOcQdFUxiMnFwAr7Dgr1pr2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199015)(6486002)(478600001)(316002)(2906002)(36756003)(86362001)(186003)(6506007)(6512007)(83380400001)(2616005)(26005)(38100700002)(8936002)(66476007)(8676002)(66556008)(4326008)(6916009)(7416002)(66946007)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6P/K9OMRkVNoyLk6BMATJ58EfNc6TAkKgpJJ5CG1dQYo1wuEYKORv5D2euR?=
 =?us-ascii?Q?z91zqL5R3xeua7W2UcimdehzehqBkUVWNAeCVLAMpCeklNV/bksDOQVrKZ1u?=
 =?us-ascii?Q?/hxIgKRX81cXgWR+BAooauqr5A2KboMrihaeVKn+2qjAZlIXaOf9G3llz0XX?=
 =?us-ascii?Q?ZrngCaL8G3e3e/voOvd96XCA5uRP0+9sbSXn0CqBpIm80HxKvRbAKJuHzmji?=
 =?us-ascii?Q?Yl0hFvzEHdK2xGp7JTAowmjn76T6d2DkpB1/dJapOO1Dzd+NmkATFRQQmSQ1?=
 =?us-ascii?Q?XAd574O6YrSxse39AUDtblpd5OdyGLl96BljkGIrw+6PfQMreJE1S2cNeQon?=
 =?us-ascii?Q?ckHzuWaAL/mv17lK+nxkPsnBvrbCcLnCFyk0oE8Nolbjb5nI7stexzHAwSj9?=
 =?us-ascii?Q?SpWcEv91uTh6/J+C2Nkxb1HEz8oHNiOXGejcKyYYT82dyQ4jKNHcGIIiVZE5?=
 =?us-ascii?Q?ZUOL9s16z8ESDfr794B1kNvxTTaE55hw+Rt/AiQFeb9UDkVRG5fs/YRPzNno?=
 =?us-ascii?Q?I26mWmXCFSmIOlOc46+D9I+SepIwjd6IryYF6YSypND0nQs/ibchUvvo92KS?=
 =?us-ascii?Q?zVdVh6pdV2asLRsyd+qf0H6j+HUL91roT7Mral3D5J0gTDiniqf4jXtxd3TJ?=
 =?us-ascii?Q?hj1a+6SVjhjj2TRzau3x3/KCPqfiYhjgPl7m9sOY6yazPGPhe23MoClNCD9d?=
 =?us-ascii?Q?i//lgIeFnzkSdvdQFAscTl8bHdGCo9gNmVTqICg+okVxm46+dVpF6WrGOzv5?=
 =?us-ascii?Q?e8YIBdf9R2WKFUr6OQ6WGKLxXjGIgvyFhqk+KMBvzZl/Cwh5sAeOfctPhNW1?=
 =?us-ascii?Q?Zd8a6pRyqfsHKf/mm2uS7V+8wJ/po/ui72CFhh8g1E9jS6jLEDK49fpF6ZfF?=
 =?us-ascii?Q?PBEDT3c4ZVUTOXZwQd0haCz9Z/HAa9a2C2Zjikn3nnbcNVCliVFWG0dRuV8z?=
 =?us-ascii?Q?/yFBjzCXu0TrldDxkG6gBCyls/EoFSQ9glx0T4utjv49NksyKXzy2jNzcWo6?=
 =?us-ascii?Q?7f4U+WgnOirSBMFr4G60LMEl2OgUTNCjTPYPGuPO2cWio0nfyqlfo6z7y39P?=
 =?us-ascii?Q?5NtXo/04tMea+Gzab94cSEPpvdsOEsLsxqApu7KIu94owy2HakamIdI7ONAd?=
 =?us-ascii?Q?97YZMjI6ZnUqalY0aK5cpG3+sGUJR5/+efJcAfhJvqYZPWDOp7en3dKHMb+K?=
 =?us-ascii?Q?t5mr2w9LtzL6+hhkBc1aC6bSfBDx7NJH+bYOCAzMCeB8bf45XBgaiOq514ac?=
 =?us-ascii?Q?jYaBRar0htmJ+Ku2mH92vySF78xD3sfx68r8LxTiKyFq6ROm0kohyiQ3FXUy?=
 =?us-ascii?Q?RbYAMuPRmJbadDg/zUy+AsxYZk44y7ou1cKsC2pm420jNU397LGDqU2u69DH?=
 =?us-ascii?Q?I2ItXrbH9nVFXYcE3oWxeX/BRM8llsUx8zlZ4v8z3Ppyj8Z/EJrdtfBk2YSp?=
 =?us-ascii?Q?nC9b9JnrGuicWS6iq0o2kT3vge731Yb2IOzLvYAPcfqvskBtDfBGZ8jI9YSe?=
 =?us-ascii?Q?ehBTeIPT9MEA08/une6/xj5W4x+T5oENHo79/F1ybmbBz/KN6mf4VLFME6wH?=
 =?us-ascii?Q?gjpU8vUmZuFZKVHpikF98Y73Fe52Oc24rAlx1A4B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f46d4fe-62cb-4b14-8df2-08daf4c24f6d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:27:42.2740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++ipFJ8JeXQ26INqwLyhOglearOHip6ePI6X/XAw1w/mNmErT2SxLOD7MchR2qzz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7463
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 12:21:17PM -0500, Matthew Rosato wrote:

> So should I work up a v2 that does symbol gets for kvm_get_kvm_safe
> and kvm_put_kvm from vfio_main and drop kvm_put_kvm_async?  Or is
> the patch Yi is working on changing things such that will also
> address the deadlock issue?

I don't think Yi's part will help

> +361,22 @@ static int vfio_device_first_open(struct vfio_device
> *device, if (ret) goto err_module_put;
>  
> +       if (kvm && !vfio_kvm_get(kvm)) {

Do call it kvm_get_safe though

> +               ret = -ENOENT;
> +               goto err_unuse_iommu;
> +       }
>         device->kvm = kvm;
>         if (device->ops->open_device) {
>                 ret = device->ops->open_device(device);
>                 if (ret)
> -                       goto err_unuse_iommu;
> +                       goto err_put_kvm;
>         }
>         return 0;
>  
> -err_unuse_iommu:
> +err_put_kvm:
> +       vfio_put_kvm(kvm);
>         device->kvm = NULL;
> +err_unuse_iommu:
>         if (iommufd)
>                 vfio_iommufd_unbind(device);
>         else
> @@ -465,6 +471,9 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>         vfio_device_group_close(device);
>  
> +       if (device->open_count == 0 && device->group->kvm)
> +               vfio_kvm_put(device->group->kvm);
> +

No, you can't touch group->kvm without holding the group lock,
that is the whole point of the problem..

This has to be device->kvm

Jason

