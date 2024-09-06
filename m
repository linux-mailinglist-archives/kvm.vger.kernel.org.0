Return-Path: <kvm+bounces-26017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEACD96F8A5
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 17:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04EE6B2220F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DDA1D31A1;
	Fri,  6 Sep 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSf2Eyql"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17594374F1
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637818; cv=none; b=UXg7OCyNiNBZ+UOPOVQWbKsjcb3cu0eTn6EmekuQeRuxEMR8Zr0eGnvE9Y2MRuRwLI8bmM0FUVMnDXbzI6z0SavMkORArZn2YB9iQ7UPTZl+coBD+fBWUdtEzJXCPa3pJYL1Bpr9zIoYorl8VCnAmB1T3wZvGEMX/6qawUmtQOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637818; c=relaxed/simple;
	bh=voVoKIR4SB0Lj8UyHwZfICbRddc6TUvPDi1bMScCwcA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7e78KTWpqGIlbGd/8CgB4GtMzBI0UGbaNlqpsRJi2AAXencXFsD1dEn5Eyk6vCwwOlBSWZev4n+FbEF02bx7nC8aqYWVIaMugqGIBMYZDmjUhRqyiU7hcrWnwXoqJtDeUmgRfDEp6XDbY735t5cbVLHG6vtQVjhymygpJztgYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YSf2Eyql; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725637816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqozqY4UtKMVO8LR3fBYcUPklBK0aAGz51hg8+BEiWg=;
	b=YSf2EyqldM98zqEEvx4CPWDXxsbN5aIYMAB8EBhssCbl5DxMY2CGXr2+GAAaZlR/yJNqDv
	S0NdsqHzzykOicge7OKjNZ4rMg2DEImH5e1VqF7Q3IGoXe9cM9Py0USgqUR3Is66hyIDgM
	6+TMR8I3MeVHFiyatK2fN7kJq6NZLCQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-3aaR_snUP-KIgc8Ayt7Eog-1; Fri, 06 Sep 2024 11:50:15 -0400
X-MC-Unique: 3aaR_snUP-KIgc8Ayt7Eog-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a4d07d89fso67289639f.3
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 08:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725637814; x=1726242614;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HqozqY4UtKMVO8LR3fBYcUPklBK0aAGz51hg8+BEiWg=;
        b=jTTs92PBmT1b3bRjTM3wC3kO9vBsD3oo2Ciqk/tarWVjw3h3wJTaAMIBG0W33DQ9iI
         LB3qkDDL7mD8m6krh23QtuAVNojQgjy4xBfjTLYtteB0/ie1LF/cHsMt0ecivj56cCc+
         8EXxxtCLSk2DH0MWSFmhA3fqQaUZP0qZRQsQ5NIQsXeeBAWnV/DDxrY5l1Tp3JuP9Z/c
         6BSIR6f9sG614EZTNT3bvnM1EAIttyuWEP0RW0fvzqUFux42rdekYSn3yaXcDZydgWGG
         YlZ09GXa+EBQ2KwuxoHUS1IvtKpo3dc9BeKUk4oHZ0vLa+I+0SoEHfIhfI9qcmxKk/nS
         9HTw==
X-Forwarded-Encrypted: i=1; AJvYcCXX/9fATJTaffJXFFqLSDmvvJCX0TJSJqGrIKM0ytphB1C1/dVYMxEC6FnYB2hUe8t9qBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxFZXqWZLObXbPU9a3MtqfxxFIUt/Nr96YFhK12wnkA2UDQpSk
	C5naRgzk4Q8bWtRspcRXtjeZgJuFUXos/rK+piV8u4DrO70pGdk7wpr5eNT6SZ8V6NZHDATVHWO
	QqCrkmh9W7vJuDnnR14cl0K5Cwl3pdqUTDxt503HeJPHgNVCBK0Xmdnb1Dg==
X-Received: by 2002:a6b:7f41:0:b0:81f:9219:4494 with SMTP id ca18e2360f4ac-82a96214b56mr186426539f.2.1725637814303;
        Fri, 06 Sep 2024 08:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8lrPeDwOb14eoPvBTw2MlvKtC6vAvEyktdfWjIP3XFtrP9mF3v0jA3yTc+vCL1uI2iejA4g==
X-Received: by 2002:a6b:7f41:0:b0:81f:9219:4494 with SMTP id ca18e2360f4ac-82a96214b56mr186425239f.2.1725637813935;
        Fri, 06 Sep 2024 08:50:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d06a1c5cdesm1025256173.81.2024.09.06.08.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 08:50:13 -0700 (PDT)
Date: Fri, 6 Sep 2024 09:50:11 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: <kwankhede@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/mdev: Constify struct kobj_type
Message-ID: <20240906095011.380c695b.alex.williamson@redhat.com>
In-Reply-To: <20240904011837.2010444-1-lihongbo22@huawei.com>
References: <20240904011837.2010444-1-lihongbo22@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Sep 2024 09:18:37 +0800
Hongbo Li <lihongbo22@huawei.com> wrote:

> This 'struct kobj_type' is not modified. It is only used in
> kobject_init_and_add() which takes a 'const struct kobj_type *ktype'
> parameter.
> 
> Constifying this structure and moving it to a read-only section,
> and this can increase over all security.
> 
> ```
> [Before]
>    text   data    bss    dec    hex    filename
>    2372    600      0   2972    b9c    drivers/vfio/mdev/mdev_sysfs.o
> 
> [After]
>    text   data    bss    dec    hex    filename
>    2436    568      0   3004    bbc    drivers/vfio/mdev/mdev_sysfs.o
> ```
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 9d2738e10c0b..e44bb44c581e 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -160,7 +160,7 @@ static void mdev_type_release(struct kobject *kobj)
>  	put_device(type->parent->dev);
>  }
>  
> -static struct kobj_type mdev_type_ktype = {
> +static const struct kobj_type mdev_type_ktype = {
>  	.sysfs_ops	= &mdev_type_sysfs_ops,
>  	.release	= mdev_type_release,
>  	.default_groups	= mdev_type_groups,

Applied to vfio next branch for v6.12.  Thanks!

Alex


