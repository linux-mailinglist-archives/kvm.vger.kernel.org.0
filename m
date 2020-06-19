Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11612019DB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436488AbgFSR46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 13:56:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38320 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404674AbgFSR4p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 13:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592589402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcqrPcvDJb0ExZL7Rd/avo/FZMjKRYWp5ZMPjnD5nIw=;
        b=Fdphpq2kCXX0NpeRFZlLy4pU4p8G4VSh4vGP0L7rqE8CdT8R9r6Bki5YD4iQbRwMqFnreO
        UGr/3u/7vvoEU5dSJhG+EH1yNOgEmHH3qpRxECqFyEWQTcm5fUA49qZ64UpmNXlSs3Qo+y
        QgS3uhgSVOUw88gjBWGWDWBfM3Jebq0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-xy4SwcoePsOWqwJVFv9HhQ-1; Fri, 19 Jun 2020 13:56:41 -0400
X-MC-Unique: xy4SwcoePsOWqwJVFv9HhQ-1
Received: by mail-qk1-f197.google.com with SMTP id 205so7834866qkh.5
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 10:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WcqrPcvDJb0ExZL7Rd/avo/FZMjKRYWp5ZMPjnD5nIw=;
        b=nrrpUs7Tw/3uLwG0KRL92QARIJzI/9jWi/wwBDCa1dOi1+apVdJ5TPhju0jCsU3vyn
         Y554wR9jfs+9m4lJREMRgpwaW2kiCUNM1yY3qLEq0vPnWCqBZqDU3Yv7yUJAe5ligaX+
         yeSrdOcvx9zQVkHvaFBqY9lIgsML61sRTZ3tn6h8dxHeK3ga5HkefkSuEVqHvaWpQmGA
         IAQ2O8jqv1k4F94WVkayvLzv0ej/9oQH35RowI8VF8DC+wo/NxsIUZG9IOJucn/mbZlU
         gwyQfsJl8sUXEAuJD7HZcRBfw+64noEcZGdZGcBpKPVCBmo3DfO2vVG5nXeNexOSr+/H
         zE0g==
X-Gm-Message-State: AOAM533mAvreT8YcgIGVkAfIUsn1mrr7fs3xGBf+aYlH6/06aMib+jSs
        aeAfUAW2TcHgp3vhf2SHHcR74mtOlZViW6ZSQY6QCjszhnsgHBJ1iP5VJCsCWJlMxCLCBbLQgkm
        oHdrZ79jbFXYgH0gl5S2l15C6iTeg
X-Received: by 2002:a37:64c6:: with SMTP id y189mr4793909qkb.353.1592589400890;
        Fri, 19 Jun 2020 10:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxts4JUG/DUZlXwHieuKsAsn4bVIZKK4d+Lvr6aZFXHNaYrdVkmy8Kqr7GNRfSCb53+bLew1eRqhZdN3cQW/5s=
X-Received: by 2002:a37:64c6:: with SMTP id y189mr4793881qkb.353.1592589400629;
 Fri, 19 Jun 2020 10:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
In-Reply-To: <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 19 Jun 2020 19:56:04 +0200
Message-ID: <CAJaqyWcDb5GefbiBkcaMADFzWup7yvmvOekRmRQ40pqxdgB0eg@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 5:19 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/6/11 =E4=B8=8B=E5=8D=887:34, Michael S. Tsirkin wrote:
> >   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >   {
> >       kfree(vq->descs);
> > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev=
 *dev)
> >       for (i =3D 0; i < dev->nvqs; ++i) {
> >               vq =3D dev->vqs[i];
> >               vq->max_descs =3D dev->iov_limit;
> > +             if (vhost_vq_num_batch_descs(vq) < 0) {
> > +                     return -EINVAL;
> > +             }
>
>
> This check breaks vdpa which set iov_limit to zero. Consider iov_limit
> is meaningless to vDPA, I wonder we can skip the test when device
> doesn't use worker.

I tested as

if (dev->use_worker && vhost_vq_num_batch_descs(vq) < 0)

In v9. Please let me know if that is ok for you.

Thanks!

>
> Thanks
>

