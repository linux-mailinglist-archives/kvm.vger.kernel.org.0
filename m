Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690897A4525
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbjIRIu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbjIRIuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 04:50:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05359120
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 01:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695026944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XjrLFNKkiROohp1YQUFUAWvCAJRc18i6LWfUqVeHSNg=;
        b=X32ITeBLVeRXHp7zHCH3yuhG45DDxs0i3vWHizSQzxA+A25DU4ZjqK/WggcnUO+luXrYC1
        1zkQP08X/7vQZFO5NUsjwxm//snbRm33fq5f/PR8WfOWxH5ciwtxbj//m/JJJcbjykzOhA
        4Bg+f9ExkJKqUq18Ei1c3QqvCoykczE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-x9FNLMSqNA6WYw2y94ACqQ-1; Mon, 18 Sep 2023 04:49:02 -0400
X-MC-Unique: x9FNLMSqNA6WYw2y94ACqQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-501c70f247cso3207973e87.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 01:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695026940; x=1695631740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjrLFNKkiROohp1YQUFUAWvCAJRc18i6LWfUqVeHSNg=;
        b=o/oPDAaM5iYj/qYq6Z934TaochJn07Ipy9Cz29t4T4a5eJtG6wojSoXEOz8H1s5JP3
         pDBOiN1AI5QiQij641n/psngv8iWNvtHOOvoBvUc14/WQXTb4qu7OPADr5Qf4LPeopBy
         wps+UiS7lg2FpoGAD2vIXaVBHaA2Wz0EzBZr0zWG4CXXKovD5GopZ/Vw0g9WNQz/yukj
         2DQHbtkllhILyDIX0KY7GFVlpGLPbyVj9LftFuF1ta5o4SSK+4m0QLUtiloH9IMx5oj5
         Y888v2ZULsgDcbe28mQ3ozqzx5SJsLYx3l8/+tA5p5oUb3Atbsz5vPz9ilwChPxiTTYV
         dDQg==
X-Gm-Message-State: AOJu0YwLIJbgyNiePu0kqBBjFPmGKojCad1j3hB3K+WM5D+1VGTlgHit
        GVgTBw2HEpL9crle9nLXDit1QRHsJTOt2xFYSNPQGPlspVHtdohnz2YDLMmGXZrckOygx3MZKOT
        HPyzn6MsQDtdMit/35tXLjenvfZ9/RJwFrzxqe9g=
X-Received: by 2002:a05:6512:454:b0:500:9a45:63b with SMTP id y20-20020a056512045400b005009a45063bmr6257567lfk.13.1695026940423;
        Mon, 18 Sep 2023 01:49:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcNhH5iIOphVoYXcP9ThVDZ+q8P4m1obQ5qx04ejzkKLACIx/Lt0O6PKx0zAhN2vKlafazLnuEdoCmJbrjonc=
X-Received: by 2002:a05:6512:454:b0:500:9a45:63b with SMTP id
 y20-20020a056512045400b005009a45063bmr6257546lfk.13.1695026940132; Mon, 18
 Sep 2023 01:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-5-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-5-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 18 Sep 2023 16:48:49 +0800
Message-ID: <CACGkMEtCYG8-Pt+V-OOwUV7fYFp_cnxU68Moisfxju9veJ-=qw@mail.gmail.com>
Subject: Re: [RFC v2 4/4] vduse: Add new ioctl VDUSE_GET_RECONNECT_INFO
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 11:01=E2=80=AFAM Cindy Lu <lulu@redhat.com> wrote:
>
> In VDUSE_GET_RECONNECT_INFO, the Userspace App can get the map size
> and The number of mapping memory pages from the kernel. The userspace
> App can use this information to map the pages.
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++++++++++
>  include/uapi/linux/vduse.h         | 15 +++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index 680b23dbdde2..c99f99892b5c 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1368,6 +1368,21 @@ static long vduse_dev_ioctl(struct file *file, uns=
igned int cmd,
>                 ret =3D 0;
>                 break;
>         }
> +       case VDUSE_GET_RECONNECT_INFO: {
> +               struct vduse_reconnect_mmap_info info;
> +
> +               ret =3D -EFAULT;
> +               if (copy_from_user(&info, argp, sizeof(info)))
> +                       break;
> +
> +               info.size =3D PAGE_SIZE;
> +               info.max_index =3D dev->vq_num + 1;
> +
> +               if (copy_to_user(argp, &info, sizeof(info)))
> +                       break;
> +               ret =3D 0;
> +               break;
> +       }
>         default:
>                 ret =3D -ENOIOCTLCMD;
>                 break;
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> index d585425803fd..ce55e34f63d7 100644
> --- a/include/uapi/linux/vduse.h
> +++ b/include/uapi/linux/vduse.h
> @@ -356,4 +356,19 @@ struct vhost_reconnect_vring {
>         _Bool avail_wrap_counter;
>  };
>
> +/**
> + * struct vduse_reconnect_mmap_info
> + * @size: mapping memory size, always page_size here
> + * @max_index: the number of pages allocated in kernel,just
> + * use for check
> + */
> +
> +struct vduse_reconnect_mmap_info {
> +       __u32 size;
> +       __u32 max_index;
> +};

One thing I didn't understand is that, aren't the things we used to
store connection info belong to uAPI? If not, how can we make sure the
connections work across different vendors/implementations. If yes,
where?

Thanks

> +
> +#define VDUSE_GET_RECONNECT_INFO \
> +       _IOWR(VDUSE_BASE, 0x1b, struct vduse_reconnect_mmap_info)
> +
>  #endif /* _UAPI_VDUSE_H_ */
> --
> 2.34.3
>

