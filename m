Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BED26FB1C
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgIRLC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 07:02:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:49694 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgIRLC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 07:02:57 -0400
IronPort-SDR: jjCDr+maZNDKIXetgqn/rigqn9qa/8607VSPlkmn005FVTIGY1OoTikwE1CUfgiVJOJY9h7uvt
 VNow3wIS+qVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="244747340"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="244747340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 04:02:56 -0700
IronPort-SDR: ANgmBiMH9bh15obHmD8XQ3qCqsitwOIFKhgNW7hROftwZgR5AEhieAUlH7er5ha3sYmCr3+3U8
 Ifq3CH6H+TxQ==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="452712594"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.42.33])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 04:02:53 -0700
Date:   Fri, 18 Sep 2020 13:02:49 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
Message-ID: <20200918110249.GE19246@ubuntu>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com>
 <20200917054705.GA11491@ubuntu>
 <47a9ad01-c922-3b1c-84de-433f229ffba3@st.com>
 <20200918054420.GA19246@ubuntu>
 <0b7d9004-d71b-8b9a-eaed-f92833ce113f@st.com>
 <20200918094719.GD19246@ubuntu>
 <20200918103907.2ts4l5xiwm4542rs@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918103907.2ts4l5xiwm4542rs@axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 18, 2020 at 12:39:07PM +0200, Vincent Whitchurch wrote:
> On Fri, Sep 18, 2020 at 11:47:20AM +0200, Guennadi Liakhovetski wrote:
> > On Fri, Sep 18, 2020 at 09:47:45AM +0200, Arnaud POULIQUEN wrote:
> > > IMO, as this API is defined in the Linux documentation [5] we should respect it, to ensure
> > > one generic implementation. The RPMsg sample client[4] uses this user API, so seems to me
> > > a good candidate to verify this. 
> > > 
> > > That's said, shall we multiple the RPMsg implementations in Linux with several APIs,
> > > With the risk to make the RPMsg clients devices dependent on these implementations?
> > > That could lead to complex code or duplications...
> > 
> > So, no, in my understanding there aren't two competing alternative APIs, you'd never have 
> > to choose between them. If you're writing a driver for Linux to communicate with remote 
> > processors or to run on VMs, you use the existing API. If you're writing a driver for 
> > Linux to communicate with those VMs, you use the vhost API and whatever help is available 
> > for RPMsg processing.
> > 
> > However, I can in principle imagine a single driver, written to work on both sides. 
> > Something like the rpmsg_char.c or maybe some networking driver. Is that what you're 
> > referring to? I can see that as a fun exercise, but are there any real uses for that? 
> 
> I hinted at a real use case for this in the previous mail thread[0].
> I'm exploring using rpmsg-char to allow communication between two chips,
> both running Linux.  rpmsg-char can be used pretty much as-is for both
> sides of the userspace-to-userspace communication and (the userspace
> side of the) userspace-to-kernel communication between the two chips.
> 
> > You could do the same with VirtIO, however, it has been decided to go with two 
> > distinct APIs: virtio for guests and vhost for the host, noone bothered to create a 
> > single API for both and nobody seems to miss one. Why would we want one with RPMsg?
> 
> I think I answered this question in the previous mail thread as well[1]:
> | virtio has distinct driver and device roles so the completely different
> | APIs on each side are understandable.  But I don't see that distinction
> | in the rpmsg API which is why it seems like a good idea to me to make it
> | work from both sides of the link and allow the reuse of drivers like
> | rpmsg-char, instead of imposing virtio's distinction on rpmsg.

I think RPMsg is lacking real established documentation... Quating from [2]:

<quote>
In the current protocol, at startup, the master sends notification to remote to let it 
know that it can receive name service announcement.
</quote>

Isn't that a sufficient asymnetry?

Thanks
Guennadi

[2] https://github.com/OpenAMP/open-amp/wiki/RPMsg-Messaging-Protocol

> 
> [0] https://www.spinics.net/lists/linux-virtualization/msg43799.html
> [1] https://www.spinics.net/lists/linux-virtualization/msg43802.html
