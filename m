Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1A232A9E
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 05:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgG3DwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 23:52:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:22022 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG3DwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 23:52:11 -0400
IronPort-SDR: IxtewTcxrzbNwQDEg6C6cYdC1UGCJRGLHA+GCWvc2vDLsQ1atZMI1C5VNTMAD0ShNA8EsP6yE4
 q7SclfCMBJYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="216018662"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="216018662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 20:52:09 -0700
IronPort-SDR: wCVXUi52RSNYU58EwEHpLTFB0/ocevtJHeoHQW/8C90+mYxaC0XfoXmfyyjv+KCupn49suGdPg
 m0YiXPBAohSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="465098188"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 29 Jul 2020 20:52:03 -0700
Date:   Thu, 30 Jul 2020 11:41:04 +0800
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
Message-ID: <20200730034104.GB32327@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
 <20200716083230.GA25316@joy-OptiPlex-7040>
 <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
 <20200729131255.68730f68@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729131255.68730f68@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 01:12:55PM -0600, Alex Williamson wrote:
> On Wed, 29 Jul 2020 12:28:46 +0100
> Sean Mooney <smooney@redhat.com> wrote:
> 
> > On Wed, 2020-07-29 at 16:05 +0800, Yan Zhao wrote:
> > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:  
> > > > On Mon, 27 Jul 2020 15:24:40 +0800
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >   
> > > > > > > As you indicate, the vendor driver is responsible for checking version
> > > > > > > information embedded within the migration stream.  Therefore a
> > > > > > > migration should fail early if the devices are incompatible.  Is it    
> > > > > > 
> > > > > > but as I know, currently in VFIO migration protocol, we have no way to
> > > > > > get vendor specific compatibility checking string in migration setup stage
> > > > > > (i.e. .save_setup stage) before the device is set to _SAVING state.
> > > > > > In this way, for devices who does not save device data in precopy stage,
> > > > > > the migration compatibility checking is as late as in stop-and-copy
> > > > > > stage, which is too late.
> > > > > > do you think we need to add the getting/checking of vendor specific
> > > > > > compatibility string early in save_setup stage?
> > > > > >    
> > > > > 
> > > > > hi Alex,
> > > > > after an offline discussion with Kevin, I realized that it may not be a
> > > > > problem if migration compatibility check in vendor driver occurs late in
> > > > > stop-and-copy phase for some devices, because if we report device
> > > > > compatibility attributes clearly in an interface, the chances for
> > > > > libvirt/openstack to make a wrong decision is little.  
> > > > 
> > > > I think it would be wise for a vendor driver to implement a pre-copy
> > > > phase, even if only to send version information and verify it at the
> > > > target.  Deciding you have no device state to send during pre-copy does
> > > > not mean your vendor driver needs to opt-out of the pre-copy phase
> > > > entirely.  Please also note that pre-copy is at the user's discretion,
> > > > we've defined that we can enter stop-and-copy at any point, including
> > > > without a pre-copy phase, so I would recommend that vendor drivers
> > > > validate compatibility at the start of both the pre-copy and the
> > > > stop-and-copy phases.
> > > >   
> > > 
> > > ok. got it!
> > >   
> > > > > so, do you think we are now arriving at an agreement that we'll give up
> > > > > the read-and-test scheme and start to defining one interface (perhaps in
> > > > > json format), from which libvirt/openstack is able to parse and find out
> > > > > compatibility list of a source mdev/physical device?  
> > > > 
> > > > Based on the feedback we've received, the previously proposed interface
> > > > is not viable.  I think there's agreement that the user needs to be
> > > > able to parse and interpret the version information.  Using json seems
> > > > viable, but I don't know if it's the best option.  Is there any
> > > > precedent of markup strings returned via sysfs we could follow?  
> > > 
> > > I found some examples of using formatted string under /sys, mostly under
> > > tracing. maybe we can do a similar implementation.
> > > 
> > > #cat /sys/kernel/debug/tracing/events/kvm/kvm_mmio/format
> > > 
> > > name: kvm_mmio
> > > ID: 32
> > > format:
> > >         field:unsigned short common_type;       offset:0;       size:2; signed:0;
> > >         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
> > >         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
> > >         field:int common_pid;   offset:4;       size:4; signed:1;
> > > 
> > >         field:u32 type; offset:8;       size:4; signed:0;
> > >         field:u32 len;  offset:12;      size:4; signed:0;
> > >         field:u64 gpa;  offset:16;      size:8; signed:0;
> > >         field:u64 val;  offset:24;      size:8; signed:0;
> > > 
> > > print fmt: "mmio %s len %u gpa 0x%llx val 0x%llx", __print_symbolic(REC->type, { 0, "unsatisfied-read" }, { 1, "read"
> > > }, { 2, "write" }), REC->len, REC->gpa, REC->val
> > >   
> > this is not json fromat and its not supper frendly to parse.
> > > 
> > > #cat /sys/devices/pci0000:00/0000:00:02.0/uevent
> > > DRIVER=vfio-pci
> > > PCI_CLASS=30000
> > > PCI_ID=8086:591D
> > > PCI_SUBSYS_ID=8086:2212
> > > PCI_SLOT_NAME=0000:00:02.0
> > > MODALIAS=pci:v00008086d0000591Dsv00008086sd00002212bc03sc00i00
> > >   
> > this is ini format or conf formant 
> > this is pretty simple to parse whichi would be fine.
> > that said you could also have a version or capablitiy directory with a file
> > for each key and a singel value.
> > 
> > i would prefer to only have to do one read personally the list the files in
> > directory and then read tehm all ot build the datastucture myself but that is
> > doable though the simple ini format use d for uevent seams the best of 3 options
> > provided above.
> > > > 
> > > > Your idea of having both a "self" object and an array of "compatible"
> > > > objects is perhaps something we can build on, but we must not assume
> > > > PCI devices at the root level of the object.  Providing both the
> > > > mdev-type and the driver is a bit redundant, since the former includes
> > > > the latter.  We can't have vendor specific versioning schemes though,
> > > > ie. gvt-version. We need to agree on a common scheme and decide which
> > > > fields the version is relative to, ex. just the mdev type?  
> > > 
> > > what about making all comparing fields vendor specific?
> > > userspace like openstack only needs to parse and compare if target
> > > device is within source compatible list without understanding the meaning
> > > of each field.  
> > that kind of defeats the reason for having them be be parsable.
> > the reason openstack want to be able to understand the capablitys is so
> > we can staticaly declare the capablit of devices ahead of time on so our schduler
> > can select host based on that. is the keys and data are opaquce to userspace
> > becaue they are just random vendor sepecific blobs we cant do that.
> 
> Agreed, I'm not sure I'm willing to rule out that there could be vendor
> specific direct match fields, as I included in my example earlier in
> the thread, but entirely vendor specific defeats much of the purpose
> here.
> 
> > > > I had also proposed fields that provide information to create a
> > > > compatible type, for example to create a type_x2 device from a type_x1
> > > > mdev type, they need to know to apply an aggregation attribute.  If we
> > > > need to explicitly list every aggregation value and the resulting type,
> > > > I think we run aground of what aggregation was trying to avoid anyway,
> > > > so we might need to pick a language that defines variable substitution
> > > > or some kind of tagging.  For example if we could define ${aggr} as an
> > > > integer within a specified range, then we might be able to define a type
> > > > relative to that value (type_x${aggr}) which requires an aggregation
> > > > attribute using the same value.  I dunno, just spit balling.  Thanks,  
> > > 
> > > what about a migration_compatible attribute under device node like
> > > below?  
> > rather then listing comaptiable devices it would be better if you could declaritivly 
> > list the feature supported and we could compare those along with a simple semver version string.
> > > 
> > > #cat /sys/bus/pci/devices/0000\:00\:02.0/UUID1/migration_compatible
> 
> Note that we're defining compatibility relative to a vfio migration
> interface, so we should include that in the name, we don't know what
> other migration interfaces might exist.
do you mean we need to name it as vfio_migration, e.g.
 /sys/bus/pci/devices/0000\:00\:02.0/UUID1/vfio_migration ?
