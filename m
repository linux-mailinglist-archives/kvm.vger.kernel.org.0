Return-Path: <kvm+bounces-52549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E104B06973
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 00:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 511DD5673B4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 22:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796152C324F;
	Tue, 15 Jul 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Kbr6OAkP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658C274B5A
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620153; cv=none; b=GVFFYfvIl0A4PBP+Cu15aFbVq9DbQUmbYYOH5bNEKNgJVuFuUdKyMIgBqVYsUCZfkdHIqBCDG63xcbNx5IhB3ueTE5MERC9EJhNFYGrh1Xy/e9RrHf4piXsH+LAWgxa/phWM1L9oYgzBsJe7cbVjBbGjo/B1dJcgZDlXsVHQn2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620153; c=relaxed/simple;
	bh=vEmMpBK5/tPkb9KHvQ0SdOc52MTBa8ee6/BHSUyXBLo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=r2b0RdMsmnKN1Ll5xtnqgjcS8hMvrEhwEp7TLSkhyVutsq/MJhcwQtHrT8E8aAS5lZXmvX5gi+KFuIsS5lUe8Rt4zcLNTtINRhJQnEyp+681tkQpliDai1qw2CN3kjQdbK8EP2tbpQM2Ajhq+hOv721V1nUsa2nEyLR6MhRImtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Kbr6OAkP; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2eb6c422828so256464fac.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752620151; x=1753224951; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oi4TdNlobhflphwjzdK68I/IBj5StICPNqn66i2gNn4=;
        b=Kbr6OAkPfiuAqNJM+Cq68H++WBeoRMd9s087WavWfC6VkyI1rS3y9xaJqGPCcw3iKU
         6a6GHFMTfbIEePJ8S0eQY8r2XeDSvV/fT6rZWxFSfP5YBICOCxXxYnYzZtgotKWabfr9
         ohntDJMeS9A5jO461DzdwG4zIRv7/P6yx6qOmK1h/pdxiCqO/dIGUbBscl30AOld4LSb
         erJiUQRjmZUO5Ysl63/4xbSiOGzHarl6LYmISPkYfPWkJzuwN7E2nlKqpSB5N/PyCe9w
         QrT1sG41pyHg9NpNMBm6DNkcyu6Fd3nBBDq0/xPjABvQeRgGzQyiD8j2QMf001WJFuX1
         mD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752620151; x=1753224951;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oi4TdNlobhflphwjzdK68I/IBj5StICPNqn66i2gNn4=;
        b=CefkfhydaXlZO6TtjA/cFnKx+jgpClrSYeaM55tiuGbY4+qyS11p2jDCPLy1q0sGtY
         WxPSNb4If0LnZamgrxhk48mU+0T2UIIx5CROQrAx8ylDmVAnuPJP6b1dNy105NPw2ViK
         yJTzvtlW7xsc6SWRm9/pk8Xfcl5fZ58OFjfi3PFePwAnxkgYwoSZq63umzLt3sAkYuiv
         2haH6fllyDpjo8Fk3+ZOokZlmFpzqByDknoxEySsp1BEv2KQBm4qfOp7U7eNVWR6eWwi
         zuclubA6oqpaIsE99Xs8QfXY5KfpI3gbrSfDEYLYW2HhPgU1ag3EEUv9r+6XWLaGE0tg
         VHrw==
X-Forwarded-Encrypted: i=1; AJvYcCWyTuc5gtTAN1W5QIcGfFPck5YoJWq/A7UmsHnHq31Ft3Bn5a+qeqfcbq4lcxpMBydEB34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzd94OL+gBtUDYbNNsvmsxYE/A+zHK4W0MOC7/cO+9W4U37DQP
	sHzjyfs/J8wwgLVqfuOXHh26G85NjWNUYl4bzVEiGrxsc7NdeW+s3Q4QOlP2moq4GXU=
