Return-Path: <kvm+bounces-19123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 764AE901677
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 17:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6849C1C20A00
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 15:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2A746433;
	Sun,  9 Jun 2024 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e8Ovct9O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EBF210E4
	for <kvm@vger.kernel.org>; Sun,  9 Jun 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717946996; cv=none; b=Xdw2KSYc2V+PDAy1bS0iUToc6IGoQ3OKUH/QRadRTOqLU+7hS6orp63pwe+o9v9MH3vCysxrlS42wtHX0owyZnQIcPtGnboynmYS1FGutpRgpTAXOf/qEJEOBNMfs22w5B6O9GeNEs8If2ab0tvP6hGhF8IznbgqikLshJDrkSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717946996; c=relaxed/simple;
	bh=LkPXGai8kaRoajhEuKD9q1QTp4VpWFHLrSWtfPGkqEk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=lcofh6CohZv/OCPQBEgrL2x+nhIk2tibMeRarpp0lUcHcY7ov3vL+ZVvDw3coCyREZSBcLneRUCl95guRGXdYCx85AgALw7mgHyPQoyArgTLDhDS+4ri0rQNLxaZWRsUx7TSQDpkOomH9LXKihuLKoVfOonHshXlestlhV7TTl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e8Ovct9O; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52c7f7fdd24so1217006e87.1
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 08:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717946993; x=1718551793; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+p7Dbyuweupea3JxyYctujxWv1vr+kMS3mFulUukLl4=;
        b=e8Ovct9OJM6L9gooMPF98nCD/TSJFi5sosivd7iXjZQ/1b4j/I7Fly9b84YAu7o3zG
         /zeN4ansGlsFvhJ3FlZ/RV3h3qNO5nRu2Fl5giDWSMUFw7Z4HByk7b5prLDFqStyMV5/
         qXvQTfBeN7OMB8nsn1OnT6PooGPnrWYCE0Xnd9EqbotCW1y/45UczRkYv4zf9McTI9Af
         ulvZYw1x+KJliZ0xRtzT2iF7u9Xu0xYhoF67+RgbQ7EVmkn8wDv7P6sa5VzZfJYoEoZx
         8SVTipcnsxM0Oetz9yMBNedp9bBB0bFoPYS+fGi9N/nO50N4vh8Wq+1xXXN8ZD06sYL0
         yIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717946993; x=1718551793;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+p7Dbyuweupea3JxyYctujxWv1vr+kMS3mFulUukLl4=;
        b=aRHLEYiDR+zr5AHpgLnVJxS49mkwgm3tDjE7CaQ5l8km/CyDQ3abe2ttF9l2i49KCD
         CkKoprWiY7LiaEQlns4lDKUtFWcHrXHWReo6tqdM6pNS4VLKOtFe6HJRctxyaQwkQJQp
         KiYgJd8m4eXdBBPaun2+9UskLUhiasfr91CJkNvZJ+hLwIPEYkGHKrtf6p/fHdyNmPM9
         5ayb85wL8azwPWIRUKoZWRQtovy37gJjOpQnQq4PxSDxgawBY3qg/oAlmLNehMBVbYb/
         Wjvt0nVRqvyPjfbUpwMO1n7QxsSJTt1MX14yhCJQA9XMWMzqSPoithhmjENHhgvgjmaf
         sA6w==
X-Forwarded-Encrypted: i=1; AJvYcCUlx73J6J6qcDo4qJv9+KUuQWUprpEEMr/XYTMXphdQcv2mAhODRvtSKE9I0mQogzSCSqaIZX11DP2fpu8c76U+QeXh
X-Gm-Message-State: AOJu0YwiDnC24gI+ku2Q0GirkzMxWuQaD35NH9oq76U+qfPkuW6wSUbe
	YpN9jagFn9ec8oILSk9tSH1yVPcp43ZmKj6I80EBICg/ittO29F7jCVBSTLLhjM=
X-Google-Smtp-Source: AGHT+IHAD4z52RxtAlhkJKnz6xDUNUsq8wzsH9aGCceUyMemIpuwQ3lYTq1VwnfUMEWgqgARHYFD4Q==
X-Received: by 2002:a19:5f5b:0:b0:520:c2c1:153a with SMTP id 2adb3069b0e04-52bb9fd2521mr4380150e87.58.1717946992519;
        Sun, 09 Jun 2024 08:29:52 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f2024b1c8sm1716363f8f.39.2024.06.09.08.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jun 2024 08:29:52 -0700 (PDT)
