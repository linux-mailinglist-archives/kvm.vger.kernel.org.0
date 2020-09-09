Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F647262508
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 04:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIICOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 22:14:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:60482 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgIICOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 22:14:15 -0400
IronPort-SDR: Te7pCnnQZYYpam+YNYavWIyKjmSKUylpimRIq+li23r8cokUH63pbipOoOHFIWbostYVq+y3gg
 94MsIXktlu6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="137773504"
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="137773504"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 19:14:15 -0700
IronPort-SDR: oo/ud125TYByVRHHJ5qg2GWa+ZHCBXGAPNIQz7XvqtmJUH6vWTuCkGOrmYvKqirKrVeZj+g829
 JFl8hWPU2hyg==
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="480286722"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 19:14:09 -0700
Date:   Wed, 9 Sep 2020 10:13:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Sean Mooney <smooney@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, intel-gvt-dev@lists.freedesktop.org,
        eskultet@redhat.com, Jiri Pirko <jiri@mellanox.com>,
        dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200909021308.GA1277@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200818113652.5d81a392.cohuck@redhat.com>
 <20200820003922.GE21172@joy-OptiPlex-7040>
 <20200819212234.223667b3@x1.home>
 <20200820031621.GA24997@joy-OptiPlex-7040>
 <20200825163925.1c19b0f0.cohuck@redhat.com>
 <20200826064117.GA22243@joy-OptiPlex-7040>
 <20200828154741.30cfc1a3.cohuck@redhat.com>
 <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
 <20200831044344.GB13784@joy-OptiPlex-7040>
 <20200908164130.2fe0d106.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908164130.2fe0d106.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > still, I'd like to put it more explicitly to make ensure it's not missed:
> > the reason we want to specify compatible_type as a trait and check
> > whether target compatible_type is the superset of source
> > compatible_type is for the consideration of backward compatibility.
> > e.g.
> > an old generation device may have a mdev type xxx-v4-yyy, while a newer
> > generation  device may be of mdev type xxx-v5-yyy.
> > with the compatible_type traits, the old generation device is still
> > able to be regarded as compatible to newer generation device even their
> > mdev types are not equal.
> 
> If you want to support migration from v4 to v5, can't the (presumably
> newer) driver that supports v5 simply register the v4 type as well, so
> that the mdev can be created as v4? (Just like QEMU versioned machine
> types work.)
yes, it should work in some conditions.
but it may not be that good in some cases when v5 and v4 in the name string
of mdev type identify hardware generation (e.g. v4 for gen8, and v5 for
gen9)

e.g.
(1). when src mdev type is v4 and target mdev type is v5 as
software does not support it initially, and v4 and v5 identify hardware
differences.
then after software upgrade, v5 is now compatible to v4, should the
software now downgrade mdev type from v5 to v4?
not sure if moving hardware generation info into a separate attribute
from mdev type name is better. e.g. remove v4, v5 in mdev type, while use
compatible_pci_ids to identify compatibility.

(2) name string of mdev type is composed by "driver_name + type_name".
in some devices, e.g. qat, different generations of devices are binding to
drivers of different names, e.g. "qat-v4", "qat-v5".
then though type_name is equal, mdev type is not equal. e.g.
"qat-v4-type1", "qat-v5-type1".

Thanks
Yan

