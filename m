Return-Path: <kvm+bounces-11585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 572EB8786FC
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 19:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8F481F211E6
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566D554FA2;
	Mon, 11 Mar 2024 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWiylKQY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F02A54F83
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710180442; cv=none; b=pUnpqRH9kKq+wFiGVn65u3mYuypVZQWzd5qRzmBsgM9sCejrSWP1gS60ito7ywHILZNyMEK1d5scT0jlWd+lylssfsx9DxYBjHsiN9b9RgrNLz5394/Pwg/LQSi+yUn6oDszY2vET7uJh2+18faew+e8tHy3bcjCf/Q/RKx6rWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710180442; c=relaxed/simple;
	bh=ETqdXubKVdbeBV0hpL13nJazrbMK4O7SLnLY1pKDnSc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I62CXsUZ70ljxus3Jdy9+BUdaxR0E74Z0F6ZIbjApSKLdSy1l3aEyBDwy1PiDGecS6XHeiOhbq4TT+xmwRzSRXIrPucvspedaMwU7K9oQduS8kKfxc5qDZ7l7V8N/6IBTuXpm19OQmtwWK0no6w7mVkpLFYs/5389mN3qz2jnq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWiylKQY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710180439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1bCDbEeMTty6864F6JmgSHmRYsmnfFaAHOZVtTt6zU=;
	b=DWiylKQYGgJCdC+i0FcyPl/dxHdz/wD3Io17yBehg4hB6WrR5v2BXBcMbr1kuuUCF18Vbq
	3aB5dw0AbAbKXxFl/BewxHEcaa5RkZuqaL298RtS+BwO5tV3keHooeMSD8SALsQCXwkHjC
	zSAX62I99PTTesd1CSgMP1nHxVlMyTw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-CCq5ECIlODi8KISfgmYGUA-1; Mon, 11 Mar 2024 14:07:17 -0400
X-MC-Unique: CCq5ECIlODi8KISfgmYGUA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c8c43ba634so70794639f.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 11:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710180437; x=1710785237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1bCDbEeMTty6864F6JmgSHmRYsmnfFaAHOZVtTt6zU=;
        b=uC0K9vDOoCCgKaQDlRCeRhh6GPlVJ9xbSa7pB+/gNV04+88I8+fYUF1WctBoP78Q1G
         gZLpz4E0gcSNFLlHRFk4KicntF8hE8fhSmjWZgzXgMw+uMJ0H1kiNhdMD92ocJEl9VVT
         RFm4hZg9/SZDsngu6tsTb7s4TYVWwPEYmsoHPVulgznyjyrCBITAWf1bV9N6PDs/9iLd
         UBjVbzSNCSQslVo9ImW4l3jW79n+8MYA8JFyeRA8uOdcQnyfWv6W6D3liHeTARCnzN40
         nPIB7s53dcBrhFBgCWGmbpWtvBbEhMuSyQckdZwPivwcjOLdHiW+EkdZYJbAAvXxr2f8
         5o/A==
X-Forwarded-Encrypted: i=1; AJvYcCUFA2pxzd3fu5SLp0l0FgXhLW26LpqdS+xu7dzmVb+49aHnCcgY4t8iebXJ+V9KA61sRFI3B6Z7PR5cQtG9FnnnXmYG
X-Gm-Message-State: AOJu0YxH52SfwmNf47+/pCZkZM7vH99vcBkKVIzt+HAc4H0Fw5Yr+PuV
	PY+vtXAHMe9ZEYJMn5X86twZBmQvFbo/p9E7hJ+QMrur5Q5iuWG8lch7rBOFbSuivMgUuC0UFvw
	6dlUH0v8NM7vBrQWe6MLbupR1WJarDFDTyoZ33JvF9LoFk0FzVA==
X-Received: by 2002:a05:6602:72f:b0:7c8:c044:a6bb with SMTP id g15-20020a056602072f00b007c8c044a6bbmr2116537iox.4.1710180436944;
        Mon, 11 Mar 2024 11:07:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiwoihuxkfZARyB/5QH06ooH3zFKU+rK+6gxSsMMuy8Lo5iRa9zr8hFV6EvG/3YtTNMwpAjA==
