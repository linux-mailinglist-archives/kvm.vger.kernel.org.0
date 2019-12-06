Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0D114E41
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLFJkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 04:40:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbfLFJkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 04:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575625219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ee6kZgpqHsGl3Yib6gXFQ8A7ZeHKLFO7UJRRdey8Gi0=;
        b=CndtgkbX0KQExVfVxk6LOrzm4RtDGb1ZMFd1wyTWDA8ZfXNycjMCtrUOO/3ItIMgQhG7uQ
        VmdHD1fIGJIRKfG20+/FdEIUFkBPB/8VlMEeH4bir/Kqxn9NcWHirHD8a/kku7GxxPS/lB
        yH6FfxpxbbcT4fAW1E6Hma+CX8vvk00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-pZCEgwzaOTyGo-ymJQn4Eg-1; Fri, 06 Dec 2019 04:40:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96041DB66;
        Fri,  6 Dec 2019 09:40:15 +0000 (UTC)
Received: from [10.72.13.14] (ovpn-13-14.pek2.redhat.com [10.72.13.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1A96B8ED;
        Fri,  6 Dec 2019 09:40:04 +0000 (UTC)
Subject: Re: [RFC PATCH 0/9] Introduce mediate ops in vfio-pci
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <8bcf603c-f142-f96d-bb11-834d686f5519@redhat.com>
 <20191205085111.GD31791@joy-OptiPlex-7040>
 <fe84dba6-5af7-daad-3102-9fa86a90aa4d@redhat.com>
 <20191206082232.GH31791@joy-OptiPlex-7040>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
Date:   Fri, 6 Dec 2019 17:40:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191206082232.GH31791@joy-OptiPlex-7040>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: pZCEgwzaOTyGo-ymJQn4Eg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/6 =E4=B8=8B=E5=8D=884:22, Yan Zhao wrote:
> On Thu, Dec 05, 2019 at 09:05:54PM +0800, Jason Wang wrote:
>> On 2019/12/5 =E4=B8=8B=E5=8D=884:51, Yan Zhao wrote:
>>> On Thu, Dec 05, 2019 at 02:33:19PM +0800, Jason Wang wrote:
>>>> Hi:
>>>>
>>>> On 2019/12/5 =E4=B8=8A=E5=8D=8811:24, Yan Zhao wrote:
>>>>> For SRIOV devices, VFs are passthroughed into guest directly without =
host
>>>>> driver mediation. However, when VMs migrating with passthroughed VFs,
>>>>> dynamic host mediation is required to  (1) get device states, (2) get
>>>>> dirty pages. Since device states as well as other critical informatio=
n
>>>>> required for dirty page tracking for VFs are usually retrieved from P=
Fs,
>>>>> it is handy to provide an extension in PF driver to centralizingly co=
ntrol
>>>>> VFs' migration.
>>>>>
>>>>> Therefore, in order to realize (1) passthrough VFs at normal time, (2=
)
>>>>> dynamically trap VFs' bars for dirty page tracking and
>>>> A silly question, what's the reason for doing this, is this a must for=
 dirty
>>>> page tracking?
>>>>
>>> For performance consideration. VFs' bars should be passthoughed at
>>> normal time and only enter into trap state on need.
>>
>> Right, but how does this matter for the case of dirty page tracking?
>>
> Take NIC as an example, to trap its VF dirty pages, software way is
> required to trap every write of ring tail that resides in BAR0.


Interesting, but it looks like we need:
- decode the instruction
- mediate all access to BAR0
All of which seems a great burden for the VF driver. I wonder whether or=20
not doing interrupt relay and tracking head is better in this case.


>   There's
> still no IOMMU Dirty bit available.
>>>>>     (3) centralizing
>>>>> VF critical states retrieving and VF controls into one driver, we pro=
pose
>>>>> to introduce mediate ops on top of current vfio-pci device driver.
>>>>>
>>>>>
>>>>>                                       _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _
>>>>>     __________   register mediate ops|  ___________     ___________  =
  |
>>>>> |          |<-----------------------|     VF    |   |           |
>>>>> | vfio-pci |                      | |  mediate  |   | PF driver |   |
>>>>> |__________|----------------------->|   driver  |   |___________|
>>>>>         |            open(pdev)      |  -----------          |       =
  |
>>>>>         |                                                    |
>>>>>         |                            |_ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _=
 _|
>>>>>        \|/                                                  \|/
>>>>> -----------                                         ------------
>>>>> |    VF   |                                         |    PF    |
>>>>> -----------                                         ------------
>>>>>
>>>>>
>>>>> VF mediate driver could be a standalone driver that does not bind to
>>>>> any devices (as in demo code in patches 5-6) or it could be a built-i=
n
>>>>> extension of PF driver (as in patches 7-9) .
>>>>>
>>>>> Rather than directly bind to VF, VF mediate driver register a mediate
>>>>> ops into vfio-pci in driver init. vfio-pci maintains a list of such
>>>>> mediate ops.
>>>>> (Note that: VF mediate driver can register mediate ops into vfio-pci
>>>>> before vfio-pci binding to any devices. And VF mediate driver can
>>>>> support mediating multiple devices.)
>>>>>
>>>>> When opening a device (e.g. a VF), vfio-pci goes through the mediate =
ops
>>>>> list and calls each vfio_pci_mediate_ops->open() with pdev of the ope=
ning
>>>>> device as a parameter.
>>>>> VF mediate driver should return success or failure depending on it
>>>>> supports the pdev or not.
>>>>> E.g. VF mediate driver would compare its supported VF devfn with the
>>>>> devfn of the passed-in pdev.
>>>>> Once vfio-pci finds a successful vfio_pci_mediate_ops->open(), it wil=
l
>>>>> stop querying other mediate ops and bind the opening device with this
>>>>> mediate ops using the returned mediate handle.
>>>>>
>>>>> Further vfio-pci ops (VFIO_DEVICE_GET_REGION_INFO ioctl, rw, mmap) on=
 the
>>>>> VF will be intercepted into VF mediate driver as
>>>>> vfio_pci_mediate_ops->get_region_info(),
>>>>> vfio_pci_mediate_ops->rw,
>>>>> vfio_pci_mediate_ops->mmap, and get customized.
>>>>> For vfio_pci_mediate_ops->rw and vfio_pci_mediate_ops->mmap, they wil=
l
>>>>> further return 'pt' to indicate whether vfio-pci should further
>>>>> passthrough data to hw.
>>>>>
>>>>> when vfio-pci closes the VF, it calls its vfio_pci_mediate_ops->relea=
se()
>>>>> with a mediate handle as parameter.
>>>>>
>>>>> The mediate handle returned from vfio_pci_mediate_ops->open() lets VF
>>>>> mediate driver be able to differentiate two opening VFs of the same d=
evice
>>>>> id and vendor id.
>>>>>
>>>>> When VF mediate driver exits, it unregisters its mediate ops from
>>>>> vfio-pci.
>>>>>
>>>>>
>>>>> In this patchset, we enable vfio-pci to provide 3 things:
>>>>> (1) calling mediate ops to allow vendor driver customizing default
>>>>> region info/rw/mmap of a region.
>>>>> (2) provide a migration region to support migration
>>>> What's the benefit of introducing a region? It looks to me we don't ex=
pect
>>>> the region to be accessed directly from guest. Could we simply extend =
device
>>>> fd ioctl for doing such things?
>>>>
>>> You may take a look on mdev live migration discussions in
>>> https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html
>>>
>>> or previous discussion at
>>> https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg04908.html,
>>> which has kernel side implemetation https://patchwork.freedesktop.org/s=
eries/56876/
>>>
>>> generaly speaking, qemu part of live migration is consistent for
>>> vfio-pci + mediate ops way or mdev way.
>>
>> So in mdev, do you still have a mediate driver? Or you expect the parent
>> to implement the region?
>>
> No, currently it's only for vfio-pci.

And specific to PCI.

> mdev parent driver is free to customize its regions and hence does not
> requires this mediate ops hooks.
>
>>> The region is only a channel for
>>> QEMU and kernel to communicate information without introducing IOCTLs.
>>
>> Well, at least you introduce new type of region in uapi. So this does
>> not answer why region is better than ioctl. If the region will only be
>> used by qemu, using ioctl is much more easier and straightforward.
>>
> It's not introduced by me :)
> mdev live migration is actually using this way, I'm just keeping
> compatible to the uapi.


I meant e.g VFIO_REGION_TYPE_MIGRATION.


>
>  From my own perspective, my answer is that a region is more flexible
> compared to ioctl. vendor driver can freely define the size,
>

Probably not since it's an ABI I think.

>   mmap cap of
> its data subregion.
>

It doesn't help much unless it can be mapped into guest (which I don't=20
think it was the case here).

>   Also, there're already too many ioctls in vfio.

Probably not :) We had a brunch of=C2=A0 subsystems that have much more=20
ioctls than VFIO. (e.g DRM)

