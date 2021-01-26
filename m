Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CF3303EB9
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbhAZNax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:30:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9154 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391687AbhAZNaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:30:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601018e10000>; Tue, 26 Jan 2021 05:28:01 -0800
Received: from [172.27.11.125] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:27:56 +0000
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210122122503.4e492b96@omen.home.shazbot.org>
 <20210122200421.GH4147@nvidia.com>
 <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
 <20210126004522.GD4147@nvidia.com>
 <20210125203429.587c20fd@x1.home.shazbot.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
Date:   Tue, 26 Jan 2021 15:27:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125203429.587c20fd@x1.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611667681; bh=juhWC5dTGQeAy1Fhbof3EZbmu4mUUHMkzS2wBTTXEYI=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=LsA8l6OwVauHt1RRkPed3EC4aL3T9+zoJXvgDT6Rr1IMH/hWMO/N8ImZj0V2MyU2t
         xvDYEK0MkltncWKY4+C/DejCe0QG6wkNUZGqcsFqW+6RGjsXeYulT1/0UKthd2GSCY
         0HGHQqLWjQYwJSdza9lno9bU6NwBZpjfcqo026ENlksRoe77feW6POqzQDzJHEX5IN
         ORwoNWCpxocbWD3E/8a/q0ptWrJ+RIJVo7oViU5a5kwzkuKU8aDoTcqsjtzl5Q3+vh
         Ke3kzSGzSb1s1k3z0uOhs2Fp9FULq/V3fKLtzVwiWGc6+dai6togTQ6tLWI7EtbKXO
         x7xlOWc0Hc9TA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia and Jason,

thanks for the reviewing this.

On 1/26/2021 5:34 AM, Alex Williamson wrote:
> On Mon, 25 Jan 2021 20:45:22 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Mon, Jan 25, 2021 at 04:31:51PM -0700, Alex Williamson wrote:
>>
>>> We're supposed to be enlightened by a vendor driver that does nothing
>>> more than pass the opaque device_data through to the core functions,
>>> but in reality this is exactly the point of concern above.  At a
>>> minimum that vendor driver needs to look at the vdev to get the
>>> pdev,
>> The end driver already havs the pdev, the RFC doesn't go enough into
>> those bits, it is a good comment.
>>
>> The dd_data pased to the vfio_create_pci_device() will be retrieved
>> from the ops to get back to the end drivers data. This can cleanly
>> include everything: the VF pci_device, PF pci_device, mlx5_core
>> pointer, vfio_device and vfio_pci_device.
>>
>> This is why the example passes in the mvadev:
>>
>> +	vdev = vfio_create_pci_device(pdev, &mlx5_vfio_pci_ops, mvadev);
>>
>> The mvadev has the PF, VF, and mlx5 core driver pointer.
>>
>> Getting that back out during the ops is enough to do what the mlx5
>> driver needs to do, which is relay migration related IOCTLs to the PF
>> function via the mlx5_core driver so the device can execute them on
>> behalf of the VF.
>>
>>> but then what else does it look at, consume, or modify.  Now we have
>>> vendor drivers misusing the core because it's not clear which fields
>>> are private and how public fields can be used safely,
>> The kernel has never followed rigid rules for data isolation, it is
>> normal to have whole private structs exposed in headers so that
>> container_of can be used to properly compose data structures.
> I reject this assertion, there are plenty of structs that clearly
> indicate private vs public data or, as we've done in mdev, clearly
> marking the private data in a "private" header and provide access
> functions for public fields.  Including a "private" header to make use
> of a "library" is just wrong.  In the example above, there's no way for
> the mlx vendor driver to get back dd_data without extracting it from
> struct vfio_pci_device itself.

I'll create a better separation between private/public fields according 
to my understanding for the V2.

I'll just mention that beyond this separation, future improvements will 
be needed and can be done incrementally.

I don't think that we should do so many changes at one shut. The 
incremental process is safer from subsystem point of view.

I also think that upstreaming mlx5_vfio_pci.ko and upstreaming vfio-pci 
separation into 2 modules doesn't have to happen in one-shut.

But again, to make our point in this RFC, I'll improve it for V2.

>
>> Look at struct device, for instance. Most of that is private to the
>> driver core.
>>
>> A few 'private to vfio-pci-core' comments would help, it is good
>> feedback to make that more clear.
>>
>>> extensions potentially break vendor drivers, etc.  We're only even hand
>>> waving that existing device specific support could be farmed out to new
>>> device specific drivers without even going to the effort to prove that.
>> This is a RFC, not a complete patch series. The RFC is to get feedback
>> on the general design before everyone comits alot of resources and
>> positions get dug in.
>>
>> Do you really think the existing device specific support would be a
>> problem to lift? It already looks pretty clean with the
>> vfio_pci_regops, looks easy enough to lift to the parent.
>>
>>> So far the TODOs rather mask the dirty little secrets of the
>>> extension rather than showing how a vendor derived driver needs to
>>> root around in struct vfio_pci_device to do something useful, so
>>> probably porting actual device specific support rather than further
>>> hand waving would be more helpful.
>> It would be helpful to get actual feedback on the high level design -
>> someting like this was already tried in May and didn't go anywhere -
>> are you surprised that we are reluctant to commit alot of resources
>> doing a complete job just to have it go nowhere again?
> That's not really what I'm getting from your feedback, indicating
> vfio-pci is essentially done, the mlx stub driver should be enough to
> see the direction, and additional concerns can be handled with TODO
> comments.  Sorry if this is not construed as actual feedback, I think
> both Connie and I are making an effort to understand this and being
> hampered by lack of a clear api or a vendor driver that's anything more
> than vfio-pci plus an aux bus interface.  Thanks,

I think I got the main idea and I'll try to summarize it:

The separation to vfio-pci.ko and vfio-pci-core.ko is acceptable, and we 
do need it to be able to create vendor-vfio-pci.ko driver in the future 
to include vendor special souse inside.

The separation implementation and the question of what is private and 
what is public, and the core APIs to the various drivers should be 
improved or better demonstrated in the V2.

I'll work on improving it and I'll send the V2.


If you have some feedback of the things/fields/structs you think should 
remain private to vfio-pci-core please let us know.

Thanks for the effort in the review,

-Max.

> Alex
>
