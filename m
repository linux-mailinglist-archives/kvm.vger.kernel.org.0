Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4AE70E92
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 03:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbfGWBSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 21:18:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfGWBSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 21:18:34 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61796308A968;
        Tue, 23 Jul 2019 01:18:33 +0000 (UTC)
Received: from x1.home (ovpn-116-35.phx2.redhat.com [10.3.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F838600C8;
        Tue, 23 Jul 2019 01:18:30 +0000 (UTC)
Date:   Mon, 22 Jul 2019 19:18:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "Lu, Kechen" <kechen.lu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190722191830.425d1593@x1.home>
In-Reply-To: <237F54289DF84E4997F34151298ABEBC876BC9AD@SHSMSX101.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
        <20190718155640.25928-3-kechen.lu@intel.com>
        <20190719102516.60af527f@x1.home>
        <31185F57AF7C4B4F87C41E735C23A6FE64E06F@shsmsx102.ccr.corp.intel.com>
        <20190722134124.16c55c2f@x1.home>
        <237F54289DF84E4997F34151298ABEBC876BC9AD@SHSMSX101.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 23 Jul 2019 01:18:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jul 2019 01:08:19 +0000
"Zhang, Tina" <tina.zhang@intel.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Tuesday, July 23, 2019 3:41 AM
> > To: Lu, Kechen <kechen.lu@intel.com>
> > Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> > kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan
> > <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian, Kevin
> > <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> > Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
> > 
> > On Mon, 22 Jul 2019 05:28:35 +0000
> > "Lu, Kechen" <kechen.lu@intel.com> wrote:
> >   
> > > Hi,
> > >  
> > > > -----Original Message-----
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Saturday, July 20, 2019 12:25 AM
> > > > To: Lu, Kechen <kechen.lu@intel.com>
> > > > Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> > > > kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> > > > kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan
> > > > <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian,
> > > > Kevin <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> > > > Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq
> > > > type
> > > >
> > > > On Thu, 18 Jul 2019 23:56:36 +0800
> > > > Kechen Lu <kechen.lu@intel.com> wrote:
> > > >  
> > > > > From: Tina Zhang <tina.zhang@intel.com>
> > > > >
> > > > > Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> > > > > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display
> > > > >
> > > > > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > > > > ---
> > > > >  include/uapi/linux/vfio.h | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > > index be6adab4f759..df28b17a6e2e 100644
> > > > > --- a/include/uapi/linux/vfio.h
> > > > > +++ b/include/uapi/linux/vfio.h
> > > > > @@ -469,6 +469,9 @@ struct vfio_irq_info_cap_type {
> > > > >  	__u32 subtype;  /* type specific */  };
> > > > >
> > > > > +#define VFIO_IRQ_TYPE_GFX				(1)
> > > > > +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
> > > > > +  
> > > >
> > > > Please include a description defining exactly what this IRQ is intended to  
> > signal.  
> > > > For instance, if another vGPU vendor wanted to implement this in
> > > > their driver and didn't have the QEMU code for reference to what it
> > > > does with the IRQ, what would they need to know?  Thanks,
> > > >
> > > > Alex
> > > >  
> > >
> > > Yes, that makes more sense. I'll add the description for it at next version  
> > patch.  
> > >
> > > BTW, may I have one more question? In the current design ideas, we
> > > partitioned the vGPU display eventfd counted 8-byte value into at most
> > > 8 events to deliver multiple display events, so we need different
> > > increasement counter value to differentiate the events. As this is the
> > > exposed thing the QEMU has to know, we plan adds a macro here
> > > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_EVENTFD_BASE_SHIFT to make sure  
> > the  
> > > partitions shift in 1 byte, does it make sense putting here? Looking forward  
> > to your and Gerd's comments. Thanks!
> > 
> > Couldn't you expose this as another capability within the IRQ_INFO return
> > data?  If you were to define it as a macro, I assume that means it would be
> > hard coded, in which case this probably becomes an Intel specific IRQ, rather
> > than what appears to be framed as a generic graphics IRQ extension.  A new
> > capability could instead allow the vendor to specify their own value, where
> > we could define how userspace should interpret and make use of this value.
> > Thanks,  
> Good suggestion. Currently, vfio_irq_info is used to save one irq
> info. What we need here is to use it to save several events info.
> Maybe we could figure out a general layout of this capability so that
> it can be leveraged by others, not only for display irq/events.

You could also expose a device specific IRQ with count > 1 (ie. similar
to MSI/X) and avoid munging the eventfd value, which is not something
we do elsewhere, at least in vfio.  Thanks,

Alex