>>>
>>>>> (3) provide a dynamic trap bar info region to allow vendor driver
>>>>> control trap/untrap of device pci bars
>>>>>
>>>>> This vfio-pci + mediate ops way differs from mdev way in that
>>>>> (1) medv way needs to create a 1:1 mdev device on top of one VF, devi=
ce
>>>>> specific mdev parent driver is bound to VF directly.
>>>>> (2) vfio-pci + mediate ops way does not create mdev devices and VF
>>>>> mediate driver does not bind to VFs. Instead, vfio-pci binds to VFs.
>>>>>
>>>>> The reason why we don't choose the way of writing mdev parent driver =
is
>>>>> that
>>>>> (1) VFs are almost all the time directly passthroughed. Directly bind=
ing
>>>>> to vfio-pci can make most of the code shared/reused.
>>>> Can we split out the common parts from vfio-pci?
>>>>
>>> That's very attractive. but one cannot implement a vfio-pci except
>>> export everything in it as common part :)
>>
>> Well, I think there should be not hard to do that. E..g you can route it
>> back to like:
>>
>> vfio -> vfio_mdev -> parent -> vfio_pci
>>
> it's desired for us to have mediate driver binding to PF device.
> so once a VF device is created, only PF driver and vfio-pci are
> required. Just the same as what needs to be done for a normal VF passthro=
ugh.
> otherwise, a separate parent driver binding to VF is required.
> Also, this parent driver has many drawbacks as I mentions in this
> cover-letter.

