Return-Path: <kvm+bounces-49724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E91ADD222
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E0FB3BE370
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B317A2ECE8A;
	Tue, 17 Jun 2025 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WpShGJTa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2940E2E9753
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174757; cv=none; b=erTC90ajKAEooJ3xmQf+4+k3m5AqBpX7OJrQvZJoE5ajj4AoWOvPs58HO1FmxaFF0uUiETDRpCUr5VU+flT+Mjlvrz6dSU2pK+oJ+jUrbA/M3kwSG6tO1+Pm9/BLawb3x8ZDcufmAfN5JXF4NvScOjfZMi7Y18bejxLFL7tpuzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174757; c=relaxed/simple;
	bh=zfy6EHe5CDOTdqnNoMOjf4o/PnjkL+mkfT4gkUjbFyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEDxQAJAa2dCsmIAV4mYExyRE3TNQ19NFKdMrf/+19/lrSAPq9kwCNTWtIA1WjMKbBcixyShq8K2qkO8SPhOhQd6vfdCb0VCyUlgfU9sbLtMvSkivWWKHIVJjMBAPk4+wL6jWEvDg7UJlOCNqbEr9wr/DYUEM+BYKOtp9cNSxTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WpShGJTa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bYA4vNkR1STXIkkbeACF7/tlzHC3egoFZWTXFv+IW1c=;
	b=WpShGJTaJ99/b5uTM0YAWWv+7PAqLiNlQrdFQ7p5uSgYHJS6mVQZaSnL4A3jDAOsJS49u4
	33VRukNojiaFc8YQmE2dh1pSiF0vDEH+0lMqblNsCLR3FUsfEzaavSlIi9l58SlpzUrHQN
	A5jqJiC3M3dTzEdf/xJyZGZ6MmGkiaE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-1LfIjQDRNvSa8X_jFegtGg-1; Tue, 17 Jun 2025 11:39:13 -0400
X-MC-Unique: 1LfIjQDRNvSa8X_jFegtGg-1
X-Mimecast-MFC-AGG-ID: 1LfIjQDRNvSa8X_jFegtGg_1750174753
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4a6f64eebecso114521831cf.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 08:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750174753; x=1750779553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYA4vNkR1STXIkkbeACF7/tlzHC3egoFZWTXFv+IW1c=;
        b=fMn+ocnuz+BSRaBh4W8M73y+09oAhU02ps8nDF/DJhAT6iPCQWvr3Di/CnTmIBSAMl
         Jbb7+BeJ3ZY05/uuARJLOCb6NJNoZX7zkaHabiGmObAtQW87BzmCi9Fmj4yKv6Y+Knfl
         bCx8FxNmctdyKPdoa/vRqUPb8fn0clhlbXwmJ+cJj336nFP6fT1SojtFDOqhpuM+nYFB
         oYrW4okRAW2qnfMjwr3gJerRUqPwc8HxB6j0YzO/lX0xrld98505rYzm6IRWB7dFAG70
         zngwVT85plYPujmiqdbFQlK8eHNYJIyhiio7hLw5NDHcoD7k7CLobh/jvguzxvvWm8oW
         Bgvg==
X-Forwarded-Encrypted: i=1; AJvYcCWka0ahTyXhWV/FlHG3e8/gC2369+QO38darRWD//XBYUlec/lE/IviYGuU4L8hUmmz3kM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV6jJXRO0BQIr+vIIf4dn/vbfdR7ZwK2niDQOFyBOUG6D01FWZ
	xHt9t6iOIxiMUPmDelIkS/uNE3XKwRx16T1RcmnOFbc483aSHClLdOxWC/m9Xeaf7b+NjMtzULW
	Wu2UqJdE6OOqYxI7LVlrzgL9RJb0C7Gac4W4Lm1/YA0fvqCJxN8twFw==
X-Gm-Gg: ASbGncsi5/OTbSu+ddYDs2bhp4LnHITjdK7dfZaDLbPDNVs4+Itr2ScVTgY7r1WD3tU
	HVsfmTemg802tKdgypZOgjm88+UBmhTgRUtE3PEUyNcFnYHC9mwrCDOoPWGHsm/AfWfdgZxS+LM
	aP1tfMesz/wN9dwVk6BChfiQ3FbVqOLcaH2H7KWtcD5klv0RV1p8KSsCWuSrGMLT4RTqizYZpKl
	Ok4qI/nsoKBt56A4RkhQxRVK/uYYlCV0PGedMBUmB4dBnq1r3w8CvK5Y89dj5iRrOAujMtAXzdd
	hnCHguBLnCKdqg==
