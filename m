Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1338D30CD83
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 22:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhBBVAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 16:00:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7520 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhBBVAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 16:00:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019bd3c0000>; Tue, 02 Feb 2021 12:59:40 -0800
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:59:30 +0000
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
Date:   Tue, 2 Feb 2021 22:59:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202204432.GC4247@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612299580; bh=VzeO8fn5oKUBcIe3AbDvCWI0BQgaZOFMZoUoYnQg2tg=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=Q+CtvyvMHflZh/Clwh4OHJNijKdiI76UyAEj58pPtOU6Pvuastj2UFSYud50DDPLP
         9GSAAKJ3kdJjy5flRmGiHJtvOeg1rPdyNy25OkqRYl2Bf/VWtK1M01W9CRBUsmt90S
         MXhYztrU7Lbwq8fw9HkQm5cWQNPuaoPdyS5eIGCXDr8T0wQBu+Jjqo2ZVrcp/x0+Gw
         hlhzsLSbeMLho2eVtyx33vlnfFSOgsJETYVo1tWgwnJlFrSN1YNiCi7Ksdd1vzrAZa
         eu/MiwQCyrd3/ArsC6JAHEvh6Oguldg+kS6ST9mLs1xXqj4zroTNyi8J7HDYSnD4cO
         x/STV1yKoFfWA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/2/2021 10:44 PM, Jason Gunthorpe wrote:
> On Tue, Feb 02, 2021 at 12:37:23PM -0700, Alex Williamson wrote:
>
>> For the most part, this explicit bind interface is redundant to
>> driver_override, which already avoids the duplicate ID issue.
> No, the point here is to have the ID tables in the PCI drivers because
> they fundamentally only work with their supported IDs. The normal
> driver core ID tables are a replacement for all the hardwired if's in
> vfio_pci.
>
> driver_override completely disables all the ID checking, it seems only
> useful for vfio_pci which works with everything. It should not be used
> with something like nvlink_vfio_pci.ko that needs ID checking.

This mechanism of driver_override seems weird to me. In case of hotplug 
and both capable drivers (native device driver and vfio-pci) are loaded, 
both will compete on the device.

I think the proposed flags is very powerful and it does fix the original 
concern Alex had ("if we start adding ids for vfio drivers then we 
create conflicts with the native host driver") and it's very deterministic.

In this way we'll bind explicitly to a driver.

And the way we'll choose a vfio-pci driver is by device_id + vendor_id + 
subsystem_device + subsystem_vendor.

There shouldn't be 2 vfio-pci drivers that support a device with same 
above 4 ids.

if you don't find a suitable vendor-vfio-pci.ko, you'll try binding 
vfio-pci.ko.

Each driver will publish its supported ids in sysfs to help the user to 
decide.

>
> Yes, this DRIVER_EXPLICIT_BIND_ONLY idea somewhat replaces
> driver_override because we could set the PCI any match on vfio_pci and
> manage the driver binding explicitly instead.
>
>> A driver id table doesn't really help for binding the device,
>> ultimately even if a device is in the id table it might fail to
>> probe due to the missing platform support that each of these igd and
>> nvlink drivers expose,
> What happens depends on what makes sense for the driver, some missing
> optional support could continue without it, or it could fail.
>
> IGD and nvlink can trivially go onwards and work if they don't find
> the platform support.
>
> Or they might want to fail, I think the mlx5 and probably nvlink
> drivers should fail as they are intended to be coupled with userspace
> that expects to use their extended features.
>
> In those cases failing is a feature because it prevents the whole
> system from going into an unexpected state.
>
> Jason
