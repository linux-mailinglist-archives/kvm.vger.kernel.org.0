Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD2A59398
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 07:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfF1Fn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 01:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfF1Fn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 01:43:59 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 605775AFE9;
        Fri, 28 Jun 2019 05:43:58 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-96.ams2.redhat.com [10.36.116.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93C796012E;
        Fri, 28 Jun 2019 05:43:52 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C0C3D16E05; Fri, 28 Jun 2019 07:43:46 +0200 (CEST)
Date:   Fri, 28 Jun 2019 07:43:46 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     "Zhang, Tina" <tina.zhang@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to userspace
Message-ID: <20190628054346.3uc3k4c4cffrqcy3@sirius.home.kraxel.org>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
 <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
 <20190627103133.6ekdwazggi5j5lcl@sirius.home.kraxel.org>
 <20190628032149.GD9684@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628032149.GD9684@zhen-hp.sh.intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 28 Jun 2019 05:43:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 28, 2019 at 11:21:49AM +0800, Zhenyu Wang wrote:
> On 2019.06.27 12:31:33 +0200, Gerd Hoffmann wrote:
> > > >   Hi,
> > > > 
> > > > > Instead of delivering page flip events, we choose to post display
> > > > > vblank event. Handling page flip events for both primary plane and
> > > > > cursor plane may make user space quite busy, although we have the
> > > > > mask/unmask mechansim for mitigation. Besides, there are some cases
> > > > > that guest app only uses one framebuffer for both drawing and display.
> > > > > In such case, guest OS won't do the plane page flip when the
> > > > > framebuffer is updated, thus the user land won't be notified about the
> > > > updated framebuffer.
> > > > 
> > > > What happens when the guest is idle and doesn't draw anything to the
> > > > framebuffer?
> > > The vblank event will be delivered to userspace as well, unless guest OS disable the pipe.
> > > Does it make sense to vfio/display?
> > 
> > Getting notified only in case there are actual display updates would be
> > a nice optimization, assuming the hardware is able to do that.  If the
> > guest pageflips this is obviously trivial.  Not sure this is possible in
> > case the guest renders directly to the frontbuffer.
> > 
> > What exactly happens when the guest OS disables the pipe?  Is a vblank
> > event delivered at least once?  That would be very useful because it
> > will be possible for userspace to stop polling altogether without
> > missing the "guest disabled pipe" event.
> > 
> 
> It looks like purpose to use vblank here is to replace user space
> polling totally by kernel event? Which just act as display update
> event to replace user space timer to make it query and update
> planes?

I think it makes sense to design it that way, so userspace will either
use the events (when supported by the driver) or a timer (fallback if
not) but not both.

> Although in theory vblank is not appropriate for this which
> doesn't align with plane update or possible front buffer rendering at
> all, but looks it's just a compromise e.g not sending event for every
> cursor position change, etc.
> 
> I think we need to define semantics for this event properly, e.g user
> space purely depends on this event for display update, the opportunity
> for issuing this event is controlled by driver when it's necessary for
> update, etc. Definitely not named as vblank event or only issue at vblank,
> that need to happen for other plane change too.

I think it should be "display update notification", i.e. userspace
should check for plane changes and update the display.

Most events will probably come from vblank (typically plane update are
actually committed at vblank time to avoid tearing, right?).  That is an
implementation detail though.

cheers,
  Gerd

