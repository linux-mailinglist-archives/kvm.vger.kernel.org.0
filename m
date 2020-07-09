Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB5219A10
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 09:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGIHe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 03:34:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:6929 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIHe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 03:34:28 -0400
IronPort-SDR: ingPK0Kpk/rgKwctWDZkJqfMeZ/SgxIN4xKja1dRVBX+AZ8+BmVuqekqj73ctpiOUj5ATL1jSA
 9U4b8S8WhkdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="136180512"
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="136180512"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 00:34:27 -0700
IronPort-SDR: f/eYnhavZCn1yjv9xOCAJdG710/TGGtn9AGr/1GgIHabbiv1OTckeOG6XwvFLd9Z1w+XpwSLFX
 6zMECFhaP12g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="483699986"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jul 2020 00:34:25 -0700
Date:   Thu, 9 Jul 2020 15:23:34 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200709072334.GA26155@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200408055824.2378-1-zhenyuw@linux.intel.com>
 <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200707190634.4d9055fe@x1.home>
 <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200708124806.058e33d9@x1.home>
 <MWHPR11MB1645C5033CB813EBD72CE4FD8C640@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645C5033CB813EBD72CE4FD8C640@MWHPR11MB1645.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 02:53:05AM +0000, Tian, Kevin wrote:

<...>
> > We also can't even seem to agree that type is a necessary requirement
> > for compatibility.  Your discussion below of a type-A, which is
> > equivalent to a type-B w/ aggregation set to some value is an example
> > of this.  We might also have physical devices with extensions to
> > support migration.  These could possibly be compatible with full mdev
> > devices.  We have no idea how an administrative tool would discover
> > this other than an exhaustive search across every possible target.
> > That's ugly but feasible when considering a single target host, but
> > completely untenable when considering a datacenter.
> 
> If exhaustive search can be done just one-off to build the compatibility
> database for all assignable devices on each node, then it might be
> still tenable in datacenter?
yes, Alex, do you think below behavior to build compatibility database is
acceptable?

management stack could do the exhaustive search in one shot to build the
compatibility database for all devices in every node. Meanwhile, it caches
migration version strings for all tested devices.
when there's a newly created/attached device, management stack could write
every cached strings to migration version attribute of the newly
created/attached device in order to update the migration compatibility
database. Then it caches the migration version string of the newly
created/attached device as well.
once a device attribute is modified, e.g. after changing its aggregation
count or updating its parent driver, update its cached migration version
string and update the compatibility database by testing against migration
version attribute of this device.


Thanks
Yan
