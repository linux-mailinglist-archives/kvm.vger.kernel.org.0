Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3766523B6FF
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgHDIsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 04:48:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:60171 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgHDIsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 04:48:14 -0400
IronPort-SDR: YmuqumWh7UdAdxPJ5gVB/hd72Ce/2Q6uQcgT0wS7YCOC9XLG/s5yJEO20wZFmMTMFBXWD8y5MR
 BhsBJtZazJtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="153441666"
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="153441666"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 01:48:14 -0700
IronPort-SDR: irc5RID6ULqLZNetmbd2upm83OlouI5asaiOG3qd3M8sRHo28+PjSLXy2Sis8HfsZ5nGDWBkND
 2wytEYurr0ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="330538296"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Aug 2020 01:48:09 -0700
Date:   Tue, 4 Aug 2020 16:37:08 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Sean Mooney <smooney@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Jason Wang <jasowang@redhat.com>,
        qemu-devel@nongnu.org, kwankhede@nvidia.com, eauger@redhat.com,
        xin-ran.wang@intel.com, corbet@lwn.net,
        openstack-discuss@lists.openstack.org, shaohe.feng@intel.com,
        kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200804083708.GA30485@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200716083230.GA25316@joy-OptiPlex-7040>
 <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
 <20200729131255.68730f68@x1.home>
 <20200730034104.GB32327@joy-OptiPlex-7040>
 <20200730112930.6f4c5762@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730112930.6f4c5762@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > yes, include a device_api field is better.
> > for mdev, "device_type=vfio-mdev", is it right?
> 
> No, vfio-mdev is not a device API, it's the driver that attaches to the
> mdev bus device to expose it through vfio.  The device_api exposes the
> actual interface of the vfio device, it's also vfio-pci for typical
> mdev devices found on x86, but may be vfio-ccw, vfio-ap, etc...  See
> VFIO_DEVICE_API_PCI_STRING and friends.
> 
ok. got it.

> > > > > 	device_id=8086591d  
> > > 
> > > Is device_id interpreted relative to device_type?  How does this
> > > relate to mdev_type?  If we have an mdev_type, doesn't that fully
> > > defined the software API?
> > >   
> > it's parent pci id for mdev actually.
>
> If we need to specify the parent PCI ID then something is fundamentally
> wrong with the mdev_type.  The mdev_type should define a unique,
> software compatible interface, regardless of the parent device IDs.  If
> a i915-GVTg_V5_2 means different things based on the parent device IDs,
> then then different mdev_types should be reported for those parent
> devices.
>
hmm, then do we allow vendor specific fields?
or is it a must that a vendor specific field should have corresponding
vendor attribute?

another thing is that the definition of mdev_type in GVT only corresponds
to vGPU computing ability currently,
e.g. i915-GVTg_V5_2, is 1/2 of a gen9 IGD, i915-GVTg_V4_2 is 1/2 of a
gen8 IGD.
It is too coarse-grained to live migration compatibility.

Do you think we need to update GVT's definition of mdev_type?
And is there any guide in mdev_type definition?

> > > > > 	mdev_type=i915-GVTg_V5_2  
> > > 
> > > And how are non-mdev devices represented?
> > >   
> > non-mdev can opt to not include this field, or as you said below, a
> > vendor signature. 
> > 
> > > > > 	aggregator=1
> > > > > 	pv_mode="none+ppgtt+context"  
> > > 
> > > These are meaningless vendor specific matches afaict.
> > >   
> > yes, pv_mode and aggregator are vendor specific fields.
> > but they are important to decide whether two devices are compatible.
> > pv_mode means whether a vGPU supports guest paravirtualized api.
> > "none+ppgtt+context" means guest can not use pv, or use ppgtt mode pv or
> > use context mode pv.
> > 
> > > > > 	interface_version=3  
> > > 
> > > Not much granularity here, I prefer Sean's previous
> > > <major>.<minor>[.bugfix] scheme.
> > >   
> > yes, <major>.<minor>[.bugfix] scheme may be better, but I'm not sure if
> > it works for a complicated scenario.
> > e.g for pv_mode,
> > (1) initially,  pv_mode is not supported, so it's pv_mode=none, it's 0.0.0,
> > (2) then, pv_mode=ppgtt is supported, pv_mode="none+ppgtt", it's 0.1.0,
> > indicating pv_mode=none can migrate to pv_mode="none+ppgtt", but not vice versa.
> > (3) later, pv_mode=context is also supported,
> > pv_mode="none+ppgtt+context", so it's 0.2.0.
> > 
> > But if later, pv_mode=ppgtt is removed. pv_mode="none+context", how to
> > name its version? "none+ppgtt" (0.1.0) is not compatible to
> > "none+context", but "none+ppgtt+context" (0.2.0) is compatible to
> > "none+context".
> 
> If pv_mode=ppgtt is removed, then the compatible versions would be
> 0.0.0 or 1.0.0, ie. the major version would be incremented due to
> feature removal.
>  
> > Maintain such scheme is painful to vendor driver.
> 
> Migration compatibility is painful, there's no way around that.  I
> think the version scheme is an attempt to push some of that low level
> burden on the vendor driver, otherwise the management tools need to
> work on an ever growing matrix of vendor specific features which is
> going to become unwieldy and is largely meaningless outside of the
> vendor driver.  Instead, the vendor driver can make strategic decisions
> about where to continue to maintain a support burden and make explicit
> decisions to maintain or break compatibility.  The version scheme is a
> simplification and abstraction of vendor driver features in order to
> create a small, logical compatibility matrix.  Compromises necessarily
> need to be made for that to occur.
>
ok. got it.

> > > > > COMPATIBLE:
> > > > > 	device_type=pci
> > > > > 	device_id=8086591d
> > > > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}    
> > > > this mixed notation will be hard to parse so i would avoid that.  
> > > 
> > > Some background, Intel has been proposing aggregation as a solution to
> > > how we scale mdev devices when hardware exposes large numbers of
> > > assignable objects that can be composed in essentially arbitrary ways.
> > > So for instance, if we have a workqueue (wq), we might have an mdev
> > > type for 1wq, 2wq, 3wq,... Nwq.  It's not really practical to expose a
> > > discrete mdev type for each of those, so they want to define a base
> > > type which is composable to other types via this aggregation.  This is
> > > what this substitution and tagging is attempting to accomplish.  So
> > > imagine this set of values for cases where it's not practical to unroll
> > > the values for N discrete types.
> > >   
> > > > > 	aggregator={val1}/2  
> > > 
> > > So the {val1} above would be substituted here, though an aggregation
> > > factor of 1/2 is a head scratcher...
> > >   
> > > > > 	pv_mode={val2:string:"none+ppgtt","none+context","none+ppgtt+context"}  
> > > 
> > > I'm lost on this one though.  I think maybe it's indicating that it's
> > > compatible with any of these, so do we need to list it?  Couldn't this
> > > be handled by Sean's version proposal where the minor version
> > > represents feature compatibility?  
> > yes, it's indicating that it's compatible with any of these.
> > Sean's version proposal may also work, but it would be painful for
> > vendor driver to maintain the versions when multiple similar features
> > are involved.
> 
> This is something vendor drivers need to consider when adding and
> removing features.
> 
> > > > > 	interface_version={val3:int:2,3}  
> > > 
> > > What does this turn into in a few years, 2,7,12,23,75,96,...
> > >   
> > is a range better?
> 
> I was really trying to point out that sparseness becomes an issue if
> the vendor driver is largely disconnected from how their feature
> addition and deprecation affects migration support.  Thanks,
>
ok. we'll use the x.y.z scheme then.

Thanks
Yan
