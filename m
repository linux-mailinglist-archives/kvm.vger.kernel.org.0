Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DECD63D2D8
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 11:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiK3KKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 05:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiK3KKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 05:10:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C34C2CE0A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 02:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4kENfRW8Q2D8wBgwA4gkmBCxKJu0atha1mfJqBz31t1K+BXtl/KjUB6Wa5t7mhrX4IwrQ3RZMiw2JvNeEYyfHkQ42y+rlzoOIJlHzn4i9ciQ3VMa5I2H0gzYM/PG3pODaPrL1d+70y+zizMm8ne/P/h5KS3CU5RUG4N6Q1PXt16DIyvP3qEQ7OHRGlGpDgKbcFgAzIyHU6+8ShSY6atxCSkRAXazD18cXrJ7P26mYKNTcnkZTbRoT5lQB53wHwtyTCYWCqLbDy0SpbHDP3I0ZIGDM/mpfNr3lZmDF1MPaj/Khte73TqGDvc4tkh9v2Wz/P46w8uf0HYVKwyr3vWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0CYOFhWnu0NfkmnGU0ttYAG6vv56ohuL2ic4MqitNk=;
 b=XBJKH6d98zBDbLu4lq5rSUyhfllT8fu30l/ASSvt5tDSMJWzwU2fYRE/xc0IzxHWfoQefcuQCb6iuL2Mj92Gkw7ILyCqHL3aZGhZX9uWuhm1S+nRJ0gv9y8mjpvSnScLfj/3R7s7l0NwMane1M7sWlGIisUubKL/1Gs4gzoYlJNwGWiRdeCuUQ+iXCJn2q9hepKGzNsRNJoMVkWWROIdbF1T2Y0STtHXeFWuxSCywXKTvCDepzeei32HqBvDK6EF1i85uUNZKlP5x7EONpXelJawvyOtFdOuQlvB2mr8KdUAZY2BYBdgoDAt2YKyzkBVkMqnuaWtz02/jD31XEYrkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0CYOFhWnu0NfkmnGU0ttYAG6vv56ohuL2ic4MqitNk=;
 b=NWiJ7pr2QsF+q3do/UW65BVrQVOZSmaBoe+t77ccvF+a4B94R5j3dP3PWgLwh+t8zGI2Lqz2kwMK4lje4mW0bR+X5S+1cjcI2ckAd7/he2wLavx4QtLGa9khXVzb7T3ab77DzZF1mWr4n+pvSx2yhTRYL75V7DNp/Xt4KWghISccowa9hapFyHUajfCydd2hXYnJeBQPYZ7StyoKeKtVusIbWH4k9sBjjwKxUFdOLhrU3P2thiAi64NYPD2XvRweWcGQw62XI8aYJc8vbDfXl7MMn1ZZHJt+vAxgL9juh1ZuIN3ThvF6gfxuSqkpK5I6otXqxXgNhWEcFiY5hvvcxA==
