Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9602626CF
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 07:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgIIFjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 01:39:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:4574 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgIIFjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 01:39:05 -0400
IronPort-SDR: PME2lyxuUZGBBNB3TqNi7XWzEhPWRNGGw5vf5Ajl/SX3Oya3E+60PouAE6ZDFgHKJfitW0iIia
 3Cii/GCS5K8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="145993006"
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="145993006"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 22:39:02 -0700
IronPort-SDR: whcmFigUgqLBadZ88oSuQUtx0F6IibdTMz/wnMKxzlk8/zn/jTBg4htIm5EhINSeN1YTLfMt/h
 Rf+LDUhf4P1Q==
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="480331663"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 22:38:56 -0700
Date:   Wed, 9 Sep 2020 13:37:56 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        openstack-discuss@lists.openstack.org,
        intel-gvt-dev@lists.freedesktop.org
Cc:     smooney@redhat.com, Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kwankhede@nvidia.com,
        eauger@redhat.com, xin-ran.wang@intel.com, corbet@lwn.net,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, intel-gvt-dev@lists.freedesktop.org,
        eskultet@redhat.com, Jiri Pirko <jiri@mellanox.com>,
        dinechin@redhat.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200909053755.GA721@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <20200820003922.GE21172@joy-OptiPlex-7040>
 <20200819212234.223667b3@x1.home>
 <20200820031621.GA24997@joy-OptiPlex-7040>
 <20200825163925.1c19b0f0.cohuck@redhat.com>
 <20200826064117.GA22243@joy-OptiPlex-7040>
 <20200828154741.30cfc1a3.cohuck@redhat.com>
 <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
 <20200831044344.GB13784@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831044344.GB13784@joy-OptiPlex-7040>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hi All,
Per our previous discussion, there are two main concerns to the previous
proposal:
(1) it's currently hard for openstack to match mdev types.
(2) complicated.

so, we further propose below changes:
(1) requiring two compatible mdevs to have the same mdev type for now.
    (though kernel still exposes compatible_type attributes for future use)  
(2) requiring 1:1 match for other attributes under sysfs type node for now
    (those attributes are specified via compatible_<attribute name> but
    with only 1 value in it.)
(3) do not match attributes under device instance node.
    rather, they are regarded as part of resource claiming process.
    so src and dest values are ensured to be 1:1.
    A dynamic_resources attribute under sysfs <type-id> node is added to
    list the attributes under device instance that mgt tools need to
    ensure 1:1 from src and dest.
    the "aggregator" attribute under device instance node is such one that
    needs to be listed.
    Those listed attributes can actually be treated as device state set by
    vendor driver during live migration. but we still want to ask for them to
    be set by mgt tools before live migration starts, in oder to reduce the
    chance of live migration failure.

do you like those changes?

after the changes, the sysfs interface would look like blow:

  |- [parent physical device]
  |--- Vendor-specific-attributes [optional]
  |--- [mdev_supported_types]
  |     |--- [<type-id>]
  |     |   |--- create
  |     |   |--- name
  |     |   |--- available_instances
  |     |   |--- device_api
  |     |   |--- software_version
  |     |   |--- compatible_type
  |     |   |--- compatible_<device_api_specific_field>
  |     |   |--- compatible_<type_specific_field>
  |     |   |--- dynamic_resources
  |     |   |--- description
  |     |   |--- [devices]

- device_api : exact match between src and dest is required.
               its value can be one of 
               "vfio-pci", "vfio-platform", "vfio-amba", "vfio-ccw", "vfio-ap"
- software_version: version of vendor driver.
                    in major.minor.bugfix scheme. 
                    dest major should be equal to src major,
	            dest minor should be no less than src minor.
		    once migration stream related code changed, vendor
		    drivers need to bump the version.
- compatible_type: not used by mgt tools currently.
                   vendor drivers can provide this attribute, but need to
		   know that mgt apps would ignore it.
		   when in future mgt tools support this attribute, it
		   would allow migration across different mdev types,
		   so that devices of older generation may be able to
		   migrate to newer generations.

- compatible_<device_api_specific_field>: for device api specific attributes,
                  e.g. compatible_subchannel_type,
                  dest values should be superset of arc values.
		  vendor drivers can specify only one value in this attribute,
		  in order to do exact match between src and dest.
		  It's ok for mgt tools to only read one value in the
		  attribute so that src:dest values are 1:1.

- compatible_<type_specific_field>: for mdev type specific attributes,
                  e.g. compatible_pci_ids, compatible_chpid_type
                  dest values should be superset of arc values.
		  vendor drivers can specify only one value in the attribute
		  in order to do exact match between src and dest.
		  It's ok for mgt tools to only read one value in the
		  attribute so that src:dest values are 1:1.

- dynamic_resources: though defined statically under <type-id>,
                  this attribute lists attributes under device instance that
		  need to be set as part of claiming dest resources.
		  e.g. $cat dynamic_resources: aggregator, fps,...
		  then after dest device is created, values of its device
		  attributes need to be set to that of src device attributes.
		  Failure in syncing src device values to dest device
		  values is treated the same as failing to claiming
		  dest resources.
		  attributes under device instance that are not listed
		  in this attribute would not be part of resource checking in
		  mgt tools.



Thanks
Yan
