Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EC71FF3EC
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgFRNwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 09:52:50 -0400
Received: from smtp1.axis.com ([195.60.68.17]:46204 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgFRNwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 09:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=1795; q=dns/txt; s=axis-central1;
  t=1592488365; x=1624024365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K3qXhXuXakILYod+5kBesnr9hqgCoyRBGyf2BukPwdg=;
  b=fotyo2v5cDMacL+i5mPFjax2SFLNqM7d0K9wU1g09qgJYvXAoQs4Ebls
   wvrPuwClnFE3H8zpWsioK/0pMFbfEW8ni3QjdCm6HnbhOjI2cHEre8mg+
   niEN15uyl3LJBtXwR3G4+G0UI5XaKsik+CiCKLg1Zm5HOfkchUNx3xLTs
   ni0b/YH3Tx3mDTjrwVvgrWKhGMg3e4GJAVT16Y1B0cfVMfHFUTugSuVO2
   VhWQQ+jKvjC5bbH0gIe1bNeVmOwuY200036ohIoH2MJj/Lu3lEBPmVriM
   UNuVVFI3BfcmNqrsph66HAeachg7tuFC0mRj1BXnHaNt2C6BiCfpDZHFy
   A==;
IronPort-SDR: 39f17DGWhFX5mDaAv7IFIaJMjHJWXn2jBB81PhoK6/VVmRVRxOLK37romffu9KZl3JRlPdAynf
 sAA8fjyOW6T7KjXFkatNsLBerEF8qKy5i3xVWCN/ww2yn5w0iQa4ZNI/vFYW09hFS4Vgu0BHRt
 23WOtQVtc1NvNPxB+h+h4MD6plcO6WuKOWHRTnIeWx8ltuBZe2DW6IkGbeE+o04bL1rUQh4src
 H03lOeRTsDA4ir9o2LZedXL8hFawX0edYqNXElrOqYFUsxPlIHs11izPXHVw4r3XB4ls/erFsC
 p3c=
X-IronPort-AV: E=Sophos;i="5.73,526,1583190000"; 
   d="scan'208";a="9960045"
Date:   Thu, 18 Jun 2020 15:52:42 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Message-ID: <20200618135241.362iuggde3jslx3p@axis.com>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200527180541.5570-6-guennadi.liakhovetski@linux.intel.com>
 <20200617191741.whnp7iteb36cjnia@axis.com> <20200618090341.GA4189@ubuntu>
 <20200618093324.tu7oldr332ndfgev@axis.com> <20200618103940.GB4189@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200618103940.GB4189@ubuntu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 18, 2020 at 12:39:40PM +0200, Guennadi Liakhovetski wrote:
> On Thu, Jun 18, 2020 at 11:33:24AM +0200, Vincent Whitchurch wrote:
> > By the "normal rpmsg API" I mean register_rpmsg_driver(), rpmsg_send(),
> > etc.  That API is not tied to virtio in any way and there are other
> > non-virtio backends for this API in the tree.  So it seems quite natural
> > to implement a vhost backend for this API so that both sides of the link
> > can use the same API but different backends, instead of forcing them to
> > use of different APIs.
> 
> Ok, I see what you mean now. But I'm not sure this is useful or desired. I'm 
> not an expert in KVM / VirtIO, I've only been working in the area for less 
> than a year, so, I might well be wrong.
> 
> You're proposing to use the rpmsg API in vhost drivers. As far as I 
> understand so far that API was only designated for the Linux side (in case of 
> AMPs) which corresponds to VM guests in virtualisation case. So, I'm not sure 
> we want to use the same API for the hosts? This can be done as you have 
> illustrated, but is it desirable? The vhost API is far enough from the VirtIO 
> driver API, so I'm not sure why we want the same API for rpmsg?

Note that "the Linux side" is ambiguous for AMP since both sides can be
Linux, as they happen to be in my case.  I'm running virtio/rpmsg
between two physical processors (of different architectures), both
running Linux.

virtio has distinct driver and device roles so the completely different
APIs on each side are understandable.  But I don't see that distinction
in the rpmsg API which is why it seems like a good idea to me to make it
work from both sides of the link and allow the reuse of drivers like
rpmsg-char, instead of imposing virtio's distinction on rpmsg.
