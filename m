Return-Path: <kvm+bounces-11074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7286A8729DD
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 22:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28D2428D32E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD37112CD9A;
	Tue,  5 Mar 2024 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENMCKtVf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1B12C544
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709675812; cv=none; b=jjqe0nOwHFjZfAWNCKsO+ejVa8x7fqLBQlS2BuJwSfx2pJeuEwyR8gvrOqA0r8uTg7U6JZUbwcHfDhy9Ym+v37IcxXkTfOX1RLyvnDIZ3At9c2ZclqMspFKIlp8Rp3wwm+7neN6IdNUN9Cwm2BxYV1XeiY3VtMZ4S2hSAc3dlQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709675812; c=relaxed/simple;
	bh=5xbFPMPPmMnEFjHCVc6ooucb9R7Ai3mit8wINjKMbvw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUre1rne1Po3ftHw6GZTBM6anogr0achmYqRF22vJnW+FEduNSe8xLNeOp7iJcjVvg67P+zipnsFZebAMw5dt5YEFNnUrMuDcUZfDsE2zB7WXqTAo98bYLToOADj5GpkVHs0gxpiTBDU2xaFkmT3pqlDeeZff6BhDSCNe/ozaRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ENMCKtVf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709675806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cTbi0/4e4gvaxDKDfWsQW+NGSYy9QBr5aF3wWDHR01M=;
	b=ENMCKtVfAOX62iCzozKko+tPQmFY17lBgHZLL22Jl5hmyhQwh7m0bK1M6TWnD3Kdh9nV5e
	0wjbTbMwggBlQf3rNMWfu46E+D2Q1DyAyo/gW0nuc9/nYMuOBGJ1Fol6XkcqdvEhpb/jXT
	qYCntj0HAmq8ruiUrsF/XHIc+mm9ZC4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-Vr_R-p9kPOeccpC9cx-vwQ-1; Tue, 05 Mar 2024 16:56:45 -0500
X-MC-Unique: Vr_R-p9kPOeccpC9cx-vwQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c836b4779fso326399739f.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 13:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709675804; x=1710280604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTbi0/4e4gvaxDKDfWsQW+NGSYy9QBr5aF3wWDHR01M=;
        b=Sr5rZykEcmxphTrtExCnW2lu8N/J/e5YK+x4KTmBxPZ1ZbhaETTrBxhtnkG2EzTzib
         rz3BCh0IAQaNuvX0d4wke0Tmn7IdPxZr/1FTsus4dKp4viW9BVNuOL81EA2dtg5+GeAV
         8aUZRaBTQlLhmJJZI1uecBrKKFmXsf+TiK2PVxjDThdNWaOEvNdqVDdrbX9K/HraN5CA
         iPwDOpvtf2YbewKT2edTUTtJVWDcZZ6DAajWzK/ED38uX9e5iFC1JI4PkchCI1zYvdxp
         wRUU7JNPp3mDw0cnDzx9WpN2qPa8VaMNZsVrrKEgutfTkDUDrT+woOW8YkdUL11pxgUm
         NFyg==
X-Forwarded-Encrypted: i=1; AJvYcCWb8TTwtFDhZNmfsufGmhTrAjt82OYtCLkumNmyroDUz4ytgCuZCdzUU8CitUzT2NJr/Iv8U6aONgZ1NX1vSxfeJXTv
X-Gm-Message-State: AOJu0Yw8/AUL2Fc4wXQNOv0HRu3ooABmiR+iz7BudONzBHczHvUw/AF/
	p5vKeQRBmE739MoZfOTFNQZMIKkJASbXo99ArRdfNKmcWLuG5vDoB+Mvw0+p4MOBzOVxjrMbw6H
	wtJxxMrcRDFzKy8nLJYMMM97bVAeHrPuHqPzsG1hffeXlpstfDg==
X-Received: by 2002:a5e:a714:0:b0:7c8:34b1:e446 with SMTP id b20-20020a5ea714000000b007c834b1e446mr10979423iod.12.1709675804414;
        Tue, 05 Mar 2024 13:56:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE9ep/TUCroJXG4fVQJ1+2AjopcTvgVZzz29YXZoyyyXNAVn8GwDafJhl7DGEF64/y5MbEdTA==
X-Received: by 2002:a5e:a714:0:b0:7c8:34b1:e446 with SMTP id b20-20020a5ea714000000b007c834b1e446mr10979407iod.12.1709675804118;
        Tue, 05 Mar 2024 13:56:44 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id j13-20020a02cc6d000000b004748a41c763sm2938663jaq.137.2024.03.05.13.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 13:56:43 -0800 (PST)
