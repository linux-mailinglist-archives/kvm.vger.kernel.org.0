Return-Path: <kvm+bounces-4952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D45981A2B1
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF8131F2551B
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34973FE30;
	Wed, 20 Dec 2023 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpdI/XLN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2D23EA95
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703086382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zOraJ8EtpK3a82KEVeqo+zv+z0wo78YLbnSZwKkknO4=;
	b=HpdI/XLNXwuZ2Ge4B9ohyT6+BWIgyuN1kg4m2rM2gAhXqrStnu4Yl5Gv6CrqSRtmW3uuTI
	9SWv2UYv6VHHfKGD2mqOnohGgzVR8ibBCA780926lJJvN4QfyXS3kbrocswwI6FcSvdiWs
	itxSKN6DKSFSlzuHPyEjUlp16a9BSPk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-1fNv0llRMhqC4WJVxNqErQ-1; Wed, 20 Dec 2023 10:33:00 -0500
X-MC-Unique: 1fNv0llRMhqC4WJVxNqErQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7ba74c2a1d6so91963339f.0
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 07:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703086380; x=1703691180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOraJ8EtpK3a82KEVeqo+zv+z0wo78YLbnSZwKkknO4=;
        b=CjNs8hzgHarnzR9jsO7KRykezguZXA76nBmYSkHMdRCdufxrXWI6sloAspxAkX81pR
         eOsttqgTXi0W0trPz5M9Ef1Ahrq7CsGvnuILGLTFeSkmN4Ih9jQju9CzASyh1XIasXvT
         lvWe2un78Tr8egQ89LFuIL9lFrNu3MiagB1RufMNQn9Siglimp6fGbJSWpFa/FyikCjV
         cNLWADkizBQFyNcfW8lv6Sr9IxsaS5sCy9tl4VWToP9oybVMqA/QW/2nB5PU0vzg3/2B
         suaihhwbTeGK2jDWTGn2aGETHDgVESorgZ+cGykazlUjIgUdXZWoL2/dicjbWTfLrNUX
         Ridg==
X-Gm-Message-State: AOJu0YzbQGczCNVx6+wTSUloFYEem75DCa8HPJmaCuzhvt/2dO4gxJVg
	+uA3VEO0LKIq0+oik5kUkF9rx/15uSDH+rwEVOsdmfkpbtEXKceSM/cYVQQdT+0RKY/+l1Ctkr5
	1TDxmeRrtYR1Z
X-Received: by 2002:a6b:5b0f:0:b0:7b4:28f8:52b with SMTP id v15-20020a6b5b0f000000b007b428f8052bmr24869757ioh.43.1703086380013;
        Wed, 20 Dec 2023 07:33:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxpWVP1i6JdFd0/u9T35fO2z0so1HYY7WW1FTyKwy9nH7mwR5SzwWRRhV8SUvgBjZPtraDgQ==
X-Received: by 2002:a6b:5b0f:0:b0:7b4:28f8:52b with SMTP id v15-20020a6b5b0f000000b007b428f8052bmr24869751ioh.43.1703086379744;
        Wed, 20 Dec 2023 07:32:59 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t16-20020a02ccb0000000b0046b70eb348dsm620749jap.167.2023.12.20.07.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 07:32:59 -0800 (PST)
Date: Wed, 20 Dec 2023 08:32:57 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <kvm@vger.kernel.org>, <mst@redhat.com>, <sfr@canb.auug.org.au>
Subject: Re: [PATCH vfio] vfio/virtio: Declare virtiovf_pci_aer_reset_done()
 static
Message-ID: <20231220083257.5e76ca8e.alex.williamson@redhat.com>
In-Reply-To: <20231220082456.241973-1-yishaih@nvidia.com>
References: <20231220082456.241973-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Dec 2023 10:24:56 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Declare virtiovf_pci_aer_reset_done() as a static function to prevent
> the below build warning.
> 
> "warning: no previous prototype for 'virtiovf_pci_aer_reset_done'
> [-Wmissing-prototypes]"
> 
> Fixes: eb61eca0e8c3 ("vfio/virtio: Introduce a vfio driver over virtio devices")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/lkml/20231220143122.63337669@canb.auug.org.au/
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/virtio/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> index 291c55b641f1..d5af683837d3 100644
> --- a/drivers/vfio/pci/virtio/main.c
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -547,7 +547,7 @@ static const struct pci_device_id virtiovf_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
>  
> -void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
> +static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
>  	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
>  

Applied to vfio next branch for v6.8.  Thanks,

Alex


