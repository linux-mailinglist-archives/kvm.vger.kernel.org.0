Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9653A26D90A
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIQK3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:29:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:34842 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbgIQK3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 06:29:23 -0400
IronPort-SDR: twmeOVqVFj0DbK2abVT28l8nuFRs5C9HbH3POwljOciphuQJ0jy0yDByE3u2GMZXBAbEDazwXW
 CNsMP2bHo0PA==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="157072154"
X-IronPort-AV: E=Sophos;i="5.76,436,1592895600"; 
   d="scan'208";a="157072154"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 03:29:19 -0700
IronPort-SDR: Sae5zd9KD3dEUlzr7XHC+ou/WiCIYT/fy4ar77tPms92ndus9S0NHGRtSrZfHv78NzTX/r3Vyg
 wBd0kK2KM1Mg==
X-IronPort-AV: E=Sophos;i="5.76,436,1592895600"; 
   d="scan'208";a="483691895"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.45.143])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 03:29:15 -0700
Date:   Thu, 17 Sep 2020 12:29:12 +0200
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
        Mathieu Poirier <mathieu.poirier@linaro.org>, kishon@ti.com
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
Message-ID: <20200917102911.GB11491@ubuntu>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com>
 <20200917054705.GA11491@ubuntu>
 <20200917083644.66yjer4zvoiftrk3@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917083644.66yjer4zvoiftrk3@axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vincent,

On Thu, Sep 17, 2020 at 10:36:44AM +0200, Vincent Whitchurch wrote:
> On Thu, Sep 17, 2020 at 07:47:06AM +0200, Guennadi Liakhovetski wrote:
> > On Tue, Sep 15, 2020 at 02:13:23PM +0200, Arnaud POULIQUEN wrote:
> > > So i would be agree with Vincent[2] which proposed to switch on a RPMsg API
> > > and creating a vhost rpmsg device. This is also proposed in the 
> > > "Enhance VHOST to enable SoC-to-SoC communication" RFC[3].
> > > Do you think that this alternative could match with your need?
> > 
> > As I replied to Vincent, I understand his proposal and the approach taken 
> > in the series [3], but I'm not sure I agree, that adding yet another 
> > virtual device / driver layer on the vhost side is a good idea. As far as 
> > I understand adding new completely virtual devices isn't considered to be 
> > a good practice in the kernel. Currently vhost is just a passive "library" 
> > and my vhost-rpmsg support keeps it that way. Not sure I'm in favour of 
> > converting vhost to a virtual device infrastructure.
> 
> I know it wasn't what you meant, but I noticed that the above paragraph
> could be read as if my suggestion was to convert vhost to a virtual
> device infrastructure, so I just want to clarify that that those are not
> related.  The only similarity between what I suggested in the thread in
> [2] and Kishon's RFC in [3] is that both involve creating a generic
> vhost-rpmsg driver which would allow the RPMsg API to be used for both
> sides of the link, instead of introducing a new API just for the server
> side.  That can be done without rewriting drivers/vhost/.

Thanks for the clarification. Another flexibility, that I'm trying to preserve 
with my approach is keeping direct access to iovec style data buffers for 
cases where that's the structure, that's already used by the respective 
driver on the host side. Since we already do packing and unpacking on the 
guest / client side, we don't need the same on the host / server side again.

Thanks
Guennadi

> > > [1]. https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335 
> > > [2]. https://www.spinics.net/lists/linux-virtualization/msg44195.html
> > > [3]. https://www.spinics.net/lists/linux-remoteproc/msg06634.html  