Date: Tue, 5 Mar 2024 14:56:42 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio] vfio/mlx5: Enforce PRE_COPY support
Message-ID: <20240305145642.3f2781be.alex.williamson@redhat.com>
In-Reply-To: <20240305103037.61144-1-yishaih@nvidia.com>
References: <20240305103037.61144-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Mar 2024 12:30:37 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Enable live migration only once the firmware supports PRE_COPY.
> 
> PRE_COPY has been supported by the firmware for a long time already and
> is required to achieve a low downtime upon live migration.
> 
> This lets us clean up some old code that is not applicable those days
> while PRE_COPY is fully supported by the firmware.

Was firmware without PRE_COPY support ever available to users?  AIUI
this would disable migration support on devices with older firmware, so
if that firmware exists in the wild this should go through a
deprecation process.

We should also likely note a minimum firmware revision and time frame
when PRE_COPY support was added in firmware.  Thanks,

Alex


> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  |  83 +++++++++++++++++++-------
>  drivers/vfio/pci/mlx5/cmd.h  |   6 --
>  drivers/vfio/pci/mlx5/main.c | 109 +++--------------------------------
>  3 files changed, 71 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index c54bcd5d0917..41a4b0cf4297 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -233,6 +233,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>  	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
>  		goto end;
>  
> +	if (!(MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> +	      MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state)))
> +		goto end;
> +
>  	mvdev->vf_id = pci_iov_vf_id(pdev);
>  	if (mvdev->vf_id < 0)
>  		goto end;
> @@ -262,17 +266,14 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
>  	mvdev->migrate_cap = 1;
>  	mvdev->core_device.vdev.migration_flags =
>  		VFIO_MIGRATION_STOP_COPY |
> -		VFIO_MIGRATION_P2P;
> +		VFIO_MIGRATION_P2P |
> +		VFIO_MIGRATION_PRE_COPY;
> +
>  	mvdev->core_device.vdev.mig_ops = mig_ops;
>  	init_completion(&mvdev->tracker_comp);
>  	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
>  		mvdev->core_device.vdev.log_ops = log_ops;
>  
> -	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> -	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
> -		mvdev->core_device.vdev.migration_flags |=
> -			VFIO_MIGRATION_PRE_COPY;
> -
>  	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
>  		mvdev->chunk_mode = 1;
>  
> @@ -414,6 +415,50 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
>  	kfree(buf);
>  }
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
>  struct mlx5_vhca_data_buffer *
>  mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
>  			 size_t length,
> @@ -680,22 +725,20 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  		goto err_out;
>  	}
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
>  		}
>  	}
>  
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 707393df36c4..df421dc6de04 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -13,9 +13,6 @@
>  #include <linux/mlx5/cq.h>
>  #include <linux/mlx5/qp.h>
>  
> -#define MLX5VF_PRE_COPY_SUPP(mvdev) \
> -	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
> -
>  enum mlx5_vf_migf_state {
>  	MLX5_MIGF_STATE_ERROR = 1,
>  	MLX5_MIGF_STATE_PRE_COPY_ERROR,
> @@ -25,7 +22,6 @@ enum mlx5_vf_migf_state {
>  };
>  
>  enum mlx5_vf_load_state {
> -	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
>  	MLX5_VF_LOAD_STATE_READ_HEADER,
>  	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
>  	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
> @@ -228,8 +224,6 @@ struct mlx5_vhca_data_buffer *
>  mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
>  		       size_t length, enum dma_data_direction dma_dir);
>  void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
> -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> -			       unsigned int npages);
>  struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>  				       unsigned long offset);
>  void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 3982fcf60cf2..61d9b0f9146d 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -65,50 +65,6 @@ mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
>  	return NULL;
>  }
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
>  static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
>  {
>  	mutex_lock(&migf->lock);
> @@ -777,36 +733,6 @@ mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
>  	return 0;
>  }
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
>  static ssize_t
>  mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
>  			 struct mlx5_vhca_data_buffer *vhca_buf,
> @@ -1038,13 +964,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
>  			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
>  			break;
>  		}
> -		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
> -			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
> -						requested_length,
> -						&buf, &len, pos, &done);
> -			if (ret)
> -				goto out_unlock;
> -			break;
>  		case MLX5_VF_LOAD_STATE_READ_IMAGE:
>  			ret = mlx5vf_resume_read_image(migf, vhca_buf,
>  						migf->record_size,
> @@ -1114,21 +1033,16 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
>  	}
>  
>  	migf->buf[0] = buf;
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
>  	}
>  
> +	migf->buf_header[0] = buf;
> +	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
> +
>  	stream_open(migf->filp->f_inode, migf->filp);
>  	mutex_init(&migf->lock);
>  	INIT_LIST_HEAD(&migf->buf_list);
> @@ -1262,13 +1176,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>  	}
>  
>  	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
> -		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
> -			ret = mlx5vf_cmd_load_vhca_state(mvdev,
> -							 mvdev->resuming_migf,
> -							 mvdev->resuming_migf->buf[0]);
> -			if (ret)
> -				return ERR_PTR(ret);
> -		}
>  		mlx5vf_disable_fds(mvdev, NULL);
>  		return NULL;
>  	}


