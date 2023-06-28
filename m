Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2FC740AB1
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjF1IJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232316AbjF1IEu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofwo3P8uKOaWvV1X+hYEb8hA8CV2BceFbJ10PxbVumI=;
        b=WAtCvFZtzjwk/ERT0HcXYckMliozUFX2x0dKeO70lNcsTwo0YbgglsLAeW3iRiXlUiZHKI
        XOKwtlq1TBlQndIvWWN3la6XcjbYQe/97Z/u8C+Lis5nC4aILU+cqUABc+sYiv8VWN5LUE
        CSyqSteiP+uZdJYaJ0r9R9HkLCG0nec=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-Vvq5zTXEOZu3EHyu-QmIZQ-1; Wed, 28 Jun 2023 04:03:53 -0400
X-MC-Unique: Vvq5zTXEOZu3EHyu-QmIZQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f9569b09a3so459991e87.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687939432; x=1690531432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ofwo3P8uKOaWvV1X+hYEb8hA8CV2BceFbJ10PxbVumI=;
        b=ljzRSCdLX9omMoQHS6DZcbK58SeIvlk7/WVmYZQDf4Z1HXPopQuMqTM/LqqaE6teKY
         RjIACOpRcKyriE3DQAOsmQEdhWHxxRY/g+2F04aDtk8ANBJZ5iYzE0b8KlxPURMtZdIc
         O8jgxloYOCbbgtx0XpMZvZQOrQSYokoHL+cRjGtLRsfAQPvPuqoiH6mMOIhGgnHN0LaB
         InsOLN/F2pUfUEftGCv04/S/Djko/7R2IVAW6WhyEmwKJRtUvV7K2NPGrc7EtRsEv3Ww
         puE6N/M+9b235BG6O7+QeAnQzDHQ27f0/P3iyJH1VFaPVZuUN1fHyYZSSlEyyBqmDzGo
         ctQw==
X-Gm-Message-State: AC+VfDx5vzt7pi+/uV4t4VyUdOaTuAnRFguQ//hXnCarJnPXhuQjJ231
        c9p5WOj7RUMxK9AY/w/xqlveYSyLqe5L0PukjgwjHg33BLA+RdRpmzankOgMc2cfg+MjUsmQfUc
        01OG1YFkRGejuqkAdeXOheVCajfEl
X-Received: by 2002:a05:6512:2828:b0:4f8:75d5:e14f with SMTP id cf40-20020a056512282800b004f875d5e14fmr206450lfb.28.1687939432274;
        Wed, 28 Jun 2023 01:03:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+VHNhq6OsMLyItLK9e1q5NqGMrmykMJR0HIs4eAUBTfGZ9IUjxcd7L2s5r2cSDn4Ra3WnvvHrOmw346uihVA=
X-Received: by 2002:a05:6512:2828:b0:4f8:75d5:e14f with SMTP id
 cf40-20020a056512282800b004f875d5e14fmr206443lfb.28.1687939431925; Wed, 28
 Jun 2023 01:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230628065919.54042-1-lulu@redhat.com> <20230628065919.54042-2-lulu@redhat.com>
In-Reply-To: <20230628065919.54042-2-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 28 Jun 2023 16:03:40 +0800
Message-ID: <CACGkMEvTyxvEkdMbYqZG3T4ZGm2G36hYqPidbTNzLB=bUgSr0A@mail.gmail.com>
Subject: Re: [RFC 1/4] vduse: Add the struct to save the vq reconnect info
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 2:59=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> From: Your Name <you@example.com>

It looks to me your git is not properly configured.

>
> this struct is to save the reconnect info struct, in this
> struct saved the page info that alloc to save the
> reconnect info
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index 26b7e29cb900..f845dc46b1db 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -72,6 +72,12 @@ struct vduse_umem {
>         struct page **pages;
>         struct mm_struct *mm;
>  };
> +struct vdpa_reconnect_info {
> +       u32 index;
> +       phys_addr_t addr;
> +       unsigned long vaddr;
> +       phys_addr_t size;
> +};

Please add comments to explain each field. And I think this should be
a part of uAPI?

Thanks

>
>  struct vduse_dev {
>         struct vduse_vdpa *vdev;
> @@ -106,6 +112,7 @@ struct vduse_dev {
>         u32 vq_align;
>         struct vduse_umem *umem;
>         struct mutex mem_lock;
> +       struct vdpa_reconnect_info reconnect_info[64];
>  };
>
>  struct vduse_dev_msg {
> --
> 2.34.3
>

