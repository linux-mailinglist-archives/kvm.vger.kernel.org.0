Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9867F963A3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 17:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfHTPDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 11:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTPDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 11:03:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8662C047B6E;
        Tue, 20 Aug 2019 15:03:30 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F05118220;
        Tue, 20 Aug 2019 15:03:27 +0000 (UTC)
Date:   Tue, 20 Aug 2019 09:03:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "kraxel@redhat.com" <kraxel@redhat.com>
Cc:     "Zhang, Tina" <tina.zhang@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: Re: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190820090327.27cfb414@x1.home>
In-Reply-To: <20190820072030.kgjjiysxgs3yj25j@sirius.home.kraxel.org>
References: <20190816023528.30210-1-tina.zhang@intel.com>
        <20190816023528.30210-3-tina.zhang@intel.com>
        <20190816145148.307408dc@x1.home>
        <237F54289DF84E4997F34151298ABEBC876F9AD3@SHSMSX101.ccr.corp.intel.com>
        <20190820072030.kgjjiysxgs3yj25j@sirius.home.kraxel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 20 Aug 2019 15:03:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Aug 2019 09:20:30 +0200
"kraxel@redhat.com" <kraxel@redhat.com> wrote:

> > > > +#define VFIO_IRQ_TYPE_GFX				(1)
> > > > +/*
> > > > + * vGPU vendor sub-type
> > > > + * vGPU device display related interrupts e.g. vblank/pageflip  */
> > > > +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)  
> > > 
> > > If this is a GFX/DISPLAY IRQ, why are we talking about a "vGPU" in the
> > > description?  It's not specific to a vGPU implementation, right?  Is this
> > > related to a physical display or a virtual display?  If it's related to the GFX
> > > PLANE ioctls, it should state that.  It's not well specified what this interrupt
> > > signals.  Is it vblank?  Is it pageflip?
> > > Is it both?  Neither?  Something else?  
> > 
> > Sorry for the confusion caused here. 
> > 
> > The original idea here was to use VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ to
> > notify user space with the display refresh event. The display refresh
> > event is general. When notified, user space can use
> > VFIO_DEVICE_QUERY_GFX_PLANE and VFIO_DEVICE_GET_GFX_DMABUF to get the
> > updated framebuffer, instead of polling them all the time.
> > 
> > In order to give user space more choice to do the optimization,
> > vfio_irq_info_cap_display_plane_events is proposed to tell user space
> > the different plane refresh event values. So when notified by
> > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ, user space can get the value of the
> > eventfd counter and understand which plane the event refresh event
> > comes from and choose to get the framebuffer on that plane instead of
> > all the planes.
> > 
> > So, from the VFIO user point of view, there is only the display
> > refresh event (i.e. no other events like vblank, pageflip ...). For
> > GTV-g, this display refresh event is implemented by both vblank and
> > pageflip, which is only the implementation thing and can be
> > transparent to the user space. Again sorry about the confusion cased
> > here, I'll correct the comments in the next version.  
> 
> All this should be explained in a comment for the IRQ in the header file.

Yes, Tina's update and your clarification all make sense to me, but it
needs to be specified in the header how this is supposed to work, what
events get signaled and what the user is intended to do in response to
that signal.  The information is all here, it just needs to be included
in the uapi definition.  Thanks,

Alex

> Key point for the API is that (a) this is a "the display should be
> updated" event and (b) this covers all display updates, i.e. user space
> can stop the display update timer and fully depend on getting
> notifications if an update is needed.
> 
> That GTV-g watches guest pageflips is an implementation detail.  Should
> nvidia support this they will probably do something completely
> different.  As far I know they render the guest display to some
> framebuffer at something like 10fps, so it would make sense for them to
> send an event each time they refreshed the framebuffer.
> 
> Also note the relationships (cur_event_val is for DRM_PLANE_TYPE_CURSOR
> updates and pri_event_val for DRM_PLANE_TYPE_PRIMARY).

