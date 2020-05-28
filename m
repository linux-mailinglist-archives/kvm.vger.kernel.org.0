Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA41E5A6E
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgE1ILB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 04:11:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:64047 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgE1ILB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 04:11:01 -0400
IronPort-SDR: O73HATl/osg7jC3XExCSGdXpLhsuQ3PzJZgboL7i7LVVHJYEWiR/jFa3EVshg1IVjld/PEbnZ/
 ifzOSxTFpO2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 01:11:00 -0700
IronPort-SDR: bRgydiOtZ9X+tvZBEcFWcYWu54Zt+rX1J2USsgGjc8eh1+jjQqAJPCDIfAEtsekT/rDVTO77Ok
 B1JIGWLyQ/RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,444,1583222400"; 
   d="scan'208";a="291916623"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 28 May 2020 01:10:55 -0700
Date:   Thu, 28 May 2020 04:01:02 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, jonathan.davies@nutanix.com, eauger@redhat.com,
        aik@ozlabs.ru, pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200528080101.GD1378@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home>
 <20200525065925.GA698@joy-OptiPlex-7040>
 <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
 <20200526141939.2632f100@x1.home>
 <20200527062358.GD19560@joy-OptiPlex-7040>
 <20200527084822.GC3001@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527084822.GC3001@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > This is my understanding of the protocol as well, when the device is
> > > running, pending_bytes might drop to zero if no internal state has
> > > changed and may be non-zero on the next iteration due to device
> > > activity.  When the device is not running, pending_bytes reporting zero
> > > indicates the device is done, there is no further state to transmit.
> > > Does that meet your need/expectation?
> > >
> > (1) on one side, as in vfio_save_pending(),
> > vfio_save_pending()
> > {
> >     ...
> >     ret = vfio_update_pending(vbasedev);
> >     ...
> >     *res_precopy_only += migration->pending_bytes;
> >     ...
> > }
> > the pending_bytes tells migration thread how much data is still hold in
> > device side.
> > the device data includes
> > device internal data + running device dirty data + device state.
> > 
> > so the pending_bytes should include device state as well, right?
> > if so, the pending_bytes should never reach 0 if there's any device
> > state to be sent after device is stopped.
> 
> I hadn't expected the pending-bytes to include a fixed offset for device
> state (If you mean a few registers etc) - I'd expect pending to drop
> possibly to zero;  the heuristic as to when to switch from iteration to
> stop, is based on the total pending across all iterated devices; so it's
> got to be allowed to drop otherwise you'll never transition to stop.
> 
ok. got it.

> > (2) on the other side,
> > along side we updated the pending_bytes in vfio_save_pending() and
> > enter into the vfio_save_iterate(), if we repeatedly update
> > pending_bytes in vfio_save_iterate(), it would enter into a scenario
> > like
> > 
> > initially pending_bytes=500M.
> > vfio_save_iterate() -->
> >   round 1: transmitted 500M.
> >   round 2: update pending bytes, pending_bytes=50M (50M dirty data).
> >   round 3: update pending bytes, pending_bytes=50M.
> >   ...
> >   round N: update pending bytes, pending_bytes=50M.
> > 
> > If there're two vfio devices, the vfio_save_iterate() for the second device
> > may never get chance to be called because there's always pending_bytes
> > produced by the first device, even the size if small.
> 
> And between RAM and the vfio devices?

yes, is that right?

Thanks
Yan
