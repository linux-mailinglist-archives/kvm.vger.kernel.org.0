Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F614396DF
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhJYNBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:01:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:27939 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhJYNBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 09:01:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10147"; a="229913159"
X-IronPort-AV: E=Sophos;i="5.87,180,1631602800"; 
   d="scan'208";a="229913159"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 05:58:52 -0700
X-IronPort-AV: E=Sophos;i="5.87,180,1631602800"; 
   d="scan'208";a="571607199"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 05:58:47 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mezYX-000cfz-I6;
        Mon, 25 Oct 2021 15:58:25 +0300
Date:   Mon, 25 Oct 2021 15:58:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Patrick Williams <patrick@stwcx.xyz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Zev Weiss <zev@bewilderbeest.net>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Rajat Jain <rajatja@google.com>,
        Jianxiong Gao <jxgao@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Saravana Kannan <saravanak@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        openbmc@lists.ozlabs.org, devicetree@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Jeffery <andrew@aj.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 4/5] driver core: inhibit automatic driver binding on
 reserved devices
Message-ID: <YXap8V/jMM3Ksj7x@smile.fi.intel.com>
References: <20211022020032.26980-1-zev@bewilderbeest.net>
 <20211022020032.26980-5-zev@bewilderbeest.net>
 <YXJeYCFJ5DnBB63R@kroah.com>
 <YXJ3IPPkoLxqXiD3@hatter.bewilderbeest.net>
 <YXJ88eARBE3vU1aA@kroah.com>
 <YXLWMyleiTFDDZgm@heinlein>
 <YXPOSZPA41f+EUvM@kroah.com>
 <627101ee-7414-57d1-9952-6e023b8db317@gmail.com>
 <YXZLjTvGevAXcidW@kroah.com>
 <YXaYmie/CUHnixtX@heinlein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXaYmie/CUHnixtX@heinlein>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 06:44:26AM -0500, Patrick Williams wrote:
> On Mon, Oct 25, 2021 at 08:15:41AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Oct 25, 2021 at 12:38:08AM -0500, Frank Rowand wrote:
> > > On 10/23/21 3:56 AM, Greg Kroah-Hartman wrote:
>  
> > We have the bind/unbind ability today, from userspace, that can control
> > this.  Why not just have Linux grab the device when it boots, and then
> > when userspace wants to "give the device up", it writes to "unbind" in
> > sysfs, and then when all is done, it writes to the "bind" file and then
> > Linux takes back over.
> > 
> > Unless for some reason Linux should _not_ grab the device when booting,
> > then things get messier, as we have seen in this thread.
> 
> This is probably more typical on a BMC than atypical.  The systems often require
> the BMC (running Linux) to be able to reboot independently from the managed host
> (running anything).  In the example Zev gave, the BMC rebooting would rip away
> the BIOS chip from the running host.
> 
> The BMC almost always needs to come up in a "I don't know what could possibly be
> going on in the system" state and re-discover where the system was left off.

Isn't it an architectural issue then?

-- 
With Best Regards,
Andy Shevchenko


