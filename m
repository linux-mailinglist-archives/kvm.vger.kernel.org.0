Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3D7203B9C
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgFVPzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:55:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726328AbgFVPzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 11:55:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592841319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5/TWvdWyq1xUujhnrnIglEliiwBVOZjUqDPRZt1W7a0=;
        b=a8fi1rj7ogFYjXEZz1ABCZsBtua+MvdRRg5aqdvhQ6zj71wk3DXTiWqhufoGBdqUJimm2I
        QGOzhlwpb2tJY82Goyzi8IcUnF8u4OTO0AqSEjHWbPvk2szn/x4EpBjM1KkEQk06ggxeJB
        z6l/Gr6p5/hNQAVQuz5He7bCcW7heHw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-2tTDEFS9MtuUOLlduZF_VA-1; Mon, 22 Jun 2020 11:55:10 -0400
X-MC-Unique: 2tTDEFS9MtuUOLlduZF_VA-1
Received: by mail-wm1-f69.google.com with SMTP id e15so19919wme.8
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 08:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5/TWvdWyq1xUujhnrnIglEliiwBVOZjUqDPRZt1W7a0=;
        b=X+P10sUv8Us2VVIRk6TGsyuc7Ziu+3WdzUiVPoVgNpxzxL8FirLZze1+7iLlDb1LT3
         KMp1TJvHZ5s5MePCaFFMWJlajoU1+ak83E2LvqPSreQz8vmDtQkey7QmkR2OdtvTl9n6
         KzDwgnB4vNSrDV2jIStNd8fR/28BAbEJ40mwgQLD1SjVZ7JG1bTFaJEqMbAxuN/+xV+D
         ZXognqrsLgq4L4vWzNnnzmex8XNU6j3bA8mtbJmCIAr3OUZZDfKPnI3iD16rh1mYDRGx
         +3UUgDLH7e8fer4RaPXWDwmbO53zne0nZI5z1JKHfgBp0N6ZG0oJMmz51SLyq+Es6wVt
         L5og==
X-Gm-Message-State: AOAM530zFoMqMuk8MhHCwCanMWwVlY5iu3mnLwLmq3VtX4PFwHsl0ndg
        wph0I9gKnZi5ZE/3aDZcHshq9jrpK86zKqiRicFCMplOXYrCIx1k+L5MXXeP00+v4DtUvH+XLmt
        BDnnLGbdjYFf/
X-Received: by 2002:adf:81c8:: with SMTP id 66mr15414795wra.348.1592841308601;
        Mon, 22 Jun 2020 08:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDqUXaq8ZLWjDVbqp55FyjxeMofHg+9iAPblS6Tpzqu1HcZ9tDlKdMVd5PLYKsZyiUVy0W0Q==
X-Received: by 2002:adf:81c8:: with SMTP id 66mr15414773wra.348.1592841308364;
        Mon, 22 Jun 2020 08:55:08 -0700 (PDT)
Received: from redhat.com (bzq-79-178-18-124.red.bezeqint.net. [79.178.18.124])
        by smtp.gmail.com with ESMTPSA id d201sm5593758wmd.34.2020.06.22.08.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 08:55:07 -0700 (PDT)
Date:   Mon, 22 Jun 2020 11:55:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200622114622-mutt-send-email-mst@kernel.org>
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com>
 <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
 <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 08:07:57PM +0200, Eugenio Perez Martin wrote:
> On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > >
> > > On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > > > As testing shows no performance change, switch to that now.
> > >
> > > What kind of testing? 100GiB? Low latency?
> > >
> >
> > Hi Konrad.
> >
> > I tested this version of the patch:
> > https://lkml.org/lkml/2019/10/13/42
> >
> > It was tested for throughput with DPDK's testpmd (as described in
> > http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> > and kernel pktgen. No latency tests were performed by me. Maybe it is
> > interesting to perform a latency test or just a different set of tests
> > over a recent version.
> >
> > Thanks!
> 
> I have repeated the tests with v9, and results are a little bit different:
> * If I test opening it with testpmd, I see no change between versions


OK that is testpmd on guest, right? And vhost-net on the host?

> * If I forward packets between two vhost-net interfaces in the guest
> using a linux bridge in the host:

And here I guess you mean virtio-net in the guest kernel?

>   - netperf UDP_STREAM shows a performance increase of 1.8, almost
> doubling performance. This gets lower as frame size increase.
>   - rests of the test goes noticeably worse: UDP_RR goes from ~6347
> transactions/sec to 5830

OK so it seems plausible that we still have a bug where an interrupt
is delayed. That is the main difference between pmd and virtio.
Let's try disabling event index, and see what happens - that's
the trickiest part of interrupts.



>   - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
>   - TCP_RR from 6223.64 transactions/sec to 5739.44