X-Received: by 2002:a05:6602:72f:b0:7c8:c044:a6bb with SMTP id g15-20020a056602072f00b007c8c044a6bbmr2116512iox.4.1710180436586;
        Mon, 11 Mar 2024 11:07:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r10-20020a5e950a000000b007c8a993d5d2sm1494104ioj.47.2024.03.11.11.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 11:07:16 -0700 (PDT)
Date: Mon, 11 Mar 2024 12:07:14 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio] vfio/mlx5: Enforce PRE_COPY support
Message-ID: <20240311120714.6e009f43.alex.williamson@redhat.com>
In-Reply-To: <2cd2af54-aceb-4728-bd68-dae060b252bb@nvidia.com>
References: <20240306105624.114830-1-yishaih@nvidia.com>
	<2cd2af54-aceb-4728-bd68-dae060b252bb@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Mar 2024 11:40:11 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 06/03/2024 12:56, Yishai Hadas wrote:
> > Enable live migration only once the firmware supports PRE_COPY.
> > 
> > PRE_COPY has been supported by the firmware for a long time already [1]
> > and is required to achieve a low downtime upon live migration.
> > 
> > This lets us clean up some old code that is not applicable those days
> > while PRE_COPY is fully supported by the firmware.
> > 
> > [1] The minimum firmware version that supports PRE_COPY is 28.36.1010,
> > it was released on January 23.

"on January 23" reads to me as "on January 23rd", but I find the
release notes[1] are dated February 02, 2023, so I think the intent is
"in January 2023".  I'll apply with that change.  Thanks,

Alex

[1]https://docs.nvidia.com/networking/display/connectx7firmwarev28361010

