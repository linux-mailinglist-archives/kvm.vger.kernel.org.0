Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2541F1681
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 12:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgFHKPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 06:15:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:58679 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgFHKPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 06:15:32 -0400
IronPort-SDR: aQXo931Nlb2H3iNr5z33nmx9g6+b6Mgw0uFjEAgXPnKTnCrUNCUkQIE0H6Dpj7BI4dlny8er1e
 NbAFQV6nJF3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 03:15:31 -0700
IronPort-SDR: m0FFRdLHaD/Vf/qbUvK66+JEM9UMrfJC4RA8ihb9+yJuwDroGvqbp5FWkEHCrvfcu1QtugZxaK
 /zBYHZ20WgcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="446683561"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.46.212])
  by orsmga005.jf.intel.com with ESMTP; 08 Jun 2020 03:15:28 -0700
Date:   Mon, 8 Jun 2020 12:15:27 +0200
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
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 0/5] Add a vhost RPMsg API
Message-ID: <20200608101526.GD10562@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <20200604151917-mutt-send-email-mst@kernel.org>
 <20200605063435.GA32302@ubuntu>
 <20200608073715.GA10562@ubuntu>
 <20200608091100.GC10562@ubuntu>
 <20200608051358-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608051358-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 05:19:06AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2020 at 11:11:00AM +0200, Guennadi Liakhovetski wrote:
> > Update: I looked through VirtIO 1.0 and 1.1 specs, data format their, 
> > including byte order, is defined on a per-device type basis. RPMsg is 
> > indeed included in the spec as device type 7, but that's the only 
> > mention of it in both versions. It seems RPMsg over VirtIO isn't 
> > standardised yet.
> 
> Yes. And it would be very good to have some standartization before we
> keep adding things. For example without any spec if host code breaks
> with some guests, how do we know which side should be fixed?
> 
> > Also it looks like newer interface definitions 
> > specify using "guest native endianness" for Virtual Queue data.
> 
> They really don't or shouldn't. That's limited to legacy chapters.
> Some definitions could have slipped through but it's not
> the norm. I just quickly looked through the 1.1 spec and could
> not find any instances that specify "guest native endianness"
> but feel free to point them out to me.

Oh, there you go. No, sorry, my fault, it's the other way round: "guest 
native" is for legacy and LE is for current / v1.0 and up.

> > So 
> > I think the same should be done for RPMsg instead of enforcing LE?
> 
> That makes hardware implementations as well as any cross-endian
> hypervisors tricky.

Yes, LE it is then. And we need to add some text to the spec.

In theory there could be a backward compatibility issue - in case someone 
was already using virtio_rpmsg_bus.c in BE mode, but I very much doubt 
that...

Thanks
Guennadi