> 
> > > SELF:
> > > 	device_type=pci
> 
> Why not the device_api here, ie. vfio-pci.  The device doesn't provide
> a pci interface directly, it's wrapped in a vfio API.
> 
the device_type is to indicate below device_id is a pci id.

yes, include a device_api field is better.
for mdev, "device_type=vfio-mdev", is it right?

> > > 	device_id=8086591d
> 
> Is device_id interpreted relative to device_type?  How does this
> relate to mdev_type?  If we have an mdev_type, doesn't that fully
> defined the software API?
> 
it's parent pci id for mdev actually.


> > > 	mdev_type=i915-GVTg_V5_2
> 
> And how are non-mdev devices represented?
> 
non-mdev can opt to not include this field, or as you said below, a
vendor signature. 

> > > 	aggregator=1
> > > 	pv_mode="none+ppgtt+context"
> 
> These are meaningless vendor specific matches afaict.
> 
yes, pv_mode and aggregator are vendor specific fields.
but they are important to decide whether two devices are compatible.
pv_mode means whether a vGPU supports guest paravirtualized api.
"none+ppgtt+context" means guest can not use pv, or use ppgtt mode pv or
use context mode pv.

> > > 	interface_version=3
> 
> Not much granularity here, I prefer Sean's previous
> <major>.<minor>[.bugfix] scheme.
> 
yes, <major>.<minor>[.bugfix] scheme may be better, but I'm not sure if
it works for a complicated scenario.
e.g for pv_mode,
(1) initially,  pv_mode is not supported, so it's pv_mode=none, it's 0.0.0,
(2) then, pv_mode=ppgtt is supported, pv_mode="none+ppgtt", it's 0.1.0,
indicating pv_mode=none can migrate to pv_mode="none+ppgtt", but not vice versa.
(3) later, pv_mode=context is also supported,
pv_mode="none+ppgtt+context", so it's 0.2.0.