> > 
> > No firmware without PRE_COPY support ever available to users.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>  
> 
> Hi Alex,
> 
> Are we OK here ?
> 
> It's a cleanup patch for a non applicable code.
> 
> Thanks,
> Yishai
> 
> > ---
> >   drivers/vfio/pci/mlx5/cmd.c  |  83 +++++++++++++++++++-------
> >   drivers/vfio/pci/mlx5/cmd.h  |   6 --
> >   drivers/vfio/pci/mlx5/main.c | 109 +++--------------------------------
> >   3 files changed, 71 insertions(+), 127 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> > index c54bcd5d0917..41a4b0cf4297 100644
> > --- a/drivers/vfio/pci/mlx5/cmd.c
> > +++ b/drivers/vfio/pci/mlx5/cmd.c
> > @@ -233,6 +233,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
> >   	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
> >   		goto end;
> >   
> > +	if (!(MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> > +	      MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state)))
> > +		goto end;
> > +
> >   	mvdev->vf_id = pci_iov_vf_id(pdev);
> >   	if (mvdev->vf_id < 0)
> >   		goto end;
> > @@ -262,17 +266,14 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
> >   	mvdev->migrate_cap = 1;
> >   	mvdev->core_device.vdev.migration_flags =
> >   		VFIO_MIGRATION_STOP_COPY |
> > -		VFIO_MIGRATION_P2P;
> > +		VFIO_MIGRATION_P2P |
> > +		VFIO_MIGRATION_PRE_COPY;
> > +
> >   	mvdev->core_device.vdev.mig_ops = mig_ops;
> >   	init_completion(&mvdev->tracker_comp);
> >   	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
> >   		mvdev->core_device.vdev.log_ops = log_ops;
> >   
> > -	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
> > -	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
> > -		mvdev->core_device.vdev.migration_flags |=
> > -			VFIO_MIGRATION_PRE_COPY;
> > -
> >   	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
> >   		mvdev->chunk_mode = 1;
> >   
> > @@ -414,6 +415,50 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
> >   	kfree(buf);
> >   }
> >   
> > +static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> > +				      unsigned int npages)
> > +{
> > +	unsigned int to_alloc = npages;
> > +	struct page **page_list;
> > +	unsigned long filled;
> > +	unsigned int to_fill;
> > +	int ret;
> > +
> > +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> > +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> > +	if (!page_list)
> > +		return -ENOMEM;
> > +
> > +	do {
> > +		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
> > +						page_list);
> > +		if (!filled) {
> > +			ret = -ENOMEM;
> > +			goto err;
> > +		}
> > +		to_alloc -= filled;
> > +		ret = sg_alloc_append_table_from_pages(
> > +			&buf->table, page_list, filled, 0,
> > +			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
> > +			GFP_KERNEL_ACCOUNT);
> > +
> > +		if (ret)
> > +			goto err;
> > +		buf->allocated_length += filled * PAGE_SIZE;
> > +		/* clean input for another bulk allocation */
> > +		memset(page_list, 0, filled * sizeof(*page_list));
> > +		to_fill = min_t(unsigned int, to_alloc,
> > +				PAGE_SIZE / sizeof(*page_list));
> > +	} while (to_alloc > 0);
> > +
> > +	kvfree(page_list);
> > +	return 0;
> > +
> > +err:
> > +	kvfree(page_list);
> > +	return ret;
> > +}
> > +
> >   struct mlx5_vhca_data_buffer *
> >   mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
> >   			 size_t length,
> > @@ -680,22 +725,20 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
> >   		goto err_out;
> >   	}
> >   
> > -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
> > -		if (async_data->stop_copy_chunk) {
> > -			u8 header_idx = buf->stop_copy_chunk_num ?
> > -				buf->stop_copy_chunk_num - 1 : 0;
> > +	if (async_data->stop_copy_chunk) {
> > +		u8 header_idx = buf->stop_copy_chunk_num ?
> > +			buf->stop_copy_chunk_num - 1 : 0;
> >   
> > -			header_buf = migf->buf_header[header_idx];
> > -			migf->buf_header[header_idx] = NULL;
> > -		}
> > +		header_buf = migf->buf_header[header_idx];
> > +		migf->buf_header[header_idx] = NULL;
> > +	}
> >   
> > -		if (!header_buf) {
> > -			header_buf = mlx5vf_get_data_buffer(migf,
> > -				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> > -			if (IS_ERR(header_buf)) {
> > -				err = PTR_ERR(header_buf);
> > -				goto err_free;
> > -			}
> > +	if (!header_buf) {
> > +		header_buf = mlx5vf_get_data_buffer(migf,
> > +			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> > +		if (IS_ERR(header_buf)) {
> > +			err = PTR_ERR(header_buf);
> > +			goto err_free;
> >   		}
> >   	}
> >   
> > diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> > index 707393df36c4..df421dc6de04 100644
> > --- a/drivers/vfio/pci/mlx5/cmd.h
> > +++ b/drivers/vfio/pci/mlx5/cmd.h
> > @@ -13,9 +13,6 @@
> >   #include <linux/mlx5/cq.h>
> >   #include <linux/mlx5/qp.h>
> >   
> > -#define MLX5VF_PRE_COPY_SUPP(mvdev) \
> > -	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
> > -
> >   enum mlx5_vf_migf_state {
> >   	MLX5_MIGF_STATE_ERROR = 1,
> >   	MLX5_MIGF_STATE_PRE_COPY_ERROR,
> > @@ -25,7 +22,6 @@ enum mlx5_vf_migf_state {
> >   };
> >   
> >   enum mlx5_vf_load_state {
> > -	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
> >   	MLX5_VF_LOAD_STATE_READ_HEADER,
> >   	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
> >   	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
> > @@ -228,8 +224,6 @@ struct mlx5_vhca_data_buffer *
> >   mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
> >   		       size_t length, enum dma_data_direction dma_dir);
> >   void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
> > -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> > -			       unsigned int npages);
> >   struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
> >   				       unsigned long offset);
> >   void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
> > diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> > index 3982fcf60cf2..61d9b0f9146d 100644
> > --- a/drivers/vfio/pci/mlx5/main.c
> > +++ b/drivers/vfio/pci/mlx5/main.c
> > @@ -65,50 +65,6 @@ mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
> >   	return NULL;
> >   }
> >   
> > -int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
> > -			       unsigned int npages)
> > -{
> > -	unsigned int to_alloc = npages;
> > -	struct page **page_list;
> > -	unsigned long filled;
> > -	unsigned int to_fill;
> > -	int ret;
> > -
> > -	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> > -	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> > -	if (!page_list)
> > -		return -ENOMEM;
> > -
> > -	do {
> > -		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
> > -						page_list);
> > -		if (!filled) {
> > -			ret = -ENOMEM;
> > -			goto err;
> > -		}
> > -		to_alloc -= filled;
> > -		ret = sg_alloc_append_table_from_pages(
> > -			&buf->table, page_list, filled, 0,
> > -			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
> > -			GFP_KERNEL_ACCOUNT);
> > -
> > -		if (ret)
> > -			goto err;
> > -		buf->allocated_length += filled * PAGE_SIZE;
> > -		/* clean input for another bulk allocation */
> > -		memset(page_list, 0, filled * sizeof(*page_list));
> > -		to_fill = min_t(unsigned int, to_alloc,
> > -				PAGE_SIZE / sizeof(*page_list));
> > -	} while (to_alloc > 0);
> > -
> > -	kvfree(page_list);
> > -	return 0;
> > -
> > -err:
> > -	kvfree(page_list);
> > -	return ret;
> > -}
> > -
> >   static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
> >   {
> >   	mutex_lock(&migf->lock);
> > @@ -777,36 +733,6 @@ mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
> >   	return 0;
> >   }
> >   
> > -static int
> > -mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
> > -				   loff_t requested_length,
> > -				   const char __user **buf, size_t *len,
> > -				   loff_t *pos, ssize_t *done)
> > -{
> > -	int ret;
> > -
> > -	if (requested_length > MAX_LOAD_SIZE)
> > -		return -ENOMEM;
> > -
> > -	if (vhca_buf->allocated_length < requested_length) {
> > -		ret = mlx5vf_add_migration_pages(
> > -			vhca_buf,
> > -			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
> > -				     PAGE_SIZE));
> > -		if (ret)
> > -			return ret;
> > -	}
> > -
> > -	while (*len) {
> > -		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
> > -						    done);
> > -		if (ret)
> > -			return ret;
> > -	}
> > -
> > -	return 0;
> > -}
> > -
> >   static ssize_t
> >   mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
> >   			 struct mlx5_vhca_data_buffer *vhca_buf,
> > @@ -1038,13 +964,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
> >   			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
> >   			break;
> >   		}
> > -		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
> > -			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
> > -						requested_length,
> > -						&buf, &len, pos, &done);
> > -			if (ret)
> > -				goto out_unlock;
> > -			break;
> >   		case MLX5_VF_LOAD_STATE_READ_IMAGE:
> >   			ret = mlx5vf_resume_read_image(migf, vhca_buf,
> >   						migf->record_size,
> > @@ -1114,21 +1033,16 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
> >   	}
> >   
> >   	migf->buf[0] = buf;
> > -	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
> > -		buf = mlx5vf_alloc_data_buffer(migf,
> > -			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> > -		if (IS_ERR(buf)) {
> > -			ret = PTR_ERR(buf);
> > -			goto out_buf;
> > -		}
> > -
> > -		migf->buf_header[0] = buf;
> > -		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
> > -	} else {
> > -		/* Initial state will be to read the image */
> > -		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
> > +	buf = mlx5vf_alloc_data_buffer(migf,
> > +		sizeof(struct mlx5_vf_migration_header), DMA_NONE);
> > +	if (IS_ERR(buf)) {
> > +		ret = PTR_ERR(buf);
> > +		goto out_buf;
> >   	}
> >   
> > +	migf->buf_header[0] = buf;
> > +	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
> > +
> >   	stream_open(migf->filp->f_inode, migf->filp);
> >   	mutex_init(&migf->lock);
> >   	INIT_LIST_HEAD(&migf->buf_list);
> > @@ -1262,13 +1176,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
> >   	}
> >   
> >   	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
> > -		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
> > -			ret = mlx5vf_cmd_load_vhca_state(mvdev,
> > -							 mvdev->resuming_migf,
> > -							 mvdev->resuming_migf->buf[0]);
> > -			if (ret)
> > -				return ERR_PTR(ret);
> > -		}
> >   		mlx5vf_disable_fds(mvdev, NULL);
> >   		return NULL;
> >   	}  
> 


