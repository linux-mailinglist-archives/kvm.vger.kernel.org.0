Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E37F6B3459
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCJCje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCJCjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:39:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A230AF367E;
        Thu,  9 Mar 2023 18:39:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WO7NEXx078v+/oQPc27Vp+luk291kKlQOHtoHkLs6aIoYLDjYBft9vSlJiNDLbVd9eQnCfOr06e70mfkDp2EwFyw/sYSsc0zwzxL6/tE77jfXKFHCEVxnmMMlwepgx5ty1ND9oPTcoKy6tn3oMYiaoCA0FRtk0jegVwQNujQ9nWfYML3V7qRAjbZFEax46Tb650iBAED4AowD6PwPTKTN/f9Cc98vIGJOE69CD/wQ6lNI7eE7aX1FGwbaGRsYhbq4ZQob2VqT8nI05omctIeHTUHgJdmo3Wy2W1+nX1bpeQTX/vwdFcQlWGdfZIfvmp5kKpKcmE6z0LWacHxsqzxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ig2HIzg25ZpiqIL9Nz0C0fP5422FqKSNBJHWxd8IAQI=;
 b=X7ds4BD4FbfD3Vy0DOEtaYkpSwmulYo1FbCFlCNlwJX7/gnCNetiC+7wU6ARFzF/vVEkkFfY5xluEOzCXwjWq5f6qL5j/s32j3aAa38KENWau9P38rnjuMeMcXo3cYCOJTXdzRmjQF78xH4yu8L0SOmdmf4HZ7RgDr2aYNkpU0Schs4SiVATQNq3vcq2PhZd+f3aa2SmxjuJcAi7vCYSjnZkKlVWCAcVQHgggdrV6nAwcgx4rTGjwmWGzYNWEj/t277EncFTu9PUfMue/IWBUazOH7gl7qVQJLmqCkXt74RZ5rpRFmvcr6gSk0cnKjMX2VsHy9FiLevUZAOjtkkOxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ig2HIzg25ZpiqIL9Nz0C0fP5422FqKSNBJHWxd8IAQI=;
 b=ybuteW+CIXlLR5VaXC9J4pc7xEQeNS+5p/DYqsOmloAwtlKxup/HrEEMzmyyj5Crzbi+3LiVLV+gQ+I31A3/rZbgykN7qHFOkGAjnqIt1n/GIoMWvtZhsGzTmFkRPp3KFAxtSV/riMNPdA7SXFXPVMYuCW1zU/8y0+k/fpW4yZk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MW4PR12MB6683.namprd12.prod.outlook.com (2603:10b6:303:1e2::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Fri, 10 Mar 2023 02:39:29 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:39:29 +0000
Message-ID: <95639de5-cf0c-0c8c-5a75-b34447e1b03b@amd.com>
Date:   Fri, 10 Mar 2023 13:39:16 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230227111135.61728-17-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0008.ausprd01.prod.outlook.com (2603:10c6:10::20)
 To DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MW4PR12MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: fc3b467e-81e9-4b9b-067c-08db2110abb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ly4HBcMNmu717i5WuJmoQfauLYdg26z9aove4yMjUEvqScnqPc4Lk/bcbjg13YK17HMCnaZYD9PXyUcD8Fp+PJM1pUtn1QQtCgEqai1KNvreOeKS7rzn+UeL76xvh9t4SPv4BImz6XsD4Q7od/WldzTK5JhE6FGXLlfVjhSRJ2cY7atEz7Dugw5H818rmI2CPJ0JewSYqG64e5oQBa8ykwcVZBt8ajGwx3CuXG9NhmceqUkuxOPKdKKtFIC0PV/nD947nVR1P+pJYXLNraEWHpRsbvoZLJc/8U8RHSgyD1K2XhU97bkx56dcLGGBJxoTUVEMSDM7+P+POY5Hqd4PzYXxAP2ym14L3yLn13pTq5gAuGwlkVRfj/aFEViFt1PDj5YvY0CGewhpk3WC27M9nIKfMbv6hYJHsQaQoFtRioaU4xVSNscg5hpM5alIfxvo/I7NyP9MWZNJIenjqrkQUz8s3y+HHBCt/y48oSHN661bve5pk5Fgls3+b6i1zD+C0iWuceyIkv51xRMot41h53x4HVoHKLvcM2RqaiGzBxxv8Cx5cyvx6pOvCslIJmneBtM33l/J5wUj2qCR3dfxYwzpq/ITn3BfXooj6Fjjhex0XH3es+LUXMKX2NPXMdhvC71t8gYo0cvXQ7J0AamkjqTl7de9EDzXXvE2S3y0fBEIxTuKspQs7Rxe8TtcOP5l9GrCsXjB+EgUevhYSeso//GzKEFEG1UXNhwXju6mxx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199018)(36756003)(6486002)(186003)(53546011)(26005)(41300700001)(6666004)(83380400001)(6506007)(6512007)(2616005)(4326008)(8676002)(66556008)(66946007)(2906002)(66476007)(8936002)(7416002)(5660300002)(38100700002)(316002)(31696002)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bldSSE5iWm00SHhHbXNEa3U0WmI3VHpZSkhxd1JsZzJCZ0RnOWlQMllmbFN5?=
 =?utf-8?B?TXF3ZlE2cU1ZdHB6K01JMjRGZW1Zbnp3Q2xJQ2hiM0lzNnQ2QXNUQmZtOWdQ?=
 =?utf-8?B?dDhwY1VXYXFUQ2NydFRDNUxBcnNYQTlXNWRzaUNhQ0FKdlVFL2tjS3lHWThm?=
 =?utf-8?B?b2poS1BNR3VldFFEZXk5ZEUrZDBaaURXVDh1bm9CRGcwR1I4Ull2M3lqdmc3?=
 =?utf-8?B?alA3bC9QKzJKOG5RaXU5N0srT3liZVFTb083SU14STRPci9vUGN0WDlLMU1X?=
 =?utf-8?B?aWY5Tit2aVlzcTU3WXBZa2RZZjIyUU5mQjBjY3VaUDhwamFhYllQWThqSXRC?=
 =?utf-8?B?MHYrMWpZWU1WanlqUHpkK2JIdVhoS0FVSjIzY21QTGJoSmFUTXUzRWdYcnhS?=
 =?utf-8?B?WUhSZVUxb0tCRDdWMW8yOG5ucHA1NitablhuRW9nSUd6M28vZlpCaSthRkdB?=
 =?utf-8?B?NjhpR3EyalhudFVLR3dUU2pnL2V5b1lJYTk2ckdZWFBlQXZDc2tCT2dlekFL?=
 =?utf-8?B?R1l6c0Z1U3pPYS91aHJrMnk1SFNGKzllVDhMSGhLd3VzVVM0VWMwb01IbjMz?=
 =?utf-8?B?ODhqcHhtMlduckNSZ1ZGVUhrV2ZpSDdmUUhlenlYdkZwaUVPRmVwaWxreWx6?=
 =?utf-8?B?YzRML2JrK2R0WXlmTmV3cUd0aklISk1hdXBlQ2cwRi8yczkrTlVHRXBSL3Jn?=
 =?utf-8?B?aStpZGZuOVpkSnRrajYrMi9yNnhFV0c4R3VCRjRFcWoyNFdnSW55WjlBSVM0?=
 =?utf-8?B?SkZZQjZQNFRTV3hyVVFiOVhMcE1VNlVJaFNDRlBvTzVpVjBaU1QwQnJSeUdZ?=
 =?utf-8?B?Rk1YNFcrbmZSRWRxa2dRQkhGKzFsYlBvY1JlNHBKRUNydDJPT0liSm8xT2FC?=
 =?utf-8?B?Mk1ZSG5US2hOOTFyUUVsdDRqNjdzNC9SUGY3TDB2NWVVVzdHRk8zME9UaERs?=
 =?utf-8?B?SkJBMCsxaERENlFqb3RMd08vNm5SS0gvZkVqem1UZHVJcG90ZTNKZUhHRU0w?=
 =?utf-8?B?QXN6ZTAwbC9XU0ZOcWhCZmNWdWptdXdhM0ZjSUpLdEQ2bmVqMWlOQUJmdzF1?=
 =?utf-8?B?VWQ1RjZjbk9qdnJ4TG1SQlhsVGxoSDI0NnNKRTBrWkR1MVFBZm90MXNyU1No?=
 =?utf-8?B?M09xZmhQWk5RaVhoYlAyR2Ezbk5CQ2kzVEp3WW1iV2NuY1dZaEtvMnJqSmp2?=
 =?utf-8?B?T0JuYkRGTHNaL2VabFZoOGZSKzBrM2NKU1FIU1NzZ3hPajFWODRHbkM4SUNx?=
 =?utf-8?B?Yk9TVi9MSXU5UjRnSDZzbGJDY1B2dzhabFpXQjgraWpsaWNMVk8xZjZtUHcv?=
 =?utf-8?B?eHlZZHJPUFdaYmx3ZzlWV1NTZWpBcURXRGEvVlZqL3JhcVVmdEowWU02MFBm?=
 =?utf-8?B?Vy9DU25lbDlCMEhVKzhENEVvVC94ODVZWG5BSGZHNFZkeDV3Y1ErVkpMSC9q?=
 =?utf-8?B?MWJ5ejdZNmtwMkdJNStQTy9wbXQ4cFNMS3M4RGF1QlBQSDFVQlZBeXBNV09v?=
 =?utf-8?B?ZXNZSEFwVTVLeGoyTTdnRFp6c0dmRjNDcEMzZzJLSHFOODI1M1hnOSt0VnRQ?=
 =?utf-8?B?VnlMNWVlbFY3dU9LZ252akRhNGRiZGszUUREVmtWQUxCMWdWS3RJVTEva1U1?=
 =?utf-8?B?aUdTSHo3cmNMN2djWWsweFd2TGZteE0wb21Da0lJOXMwMTR2a1ZnbFJUSjVn?=
 =?utf-8?B?cWJodnV2cVYvUlI5UjJoemlnTHNhcVJJRTBVbHFnZXpnTlo3OTAwaThDL0cx?=
 =?utf-8?B?Ri8xRXkxekNsQ3ZOQUIrS2U3V200OTN4ZGxCSWg0dTZ1Qk1YNzJveGlqSGlr?=
 =?utf-8?B?QWdIZi8xdkZSb094cHNpTGpQd3RoTnA5ZU5JOGpOOHNjRi9DN2RqRlFWRUZB?=
 =?utf-8?B?dU5jY3VaQUlHU2ZzUFJwYU5PdEc1UVRzM0dFMENUVmM2MHRmbjJ0L3I1R0hm?=
 =?utf-8?B?Q3I4WjJCK0FRYzZtVGJ0clZ6M2g1QmpTaGNPKzZoY0tIN3hFQldwRkE0eEZ3?=
 =?utf-8?B?elB4OEhydHBTdkNyQnozbzJQOWpTZHpoZjVhNElQRzlRcWxkN2crb2M3N0Jk?=
 =?utf-8?B?VGdpRVBSTjdBWlQxWkNiQzN3ejcxRkxlamhZSnk0aFlzQ0FYaU9BSm1SSzcy?=
 =?utf-8?Q?7FpernCrBSzV3MLib7tEK5ArD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3b467e-81e9-4b9b-067c-08db2110abb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 02:39:29.1221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMYt878BYvmEwCyLT48h2U8SZZ+Tu2BuY0xEpQF5LQMBnjL79YM3s9cD/5aOEAqpxIy1Dp8Dgwr8pJPGbzsnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/2/23 22:11, Yi Liu wrote:
> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>      VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 			      VFIO no iommu mode is indicated by passing
> 			      a negative iommufd value.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/vfio/device_cdev.c | 146 +++++++++++++++++++++++++++++++++++++
>   drivers/vfio/vfio.h        |  17 ++++-
>   drivers/vfio/vfio_main.c   |  54 ++++++++++++--
>   include/linux/iommufd.h    |   6 ++
>   include/uapi/linux/vfio.h  |  34 +++++++++
>   5 files changed, 248 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 9e2c1ecaaf4f..37f80e368551 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -3,6 +3,7 @@
>    * Copyright (c) 2023 Intel Corporation.
>    */
>   #include <linux/vfio.h>
> +#include <linux/iommufd.h>
>   
>   #include "vfio.h"
>   
> @@ -45,6 +46,151 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>   	return ret;
>   }
>   
> +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> +{
> +	spin_lock(&df->kvm_ref_lock);
> +	if (!df->kvm)
> +		goto unlock;
> +
> +	_vfio_device_get_kvm_safe(df->device, df->kvm);
> +
> +unlock:
> +	spin_unlock(&df->kvm_ref_lock);
> +}
> +
> +void vfio_device_cdev_close(struct vfio_device_file *df)
> +{
> +	struct vfio_device *device = df->device;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * As df->access_granted writer is under dev_set->lock as well,
> +	 * so this read no need to use smp_load_acquire() to pair with
> +	 * smp_store_release() in the caller of vfio_device_open().
> +	 */
> +	if (!df->access_granted) {
> +		mutex_unlock(&device->dev_set->lock);
> +		return;
> +	}
> +	vfio_device_close(df);
> +	vfio_device_put_kvm(device);
> +	if (df->iommufd)
> +		iommufd_ctx_put(df->iommufd);
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +}
> +
> +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> +{
> +	struct fd f;
> +	struct iommufd_ctx *iommufd;
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
> +
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd = NULL;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	ret = vfio_device_block_group(device);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * If already been bound to an iommufd, or already set noiommu
> +	 * then fail it.
> +	 */
> +	if (df->iommufd || df->noiommu) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			ret = -EPERM;
> +			goto out_unlock;
> +		}
> +		df->noiommu = true;
> +	} else {
> +		iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
> +		if (IS_ERR(iommufd)) {
> +			ret = PTR_ERR(iommufd);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * Before the device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain
> +	 * a reference.  This reference is held until device closed.
> +	 * Save the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	df->iommufd = iommufd;
> +	ret = vfio_device_open(df, &bind.out_devid, NULL);


This is unrelated to this patch but reminded me - while debugging QEMU, 
vfio_assert_device_open() kept firing as I was killing QEMU (which in 
turn made the kernel close all fds), device->open_count==0 as QEMU was 
dying before calling ioctl(VFIO_DEVICE_BIND_IOMMUFD) which would call 
this vfio_device_open() just above. Has this been reported/fixed, just 
curious?



-- 
Alexey