X-Gm-Gg: ASbGncv7A6t0C3JoaGZp/tgROtpcnc+PYJwp5Ag9fIUWVPIqfn0RPdUNkjhEbjduMqL
	AFqoOHdiGjqWWWgXtaopIFZ4zyEpcvzd5hP+kff3tlM0khOxiftHZTZC+fVDDsKZ8PXjMcZ4bnQ
	24lRLqTPttHjm3zYyh16eSVYfRc/caWgEzRYb6UaHpAaQf2l9CammtSl8FYs+/RRy5i8jjTG4M9
	XddhHPlU6NfC/FsU/HqUYzPzGZuQlQ8/vDXyRN+SHeOB/KpupL1MbzlbdTrEnxngT0eJMly5GFl
	kCsi8ZpLYhEn+5aYdllBGu4jAfJHAckpYqrRqI+vZXoaMnGVxtBY0ol49CUUrf4O2rlTsnBgx+i
	FVqz94GqUsDnPHp+yHmiOj5uEG1UkNzh6ql77Rzw=
X-Google-Smtp-Source: AGHT+IF5HaHuyKCM6E4t2p7V295FGoLcL158yabHcCEf0sSmb2eM1U+wbvg4ZE1zb1cHzfegWFEB5Q==
X-Received: by 2002:a05:6870:3288:b0:2f7:64f7:8d40 with SMTP id 586e51a60fabf-2ffb0bed7efmr740669fac.9.1752620150775;
        Tue, 15 Jul 2025 15:55:50 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:a172:6205:b5e:43cb])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ff116d22easm2976522fac.33.2025.07.15.15.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 15:55:49 -0700 (PDT)
Date: Wed, 16 Jul 2025 01:55:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>

