Return-Path: <kvm+bounces-11124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF93873540
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 12:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 259E91F25CCA
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 11:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DB360DCE;
	Wed,  6 Mar 2024 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hixESw66"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D705FDDC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 11:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709722911; cv=fail; b=ryCXiQwv0juDwJnLP6BVO4fPoQ282Z/WRoqKGx34XEDzKbeE/U54CQ7+1en1g/upDN7Q7nw6ht2WjYiaQFoBuQAP4yTKPEJ/3gQK6y1Ie/s7Hduu5RNZKnIFr+OJL3pSPBvDCLZT+PGnWieqG1RqEPCQj3PThijLN9i1bvzhLG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709722911; c=relaxed/simple;
	bh=kQ+AZkY4+QuBkjNGcO36C6GSJ+n7pvATxLb82CJs2rU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eVBB/uv3qMlYg7X469nwIcyUy/g2J9begu9B+kqFJrFVmv7ebhOAhNes3NZGT6olSY5KIzFAnG7+du2IQO+1TA4x8ithExagL2NZCFnxn5bHtd5zgJeJ+qTWqasyx9b4UUxhCJYdOiOcJn64dXCJxzormZUvZpMzB6GWb5Q3A4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hixESw66; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWjAsERwWvWjWosoPLiznopEvWFC/LZz8GTwYH+50cnDPLn8YfKh4L1Gt9+i7uip5eGXbUMgvD3ZJUCQr6TPwdJv2WBmJVB7EbWfdpESxogW8p6NFAoroqS62zl9N24bk0rzCQsAEFr+B+RHWBBcXbLVxw0j+RMFey6RYATZLl0FcF/4CHPo+dPGU5RZVKhpTppgmczSs15FP+L/fvOtbfO0nXeMKY4PE9mNUb7PWiaK4VEXEDKn3W2TayGFhdXqVnj8v3Z02MTLE0/y2kt56427EHJaZfavkDEUyn+8u9SbG8vHoU4zCoDbAFxbzv0vOlnpQ03Y3ByguC8XWAwTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skbbCzR9nBzo5JZTVeuEUNXslbFJK+La9wz+k8i519w=;
 b=cot4tXmH6ipzW+9SJxnjP3tkkg9ryy4tXj/5VlhvFr99SVd7fDUD5M16hQLLNOp2tXLEmDL7mp/5CO9OTDx9LP5BKc2BP4E1lIj2m1uOWxpHb2MbAjDNsdAYbq9qCITOz/R7i1KNxW1Qhe727GbdwoCZErSLM/efbe3FeLTmQQr9nxtYd2ryNT5QOlS+NT27QSzJYO7I2xcEHyBvFLByt3CJ1/Acmdala8621XajlnGKo9s6rBw6qLxJkc0GsNJNwfhhek9LBC30+BokacdZzy4IlAdyY1we58mjeYm2IvYCihK3GmLKysxddNbBqqNVC8ANJDHZUT26/OQFmiPCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skbbCzR9nBzo5JZTVeuEUNXslbFJK+La9wz+k8i519w=;
 b=hixESw66zDLqQNOQAyViL5qXTgqd6yUtW899jXYbNQYPMtsF3U55dwOUduKBWhTnWUzfayNJ3b/S+0xNizdPsPWRcMRM0t+4aKaVk4fW4iJQp+p+2tlQSFp6e7TqUsZORejbkBocqPuDVUeAqZL9KYl9rz4chSYe8XfzXNyFebzc8y+PnGvNTA1syFTdratII5e4ILisToT8qaE4PD2Q+pQCxY9F4CFDUqh+4fE6RiDAOsk+lPUAQxCFs+MHkCwKKSQpyLpLiwOG5dHVqcB7B4EowbIaUMTlE/eA8idYEvc+V66BckjWyKQbnLK8xgJzNAO2f6M/f9TY9vQqz6wpcw==
Received: from CH5P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::13)
 by DS7PR12MB8249.namprd12.prod.outlook.com (2603:10b6:8:ea::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 6 Mar
 2024 11:01:45 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:1f3::4) by CH5P223CA0017.outlook.office365.com
 (2603:10b6:610:1f3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24 via Frontend
 Transport; Wed, 6 Mar 2024 11:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Wed, 6 Mar 2024 11:01:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Mar 2024
 03:01:26 -0800
Received: from [10.80.2.88] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 6 Mar
 2024 03:01:24 -0800
Message-ID: <23e07cd0-ae5b-4693-a7af-ea5ae3508c47@nvidia.com>
Date: Wed, 6 Mar 2024 13:01:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio] vfio/mlx5: Enforce PRE_COPY support
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20240305103037.61144-1-yishaih@nvidia.com>
 <20240305145642.3f2781be.alex.williamson@redhat.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240305145642.3f2781be.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|DS7PR12MB8249:EE_
