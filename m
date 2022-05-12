Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FF452549B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357560AbiELSVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357551AbiELSV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:21:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6198445057
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652379685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liwTgUxqAqwFiu3hiQYmfoukAO/Bb2SxBCCUw8+D2Eo=;
        b=bqJnltqnpmX2MrrND2B4ho1X9wEzbxKkw/DViaW8YL+OW9R4OGrQAOb4alqJVHOOGf5dUA
        ItmRaVbQTV2Bi2hnyuTCeXh4uFIhVO2JQ5Z5yjq2b0jktt6aOogDhIcAEHItMj4QHPXSC4
        jCLLpgT6K9LqE5DjJYXnhjUGUaj/99w=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-JX3ha5R5OP-rQjstUAWZMA-1; Thu, 12 May 2022 14:21:24 -0400
X-MC-Unique: JX3ha5R5OP-rQjstUAWZMA-1
Received: by mail-il1-f200.google.com with SMTP id k15-20020a92c24f000000b002d0ee4f5d79so949238ilo.9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=liwTgUxqAqwFiu3hiQYmfoukAO/Bb2SxBCCUw8+D2Eo=;
        b=yVi1sdWz0TmRCQB1HbBp5BYwG6hP+b/wrE9Qd+N30i/NJE4TemvX2Z/w3CHRSQAmYE
         NlO/P5nEOcojh0T0TLeIYAXytkCzyS4+YTau81iOZjPnVbs9QydGSXqvHtRIajMYJqWp
         orOVxDiy3ncTd4bU3d7+s04UzzQG7xrOU8fMrLAaZHUWj6ete7z21Owd8N1iPYpC6gvO
         lDi+1LbjjGhb/SQz6TtticFPQxtv7VgMmZul+UN1XKEAkMfixzLPLm4RZVFy/tuHnEj9
         /7rHYoh3lynD0zMPCUQLt1CNKxsxf0zIQx0+lKHnIcHdQyyp4GbCyYY+wyHVfgt/byT+
         HIUA==
X-Gm-Message-State: AOAM5311YrJz2n9TXTH2y6nDzyp62/uBLW6erNZG1g4BNRcZtkOTi0NO
        1fDxght2hTOvd3FODbtnE6FVQssWhQzaOs8fR8DO9MkfKdOCXOolq2dWAIIY11rPKPGpzgLrmyh
        aBo1ZsGOUrfRF
X-Received: by 2002:a05:6e02:2146:b0:2cf:87ae:ddb0 with SMTP id d6-20020a056e02214600b002cf87aeddb0mr689794ilv.188.1652379683041;
        Thu, 12 May 2022 11:21:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeQb/MQ5kg9HqtwVpVAaSTmnED1ANBhiXTkVXgRWmq7UXDkHZcOFHlURBKM69GaMWdymo+kw==
X-Received: by 2002:a05:6e02:2146:b0:2cf:87ae:ddb0 with SMTP id d6-20020a056e02214600b002cf87aeddb0mr689788ilv.188.1652379682840;
        Thu, 12 May 2022 11:21:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g18-20020a0566380c5200b0032b3a7817b8sm57930jal.124.2022.05.12.11.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:21:22 -0700 (PDT)
Date:   Thu, 12 May 2022 12:21:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     cohuck@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Stop using iommu_present()
Message-ID: <20220512122121.348e5f82.alex.williamson@redhat.com>
In-Reply-To: <537103bbd7246574f37f2c88704d7824a3a889f2.1649160714.git.robin.murphy@arm.com>
References: <537103bbd7246574f37f2c88704d7824a3a889f2.1649160714.git.robin.murphy@arm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 13:11:54 +0100
Robin Murphy <robin.murphy@arm.com> wrote:

> IOMMU groups have been mandatory for some time now, so a device without
> one is necessarily a device without any usable IOMMU, therefore the
> iommu_present() check is redundant (or at best unhelpful).
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/vfio/vfio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e..7b0a7b85e77e 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -745,11 +745,11 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  
>  	iommu_group = iommu_group_get(dev);
>  #ifdef CONFIG_VFIO_NOIOMMU
> -	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
> +	if (!iommu_group && noiommu) {
>  		/*
>  		 * With noiommu enabled, create an IOMMU group for devices that
> -		 * don't already have one and don't have an iommu_ops on their
> -		 * bus.  Taint the kernel because we're about to give a DMA
> +		 * don't already have one, implying no IOMMU hardware/driver
> +		 * exists.  Taint the kernel because we're about to give a DMA
>  		 * capable device to a user without IOMMU protection.
>  		 */
>  		group = vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);

Applied to vfio next branch for v5.19.  Thanks,

Alex