Well, as discussed, no need to duplicate the code, bar trick should=20
still work. The main issues I saw with this proposal is:

1) PCI specific, other bus may need something similar
2) Function duplicated with mdev and mdev can do even more


>>>>>     If we write a
>>>>> vendor specific mdev parent driver, most of the code (like passthroug=
h
>>>>> style of rw/mmap) still needs to be copied from vfio-pci driver, whic=
h is
>>>>> actually a duplicated and tedious work.
>>>> The mediate ops looks quite similar to what vfio-mdev did. And it look=
s to
>>>> me we need to consider live migration for mdev as well. In that case, =
do we
>>>> still expect mediate ops through VFIO directly?
>>>>
>>>>
>>>>> (2) For features like dynamically trap/untrap pci bars, if they are i=
n
>>>>> vfio-pci, they can be available to most people without repeated code
>>>>> copying and re-testing.
>>>>> (3) with a 1:1 mdev driver which passthrough VFs most of the time, pe=
ople
>>>>> have to decide whether to bind VFs to vfio-pci or mdev parent driver =
before
>>>>> it runs into a real migration need. However, if vfio-pci is bound
>>>>> initially, they have no chance to do live migration when there's a ne=
ed
>>>>> later.
>>>> We can teach management layer to do this.
>>>>
>>> No. not possible as vfio-pci by default has no migration region and
>>> dirty page tracking needs vendor's mediation at least for most
>>> passthrough devices now.
>>
>> I'm not quite sure I get here but in this case, just tech them to use
>> the driver that has migration support?
>>
> That's a way, but as more and more passthrough devices have demands and
> caps to do migration, will vfio-pci be used in future any more ?


This should not be a problem:
- If we introduce a common mdev for vfio-pci, we can just bind that=20
driver always
- The most straightforward way to support dirty page tracking is done by=20
IOMMU instead of device specific operations.

Thanks

