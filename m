Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4106463EA1
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbhK3Tds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 14:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239807AbhK3Tdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 14:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638300626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WESWr+5BI8GRSBi9Cos1Mk5W6Xh2KYOOudnrwzLkW30=;
        b=BSwtgqY+me8PO12juwjJy8nOG6kF1N6/u/4f14ttcNMGlh7qMnLRoJMkofs7xqercoETSW
        XCibkogkSFJvWxDTuJNg3WFqTD4prJcSbu78Yejzk3hIcDV4BKDrSMWfheS0wM1+vFFQI+
        OswbUp1p/j1fxhv4SCOyzICBqz3x7h8=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-Ev_CDfZwPOOXD5CsZcE9_g-1; Tue, 30 Nov 2021 14:30:25 -0500
X-MC-Unique: Ev_CDfZwPOOXD5CsZcE9_g-1
Received: by mail-oo1-f71.google.com with SMTP id v67-20020a4a5a46000000b002c9c5da9902so7332663ooa.16
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 11:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WESWr+5BI8GRSBi9Cos1Mk5W6Xh2KYOOudnrwzLkW30=;
        b=dNL23TcHAuow0gRGosOehY11xL+Zb8tQzKu2nNTi3wkwLHu94u5vk3eGQJao1xQ4nn
         ZwHYFB5ENJovxGUJj79zUy6s53JEVpBAS1lp0FsZuIdx3Z6Xx/N/hdBGSnyVGWOtDQiR
         f+q71RpYaKPiNkfYx4Mxm6j1vIKqIJbRQ3IMb0rWuYrtOeVfBdRprGl5wc7KJKr/CzwE
         uVEpPxSuyGfdiEwSZ3Na7A98xnuA4CCSnjqIx1PkOMBjSoOwXLNxXGnQsGMcq9Vpu8Xj
         wv2+1zIRVZ0GCjc2yFTnPmt/TpBpQS1X/1qHsbZC0HvxW4hc3tf0j3i+/ZfR1oAAGMQw
         gVVA==
X-Gm-Message-State: AOAM530+BNjju910cV18or8DfyRgGcJRFsqfbbv9G1REDSI/i9asydAU
        0z2zAExAh1wEzIy13hV2OLVGpC5mAKzgVB0HQdd5q5TY3JMRz5JnukpCtFJpOJFWRqURLfgsijl
        3D7yxHCT06Ryt
X-Received: by 2002:a05:6808:1485:: with SMTP id e5mr1025400oiw.156.1638300624182;
        Tue, 30 Nov 2021 11:30:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnCloXxSDC9Gc5c8OssnUR6/XWlmqWL98bnVrepoupE5fiZrnCNtF1YGm14IBbss0ZYuzpaQ==
X-Received: by 2002:a05:6808:1485:: with SMTP id e5mr1025386oiw.156.1638300624034;
        Tue, 30 Nov 2021 11:30:24 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h1sm3311356otq.45.2021.11.30.11.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 11:30:23 -0800 (PST)
Date:   Tue, 30 Nov 2021 12:30:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, Colin Xu <colin.xu@gmail.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Gao, Fred" <fred.gao@intel.com>
Subject: Re: [PATCH] vfio/pci: Fix OpRegion read
Message-ID: <20211130123021.2c4dd788.alex.williamson@redhat.com>
In-Reply-To: <20211125051328.3359902-1-zhenyuw@linux.intel.com>
References: <CAB4daBTAci-ygY0sXbK7v8x84r7Q33WGunKLYjR8jQNjt4BZNQ@mail.gmail.com>
        <20211125051328.3359902-1-zhenyuw@linux.intel.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Nov 2021 13:13:28 +0800
Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> This is to fix incorrect pointer arithmetic which caused wrong
> OpRegion version returned, then VM driver got error to get wanted
> VBT block. We need to be safe to return correct data, so force
> pointer type for byte access.
> 
> Fixes: 49ba1a2976c8 ("vfio/pci: Add OpRegion 2.0+ Extended VBT support.")
> Cc: Colin Xu <colin.xu@gmail.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Dmitry Torokhov <dtor@chromium.org>
> Cc: "Xu, Terrence" <terrence.xu@intel.com>
> Cc: "Gao, Fred" <fred.gao@intel.com>
> Acked-by: Colin Xu <colin.xu@gmail.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 56cd551e0e04..dad6eeed5e80 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -98,7 +98,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>  			version = cpu_to_le16(0x0201);
>  
>  		if (igd_opregion_shift_copy(buf, &off,
> -					    &version + (pos - OPREGION_VERSION),
> +					    (u8 *)&version + (pos - OPREGION_VERSION),
>  					    &pos, &remaining, bytes))
>  			return -EFAULT;
>  	}
> @@ -121,7 +121,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>  					  OPREGION_SIZE : 0);
>  
>  		if (igd_opregion_shift_copy(buf, &off,
> -					    &rvda + (pos - OPREGION_RVDA),
> +					    (u8 *)&rvda + (pos - OPREGION_RVDA),
>  					    &pos, &remaining, bytes))
>  			return -EFAULT;
>  	}

Applied to vfio for-linus branch for v5.16.  Thanks,

Alex