Hi Jason,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Gunthorpe/vfio-pci-Do-vf_token-checks-for-VFIO_DEVICE_BIND_IOMMUFD/20250715-001209
base:   32b2d3a57e26804ca96d82a222667ac0fa226cb7
patch link:    https://lore.kernel.org/r/0-v3-bdd8716e85fe%2B3978a-vfio_token_jgg%40nvidia.com
patch subject: [PATCH v3] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
config: openrisc-randconfig-r071-20250715 (https://download.01.org/0day-ci/archive/20250716/202507160254.dAjYAz9h-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202507160254.dAjYAz9h-lkp@intel.com/

smatch warnings:
drivers/vfio/device_cdev.c:126 vfio_df_ioctl_bind_iommufd() warn: missing unwind goto?
drivers/vfio/device_cdev.c:170 vfio_df_ioctl_bind_iommufd() warn: inconsistent returns '&device->dev_set->lock'.

vim +126 drivers/vfio/device_cdev.c

5fcc26969a164e Yi Liu          2023-07-18   83  long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
5fcc26969a164e Yi Liu          2023-07-18   84  				struct vfio_device_bind_iommufd __user *arg)
5fcc26969a164e Yi Liu          2023-07-18   85  {
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   86  	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
5fcc26969a164e Yi Liu          2023-07-18   87  	struct vfio_device *device = df->device;
5fcc26969a164e Yi Liu          2023-07-18   88  	struct vfio_device_bind_iommufd bind;
5fcc26969a164e Yi Liu          2023-07-18   89  	unsigned long minsz;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   90  	u32 user_size;
5fcc26969a164e Yi Liu          2023-07-18   91  	int ret;
5fcc26969a164e Yi Liu          2023-07-18   92  
5fcc26969a164e Yi Liu          2023-07-18   93  	static_assert(__same_type(arg->out_devid, df->devid));
5fcc26969a164e Yi Liu          2023-07-18   94  
5fcc26969a164e Yi Liu          2023-07-18   95  	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
5fcc26969a164e Yi Liu          2023-07-18   96  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   97  	ret = get_user(user_size, &arg->argsz);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   98  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   99  		return ret;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  100  	if (user_size < minsz)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  101  		return -EINVAL;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  102  	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  103  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  104  		return ret;
5fcc26969a164e Yi Liu          2023-07-18  105  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  106  	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
5fcc26969a164e Yi Liu          2023-07-18  107  		return -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  108  
5fcc26969a164e Yi Liu          2023-07-18  109  	/* BIND_IOMMUFD only allowed for cdev fds */
5fcc26969a164e Yi Liu          2023-07-18  110  	if (df->group)
5fcc26969a164e Yi Liu          2023-07-18  111  		return -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  112  
5fcc26969a164e Yi Liu          2023-07-18  113  	ret = vfio_device_block_group(device);
5fcc26969a164e Yi Liu          2023-07-18  114  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  115  		return ret;
5fcc26969a164e Yi Liu          2023-07-18  116  
5fcc26969a164e Yi Liu          2023-07-18  117  	mutex_lock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  118  	/* one device cannot be bound twice */
5fcc26969a164e Yi Liu          2023-07-18  119  	if (df->access_granted) {
5fcc26969a164e Yi Liu          2023-07-18  120  		ret = -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  121  		goto out_unlock;
5fcc26969a164e Yi Liu          2023-07-18  122  	}
5fcc26969a164e Yi Liu          2023-07-18  123  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  124  	ret = vfio_df_check_token(device, &bind);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  125  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14 @126  		return ret;

This needs to be a goto unlock.

be2e70b96c3e54 Jason Gunthorpe 2025-07-14  127  
5fcc26969a164e Yi Liu          2023-07-18  128  	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
5fcc26969a164e Yi Liu          2023-07-18  129  	if (IS_ERR(df->iommufd)) {
5fcc26969a164e Yi Liu          2023-07-18  130  		ret = PTR_ERR(df->iommufd);
5fcc26969a164e Yi Liu          2023-07-18  131  		df->iommufd = NULL;
5fcc26969a164e Yi Liu          2023-07-18  132  		goto out_unlock;
5fcc26969a164e Yi Liu          2023-07-18  133  	}
5fcc26969a164e Yi Liu          2023-07-18  134  
5fcc26969a164e Yi Liu          2023-07-18  135  	/*
5fcc26969a164e Yi Liu          2023-07-18  136  	 * Before the device open, get the KVM pointer currently
5fcc26969a164e Yi Liu          2023-07-18  137  	 * associated with the device file (if there is) and obtain
5fcc26969a164e Yi Liu          2023-07-18  138  	 * a reference.  This reference is held until device closed.
5fcc26969a164e Yi Liu          2023-07-18  139  	 * Save the pointer in the device for use by drivers.
5fcc26969a164e Yi Liu          2023-07-18  140  	 */
5fcc26969a164e Yi Liu          2023-07-18  141  	vfio_df_get_kvm_safe(df);
5fcc26969a164e Yi Liu          2023-07-18  142  
5fcc26969a164e Yi Liu          2023-07-18  143  	ret = vfio_df_open(df);
5fcc26969a164e Yi Liu          2023-07-18  144  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  145  		goto out_put_kvm;
5fcc26969a164e Yi Liu          2023-07-18  146  
5fcc26969a164e Yi Liu          2023-07-18  147  	ret = copy_to_user(&arg->out_devid, &df->devid,
5fcc26969a164e Yi Liu          2023-07-18  148  			   sizeof(df->devid)) ? -EFAULT : 0;
5fcc26969a164e Yi Liu          2023-07-18  149  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  150  		goto out_close_device;
5fcc26969a164e Yi Liu          2023-07-18  151  
5fcc26969a164e Yi Liu          2023-07-18  152  	device->cdev_opened = true;
5fcc26969a164e Yi Liu          2023-07-18  153  	/*
5fcc26969a164e Yi Liu          2023-07-18  154  	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
5fcc26969a164e Yi Liu          2023-07-18  155  	 * read/write/mmap
5fcc26969a164e Yi Liu          2023-07-18  156  	 */
5fcc26969a164e Yi Liu          2023-07-18  157  	smp_store_release(&df->access_granted, true);
5fcc26969a164e Yi Liu          2023-07-18  158  	mutex_unlock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  159  	return 0;
5fcc26969a164e Yi Liu          2023-07-18  160  
5fcc26969a164e Yi Liu          2023-07-18  161  out_close_device:
5fcc26969a164e Yi Liu          2023-07-18  162  	vfio_df_close(df);
5fcc26969a164e Yi Liu          2023-07-18  163  out_put_kvm:
5fcc26969a164e Yi Liu          2023-07-18  164  	vfio_device_put_kvm(device);
5fcc26969a164e Yi Liu          2023-07-18  165  	iommufd_ctx_put(df->iommufd);
5fcc26969a164e Yi Liu          2023-07-18  166  	df->iommufd = NULL;
5fcc26969a164e Yi Liu          2023-07-18  167  out_unlock:
5fcc26969a164e Yi Liu          2023-07-18  168  	mutex_unlock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  169  	vfio_device_unblock_group(device);
5fcc26969a164e Yi Liu          2023-07-18 @170  	return ret;
5fcc26969a164e Yi Liu          2023-07-18  171  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


