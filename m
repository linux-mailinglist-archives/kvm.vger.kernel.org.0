Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4A722E6A9
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 09:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgG0Hfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 03:35:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:50149 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgG0Hfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 03:35:45 -0400
IronPort-SDR: i+RsR8zaNm7rLl4VjwSk1N3Fj8rgVj/H2zXOHsHzebfcFg7A160xlHQn2kodmdlhJ6l7yUw+oI
 1No9h3Ux6vUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="148444271"
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="148444271"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 00:35:45 -0700
IronPort-SDR: 0ffjI+i+TsbheWV9B1ekyPjpDXDKX5V9QqFeMTIOUgqFnBjB7356oNacj5t1wADBNDmVTD6CU1
 TSX+YyW3cBSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="364039470"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 27 Jul 2020 00:35:38 -0700
Date:   Mon, 27 Jul 2020 15:24:40 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, cohuck@redhat.com, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200727072440.GA28676@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
 <20200716083230.GA25316@joy-OptiPlex-7040>
 <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721005113.GA10502@joy-OptiPlex-7040>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > As you indicate, the vendor driver is responsible for checking version
> > information embedded within the migration stream.  Therefore a
> > migration should fail early if the devices are incompatible.  Is it
> but as I know, currently in VFIO migration protocol, we have no way to
> get vendor specific compatibility checking string in migration setup stage
> (i.e. .save_setup stage) before the device is set to _SAVING state.
> In this way, for devices who does not save device data in precopy stage,
> the migration compatibility checking is as late as in stop-and-copy
> stage, which is too late.
> do you think we need to add the getting/checking of vendor specific
> compatibility string early in save_setup stage?
>
hi Alex,
after an offline discussion with Kevin, I realized that it may not be a
problem if migration compatibility check in vendor driver occurs late in
stop-and-copy phase for some devices, because if we report device
compatibility attributes clearly in an interface, the chances for
libvirt/openstack to make a wrong decision is little.
so, do you think we are now arriving at an agreement that we'll give up
the read-and-test scheme and start to defining one interface (perhaps in
json format), from which libvirt/openstack is able to parse and find out
compatibility list of a source mdev/physical device?

Thanks
Yan
