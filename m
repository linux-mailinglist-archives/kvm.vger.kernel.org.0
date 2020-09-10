Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A7C263E50
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgIJHPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:15:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:43531 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730378AbgIJHPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:15:20 -0400
IronPort-SDR: ts3/RM3BbAaSZErg9pI8cI18afivj805sKU6FLrJDP5p+xqJf6pT/qdvex0CmqLVXx8uVYjOI6
 AXdSIl4u5Img==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="155881189"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="155881189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:15:19 -0700
IronPort-SDR: e6Qaiy2n8PctJP2/CF688WXqm7EvXe1yUUpcy7kkqSeXCMRKgSqQXPf9dioKsgfziB4kkep8yk
 fbFAIxWN4HPw==
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="286478970"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.39.14])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:15:16 -0700
Date:   Thu, 10 Sep 2020 09:15:13 +0200
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
Message-ID: <20200910062144.GA16802@ubuntu>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-2-guennadi.liakhovetski@linux.intel.com>
 <20200909224214.GB562265@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909224214.GB562265@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Wed, Sep 09, 2020 at 04:42:14PM -0600, Mathieu Poirier wrote:
> On Wed, Aug 26, 2020 at 07:46:33PM +0200, Guennadi Liakhovetski wrote:
> > VHOST_VSOCK_SET_RUNNING is used by the vhost vsock driver to perform
> > crucial VirtQueue initialisation, like assigning .private fields and
> > calling vhost_vq_init_access(), and clean up. However, this ioctl is
> > actually extremely useful for any vhost driver, that doesn't have a
> > side channel to inform it of a status change, e.g. upon a guest
> > reboot. This patch makes that ioctl generic, while preserving its
> > numeric value and also keeping the original alias.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > ---
> >  include/uapi/linux/vhost.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 75232185324a..11a4948b6216 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -97,6 +97,8 @@
> >  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
> >  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
> >  
> > +#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
> > +
> 
> I don't see it used in the next patches and as such should be part of another
> series.

It isn't used in the next patches, it is used in this patch - see below.

Thanks
Guennadi

> >  /* VHOST_NET specific defines */
> >  
> >  /* Attach virtio net ring to a raw socket, or tap device.
> > @@ -118,7 +120,7 @@
> >  /* VHOST_VSOCK specific defines */
> >  
> >  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> > -#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > +#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
> >  
> >  /* VHOST_VDPA specific defines */
> >  
> > -- 
> > 2.28.0
> > 
