Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292E83796F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfFFQZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbfFFQZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:25:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6E4A30872C9;
        Thu,  6 Jun 2019 16:25:18 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23C369F5E;
        Thu,  6 Jun 2019 16:25:13 +0000 (UTC)
Date:   Thu, 6 Jun 2019 10:25:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "kraxel@redhat.com" <kraxel@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device
 specific irq
Message-ID: <20190606102512.0b3d2933@x1.home>
In-Reply-To: <237F54289DF84E4997F34151298ABEBC8764837E@SHSMSX101.ccr.corp.intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
        <20190604095534.10337-2-tina.zhang@intel.com>
        <20190605040446.GW9684@zhen-hp.sh.intel.com>
        <237F54289DF84E4997F34151298ABEBC87646B5C@SHSMSX101.ccr.corp.intel.com>
        <20190605100942.bceke6yqjynuwk3z@sirius.home.kraxel.org>
        <237F54289DF84E4997F34151298ABEBC8764837E@SHSMSX101.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 06 Jun 2019 16:25:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Jun 2019 10:17:51 +0000
"Zhang, Tina" <tina.zhang@intel.com> wrote:

> > -----Original Message-----
> > From: intel-gvt-dev [mailto:intel-gvt-dev-bounces@lists.freedesktop.org] On
> > Behalf Of kraxel@redhat.com
> > Sent: Wednesday, June 5, 2019 6:10 PM
> > To: Zhang, Tina <tina.zhang@intel.com>
> > Cc: Tian, Kevin <kevin.tian@intel.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Zhenyu Wang <zhenyuw@linux.intel.com>; Yuan,
> > Hang <hang.yuan@intel.com>; alex.williamson@redhat.com; Lv, Zhiyuan
> > <zhiyuan.lv@intel.com>; intel-gvt-dev@lists.freedesktop.org; Wang, Zhi A
> > <zhi.a.wang@intel.com>
> > Subject: Re: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device
> > specific irq
> > 
> >   Hi,
> >   
> > > > Really need to split for different planes? I'd like a
> > > > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_EVENT
> > > > so user space can probe change for all.  
> >   
> > > User space can choose to user different handlers according to the
> > > specific event. For example, user space might not want to handle every
> > > cursor event due to performance consideration. Besides, it can reduce
> > > the probe times, as we don't need to probe twice to make sure if both
> > > cursor plane and primary plane have been updated.  
> > 
> > I'd suggest to use the value passed via eventfd for that, i.e. instead of
> > sending "1" unconditionally send a mask of changed planes.  
> If there is only one eventfd working for GFX_DISPLAY, should it be
> VFIO_IRQ_INFO_EVENTFD and VFIO_IRQ_INFO_AUTOMASKED? i.e. after
> signaling, the interrupt is automatically masked and the user space
> needs to unmask the line to receive new irq event.

If there's any way at all the interrupt is rate limited already, I'd
suggest not to use automasked.  This flag is generally intended for
cases where we need to mask a host interrupt and don't have a generic
or efficient way to determine acknowledgement of the interrupt and
therefore require an explicit unmask.  If the events here are not at a
high frequency or you can tell by other interactions that they've been
acted upon, I'd suggest to handle these as an edge triggered interrupt
w/o automasked.  Thanks,

Alex
