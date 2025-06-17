Return-Path: <kvm+bounces-49742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 990BAADD91A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C07A4A36EA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC0A2DFF06;
	Tue, 17 Jun 2025 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTXPo+xd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54B235067
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178872; cv=none; b=B5PT6XqVVCRs/agyTq+OYAY4+l8THZAqJYeuYpBvZ6MHEspZw+ZI6pNvtQwXcANCpvB/E+ehxvdIz6X9tL4+NUpDC58v2WmMLwAWhskWC0i/ri7SoUB+7NSPAhMDu+CY0iE358R7jBlHnlYNgijNZ6cY557v62m9E7GRxFl7tBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178872; c=relaxed/simple;
	bh=Ng2+55cycp9Mq67N0F50gt8NmngHjK/xJ38hqLOcTTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN2TiFBg08wKYQolRwPQEhC8shZoCvT0TzR6qPfynSrZ+6tGg/aP3Yo5tqSgjgu4N06ts+1xc55u7dgQMkqgkEYGlgahcFilUsfBcseuBff/Ylw9Z2nwgkmi8AwiTj91bbK6LIJW7kAzFeagsWsbH6ZYDcCK4Es7u1gIVyfdar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTXPo+xd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750178869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9udXpXMKLqnXjPpw+ssHtlTIRsjM/WGu/+kStlwAoqo=;
	b=LTXPo+xd6vQj7E9BKHOe1AR0GrbUYJxN6i5juYcM2QB5/rvrfGfnqDeEYReLwpFmjOM8XA
	ThxHWuDMD0bS5yiAXHNh/EIG5mgGeRh5Weh0F4cQBtGY/LAtdA4XknnJliz8PXtlcKrzmB
	J2qHxO2YpF1IQUykjtdt91sA9z+VBeo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-oDLF-KvzOU6dy9V29eNTdQ-1; Tue, 17 Jun 2025 12:47:47 -0400
X-MC-Unique: oDLF-KvzOU6dy9V29eNTdQ-1
X-Mimecast-MFC-AGG-ID: oDLF-KvzOU6dy9V29eNTdQ_1750178866
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso5918503a91.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178866; x=1750783666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9udXpXMKLqnXjPpw+ssHtlTIRsjM/WGu/+kStlwAoqo=;
        b=LjGLOIw+SVO532iJd3MG0QiPDauPZp4WhqI1kKD4rIExmODg1LHKeAVi8RC7FPwp4X
         J3CV2nL7jS/e3hl5+hu6mS8OPihVvU1f7Jx9MPYbOI5/tXezFTHqV1Fg7LONflEvLz2S
         1UF8VCmjkdV3XZ5Hfbcz2H/MlqglFSSznKJ0rZaUd+rq/mqCoS1Re3YSYBMhQMKaCr0b
         ANlX34L02YVoj1ftp3raLXJFsrwFq2QtByZnDrfvWOfW+KeJWFqNgv1uqBmAU5WufKhw
         d0INkCLiISxG65kSuybCsa1xh2ZOZYoGiciin3Tmmnsde9XU5KslaRUU05A+bIsvSbh3
         Hekg==
X-Forwarded-Encrypted: i=1; AJvYcCUaQm4gd8lD6OUE+nQTNhBdYiWOT3I5FN+JiRZjDi0jYLK/AxmyUIGZVj5A6VFDo0hcwNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjDhDrpb/5MjrxqayFGuyPBK0VSgqC/7MMDlIYBwJqWgwgPrXY
	mFehiuk/vWv6UWqNe2Qg7UZIuHH79RIhCzjKU0a/BiPmc9r7ZDNclUvzITD/Kp35ZXvLNtDq1II
	/tO9QCfkEN5zPoZWcVEYXVbgYY9oS1TmWAcdu2WbUmfUMchuFpMsM/w==
X-Gm-Gg: ASbGncs5be9DTrhtQNQwxgAOOWWXyiyV0ULn7BwDI4X+eMDQVdQeR3f66I7b4yfqXmk
	0SN7mNw3cJh3x8Tadp8RdtI19u+tQATs8eExlnRwF+BPBTei4BOWFgAEwbT/6qHaV97qltTZp3O
	QLwQVlpDXsH5EFe+4N+KkqYFvRrEYpZsydoIp5jZfgy8shHPvDxGiVo1Gpudet84oil7lTvBP6D
	53LQ34zaHuSUMyS9yBcqzEyhIPaZfpxaxHt7UMk4rgwt6gklfFzfY14vYcqbDqs6GvAyMLJiX4B
	yDY5kUabrpTW0A==
X-Received: by 2002:a17:90b:2808:b0:30a:3e8e:ea30 with SMTP id 98e67ed59e1d1-31427e9f04cmr4387984a91.11.1750178866282;
        Tue, 17 Jun 2025 09:47:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZ5RZvlcb8QDXdYGv2rCtK+dVH8l+O3RgQMnCOn4WGgTIeBHCIqlbbuc04Tn+tkV7OjqZJXw==
X-Received: by 2002:a17:90b:2808:b0:30a:3e8e:ea30 with SMTP id 98e67ed59e1d1-31427e9f04cmr4387954a91.11.1750178865920;
        Tue, 17 Jun 2025 09:47:45 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365decb947sm82211815ad.225.2025.06.17.09.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:47:45 -0700 (PDT)
Date: Tue, 17 Jun 2025 12:47:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <aFGcJ-mjhZ1yT7Je@x1.local>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617154157.GY1174925@nvidia.com>

On Tue, Jun 17, 2025 at 12:41:57PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 17, 2025 at 11:39:07AM -0400, Peter Xu wrote:
> >  
> > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> >  static unsigned long vfio_device_get_unmapped_area(struct file *file,
> >                                                    unsigned long addr,
> >                                                    unsigned long len,
> > @@ -1370,6 +1371,7 @@ static unsigned long vfio_device_get_unmapped_area(struct file *file,
> >         return device->ops->get_unmapped_area(device, file, addr, len,
> >                                               pgoff, flags);
> >  }
> > +#endif
> >  
> >  const struct file_operations vfio_device_fops = {
> >         .owner          = THIS_MODULE,
> > @@ -1380,7 +1382,9 @@ const struct file_operations vfio_device_fops = {
> >         .unlocked_ioctl = vfio_device_fops_unl_ioctl,
> >         .compat_ioctl   = compat_ptr_ioctl,
> >         .mmap           = vfio_device_fops_mmap,
> > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> >         .get_unmapped_area = vfio_device_get_unmapped_area,
> > +#endif
> >  };
> 
> IMHO this also seems like something the core code should be dealing
> with and not putting weird ifdefs in drivers.

It may depend on whether we want to still do the fallbacks to
mm_get_unmapped_area().  I get your point in the other email but not yet
get a chance to reply.  I'll try that out to see how it looks and reply
there.

-- 
Peter Xu


