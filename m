Return-Path: <kvm+bounces-28782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E40A99D3E3
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B9F2859F7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FAA1ABEB1;
	Mon, 14 Oct 2024 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5tDW+WD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A0785628
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920958; cv=none; b=sU3MUMo5tA40uuqkAkrbAdWDPuaqfy8lSW5i/AhquyD1PK/r4htTSqVDi+yEDtAJlzpVRQTPx3fs5eQiqps/8IRrFjNwK1Q3vx4L+D662OS2faX/ACA8D99Ebm2ujWO+9H0ZDKc+NetKvkESC8WvDl8RT//Vn9ZizELraRpQmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920958; c=relaxed/simple;
	bh=XRS/dhY3lhsy5JlKSK/pDayLQmj12dslPK6ZKBfJS1I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVpXUCmtL4riR4NQjsV56X/DI+Fwi2WL4l6vvJcSUmngYfywVm1Cykt+vR4kWyD1UoYnv5FokOH3ilGLuIbSeFKbiOZ8hvsHWULaLYn7BA499QdRpVkkltZoAzL0vPw7asy4VmnVnkNY3ClSJA4DKC1cElOfHXpnk0bL1x9jqlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5tDW+WD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728920955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5oOyJqq8PPkDeXUCYaZe3E5gfpM/CyhtuyeM6PK2gI=;
	b=N5tDW+WDCP8DjFE6WHxOKo0cetLv4fHYgNFGI6SSxKDOPX0gNRgwyeX3nX+k6xLu7jWjtp
	1w3cCfuzGF+IrvVXe/oshY1AWN/JKpHngdrZiY1Gl3/uXVQLNygL0uCuo4d77M+zlWHwO1
	ra1phK+KVGNQZpHQwiInFKlzrcqCmx4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-T33hO_O8OpaYsRKBbkIt2w-1; Mon, 14 Oct 2024 11:49:14 -0400
X-MC-Unique: T33hO_O8OpaYsRKBbkIt2w-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8353c004245so41845639f.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 08:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728920954; x=1729525754;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r5oOyJqq8PPkDeXUCYaZe3E5gfpM/CyhtuyeM6PK2gI=;
        b=gJ4kYbxsTt11RTrPaXo7bzGill/4otLPtSWOeXIHKOht2tJ6og8jwrAaJub+BZSehx
         oUGo+vk7UoPVgMvYocjcBVZ3qBwF+52j6RG1LmyXshg7ZtnQnOe3NmULEFOO7d+VdATX
         1ojDHiJ6WmqeUrJblekFr358oIg8Pl9rFr6B2OUc72uVuAX0M61KSeCSQ/2vUEgZpUje
         ZE1Mx/WIsWlyMAVE/S34ih86RER7KX18y2hEhQ/YIMp+QhoNi0q7RSUEpSBtVK1h3mwf
         ub0yjKfiPRxjtpeysgpumOwEJfjzrbuwhyPC9zi6OUNU9fDr0V6fgCrLqjv8wpWa2nIE
         oI/w==
X-Forwarded-Encrypted: i=1; AJvYcCUB1kedBF4g0d7Fx3hTgWnjP/cS/aiNHwy9TbuCLnB09aCRWl+4AJRnSsyRHIa0mvo3hOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3rgUOiSaSVqXlhckXKj1dbW2R6AIJBt9McvIE4sniNiTNSScO
	JI9KmsgXcrdawcDUXwiNkJqbJdAjmqjjXoIB3v9REMmyeyr1kRqQ5uJUoBqcEIcjxRen+EEh6aD
	fMp9xH2LD9lrsfAH2oahgW1wpq1P1InQJ6Dw8zIxTjcJ4zJUM5Q==
X-Received: by 2002:a05:6602:1d42:b0:82c:f075:e033 with SMTP id ca18e2360f4ac-8379202d3bdmr268320739f.1.1728920953925;
        Mon, 14 Oct 2024 08:49:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUFkYkuWYHNF8mjIwi8TJAn4sHd44prmigXPuDnZRjvu50tB9Qo+nw7+fZFLhBf8JiFPBHQw==
X-Received: by 2002:a05:6602:1d42:b0:82c:f075:e033 with SMTP id ca18e2360f4ac-8379202d3bdmr268319939f.1.1728920953522;
        Mon, 14 Oct 2024 08:49:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbd2c7e34asm5505357173.84.2024.10.14.08.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 08:49:12 -0700 (PDT)
Date: Mon, 14 Oct 2024 09:49:11 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 3/4] vfio: Add
 VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <20241014094911.46fba20e.alex.williamson@redhat.com>
In-Reply-To: <a435de20-2c25-46f5-a883-f10d425ef37e@intel.com>
References: <20240912131729.14951-1-yi.l.liu@intel.com>
	<20240912131729.14951-4-yi.l.liu@intel.com>
	<BN9PR11MB5276D2D0EEAC2904EDB60B048C762@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20241001121126.GC1365916@nvidia.com>
	<a435de20-2c25-46f5-a883-f10d425ef37e@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 12 Oct 2024 21:49:05 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/10/1 20:11, Jason Gunthorpe wrote:
> > On Mon, Sep 30, 2024 at 07:55:08AM +0000, Tian, Kevin wrote:
> >   
> >>> +struct vfio_device_pasid_attach_iommufd_pt {
> >>> +	__u32	argsz;
> >>> +	__u32	flags;
> >>> +	__u32	pasid;
> >>> +	__u32	pt_id;
> >>> +};
> >>> +
> >>> +#define VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT	_IO(VFIO_TYPE,
> >>> VFIO_BASE + 21)  
> >>
> >> Not sure whether this was discussed before. Does it make sense
> >> to reuse the existing VFIO_DEVICE_ATTACH_IOMMUFD_PT
> >> by introducing a new pasid field and a new flag bit?  
> > 
> > Maybe? I don't have a strong feeling either way.
> > 
> > There is somewhat less code if you reuse the ioctl at least  
> 
> I had a rough memory that I was suggested to add a separate ioctl for
> PASID. Let's see Alex's opinion.

I don't recall any previous arguments for separate ioctls, but it seems
to make a lot of sense to me to extend the existing ioctls with a flag
to indicate pasid cscope and id.  Thanks,

Alex


