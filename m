Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE07D5272
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfJLUhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 16:37:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbfJLUhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 16:37:01 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 587D010B78
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 20:37:01 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id c6so2804wrp.3
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 13:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nsuG9DynP4h5A9hJiRAHv7ZghRiHq0bUTGCGrIQlgl4=;
        b=OgC02QgrD0ga/LF6VYO3E82AKYWQkE/WF0D3BSpg4BrhD/BOm3mk2VRtQeFl182eKQ
         xPbuJHdvpkpFicmRU7EnfIyMMk7E+tyfzZ7JsnG50KRuQDJzO41DK6/NXbuhk67UF8Lh
         aY5HfkNp8xlqHE2vMurwkKgpwaRex2JNFZSzG2FMcD4BYq/UQfph2Ubcc8TTQf8ofSo/
         ZY1IaOO9VT4SISJi2613llUuTGA8M2AxMbgKXyyJP11Lda0SuzNecQtlKdZh+XJOftsi
         jh1gGhNhL7SeB+O3TVPDp9vRpYcyy5pxNIUblaxmHsQY5KGHkb9p4XNh48dGkK95s/2s
         DK0A==
X-Gm-Message-State: APjAAAW2vRPAIq3tdrzI8YzG9zIEDz/RKtl3IfD/J2cJYnfNw/Ihw2mj
        GgY5ewyjy7c+gBKJZdFG9BfLiH0nvUwx/ZoTkdiwXf9SgjrfLl5/EfotYp69tAcJ0rNCE5CLYmo
        plGtR3Pv+4qXx
X-Received: by 2002:a5d:6709:: with SMTP id o9mr18541561wru.116.1570912620054;
        Sat, 12 Oct 2019 13:37:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8AwCsOKbqErxze+dj/LkUtWRGrZpyJTxNw8vodxFVLNH1FPTXAO2PjutYGomFF101n5ZJLw==
X-Received: by 2002:a5d:6709:: with SMTP id o9mr18541555wru.116.1570912619857;
        Sat, 12 Oct 2019 13:36:59 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id d78sm17957635wmd.47.2019.10.12.13.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 13:36:59 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:36:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/2] vhost: ring format independence
Message-ID: <20191012163635-mutt-send-email-mst@kernel.org>
References: <20191011134358.16912-1-mst@redhat.com>
 <b24b3c9e-3a5d-fa5e-8218-ea7def0e5a39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b24b3c9e-3a5d-fa5e-8218-ea7def0e5a39@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 12, 2019 at 03:31:50PM +0800, Jason Wang wrote:
> 
> On 2019/10/11 下午9:45, Michael S. Tsirkin wrote:
> > So the idea is as follows: we convert descriptors to an
> > independent format first, and process that converting to
> > iov later.
> > 
> > The point is that we have a tight loop that fetches
> > descriptors, which is good for cache utilization.
> > This will also allow all kind of batching tricks -
> > e.g. it seems possible to keep SMAP disabled while
> > we are fetching multiple descriptors.
> > 
> > And perhaps more importantly, this is a very good fit for the packed
> > ring layout, where we get and put descriptors in order.
> > 
> > This patchset seems to already perform exactly the same as the original
> > code already based on a microbenchmark.  More testing would be very much
> > appreciated.
> > 
> > Biggest TODO before this first step is ready to go in is to
> > batch indirect descriptors as well.
> > 
> > Integrating into vhost-net is basically
> > s/vhost_get_vq_desc/vhost_get_vq_desc_batch/ -
> > or add a module parameter like I did in the test module.
> 
> 
> It would be better to convert vhost_net then I can do some benchmark on
> that.
> 
> Thanks

Sure, I post a small patch that does this.

> 
> > 
> > 
> > 
> > Michael S. Tsirkin (2):
> >    vhost: option to fetch descriptors through an independent struct
> >    vhost: batching fetches
> > 
> >   drivers/vhost/test.c  |  19 ++-
> >   drivers/vhost/vhost.c | 333 +++++++++++++++++++++++++++++++++++++++++-
> >   drivers/vhost/vhost.h |  20 ++-
> >   3 files changed, 365 insertions(+), 7 deletions(-)
> > 