>
> Thanks
> Yan
>
>> Thanks
>>
>>
>>> Thanks
>>> Yn
>>>
>>>> Thanks
>>>>
>>>>
>>>>> In this patchset,
>>>>> - patches 1-4 enable vfio-pci to call mediate ops registered by vendo=
r
>>>>>      driver to mediate/customize region info/rw/mmap.
>>>>>
>>>>> - patches 5-6 provide a standalone sample driver to register a mediat=
e ops
>>>>>      for Intel Graphics Devices. It does not bind to IGDs directly bu=
t decides
>>>>>      what devices it supports via its pciidlist. It also demonstrates=
 how to
>>>>>      dynamic trap a device's PCI bars. (by adding more pciids in its
>>>>>      pciidlist, this sample driver actually is not necessarily limite=
d to
>>>>>      support IGDs)
>>>>>
>>>>> - patch 7-9 provide a sample on i40e driver that supports Intel(R)
>>>>>      Ethernet Controller XL710 Family of devices. It supports VF prec=
opy live
>>>>>      migration on Intel's 710 SRIOV. (but we commented out the real
>>>>>      implementation of dirty page tracking and device state retrievin=
g part
>>>>>      to focus on demonstrating framework part. Will send out them in =
future
>>>>>      versions)
>>>>>      patch 7 registers/unregisters VF mediate ops when PF driver
>>>>>      probes/removes. It specifies its supporting VFs via
>>>>>      vfio_pci_mediate_ops->open(pdev)
>>>>>
>>>>>      patch 8 reports device cap of VFIO_PCI_DEVICE_CAP_MIGRATION and
>>>>>      provides a sample implementation of migration region.
>>>>>      The QEMU part of vfio migration is based on v8
>>>>>      https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.h=
tml.
>>>>>      We do not based on recent v9 because we think there are still op=
ens in
>>>>>      dirty page track part in that series.
>>>>>
>>>>>      patch 9 reports device cap of VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_B=
AR and
>>>>>      provides an example on how to trap part of bar0 when migration s=
tarts
>>>>>      and passthrough this part of bar0 again when migration fails.
>>>>>
>>>>> Yan Zhao (9):
>>>>>      vfio/pci: introduce mediate ops to intercept vfio-pci ops
>>>>>      vfio/pci: test existence before calling region->ops
>>>>>      vfio/pci: register a default migration region
>>>>>      vfio-pci: register default dynamic-trap-bar-info region
>>>>>      samples/vfio-pci/igd_dt: sample driver to mediate a passthrough =
IGD
>>>>>      sample/vfio-pci/igd_dt: dynamically trap/untrap subregion of IGD=
 bar0
>>>>>      i40e/vf_migration: register mediate_ops to vfio-pci
>>>>>      i40e/vf_migration: mediate migration region
>>>>>      i40e/vf_migration: support dynamic trap of bar0
>>>>>
>>>>>     drivers/net/ethernet/intel/Kconfig            |   2 +-
>>>>>     drivers/net/ethernet/intel/i40e/Makefile      |   3 +-
>>>>>     drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
>>>>>     drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
>>>>>     .../ethernet/intel/i40e/i40e_vf_migration.c   | 626 +++++++++++++=
+++++
>>>>>     .../ethernet/intel/i40e/i40e_vf_migration.h   |  78 +++
>>>>>     drivers/vfio/pci/vfio_pci.c                   | 189 +++++-
>>>>>     drivers/vfio/pci/vfio_pci_private.h           |   2 +
>>>>>     include/linux/vfio.h                          |  18 +
>>>>>     include/uapi/linux/vfio.h                     | 160 +++++
>>>>>     samples/Kconfig                               |   6 +
>>>>>     samples/Makefile                              |   1 +
>>>>>     samples/vfio-pci/Makefile                     |   2 +
>>>>>     samples/vfio-pci/igd_dt.c                     | 367 ++++++++++
>>>>>     14 files changed, 1455 insertions(+), 4 deletions(-)
>>>>>     create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migrat=
ion.c
>>>>>     create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migrat=
ion.h
>>>>>     create mode 100644 samples/vfio-pci/Makefile
>>>>>     create mode 100644 samples/vfio-pci/igd_dt.c
>>>>>

