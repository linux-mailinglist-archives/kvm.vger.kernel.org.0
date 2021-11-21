Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB02F4583F3
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhKUOFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 09:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbhKUOE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 09:04:59 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2058C061574
        for <kvm@vger.kernel.org>; Sun, 21 Nov 2021 06:01:54 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g17so42394642ybe.13
        for <kvm@vger.kernel.org>; Sun, 21 Nov 2021 06:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67hXTk+abh43UjHxqiTsE4nJZHn+VwdkmDRyJHK8nSY=;
        b=UkobBgeJOpG0dAyl0RJu8bocWDhDashoxt+RZ9OMCQRyDudWxiNpjxgFyRz9g7UYO+
         6ehhbaG2ZoZccwSK7elPTzs4JB3D7/KgBPgpx5OssQamLzLGbYqGWsTF3ZTlDSWXchlr
         yLjKQd4o1gU45HQDliJLeifo6dLRSDO0XBV0A8XFEcStul1dAOHJ1Y5lVHQJWnwLgPPr
         HgwNkRBBd5s9adwyH9W5jl0gSj8xGHOHeJ6iZdGrWWccggOgd1N9ocjiNiyF2vwxe/NL
         m6XefcCgR8j0Mgish1Hm9NaNIHWD5TGf9lUt+Axwz3DomnavHebMdaEDFlmpQe5eFlLg
         WoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67hXTk+abh43UjHxqiTsE4nJZHn+VwdkmDRyJHK8nSY=;
        b=z3hPwFf01ORqMECH5ayYJWxleOD2A7ZhvCPMAfOmSAjB+fSuK/CMHgugIdSaFdF4Hy
         ecmBkecaotFVjasTxl6aelYRKR77ItC5KAAYVqdnafrHFyx0nUq05x9DtAyMINyTKfkZ
         J5rLkrT6M54pSBZyob9LsIjcTFxJ51DU+qnKkZMeMTwjJbKVEgOtGkpxoUh6hyaV0wil
         XKtvfRtPlScHHRQDl/S6XDMk0WoeDrJvM+yy3zabC+U6N0Wq4R4pjErC1/NVArLOgVjb
         FNBEmY/aeBYQGWKDKpTqUUtSELAoSaWv244rpHyIbNJ0BzLNCXJs3Hhnuva1xzlBgr7H
         U7Jw==
X-Gm-Message-State: AOAM531xW890yVVgGo0a0x/Zg272rkDk51FYIWGFrKQAq3v4Y6NlhS8c
        D8gl5Gwpp+YW+QVPpLWFuxE5y1wHXg5JncfbB9v4nA9B
X-Google-Smtp-Source: ABdhPJxNl9xVDFHZgecUYqmoFdnpWMMKJWAsdUC1ioqxSryJe1cqB+5XIkRNeJsiPeNfh1E1V5vi0rUL4JlhOiYzocA=
X-Received: by 2002:a25:28c6:: with SMTP id o189mr54417512ybo.462.1637503314047;
 Sun, 21 Nov 2021 06:01:54 -0800 (PST)
MIME-Version: 1.0
References: <20211119081435.3237699-1-zhenyuw@linux.intel.com>
In-Reply-To: <20211119081435.3237699-1-zhenyuw@linux.intel.com>
From:   Colin Xu <colin.xu@gmail.com>
Date:   Sun, 21 Nov 2021 22:01:43 +0800
Message-ID: <CAB4daBR9YVnUnzPW9CPsBAsHmnfm1-2o5cwe_z_cjV5iAOKB9A@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Fix OpRegion read
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, Dmitry Torokhov <dtor@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the fix.
The implicit ptr cast will incorrectly advance the pointer. Cast to
byte is the correct step.

Best Regards,
Colin

On Fri, Nov 19, 2021 at 4:14 PM Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>
> This is to fix incorrect pointer arithmetic which caused wrong
> OpRegion version returned, then VM driver got error to get wanted
> VBT block. We need to be safe to return correct data, so force
> pointer type for byte access.
>
> Fixes: 49ba1a2976c8 ("vfio/pci: Add OpRegion 2.0+ Extended VBT support.")
> Cc: Colin Xu <colin.xu@gmail.com>
> Cc: Dmitry Torokhov <dtor@chromium.org>
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
>                         version = cpu_to_le16(0x0201);
>
>                 if (igd_opregion_shift_copy(buf, &off,
> -                                           &version + (pos - OPREGION_VERSION),
> +                                           (u8 *)&version + (pos - OPREGION_VERSION),
>                                             &pos, &remaining, bytes))
>                         return -EFAULT;
>         }
> @@ -121,7 +121,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>                                           OPREGION_SIZE : 0);
>
>                 if (igd_opregion_shift_copy(buf, &off,
> -                                           &rvda + (pos - OPREGION_RVDA),
> +                                           (u8 *)&rvda + (pos - OPREGION_RVDA),
>                                             &pos, &remaining, bytes))
>                         return -EFAULT;
>         }
> --
> 2.33.1
>
