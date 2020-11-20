Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B32BB5A8
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgKTTfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 14:35:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728622AbgKTTfq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 14:35:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605900944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kaGyevx9bKbJa/Uo/GEmlNDAH9YfZ7oI6laQDA+pda0=;
        b=L7BZfkysQqobCv9OoB5GvJ08g3OrkdwN22o9//lgcJCposxEUc28w2rEomGBvrBzw3Ka/t
        eqa4VlKe11Kp3nBGVVr0yXzGMxHOzeUuL+aYuzOryltYfoxOZvD+81SxFD4EHF4RGfl9c2
        kKJkh1KGovlfPolMiJe0j6MygRfkw2I=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-2mREp2qBMM6Gflbkub9QeA-1; Fri, 20 Nov 2020 14:35:42 -0500
X-MC-Unique: 2mREp2qBMM6Gflbkub9QeA-1
Received: by mail-qk1-f197.google.com with SMTP id x85so8778402qka.14
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 11:35:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kaGyevx9bKbJa/Uo/GEmlNDAH9YfZ7oI6laQDA+pda0=;
        b=Dai8IWHf/9jTvv3Oo/5a+gtr9MW2ykQFAhSr7+zDd+A0ygAFwzI9i1Do2AURetuNNo
         rYlYPZr0BmTLvCUrK+XzffNBrohKPw2uFAIGBrDm17daOuLqwEQXgB9dDhz8gD8xCGgG
         bXPDv9pJPSQDB3p1JUaYjyNz76pTZKzthlvTcETpZ7Dk2EJoG77Ufk0TXyDH3jRqiESA
         yTk9U0hVAPKT7o357bRR7t85NtK+a8caTNYbyl6W/nbHPEnCSKZqQEZYTgiFQ2h/MFT3
         fOM1xLBlSScFDdJv9IU8rpiang7/NCBvbeZSYg9Z03RHyil1iiscQxAJqK9FVZ/Tllxd
         +kpQ==
X-Gm-Message-State: AOAM530CZ6AYWSpKEX6+iGXiEe6Ei2WLfvZxw96LZJRSDqCyJ2i7M5RF
        cNo0ycCRcQI+G/O9LnctKEO+kflY7OKcUuZde/9Lm5TK6+L9rEKW/4Mrpopee2qNgJN4pee+Uwc
        R524AW3LOm5McHBBtwx0f2sTrzCIB
X-Received: by 2002:ad4:4051:: with SMTP id r17mr13579872qvp.39.1605900942257;
        Fri, 20 Nov 2020 11:35:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEWE3AxwjU9e+BlJSEt7dnIJDH7qPT0GZiFEk0NSR9+fpXLCgv65B/saA/egK3fv56fMNdOMAejiJ325PXQg8=
X-Received: by 2002:ad4:4051:: with SMTP id r17mr13579837qvp.39.1605900942042;
 Fri, 20 Nov 2020 11:35:42 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-26-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-26-eperezma@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 20 Nov 2020 20:35:06 +0100
Message-ID: <CAJaqyWdad0x5R=VpGazbroZwd_Rig+n5kEJwgv3MY+WweUCYAA@mail.gmail.com>
Subject: Re: [RFC PATCH 25/27] vhost: Do not commit vhost used idx on vhost_virtqueue_stop
To:     qemu-level <qemu-devel@nongnu.org>
Cc:     Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 8:12 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> ... if sw lm is enabled
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index cb44b9997f..cf000b979f 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1424,17 +1424,22 @@ static void vhost_virtqueue_stop(struct vhost_dev=
 *dev,
>      struct vhost_vring_state state =3D {
>          .index =3D vhost_vq_index,
>      };
> -    int r;
> +    int r =3D -1;
>
>      if (virtio_queue_get_desc_addr(vdev, idx) =3D=3D 0) {
>          /* Don't stop the virtqueue which might have not been started */
>          return;
>      }
>
> -    r =3D dev->vhost_ops->vhost_get_vring_base(dev, &state);
> -    if (r < 0) {
> -        VHOST_OPS_DEBUG("vhost VQ %u ring restore failed: %d", idx, r);
> -        /* Connection to the backend is broken, so let's sync internal
> +    if (!dev->sw_lm_enabled) {
> +        r =3D dev->vhost_ops->vhost_get_vring_base(dev, &state);
> +        if (r < 0) {
> +            VHOST_OPS_DEBUG("vhost VQ %u ring restore failed: %d", idx, =
r);
> +        }
> +    }
> +
> +    if (!dev->sw_lm_enabled || r < 0) {

This test should actually test for `dev->sw_lm_enabled`, not for negation.

> +        /* Connection to the backend is unusable, so let's sync internal
>           * last avail idx to the device used idx.
>           */
>          virtio_queue_restore_last_avail_idx(vdev, idx);
> --
> 2.18.4
>

