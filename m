Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3A58071
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 12:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfF0Kbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 06:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfF0Kbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 06:31:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFEE43082E06;
        Thu, 27 Jun 2019 10:31:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-96.ams2.redhat.com [10.36.116.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BB685C1B4;
        Thu, 27 Jun 2019 10:31:34 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 5DDE011AAF; Thu, 27 Jun 2019 12:31:33 +0200 (CEST)
Date:   Thu, 27 Jun 2019 12:31:33 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to userspace
Message-ID: <20190627103133.6ekdwazggi5j5lcl@sirius.home.kraxel.org>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
 <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 27 Jun 2019 10:31:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >   Hi,
> > 
> > > Instead of delivering page flip events, we choose to post display
> > > vblank event. Handling page flip events for both primary plane and
> > > cursor plane may make user space quite busy, although we have the
> > > mask/unmask mechansim for mitigation. Besides, there are some cases
> > > that guest app only uses one framebuffer for both drawing and display.
> > > In such case, guest OS won't do the plane page flip when the
> > > framebuffer is updated, thus the user land won't be notified about the
> > updated framebuffer.
> > 
> > What happens when the guest is idle and doesn't draw anything to the
> > framebuffer?
> The vblank event will be delivered to userspace as well, unless guest OS disable the pipe.
> Does it make sense to vfio/display?

Getting notified only in case there are actual display updates would be
a nice optimization, assuming the hardware is able to do that.  If the
guest pageflips this is obviously trivial.  Not sure this is possible in
case the guest renders directly to the frontbuffer.

What exactly happens when the guest OS disables the pipe?  Is a vblank
event delivered at least once?  That would be very useful because it
will be possible for userspace to stop polling altogether without
missing the "guest disabled pipe" event.

cheers,
  Gerd

