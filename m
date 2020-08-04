Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A7C23BBC4
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgHDOHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:07:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727862AbgHDOHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 10:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596550068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5VoaR683WhHbTY4KgZuHziRoIAvgy8uF9wmZyYpxKE=;
        b=e824Ro8WpzYzK+Aohdwi3iKxlb6GD7oPvkhBHeS94Gg84qGf+DU0jyLDqwCdu7r1T73OZW
        94TgasJz6vZ0rAtkmXjzaoN/PY8K5YXEdTsvaWO6zKFoC6TvSq1B5LGccF5zDqe3c7goWK
        XkxI459By6Chu3hG1Ru68mIefXl8THU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-hU3JNZ8CO9qO_nIFLNQV4A-1; Tue, 04 Aug 2020 10:07:44 -0400
X-MC-Unique: hU3JNZ8CO9qO_nIFLNQV4A-1
Received: by mail-qk1-f199.google.com with SMTP id k142so28585836qke.7
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 07:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r5VoaR683WhHbTY4KgZuHziRoIAvgy8uF9wmZyYpxKE=;
        b=bJ2fVDwVP94ljtOujAAdFUMb6mWTPfkjKY6bhj0m9WpOMKaibTIbgK0SgHm0nVjXJI
         B3rWsZT5RT8w2cZNZFJtQtBgxhvCiW3l9ZZV1uufxj1MentOIA0oJ/NBvei5F3Ffst/l
         YeTAOGXRvZtbmztzKSeWZA4HbuNQpGqs3JHk21egI8tc6lQhstMaq5B6YKgW19Lx7X2M
         IEwtj/2Jjoi6wIZ5zRjPUKyO1FVSSUXTXzK2BRX0y15nkQefxA5QjQ63asMGEh7reLOU
         mo8bVnmkCovxR7rMpGslERVoLEcFz9C2/zu1lvtUaPGFL2b9YKf91kAJpzgnWuXCXcur
         Udmg==
X-Gm-Message-State: AOAM532A+y5wF4VO05+HouF3E69lVA/rkUUmbsA0I1xeNosi6SVsLhez
        vwQ9Y8u10FOEWRiTtqR3PnU8X61K7IKfkQrDQ+sEl9TnzAzlr9gkCaGOtqIFbJJro16EcCteO+O
        fq8fkjk5eGicG
X-Received: by 2002:a0c:9e4e:: with SMTP id z14mr22088422qve.71.1596550060722;
        Tue, 04 Aug 2020 07:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXZYn2kYoVoPTMxHOlAinXwUHh9e5wf9YCT9UDb/2L0ldClTmNU7M2/9PZQ2lCCvwhHwKVrA==
X-Received: by 2002:a0c:9e4e:: with SMTP id z14mr22088386qve.71.1596550060392;
        Tue, 04 Aug 2020 07:07:40 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id p4sm21874787qkj.135.2020.08.04.07.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:07:39 -0700 (PDT)
Date:   Tue, 4 Aug 2020 10:07:33 -0400
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
Message-ID: <20200804100640-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200730120805-mutt-send-email-mst@kernel.org>
 <20200731054752.GA28005@ubuntu>
 <CANLsYkxuCf6yeoqJ-T2x3LHvr9+DuxFdcsxJPmrh9A4H8yNr3w@mail.gmail.com>
 <20200803164605-mutt-send-email-mst@kernel.org>
 <CANLsYkx9e=-2dU26Lx5JFrtrbV07Vtwsi3gFphxKW5QRiwqoHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkx9e=-2dU26Lx5JFrtrbV07Vtwsi3gFphxKW5QRiwqoHg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 07:37:49AM -0600, Mathieu Poirier wrote:
> On Mon, 3 Aug 2020 at 14:47, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Aug 03, 2020 at 07:25:24AM -0600, Mathieu Poirier wrote:
> > > On Thu, 30 Jul 2020 at 23:47, Guennadi Liakhovetski
> > > <guennadi.liakhovetski@linux.intel.com> wrote:
> > > >
> > > > Hi Michael,
> > > >
> > > > On Thu, Jul 30, 2020 at 12:08:29PM -0400, Michael S. Tsirkin wrote:
> > > > > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > > > > Hi,
> > > > > >
> > > > > > Now that virtio-rpmsg endianness fixes have been merged we can
> > > > > > proceed with the next step.
> > > > >
> > > > > Which tree is this for?
> > > >
> > > > The essential part of this series is for drivers/vhost, so, I presume
> > > > that should be the target tree as well. There is however a small part
> > > > for the drivers/rpmsg, should I split this series in two or shall we
> > > > first review is as a whole to make its goals clearer?
> > >
> > > I suggest to keep it whole for now.
> >
> >
> > Ok can I get some acks please?
> 
> Yes, as soon as I have the opportunity to review the work.  There is a
> lot of volume on the linux-remoteproc mailing list lately and
> patchsets are reviewed in the order they have been received.

Well the merge window is open, I guess I'll merge this and
any issues can be addressed later then?

> > Also, I put this in my linux-next branch on
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> >
> > there were some conflicts - could you pls test and report it's ok?
> >
> > > >
> > > > Thanks
> > > > Guennadi
> > > >
> > > > > > v4:
> > > > > > - add endianness conversions to comply with the VirtIO standard
> > > > > >
> > > > > > v3:
> > > > > > - address several checkpatch warnings
> > > > > > - address comments from Mathieu Poirier
> > > > > >
> > > > > > v2:
> > > > > > - update patch #5 with a correct vhost_dev_init() prototype
> > > > > > - drop patch #6 - it depends on a different patch, that is currently
> > > > > >   an RFC
> > > > > > - address comments from Pierre-Louis Bossart:
> > > > > >   * remove "default n" from Kconfig
> > > > > >
> > > > > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > > > > cases. It can however also be used for virtualisation scenarios,
> > > > > > e.g. when using KVM to run Linux on both the host and the guests.
> > > > > > This patch set adds a wrapper API to facilitate writing vhost
> > > > > > drivers for such RPMsg-based solutions. The first use case is an
> > > > > > audio DSP virtualisation project, currently under development, ready
> > > > > > for review and submission, available at
> > > > > > https://github.com/thesofproject/linux/pull/1501/commits
> > > > > >
> > > > > > Thanks
> > > > > > Guennadi
> > > > > >
> > > > > > Guennadi Liakhovetski (4):
> > > > > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > > > > >   rpmsg: move common structures and defines to headers
> > > > > >   rpmsg: update documentation
> > > > > >   vhost: add an RPMsg API
> > > > > >
> > > > > >  Documentation/rpmsg.txt          |   6 +-
> > > > > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > > > > >  drivers/vhost/Kconfig            |   7 +
> > > > > >  drivers/vhost/Makefile           |   3 +
> > > > > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > > > > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > > > > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > > > > >  include/uapi/linux/rpmsg.h       |   3 +
> > > > > >  include/uapi/linux/vhost.h       |   4 +-
> > > > > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > > > >
> > > > > > --
> > > > > > 2.27.0
> > > > >
> >

