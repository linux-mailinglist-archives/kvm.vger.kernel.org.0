Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6EF6C5D02
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 04:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjCWDDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 23:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCWDDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 23:03:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1664B20573
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 20:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679540544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1/q/ATjsfc/6alZ9skuNHGyOSWC2q/7g+svCIqwPXA=;
        b=Y2Kt1gp7ytHDE7Hd2iJj68fRa18H28cDkyoUNi8jy3g4kNAR05QmJrl9TXR4dbO3+pe59N
        I5VomsRxTWxjPuoT/Dz3OHthiAWWL2mu7b6OGyrz4HGAoDBx6x66jnNS6zAcbhbpJMGC1u
        SQdj3HNoRHxNOc757AzL49ddvlofjnw=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-jJzhChJ_Nq6EQS5BG7DFtA-1; Wed, 22 Mar 2023 23:02:23 -0400
X-MC-Unique: jJzhChJ_Nq6EQS5BG7DFtA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-176249fbc56so10726222fac.6
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 20:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679540542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1/q/ATjsfc/6alZ9skuNHGyOSWC2q/7g+svCIqwPXA=;
        b=Mvo7FZbNXrGF3LomSG6wwyqPJJfucDtMTg6JxqKwpxzTu4QklT+qQVDxKHwXxssPh1
         xUeEzgixpJ86CboeVfQ8CO9U3sB3ciWOlUyH5bCY543+TWu4u3sFuIvK2z6f4km4m1OS
         +m0uq4ZrhVP5OTiHrVEQWDnvLRWoMoGqPBODL/SBmKNIlq+zdLfRsOo4DEYv8PsWSoHJ
         t+nkM5bR20jE7iTKWOj5aMBUEl/wheakBAVZhGiEC6ju8oJR123vurcFj2bYvd6jaDvV
         wIbfqQqhFNkHJmMZRGxweeT0vxUk6Gwn+v0dVzi34ye5JEPy7xo12rh5x9sL4UpVESA4
         apnw==
X-Gm-Message-State: AO0yUKUcEesQ24gMf3YnGpoSCAJNBHH+/nAD2nZfs7DXBCMZh1FQqga6
        ULHAcym6VWQC/ZZY7VNUOm5IUXEWMznlGGJH7es9PP5EPx8BfD31/P7aeNyfN7Eq6+oNtrKrf3O
        Sm3nOjV8xzcXAWxhuK3Zo3t8CD/ZN
X-Received: by 2002:a54:400a:0:b0:384:27f0:bd0a with SMTP id x10-20020a54400a000000b0038427f0bd0amr1632034oie.9.1679540542226;
        Wed, 22 Mar 2023 20:02:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set8KGY7ymo8deUihSS/JSlAOb5tzZYOZLT+Km6uuakG63U+Wxly37yoFJagU90whn6RDzKuaNOE/YjnljkXMXVA=
X-Received: by 2002:a54:400a:0:b0:384:27f0:bd0a with SMTP id
 x10-20020a54400a000000b0038427f0bd0amr1632024oie.9.1679540541948; Wed, 22 Mar
 2023 20:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-4-sgarzare@redhat.com>
In-Reply-To: <20230321154228.182769-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:02:11 +0800
Message-ID: <CACGkMEsnh9atkXwqn7gx0uKfPLLuph9ROh_0GvaUTXQfv01hkw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] vringh: replace kmap_atomic() with kmap_local_page()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 11:42=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> kmap_atomic() is deprecated in favor of kmap_local_page() since commit
> f3ba3c710ac5 ("mm/highmem: Provide kmap_local*").
>
> With kmap_local_page() the mappings are per thread, CPU local, can take
> page-faults, and can be called from any context (including interrupts).
> Furthermore, the tasks can be preempted and, when they are scheduled to
> run again, the kernel virtual addresses are restored and still valid.
>
> kmap_atomic() is implemented like a kmap_local_page() which also disables
> page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> otherwise it only disables migration).
>
> The code within the mappings/un-mappings in getu16_iotlb() and
> putu16_iotlb() don't depend on the above-mentioned side effects of
> kmap_atomic(), so that mere replacements of the old API with the new one
> is all that is required (i.e., there is no need to explicitly add calls
> to pagefault_disable() and/or preempt_disable()).
>
> This commit reuses a "boiler plate" commit message from Fabio, who has
> already did this change in several places.
>
> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Notes:
>     v3:
>     - credited Fabio for the commit message
>     - added reference to the commit that deprecated kmap_atomic() [Jason]
>     v2:
>     - added this patch since checkpatch.pl complained about deprecation
>       of kmap_atomic() touched by next patch
>
>  drivers/vhost/vringh.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index a1e27da54481..0ba3ef809e48 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_atomic(iov.bv_page);
> +       kaddr =3D kmap_local_page(iov.bv_page);
>         from =3D kaddr + iov.bv_offset;
>         *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_atomic(kaddr);
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> @@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vring=
h *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_atomic(iov.bv_page);
> +       kaddr =3D kmap_local_page(iov.bv_page);
>         to =3D kaddr + iov.bv_offset;
>         WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_atomic(kaddr);
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> --
> 2.39.2
>