X-Received: by 2002:a05:622a:446:b0:4a5:a4e9:1333 with SMTP id d75a77b69052e-4a73c656171mr237038121cf.49.1750174752396;
        Tue, 17 Jun 2025 08:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPIM43/kJAMEA2z+DJQLz3Nfj5J/K0A7FFjpnjYR1h2Y4Z5A/KK2hrX/uNeaSpJOy3GeFrSQ==
X-Received: by 2002:a05:622a:446:b0:4a5:a4e9:1333 with SMTP id d75a77b69052e-4a73c656171mr237037031cf.49.1750174751109;
        Tue, 17 Jun 2025 08:39:11 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a308f55sm62628021cf.28.2025.06.17.08.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 08:39:10 -0700 (PDT)
Date: Tue, 17 Jun 2025 11:39:07 -0400
From: Peter Xu <peterx@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <aFGMG3763eSv9l8b@x1.local>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202506142215.koMEU2rT-lkp@intel.com>

On Sat, Jun 14, 2025 at 10:46:45PM +0800, kernel test robot wrote:
> Hi Peter,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-Deduplicate-mm_get_unmapped_area/20250613-214307
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20250613134111.469884-5-peterx%40redhat.com
> patch subject: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area hook
> config: sh-randconfig-002-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142215.koMEU2rT-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.4.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506142215.koMEU2rT-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202506142215.koMEU2rT-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vfio/vfio_main.c: In function 'vfio_device_get_unmapped_area':
> >> drivers/vfio/vfio_main.c:1367:24: error: implicit declaration of function 'mm_get_unmapped_area'; did you mean 'get_unmapped_area'? [-Werror=implicit-function-declaration]
>     1367 |                 return mm_get_unmapped_area(current->mm, file, addr,
>          |                        ^~~~~~~~~~~~~~~~~~~~
>          |                        get_unmapped_area
>    cc1: some warnings being treated as errors
> 
> 
> vim +1367 drivers/vfio/vfio_main.c
> 
>   1356	
>   1357	static unsigned long vfio_device_get_unmapped_area(struct file *file,
>   1358							   unsigned long addr,
>   1359							   unsigned long len,
>   1360							   unsigned long pgoff,
>   1361							   unsigned long flags)
>   1362	{
>   1363		struct vfio_device_file *df = file->private_data;
>   1364		struct vfio_device *device = df->device;
>   1365	
>   1366		if (!device->ops->get_unmapped_area)
> > 1367			return mm_get_unmapped_area(current->mm, file, addr,
>   1368						    len, pgoff, flags);
>   1369	
>   1370		return device->ops->get_unmapped_area(device, file, addr, len,
>   1371						      pgoff, flags);
>   1372	}
>   1373	

This is "ARCH_SH + VFIO + !MMU".. I'll make sure to cover this config when
repost.  I'll squash below into the patch:

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 19db8e58d223..cc14884d282f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1354,6 +1354,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
        return device->ops->mmap(device, vma);
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
 static unsigned long vfio_device_get_unmapped_area(struct file *file,
                                                   unsigned long addr,
                                                   unsigned long len,
@@ -1370,6 +1371,7 @@ static unsigned long vfio_device_get_unmapped_area(struct file *file,
        return device->ops->get_unmapped_area(device, file, addr, len,
                                              pgoff, flags);
 }
+#endif
 
 const struct file_operations vfio_device_fops = {
        .owner          = THIS_MODULE,
@@ -1380,7 +1382,9 @@ const struct file_operations vfio_device_fops = {
        .unlocked_ioctl = vfio_device_fops_unl_ioctl,
        .compat_ioctl   = compat_ptr_ioctl,
        .mmap           = vfio_device_fops_mmap,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
        .get_unmapped_area = vfio_device_get_unmapped_area,
+#endif
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)

-- 
Peter Xu


