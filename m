Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087487FAE6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 15:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406174AbfHBNfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 09:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36735 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406126AbfHBNfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 09:35:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FA03882F2;
        Fri,  2 Aug 2019 13:35:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-81.ams2.redhat.com [10.36.116.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB2A860C47;
        Fri,  2 Aug 2019 13:35:32 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id DCD6916E05; Fri,  2 Aug 2019 15:35:31 +0200 (CEST)
Date:   Fri, 2 Aug 2019 15:35:31 +0200
From:   "kraxel@redhat.com" <kraxel@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Zhang, Tina" <tina.zhang@intel.com>,
        "Lu, Kechen" <kechen.lu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190802133531.4zwsjltvjisq4sfz@sirius.home.kraxel.org>
References: <20190718155640.25928-1-kechen.lu@intel.com>
 <20190718155640.25928-3-kechen.lu@intel.com>
 <20190719102516.60af527f@x1.home>
 <31185F57AF7C4B4F87C41E735C23A6FE64E06F@shsmsx102.ccr.corp.intel.com>
 <20190722134124.16c55c2f@x1.home>
 <237F54289DF84E4997F34151298ABEBC876BC9AD@SHSMSX101.ccr.corp.intel.com>
 <20190722191830.425d1593@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722191830.425d1593@x1.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 02 Aug 2019 13:35:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > > Couldn't you expose this as another capability within the IRQ_INFO return
> > > data?  If you were to define it as a macro, I assume that means it would be
> > > hard coded, in which case this probably becomes an Intel specific IRQ, rather
> > > than what appears to be framed as a generic graphics IRQ extension.  A new
> > > capability could instead allow the vendor to specify their own value, where
> > > we could define how userspace should interpret and make use of this value.
> > > Thanks,  
> > Good suggestion. Currently, vfio_irq_info is used to save one irq
> > info. What we need here is to use it to save several events info.
> > Maybe we could figure out a general layout of this capability so that
> > it can be leveraged by others, not only for display irq/events.
> 
> You could also expose a device specific IRQ with count > 1 (ie. similar
> to MSI/X) and avoid munging the eventfd value, which is not something
> we do elsewhere, at least in vfio.  Thanks,

Well, the basic idea is to use the eventfd value to signal the kind of
changes which did happen, simliar to IRQ status register bits.

So, when the guest changes the primary plane, the mdev driver notes
this.  Same with the cursor plane.  On vblank (when the guests update
is actually applied) the mdev driver wakes the eventfd and uses eventfd
value to signal whenever primary plane or cursor plane or both did
change.

Then userspace knows which planes need an update without an extra
VFIO_DEVICE_QUERY_GFX_PLANE roundtrip to the kernel.

Alternatively we could have one eventfd for each change type.  But given
that these changes are typically applied at the same time (vblank) we
would have multiple eventfds being signaled at the same time.  Which
doesn't look ideal to me ...

cheers,
  Gerd

