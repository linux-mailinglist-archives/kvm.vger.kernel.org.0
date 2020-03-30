Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3C197578
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 09:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgC3HTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 03:19:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46733 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729372AbgC3HTF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 03:19:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585552743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ndOQsprsy0rDZ1akOpvUvMPB3GOXP8NxcpZODWJ/64=;
        b=XWCsIlO5Bok4cU4ZOHIqRXuLejgYFtWhZMTt7Db/ZP3gYcB4+4Jm4XJGCaUz1ZTQYBWQTn
        D2OYSxfm6TZ2icskWpew2K553pvCx0GB1YOGieNVpMOvd3gOAeXudMr3gmDAa9OjjpjJSR
        Lr7cjyLemll+8g3ik6OzgxfWkRQfSns=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-pZO2A_ZqP6-otvSLmyMj2A-1; Mon, 30 Mar 2020 03:18:59 -0400
X-MC-Unique: pZO2A_ZqP6-otvSLmyMj2A-1
Received: by mail-qt1-f198.google.com with SMTP id i36so14220100qtd.9
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 00:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ndOQsprsy0rDZ1akOpvUvMPB3GOXP8NxcpZODWJ/64=;
        b=SEi83/JRb4gt6CeCrheVFo9DxsPE2X3HfMApLjE3DdcHP5hmIW53B+pnzga8BKDUs/
         +S1EgNRgy8A4iGKTTfu46gvXfUpW590EOS1erkXXRnNtV4c/cEiceh5bhRgwWzscyvXr
         U8/RigNI/v+V09vjyFO7YnHlHK1pu5SHfS7c44T84teQq9jzjA5nAkeLOyQ1Xpr+iQ75
         IrwMoBApQlpEw/TeSSJKjhNik34I6k3O/NiYDh1Of6pPrby5QuQVyFC/NKEKZwR0F7eZ
         3TKjMQxWs4SPfUw4rEOxMumm9DjzrRxh63BoyYDnSWm8j/ULKrrvuiY9lmGss5fEfscJ
         Q1aA==
X-Gm-Message-State: ANhLgQ2S2oo/rfjXjKP3TtrqMwGlbdWHv1zoqekXORXlctGlu+KeBX3C
        QmOYLWhDYHTjfxid8muNLkHTBpxp7YVGhvjAAv7f4XQNdAIqksbqeeu5p1HDY3sTfo7BKCI8ybZ
        bwo1Ksi3qlC8nLnLUwxhVRxTqaRjR
X-Received: by 2002:ac8:740b:: with SMTP id p11mr4272140qtq.379.1585552739244;
        Mon, 30 Mar 2020 00:18:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vthgONhLcNuIaHQCwo4a9iIoIcpLwlFSG4sBnK8dC+inDlYKb1GHGPlwu8yPOeO0Fm0D3Ijy5om00tWQk8V4TE=
X-Received: by 2002:ac8:740b:: with SMTP id p11mr4272127qtq.379.1585552738977;
 Mon, 30 Mar 2020 00:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200329113359.30960-1-eperezma@redhat.com> <bb95e827-f219-32fd-0046-41046eec058b@de.ibm.com>
In-Reply-To: <bb95e827-f219-32fd-0046-41046eec058b@de.ibm.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 30 Mar 2020 09:18:22 +0200
Message-ID: <CAJaqyWePfMcXhYEPxKYV22J3cYtO=DUXCj1Yf=7XH+khXHop9A@mail.gmail.com>
Subject: Re: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE call
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 9:14 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
> On 29.03.20 13:33, Eugenio P=C3=A9rez wrote:
> > Vhost did not reset properly the batched descriptors on SET_VRING_BASE =
event. Because of that, is possible to return an invalid descriptor to the =
guest.
>
> I guess this could explain my problems that I have seen during reset?
>

Yes, I think so. The series has a test that should reproduce more or
less what you are seeing. However, it would be useful to reproduce on
your system and to know what causes qemu to send the reset :).

Thanks!

> >
> > This series ammend this, and creates a test to assert correct behavior.=
 To do that, they need to expose a new function in virtio_ring, virtqueue_r=
eset_free_head. Not sure if this can be avoided.
> >
> > Also, change from https://lkml.org/lkml/2020/3/27/108 is not included, =
that avoids to update a variable in a loop where it can be updated once.
> >
> > This is meant to be applied on top of eccb852f1fe6bede630e2e4f1a121a81e=
34354ab in git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git, and some =
commits should be squashed with that series.
> >
> > Eugenio P=C3=A9rez (6):
> >   tools/virtio: Add --batch option
> >   tools/virtio: Add --batch=3Drandom option
> >   tools/virtio: Add --reset=3Drandom
> >   tools/virtio: Make --reset reset ring idx
> >   vhost: Delete virtqueue batch_descs member
> >   fixup! vhost: batching fetches
> >
> >  drivers/vhost/test.c         |  57 ++++++++++++++++
> >  drivers/vhost/test.h         |   1 +
> >  drivers/vhost/vhost.c        |  12 +++-
> >  drivers/vhost/vhost.h        |   1 -
> >  drivers/virtio/virtio_ring.c |  18 +++++
> >  include/linux/virtio.h       |   2 +
> >  tools/virtio/linux/virtio.h  |   2 +
> >  tools/virtio/virtio_test.c   | 123 +++++++++++++++++++++++++++++++----
> >  8 files changed, 201 insertions(+), 15 deletions(-)
> >
>

