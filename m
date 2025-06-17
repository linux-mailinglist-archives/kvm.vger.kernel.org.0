Return-Path: <kvm+bounces-49756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B94ADDC86
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5F0175ABE
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE41E2EAB90;
	Tue, 17 Jun 2025 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i7cZYVN6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41632E3AEF
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750189170; cv=none; b=DO4YbkMTMv+5vpJBKE2Sr4Di7APn/CbZwCsO2E033l1sobPp2fnAr7hHjLxFCF6r+fAGEWNHqJwNaRt7NdzKG/roJqE+pkuswVcdnfIHv7aXPpnIKmOQWDwSrNKR8EUOVMca7d9intR9eWmnxjght1Fi2rndV9C4/QGomyGyfEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750189170; c=relaxed/simple;
	bh=F8sGT+/sgtF0uvYnPIHZZx0Lfe8FrbZyk0U6/gz6wZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHorPFHUacxfws9YxaLZIECaeFO1OB/9kRn/iBa1PTFBNzObBftnDgB2NDZYYwH9EiWaR8jLkLJKUxpnoabL9s9Bq2oePI1yGQnfXtohzhrPeYOyWjR8lXC43e+n3Nr5IVYXI4sC4faZTJ9WSaUQBCXlWP4Ih+5VaBDapRr6WiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i7cZYVN6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750189167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJl3ISS5vZpEM73Zu2QnVbFcIkeedrpFNBWR+QK1Ynw=;
	b=i7cZYVN6MSJFAjq37Y8sZkqitrheGKWNFzOtojrFec5DU05wrDatk1bwAomCMM1QBi/Jw9
	H5JN7Wjevi9EedzE0i8RJvHaGSFFptcjpOihKi2jSx3HFZmB8YffD21j0Ij7QNeZaIbcVT
	h8LVRNKxwS7rnNBNx7UWXUvLnI6NfN8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-K1mov-ZiNSGmHqlwcw030g-1; Tue, 17 Jun 2025 15:39:25 -0400
X-MC-Unique: K1mov-ZiNSGmHqlwcw030g-1
X-Mimecast-MFC-AGG-ID: K1mov-ZiNSGmHqlwcw030g_1750189165
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7489ac848f3so5607465b3a.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 12:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750189165; x=1750793965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJl3ISS5vZpEM73Zu2QnVbFcIkeedrpFNBWR+QK1Ynw=;
        b=KHiLy9OD7x4tA+YdmZaR7xQEjG3WfHK1Z1g07OHQx9jq39kkXcNf/D68WNqsP6CwwF
         7QuQK5xMNngm7t5/LzScc/ONwqWlh4nneHnkDyPSuRfuzHJG+cm0MtJOxdgpqNe9YNa7
         +TBwRPMW2i3gZfxLzlN+V0akxJks9pScWOG+C2sXhzOB5C4rq1g6kHUzdDQEmF12l6VP
         o7hT0qmyHjKENyNkMYDZi3nbbyWFmUNKaLoAR+XoG2TRiecLaJT2xe3TbCGV3XSm/bNz
         9R2zK9a0Tr5UFGadoFJm0quDlPpf2OBUVImdNvyRkyo6MgIqLcnETsngFckEex6EtOKU
         uCBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3ZRMtmRk4+EVeRB3M89CTu869sc/7aCxQdalU36zdAOr9HR8mvR8SDMtls0tYNH9qWV8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5SfvBoil1h34dVYDQMprycw3dilFXre1w3WghaOdaoXXQUJVQ
	O++DF7wYICxBFvqHj2l7VlNjQFxAJoGIRZVN71pAauGVVZhG/T7ONPWNkWw/GDdQdrZUof2Ds1/
	b0Td+GkHmIz3560ScO9FVZxBycSW5t0SG5cwRmi4QEBrD5XAh0oq1rQ==
X-Gm-Gg: ASbGncvKobXIopBTiPMUNTi2UN2BUHaGwboC9LioygvxaPDm/Gk+nAV6Bm+1u+9c58j
	A4v6EcOjwaz5n0mE8ttJY2Pb/wJH24RLY5GpB16Alvwn/j+354lxKq8t/IFINVBjTRdhig+Dei+
	8baPmAYSCf38akeOIH2SSEXS4V38ruDn2wGJnl5L4KgXbIgjQkKhRnZkLm8eVHYut4k6ePcm9RZ
	mmzQXYmBZ0KW+yacXECC/bf5P+j1TmvnY/PWIA2DG+of1vaGnkU4hil5VD3L6TsWXyxOvA2Q9vo
	I5jetp/GmYcNhg==
X-Received: by 2002:a05:6a00:3a19:b0:746:2ae9:fc3d with SMTP id d2e1a72fcca58-7489cffb6bbmr18361938b3a.23.1750189164734;
        Tue, 17 Jun 2025 12:39:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0d0QqjyrjopZorTKaCRFU/Z21FT70P9cxE4DFi+E6/jbvdkezfloKB99Q5wHRPPT6YtfIBg==
X-Received: by 2002:a05:6a00:3a19:b0:746:2ae9:fc3d with SMTP id d2e1a72fcca58-7489cffb6bbmr18361911b3a.23.1750189164376;
        Tue, 17 Jun 2025 12:39:24 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748d8093c63sm1700538b3a.57.2025.06.17.12.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 12:39:23 -0700 (PDT)
Date: Tue, 17 Jun 2025 15:39:19 -0400
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
Message-ID: <aFHEZw1ag6o0BkrS@x1.local>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
 <aFGcJ-mjhZ1yT7Je@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aFGcJ-mjhZ1yT7Je@x1.local>

On Tue, Jun 17, 2025 at 12:47:35PM -0400, Peter Xu wrote:
> On Tue, Jun 17, 2025 at 12:41:57PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 17, 2025 at 11:39:07AM -0400, Peter Xu wrote:
> > >  
> > > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > >  static unsigned long vfio_device_get_unmapped_area(struct file *file,
> > >                                                    unsigned long addr,
> > >                                                    unsigned long len,
> > > @@ -1370,6 +1371,7 @@ static unsigned long vfio_device_get_unmapped_area(struct file *file,
> > >         return device->ops->get_unmapped_area(device, file, addr, len,
> > >                                               pgoff, flags);
> > >  }
> > > +#endif
> > >  
> > >  const struct file_operations vfio_device_fops = {
> > >         .owner          = THIS_MODULE,
> > > @@ -1380,7 +1382,9 @@ const struct file_operations vfio_device_fops = {
> > >         .unlocked_ioctl = vfio_device_fops_unl_ioctl,
> > >         .compat_ioctl   = compat_ptr_ioctl,
> > >         .mmap           = vfio_device_fops_mmap,
> > > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > >         .get_unmapped_area = vfio_device_get_unmapped_area,
> > > +#endif
> > >  };
> > 
> > IMHO this also seems like something the core code should be dealing
> > with and not putting weird ifdefs in drivers.
> 
> It may depend on whether we want to still do the fallbacks to
> mm_get_unmapped_area().  I get your point in the other email but not yet
> get a chance to reply.  I'll try that out to see how it looks and reply
> there.

I just noticed this is unfortunate and special; I yet don't see a way to
avoid the fallback here.

Note that this is the vfio_device's fallback, even if the new helper
(whatever we name it..) could do fallback internally, vfio_device still
would need to be accessible to mm_get_unmapped_area() to make this config
build pass.

So I think I'll need my fixup here..

-- 
Peter Xu


