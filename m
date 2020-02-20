Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5C165663
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 05:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgBTEr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 23:47:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:53932 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbgBTEr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 23:47:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 20:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="283305850"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2020 20:47:55 -0800
Date:   Wed, 19 Feb 2020 23:38:35 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] vfio/type1: Reduce vfio_iommu.lock contention
Message-ID: <20200220043835.GB30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
 <20200117011050.GC1759@joy-OptiPlex-7040>
 <20200219090417.GA30338@joy-OptiPlex-7040>
 <20200219135247.42d18bb2@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219135247.42d18bb2@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 04:52:47AM +0800, Alex Williamson wrote:
> On Wed, 19 Feb 2020 04:04:17 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Fri, Jan 17, 2020 at 09:10:51AM +0800, Yan Zhao wrote:
> > > Thank you, Alex!
> > > I'll try it and let you know the result soon. :)
> > > 
> > > On Fri, Jan 17, 2020 at 02:17:49AM +0800, Alex Williamson wrote:  
> > > > Hi Yan,
> > > > 
> > > > I wonder if this might reduce the lock contention you're seeing in the
> > > > vfio_dma_rw series.  These are only compile tested on my end, so I hope
> > > > they're not too broken to test.  Thanks,
> > > > 
> > > > Alex
> > > > 
> > > > ---
> > > > 
> > > > Alex Williamson (3):
> > > >       vfio/type1: Convert vfio_iommu.lock from mutex to rwsem
> > > >       vfio/type1: Replace obvious read lock instances
> > > >       vfio/type1: Introduce pfn_list mutex
> > > > 
> > > > 
> > > >  drivers/vfio/vfio_iommu_type1.c |   67 ++++++++++++++++++++++++---------------
> > > >  1 file changed, 41 insertions(+), 26 deletions(-)
> > > >  
> > 
> > hi Alex
> > I have finished testing of this series.
> > It's quite stable and passed our MTBF testing :)
> > 
> > However, after comparing the performance data obtained from several
> > benchmarks in guests (see below),
> > it seems that this series does not bring in obvious benefit.
> > (at least to cases we have tested, and though I cannot fully explain it yet).
> > So, do you think it's good for me not to include this series into my next
> > version of "use vfio_dma_rw to read/write IOVAs from CPU side"?
> 
> Yes, I would not include it in your series.  No reason to bloat your
> series for a feature that doesn't clearly show an improvement.  Thanks
> for the additional testing, we can revive them if this lock ever
> resurfaces.  I'm was actually more hopeful that holding an external
> group reference might provide a better performance improvement, the
> lookup on every vfio_dma_rw is not very efficient.  Thanks,
> 
got it. thanks~

Yan
