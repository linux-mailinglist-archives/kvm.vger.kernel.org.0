Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B622217DBD
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 05:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgGHDtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 23:49:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:60573 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgGHDtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 23:49:39 -0400
IronPort-SDR: rcSMqIbHYADQMGg7i7SM92vw4kADQ1O8GVGdjlYOJ/Tmu+ZP9izrX+bUWvD/y1R4EcIB6wIved
 d7jms/mJpWHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="147740710"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="147740710"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 20:49:38 -0700
IronPort-SDR: ED0kLdDbgT5Umbh0ovHrUHXgJ7OjjtOYtlyuFZOoad60pnHIMEzu1T0y8kedt2dYbez1U1BBpx
 YMQjmFrKUbUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="305894597"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jul 2020 20:49:36 -0700
Date:   Wed, 8 Jul 2020 11:38:46 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200708033845.GB20022@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200408055824.2378-1-zhenyuw@linux.intel.com>
 <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200707190634.4d9055fe@x1.home>
 <20200708015419.GM27035@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708015419.GM27035@zhen-hp.sh.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 09:54:19AM +0800, Zhenyu Wang wrote:
> On 2020.07.07 19:06:34 -0600, Alex Williamson wrote:
> > On Tue, 7 Jul 2020 23:28:39 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > 
> > > Hi, Alex, 
> > > 
> > > Gentle ping... Please let us know whether this version looks good.
> > 
> > I figured this is entangled with the versioning scheme.  There are
> > unanswered questions about how something that assumes a device of a
> > given type is software compatible to another device of the same type
> > handles aggregation and how the type class would indicate compatibility
> > with an aggregated instance.  Thanks,
> > 
> 
> +Yan
> 
> Alex, If no concern on aggregated resources info for instance that would
> be vendor's behavior to determine what type of resources would be aggregated,
> then I'll check with Yan to see how to fulfill this during migration.
> 
> Thanks
>

hi zhenyu and Alex
currently in this series, it looks that aggregated instances are created
in this way:
    echo "<uuid>,aggregate=10" > create

Is that possible that we change it like that:
1. provide a separate attribute named "aggregator" under mdev type.
  |- [parent physical device]
  |--- Vendor-specific-attributes [optional]
  |--- [mdev_supported_types]
  |     |--- [<type-id>]
  |     |   |--- create
+ |     |   |--- aggregator
  |     |   |--- name
  |     |   |--- available_instances
  |     |   |--- device_api
  |     |   |--- description
  |     |   |--- [devices]

normally, the aggregator is read as 0.


2. when we want to create an aggregated instance, we first echo the count
into the aggregator attribute. e.g.
   echo 10 > aggregator
It will switch the mdev type to 10 x original_type. And then,
available_instances and description would be updated accordingly.

3. do the real mdev creation.
   echo <uuid> > create


In this way, before any instance is created, we can use the
migration_version attribute to test if two aggregation mdevs are
migration compatible.

Thanks
Yan


