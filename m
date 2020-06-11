Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9BF1F66A7
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgFKLaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:30:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727891AbgFKLaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 07:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/jl7PRjuNx/C+pUMDHawKvKRMB5jFyju67YAOMh5Vw=;
        b=PhQI0XuUIWtM87GLLu18qwHtIsV/lTNzKWJIPvLgEb5oAQv04QvjAQOm+dxo1LQ2nbbqpU
        ET9n2jbMEoUGbj/DdluGeXNpkyfkdNzNMnEQQGaK+94Eh5AiYypxmBJKc0MGncrUf2IYpT
        Ndrju12NbYFlJZZLWa2WQggj0q03E10=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-dmuHQcc4PBqVUA_EN5jkhA-1; Thu, 11 Jun 2020 07:30:19 -0400
X-MC-Unique: dmuHQcc4PBqVUA_EN5jkhA-1
Received: by mail-wm1-f70.google.com with SMTP id x6so1230180wmj.9
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9/jl7PRjuNx/C+pUMDHawKvKRMB5jFyju67YAOMh5Vw=;
        b=rZwmKCU7I7GRP2ipgZ/g8enZ1Fc+n2LPm1l9Qm6PTrYwJfZmoaKx4kp0G+RqmeeCS8
         x3k7tuA51bxQWhQH6WdvODuEl7tw+DAG08kstT1ssjnPA+x6XrQWDmTEqindeOpErjoC
         Xa41XDQF4tuEu23M6hBoEYvQT7ugSCLemEzys8bkSd1AzoOEEG6SLOSSIyO6Z6rB3SHX
         R/UUy10NteNDnvssvvuyMVQ0mdZYRu5aOeehT/5S1CvWDycMEN5FUnoaP5oXRMq56uZ2
         kKCZ+UC+GK0omyW+xquzeEYbreNcGDrWWU8jWZ2jZGQGlKlsW0zCtfdtgFGm7QEJGaV0
         UbRw==
X-Gm-Message-State: AOAM531ABW+gzxkPENV4Da9yg5aJmKdQdvSI+kBpzhPvWT4c3jDL11ck
        jnWXBTtM61Nxzr6EzbB0j70EHu/5UUpb1UDlrdTKQYvXdT5/MvBB3+9SFETGfzCY+eR3HAGwZYf
        1PuCzT9y987BI
X-Received: by 2002:a1c:3b8b:: with SMTP id i133mr7709143wma.111.1591875017438;
        Thu, 11 Jun 2020 04:30:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzJ6v/QkioaQycgPSzfq+keXBu76wlWx/mu62TPOFBjqUGGd1L5f5cXkoDx4uk2vFtzgVdWQ==
X-Received: by 2002:a1c:3b8b:: with SMTP id i133mr7709124wma.111.1591875017186;
        Thu, 11 Jun 2020 04:30:17 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id b81sm4055054wmc.5.2020.06.11.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:30:16 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:30:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
Message-ID: <20200611072702-mutt-send-email-mst@kernel.org>
References: <20200610113515.1497099-1-mst@redhat.com>
 <20200610113515.1497099-4-mst@redhat.com>
 <CAJaqyWdGKh5gSTndGuVPyJSgt3jfjfW4xNCrJ2tQ9f+mD8=sMQ@mail.gmail.com>
 <20200610111147-mutt-send-email-mst@kernel.org>
 <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWe6d19hFAbpqaQqOPuQQmBQyevyF4sTVkaXKhD729XDkw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 06:18:32PM +0200, Eugenio Perez Martin wrote:
> On Wed, Jun 10, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 10, 2020 at 02:37:50PM +0200, Eugenio Perez Martin wrote:
> > > > +/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> > > > + * A negative code is returned on error. */
> > > > +static int fetch_descs(struct vhost_virtqueue *vq)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       if (unlikely(vq->first_desc >= vq->ndescs)) {
> > > > +               vq->first_desc = 0;
> > > > +               vq->ndescs = 0;
> > > > +       }
> > > > +
> > > > +       if (vq->ndescs)
> > > > +               return 1;
> > > > +
> > > > +       for (ret = 1;
> > > > +            ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
> > > > +            ret = fetch_buf(vq))
> > > > +               ;
> > >
> > > (Expanding comment in V6):
> > >
> > > We get an infinite loop this way:
> > > * vq->ndescs == 0, so we call fetch_buf() here
> > > * fetch_buf gets less than vhost_vq_num_batch_descs(vq); descriptors. ret = 1
> > > * This loop calls again fetch_buf, but vq->ndescs > 0 (and avail_vq ==
> > > last_avail_vq), so it just return 1
> >
> > That's what
> >          [PATCH RFC v7 08/14] fixup! vhost: use batched get_vq_desc version
> > is supposed to fix.
> >
> 
> Sorry, I forgot to include that fixup.
> 
> With it I don't see CPU stalls, but with that version latency has
> increased a lot and I see packet lost:
> + ping -c 5 10.200.0.1
> PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> >From 10.200.0.2 icmp_seq=1 Destination Host Unreachable
> >From 10.200.0.2 icmp_seq=2 Destination Host Unreachable
> >From 10.200.0.2 icmp_seq=3 Destination Host Unreachable
> 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=6848 ms
> 
> --- 10.200.0.1 ping statistics ---
> 5 packets transmitted, 1 received, +3 errors, 80% packet loss, time 76ms
> rtt min/avg/max/mdev = 6848.316/6848.316/6848.316/0.000 ms, pipe 4
> --
> 
> I cannot even use netperf.

OK so that's the bug to try to find and fix I think.


> If I modify with my proposed version:
> + ping -c 5 10.200.0.1
> PING 10.200.0.1 (10.200.0.1) 56(84) bytes of data.
> 64 bytes from 10.200.0.1: icmp_seq=1 ttl=64 time=7.07 ms
> 64 bytes from 10.200.0.1: icmp_seq=2 ttl=64 time=0.358 ms
> 64 bytes from 10.200.0.1: icmp_seq=3 ttl=64 time=5.35 ms
> 64 bytes from 10.200.0.1: icmp_seq=4 ttl=64 time=2.27 ms
> 64 bytes from 10.200.0.1: icmp_seq=5 ttl=64 time=0.426 ms


Not sure which version this is.

> [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.200.0.1 () port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 131072  16384  16384    10.01    4742.36
> [root@localhost ~]# netperf -H 10.200.0.1 -p 12865 -l 10 -t UDP_STREAM
> MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
> 10.200.0.1 () port 0 AF_INET
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
> 212992   65507   10.00        9214      0     482.83
> 212992           10.00        9214            482.83
> 
> I will compare with the non-batch version for reference, but the
> difference between the two is noticeable. Maybe it's worth finding a
> good value for the if() inside fetch_buf?
> 
> Thanks!
> 

I don't think it's performance, I think it's a bug somewhere,
e.g. maybe we corrupt a packet, or stall the queue, or
something like this.

Let's do this, I will squash the fixups and post v8 so you can bisect
and then debug cleanly.

> > --
> > MST
> >

