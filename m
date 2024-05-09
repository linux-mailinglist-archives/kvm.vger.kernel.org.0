Return-Path: <kvm+bounces-17121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DB18C1135
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B55ED1F23085
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40F315E7E2;
	Thu,  9 May 2024 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlxuDlRy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C8413A3F3
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264987; cv=none; b=Cd7KMxrBCB9nbdywenDZa0T1uONqFFPQvFBQ1qT5XQyQ+HwjfMDYxTR/OP+xAAf2ZTJV9YoDnQm1EKejV7OCeEo5RZdcuYNvaxxyO4jdsIv89S/EK0xlLY3QHA5onEnP8vILAT0qw3a8O8hHGe+oYkdU/rZsnx3XMwLrtRhbT1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264987; c=relaxed/simple;
	bh=vUAQCwT5DYoY+N8IEhXi9/QjZVnb++zhokjf7htK2HI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fogUM0LprEvaxAq4FMk7o/9AxPwiWMBk71IByGE/yQwURy9bAXTnBD62OO3aliOWARPEehL9gTWsFnRdDTOPDCZcMbcJrc0ggqYrSXjUUue70g8pgf+CvPLl6HLVUlzfLvbnvgXt3hOMQwLd614FuNl884LgzAMl6KuSAgdQTb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlxuDlRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715264984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+5whHKtKmTPniU0MUQJnppQ0+qSDE9HGLUKotDsWWs4=;
	b=LlxuDlRy71sIsTLGF5/nxKC45uXzL/xvDGtlfG0rd39TZjoePCStupWLutEWnSlG/IKE07
	6Zs9cEz8Vw5xqSDIpjAWel3vzfm5D6mtsxSOx+YtKmEzMdIcGn7pqw+RYuYhYSNiN8TM4I
	IkEWeomW+K848sAc8DyZsXt70oFX0fU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-0g7sytMaO9uU4rBDiSXXOQ-1; Thu, 09 May 2024 10:29:43 -0400
X-MC-Unique: 0g7sytMaO9uU4rBDiSXXOQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36c1af8f2f3so11248145ab.3
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 07:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715264982; x=1715869782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+5whHKtKmTPniU0MUQJnppQ0+qSDE9HGLUKotDsWWs4=;
        b=e118eJM+iTNH0o3HIa1BlU+h3cPk4EMdhxftdtzwdlhWez8b8NeFZgLKJboyShsCB/
         NnHVmGKExM1wGtmagiCxuArqG/HKVnn2jkQvwj7NVHO3qxnBwVYrHGej1sYg0rChQBrR
         Wx+RieH345lAvj6BIkyiVd6WAqu1rAx+huF9M/0ritHiz+rkwNp+lYjuP3bWNN825Vu7
         5K52EiVOS3Stp6zsSdEi33U06RgpnT6znemCBQQ+mlW5DOzWv/h/KY2B3FsEcItU/Gsh
         A56TuIpUUPMKCHmIYx/UPMzFqaSxfj8fQiIXIjUCRfhEEnUaEY7gM8+zXcUzf0ZXtb4g
         rG1g==
X-Forwarded-Encrypted: i=1; AJvYcCVwGeY3yOLrYLhYsfm6WfO2rrSPbKVXa7cMFSFLQiLY75lf3jjoIX6rJhfqMydAGOuacuxr+zX0QKNzergADppzrXDt
X-Gm-Message-State: AOJu0Yw/Hpe/bh3vryr2E6NhJqSFn8D7mBsXn1XC+y4XZA/gLD9fu9ZL
	RBBGZv+X8gAFWPAS+m8ALexpXgvcnMw2u5jr252RtbJUktLRCWEMsyoKXZveLNzkLgArVW5yide
	wu5LtQEIszi6Kq+cP+BMJ9gQ8o5eXnfjvNYl/hdU+ncqLu8WB8A==
X-Received: by 2002:a05:6e02:1c2e:b0:36c:297d:2c96 with SMTP id e9e14a558f8ab-36caed146c9mr63864405ab.19.1715264982499;
        Thu, 09 May 2024 07:29:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIdpDjGHGexgw5o9U8vuEzt3Q/nQ23++X0YJfBn6yfypXc9bFXjp+dyTMggXFB65Z1qNLGbg==
