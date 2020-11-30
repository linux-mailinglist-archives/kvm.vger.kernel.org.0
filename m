Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060E12C7F5E
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 08:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgK3H4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 02:56:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbgK3H4X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 02:56:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606722896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cfYEN4na3C3FMqwMo6LNjQ8k4ZCO0qa7qNB5nkxkM6o=;
        b=XEl7iqI3DAeA8AKUnM4dGpQ+oBDQzvSUExnupTNieRh/8JSJhihdjqSnEZkmOzYsPdOiPf
        tN2IG2w04FGFNJ8eGeMDYbfZFWQfbpqZDVOBsWkSA9fUuth0uyWI7kCAShDXqE4k4K7xZa
        5MFex9szYZ6VUJLKUOLgkLgaKrjvlAw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-jzcMcfbPMjO3P68tJ2E7NQ-1; Mon, 30 Nov 2020 02:54:54 -0500
X-MC-Unique: jzcMcfbPMjO3P68tJ2E7NQ-1
Received: by mail-qk1-f197.google.com with SMTP id 202so8997864qkl.9
        for <kvm@vger.kernel.org>; Sun, 29 Nov 2020 23:54:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cfYEN4na3C3FMqwMo6LNjQ8k4ZCO0qa7qNB5nkxkM6o=;
        b=IQ5KuhLDbhdE4ynKsfO4qkRcf5teadKiyW6276errdnkEhp+5zMy+RmrZqZqANXvRo
         oI4PqN2vF0H9Dr4v5mBoDIQwi7YCk/PwujYFfbeOnj//ejI8/dzv9QFeEJ+F5S/39cXu
         g/L5zpVe0y4wWZD6Tq8Csgol1vYnoJkXQxWN7YU62XTc2ATG6RGmSk8DjtxbI2etnEkI
         1ErkIiMJa6POY3KWqFh9JNxYEcViqRgb+UleFZOuPr2gzpzxZvT2laGZD7HBbCuLcmt0
         guIcjU2TRdTUu1j06EdynFYqJusZjspLv+whJlfiPJ9/z5OhmlxezLbjHI3RDLGzTRuV
         A3zg==
X-Gm-Message-State: AOAM533SQ2nmDYLXHrBZEGzof6n5fwY1esIos0h++mjIdVDU7jlqPVP6
        9sV82VeVVsLVNRO0MohHfR1F3SHIwTuhxqxsMd6JNSReoEOQNJcAHSga/TjonLsmukQsKs0F3g/
        i/L1M1CTS66gN5jo2OdekLt1sDRZh
X-Received: by 2002:a05:620a:132d:: with SMTP id p13mr21768019qkj.233.1606722894178;
        Sun, 29 Nov 2020 23:54:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuzkTzTp2p3vGrFooseaaNhC8uI+tyCQrxfu6y0WFvPSKipLD0ddM5+y6Pgg0Pf6Qwpznddv7mfYMwakFsfAA=
X-Received: by 2002:a05:620a:132d:: with SMTP id p13mr21768001qkj.233.1606722893979;
 Sun, 29 Nov 2020 23:54:53 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-24-eperezma@redhat.com>
 <20201127152901.cbfu7rmewbxventr@steredhat>
In-Reply-To: <20201127152901.cbfu7rmewbxventr@steredhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 30 Nov 2020 08:54:18 +0100
Message-ID: <CAJaqyWe+u+ZPSeMr7ZLHYGbqRhH=YZxE8zrMamTQFxrSLgb3sA@mail.gmail.com>
Subject: Re: [RFC PATCH 23/27] vhost: unmap qemu's shadow virtqueues on sw
 live migration
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
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

On Fri, Nov 27, 2020 at 4:29 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Fri, Nov 20, 2020 at 07:51:01PM +0100, Eugenio P=C3=83=C2=A9rez wrote:
> >Since vhost does not need to access it, it has no sense to keep it
> >mapped.
> >
> >Signed-off-by: Eugenio P=C3=83=C2=A9rez <eperezma@redhat.com>
> >---
> > hw/virtio/vhost.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> >index f640d4edf0..eebfac4455 100644
> >--- a/hw/virtio/vhost.c
> >+++ b/hw/virtio/vhost.c
> >@@ -1124,6 +1124,7 @@ static int vhost_sw_live_migration_start(struct vh=
ost_dev *dev)
> >
> >         dev->sw_lm_shadow_vq[idx] =3D vhost_sw_lm_shadow_vq(dev, idx);
> >         event_notifier_set_handler(&vq->masked_notifier, vhost_handle_c=
all);
> >+        vhost_virtqueue_memory_unmap(dev, &dev->vqs[idx], true);
>
> IIUC vhost_virtqueue_memory_unmap() is already called at the end of
> vhost_virtqueue_stop(), so we can skip this call, right?
>

You are totally right Stefano, thanks for the catch!

> >
> >         vhost_vring_write_addr(dev->sw_lm_shadow_vq[idx], &addr);
> >         r =3D dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
> >-- 2.18.4
> >
>

