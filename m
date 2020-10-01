Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A4F27FF6B
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 14:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbgJAMqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 08:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731891AbgJAMqm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 08:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601556400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Js563GcaR2/yt5ZRRb4g7uvZTFa1RVtXs31pHNFBFkg=;
        b=RXMT8ybI/DtCizqV42MCHXcUUePtAUW1c/V3LW7DZkpFyTq0Egzu4S3s90djEHpE1Bg1HB
        q94BFq4defsIkxQUpieyXx40F4NCbUgK2cET/UDQ6hGjATL/Pq6K+/cc5rJeC5Kk03GKow
        nLjaM83zpOCR2hgfuJ+3XXJn/fR+XVo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-GJlmBjkyN0yk45KfKKw26g-1; Thu, 01 Oct 2020 08:46:35 -0400
X-MC-Unique: GJlmBjkyN0yk45KfKKw26g-1
Received: by mail-wr1-f69.google.com with SMTP id l17so1981094wrw.11
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 05:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Js563GcaR2/yt5ZRRb4g7uvZTFa1RVtXs31pHNFBFkg=;
        b=CqBRcHd62ECtp5dN1Ct95GqF/OCKv6CzK1I4jv0Rgh0LbCOGHwVu0QPAPqFMaMsreB
         GhWaUOlao4cBQVt7C6fD/9HUcq+O5+nQ6MZEk6IYtfB3ET2s6hVjO7YrJ4OzE+RrXdQl
         EGP8dmXnnANo1Dkf3LkO1/95/8VEOImN4XkbvX2ahDotlckqD/o+YWa3OOE2Qdy/Jjhy
         /zilUdQ0l7dqpF3vBTrtE5tsA0k7+GMx0TdX+hAtIMoIg1nMr/L+ETxI5g62nd7sDCIG
         OXNefL7vEE64/9FfqD0pNSOnnjJi5SSzrhr9y7CTPJYl3v7pRF8ZXHMUfSS60lUvlsXr
         vXMw==
X-Gm-Message-State: AOAM5331A9y6ekt4ALTJD2AxrpLRgDubtOotC+ucf09mEWTtU8Gr2rcQ
        Y4RoL56p2fIkXMqy/6t4wCCKPjh1IVLDzccKFlesVs//pCH5vP/gDVRATv94FIKA5sp0nnwmeIy
        wQAcDxBUkp8+P
X-Received: by 2002:a7b:c774:: with SMTP id x20mr2389449wmk.102.1601556394412;
        Thu, 01 Oct 2020 05:46:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH6EuErZXThHeJ05UE72wy3Fr8fkLJJnHtXxx76BlpIz/RYUHWaHYI9cBE1T6i8tXzrTOyqA==
X-Received: by 2002:a7b:c774:: with SMTP id x20mr2389421wmk.102.1601556394184;
        Thu, 01 Oct 2020 05:46:34 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id y1sm8480045wma.36.2020.10.01.05.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:46:33 -0700 (PDT)
Date:   Thu, 1 Oct 2020 08:46:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 0/2] vhost: Skip access checks on GIOVAs
Message-ID: <20201001084608-mutt-send-email-mst@kernel.org>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 06:30:20PM +0200, Greg Kurz wrote:
> This series addresses some misuse around vring addresses provided by
> userspace when using an IOTLB device. The misuse cause failures of
> the VHOST_SET_VRING_ADDR ioctl on POWER, which in turn causes QEMU
> to crash at migration time.
> 
> While digging some more I realized that log_access_ok() can also be 
> passed a GIOVA (vq->log_addr) even though log_used() will never log
> anything at that address. I could observe addresses beyond the end
> of the log bitmap being passed to access_ok(), but it didn't have any
> impact because the addresses were still acceptable from an access_ok()
> standpoint. Adding a second patch to fix that anyway.
> 
> Note that I've also posted a patch for QEMU so that it skips the used
> structure GIOVA when allocating the log bitmap. Otherwise QEMU fails to
> allocate it because POWER puts GIOVAs very high in the address space (ie.
> over 0x800000000000000ULL).
> 
> https://patchwork.ozlabs.org/project/qemu-devel/patch/160105498386.68108.2145229309875282336.stgit@bahia.lan/

I queued this. Jason, can you ack please?

> v2:
>  - patch 1: move the (vq->ioltb) check from vhost_vq_access_ok() to
>             vq_access_ok() as suggested by MST
>  - patch 2: new patch
> 
> ---
> 
> Greg Kurz (2):
>       vhost: Don't call access_ok() when using IOTLB
>       vhost: Don't call log_access_ok() when using IOTLB
> 
> 
>  drivers/vhost/vhost.c |   32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> --
> Greg

