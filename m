Return-Path: <kvm+bounces-9441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC708604F0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 22:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A4CC1F21512
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 21:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB87412D20D;
	Thu, 22 Feb 2024 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P7/fzb0N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E973F13
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708637848; cv=none; b=rn5sdbTK0MAmN9ScDb+fSMmMq+kP732EBo4IqmgpbBZ9YS91bYicEyRsePENJ4u0Peyztw7uQXejilx+TR8sZCRys+GPmkbFBrYYXM4HXHjqarIIO6BYiQE/Fz5J4E9+VbHI7QjACGxo0SBxyxixjQgHcvit1Qpi6+7pWWGgVok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708637848; c=relaxed/simple;
	bh=CRQLcQZZCyWq7iQgWSpsPFZZBjaRvd9wTMW8gMdChFo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUfD5KovQFvH3PejwEafzW4oFGE/ArpsAjqNXWPMDyscJYcYlG5cn8tPHRr7wYXsnhCRvN8gnQPuxZJsW8F1DEnHztGhBYPKX3AmGkXHHYSCmnJNmy+EbEL7nNHSw5R+PDQilr9HnXWoCN/hcdkF76GwDrWeyt3wnsee4pStuBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P7/fzb0N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708637846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7l+9clzjVKQA+xkkzwU5JxUEh+E5T8G22Hnvhg7ds4=;
	b=P7/fzb0NZRy6g4+Tql3ckZ/lTWX2yq+3gYpNTUEAUXiiAn3lVYscG3yuHePgbsreKaEDWf
	qFEERPM7ByPc4VoFJKzNTx3KYDJhPZPFN1epx2eHXUEvga3khme+y+cJsdSd+3AfP6fTQh
	kpNH/ytMROpTO8nMIwpk3q4JFl42l2c=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-zRK1GfzJNqaztn7eXLiUJw-1; Thu, 22 Feb 2024 16:37:24 -0500
X-MC-Unique: zRK1GfzJNqaztn7eXLiUJw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c76a65a4aaso22503039f.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 13:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708637844; x=1709242644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7l+9clzjVKQA+xkkzwU5JxUEh+E5T8G22Hnvhg7ds4=;
        b=APHc67hS688TPPS15r+fG0oFkSzeFkQHLnqbQr3g4Pxtgb8/mUjiLVl2Qdl1GB1QtB
         jFmggSv+E0vxvX7IlEI7GOKnm7yYNCbdhrxmOgoS93MtRwPOsfYOrdXAjhvaVoj9lm+o
         J4er54avxtesI/mQAnILEt0ijOclaUoi3AmaWewr06tGIMcwUlPPtfdekEiGKHHraJmO
         qE8hJO8RugqWIoUm/nzM5mZGerE+T+SO/2w2QjNTGKOzzEwIkhVMULuZTLzqJpNf+XzF
         gnN5tji5HLBPDYilc7rlxuS1skm+u+hziZMRGKYyK7Rsz1R/M+HZMF5QUCWzM9kKPdsC
         jPzQ==
X-Gm-Message-State: AOJu0Yw5765rE9FRIEo6lqoZ+5EWM16BqimxtEhajDOT6HGxg+YrSHh9
	m4AdMGrY8P9Qc7Qohq9wnQMAaDwxKeaCRegkv4yNXNSfNz+gb9p0dXTbkF8lL+1BYQHfYOUmGch
	/C58MLZSlIcihSbNHOdA5a6P8hz4pra4ITkeTqrmlCj/fQr8IrhdOzMLAMQ==
X-Received: by 2002:a6b:e00e:0:b0:7c0:3d0f:b7cf with SMTP id z14-20020a6be00e000000b007c03d0fb7cfmr2831137iog.8.1708637843584;
        Thu, 22 Feb 2024 13:37:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/m5G6udUIqgOLIq2GJ6IMPYm7AvkII6Jm6SmNbDfsGtL4njJ2KwbwX+3lenHBYb+iEfCSAA==
X-Received: by 2002:a6b:e00e:0:b0:7c0:3d0f:b7cf with SMTP id z14-20020a6be00e000000b007c03d0fb7cfmr2831128iog.8.1708637843367;
        Thu, 22 Feb 2024 13:37:23 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id l14-20020a056638220e00b004743021012asm2117827jas.2.2024.02.22.13.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:37:22 -0800 (PST)
Date: Thu, 22 Feb 2024 14:37:17 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Kunwu Chan <chentao@kylinos.cn>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Message-ID: <20240222143717.5e6bd5d8.alex.williamson@redhat.com>
In-Reply-To: <20240115063434.20278-1-chentao@kylinos.cn>
References: <20240115063434.20278-1-chentao@kylinos.cn>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 14:34:34 +0800
Kunwu Chan <chentao@kylinos.cn> wrote:

> kasprintf() returns a pointer to dynamically allocated memory
> which can be NULL upon failure.
> 
> This is a blocking notifier callback, so errno isn't a proper return
> value. Use WARN_ON to small allocation failures.
> 
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
> v2: Use WARN_ON instead of return errno
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..61aa19666050 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2047,6 +2047,7 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  			 pci_name(pdev));
>  		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
>  						  vdev->vdev.ops->name);
> +		WARN_ON(!pdev->driver_override);
>  	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>  		   pdev->is_virtfn && physfn == vdev->pdev) {
>  		struct pci_driver *drv = pci_dev_driver(pdev);

Applied to vfio next branch for v6.9.  Thanks,

Alex


