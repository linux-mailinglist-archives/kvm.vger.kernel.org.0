Return-Path: <kvm+bounces-11524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D2A877D19
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8672EB20B65
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB315179B7;
	Mon, 11 Mar 2024 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ctZrf4Ta"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E717999
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710150034; cv=fail; b=JFOy84rttjERutqjmQZIJVnAMfNMA7sR/mDwtLhAJCu73DKxvA405IfAn6kfYA9yphX+GoCOPvK9XFuRKt5H4hU++RbYzfVzM5Or+ceYFE/U6v/VcIxs/220g2UikjhIdhdBPE80N5fiKdxx1lCVJlffShOtGfSlj2PxP8ibrOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710150034; c=relaxed/simple;
	bh=LKEE0Nnj1efLERXCsMpmeHLTse/jPsFGNfFPcZB/xbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ExHtn8VVYj6jth8CHJ9gKWM1zcVX/7pNUeYyiT1Jf02GoTmNcAnTazQxskLET1vci1QC5jhQ6Ll8GB+nXXjOzq5mYXh4KxlCRnuEoWEA+bJqxd4fbi+e84dtENNceS9vRcCuIY0bjWblDmCeNiTU1raQ+jdDT3DA9jC7tOQ0kjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ctZrf4Ta; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC6Li2TOwGfwMUyjn32z2yy39ucohCyMXpo4gHizWKKh0LtjfPV2nv5ySStpGFjE9TsmSUDFs06yChMgJ4nhxCHx6Bhs66gk8kucZsopRFYaNMP1mFv+J7oGeAqdE5iqY1yDMNUsS+np7PE0wIgRKRI4fSkG/yqmO7R5gPE8DcG8Heh61lY0ZQkCMoYZjaVW1j9JNmeBHK8eo5QrJoBjKsWAT9ElglPT9UYW3FuHjdqbqVY+SVvrn1pLTEaLdHiC1KfcxN5DeLGTViznvxFeTXvfe1vXGxr+lGSxyHGPyKXBVqtyM6ZgZB7OhmM6U2zMS3O1/W8e77KZNbdv3XUutw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUWCUNkYRTsvDG5xCMDCSCkkqvZvBA1MXuRadCLSH2s=;
 b=Wbn6PM+JbVfCfERJk07bukGA2vaS7devPpfGdYEsEfSqVgBZjyegI3w/Dsy0UTG7JVqrvIp3Cg3L5PDA6omvrF5qRSGjb9zQP2YPuAbj1qkQWxms9MQJ0EOxopMskFCKzJTUda++cp+NbN+6PypPCHq2tkhCRLzOXvKgheKKo1bMA+/n1Mbuz9ny0jk12sfOl2uSlXelNv7CMdDzLpEW1R6YMkJQxFinpR01+0szasvy+VAe7KP9f1gZ51amLmHEttwiapNXdqZd+KYUZ9mFkgkqTsshgv0PHoKQM7drzcoD6rp5VJSbBcA91ji+n4tnyw7shSpQIN1eHV4bdOEonw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUWCUNkYRTsvDG5xCMDCSCkkqvZvBA1MXuRadCLSH2s=;
 b=ctZrf4Tay9GrzHYZg5nWoN3DHuq8BhRwYNop6QhJyx99LCiEYSAxiY8eblD29+YgcKD389+4XLxq8Ctsc5CIWCsfEQkTjskE2ihcXEPpjMyDwyITCoFQgz678/A4IRjwYXZu75Zj6WyoK413+h/4m3O1cpF9Vzw+La2LM6uM8m22Raj+7eJ9h679TABeqTJm8+R+6SIufg7bZNuV4T4+yIv2NI/bwfLFjIqaDHTyiaz3OBye9s5UyPlLk4aR0pN+7SHpgMZxwZt5W1wf/Ss9wX/E8lPAY9EwLpAPKTcDkZ1DI33moG7ALVM4WG3xdRhx46Ulk5uf9s+GyP5iE8DCHQ==
