Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E068F251A15
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHYNqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 09:46:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:6166 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgHYNlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 09:41:14 -0400
IronPort-SDR: nZRc+bCrGYq3nfE/yaSjx1um1LnOQzfDM5DS6ELMHZJXWMUMhwo5/mh8WewR0QAypvQOcOOIU+
 01xDnWGB5bkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="240925804"
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="240925804"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 06:41:13 -0700
IronPort-SDR: 15vXcXLW0R3ZxvbOzXHfgHkl51eK0GaGcbh/iSVDLHo9hh998TBv28JBK9iB4gZg035GuYUmg+
 H8EL31jZFJ3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,352,1592895600"; 
   d="scan'208";a="299093769"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.54.8])
  by orsmga006.jf.intel.com with ESMTP; 25 Aug 2020 06:41:10 -0700
Date:   Tue, 25 Aug 2020 15:41:10 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Subject: Re: [PATCH v4 4/4] vhost: add an RPMsg API
Message-ID: <20200825134109.GA9822@ubuntu>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200722150927.15587-5-guennadi.liakhovetski@linux.intel.com>
 <20200804102132-mutt-send-email-mst@kernel.org>
 <20200804151916.GC19025@ubuntu>
 <20200810094013-mutt-send-email-mst@kernel.org>
 <20200812123243.GA10218@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812123243.GA10218@ubuntu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

...back from holidays and still unsure what your preferred solution 
for the message layout would be:

On Wed, Aug 12, 2020 at 02:32:43PM +0200, Guennadi Liakhovetski wrote:
> Hi Michael,
> 
> Thanks for a review.
> 
> On Mon, Aug 10, 2020 at 09:44:15AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Aug 04, 2020 at 05:19:17PM +0200, Guennadi Liakhovetski wrote:

[snip]

> > > > > +static int vhost_rpmsg_get_single(struct vhost_virtqueue *vq)
> > > > > +{
> > > > > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > > > > +	unsigned int out, in;
> > > > > +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> > > > > +				     NULL, NULL);
> > > > > +	if (head < 0) {
> > > > > +		vq_err(vq, "%s(): error %d getting buffer\n",
> > > > > +		       __func__, head);
> > > > > +		return head;
> > > > > +	}
> > > > > +
> > > > > +	/* Nothing new? */
> > > > > +	if (head == vq->num)
> > > > > +		return head;
> > > > > +
> > > > > +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE] && (out || in != 1)) {
> > > > 
> > > > This in != 1 looks like a dependency on a specific message layout.
> > > > virtio spec says to avoid these. Using iov iters it's not too hard to do
> > > > ...
> > > 
> > > This is an RPMsg VirtIO implementation, and it has to match the virtio_rpmsg_bus.c 
> > > driver, and that one has specific VirtIO queue and message usage patterns.
> > 
> > That could be fine for legacy virtio, but now you are claiming support
> > for virtio 1, so need to fix these assumptions in the device.
> 
> I can just deop these checks without changing anything else, that still would work. 
> I could also make this work with "any" layout - either ignoring any left-over 
> buffers or maybe even getting them one by one. But I wouldn't even be able to test 
> those modes without modifying / breaking the current virtio-rpmsg driver. What's 
> the preferred solution?

Could you elaborate a bit please?

Thanks
Guennadi
