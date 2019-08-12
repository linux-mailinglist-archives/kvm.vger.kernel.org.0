Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868D389D33
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfHLLfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 07:35:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17672 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfHLLfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 07:35:51 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d514f170000>; Mon, 12 Aug 2019 04:35:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 12 Aug 2019 04:35:49 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 12 Aug 2019 04:35:49 -0700
Received: from [10.24.70.124] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Aug
 2019 11:35:44 +0000
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
To:     Alex Williamson <alex.williamson@redhat.com>,
        Parav Pandit <parav@mellanox.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <cjia@nvidia.com>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
Date:   Mon, 12 Aug 2019 17:05:35 +0530
MIME-Version: 1.0
In-Reply-To: <20190808170247.1fc2c4c4@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565609751; bh=fpHvHHJL8wyOLDiEfQdubvRYA+qG1k/+C72xvd/LHRQ=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=blXKchJTCoja53q4QJ8ExzCyn1pWzmxPHrtImiRE//hESE7MIbP+UxofWHdYsY4Gv
         GKk3HQN0w6m2V8kLq/xaA7kQIlsVjC5DMdNVsjzr322QbAq5Z+Ggn9Mv1J+sPp2E9A
         /L9/qQ85m0NiGMMO1hCG2CsXcDUzvobEgyM3ymj+PhX2CZ2p3SqakukpYNKzkvDRWG
         f+9qKYCSsbtyENegLRTUEyNYBhi8sNgfwYDdK+H6zVzQyNb05z7xgpGAs6F9IRzAB/
         DhqfBfvnaR2EtmR+WVMSP2icu6D8Z+UY2byAgshKZ0OcA3VRBfeNpa7HXCFXVDEWyA
         U041fgBWnGoTQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/2019 4:32 AM, Alex Williamson wrote:
> On Thu,  8 Aug 2019 09:12:53 -0500
> Parav Pandit <parav@mellanox.com> wrote:
> 
>> Currently mtty sample driver uses mdev state and UUID in convoluated way to
>> generate an interrupt.
>> It uses several translations from mdev_state to mdev_device to mdev uuid.
>> After which it does linear search of long uuid comparision to
>> find out mdev_state in mtty_trigger_interrupt().
>> mdev_state is already available while generating interrupt from which all
>> such translations are done to reach back to mdev_state.
>>
>> This translations are done during interrupt generation path.
>> This is unnecessary and reduandant.
> 
> Is the interrupt handling efficiency of this particular sample driver
> really relevant, or is its purpose more to illustrate the API and
> provide a proof of concept?  If we go to the trouble to optimize the
> sample driver and remove this interface from the API, what do we lose?
> 
> This interface was added via commit:
> 
> 99e3123e3d72 vfio-mdev: Make mdev_device private and abstract interfaces
> 
> Where the goal was to create a more formal interface and abstract
> driver access to the struct mdev_device.  In part this served to make
> out-of-tree mdev vendor drivers more supportable; the object is
> considered opaque and access is provided via an API rather than through
> direct structure fields.
> 
> I believe that the NVIDIA GRID mdev driver does make use of this
> interface and it's likely included in the sample driver specifically so
> that there is an in-kernel user for it (ie. specifically to avoid it
> being removed so casually).  An interesting feature of the NVIDIA mdev
> driver is that I believe it has portions that run in userspace.  As we
> know, mdevs are named with a UUID, so I can imagine there are some
> efficiencies to be gained in having direct access to the UUID for a
> device when interacting with userspace, rather than repeatedly parsing
> it from a device name.

That's right.

>  Is that really something we want to make more
> difficult in order to optimize a sample driver?  Knowing that an mdev
> device uses a UUID for it's name, as tools like libvirt and mdevctl
> expect, is it really worthwhile to remove such a trivial API?
> 
>> Hence,
>> Patch-1 simplifies mtty sample driver to directly use mdev_state.
>>
>> Patch-2, Since no production driver uses mdev_uuid(), simplifies and
>> removes redandant mdev_uuid() exported symbol.
> 
> s/no production driver/no in-kernel production driver/
> 
> I'd be interested to hear how the NVIDIA folks make use of this API
> interface.  Thanks,
> 

Yes, NVIDIA mdev driver do use this interface. I don't agree on removing
mdev_uuid() interface.

Thanks,
Kirti


> Alex
> 
>> ---
>> Changelog:
>> v1->v2:
>>  - Corrected email of Kirti
>>  - Updated cover letter commit log to address comment from Cornelia
>>  - Added Reviewed-by tag
>> v0->v1:
>>  - Updated commit log
>>
>> Parav Pandit (2):
>>   vfio-mdev/mtty: Simplify interrupt generation
>>   vfio/mdev: Removed unused and redundant API for mdev UUID
>>
>>  drivers/vfio/mdev/mdev_core.c |  6 ------
>>  include/linux/mdev.h          |  1 -
>>  samples/vfio-mdev/mtty.c      | 39 +++++++----------------------------
>>  3 files changed, 8 insertions(+), 38 deletions(-)
>>
> 
