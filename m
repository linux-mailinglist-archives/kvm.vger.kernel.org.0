Return-Path: <kvm+bounces-53513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF53B13124
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE05C3B1145
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F69223DF9;
	Sun, 27 Jul 2025 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ts8I5MDw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B437080D
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640457; cv=none; b=nvejXT+yrc/p36wc06wBJNHOUZQpWG39OkIf/cicXE1V6Ed6MKT+99gOVq9OW5aTL+KdY138iHSpnigLdLcLTxJPqdXLypJD+X9e9r8f3CTnM0T1+0zExnXNLFBmtZY2wNFsTu9hEGrtNC/TGs1gyBpwN6hGTrI22Aew5AFx/Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640457; c=relaxed/simple;
	bh=ZNwYPqCXc716+CPAJIZgMlFJ8UWE7xA8vfmtNewg88E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NlUs1uADznsUajyTkaaGFI/Etw7kJ2q3KKKJ7ggSN4YhcttQRg24+Na5Zc9SutzgENPG8C0pt1bMhcuxQFVdpxp9NXw4fqC3CYCUw46C8tx3DvsqO4jjvctC2CWAQBsCku5PCM3GckEG36mzvX+1mC0p2e1YwLPYMKVnSYi4J3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ts8I5MDw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso42815e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753640453; x=1754245253; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoqh8aGiy9k/GWQkFeAJUj3hrYIrXSssOOlRTlmEWBg=;
        b=Ts8I5MDwI+LzALbyv62HMdcAr/0zvzpSagtDiDmwetTBcibL+8unk1xDJxtD1lnbVc
         9tZmPs311iSh21FRnxnnEm9Mdr+g6MJR2p6Cctrs1pTDynjQyZPUr2DkSwWgoPe/IPFg
         SShhIdmrClrX6DX2WYu9BqrzNV0JHVmndHAuAENCeYK2TRJYkeNTy5AiWskqUQeNgAcP
         QefJvUfxtFOIJveE/u/jZ4Dlx3yKrQ3SULSdv0ywsfmpzfQutwr2iQzKYyUjbFVY+iH4
         AiDyu97pA3Uo5Xaug84OLp3vxO/jrt4VZEm+U9JTNHE4g96g+YOWxFsbBwDNnpCa9ssb
         GXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640453; x=1754245253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aoqh8aGiy9k/GWQkFeAJUj3hrYIrXSssOOlRTlmEWBg=;
        b=kXhBTWmZCuLPCMuc5npQfuTDDnPYwtWe6iioVlWgjTCLg0e0yOjbP3lmN2+FN7eeTU
         YJJDQmPMQydhf5JMqby2laBYsTKxaYMNXB3yNgfod7aW2eKGjSjXwfZ4+AjEDJmZIviY
         xPLlz4AoEkkrJkzZvPmgZlat6kGEErmYW3NxW4FzKcOlkc3YLyz9S930WbFnmja8MDfW
         scQ+xytJZO/BUNOr74v3XiJL/3GnMHqbOGUvNDHhGT900p/ZkPzxR4IhuBjsIyElnBDe
         gyq35ih8cM48Bt97aIhqWkzhKo7Mzy5SvLhC2YnZ/zItcmh9U5WJVRhnA3ikMah4V3Fo
         wGqA==
X-Gm-Message-State: AOJu0Yz1jzeRjbB7O/06pb9xBAxyKkpnV5kw+7ljWMs202L8RzXKeE4K
	wU12EWFRVYeWOt+vfPnrKqNnv9VF1KIHsHcDpHtjUlCs3iKSJ7bfDPJsY0acQvbacQ==
X-Gm-Gg: ASbGncunrkrf3r6BxcwcvB1Mdf4ykSwNbU4ftyvxynjBU880oTZCmBtErd/L2JkMdUt
	isGAT0HPxRbOTLBliOKyMg1GV0HPfCyDaOLUOHUs5F/iptLJn00fQkusa7aHLoUhVyoFc0Dh2QX
	wopL4aF56ppFImgctMT6QJUCAJGjqAlYbhBpk6G4oeOLQa6ZEG1G0sddMhNTFStqoAyMAxr3jXU
	LC608MnRbF3YDg/O2/699bzyUXbajZRL+tuqK2ZErvMen2ulugDnBilEQvYaQkirmCOOUTPyFRz
	2WGeaaJ2J5WtS6AF67Tb4EZb0EhmSSoIERk8rFPwnIbaFn1f80yyT/CrdfuLzVEUflfZ4QogdQb
	TrkJk8zKVxFcuGaTwFElz4nwddhkl5SPBF34VekhR+VX1SzQL1eWDtf+bV05G
