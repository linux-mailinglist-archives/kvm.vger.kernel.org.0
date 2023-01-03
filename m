Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6265C2E7
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbjACPUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 10:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbjACPU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 10:20:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E1F117D
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 07:20:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKmkOe8JM7+zzcB4NBcP2ckqvcIQcGqq9nxzR1vCogt5ydWlAPg9UL6lqASNmnHNQ1LMSVKIig5UpDrwv7UJy3mgT7pYB2frF7uqKsqRUV9WllOnI524qGuX7Q65ttdbACM231soY641OhkX0cVIgzIJybarBtX+8t/7NnLDAH8UZPu3dCcZ3WyTDqt7pWY/Z3bAG6H9eAEhVJi5KaV0UZU63sFuZBPfdtpYSMTqgj3gq/FU6tmVRb4unkJKEw+j3AAcyO7V0bqrZI66+xRfaACbbRC0Gs0KUOauI5JMC89ERh23Zq0U3rcZ9kG1kOqCPtNP3ayrIrNxmKqNDB97RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ivojQ7ZkMTmay2O+jLganTQCBMi5fpnSb8PR60afNM=;
 b=A+msW/N4As1d6yhj2lLDpxcjTiqz0sPBmjgX1gY22w4eyIYj3Qiwf5lsBOMW48I1ZI1lAB230Otpf+iYV4TBAM4XWpeUTmVLC8yI6zCFbygXehhZdY/blwgZ4yvVSK4YrTj0yO8zZPidTdm7Uy6ffLolkXQAw6OxC2Kn9IqQWNe1vF8sp1u1VJZTQJWsVjxopwEL76MIAhVZ8wyTO36eOEyefeUKEMAo0BKebMM8Iz5qsXZy5zLRm1Nr7RAJtLehlMdC2weV37Euw0Jpc+Wld30GmiGfolp4LFNaFCt9GIIEZ9MetAb5lygsZMVnnB8ypDWwgTfej6b8cyZkbCeDLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ivojQ7ZkMTmay2O+jLganTQCBMi5fpnSb8PR60afNM=;
 b=Utjv1DBL1CAUiIa76rHP1p24O1Xu2viPxRkn53PX/WXHVmGBuc2/+/Ayh3vsSaoKzuxnT4PEqQ1SDCsOMlhYyveL+q30HLqoiq0yqYEBvPrL+pR3LrfJDii/04LFJPOfolMKg3QrjeIisKu0Qe+Sq3FHlowqH2S0I//6bkHdfMarPGo0cW25qm5jOddGDKktHxcDDi/eTqIdsYWURwabvtl44P/KLrIKAdYN1w0w45K+OkkDGeG3pntVCzamEkRiqsaC+UwtYk1QAR8JoiyYZ4uj6daqtTRSL0kXM8n7qp31Y4CYZtWAunL2UPzxOY2hPMkrPShlzCfZKq/N7Zr69g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 15:20:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 15:20:23 +0000