Date: Sun, 9 Jun 2024 18:29:48 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Fred Griffoul <fgriffo@amazon.co.uk>,
	griffoul@gmail.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
Message-ID: <714268da-d199-4371-8360-500e7165119c@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607190955.15376-3-fgriffo@amazon.co.uk>

Hi Fred,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Fred-Griffoul/cgroup-cpuset-export-cpuset_cpus_allowed/20240608-031332
base:   cbb325e77fbe62a06184175aa98c9eb98736c3e8
patch link:    https://lore.kernel.org/r/20240607190955.15376-3-fgriffo%40amazon.co.uk
patch subject: [PATCH v4 2/2] vfio/pci: add msi interrupt affinity support
config: mips-randconfig-r081-20240609 (https://download.01.org/0day-ci/archive/20240609/202406092245.Hgx6MqK9-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202406092245.Hgx6MqK9-lkp@intel.com/

New smatch warnings:
drivers/vfio/pci/vfio_pci_core.c:1241 vfio_pci_ioctl_set_irqs() warn: maybe return -EFAULT instead of the bytes remaining?

vim +1241 drivers/vfio/pci/vfio_pci_core.c

2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1190  static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1191  				   struct vfio_irq_set __user *arg)
2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1192  {
2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1193  	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1194  	struct vfio_irq_set hdr;
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1195  	cpumask_var_t mask;
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1196  	u8 *data = NULL;
05692d7005a364 drivers/vfio/pci/vfio_pci.c      Vlad Tsyrklevich 2016-10-12  1197  	int max, ret = 0;
ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-17  1198  	size_t data_size = 0;
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1199  
663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1200  	if (copy_from_user(&hdr, arg, minsz))
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1201  		return -EFAULT;
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1202  
05692d7005a364 drivers/vfio/pci/vfio_pci.c      Vlad Tsyrklevich 2016-10-12  1203  	max = vfio_pci_get_irq_count(vdev, hdr.index);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1204  
ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1205  	ret = vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_PCI_NUM_IRQS,
ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1206  						 &data_size);
ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-17  1207  	if (ret)
ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-17  1208  		return ret;
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1209  
ef198aaa169c61 drivers/vfio/pci/vfio_pci.c      Kirti Wankhede   2016-11-17  1210  	if (data_size) {
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1211  		if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY) {
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1212  			if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1213  				return -ENOMEM;
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1214  
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1215  			ret = copy_from_user(mask, &arg->data, data_size);

copy_from_user() returns the number of bytes remaining to be copied.
This should be:

	if (copy_from_user(mask, &arg->data, data_size)) {
		ret = -EFAULT;
		goto out;
	}

66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1216  			if (ret)
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1217  				goto out;
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1218  
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1219  			data = (u8 *)mask;
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1220  
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1221  		} else {
663eab456e072b drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1222  			data = memdup_user(&arg->data, data_size);
3a1f7041ddd59e drivers/vfio/pci/vfio_pci.c      Fengguang Wu     2012-12-07  1223  			if (IS_ERR(data))
3a1f7041ddd59e drivers/vfio/pci/vfio_pci.c      Fengguang Wu     2012-12-07  1224  				return PTR_ERR(data);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1225  		}
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1226  	}
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1227  
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1228  	mutex_lock(&vdev->igate);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1229  
ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1230  	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
ea3fc04d4fad2d drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1231  				      hdr.count, data);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1232  
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1233  	mutex_unlock(&vdev->igate);
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1234  
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1235  out:
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1236  	if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY && data_size)
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1237  		free_cpumask_var(mask);
66c926fb7b2507 drivers/vfio/pci/vfio_pci_core.c Fred Griffoul    2024-06-07  1238  	else
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1239  		kfree(data);
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31  1240  
89e1f7d4c66d85 drivers/vfio/pci/vfio_pci.c      Alex Williamson  2012-07-31 @1241  	return ret;
2ecf3b58ed7bc5 drivers/vfio/pci/vfio_pci_core.c Jason Gunthorpe  2022-08-31  1242  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