X-Google-Smtp-Source: AGHT+IH//LXBKZ0cdby/UzuZNvzQ9veU+ae1jsD7cPmzJU282p6Iirzy2BAWCawSI/d5+j/V3A7Bpg==
X-Received: by 2002:a05:600c:c05a:b0:453:5ffb:e007 with SMTP id 5b1f17b1804b1-4587c1f7b91mr1229025e9.4.1753640453355;
        Sun, 27 Jul 2025 11:20:53 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587ac660b6sm71401795e9.24.2025.07.27.11.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:20:52 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:20:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 02/10] vfio: Rename some functions
Message-ID: <aIZuAlHQRdi5PUqY@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-2-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525074917.150332-2-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:08PM +0530, Aneesh Kumar K.V (Arm) wrote:
> We will add iommufd support in later patches. Rename the old vfio
> method as legacy vfio.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  vfio/core.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/vfio/core.c b/vfio/core.c
> index c6b305c30cf7..424dc4ed3aef 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -282,7 +282,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  	}
>  }
>  
> -static int vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
> +static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
>  	struct vfio_group *group = vdev->group;
> @@ -340,12 +340,12 @@ err_close_device:
>  	return ret;
>  }
>  
> -static int vfio_configure_devices(struct kvm *kvm)
> +static int legacy_vfio_configure_devices(struct kvm *kvm)
>  {
>  	int i, ret;
>  
>  	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
> -		ret = vfio_configure_device(kvm, &vfio_devices[i]);
> +		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
>  		if (ret)
>  			return ret;
>  	}
> @@ -429,7 +429,7 @@ static int vfio_configure_reserved_regions(struct kvm *kvm,
>  	return ret;
>  }
>  
> -static int vfio_configure_groups(struct kvm *kvm)
> +static int legacy_vfio_configure_groups(struct kvm *kvm)
>  {
>  	int ret;
>  	struct vfio_group *group;
> @@ -454,7 +454,7 @@ static int vfio_configure_groups(struct kvm *kvm)
>  	return 0;
>  }
>  
> -static struct vfio_group *vfio_group_create(struct kvm *kvm, unsigned long id)
> +static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
>  {
>  	int ret;
>  	struct vfio_group *group;
> @@ -512,10 +512,11 @@ static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
>  	if (--group->refs != 0)
>  		return;
>  
> -	ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
> -
>  	list_del(&group->list);
> -	close(group->fd);
> +	if (group->fd != -1) {
> +		ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
> +		close(group->fd);
> +	}

That seems unrelated to the rename, maybe it's better to move that when
IOMMUFD is supported as it's related to it.

Thanks,
Mostafa

>  	free(group);
>  }
>  
> @@ -559,14 +560,14 @@ vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
>  		}
>  	}
>  
> -	group = vfio_group_create(kvm, group_id);
> +	group = legacy_vfio_group_create(kvm, group_id);
>  
>  out_close:
>  	close(dirfd);
>  	return group;
>  }
>  
> -static int vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
> +static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
>  	char dev_path[PATH_MAX];
> @@ -610,7 +611,7 @@ static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
>  	free(vdev->sysfs_path);
>  }
>  
> -static int vfio_container_init(struct kvm *kvm)
> +static int legacy_vfio_container_init(struct kvm *kvm)
>  {
>  	int api, i, ret, iommu_type;;
>  
> @@ -638,7 +639,7 @@ static int vfio_container_init(struct kvm *kvm)
>  	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
>  		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
>  
> -		ret = vfio_device_init(kvm, &vfio_devices[i]);
> +		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
>  		if (ret)
>  			return ret;
>  	}
> @@ -678,15 +679,15 @@ static int vfio__init(struct kvm *kvm)
>  	}
>  	kvm_vfio_device = device.fd;
>  
> -	ret = vfio_container_init(kvm);
> +	ret = legacy_vfio_container_init(kvm);
>  	if (ret)
>  		return ret;
>  
> -	ret = vfio_configure_groups(kvm);
> +	ret = legacy_vfio_configure_groups(kvm);
>  	if (ret)
>  		return ret;
>  
> -	ret = vfio_configure_devices(kvm);
> +	ret = legacy_vfio_configure_devices(kvm);
>  	if (ret)
>  		return ret;
>  
> -- 
> 2.43.0
> 