But if later, pv_mode=ppgtt is removed. pv_mode="none+context", how to
name its version? "none+ppgtt" (0.1.0) is not compatible to
"none+context", but "none+ppgtt+context" (0.2.0) is compatible to
"none+context".

Maintain such scheme is painful to vendor driver.



> > > COMPATIBLE:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}  
> > this mixed notation will be hard to parse so i would avoid that.
> 
> Some background, Intel has been proposing aggregation as a solution to
> how we scale mdev devices when hardware exposes large numbers of
> assignable objects that can be composed in essentially arbitrary ways.
> So for instance, if we have a workqueue (wq), we might have an mdev
> type for 1wq, 2wq, 3wq,... Nwq.  It's not really practical to expose a
> discrete mdev type for each of those, so they want to define a base
> type which is composable to other types via this aggregation.  This is
> what this substitution and tagging is attempting to accomplish.  So
> imagine this set of values for cases where it's not practical to unroll
> the values for N discrete types.
> 
> > > 	aggregator={val1}/2
> 
> So the {val1} above would be substituted here, though an aggregation
> factor of 1/2 is a head scratcher...
> 
> > > 	pv_mode={val2:string:"none+ppgtt","none+context","none+ppgtt+context"}
> 
> I'm lost on this one though.  I think maybe it's indicating that it's
> compatible with any of these, so do we need to list it?  Couldn't this
> be handled by Sean's version proposal where the minor version
> represents feature compatibility?
yes, it's indicating that it's compatible with any of these.
Sean's version proposal may also work, but it would be painful for
vendor driver to maintain the versions when multiple similar features
are involved.

> 
> > >  
> > > 	interface_version={val3:int:2,3}
> 
> What does this turn into in a few years, 2,7,12,23,75,96,...
> 
is a range better?

> > > COMPATIBLE:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > > 	aggregator={val1}/2
> > > 	pv_mode=""  #"" meaning empty, could be absent in a compatible device
> > > 	interface_version=1  
> 
> Why can't this be represented within the previous compatible
> description?
> 
actually it can be merged with the previous one :)
But I guess there must be one that cannot merge, so put it as an
example to demo multiple COMPATIBLE objects.

Thanks
Yan