Received: from CYZPR11CA0019.namprd11.prod.outlook.com (2603:10b6:930:8d::19)
 by CY8PR12MB8241.namprd12.prod.outlook.com (2603:10b6:930:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Mon, 11 Mar
 2024 09:40:28 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:930:8d:cafe::ac) by CYZPR11CA0019.outlook.office365.com
 (2603:10b6:930:8d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36 via Frontend
 Transport; Mon, 11 Mar 2024 09:40:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Mon, 11 Mar 2024 09:40:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 11 Mar
 2024 02:40:16 -0700
Received: from [172.27.57.229] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 11 Mar
 2024 02:40:14 -0700
Message-ID: <2cd2af54-aceb-4728-bd68-dae060b252bb@nvidia.com>
Date: Mon, 11 Mar 2024 11:40:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio] vfio/mlx5: Enforce PRE_COPY support
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20240306105624.114830-1-yishaih@nvidia.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240306105624.114830-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|CY8PR12MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a4b4062-d91f-43bd-af12-08dc41af4970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lwlSeNv4JDS1TAzeLoOiRjhZcBg4/YayPUtQyTYGHHgUGJL0daV1sycf6lzfUk93atagvnlljxiLVB0Qmje/Gdv+D+qsEeGnBpFwDr1pPh/lie/Rb0Oo3x5wsGSAJ2j0qdX0uczXQJzhN0o0S0y0lj7bFmcYze1hLL8Xz7V+jjraHdseSIva48uY8v4XKPCQdhM2WoTSCQQ/kHRL+YpRkTcnF3uV+77OApOoaYPSu2cSdq6flrQDEfoyh1m4i8aKX25zUaGeLe7XkCAKGeWahftr7SU49S9yjiXrEuH2BIl5OY2D5IIORGAsZE15oVmFbyzt5A06SJ3L9v/+wh+X8N2HqV6c+lfZC9tGDs0iqvYLCPJCbP9hY61MiHC0mhqeYGjXLqAvaYKWOVv/GRw287he/dWVGSchZQT0a2TbStcn8cwjroAtPlnaTYtH8dXVmUiOyVHw1xBZGwbMVUEhGe5XL4VSwaNkMDMPnWTSM06ZPG5U3lMqQeR5SZYUKBHBjwtASKwya0tdY44zp91ZpIK5T7MPaVVtIdSZr3u+Id91fnc7ERTFOYdoSJkohQ2F/aBJzik9TAj+S3OnJYdwROjrEA9mBgYAYLY71M/iDxKgCew3Im8Nvpm1vuc5V7HLp1+XZuunAn5a2yIYvLx29gfhMoHFGa7TNpu53rZu+SYM2Bnow9ScKIK4LtpbjtYnCuWvw44SV9GdjONj4NGA9lgar70ekj6A8UJ2AXFDsmswVS2E6CpOzObAlU/69e1K
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 09:40:28.5932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4b4062-d91f-43bd-af12-08dc41af4970
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8241

On 06/03/2024 12:56, Yishai Hadas wrote:
> Enable live migration only once the firmware supports PRE_COPY.
> 
> PRE_COPY has been supported by the firmware for a long time already [1]
> and is required to achieve a low downtime upon live migration.
> 
> This lets us clean up some old code that is not applicable those days
> while PRE_COPY is fully supported by the firmware.
> 
> [1] The minimum firmware version that supports PRE_COPY is 28.36.1010,
> it was released on January 23.
> 
> No firmware without PRE_COPY support ever available to users.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Hi Alex,

Are we OK here ?

It's a cleanup patch for a non applicable code.

Thanks,
Yishai

