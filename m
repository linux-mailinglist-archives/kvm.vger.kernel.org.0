Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4733E8351
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhHJS4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 14:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231295AbhHJS4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 14:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628621770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aeyIMXFzQ8OzGR9pMLrY5l1FOe7kguJjNVeE5rzOXJQ=;
        b=FEWTuyihFbSiguWdpPCkaQ75LSo3br9Spv3bsUtewCwqkekLZlyQYfMR1ZWAXjSz9NXWep
        RMQDpO7kMp4Xgs6flribw+JCtpCglMYFWeH0X6kGWC7MuKDNwcRgzP5tmn0vGBO+jQ6tHY
        ZwaIh4BaMeUjomgaN9Z47pUOFcpa5Fw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-EIOAU9_XPliQTOielWiq2g-1; Tue, 10 Aug 2021 14:56:09 -0400
X-MC-Unique: EIOAU9_XPliQTOielWiq2g-1
Received: by mail-qk1-f200.google.com with SMTP id d20-20020a05620a1414b02903d24f3e6540so3280642qkj.7
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 11:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aeyIMXFzQ8OzGR9pMLrY5l1FOe7kguJjNVeE5rzOXJQ=;
        b=kW4Rbl4k6v12tvyTEXAKLUJ5iYzBmfpIzvOMrV/lJ5occ1UKi4pM3zJoZelaWxRriQ
         IBJmJ0ziUnFtZXo2RdQOATzV7/wdEpxYF638+Puj9+0XDfcQTLSrjK9ALS13uu0Qs102
         HZz+RosmQLaC8+IqfqjD37omAa7Y6J/7jdOECEeXxm65E0noIX5CprycKeLXd23nROZD
         C+Lb7RmEfe6zp2nOijG9wgqDZktZB1Rcb5zjTdkwrhb4ZrVa8mTV3zkkCPnxI1BkviQc
         e7H0xbFpXWJe3k1HupWv+mpztAI8dqTStftBuEoE9RXIC5YRWNtj5POdcj2XrSGjlm/f
         939Q==
X-Gm-Message-State: AOAM5315l3sftpfaPh3WGbJuZ45qEK7Za5Ee1Sbgh9NHJtz6rwG7wHLu
        NvwqK4UPtNkuA9kHoR7XqT1nvCr6rI4s8vmQbsN30s5/mqRPDWsvqUZd8xN+AVyTR0G8mS4jgsm
        MIQpjd9L1Ega5
X-Received: by 2002:ad4:4801:: with SMTP id g1mr19233070qvy.34.1628621769275;
        Tue, 10 Aug 2021 11:56:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY/8eH8qraAlg3QzXb5kdVEZIVe5XqgOyT/w9ICdKgY1ZKVgnUtZNKNx1/TkE7BD326QwTlw==
X-Received: by 2002:ad4:4801:: with SMTP id g1mr19233063qvy.34.1628621769108;
        Tue, 10 Aug 2021 11:56:09 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id x125sm11300960qkd.8.2021.08.10.11.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 11:56:08 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:56:07 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH 2/7] vfio: Export unmap_mapping_range() wrapper
Message-ID: <YRLLx5O6gleDqsMR@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818324222.1511194.15934590640437021149.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <162818324222.1511194.15934590640437021149.stgit@omen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:07:22AM -0600, Alex Williamson wrote:
> +void vfio_device_unmap_mapping_range(struct vfio_device *device,
> +				     loff_t start, loff_t len)
> +{
> +	unmap_mapping_range(device->inode->i_mapping, start, len, true);

(not a big deal, but still raise this up)

It seems to me VFIO MMIO regions do not allow private maps, so even_cow==true
should be the same with even_cow==false. even_cow==true will just check the
page mapping for each pte even though they should just all match, imho, so
logically "false" should work the same and should be tiny-little faster.

Thanks,

> +}
> +EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);

-- 
Peter Xu

