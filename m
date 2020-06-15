Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689A31F9683
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgFOM2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:28:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47811 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728510AbgFOM2w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 08:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592224131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBg2fZ9D+qAlMaoxpCp/kIBmDKmXPzYejbkMJfk/U3o=;
        b=VDrzMEDwLOtyAWqQWrS17//007u7j3g3Sd/GsLSiev9YNATRdYt7CvC0/kxBRf5aM5DEuO
        m2UltlH55cqSdJ74XyweY3E8hhxcE7GmUoXL4IncspxvF/2VzUPzkUiiy1K38Q4dIArSWf
        Htz0rChb+wGM4ZPe8YBdoLAuwr21k6A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-_3YLY8RkNZicpjJB6lEDrA-1; Mon, 15 Jun 2020 08:28:39 -0400
X-MC-Unique: _3YLY8RkNZicpjJB6lEDrA-1
Received: by mail-qt1-f198.google.com with SMTP id y7so13833803qti.8
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBg2fZ9D+qAlMaoxpCp/kIBmDKmXPzYejbkMJfk/U3o=;
        b=E7L8F8EtvYb7/F9kNCdplEXl1bU1hFtbiZoY0SqGxia5CyedfCfKZ2ChymL7riI2Yw
         IKzTzUbA73MzeOFY4AOPaNVQXov8DOITSdV+CMi/yTdFV+Z8W0JAYtYzCePC/T1OF0nz
         +Ao2VWNU2UHn3MowUC6SrwCmjKU0gBbtvpec0Ta+5nziDAsJXdfNlEeED4VXY2LxoWgo
         /Mfpq3FaEZHcbZ+A7e6Sm59E170vFGXYaV3zRgmSb/8x48MIEQDaxOppgF0A49TenUcn
         1VcXDi7/FoN5OaFDsAWmCS5v/s7E05P+jjNKexD+UtxLkemoLUWRsKB6gVUTIVIhuVZu
         PEtA==
X-Gm-Message-State: AOAM532FAdsOS7JVJuvB8jhz4wPQdQsfkWN1gI0/LL3cc4hK+e46agsN
        BAXSvbGpIxNDEcrbWLSNriVfH78w7jeH7L7Wa2itc/JwiEPoBXD7ivXJarzpbGGYhrSyBN3IHrA
        goj6wkFbE5wTJwdAY2EIkj2zou+Ho
X-Received: by 2002:a05:620a:1407:: with SMTP id d7mr14076424qkj.89.1592224119511;
        Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMGtIFdrgid15Y38ee12F5MvFgWU29hVuUe2nr/sf233yxjKvAmpE8PkTLK0uLOi4+pmRt8SvQU4mlzAKXbyY=
X-Received: by 2002:a05:620a:1407:: with SMTP id d7mr14076410qkj.89.1592224119276;
 Mon, 15 Jun 2020 05:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <20200611152257.GA1798@char.us.oracle.com>
In-Reply-To: <20200611152257.GA1798@char.us.oracle.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 14:28:03 +0200
Message-ID: <CAJaqyWdwXMX0JGhmz6soH2ZLNdaH6HEdpBM8ozZzX9WUu8jGoQ@mail.gmail.com>
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

On Thu, Jun 11, 2020 at 5:22 PM Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> > As testing shows no performance change, switch to that now.
>
> What kind of testing? 100GiB? Low latency?
>

Hi Konrad.

I tested this version of the patch:
https://lkml.org/lkml/2019/10/13/42

It was tested for throughput with DPDK's testpmd (as described in
http://doc.dpdk.org/guides/howto/virtio_user_as_exceptional_path.html)
and kernel pktgen. No latency tests were performed by me. Maybe it is
interesting to perform a latency test or just a different set of tests
over a recent version.

Thanks!