Received: from CY5PR22CA0093.namprd22.prod.outlook.com (2603:10b6:930:65::11)
 by DM4PR12MB5891.namprd12.prod.outlook.com (2603:10b6:8:67::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 10:10:35 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:930:65:cafe::fe) by CY5PR22CA0093.outlook.office365.com
 (2603:10b6:930:65::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Wed, 30 Nov 2022 10:10:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 10:10:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 02:10:21 -0800
Received: from [172.27.11.80] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 02:10:18 -0800
Message-ID: <fd2ede8c-3588-0e7f-00dd-c0f706e1ff28@nvidia.com>
Date:   Wed, 30 Nov 2022 12:10:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V1 vfio 09/14] vfio/mlx5: Introduce SW headers for
 migration states
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
 <20221124173932.194654-10-yishaih@nvidia.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20221124173932.194654-10-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|DM4PR12MB5891:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f82e4e9-c710-4a08-8bf5-08dad2bb1f5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lruTx8eEd2xhkvI6hXtfhW9VTB/WbNeCaBd3xqOvCK+i/9snfJZMmDcb8D3t/x3F3cQEtQxq2Q/gf2TufDghq6AVlWiZpkMRkpf+qVT26NnrUDG0/55TcHvGLaJNgM0ihlbe33mUN8sf3c5SPUvJeUTdlnhE2RDlobUt6bbXdKzwIhaqsAb7AlzZWnakDXQLHscR5bF7rXTAM1zR0pHEJm+YvGRP9jdY5KcP9CfreHYNEDXzoJU5NdTmCnCciFXhKmz6tQD8FIPVpWvf7B5quAbW/ysWLLNp9NSP85Ec8z5z2Edow2fQTEEhYmhuS7hBSakigpFHinooMrDioSfIa2/s1JAqSROwNhb8DKvA6hlrUYzgyBgyRBzis1DPDgGzyi3BQR0VBSO8hZA+fluec+KZ27js8/9LlWa10MYnEfmJ+tpowELFCeY43shYDpo+On2IUt8wl4xQ/+E/V5igHlr25IGJXHPwkAVOhFE/3Hbb0914XQvcAg+arTwelBxcoHimbegTopc0lRwfBiTqgCb7UMumYp9htXMMtvaOzrkm4c0PbVDZJGDL5K6GXz878AlcOQGlL5vxoClHmiqlkDxR2w8ez4HLadHyx/XA3AdcDtNwhtfQzY9PfKiwItgzaLKZOEnrOjZOY38fiMmmZK2k4s+vTfhh/xBl0/cre9LwiWGyQNBMqattu4lh0PKvoE3WJ8dbhwQLQJdvmvpGHzJGqyW3JCERTPrpI6FPOCU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(2616005)(31686004)(2906002)(36860700001)(83380400001)(41300700001)(70586007)(70206006)(40460700003)(8676002)(356005)(26005)(7636003)(53546011)(40480700001)(478600001)(82310400005)(82740400003)(36756003)(336012)(426003)(186003)(8936002)(5660300002)(47076005)(16526019)(31696002)(4326008)(6636002)(86362001)(316002)(54906003)(16576012)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 10:10:35.1816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f82e4e9-c710-4a08-8bf5-08dad2bb1f5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5891
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 19:39, Yishai Hadas wrote:
> As mentioned in the previous patches, mlx5 is transferring multiple
> states when the PRE_COPY protocol is used. This states mechanism
> requires the target VM to know the states' size in order to execute
> multiple loads.  Therefore, add SW header, with the needed information,
> for each saved state the source VM is transferring to the target VM.
>
> This patch implements the source VM handling of the headers, following
> patch will implement the target VM handling of the headers.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   drivers/vfio/pci/mlx5/cmd.c  | 56 ++++++++++++++++++++++++++++++++++--
>   drivers/vfio/pci/mlx5/cmd.h  | 10 +++++++
>   drivers/vfio/pci/mlx5/main.c |  2 +-
>   3 files changed, 64 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5fcece201d4c..0af1205e6363 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -351,9 +351,11 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
>   		if (ret)
>   			goto end;
>   
> -		ret = mlx5vf_dma_data_buffer(buf);
> -		if (ret)
> -			goto end;
> +		if (dma_dir != DMA_NONE) {
> +			ret = mlx5vf_dma_data_buffer(buf);
> +			if (ret)
> +				goto end;
> +		}
>   	}
>   
>   	return buf;
> @@ -422,6 +424,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
>   	mutex_lock(&migf->lock);
>   	if (async_data->status) {
>   		mlx5vf_put_data_buffer(async_data->buf);
> +		if (async_data->header_buf)
> +			mlx5vf_put_data_buffer(async_data->header_buf);
>   		migf->state = MLX5_MIGF_STATE_ERROR;
>   		wake_up_interruptible(&migf->poll_wait);
>   	}
> @@ -431,6 +435,32 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
>   	fput(migf->filp);
>   }
>   
> +static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
> +			  size_t image_size)
> +{
> +	struct mlx5_vf_migration_file *migf = header_buf->migf;
> +	struct mlx5_vf_migration_header header = {};
> +	unsigned long flags;
> +	struct page *page;
> +	u8 *to_buff;
> +
> +	header.image_size = cpu_to_le64(image_size);
> +	page = mlx5vf_get_migration_page(header_buf, 0);
> +	if (!page)
> +		return -EINVAL;
> +	to_buff = kmap_local_page(page);
> +	memcpy(to_buff, &header, sizeof(header));
> +	kunmap_local(to_buff);
> +	header_buf->length = sizeof(header);
> +	header_buf->header_image_size = image_size;
> +	header_buf->start_pos = header_buf->migf->max_pos;
> +	migf->max_pos += header_buf->length;
> +	spin_lock_irqsave(&migf->list_lock, flags);
> +	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
> +	spin_unlock_irqrestore(&migf->list_lock, flags);
> +	return 0;
> +}
> +
>   static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
>   {
>   	struct mlx5vf_async_data *async_data = container_of(context,
> @@ -444,6 +474,11 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
>   
>   		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
>   				      actual_image_size);
> +		if (async_data->header_buf) {
> +			status = add_buf_header(async_data->header_buf, image_size);
> +			if (status)
> +				goto err;
> +		}
>   		async_data->buf->length = image_size;
>   		async_data->buf->start_pos = migf->max_pos;
>   		migf->max_pos += async_data->buf->length;
> @@ -455,6 +490,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
>   		wake_up_interruptible(&migf->poll_wait);
>   	}
>   
> +err:
>   	/*
>   	 * The error and the cleanup flows can't run from an
>   	 * interrupt context
> @@ -470,6 +506,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>   {
>   	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
>   	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
> +	struct mlx5_vhca_data_buffer *header_buf = NULL;
>   	struct mlx5vf_async_data *async_data;
>   	int err;
>   
> @@ -499,6 +536,16 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>   		goto err_out;
>   	}
>   
> +	if (track || inc) {

This check should be replaced by some general check whether PRE_COPY  is 
supported by the mlx5 device.

Otherwise the header data won't be sent in some flows (e.g. user space 
moved directly to STOP_COPY without being in PRE_COPY) which is wrong.

Will fix it as part of V2.

Yishai

> +		header_buf = mlx5vf_get_data_buffer(migf,
> +			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> +		if (IS_ERR(header_buf)) {
> +			err = PTR_ERR(header_buf);
> +			goto err_free;
> +		}
> +	}
> +
> +	async_data->header_buf = header_buf;
>   	get_file(migf->filp);
>   	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
>   			       async_data->out,
> @@ -510,7 +557,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>   	return 0;
>   
>   err_exec:
> +	if (header_buf)
> +		mlx5vf_put_data_buffer(header_buf);
>   	fput(migf->filp);
> +err_free:
>   	kvfree(async_data->out);
>   err_out:
>   	complete(&migf->save_comp);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 34e61c7aa23d..2b77e2ab9cd2 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -17,11 +17,18 @@ enum mlx5_vf_migf_state {
>   	MLX5_MIGF_STATE_COMPLETE,
>   };
>   
> +struct mlx5_vf_migration_header {
> +	__le64 image_size;
> +	/* For future use in case we may need to change the kernel protocol */
> +	__le64 flags;
> +};
> +
>   struct mlx5_vhca_data_buffer {
>   	struct sg_append_table table;
>   	loff_t start_pos;
>   	u64 length;
>   	u64 allocated_length;
> +	u64 header_image_size;
>   	u32 mkey;
>   	enum dma_data_direction dma_dir;
>   	u8 dmaed:1;
> @@ -37,6 +44,7 @@ struct mlx5vf_async_data {
>   	struct mlx5_async_work cb_work;
>   	struct work_struct work;
>   	struct mlx5_vhca_data_buffer *buf;
> +	struct mlx5_vhca_data_buffer *header_buf;
>   	int status;
>   	u8 last_chunk:1;
>   	void *out;
> @@ -165,6 +173,8 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
>   void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
>   int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>   			       unsigned int npages);
> +struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
> +				       unsigned long offset);
>   void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>   void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
>   void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index e86489d5dd6e..ec52c8c4533a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -32,7 +32,7 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
>   			    core_device);
>   }
>   
> -static struct page *
> +struct page *
>   mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>   			  unsigned long offset)
>   {