X-MS-Office365-Filtering-Correlation-Id: 35dd6df4-ce5f-435f-ca44-08dc3dccd046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7zwc4qiPUwUTIEkniwF3UhHnP9X0ba6n+wJIXH2f5KCPSd8zNWfg4lX20kkjGsHYElku11zRrTbLpfsQnA66THJMoWRfaZAOH7f7Ak/wEBNyJrjIvkvmkd54TOsTK/B1X0HflN4pBSQHw3PDh/J3qizXpbXk+mqIgXuxNbYyQxoWmYgnBTprOS/s/BynHRzU2T0eVbmBgvf4ZkOsrYp6CCU3Mdqk7nrjpeIk2M7TEBpwmT5emjaJakYeKzyxwTLbvBR3Ka1IR/aISPHxhXzhj1o/QuRz8VSGmDZUqydVnFbLQDVW5sunQbuX+PcRVBJUvi0MDVbe6IpvQKFpu4HPCNuLdXMTCwYJx6l8BQ0CrsuWlTYxDwu5gLAekiQ9Sf8bSVG2Czwxd7nqhnsM8An0INR+RNiXz5Qdyxr5cJlREMDNLqT2HLLQ7kSNJykxW9Jj2IzcSXehJz9zbQ/0120eGBqsmrCgeXFkJ45fhmojeRg0LSgjvFJHrHNc0I9sQvuJ8QSI4wxw1viFNpvHruZGZSpYEDk0RY66cVjukeFdnLdUchUOfcfb0uJzFHqhpJZNABVC5Di6abBdK3rquTt2suz/ueFLAKVB7TeSdpZw3emJD4YNDD+K1GAtMZ7bvpD9nqFd3WKLujFmSANMOtB/PhRWhgpmr3ti8dQut+fT4bI/9xFXVCBk5fC5P3hp/UU77H5hvRBo34QJLBgj+Oj380AQDHCYCcoUKO9fGTLyo1HEmKty01x31wJpdSprBXm7
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 11:01:45.4972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dd6df4-ce5f-435f-ca44-08dc3dccd046
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8249

On 05/03/2024 23:56, Alex Williamson wrote:
> On Tue, 5 Mar 2024 12:30:37 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> Enable live migration only once the firmware supports PRE_COPY.
>>
>> PRE_COPY has been supported by the firmware for a long time already and
>> is required to achieve a low downtime upon live migration.
>>
>> This lets us clean up some old code that is not applicable those days
>> while PRE_COPY is fully supported by the firmware.
> 
> Was firmware without PRE_COPY support ever available to users?  AIUI
> this would disable migration support on devices with older firmware, so
> if that firmware exists in the wild this should go through a
> deprecation process.

No firmware without PRE_COPY support ever available to users.

> 
> We should also likely note a minimum firmware revision and time frame
> when PRE_COPY support was added in firmware.  Thanks,
> 

Sure, I just sent V1 having that information.

Thanks,
Yishai

