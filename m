Return-Path: <kvm+bounces-25781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7272F96A6D8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30FA128AE1A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFF9192D73;
	Tue,  3 Sep 2024 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTUBB6e+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D0190693
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725389234; cv=none; b=mWrFQpr5Ymw/jvD66y6d3i38Qa4W6XZRTK1mGhR4f4uEjm6s2IjaA/nuBSIGQFKbRl8u9y0KL3tkk0/ls8KTccbQayqGVFFKbMEp7b+bpfWNFlQO4QLM8Bku8Pv5EgIfNtlNBRnofWbV4dpJQqJmqVBEru0bghU3UdYiyhhegKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725389234; c=relaxed/simple;
	bh=9fw3yLmVGvVS67/sHkf7QjBMcfR2KArwbDGYPnK0ydc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNi2NqFW5dmF8itoY/Vy5OgsurmpS2mc8EKqke5Vbu22VoNXanLHwZsFX5RKEL7xTwg72Gxw+LoQHM6HQzkvf3LQCRdevp8vkyzTOzPrS7eCeDpGqGP6RytEJMsoCFfA1QlHot6bkY1VE7NHqBs5ytBMfVepPcgHnrVE/UYQDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bTUBB6e+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725389232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RiYZls7XAH3fXWooN5lGFOF3Jc3SZNKa7sVf+1sWGVg=;
	b=bTUBB6e+KFS9fimWbL5hZhAWrpeCSnoMyMM8nUea+WZ8IBo3Ia5Q37lLN+Umfc1SNWJzLB
	yZoIlvqMb1YOsDid5Izo5b2pUBzvLgbD4y1aU1CFtO3DgHiMf6pthn4W5MTkVS7vUY6QEA
	MnB++ewM+FO0IKo3upZVE+JXPfP/FsQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-vAx1I2miP7i_mvsRe6ByFg-1; Tue, 03 Sep 2024 14:47:10 -0400
X-MC-Unique: vAx1I2miP7i_mvsRe6ByFg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a4d07d89fso44889539f.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 11:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725389229; x=1725994029;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RiYZls7XAH3fXWooN5lGFOF3Jc3SZNKa7sVf+1sWGVg=;
        b=GuYEbb/zPhDqT2zVaePGicitKDBplsNN4YOMrG+qVycaFR0Oy/TAR48LwlpYJJVilk
         uigL3cQAKCkq3HPIjkCunWzN+r90ER8WizQoECNPUsh+ufpQhrFLwSY+ZyOQKMRNgNBY
         rT7Gm1V5XlPULUD0vR1e4xMOBk/q9slwfy78wiQWZfkJHCesvthqCgBiW7a1roRgsuqW
         aSp/mF/gSefDBIVJBzDr50BjkClBg9P0jxt9cm95ORB3AbPj3m1zT5K5aQzKJPTGtUs3
         RtFPogbts4p1eZ89dxX2BFY+JTJO+ZE+//C1fJc2YMMm5kdho5RSUlQ2ZAQ/pzvoPBvg
         OS+A==
X-Gm-Message-State: AOJu0YzhzXP0qqEzqBFSVuWPR2KsoJhDYigsSJ80ZVDICpTJwpjmTppR
	+5H0PLBc+rk0meNR27gRrZqIFgxziMExkQUbmdCx4UsOrRh7dGydJolj1kaVjkb4lVnUvcpQIsP
	Yrf0tu8ZbzSCL0NO67HmGbhDdpPLm+0T8WZ17o1uk/1c6wYVO5HbP0fjtyQ==
X-Received: by 2002:a05:6e02:19c8:b0:39f:7050:6f5f with SMTP id e9e14a558f8ab-39f70506fb4mr10497855ab.5.1725389229139;
        Tue, 03 Sep 2024 11:47:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJhPRnAYcOWTvXTG2dd2PcZkuZ1cOljpqdC47/lzql5dL1/zxTeKjMgQttAAOA6UoUgBJvxw==
X-Received: by 2002:a05:6e02:19c8:b0:39f:7050:6f5f with SMTP id e9e14a558f8ab-39f70506fb4mr10497605ab.5.1725389228707;
        Tue, 03 Sep 2024 11:47:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39f3afc4ff6sm32862425ab.37.2024.09.03.11.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 11:47:08 -0700 (PDT)
Date: Tue, 3 Sep 2024 12:47:07 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/fsl-mc: Remove unused variable 'hwirq'
Message-ID: <20240903124707.4ecfc5de.alex.williamson@redhat.com>
In-Reply-To: <20240730141133.525771-1-yuehaibing@huawei.com>
References: <20240730141133.525771-1-yuehaibing@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Jul 2024 22:11:33 +0800
Yue Haibing <yuehaibing@huawei.com> wrote:

> Commit 7447d911af69 ("vfio/fsl-mc: Block calling interrupt handler without trigger")
> left this variable unused, so remove it.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> index 82b2afa9b7e3..7e7988c4258f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -108,10 +108,10 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
>  				       void *data)
>  {
>  	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> -	int ret, hwirq;
>  	struct vfio_fsl_mc_irq *irq;
>  	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
>  	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
> +	int ret;
>  
>  	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
>  		return vfio_set_trigger(vdev, index, -1);
> @@ -136,8 +136,6 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
>  		return vfio_set_trigger(vdev, index, fd);
>  	}
>  
> -	hwirq = vdev->mc_dev->irqs[index]->virq;
> -
>  	irq = &vdev->mc_irqs[index];
>  
>  	if (flags & VFIO_IRQ_SET_DATA_NONE) {

Applied to vfio next branch for v6.12.  Thanks!

Alex


