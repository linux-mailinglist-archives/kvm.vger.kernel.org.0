Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D5523BBCF
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgHDOKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:10:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726580AbgHDOKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 10:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596550234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Buhd+kZycj+/wRI0Hp3Q3IKmTfkuvVjniMvAfWe01oU=;
        b=V/RcmfZny8swjQIwt+ZXkBE5uAmhJJZgUUijgEPaqpzG5D0sh6mtUxBvH5Q+arXRgmJ+yX
        3k7v5RKgm4SDQPL0sHYoBI1uj0laidUXArBanttmNlTlqWLn8nRu2zrL++iZIoUdGQ2NIG
        iircbwWA1fa9YfybuBGKfFpMMyCb5lg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-HpT2VV58MOW_AGORrC0bvQ-1; Tue, 04 Aug 2020 10:10:32 -0400
X-MC-Unique: HpT2VV58MOW_AGORrC0bvQ-1
Received: by mail-qv1-f72.google.com with SMTP id d1so13559436qvs.21
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 07:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Buhd+kZycj+/wRI0Hp3Q3IKmTfkuvVjniMvAfWe01oU=;
        b=aqW9Da4PDY4OZfJ2HvsqJL57zPqdqU/GsnRmJJC7b7+BZWdf8GlRYjRcxTer+tWTzV
         9WjeSrEgJ5Zm2asO9ymkXSpNZtDb65YUEY78bpQ1tpiw01J65ItMyUgncrKDqXOraIAw
         xIhJsKXdLvjbhxtvBhqPGT2gmqs8XtTvUrZeIIFb+C610IQLeZ+6zz8U4J875ZCsmhRN
         r068BMJaywImacFuqE1QPgHbdAjt50L28j7kUYmTI0sD1KBG2RJl3Sw8Lid/oc69aNkU
         K6NiumIyhEX9j745YuGwlskGT5NGjhv4yNzlEXprFXzubMgGJNAR1fS0uIBMuQ3Yhc3R
         gkKA==
X-Gm-Message-State: AOAM533ukDu1aM1aMOG4D72cA9WeThDANPW4AX88Um7qGlIKSyZ76RnB
        z2NdVQuRV3nmHgyWVKfOwYua0PxMHoIh+9re+hQ5qD36aom4lEBpvZQlNBevTMp1jppQG0uG82Z
        ys7zRWF+pxVNh
X-Received: by 2002:ac8:5546:: with SMTP id o6mr20933590qtr.211.1596550229462;
        Tue, 04 Aug 2020 07:10:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh3pjFBLQIXYiY71oA2fmlEWD9//13DksMw68m8mtIbvj8Tup8wAllZTDQOkR6zg/SeRurDQ==
X-Received: by 2002:ac8:5546:: with SMTP id o6mr20933560qtr.211.1596550229198;
        Tue, 04 Aug 2020 07:10:29 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id l66sm1076968qte.48.2020.08.04.07.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:10:28 -0700 (PDT)
Date:   Tue, 4 Aug 2020 10:10:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200804100747-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200804082250-mutt-send-email-mst@kernel.org>
 <20200804131918.GA19025@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804131918.GA19025@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 03:19:19PM +0200, Guennadi Liakhovetski wrote:
> Hi Michael,
> 
> On Tue, Aug 04, 2020 at 08:26:53AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> > > Hi,
> > > 
> > > Now that virtio-rpmsg endianness fixes have been merged we can 
> > > proceed with the next step.
> > 
> > OK my attempts to resolve conflicts just created a mess.
> 
> You just need to apply my previous patch for virtio-rpmsg first 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/rpmsg/virtio_rpmsg_bus.c?id=111d1089700cdb752681ef44f54ab6137736f5c2
> Then this series should apply cleanly.
> 
> Thanks
> Guennadi

Hmm.  Could you test the vhost branch in my tree, and tell me if that looks
good to you?

> > I dropped these for now, could you pls rebase on top
> > of linux-next branch in my tree, and repost?
> > Thanks!
> > 
> > 
> > > v4:
> > > - add endianness conversions to comply with the VirtIO standard
> > > 
> > > v3:
> > > - address several checkpatch warnings
> > > - address comments from Mathieu Poirier
> > > 
> > > v2:
> > > - update patch #5 with a correct vhost_dev_init() prototype
> > > - drop patch #6 - it depends on a different patch, that is currently
> > >   an RFC
> > > - address comments from Pierre-Louis Bossart:
> > >   * remove "default n" from Kconfig
> > > 
> > > Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> > > cases. It can however also be used for virtualisation scenarios,
> > > e.g. when using KVM to run Linux on both the host and the guests.
> > > This patch set adds a wrapper API to facilitate writing vhost
> > > drivers for such RPMsg-based solutions. The first use case is an
> > > audio DSP virtualisation project, currently under development, ready
> > > for review and submission, available at
> > > https://github.com/thesofproject/linux/pull/1501/commits
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > Guennadi Liakhovetski (4):
> > >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> > >   rpmsg: move common structures and defines to headers
> > >   rpmsg: update documentation
> > >   vhost: add an RPMsg API
> > > 
> > >  Documentation/rpmsg.txt          |   6 +-
> > >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
> > >  drivers/vhost/Kconfig            |   7 +
> > >  drivers/vhost/Makefile           |   3 +
> > >  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
> > >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
> > >  include/linux/virtio_rpmsg.h     |  83 +++++++
> > >  include/uapi/linux/rpmsg.h       |   3 +
> > >  include/uapi/linux/vhost.h       |   4 +-
> > >  9 files changed, 553 insertions(+), 80 deletions(-)
> > >  create mode 100644 drivers/vhost/rpmsg.c
> > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > >  create mode 100644 include/linux/virtio_rpmsg.h
> > > 
> > > -- 
> > > 2.27.0
> > 

