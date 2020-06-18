Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7B61FF472
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgFROOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 10:14:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:47310 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730714AbgFROOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 10:14:18 -0400
IronPort-SDR: tQuvQZ4xttHmZDK0BJQeJs/7jMh/cRDi9kfexfYJ/bIR8CRN38vpfvKlOar/nOjFNy/idsL4B8
 ckJaoFyMQabg==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="141658831"
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="141658831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 07:14:18 -0700
IronPort-SDR: 0itBy+xKAWbv8XVSzGrTX5a00QgANjZmuLmz4Kd9PS8ZFk8J8KQqQXg3VyR0B1cefAsJZ3FOOt
 28jlxIVBXIqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,526,1583222400"; 
   d="scan'208";a="477253979"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.48.152])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2020 07:14:15 -0700
Date:   Thu, 18 Jun 2020 16:14:12 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "sound-open-firmware@alsa-project.org" 
        <sound-open-firmware@alsa-project.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 5/5] vhost: add an RPMsg API
Message-ID: <20200618141412.GD4189@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200527180541.5570-6-guennadi.liakhovetski@linux.intel.com>
 <20200617191741.whnp7iteb36cjnia@axis.com>
 <20200618090341.GA4189@ubuntu>
 <20200618093324.tu7oldr332ndfgev@axis.com>
 <20200618103940.GB4189@ubuntu>
 <20200618135241.362iuggde3jslx3p@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618135241.362iuggde3jslx3p@axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 18, 2020 at 03:52:42PM +0200, Vincent Whitchurch wrote:
> On Thu, Jun 18, 2020 at 12:39:40PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, Jun 18, 2020 at 11:33:24AM +0200, Vincent Whitchurch wrote:
> > > By the "normal rpmsg API" I mean register_rpmsg_driver(), rpmsg_send(),
> > > etc.  That API is not tied to virtio in any way and there are other
> > > non-virtio backends for this API in the tree.  So it seems quite natural
> > > to implement a vhost backend for this API so that both sides of the link
> > > can use the same API but different backends, instead of forcing them to
> > > use of different APIs.
> > 
> > Ok, I see what you mean now. But I'm not sure this is useful or desired. I'm 
> > not an expert in KVM / VirtIO, I've only been working in the area for less 
> > than a year, so, I might well be wrong.
> > 
> > You're proposing to use the rpmsg API in vhost drivers. As far as I 
> > understand so far that API was only designated for the Linux side (in case of 
> > AMPs) which corresponds to VM guests in virtualisation case. So, I'm not sure 
> > we want to use the same API for the hosts? This can be done as you have 
> > illustrated, but is it desirable? The vhost API is far enough from the VirtIO 
> > driver API, so I'm not sure why we want the same API for rpmsg?
> 
> Note that "the Linux side" is ambiguous for AMP since both sides can be
> Linux, as they happen to be in my case.  I'm running virtio/rpmsg
> between two physical processors (of different architectures), both
> running Linux.

Ok, interesting, I didn't know such configurations were used too. I understood 
the Linux rpmsg implementation in the way, that it's assumed, that the "host" 
has to boot the "device" by sending an ELF formatted executable image to it, is 
that optional? You aren't sending a complete Linux image to the device side, 
are you?

> virtio has distinct driver and device roles so the completely different
> APIs on each side are understandable.  But I don't see that distinction
> in the rpmsg API which is why it seems like a good idea to me to make it
> work from both sides of the link and allow the reuse of drivers like
> rpmsg-char, instead of imposing virtio's distinction on rpmsg.

Understand. In principle I'm open to this idea, but before I implement it it 
would be good to know what maintainers think?

Thanks
Guennadi
