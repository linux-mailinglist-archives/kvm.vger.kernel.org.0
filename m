Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6A16400A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 10:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgBSJNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 04:13:40 -0500
Received: from mga04.intel.com ([192.55.52.120]:29897 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgBSJNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 04:13:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 01:13:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="315339832"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 19 Feb 2020 01:13:38 -0800
Date:   Wed, 19 Feb 2020 04:04:17 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] vfio/type1: Reduce vfio_iommu.lock contention
Message-ID: <20200219090417.GA30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <157919849533.21002.4782774695733669879.stgit@gimli.home>
 <20200117011050.GC1759@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117011050.GC1759@joy-OptiPlex-7040>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 17, 2020 at 09:10:51AM +0800, Yan Zhao wrote:
> Thank you, Alex!
> I'll try it and let you know the result soon. :)
> 
> On Fri, Jan 17, 2020 at 02:17:49AM +0800, Alex Williamson wrote:
> > Hi Yan,
> > 
> > I wonder if this might reduce the lock contention you're seeing in the
> > vfio_dma_rw series.  These are only compile tested on my end, so I hope
> > they're not too broken to test.  Thanks,
> > 
> > Alex
> > 
> > ---
> > 
> > Alex Williamson (3):
> >       vfio/type1: Convert vfio_iommu.lock from mutex to rwsem
> >       vfio/type1: Replace obvious read lock instances
> >       vfio/type1: Introduce pfn_list mutex
> > 
> > 
> >  drivers/vfio/vfio_iommu_type1.c |   67 ++++++++++++++++++++++++---------------
> >  1 file changed, 41 insertions(+), 26 deletions(-)
> >

hi Alex
I have finished testing of this series.
It's quite stable and passed our MTBF testing :)

However, after comparing the performance data obtained from several
benchmarks in guests (see below),
it seems that this series does not bring in obvious benefit.
(at least to cases we have tested, and though I cannot fully explain it yet).
So, do you think it's good for me not to include this series into my next
version of "use vfio_dma_rw to read/write IOVAs from CPU side"?


B: stands for baseline code, where mutex is used for vfio_iommu.lock
B+S: applied rwsem patches to convert vfio_iommu.lock from mutex to
rwsem.

==== comparison: benchmark scores ====
(1) with 1 VM:

 score  |     glmark2    |   lightsmark    |   openarena
-----------------------------------------------------------
      B | 1248 (100%)    | 219.70 (100%)   | 114.9 (100%)
    B+S | 1252 (100.3%)  | 222.76 (101.2%) | 114.8 ( 99.9%)


(2) with 2 VMs:

 score  |     glmark2    |   lightsmark    |   openarena                                       
-----------------------------------------------------------                                    
      B | 812   (100%)   | 211.46 (100%)   | 115.3 (100%)                                      
    B+S | 812.8 (100.1%) | 212.96 (100.7%) | 114.9 (99.6%) 


==== comparison: average cycles spent on vfio_iommu.lock =====
(1) with 1 VM:

 cycles | glmark2   | lightsmark | openarena | VM boot up
---------------------------------------------------------
      B | 107       | 113        | 110       | 107
    B+S | 112 (+5)  | 111  (-2)  | 108 (-2)  | 104 (-3)

Note:
a. during VM boot up, for rwsem, there are 24921 reads vs 67 writes
(372:1)
b. for the mesured 3 benchmarks, no write for rwsem.


(2) with 2 VMs:

 cycles | glmark2   | lightsmark | openarena | VM boot up
----------------------------------------------------------
      B | 113       | 119        | 112       | 119
    B+S | 118 (+5)  | 138  (+19) | 110 (-2)  | 114 (-5)


similar results obtained after applying patches of vfio_dma_rw.

B: stands for baseline code, where mutex is used for vfio_iommu.lock
B+V: baseline code + patches to convert from using kvm_read/write_guest
to using vfio_dma_rw
B+V+S: baseline code + patches to using vfio_dma_rw + patches to use
rwsem

==== comparison: benchmark scores =====
(1) with 1 VM:

 score  |     glmark2    |   lightsmark    |   openarena
----------------------------------------------------------
    B+V | 1244 (100%)    | 222.18 (100%)   | 114.4 (100%)
  B+V+S | 1241 ( 99.8%)  | 223.90 (100.8%) | 114.6 (100.2%)

(2) with 2 VMs:

        |     glmark2    |   lightsmark    |   openarena
----------------------------------------------------------
    B+V | 811.2 (100%)   | 211.20 (100%)   | 115.4 (100%)
  B+V+S | 811   (99.98%) | 211.81 (100.3%) | 115.5 (100.1%)


==== comparison: average cycles spent on vfio_dma_rw =====
(1) with 1 VM:

cycles  |    glmark2  | lightsmark | openarena
--------------------------------------------------
    B+V | 1396        | 1592       | 1351 
  B+V+S | 1415 (+19 ) | 1650 (+58) | 1357 (+6)

(2) with 2 VMs:

cycles  |    glmark2  | lightsmark | openarena
--------------------------------------------------
    B+V | 1974        | 2024       | 1636
  B+V+S | 1979 (+5)   | 2051 (+27) | 1644 (+8)


==== comparison: average cycles spent on vfio_iommu.lock =====
(1) with 1 VM:

 cycles | glmark2   | lightsmark | openarena | VM boot up
---------------------------------------------------------
    B+V | 137       | 139        | 156       | 124
  B+V+S | 142 (+5)  | 143 (+4)   | 149 (-7)  | 114 (-10)

(2) with 2 VMs:

 cycles | glmark2   | lightsmark | openarena | VM boot up
---------------------------------------------------------
    B+V | 153       | 148        | 146       | 111
  B+V+S | 155 (+2)  | 157 (+9)   | 156 (+10) | 118 (+7)


P.S.
You may find some inconsistency when comparing to the test result I sent
at https://lkml.org/lkml/2020/1/14/1486. It is because I had to changed
my test machine for personal reason and also because I made lightsmark not
to sync on vblank events.


Thanks
Yan


