Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01420265AF8
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 09:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgIKH7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 03:59:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:10020 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgIKH7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 03:59:20 -0400
IronPort-SDR: Eot52ivqU66j5WiKoWJevrZIOrklfgn4EK7OzPVa0T3uq7II+Lzgsdpt4/yi+eXVet5qJqMKPT
 TCrVjg3MyhiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="222913104"
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="222913104"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 00:59:18 -0700
IronPort-SDR: iDT9vVAuH2W1PbzfD/zs+OjLyNdr4CigVukWNXDRllpKhMI7QnnLfYbitFQE61Jnlvi3krOJSk
 OlymXk/fwhSw==
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="344563126"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.38.203])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 00:59:16 -0700
Date:   Fri, 11 Sep 2020 09:59:12 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 1/4] vhost: convert VHOST_VSOCK_SET_RUNNING to a
 generic ioctl
Message-ID: <20200911075912.GB26801@ubuntu>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-2-guennadi.liakhovetski@linux.intel.com>
 <20200909224214.GB562265@xps15>
 <20200910062144.GA16802@ubuntu>
 <20200910164643.GA579940@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910164643.GA579940@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 10:46:43AM -0600, Mathieu Poirier wrote:
> On Thu, Sep 10, 2020 at 09:15:13AM +0200, Guennadi Liakhovetski wrote:
> > Hi Mathieu,
> > 
> > On Wed, Sep 09, 2020 at 04:42:14PM -0600, Mathieu Poirier wrote:
> > > On Wed, Aug 26, 2020 at 07:46:33PM +0200, Guennadi Liakhovetski wrote:
> > > > VHOST_VSOCK_SET_RUNNING is used by the vhost vsock driver to perform
> > > > crucial VirtQueue initialisation, like assigning .private fields and
> > > > calling vhost_vq_init_access(), and clean up. However, this ioctl is
> > > > actually extremely useful for any vhost driver, that doesn't have a
> > > > side channel to inform it of a status change, e.g. upon a guest
> > > > reboot. This patch makes that ioctl generic, while preserving its
> > > > numeric value and also keeping the original alias.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > ---
> > > >  include/uapi/linux/vhost.h | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > > index 75232185324a..11a4948b6216 100644
> > > > --- a/include/uapi/linux/vhost.h
> > > > +++ b/include/uapi/linux/vhost.h
> > > > @@ -97,6 +97,8 @@
> > > >  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
> > > >  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
> > > >  
> > > > +#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
> > > > +
> > > 
> > > I don't see it used in the next patches and as such should be part of another
> > > series.
> > 
> > It isn't used in the next patches, it is used in this patch - see below.
> >
> 
> Right, but why is this part of this set?  What does it bring?  It should be part
> of a patchset where "VHOST_SET_RUNNING" is used.

Ok, I can remove this patch from this series and make it a part of the series, 
containing [1] "vhost: add an SOF Audio DSP driver"

Thanks
Guennadi

[1] https://www.spinics.net/lists/linux-virtualization/msg43309.html

> > > >  /* VHOST_NET specific defines */
> > > >  
> > > >  /* Attach virtio net ring to a raw socket, or tap device.
> > > > @@ -118,7 +120,7 @@
> > > >  /* VHOST_VSOCK specific defines */
> > > >  
> > > >  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > > > -#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > > > +#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
> > > >  
> > > >  /* VHOST_VDPA specific defines */
> > > >  
> > > > -- 
> > > > 2.28.0
> > > > 