> ---
>   drivers/vfio/pci/mlx5/cmd.c  |  83 +++++++++++++++++++-------
>   drivers/vfio/pci/mlx5/cmd.h  |   6 --
>   drivers/vfio/pci/mlx5/main.c | 109 +++--------------------------------
>   3 files changed, 71 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index c54bcd5d0917..41a4b0cf4297 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -233,6 +233,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>   	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
>   		goto end;
>   
> +	if (!(MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> +	      MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state)))
> +		goto end;
> +
>   	mvdev->vf_id = pci_iov_vf_id(pdev);
>   	if (mvdev->vf_id < 0)
>   		goto end;
> @@ -262,17 +266,14 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>   	mvdev->migrate_cap = 1;
>   	mvdev->core_device.vdev.migration_flags =
>   		VFIO_MIGRATION_STOP_COPY |
> -		VFIO_MIGRATION_P2P;
> +		VFIO_MIGRATION_P2P |
> +		VFIO_MIGRATION_PRE_COPY;
> +
>   	mvdev->core_device.vdev.mig_ops = mig_ops;
>   	init_completion(&mvdev->tracker_comp);
>   	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
>   		mvdev->core_device.vdev.log_ops = log_ops;
>   
> -	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> -	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
> -		mvdev->core_device.vdev.migration_flags |=
> -			VFIO_MIGRATION_PRE_COPY;
> -
>   	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
>   		mvdev->chunk_mode = 1;
>   
> @@ -414,6 +415,50 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
>   	kfree(buf);
>   }
>   
> +static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> +				      unsigned int npages)
> +{
> +	unsigned int to_alloc = npages;
> +	struct page **page_list;
> +	unsigned long filled;
> +	unsigned int to_fill;
> +	int ret;
> +
> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> +	if (!page_list)
> +		return -ENOMEM;
> +
> +	do {
> +		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
> +						page_list);
> +		if (!filled) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		to_alloc -= filled;
> +		ret = sg_alloc_append_table_from_pages(
> +			&buf->table, page_list, filled, 0,
> +			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
> +			GFP_KERNEL_ACCOUNT);
> +
> +		if (ret)
> +			goto err;
> +		buf->allocated_length += filled * PAGE_SIZE;
> +		/* clean input for another bulk allocation */
> +		memset(page_list, 0, filled * sizeof(*page_list));
> +		to_fill = min_t(unsigned int, to_alloc,
> +				PAGE_SIZE / sizeof(*page_list));
> +	} while (to_alloc > 0);
> +
> +	kvfree(page_list);
> +	return 0;
> +
> +err:
> +	kvfree(page_list);
> +	return ret;
> +}
> +
>   struct mlx5_vhca_data_buffer *
>   mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
>   			 size_t length,
> @@ -680,22 +725,20 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>   		goto err_out;
>   	}
>   
> -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
> -		if (async_data->stop_copy_chunk) {
> -			u8 header_idx = buf->stop_copy_chunk_num ?
> -				buf->stop_copy_chunk_num - 1 : 0;
> +	if (async_data->stop_copy_chunk) {
> +		u8 header_idx = buf->stop_copy_chunk_num ?
> +			buf->stop_copy_chunk_num - 1 : 0;
>   
> -			header_buf = migf->buf_header[header_idx];
> -			migf->buf_header[header_idx] = NULL;
> -		}
> +		header_buf = migf->buf_header[header_idx];
> +		migf->buf_header[header_idx] = NULL;
> +	}
>   
> -		if (!header_buf) {
> -			header_buf = mlx5vf_get_data_buffer(migf,
> -				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> -			if (IS_ERR(header_buf)) {
> -				err = PTR_ERR(header_buf);
> -				goto err_free;
> -			}
> +	if (!header_buf) {
> +		header_buf = mlx5vf_get_data_buffer(migf,
> +			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> +		if (IS_ERR(header_buf)) {
> +			err = PTR_ERR(header_buf);
> +			goto err_free;
>   		}
>   	}
>   
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 707393df36c4..df421dc6de04 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -13,9 +13,6 @@
>   #include <linux/mlx5/cq.h>
>   #include <linux/mlx5/qp.h>
>   
> -#define MLX5VF_PRE_COPY_SUPP(mvdev) \
> -	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
> -
>   enum mlx5_vf_migf_state {
>   	MLX5_MIGF_STATE_ERROR = 1,
>   	MLX5_MIGF_STATE_PRE_COPY_ERROR,
> @@ -25,7 +22,6 @@ enum mlx5_vf_migf_state {
>   };
>   
>   enum mlx5_vf_load_state {
> -	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
>   	MLX5_VF_LOAD_STATE_READ_HEADER,
>   	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
>   	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
> @@ -228,8 +224,6 @@ struct mlx5_vhca_data_buffer *
>   mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
>   		       size_t length, enum dma_data_direction dma_dir);
>   void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
> -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> -			       unsigned int npages);
>   struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>   				       unsigned long offset);
>   void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 3982fcf60cf2..61d9b0f9146d 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -65,50 +65,6 @@ mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>   	return NULL;
>   }
>   
> -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> -			       unsigned int npages)
> -{
> -	unsigned int to_alloc = npages;
> -	struct page **page_list;
> -	unsigned long filled;
> -	unsigned int to_fill;
> -	int ret;
> -
> -	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> -	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> -	if (!page_list)
> -		return -ENOMEM;
> -
> -	do {
> -		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
> -						page_list);
> -		if (!filled) {
> -			ret = -ENOMEM;
> -			goto err;
> -		}
> -		to_alloc -= filled;
> -		ret = sg_alloc_append_table_from_pages(
> -			&buf->table, page_list, filled, 0,
> -			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
> -			GFP_KERNEL_ACCOUNT);
> -
> -		if (ret)
> -			goto err;
> -		buf->allocated_length += filled * PAGE_SIZE;
> -		/* clean input for another bulk allocation */
> -		memset(page_list, 0, filled * sizeof(*page_list));
> -		to_fill = min_t(unsigned int, to_alloc,
> -				PAGE_SIZE / sizeof(*page_list));
> -	} while (to_alloc > 0);
> -
> -	kvfree(page_list);
> -	return 0;
> -
> -err:
> -	kvfree(page_list);
> -	return ret;
> -}
> -
>   static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
>   {
>   	mutex_lock(&migf->lock);
> @@ -777,36 +733,6 @@ mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
>   	return 0;
>   }
>   
> -static int
> -mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
> -				   loff_t requested_length,
> -				   const char __user **buf, size_t *len,
> -				   loff_t *pos, ssize_t *done)
> -{
> -	int ret;
> -
> -	if (requested_length > MAX_LOAD_SIZE)
> -		return -ENOMEM;
> -
> -	if (vhca_buf->allocated_length < requested_length) {
> -		ret = mlx5vf_add_migration_pages(
> -			vhca_buf,
> -			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
> -				     PAGE_SIZE));
> -		if (ret)
> -			return ret;
> -	}
> -
> -	while (*len) {
> -		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
> -						    done);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> -}
> -
>   static ssize_t
>   mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
>   			 struct mlx5_vhca_data_buffer *vhca_buf,
> @@ -1038,13 +964,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
>   			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
>   			break;
>   		}
> -		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
> -			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
> -						requested_length,
> -						&buf, &len, pos, &done);
> -			if (ret)
> -				goto out_unlock;
> -			break;
>   		case MLX5_VF_LOAD_STATE_READ_IMAGE:
>   			ret = mlx5vf_resume_read_image(migf, vhca_buf,
>   						migf->record_size,
> @@ -1114,21 +1033,16 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
>   	}
>   
>   	migf->buf[0] = buf;
> -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
> -		buf = mlx5vf_alloc_data_buffer(migf,
> -			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> -		if (IS_ERR(buf)) {
> -			ret = PTR_ERR(buf);
> -			goto out_buf;
> -		}
> -
> -		migf->buf_header[0] = buf;
> -		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
> -	} else {
> -		/* Initial state will be to read the image */
> -		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
> +	buf = mlx5vf_alloc_data_buffer(migf,
> +		sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> +	if (IS_ERR(buf)) {
> +		ret = PTR_ERR(buf);
> +		goto out_buf;
>   	}
>   
> +	migf->buf_header[0] = buf;
> +	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
> +
>   	stream_open(migf->filp->f_inode, migf->filp);
>   	mutex_init(&migf->lock);
>   	INIT_LIST_HEAD(&migf->buf_list);
> @@ -1262,13 +1176,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>   	}
>   
>   	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
> -		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
> -			ret = mlx5vf_cmd_load_vhca_state(mvdev,
> -							 mvdev->resuming_migf,
> -							 mvdev->resuming_migf->buf[0]);
> -			if (ret)
> -				return ERR_PTR(ret);
> -		}
>   		mlx5vf_disable_fds(mvdev, NULL);
>   		return NULL;
>   	}