> > if you presented this information the only way i could see to use it would be to
> > extract the mdev_type name and interface_vertion  and build a database table as follows
> > 
> > source_mdev_type | source_version | target_mdev_type | target_version
> > i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | {val3:int:2,3}
> > i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | 1
> > 
> > this would either reuiqre use to use a post placment sechudler filter to itrospec this data base
> > or thansform the target_mdev_type and target_version colum data into CUSTOM_* traits we apply to
> > our placment resouce providers and we would have to prefrom multiple reuqest for each posible compatiable
> > alternitive.  if the vm has muplite mdevs this is combinatorially problmenatic as it is 1 query for each
> > device * the number of possible compatible devices for that device.
> > 
> > in other word if this is just opaque data we cant ever represent it efficently in our placment service and
> > have to fall back to an explisive post placment schdluer filter base on the db table approch.
> > 
> > this also ignore the fact that at present the mdev_type cannot change druing a migration so the compatiable
> > devicve with a different mdev type would not be considerd accpetable choice in openstack. they way you select a host
> > with a specific vgpu mdev type today is to apply a custome trait which is CUSTOM_<medev_type_goes_here> to the vGPU
> > resouce provider and then in the flavor you request 1 allcoaton of vGPU and require the CUSTOM_<medev_type_goes_here>
> > trait. so going form i915-GVTg_V5_2 to i915-GVTg_V5_{val1:int:1,2,4,8} would not currently be compatiable with that
> > workflow.
> 
> The latter would need to be parsed into:
> 
> i915-GVTg_V5_1
> i915-GVTg_V5_2
> i915-GVTg_V5_4
> i915-GVTg_V5_8
> 
> There is also on the table, migration from physical devices to mdev
> devices (or vice versa), which is not represented in these examples,
> nor do I see how we'd represent it.  This is where I started exposing
> the resulting PCI device from the mdev in my example so we could have
> some commonality between devices, but the migration stream provider is
> just as important as the type of device, we could have different host
> drivers providing the same device with incompatible migration streams.
> The mdev_type encompasses both the driver and device, but we wouldn't
> have mdev_types for physical devices, per our current thinking.
> 
> 
> > > #cat /sys/bus/pci/dei915-GVTg_V5_{val1:int:1,2,4,8}vices/0000\:00\:i915-
> > > GVTg_V5_{val1:int:1,2,4,8}2.0/UUID2/migration_compatible
> > > SELF:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_4
> > > 	aggregator=2
> > > 	interface_version=1
> > > COMPATIBLE: 
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > > 	aggregator={val1}/2
> > > 	interface_version=1  
> > by the way this is closer to yaml format then it is to json but it does not align with any exsiting
> > format i know of so that just make the representation needless hard to consume
> > if we are going to use a markup lanag let use a standard one like yaml json or toml and not invent a new one.
> > > 
> > > Notes:
> > > - A COMPATIBLE object is a line starting with COMPATIBLE.
> > >   It specifies a list of compatible devices that are allowed to migrate
> > >   in.
> > >   The reason to allow multiple COMPATIBLE objects is that when it
> > >   is hard to express a complex compatible logic in one COMPATIBLE
> > >   object, a simple enumeration is still a fallback.
> > >   in the above example, device UUID2 is in the compatible list of
> > >   device UUID1, but device UUID1 is not in the compatible list of device
> > >   UUID2, so device UUID2 is able to migrate to device UUID1, but device
> > >   UUID1 is not able to migrate to device UUID2.
> > > 
> > > - fields under each object are of "and" relationship to each other,  meaning
> > >   all fields of SELF object of a target device must be equal to corresponding
> > >   fields of a COMPATIBLE object of source device, otherwise it is regarded as not
> > >   compatible.
> > > 
> > > - each field, however, is able to specify multiple allowed values, using
> > >   variables as explained below.
> > > 
> > > - variables are represented with {}, the first appearance of one variable
> > >   specifies its type and allowed list. e.g.
> > >   {val1:int:1,2,4,8} represents var1 whose type is integer and allowed
> > >   values are 1, 2, 4, 8.
> > > 
> > > - vendors are able to specify which fields are within the comparing list
> > >   and which fields are not. e.g. for physical VF migration, it may not
> > >   choose mdev_type as a comparing field, and maybe use driver name instead.  
> > this format might be useful to vendors but from a orcestrator
> > perspecive i dont think this has value to us likely we would not use
> > this api if it was added as it does not help us with schduling.
> > ideally instead fo declaring which other mdev types a device is
> > compatiable with (which could presumably change over time as new
> > device and firmwares are released) i would prefer to see a
> > declaritive non vendor specific api that declares the feature set
> > provided by each mdev_type from which we can infer comaptiablity
> > similar to cpu feature flags. for devices fo the same mdev_type name
> > addtionally a declaritive version sting could also be used if
> > required for addtional compatiablity checks.
> 
> "non vendor specific api that declares the feature set", aren't
> features generally vendor specific?  What we're trying to describe is,
> by it's very nature, vendor specific.  We don't have an ISO body
> defining a graphics adapter and enumerating features for that adapter.
> I think what we have is mdev_types.  Each type is supposed to define a
> specific software interface, perhaps even more so than is done by a PCI
> vendor:device ID.  Maybe that mdev_type needs to be abstracted as
> something more like a vendor signature, such that a physical device
> could provide or accept a vendor signature that's compatible with an
> mdev device.  For example, a physically assigned Intel GPU might expose
> a migration signature of i915-GVTg_v5_8 if it were designed to be
> compatible with that mdev_type.  Thanks,
> 
> Alex
> 