Date:   Tue, 3 Jan 2023 11:20:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Message-ID: <Y7RHtRnHOcrBuxBi@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: MN2PR15CA0043.namprd15.prod.outlook.com
 (2603:10b6:208:237::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 15bddd0b-0824-42dc-42ec-08daed9e0864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IvI1yLBSnOWnbrDIE5f5Ds2f/o1wY7Pc31PScI3zHc9EQU4fvEQd6zu4V1LXMwESUm8y7BhdDUOYHPf45luq8Bui3gc/4iaTk/g9Hm77ozQdGpAL8l7FEq2S+L7y/DJrFhahvVSCvwSTIwuqZYXEaVbG3+jzcXh5ffsrhAc/DKl23K4QiDUmWLqM0gYbYyaAoSWICaEH8/4uxYmzpi0OVqHuN1MxrIgcneCE2AljUCoy7rotkthlIVQQkvgoewfW06H5HJOa8Ahigd19qgK8j818beLsK/G6kqz4bykbUHKW2cR0JFHeltki3lD1Ob+mdwWukI4xN6xaunVspiRWXAnHwg7f2juLyMwb8feWAnABa+bNO1955MlDLeyZO5DokeC4p2olh+CX6eOQ7qE8BKfCbkHe4y8aqASif1Jd0BbQZ9uMn/SwD7W3A6uaaYCQoqyVu/+NVAGJcXiMiGSA76FMiQSYY/rTU8bQ4RTBMdmw5w+d9BnwPcV4CCkHsEZwyN7gCtCP3v36A95+ySS4JpQ3tuJLR61fXYMPl2bIfjSleYdI1DeCj/BrK0CI1spotr9C9dVShSEHqp1A9U1p7CByf1IL9qYQYbc/tgqpFWaT7LOQWKbJjP3XeDHWXH9lkIzE8O5qsK1Xni5VkE6n20ppZPaMF8OMw5P6pgCpnDDi/iCyuws7HaD4EomKCnxn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(41300700001)(4326008)(8936002)(8676002)(5660300002)(66946007)(316002)(6916009)(66476007)(54906003)(2906002)(6486002)(6506007)(478600001)(66556008)(86362001)(2616005)(186003)(26005)(6512007)(83380400001)(38100700002)(36756003)(22166006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nLLSlgTR8OPeY/p4mUiCaxvZM3BhPSAjJjnOpbqd2dedRoyBOIeYvL486s5H?=
 =?us-ascii?Q?xl50agAL5EYlrPfOBb/2GGsrko7PQynGvWHauOJc6u9eQ7bVbueeZdai41RC?=
 =?us-ascii?Q?4sZMfH1W20T6TlwMIIIwD2W2eVgANugA6PxVzLGcfAacYXpu2Bm25R+TwQdL?=
 =?us-ascii?Q?jNkYNe3gUEiUGujC3tvivbnh/m//YLqSDWeUbszQhNiCWyz0AjecLijOb+CB?=
 =?us-ascii?Q?zdGANoXaYkX4h++CjWZ6ZQBnHjD5fMYR3xIi+8fNs7dG8HtqJYlbP2KfxpO7?=
 =?us-ascii?Q?VjoOPyZ7jkOhiaf+J/NSvkRnCW1Q3wQhWi9RdKHaOy8X3XgIkjZaME0Se6F9?=
 =?us-ascii?Q?YGuXCoRdPWe0wbMt/fOwZVBV81qmsvoJDwmSuLObFrGYCgIPxxkmKYP0e/wD?=
 =?us-ascii?Q?X8wbOf6Q0VYdJAmXxdMoIUyNj3dXYvhzIeNNKbnHrspsn6xxNWsoBSeMFMln?=
 =?us-ascii?Q?8plsTBcVeuQHT25lObSjbvUMKYPJ8MNsvwwH59jBYDudMdTw6k2OC+ROc1d8?=
 =?us-ascii?Q?rWTUHcwy/LfacPkH9m318Q1ngMq+AU1ElRJJtCwUn2HGN5k9mIg+hsk1ZxxL?=
 =?us-ascii?Q?/7bPD5ZV1dVImajuvkhMHvTcG0UGETpYOrtxy+4Q95DFoFiJbJESjFfQ0DtF?=
 =?us-ascii?Q?wG5r+3HJWStchISjsT0rz5kr4NwVirHIJANcrs6QJaEXgzgqilQ+l+jciKpI?=
 =?us-ascii?Q?hxArLxzwKzgu8CNpQMnyO2zDwDVWRz1kiutoLp2/OD4ollOAUtl+5N++RSlL?=
 =?us-ascii?Q?h9Yu/QrwdXwnJCwrWqWGcImi87reuC7NDsDy4aetxSTQqrZc+D1DKzuNc8qi?=
 =?us-ascii?Q?4xQ+ji+7x5Y0h2QoPWuVkR3NZ/IG1UkMzAVPN/myk57bNan68kQRIbi12dI9?=
 =?us-ascii?Q?g6gnhaPoyt4FvIr0arOfm1zsAkO08gm3KZN7gJ7Zidznd4rW9SmmIC8qI5fl?=
 =?us-ascii?Q?ksRHBAKgx6IuwQfkyR9bWwKUgxtNozb5DK8oHIdinOMFbFjqSE5B4tpVG0n6?=
 =?us-ascii?Q?a81zNp6CHzbWDXcD7TcB6H/nO8+WcjnI/nRRJYH1xB/u5FURuV+z9+sm76Rw?=
 =?us-ascii?Q?DWYwCrAOP4gUTP5obsACKcGNX2LKJ5p1lHR5otIL7/wDlSGJnG6oU/sUvquQ?=
 =?us-ascii?Q?87mXxculs5zgX9tkK9AkksH7fFuvJqMjwkCisSXLzNSAqr52UatDKbH+1TVK?=
 =?us-ascii?Q?TapNvOjQPNNujpXETZLQitaKnnvIWn0IYhpgnAb+QxpkLHevRi5Ph/vekGfz?=
 =?us-ascii?Q?C2ti+CywJvwB9+qhSFmTHi2NO7OTUSaZ6KsyqcEhhqBqheW1zLDqOdfe4pwv?=
 =?us-ascii?Q?egPVw/XiZSrUzackvVDp/eTjItlFp/vsPVsETSmUNv05lfr5SkFn5uGZLkYt?=
 =?us-ascii?Q?YqiR+kCq+2GA9L4CK8qxFaep94lJMJO42PDdkOvbsH+1Yl6Co6CXGAYoGinU?=
 =?us-ascii?Q?MX7krzS08J7DgHpDzneaqfqmJZn5MnB2Ae28KNYtI1R3rpQGMtRHzIPvKsyM?=
 =?us-ascii?Q?Pa8gt5qBHCW38tolXETrxM2To4QqWrHY3inCkGDQCeFf0UtXPs7Kj1sWxixo?=
 =?us-ascii?Q?DXmxlSOO/xULAKKAI0aDuwJNhadV3G5v+QSpVtco?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bddd0b-0824-42dc-42ec-08daed9e0864
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 15:20:22.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cCEGAKi3eExStUs1AmF/j2ts7Jgff1xM92LcxJEi6WpCcIQR+YNE7OXSPD10Cma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
> When a vfio container is preserved across exec, the task does not change,
> but it gets a new mm with locked_vm=0, and loses the count from existing
> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
> to a large unsigned value, and a subsequent dma map request fails with
> ENOMEM in __account_locked_vm.
> 
> To avoid underflow, grab and save the mm at the time a dma is mapped.
> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> 
> locked_vm is incremented for existing mappings in a subsequent patch.
> 
> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 144f5bb..71f980b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,6 +100,7 @@ struct vfio_dma {
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> +	struct mm_struct	*mm;
>  };
>  
>  struct vfio_batch {
> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>  	if (!npage)
>  		return 0;
>  
> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
> -	if (!mm)
> +	mm = dma->mm;
> +	if (async && !mmget_not_zero(mm))
>  		return -ESRCH; /* process exited */

Just delete the async, the lock_acct always acts on the dma which
always has a singular mm.

FIx the few callers that need it to do the mmget_no_zero() before
calling in.

> @@ -794,8 +795,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>  	struct mm_struct *mm;
>  	int ret;
>  
> -	mm = get_task_mm(dma->task);
> -	if (!mm)
> +	mm = dma->mm;
> +	if (!mmget_not_zero(mm))
>  		return -ENODEV;

eg things get all confused here where we have the mmget_not_zero

But then we go ahead and call vfio_lock_acct() with true

Jason