X-Received: by 2002:a05:6e02:1c2e:b0:36c:297d:2c96 with SMTP id e9e14a558f8ab-36caed146c9mr63864235ab.19.1715264982221;
        Thu, 09 May 2024 07:29:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9d97495sm3246765ab.44.2024.05.09.07.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 07:29:41 -0700 (PDT)
Date: Thu, 9 May 2024 08:29:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location
 of the XQC address
Message-ID: <20240509082940.51a69feb.alex.williamson@redhat.com>
In-Reply-To: <ed07017d74f147b28a069660100e3ad1@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-3-liulongfang@huawei.com>
	<20240503101138.7921401f.alex.williamson@redhat.com>
	<bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
	<20240507063552.705cb1b6.alex.williamson@redhat.com>
	<3911fd96-a872-c352-b0ab-0eb2ae982037@huawei.com>
	<20240508115957.1c13dd12.alex.williamson@redhat.com>
	<ed07017d74f147b28a069660100e3ad1@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 May 2024 09:37:51 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, May 8, 2024 7:00 PM
> > To: liulongfang <liulongfang@huawei.com>
> > Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linuxarm@openeuler.org
> > Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location of
> > the XQC address  
> 
> [...]
>  
> > > HiSilicon accelerator equipment can perform general services after  
> > completing live migration.  
> > > This kind of business is executed through the user mode driver and only  
> > needs to use SQE and CQE.  
> > >
> > > At the same time, this device can also perform kernel-mode services in the  
> > VM through the crypto  
> > > subsystem. This kind of service requires the use of EQE.
> > >
> > > Finally, if the device is abnormal, the driver needs to perform a device  
> > reset, and AEQE needs to  
> > > be used in this case.
> > >
> > > Therefore, a complete device live migration function needs to ensure that  
> > device functions are  
> > > normal in all these scenarios.
> > > Therefore, this data still needs to be migrated.  
> > 
> > Ok, I had jumped to an in-kernel host driver in reference to "kernel
> > mode" rather than a guest kernel.  Migrating with bad data only affects
> > the current configuration of the device, reloading a guest driver to
> > update these registers or a reset of the device would allow proper
> > operation of the device, correct?  
> 
> Yes, after talking to Longfang, the device RAS will trigger a reset and
> would function after reset.
> 
> > 
> > But I think this still isn't really a complete solution, we know
> > there's a bug in the migration data stream, so not only would we fix
> > the data stream, but I think we should also take measures to prevent
> > loading a known bad data stream.  AIUI migration of this device while
> > running in kernel mode (ie. a kernel driver within a guest VM) is
> > broken.  Therefore, the least we can do in a new kernel, knowing that
> > there was previously a bug in the migration data stream, is to fail to
> > load that migration data because it risks this scenario where the
> > device is broken after migration.  Shouldn't we then also increment a
> > migration version field in the data stream to block migrations that
> > risk this breakage, or barring that, change the magic data field to
> > prevent the migration?  Thanks,  
> 
> Ok. We could add a new ACC_DEV_MAGIC_V2 and prevent the migration
> in vf_qm_check_match(). The only concern here is that, it will completely
> block old kernel to new kernel migration and since we can recover the
> device after the reset whether it is too restrictive or not.

What's the impact to the running driver, kernel or userspace, if the
device is reset?  Migration is intended to be effectively transparent
to the driver.  If the driver stalls and needs to reset the device,
what has the migration driver accomplished versus an offline migration?

If there's a way to detect from the migration data if the device is
running in kernel mode or user mode then you could potentially accept
and send v1 magic conditional that the device is in user mode and
require v2 magic for any migration where the device is in kernel mode.
This all adds complication though and seems like it has corner cases
where we might allow migration to an old kernel that might trap the
device there if the use case changes.

Essentially it comes down to what should the migration experience be
and while restricting old->new and new->old migration is undesirable,
it seems old->old migration is effectively already broken anyway.  As
you consider a v2 magic, perhaps consider how the migration data
structure might be improved overall to better handle new features and
bugs.  Thanks,

Alex


