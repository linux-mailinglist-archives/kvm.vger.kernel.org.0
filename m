Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4510421ACEA
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 04:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGJCJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 22:09:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:5410 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgGJCJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 22:09:42 -0400
IronPort-SDR: 3fdhK9aaNCw4NsCOdLacmELgKDbGcP5nU26VA/BsOnKu4ObdaoVKqD/h1pwHTMMiK/DOScJ593
 KoaLDhCuBLQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="148126304"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="148126304"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 19:09:42 -0700
IronPort-SDR: sy34eng3Rc29njdTX5UioJU1Xs+Y7uzRLHWtCTziJEsEeQqw37C7jMKZZybtJfHvNIhE0trrp5
 R1fcGh4lSWPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="267575422"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jul 2020 19:09:40 -0700
Date:   Fri, 10 Jul 2020 09:58:49 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200710015849.GA29271@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200408055824.2378-1-zhenyuw@linux.intel.com>
 <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200707190634.4d9055fe@x1.home>
 <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200708124806.058e33d9@x1.home>
 <MWHPR11MB1645C5033CB813EBD72CE4FD8C640@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200709072334.GA26155@joy-OptiPlex-7040>
 <20200709142226.5194a4f4@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709142226.5194a4f4@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 02:22:26PM -0600, Alex Williamson wrote:
> On Thu, 9 Jul 2020 15:23:34 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, Jul 09, 2020 at 02:53:05AM +0000, Tian, Kevin wrote:
> > 
> > <...>
> > > > We also can't even seem to agree that type is a necessary requirement
> > > > for compatibility.  Your discussion below of a type-A, which is
> > > > equivalent to a type-B w/ aggregation set to some value is an example
> > > > of this.  We might also have physical devices with extensions to
> > > > support migration.  These could possibly be compatible with full mdev
> > > > devices.  We have no idea how an administrative tool would discover
> > > > this other than an exhaustive search across every possible target.
> > > > That's ugly but feasible when considering a single target host, but
> > > > completely untenable when considering a datacenter.  
> > > 
> > > If exhaustive search can be done just one-off to build the compatibility
> > > database for all assignable devices on each node, then it might be
> > > still tenable in datacenter?  
> > yes, Alex, do you think below behavior to build compatibility database is
> > acceptable?
> > 
> > management stack could do the exhaustive search in one shot to build the
> > compatibility database for all devices in every node. Meanwhile, it caches
> > migration version strings for all tested devices.
> > when there's a newly created/attached device, management stack could write
> > every cached strings to migration version attribute of the newly
> > created/attached device in order to update the migration compatibility
> > database. Then it caches the migration version string of the newly
> > created/attached device as well.
> > once a device attribute is modified, e.g. after changing its aggregation
> > count or updating its parent driver, update its cached migration version
> > string and update the compatibility database by testing against migration
> > version attribute of this device.
> 
> This is exactly the scenario that I think is untenable.  You're asking
> a management application to keep a live database of the opaque version
> string of every device type and likely every instance of a device,
> which it's not allowed to compare on its own, it can only pipe them
if management stack is allowed to compare on its own, then the migration
version strings have to be standardized.

But it's a little hard to do it.
e.g. 
for GVT, string format can be
"parent device PCI ID" + "version of gvt driver" + "mdev type" +
"aggregator count".

for an NVMe VF connecting to a remote storage. it is
"PCI ID" + "driver version" + "configured remote storage URL"

for a QAT VF, it's
"PCI ID" + "driver version" + "supported encryption set".

The management stack also needs to understand how to compare those
strings, which is also hard. e.g.
two device with different PCI IDs are incompatible initially, but later
because of software upgrade, they are compatible again.


> through to every other device across the datacenter to determine which
> are comparable.  It would need to respond to not only devices being
> added and removed, but bound and unbound from drivers, and entire nodes
> being added and removed.  That seems like a lot of overhead, in
those responses are also required if the management stack wants to
compare on its own, right?

> addition to the effect of essentially fuzzing the version interface
> across all vendors and types.  We need a better solution or we need
> someone from openstack and ovirt to agree that this is more viable than
> I suspect. Thanks
before we have a better solution, do you think it's good to ask people
from openstack and ovirt first? what if the problem is not as complicated
as we thought?

Thanks
Yan

 
