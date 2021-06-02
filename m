Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E863398EDB
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 17:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhFBPmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 11:42:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:62051 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhFBPml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 11:42:41 -0400
IronPort-SDR: 45+E8r9bh5eXM6wWQ4phn8eiYrnKXyn6RRvuWP4Rb6VO0u8Rx6rnp4oF+OBQitnpeSVyseiCa3
 We35UMG/UM4g==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="183498170"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="183498170"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 08:40:53 -0700
IronPort-SDR: fygxpcgJ3k09ad+5wsx/bbZIYzXgQ3NYwhn46RK80I4bKEM5GOZOA6SO5QKmeqsQdSvAQqZNmI
 Ydz7uxkN31Lw==
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="416934415"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.254.187.108]) ([10.254.187.108])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 08:40:52 -0700
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
Date:   Wed, 2 Jun 2021 08:40:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210523232219.GG1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/23/2021 4:22 PM, Jason Gunthorpe wrote:
> On Fri, May 21, 2021 at 05:19:05PM -0700, Dave Jiang wrote:
>> Introducing mdev types “1dwq-v1” type. This mdev type allows
>> allocation of a single dedicated wq from available dedicated wqs. After
>> a workqueue (wq) is enabled, the user will generate an uuid. On mdev
>> creation, the mdev driver code will find a dwq depending on the mdev
>> type. When the create operation is successful, the user generated uuid
>> can be passed to qemu. When the guest boots up, it should discover a
>> DSA device when doing PCI discovery.
>>
>> For example of “1dwq-v1” type:
>> 1. Enable wq with “mdev” wq type
>> 2. A user generated uuid.
>> 3. The uuid is written to the mdev class sysfs path:
>> echo $UUID > /sys/class/mdev_bus/0000\:00\:0a.0/mdev_supported_types/idxd-1dwq-v1/create
>> 4. Pass the following parameter to qemu:
>> "-device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:0a.0/$UUID"
> So the idxd core driver knows to create a "vfio" wq with its own much
> machinery but you still want to involve the horrible mdev guid stuff?
>
> Why??

Are you referring to calling mdev_device_create() directly in the mdev 
idxd_driver probe? I think this would work with our dedicated wq where a 
single mdev can be assigned to a wq. However, later on when we need to 
support shared wq where we can create multiple mdev per wq, we'll need 
an entry point to do so. In the name of making things consistent from 
user perspective, going through sysfs seems the way to do it.

