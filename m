Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1265E1EF4E2
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 12:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgFEKBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 06:01:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:11568 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgFEKBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 06:01:30 -0400
IronPort-SDR: XoqVkBIiGxTHo+wSZrgkx7HdREHvZohPklI7NKzTjb4TC8cTmVR/V3MV0yEii1AaaWhfp22a7J
 e2rg4hEeqzUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 03:01:29 -0700
IronPort-SDR: vWS/50et7xmFAg5r4IU3YsDOlNUuTrqgv+k1rQ0mALJtjpZI9lZqkhSgjDJqcjNJi54nfShBXf
 GeveydjtL6NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,475,1583222400"; 
   d="scan'208";a="305191033"
Received: from rpurrx-mobl1.ger.corp.intel.com ([10.252.45.77])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2020 03:01:26 -0700
Message-ID: <298489ce4ba4baeb4e3cc46345b4a9f573f59b76.camel@linux.intel.com>
Subject: Re: [Sound-open-firmware] [PATCH v3 0/5] Add a vhost RPMsg API
From:   Liam Girdwood <liam.r.girdwood@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-remoteproc@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        sound-open-firmware@alsa-project.org
Date:   Fri, 05 Jun 2020 11:01:29 +0100
In-Reply-To: <20200604151917-mutt-send-email-mst@kernel.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
         <20200604151917-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-06-04 at 15:23 -0400, Michael S. Tsirkin wrote:
> On Wed, May 27, 2020 at 08:05:36PM +0200, Guennadi Liakhovetski
> wrote:
> > v3:
> > - address several checkpatch warnings
> > - address comments from Mathieu Poirier
> > 
> > v2:
> > - update patch #5 with a correct vhost_dev_init() prototype
> > - drop patch #6 - it depends on a different patch, that is
> > currently
> >   an RFC
> > - address comments from Pierre-Louis Bossart:
> >   * remove "default n" from Kconfig
> > 
> > Linux supports RPMsg over VirtIO for "remote processor" /AMP use
> > cases. It can however also be used for virtualisation scenarios,
> > e.g. when using KVM to run Linux on both the host and the guests.
> > This patch set adds a wrapper API to facilitate writing vhost
> > drivers for such RPMsg-based solutions. The first use case is an
> > audio DSP virtualisation project, currently under development,
> > ready
> > for review and submission, available at
> > https://github.com/thesofproject/linux/pull/1501/commits
> > A further patch for the ADSP vhost RPMsg driver will be sent
> > separately for review only since it cannot be merged without audio
> > patches being upstreamed first.
> 
> RPMsg over virtio has several problems. One is that it's
> not specced at all. Before we add more stuff, I'd like so
> see at least an attempt at describing what it's supposed to do.
> 

Sure, I'll add some more context here. The remote processor in this use
case is any DSP (from any vendor) running SOF. The work from Guennadi
virtualises the SOF mailbox and SOF doorbell mechanisms (which the
platform driver abstracts) via rpmsg/virtio so the guest SOF drivers
can send and receive SOF IPCs (just as the host SOF driver would do).
It's 95% the same Linux driver on host or guest (for each feature).

I would also add here (and it's maybe confusing in the SOF naming) that
SOF is multi a feature FW, it's not just an audio FW, so we would also
expect to see other guest drivers (e.g. sensing) that would use the
same mechanism for IPC on guests. I would expect the feature driver
count to increase as the FW features grow.

The IPC ABI between the FW and host drivers continually evolves as
features and new HW is added (not just from Intel, but from other SOF
partners and external partners that supply proprietary audio
processing). The only part of the interface that is specced is the
rpmsg header, as the SOF message content will keep evolving (it's up to
driver and FW to align on ABI version used - it does this already
today). 

I guess it boils down to two goals here

1) virtualising the SOF features on any platform/guest/OS so that
guests would be able to access any FW feature (provided guest was
permitted) just as they would on host.

2) Supporting FW features and use cases from multiple parties without
having to change driver core or driver virtualisation core. i.e. all
the changes (for new features) would be in the edge drivers e.g. new
audio features would impact audio driver only.

> Another it's out of line with 1.0 spec passing guest
> endian data around. Won't work if host and guest
> endian-ness do not match. Should pass eveything in LE and
> convert.
> 

I think Guennadi is working on this now.

> It's great to see it's seeing active development finally.
> Do you think you will have time to address these?
> 

Yes, of course. Let me know if you need any more background or context.

Thanks

Liam

> 
> 
> > Thanks
> > Guennadi
> > 
> > Guennadi Liakhovetski (5):
> >   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
> >   vhost: (cosmetic) remove a superfluous variable initialisation
> >   rpmsg: move common structures and defines to headers
> >   rpmsg: update documentation
> >   vhost: add an RPMsg API
> > 
> >  Documentation/rpmsg.txt          |   6 +-
> >  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +-------
> >  drivers/vhost/Kconfig            |   7 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/rpmsg.c            | 382
> > +++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost.c            |   2 +-
> >  drivers/vhost/vhost_rpmsg.h      |  74 ++++++++
> >  include/linux/virtio_rpmsg.h     |  81 +++++++++
> >  include/uapi/linux/rpmsg.h       |   3 +
> >  include/uapi/linux/vhost.h       |   4 +-
> >  10 files changed, 559 insertions(+), 81 deletions(-)
> >  create mode 100644 drivers/vhost/rpmsg.c
> >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> >  create mode 100644 include/linux/virtio_rpmsg.h
> > 
> > -- 
> > 1.9.3
> 
> _______________________________________________
> Sound-open-firmware mailing list
> Sound-open-firmware@alsa-project.org
> https://mailman.alsa-project.org/mailman/listinfo/sound-open-firmware

