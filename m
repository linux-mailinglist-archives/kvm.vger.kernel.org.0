Return-Path: <kvm+bounces-25940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA6C96D7FF
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0FC11C21568
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152BB19AA43;
	Thu,  5 Sep 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDbPgUAf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A3C1991B1
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538320; cv=none; b=BdhXpIppuTcmfxpNNOKPFjTrdHmhNk03ZGOQbghTwGgSOwSWxk7lH+ktgwV+sg6jiC2Evb1IE8YFMZWOzrI97Vm4T6V0kPKeX6HEoa+PQifUc1UOac0+uOqGYqT2AVhjvl0sR31xB8IKVHpNBSUBs811mvn4kpi7ERxBVjqA5cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538320; c=relaxed/simple;
	bh=rxVBrr5JB+LiJcrM9kipJYfpbElLY1RcLEjHjvLLoPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h23SZqxM1Y5Up1j305L0dhfM6jMnewWOwXXcUE7pOY7A3zIU2rXYTAoGDkCy9UsOwCvoro6Dq/REluL3AFghU4oTBnGGXLz9O4xBKCdmiU3aiqOH2t03qcMkoqtGjiWSMSl3LhdZnMGSud5aWnbRbQQP9XivRKxKzLUFajfaOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDbPgUAf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725538317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uV9Ps9I2kiQkXKKB9CYYT2x6uyi7nvkPpJLSIw5AOEQ=;
	b=MDbPgUAfnTpApeWOUkmsAgXEwAtcEGB6TkO3uRiKo/UIZQM7wsndVbKcA+ZwBipoHirMDX
	XWv20IxjcBrqGlyMTlePM9q7x2x+nzthSuggktr8g8M71Bo3dzW8Y1o5oNd2/67hHO3WiV
	IDiuvRs7/zIbQcRZjGoBBuRJLuT15eM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-NqSK2JG7PS2bor2G4EZhkw-1; Thu, 05 Sep 2024 08:11:56 -0400
X-MC-Unique: NqSK2JG7PS2bor2G4EZhkw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374b981dd62so410341f8f.3
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 05:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725538315; x=1726143115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uV9Ps9I2kiQkXKKB9CYYT2x6uyi7nvkPpJLSIw5AOEQ=;
        b=jQY0RXhRONZcdZV/mCUHx1x9ZCwu0t19HXPlK+YTDTwjtbltuOA4Ked3gCZ6XAtaya
         sNWB9D1vrCdNgU+o8xiT9A1+/7wiCmjjBRhocOEoekZT1xz0FyZxULCtTUVmYl2rLXla
         E0dLHMWNO5433Sl8nNbSJEm+0cgIWJMpcB/4Y25PHfIeRDiU4xMFfEGg1U2KfHStrssu
         HqN/gLLrBb8OpP1wQFwSRtMjJYE4HV0woeVhEjynJd9fLBfhOuKSz4gkf7MbQdoUQCEW
         lqp19JtOmiF/TNM7yBP4PT38tT3csuaU8NbMD5iNVLV7RtXXb3B5bDmovFDwKL7dLO8g
         2JcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyFjS2a59bbyc1qNjOvx56YhAB4e0v7/v9ZT09LfXH7fd7B3FV7WXdZ0ZbOORGSPFOD9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtO3BaaQUXsv0HQkryZ7FGZ1zHRXmMlY5Vju6AGhWEpBCBpvsB
	dJfmYm7zrOVNNg+AfRqnxWbjpqYQM3ktEZzYzBaZaY47CLbf9MHIZNuR0keUZiae2bBxIFsADmx
	6fjwQr8Qyo1KRooV6W2N1st1wQc4J2O7BbXd0BWvoVcxWGUBeqw==
X-Received: by 2002:adf:e38c:0:b0:371:a844:d326 with SMTP id ffacd0b85a97d-374bcfe5e74mr12844283f8f.43.1725538315005;
        Thu, 05 Sep 2024 05:11:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWHWAhLTW54aL8/fKJKu2un/o8IsgIWTybMSffflhkCvx7Czg/Z9Plp17Cp/9d4oe6RJHNRQ==
X-Received: by 2002:adf:e38c:0:b0:371:a844:d326 with SMTP id ffacd0b85a97d-374bcfe5e74mr12844227f8f.43.1725538314095;
        Thu, 05 Sep 2024 05:11:54 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1ee:dac1:384c:40cd:a203:ee4f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42baf1b0c18sm250501545e9.37.2024.09.05.05.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 05:11:53 -0700 (PDT)
Date: Thu, 5 Sep 2024 08:11:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, virtualization@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
	Jingbo Xu <jefflexu@linux.alibaba.com>, pgootzen@nvidia.com,
	smalin@nvidia.com, larora@nvidia.com, ialroy@nvidia.com,
	oren@nvidia.com, izach@nvidia.com,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Subject: Re: [PATCH v1 1/2] virtio_fs: introduce virtio_fs_put_locked helper
Message-ID: <20240905081133-mutt-send-email-mst@kernel.org>
References: <20240825130716.9506-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240825130716.9506-1-mgurtovoy@nvidia.com>

Cc: "Eugenio Pérez" <eperezma@redhat.com>


On Sun, Aug 25, 2024 at 04:07:15PM +0300, Max Gurtovoy wrote:
> Introduce a new helper function virtio_fs_put_locked to encapsulate the
> common pattern of releasing a virtio_fs reference while holding a lock.
> The existing virtio_fs_put helper will be used to release a virtio_fs
> reference while not holding a lock.
> 
> Also add an assertion in case the lock is not taken when it should.
> 
> Reviewed-by: Idan Zach <izach@nvidia.com>
> Reviewed-by: Shai Malin <smalin@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  fs/fuse/virtio_fs.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index dd5260141615..43f7be1d7887 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -201,18 +201,25 @@ static const struct kobj_type virtio_fs_ktype = {
>  };
>  
>  /* Make sure virtiofs_mutex is held */
> -static void virtio_fs_put(struct virtio_fs *fs)
> +static void virtio_fs_put_locked(struct virtio_fs *fs)
>  {
> +	lockdep_assert_held(&virtio_fs_mutex);
> +
>  	kobject_put(&fs->kobj);
>  }
>  
> +static void virtio_fs_put(struct virtio_fs *fs)
> +{
> +	mutex_lock(&virtio_fs_mutex);
> +	virtio_fs_put_locked(fs);
> +	mutex_unlock(&virtio_fs_mutex);
> +}
> +
>  static void virtio_fs_fiq_release(struct fuse_iqueue *fiq)
>  {
>  	struct virtio_fs *vfs = fiq->priv;
>  
> -	mutex_lock(&virtio_fs_mutex);
>  	virtio_fs_put(vfs);
> -	mutex_unlock(&virtio_fs_mutex);
>  }
>  
>  static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
> @@ -1052,7 +1059,7 @@ static void virtio_fs_remove(struct virtio_device *vdev)
>  
>  	vdev->priv = NULL;
>  	/* Put device reference on virtio_fs object */
> -	virtio_fs_put(fs);
> +	virtio_fs_put_locked(fs);
>  	mutex_unlock(&virtio_fs_mutex);
>  }
>  
> @@ -1596,9 +1603,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
>  
>  out_err:
>  	kfree(fc);
> -	mutex_lock(&virtio_fs_mutex);
>  	virtio_fs_put(fs);
> -	mutex_unlock(&virtio_fs_mutex);
>  	return err;
>  }
>  
> -- 
> 2.18.1


