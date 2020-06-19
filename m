Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDC12019F7
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbgFSSIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:08:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38264 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387423AbgFSSIk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 14:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592590119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M1kqnSC0TnwwjU9pqdl+Jl6MnsvVIxbg1NKgAjCQLQk=;
        b=cl1+652e+fWCtGoesj6yht07XsNuGao/aRLVpVL6aYALBdFfI2CtzuMyey99gio5cwLa4A
        sj984r2RhF0u20QEphNqsM7xwo6pKjNhqxxrRdHqfj6/ilQswT2hXx1aycFGVmIx0Gdn4m
        eevFSxmtm36zvY0BFfoaqZqCvbgP8kc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-UBY8T7zGPx-dN1FeCX2Llg-1; Fri, 19 Jun 2020 14:08:34 -0400
X-MC-Unique: UBY8T7zGPx-dN1FeCX2Llg-1
Received: by mail-qv1-f71.google.com with SMTP id ca16so1465237qvb.17
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 11:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1kqnSC0TnwwjU9pqdl+Jl6MnsvVIxbg1NKgAjCQLQk=;
        b=q7Gfb1f/yuMSVT9UwSQ0Jy6mszmSFGTRaC9YFhxleDWc4bpPCJ7yk49bRkgrR4f2Nc
         xZlL44yn54h4q0kEZeNaiMahdxPhhIsytPM45zy/t+MEvwIdfS8GKwRO8Eq/sQVRPEhq
         fOUFdk2krmLqk4LkfetN/UhgSTpGSBUACEyTpLuBYUOnZpWLhpxtzfRY4MNiY0oNjLb3
         gGCEzYC/uBjmEve1OQC2NYoJM5grUJ2baRdMSPE4++0ZNIiuY9ahch1kZloxULwfs7fM
         t1JYdA7yPDL1i3bI0bRCfW5noMcF+fnNEKhuK9OYr4/DjGlPV/GMGNSv6lx+/N8azrH5
         5nVw==
X-Gm-Message-State: AOAM533a/tOPoQ77iZcYN/f2fSg6zbrFihFLiLfEqiCt8/D8m+zgJvEj
        8wex9uOSh6EKkJPSz7xCANwa5zvNMvW3GxZTuDimpmsEtOqocRd71miKkgk8hv6mK/tko39jt0u
        P2br09cmcXUqNvhd7gHvrhpdSDkIL
X-Received: by 2002:aed:2171:: with SMTP id 104mr2269427qtc.22.1592590114098;
        Fri, 19 Jun 2020 11:08:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxb3LLfD5Gk7BoQBiwyBzy1qquwOQYCpCWEpfsWGm3cQ1kfZddE50/+gf0EU9STwwFtmiZcEeywa03jj7Vwsy0=
X-Received: by 2002:aed:2171:: with SMTP id 104mr2269401qtc.22.1592590113830;
 Fri, 19 Jun 2020 11:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com> <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
In-Reply-To: <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 19 Jun 2020 20:07:57 +0200
Message-ID: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 2:28 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > > As testing shows no performance change, switch to that now.
> >
> > What kind of testing? 100GiB? Low latency?
> >
>
> Hi Konrad.
>
> I tested this version of the patch:
> https://lkml.org/lkml/2019/10/13/42
>
> It was tested for throughput with DPDK's testpmd (as described in
> http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
> and kernel pktgen. No latency tests were performed by me. Maybe it is
> interesting to perform a latency test or just a different set of tests
> over a recent version.
>
> Thanks!

I have repeated the tests with v9, and results are a little bit different:
* If I test opening it with testpmd, I see no change between versions
* If I forward packets between two vhost-net interfaces in the guest
using a linux bridge in the host:
  - netperf UDP_STREAM shows a performance increase of 1.8, almost
doubling performance. This gets lower as frame size increase.
  - rests of the test goes noticeably worse: UDP_RR goes from ~6347
transactions/sec to 5830
  - TCP_STREAM goes from ~10.7 gbps to ~7Gbps
  - TCP_RR from 6223.64 transactions/sec to 5739.44

