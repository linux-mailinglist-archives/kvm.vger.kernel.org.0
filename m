Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD18221EC0
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgGPInb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 04:43:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:14653 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgGPIna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 04:43:30 -0400
IronPort-SDR: PfSPh/zDJJzDlYzs7P5PEUu1z4d8nIdHqbJOTHkM88FNfxc4NBw0JRkf2PDE0MdPePVFd7/uy/
 O4NseaRB4BvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="129413707"
X-IronPort-AV: E=Sophos;i="5.75,358,1589266800"; 
   d="scan'208";a="129413707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 01:43:28 -0700
IronPort-SDR: pS0mlfERo4yWffrQWy+T1/c/BGFOynW3Hp24gWXd3/zJVKo5yaU/uRBlnnQO5fqh5oTHeTRwcW
 v7AyWXGodU7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,358,1589266800"; 
   d="scan'208";a="391036069"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jul 2020 01:43:23 -0700
Date:   Thu, 16 Jul 2020 16:32:30 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     devel@ovirt.org, openstack-discuss@lists.openstack.org,
        libvir-list@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, berrange@redhat.com,
        smooney@redhat.com, eskultet@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com, dinechin@redhat.com,
        corbet@lwn.net, kwankhede@nvidia.com, dgilbert@redhat.com,
        eauger@redhat.com, jian-feng.ding@intel.com, hejie.xu@intel.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        bao.yumeng@zte.com.cn, xin-ran.wang@intel.com,
        shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200716083230.GA25316@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 12:16:26PM +0800, Jason Wang wrote:
> 
> On 2020/7/14 上午7:29, Yan Zhao wrote:
> > hi folks,
> > we are defining a device migration compatibility interface that helps upper
> > layer stack like openstack/ovirt/libvirt to check if two devices are
> > live migration compatible.
> > The "devices" here could be MDEVs, physical devices, or hybrid of the two.
> > e.g. we could use it to check whether
> > - a src MDEV can migrate to a target MDEV,
> > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > - a src MDEV can migration to a target VF in SRIOV.
> >    (e.g. SIOV/SRIOV backward compatibility case)
> > 
> > The upper layer stack could use this interface as the last step to check
> > if one device is able to migrate to another device before triggering a real
> > live migration procedure.
> > we are not sure if this interface is of value or help to you. please don't
> > hesitate to drop your valuable comments.
> > 
> > 
> > (1) interface definition
> > The interface is defined in below way:
> > 
> >               __    userspace
> >                /\              \
> >               /                 \write
> >              / read              \
> >     ________/__________       ___\|/_____________
> >    | migration_version |     | migration_version |-->check migration
> >    ---------------------     ---------------------   compatibility
> >       device A                    device B
> > 
> > 
> > a device attribute named migration_version is defined under each device's
> > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).
> 
> 
> Are you aware of the devlink based device management interface that is
> proposed upstream? I think it has many advantages over sysfs, do you
> consider to switch to that?
not familiar with the devlink. will do some research of it.
> 
> 
> > userspace tools read the migration_version as a string from the source device,
> > and write it to the migration_version sysfs attribute in the target device.
> > 
> > The userspace should treat ANY of below conditions as two devices not compatible:
> > - any one of the two devices does not have a migration_version attribute
> > - error when reading from migration_version attribute of one device
> > - error when writing migration_version string of one device to
> >    migration_version attribute of the other device
> > 
> > The string read from migration_version attribute is defined by device vendor
> > driver and is completely opaque to the userspace.
> 
> 
> My understanding is that something opaque to userspace is not the philosophy

but the VFIO live migration in itself is essentially a big opaque stream to userspace.

> of Linux. Instead of having a generic API but opaque value, why not do in a
> vendor specific way like:
> 
> 1) exposing the device capability in a vendor specific way via sysfs/devlink
> or other API
> 2) management read capability in both src and dst and determine whether we
> can do the migration
> 
> This is the way we plan to do with vDPA.
>
yes, in another reply, Alex proposed to use an interface in json format.
I guess we can define something like

