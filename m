Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC426B8937
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 04:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCND5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 23:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCND5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 23:57:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB8587DA4
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 20:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678766181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUTGoKigOjF7lnPsnySj5O1n6jQabFHTwPAHfAEzD+g=;
        b=G8iyA6zoIJk+7D5kiOqcAOXMLDnjtAq4BXcw9WZ9uXof6vemeot4h2kwJesHIV14DPA0Kz
        dt0HJ6craUDU9OE/CWcTnr3fpXkMEQEjM7GrDR/3hFlQVSQ/IiZ8g5hv9avISpaIgHugQ5
        XlDkNpw7ngTjgzghzIERC78xXURFeh8=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-pLXVcOytOOK1spLZFmqDtw-1; Mon, 13 Mar 2023 23:56:20 -0400
X-MC-Unique: pLXVcOytOOK1spLZFmqDtw-1
Received: by mail-ot1-f72.google.com with SMTP id v11-20020a05683011cb00b006945a70256dso6893959otq.1
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 20:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678766179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gUTGoKigOjF7lnPsnySj5O1n6jQabFHTwPAHfAEzD+g=;
        b=Ofx5lZQbXk4YSCR0RppJ9nKV6EfuhFc9JPWK2KoHy/YnDUPmNKK5jBVsaNPM5FQB54
         tO/f6kMxLgbk7DEKpXPDubY8Bs5MERJDHKdshc8m1wV3MO8IQMhyguduGbz2Ei5XOaCL
         HdtZ7X6481g8etFpZYMn0Ue9zoa6WMGU16Qc3Z9aG3aYMHMJ/BNNziLQv6Ge8j77rOYG
         Ki+EeBD8qSOIfXOgzXSt0eon2zFNISDcbJtT37pOyciONEzzgmkGlNYSLuz6gWJwtupV
         cErd+uuuQamDuORVbHu+bj9GJUz+KDntx1tKTMR16kBG5M7N3DxBmJ80IpQYpJQf8Xoz
         +ydg==
X-Gm-Message-State: AO0yUKXOLe6k/Izp49UfYM1B9s2UC42qhoXtCuzmiYtUx4RorvodlVhW
        WS8Uu7tjbHfutK7uIgbeXcLa0+6IkrO+G9RZJ67IYkEf1xjZ5J8NWfThYT3o9mDLUNQ9298Q9Sx
        8TeFyMyLzjQQyw3w2dtZr0HOFnZ89
X-Received: by 2002:a9d:1984:0:b0:696:46dd:bec7 with SMTP id k4-20020a9d1984000000b0069646ddbec7mr491244otk.2.1678766179429;
        Mon, 13 Mar 2023 20:56:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set/8cD2YJCW/GyAom9yPG1fRPOW6omllIrRCSG8zrwMHOV27MDaBDu6YXAj5Pwq1SwhCEPZrqYs4Ze4SH/NyHBo=
X-Received: by 2002:a9d:1984:0:b0:696:46dd:bec7 with SMTP id
 k4-20020a9d1984000000b0069646ddbec7mr491235otk.2.1678766179150; Mon, 13 Mar
 2023 20:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-4-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 11:56:08 +0800
Message-ID: <CACGkMEs6cW7LdpCdWQnX4Pif2gGOu=f3bjNeYQ6MVcdQe=X--Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> kmap_atomic() is deprecated in favor of kmap_local_page().

It's better to mention the commit or code that introduces this.

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
> kmap_atomic(),

Note we used to use spinlock to protect simulators (at least until
patch 7, so we probably need to re-order the patches at least) so I
think this is only valid when:

The vringh IOTLB helpers are not used in atomic context (e.g spinlock,
interrupts).

If yes, should we document this? (Or should we introduce a boolean to
say whether an IOTLB variant can be used in an atomic context)?

Thanks

> so that mere replacements of the old API with the new one
> is all that is required (i.e., there is no need to explicitly add calls
> to pagefault_disable() and/or preempt_disable()).
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
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