> Alex
> 
> 
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c  |  83 +++++++++++++++++++-------
>>   drivers/vfio/pci/mlx5/cmd.h  |   6 --
>>   drivers/vfio/pci/mlx5/main.c | 109 +++--------------------------------
>>   3 files changed, 71 insertions(+), 127 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index c54bcd5d0917..41a4b0cf4297 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -233,6 +233,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>>   	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
>>   		goto end;
>>   
>> +	if (!(MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
>> +	      MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state)))
>> +		goto end;
>> +
>>   	mvdev->vf_id = pci_iov_vf_id(pdev);
>>   	if (mvdev->vf_id < 0)
>>   		goto end;
>> @@ -262,17 +266,14 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>>   	mvdev->migrate_cap = 1;
>>   	mvdev->core_device.vdev.migration_flags =
>>   		VFIO_MIGRATION_STOP_COPY |
>> -		VFIO_MIGRATION_P2P;
>> +		VFIO_MIGRATION_P2P |
>> +		VFIO_MIGRATION_PRE_COPY;
>> +
>>   	mvdev->core_device.vdev.mig_ops = mig_ops;
>>   	init_completion(&mvdev->tracker_comp);
>>   	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
>>   		mvdev->core_device.vdev.log_ops = log_ops;
>>   
>> -	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
>> -	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
>> -		mvdev->core_device.vdev.migration_flags |=
>> -			VFIO_MIGRATION_PRE_COPY;
>> -
>>   	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
>>   		mvdev->chunk_mode = 1;
>>   
>> @@ -414,6 +415,50 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
>>   	kfree(buf);
>>   }
>>   
>> +static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>> +				      unsigned int npages)
>> +{
>> +	unsigned int to_alloc = npages;
>> +	struct page **page_list;
>> +	unsigned long filled;
>> +	unsigned int to_fill;
>> +	int ret;
>> +
>> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
>> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
>> +	if (!page_list)
>> +		return -ENOMEM;
>> +
>> +	do {
>> +		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
>> +						page_list);
>> +		if (!filled) {
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
>> +		to_alloc -= filled;
>> +		ret = sg_alloc_append_table_from_pages(
>> +			&buf->table, page_list, filled, 0,
>> +			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
>> +			GFP_KERNEL_ACCOUNT);
>> +
>> +		if (ret)
>> +			goto err;
>> +		buf->allocated_length += filled * PAGE_SIZE;
>> +		/* clean input for another bulk allocation */
>> +		memset(page_list, 0, filled * sizeof(*page_list));
>> +		to_fill = min_t(unsigned int, to_alloc,
>> +				PAGE_SIZE / sizeof(*page_list));
>> +	} while (to_alloc > 0);
>> +
>> +	kvfree(page_list);
>> +	return 0;
>> +
>> +err:
>> +	kvfree(page_list);
>> +	return ret;
>> +}
>> +
>>   struct mlx5_vhca_data_buffer *
>>   mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
>>   			 size_t length,
>> @@ -680,22 +725,20 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>>   		goto err_out;
>>   	}
>>   
>> -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
>> -		if (async_data->stop_copy_chunk) {
>> -			u8 header_idx = buf->stop_copy_chunk_num ?
>> -				buf->stop_copy_chunk_num - 1 : 0;
>> +	if (async_data->stop_copy_chunk) {
>> +		u8 header_idx = buf->stop_copy_chunk_num ?
>> +			buf->stop_copy_chunk_num - 1 : 0;
>>   
>> -			header_buf = migf->buf_header[header_idx];
>> -			migf->buf_header[header_idx] = NULL;
>> -		}
>> +		header_buf = migf->buf_header[header_idx];
>> +		migf->buf_header[header_idx] = NULL;
>> +	}
>>   
>> -		if (!header_buf) {
>> -			header_buf = mlx5vf_get_data_buffer(migf,
>> -				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
>> -			if (IS_ERR(header_buf)) {
>> -				err = PTR_ERR(header_buf);
>> -				goto err_free;
>> -			}
>> +	if (!header_buf) {
>> +		header_buf = mlx5vf_get_data_buffer(migf,
>> +			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
>> +		if (IS_ERR(header_buf)) {
>> +			err = PTR_ERR(header_buf);
>> +			goto err_free;
>>   		}
>>   	}
>>   
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 707393df36c4..df421dc6de04 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -13,9 +13,6 @@
>>   #include <linux/mlx5/cq.h>
>>   #include <linux/mlx5/qp.h>
>>   
>> -#define MLX5VF_PRE_COPY_SUPP(mvdev) \
>> -	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
>> -
>>   enum mlx5_vf_migf_state {
>>   	MLX5_MIGF_STATE_ERROR = 1,
>>   	MLX5_MIGF_STATE_PRE_COPY_ERROR,
>> @@ -25,7 +22,6 @@ enum mlx5_vf_migf_state {
>>   };
>>   
>>   enum mlx5_vf_load_state {
>> -	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
>>   	MLX5_VF_LOAD_STATE_READ_HEADER,
>>   	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
>>   	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
>> @@ -228,8 +224,6 @@ struct mlx5_vhca_data_buffer *
>>   mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
>>   		       size_t length, enum dma_data_direction dma_dir);
>>   void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
>> -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>> -			       unsigned int npages);
>>   struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>>   				       unsigned long offset);
>>   void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index 3982fcf60cf2..61d9b0f9146d 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -65,50 +65,6 @@ mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>>   	return NULL;
>>   }
>>   
>> -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>> -			       unsigned int npages)
>> -{
>> -	unsigned int to_alloc = npages;
>> -	struct page **page_list;
>> -	unsigned long filled;
>> -	unsigned int to_fill;
>> -	int ret;
>> -
>> -	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
>> -	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
>> -	if (!page_list)
>> -		return -ENOMEM;
>> -
>> -	do {
>> -		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
>> -						page_list);
>> -		if (!filled) {
>> -			ret = -ENOMEM;
>> -			goto err;
>> -		}
>> -		to_alloc -= filled;
>> -		ret = sg_alloc_append_table_from_pages(
>> -			&buf->table, page_list, filled, 0,
>> -			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
>> -			GFP_KERNEL_ACCOUNT);
>> -
>> -		if (ret)
>> -			goto err;
>> -		buf->allocated_length += filled * PAGE_SIZE;
>> -		/* clean input for another bulk allocation */
>> -		memset(page_list, 0, filled * sizeof(*page_list));
>> -		to_fill = min_t(unsigned int, to_alloc,
>> -				PAGE_SIZE / sizeof(*page_list));
>> -	} while (to_alloc > 0);
>> -
>> -	kvfree(page_list);
>> -	return 0;
>> -
>> -err:
>> -	kvfree(page_list);
>> -	return ret;
>> -}
>> -
>>   static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
>>   {
>>   	mutex_lock(&migf->lock);
>> @@ -777,36 +733,6 @@ mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
>>   	return 0;
>>   }
>>   
>> -static int
>> -mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
>> -				   loff_t requested_length,
>> -				   const char __user **buf, size_t *len,
>> -				   loff_t *pos, ssize_t *done)
>> -{
>> -	int ret;
>> -
>> -	if (requested_length > MAX_LOAD_SIZE)
>> -		return -ENOMEM;
>> -
>> -	if (vhca_buf->allocated_length < requested_length) {
>> -		ret = mlx5vf_add_migration_pages(
>> -			vhca_buf,
>> -			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
>> -				     PAGE_SIZE));
>> -		if (ret)
>> -			return ret;
>> -	}
>> -
>> -	while (*len) {
>> -		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
>> -						    done);
>> -		if (ret)
>> -			return ret;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>   static ssize_t
>>   mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
>>   			 struct mlx5_vhca_data_buffer *vhca_buf,
>> @@ -1038,13 +964,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
>>   			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
>>   			break;
>>   		}
>> -		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
>> -			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
>> -						requested_length,
>> -						&buf, &len, pos, &done);
>> -			if (ret)
>> -				goto out_unlock;
>> -			break;
>>   		case MLX5_VF_LOAD_STATE_READ_IMAGE:
>>   			ret = mlx5vf_resume_read_image(migf, vhca_buf,
>>   						migf->record_size,
>> @@ -1114,21 +1033,16 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
>>   	}
>>   
>>   	migf->buf[0] = buf;
>> -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
>> -		buf = mlx5vf_alloc_data_buffer(migf,
>> -			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
>> -		if (IS_ERR(buf)) {
>> -			ret = PTR_ERR(buf);
>> -			goto out_buf;
>> -		}
>> -
>> -		migf->buf_header[0] = buf;
>> -		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
>> -	} else {
>> -		/* Initial state will be to read the image */
>> -		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
>> +	buf = mlx5vf_alloc_data_buffer(migf,
>> +		sizeof(struct mlx5_vf_migration_header), DMA_NONE);
>> +	if (IS_ERR(buf)) {
>> +		ret = PTR_ERR(buf);
>> +		goto out_buf;
>>   	}
>>   
>> +	migf->buf_header[0] = buf;
>> +	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
>> +
>>   	stream_open(migf->filp->f_inode, migf->filp);
>>   	mutex_init(&migf->lock);
>>   	INIT_LIST_HEAD(&migf->buf_list);
>> @@ -1262,13 +1176,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>>   	}
>>   
>>   	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
>> -		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
>> -			ret = mlx5vf_cmd_load_vhca_state(mvdev,
>> -							 mvdev->resuming_migf,
>> -							 mvdev->resuming_migf->buf[0]);
>> -			if (ret)
>> -				return ERR_PTR(ret);
>> -		}
>>   		mlx5vf_disable_fds(mvdev, NULL);
>>   		return NULL;
>>   	}
> 