{ "self" :
  [
    { "pciid" : "8086591d",
      "driver" : "i915",
      "gvt-version" : "v1",
      "mdev_type"   : "i915-GVTg_V5_2",
      "aggregator"  : "1",
      "pv-mode"     : "none",
    }
  ],
  "compatible" :
  [
    { "pciid" : "8086591d",
      "driver" : "i915",
      "gvt-version" : "v1",
      "mdev_type"   : "i915-GVTg_V5_2",
      "aggregator"  : "1"
      "pv-mode"     : "none",
    },
    { "pciid" : "8086591d",
      "driver" : "i915",
      "gvt-version" : "v1",
      "mdev_type"   : "i915-GVTg_V5_4",
      "aggregator"  : "2"
      "pv-mode"     : "none",
    },
    { "pciid" : "8086591d",
      "driver" : "i915",
      "gvt-version" : "v2",
      "mdev_type"   : "i915-GVTg_V5_4",
      "aggregator"  : "2"
      "pv-mode"     : "none, ppgtt, context",
    }
    ...
  ]
}

But as those fields are mostly vendor specific, the userspace can
only do simple string comparing, I guess the list would be very long as
it needs to enumerate all possible targets.
also, in some fileds like "gvt-version", is there a simple way to express
things like v2+?

If the userspace can read this interface both in src and target and
check whether both src and target are in corresponding compatible list, I
think it will work for us.

But still, kernel should not rely on userspace's choice, the opaque
compatibility string is still required in kernel. No matter whether
it would be exposed to userspace as an compatibility checking interface,
vendor driver would keep this part of code and embed the string into the
migration stream. so exposing it as an interface to be used by libvirt to
do a safety check before a real live migration is only about enabling
the kernel part of check to happen ahead.


Thanks
Yan


> 
> 
> > for a Intel vGPU, string format can be defined like
> > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggregator count".
> > 
> > for an NVMe VF connecting to a remote storage. it could be
> > "PCI ID" + "driver version" + "configured remote storage URL"
> > 
> > for a QAT VF, it may be
> > "PCI ID" + "driver version" + "supported encryption set".
> > 
> > (to avoid namespace confliction from each vendor, we may prefix a driver name to
> > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)
> > 
> > 
> > (2) backgrounds
> > 
> > The reason we hope the migration_version string is opaque to the userspace
> > is that it is hard to generalize standard comparing fields and comparing
> > methods for different devices from different vendors.
> > Though userspace now could still do a simple string compare to check if
> > two devices are compatible, and result should also be right, it's still
> > too limited as it excludes the possible candidate whose migration_version
> > string fails to be equal.
> > e.g. an MDEV with mdev_type_1, aggregator count 3 is probably compatible
> > with another MDEV with mdev_type_3, aggregator count 1, even their
> > migration_version strings are not equal.
> > (assumed mdev_type_3 is of 3 times equal resources of mdev_type_1).
> > 
> > besides that, driver version + configured resources are all elements demanding
> > to take into account.
> > 
> > So, we hope leaving the freedom to vendor driver and let it make the final decision
> > in a simple reading from source side and writing for test in the target side way.
> > 
> > 
> > we then think the device compatibility issues for live migration with assigned
> > devices can be divided into two steps:
> > a. management tools filter out possible migration target devices.
> >     Tags could be created according to info from product specification.
> >     we think openstack/ovirt may have vendor proprietary components to create
> >     those customized tags for each product from each vendor.
> >     e.g.
> >     for Intel vGPU, with a vGPU(a MDEV device) in source side, the tags to
> >     search target vGPU are like:
> >     a tag for compatible parent PCI IDs,
> >     a tag for a range of gvt driver versions,
> >     a tag for a range of mdev type + aggregator count
> > 
> >     for NVMe VF, the tags to search target VF may be like:
> >     a tag for compatible PCI IDs,
> >     a tag for a range of driver versions,
> >     a tag for URL of configured remote storage.
> > 
> > b. with the output from step a, openstack/ovirt/libvirt could use our proposed
> >     device migration compatibility interface to make sure the two devices are
> >     indeed live migration compatible before launching the real live migration
> >     process to start stream copying, src device stopping and target device
> >     resuming.
> >     It is supposed that this step would not bring any performance penalty as
> >     -in kernel it's just a simple string decoding and comparing
> >     -in openstack/ovirt, it could be done by extending current function
> >      check_can_live_migrate_destination, along side claiming target resources.[1]
> > 
> > 
> > [1] https://specs.openstack.org/openstack/nova-specs/specs/stein/approved/libvirt-neutron-sriov-livemigration.html
> > 
> > Thanks
> > Yan
> > 
> 
