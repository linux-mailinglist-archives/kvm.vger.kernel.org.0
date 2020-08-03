Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B971C23AE60
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 22:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgHCUrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 16:47:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38448 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgHCUrE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 16:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596487622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YWSXpH5LufLhcUK5++dpDgIe+PU/a2RiJP9vO4xSyb8=;
        b=IXch8zKfr1HMFS+ToTrnJQ6JGtKpZahN7oe/bHcBKOfOwzskNfEYCmWm+JYA65MqVD9kSN
        vF6Eey6lhgLOjZXBCH0z3EWBKUWIW7Y9VqbkAAPuZIbCZ9S1fPXu+fmEsntknU9VTTr6FS
        rjtxjZ5GbYxOvK1TA0B/XArNwLbk4cw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-8LqHgqaPO5iK6ol-hRFQgg-1; Mon, 03 Aug 2020 16:46:58 -0400
X-MC-Unique: 8LqHgqaPO5iK6ol-hRFQgg-1
Received: by mail-qt1-f199.google.com with SMTP id f59so14516646qtb.22
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 13:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YWSXpH5LufLhcUK5++dpDgIe+PU/a2RiJP9vO4xSyb8=;
        b=gLV5VgBXgoGXawzrtdBOGb6SOTj/belhw9fxFDkDLbzYPGa/72fOeGSymtVNdeWCc2
         1dDAc3MlH1oIs9jBW38r0dZ+ngurKCCIX/dW/V5DQAsrlLahY3rz7EVH3PK892wGK0Rr
         QvtVV+76dBy7e+29tWReER3AXlRupceDJvGqkK0+U1bWpRWH4J9zO339uch5Z7iPs134
         G4lvy/JUTPmlcE5o9M0GXcFcYKqyPnSmTUa5zCQfIhfqn4Odc6ngU1B8YKRkGoCSuwoh
         l0tiZOAvsGrZK678RF5cbiXEp/PPE229kBJshqP/fa6USGxsx93w82mtfioq7ptsUdyE
         I78Q==
X-Gm-Message-State: AOAM533zhdPb6FsQibvpmKeTbFEBZnTLsLMWtRUr085SD38pKGCCRhUK
        K1f3qB0YxovFVkPRPmfp4k3nWdUQEUZcz9PA5avZ0E4qP5rRK5CGH6d6voD0VNhQrd9uD2Di24i
        bWXgLPJ4NU+MR
X-Received: by 2002:ac8:7a95:: with SMTP id x21mr18296173qtr.135.1596487618310;
        Mon, 03 Aug 2020 13:46:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5fxnaL6Ri46pS/AV+1q2qnTh3NBSJWvAJ/JhDs1vxf+Hn61PqhkFs+LWvi9B3V915cqgzgQ==
X-Received: by 2002:ac8:7a95:: with SMTP id x21mr18296141qtr.135.1596487617954;
        Mon, 03 Aug 2020 13:46:57 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id w44sm23855273qtj.86.2020.08.03.13.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:46:56 -0700 (PDT)
Date:   Mon, 3 Aug 2020 16:46:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        kvm@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200803164605-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org>
 <20200731054752.GA28005@ubuntu>
 <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 07:25:24AM -0600, Mathieu Poirier wrote:
> On Thu, 30 Jul 2020 at 23:47, Guennadi Liakhovetski
> <guennadi.liakhovetski@linux.intel.com> wrote:
> >
> > Hi Michael,
> >
> > On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > Hi,
> > > >
> > > > Now that virtio-rpmsg endianness fixes have been merged we can
> > > > proceed with the next step.
> > >
> > > Which tree is this for?
> >
> > The essential part of this series is for drivers/vhost, so, I presume
> > that should be the target tree as well. There is however a small part
> > for the drivers/rpmsg, should I split this series in two or shall we
> > first review is as a whole to make its goals clearer?
> 
> I suggest to keep it whole for now.


Ok can I get some acks please?
Also, I put this in my linux-next branch on 

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

there were some conflicts - could you pls test and report it's ok?

> >
> > Thanks
> > Guennadi
> >
> > > > v4:
> > > > - add endianness conversions to comply with the VirtIO standard
> > > >
> > > > v3:
> > > > - address several checkpatch warnings
> > > > - address comments from Mathieu Poirier
> > > >
> > > > v2:
> > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > - drop patch #6 - it depends on a different patch, that is currently
> > > >   an RFC
> > > > - address comments from Pierre-Louis Bossart:
> > > >   * remove "default n" from Kconfig
> > > >
> > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > cases. It can however also be used for virtualisation scenarios,
> > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > audio DSP virtualisation project, currently under development, ready
> > > > for review and submission, available at
> > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > >
> > > > Thanks
> > > > Guennadi
> > > >
> > > > Guennadi Liakhovetski (4):
> > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > >   rpmsg: move common structures and defines to headers
> > > >   rpmsg: update documentation
> > > >   vhost: add an RPMsg API
> > > >
> > > >  Documentation/rpmsg.txt          |   6 +-
> > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > >  drivers/vhost/Kconfig            |   7 +
> > > >  drivers/vhost/Makefile           |   3 +
> > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > >  include/uapi/linux/vhost.h       |   4 +-
> > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > >
> > > > --
> > > > 2.27.0
> > >

