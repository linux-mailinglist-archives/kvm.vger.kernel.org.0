Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8E3DF4ED
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbhHCSpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 14:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239231AbhHCSpb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 14:45:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628016319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vD4GHHiAQujvrl1/opzUUx/uFZKgR5lwlMLUYlItd0Q=;
        b=NL2Prij89lxH5pgMDhJSS97vgeR22yKoiBY0+LzZlZ6td9wdzc28mEVSsIrPe8/G0kxc4S
        3rNYPEAHYic8AvxppjcOBAsR7MQ/QcVI5+XYL1CtJGHR8kDExr9WTdXk9MPNKakaCB4eXC
        o8hObIkSUT2HogrO2DqDfkKQIqmK/Ak=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-J66qQS43OROYpTqexdnn-A-1; Tue, 03 Aug 2021 14:45:18 -0400
X-MC-Unique: J66qQS43OROYpTqexdnn-A-1
Received: by mail-ot1-f70.google.com with SMTP id j12-20020a9d190c0000b02904d23318616aso10185981ota.17
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 11:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vD4GHHiAQujvrl1/opzUUx/uFZKgR5lwlMLUYlItd0Q=;
        b=Mj5HzFqFTpYDmMnYso4Q6oDJUiprKR34r0EMXpGij7A4ftdxG1Ua77Crn3eIiWJ2HW
         VQixoPWF2JClZdGeL11Ll4w00mI5ni7SZC66qG579SN+loWrFJDGOPL6h6t+IUuAm1r+
         CYA99/jfu+B+piR89ozoVfMXjfdyEhGONpytFFZdSS7g4FiGvUmSTgbW1zBhX+D0Njmp
         YFnhfF6JHmURgq2Ae9H/Xdi2GkSt3OenhHBkNuoLaeBG9ApiOvL9gPR4fOeb1NUy8MuK
         Mzh5QGQvVhQNnbmTMsZzD3Dl+rDXvCkvloSrxGS4Y4xzubI5EhNOTm8zJSATzkQYSmqX
         s/iA==
X-Gm-Message-State: AOAM5335f7FZesVqO2PiaDUfRo63fGH9FcI9wi2LDO0YMgq9HI5CO6XV
        ebUoe9vYgL1D7GPZg31vCem4Lg4jASNcTOgRGEfb6866ajP5MRd69sPkahjHI5c4WbmKs8p+UH6
        L0doOhT4TsvAD
X-Received: by 2002:a4a:de08:: with SMTP id y8mr15449640oot.82.1628016317415;
        Tue, 03 Aug 2021 11:45:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCfhff+efEfTZP7FOJU9riq82NNdenr4cPJ+RBArqw/DOV4JlQPqPyE+EnKVMCeq6hipJkUQ==
X-Received: by 2002:a4a:de08:: with SMTP id y8mr15449633oot.82.1628016317267;
        Tue, 03 Aug 2021 11:45:17 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id bg9sm2584126oib.26.2021.08.03.11.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 11:45:17 -0700 (PDT)
Date:   Tue, 3 Aug 2021 12:45:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v3] vfio/pci: Make vfio_pci_regops->rw() return ssize_t
Message-ID: <20210803124516.7531a1b6.alex.williamson@redhat.com>
In-Reply-To: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
References: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Jul 2021 10:05:48 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> The only implementation of this in IGD returns a -ERRNO which is
> implicitly cast through a size_t and then casted again and returned as a
> ssize_t in vfio_pci_rw().
> 
> Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
> consistent.
> 
> Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)

Applied to vfio next branch for v5.15 with Max and Connie's R-b.
Thanks,

Alex

