Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63E3109BA0
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfKZJ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 04:59:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50660 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727724AbfKZJ7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 04:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574762343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ERKqMrCg9g6ht1S3vcoxPOIWk/iSi4tl+wRpifcMM3Y=;
        b=PSJRQkHefSpx14WIBbpC547R6+7Ncpy/VBwGK4avby2ZFb/q2lNFreLzJgn0fBu1ES7OfI
        2AHgeXW3fy5HysD4KxWKq5P0kjVRAn9kLmnlNzeRBP8mI9ARVfLpjtCkd7QO00790cOemO
        ZurLG4XkzFN9oygqWsI4SXLBd8Q8UAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-f5jEAjP0O6WBtPbyECMUyQ-1; Tue, 26 Nov 2019 04:58:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15D54101F4E5;
        Tue, 26 Nov 2019 09:58:57 +0000 (UTC)
Received: from [10.72.12.241] (ovpn-12-241.pek2.redhat.com [10.72.12.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D44519C70;
        Tue, 26 Nov 2019 09:58:49 +0000 (UTC)
Subject: Re: [PATCH] pci: endpoint: functions: Add a virtnet EP function
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Haotian Wang <haotian.wang@sifive.com>, mst@redhat.com,
        lorenzo.pieralisi@arm.com, bhelgaas@google.com,
        Alan Mikhak <alan.mikhak@sifive.com>
Cc:     linux-pci@vger.kernel.org, haotian.wang@duke.edu,
        Jon Mason <jdmason@kudzu.us>, KVM list <kvm@vger.kernel.org>
References: <7067e657-5c8e-b724-fa6a-086fece6e6c3@redhat.com>
 <20190904215801.2971-1-haotian.wang@sifive.com>
 <59982499-0fc1-2e39-9ff9-993fb4dd7dcc@redhat.com>
 <2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d87fbe2f-b3ae-5cb1-448a-41335febc460@redhat.com>
Date:   Tue, 26 Nov 2019 17:58:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: f5jEAjP0O6WBtPbyECMUyQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/25 =E4=B8=8B=E5=8D=888:49, Kishon Vijay Abraham I wrote:
> +Alan, Jon
>
> Hi Jason, Haotian, Alan,
>
> On 05/09/19 8:26 AM, Jason Wang wrote:
>> On 2019/9/5 =E4=B8=8A=E5=8D=885:58, Haotian Wang wrote:
>>> Hi Jason,
>>>
>>> I have an additional comment regarding using vring.
>>>
>>> On Tue, Sep 3, 2019 at 6:42 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> Kind of, in order to address the above limitation, you probably want t=
o
>>>> implement a vringh based netdevice and driver. It will work like,
>>>> instead of trying to represent a virtio-net device to endpoint,
>>>> represent a new type of network device, it uses two vringh ring instea=
d
>>>> virtio ring. The vringh ring is usually used to implement the
>>>> counterpart of virtio driver. The advantages are obvious:
>>>>
>>>> - no need to deal with two sets of features, config space etc.
>>>> - network specific, from the point of endpoint linux, it's not a virti=
o
>>>> device, no need to care about transport stuffs or embedding internal
>>>> virtio-net specific data structures
>>>> - reuse the exist codes (vringh) to avoid duplicated bugs, implementin=
g
>>>> a virtqueue is kind of challenge
>>> With vringh.c, there is no easy way to interface with virtio_net.c.
>>>
>>> vringh.c is linked with vhost/net.c nicely
>>
>> Let me clarify, vhost_net doesn't use vringh at all (though there's a
>> plan to switch to use vringh).
>>
>>
>>> but again it's not easy to
>>> interface vhost/net.c with the network stack of endpoint kernel. The
>>> vhost drivers are not designed with the purpose of creating another
>>> suite of virtual devices in the host kernel in the first place. If I tr=
y
>>> to manually write code for this interfacing, it seems that I will do
>>> duplicate work that virtio_net.c does.
>>
>> Let me explain:
>>
>> - I'm not suggesting to use vhost_net since it can only deal with
>> userspace virtio rings.
>> - I suggest to introduce netdev that has vringh vring assoticated.
>> Vringh was designed to deal with virtio ring located at different types
>> of memory. It supports userspace vring and kernel vring currently, but
>> it should not be too hard to add support for e.g endpoint device that
>> requires DMA or whatever other method to access the vring. So it was by
>> design to talk directly with e.g kernel virtio device.
>> - In your case, you can read vring address from virtio config space
>> through endpoint framework and then create vringh. It's as simple as:
>> creating a netdev, read vring address, and initialize vringh. Then you
>> can use vringh helper to get iov and build skb etc (similar to caif_virt=
io).
>  From the discussions above and from looking at Jason's mdev patches [1],=
 I've
> created the block diagram below.
>
> While this patch (from Haotian) deals with RC<->EP connection, I'd also l=
ike
> this to be extended for NTB (using multiple EP instances. RC<->EP<->EP<->=
RC)
> [2][3].
>
> +-----------------------------------+   +--------------------------------=
-----+
> |                                   |   |                                =
     |
> |  +------------+  +--------------+ |   | +------------+  +--------------=
+    |
> |  | vringh_net |  | vringh_rpmsg | |   | | virtio_net |  | virtio_rpmsg =
|    |
> |  +------------+  +--------------+ |   | +------------+  +--------------=
+    |
> |                                   |   |                                =
     |
> |          +---------------+        |   |          +---------------+     =
     |
> |          |  vringh_mdev  |        |   |          |  virtio_mdev  |     =
     |
> |          +---------------+        |   |          +---------------+     =
     |
> |                                   |   |                                =
     |
> |  +------------+   +------------+  |   | +-------------------+ +--------=
----+|
> |  | vringh_epf |   | vringh_ntb |  |   | | virtio_pci_common | | virtio_=
ntb ||
> |  +------------+   +------------+  |   | +-------------------+ +--------=
----+|
> | (PCI EP Device)   (NTB Secondary  |   |        (PCI RC)       (NTB Prim=
ary  |
> |                       Device)     |   |                          Device=
)    |
> |                                   |   |                                =
     |
> |                                   |   |                                =
     |
> |             (A)                   |   |              (B)               =
     |
> +-----------------------------------+   +--------------------------------=
-----+
>
> GUEST SIDE (B):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In the virtualization terminology, the side labeled (B) will be the guest=
 side.
> Here it will be the place where PCIe host (RC) side SW will execute (Igno=
re NTB
> for this discussion since PCIe host side SW will execute on both ends of =
the
> link in the case of NTB. However I've included in the block diagram since=
 the
> design we adopt should be able to be extended for NTB as well).
>
> Most of the pieces in (B) already exists.
> 1) virtio_net and virtio_rpmsg: No modifications needed and can be used a=
s it
>     is.
> 2) virtio_mdev: Jason has sent this [1]. This could be used as it is for =
EP
>     usecases as well. Jason has created mvnet based on virtio_mdev, but f=
or EP
>     usecases virtio_pci_common and virtio_ntb should use it.


Can we implement NTB as a transport for virtio, then there's no need for=20
virtio_mdev?


> 3) virtio_pci_common: This should be used when a PCIe EPF is connected. T=
his
>     should be modified to create virtio_mdev instead of directly creating=
 virtio
>     device.
> 4) virtio_ntb: This is used for NTB where one end of the link should use
>     virtio_ntb. This should create virtio_mdev.
>
> With this virtio_mdev can abstract virtio_pci_common and virtio_ntb and i=
deally
> any virtio drivers can be used for EP or NTB (In the block diagram above
> virtio_net and virtio_rpmsg can be used).
>
> HOST SIDE (A):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In the virtualization terminology, the side labeled (A) will be the host =
side.
> Here it will be the place where PCIe device (Endpoint) side SW will execu=
te.
>
> Bits and pieces of (A) should exist but there should be considerable work=
 in this.
> 1) vringh_net: There should be vringh drivers corresponding to
>     the virtio drivers on the guest side (B). vringh_net should register =
with
>     the net core. The vringh_net device should be created by vringh_mdev.=
 This
>     should be new development.
> 2) vringh_rpmsg: vringh_rpmsg should register with the rpmsg core. The
>     vringh_rpmsg device should be created by vringh_mdev.
> 3) vringh_mdev: This layer should define ops specific to vringh (e.g
>     get_desc_addr() should give vring descriptor address and will depend =
on
>     either EP device or NTB device). I haven't looked further on what oth=
er ops
>     will be needed. IMO this layer should also decide whether _kern() or =
_user()
>     vringh helpers should be invoked.


Right, but probably not necessary called "mdev", it could just some=20
abstraction as a set of callbacks.


> 4) vringh_epf: This will be used for PCIe endpoint. This will implement o=
ps to
>     get the vring descriptor address.
> 5) vringh_ntb: Similar to vringh_epf but will interface with NTB device i=
nstead
>     of EPF device.
>
> Jason,
>
> Can you give your comments on the above design? Do you see any flaws/issu=
es
> with the above approach?


Looks good overall, see questions above.

Thanks


>
> Thanks
> Kishon
>
> [1] -> https://lkml.org/lkml/2019/11/18/261
> [2] -> https://lkml.org/lkml/2019/9/26/291
> [3] ->
> https://www.linuxplumbersconf.org/event/4/contributions/395/attachments/2=
84/481/Implementing_NTB_Controller_Using_PCIe_Endpoint_-_final.pdf
>>
>>> There will be two more main disadvantages probably.
>>>
>>> Firstly, there will be two layers of overheads. vhost/net.c uses
>>> vringh.c to channel data buffers into some struct sockets. This is the
>>> first layer of overhead. That the virtual network device will have to
>>> use these sockets somehow adds another layer of overhead.
>>
>> As I said, it doesn't work like vhost and no socket is needed at all.
>>
>>
>>> Secondly, probing, intialization and de-initialization of the virtual
>>> network_device are already non-trivial. I'll likely copy this part
>>> almost verbatim from virtio_net.c in the end. So in the end, there will
>>> be more duplicate code.
>>
>> It will be a new type of network device instead of virtio, you don't
>> need to care any virtio stuffs but vringh in your codes. So it looks to
>> me it would be much simpler and compact.
>>
>> But I'm not saying your method is no way to go, but you should deal with
>> lots of other issues like I've replied in the previous mail. What you
>> want to achieve is
>>
>> 1) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> virtio
>> ring <-> Endpoint (virtio with customized config_ops).
>>
>> But I suggest is
>>
>> 2) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> vringh
>> vring (virtio ring in the Host) <-> network device
>>
>> The differences is.
>> - Complexity: In your proposal, there will be two virtio devices and 4
>> virtqueues. It means you need to prepare two sets of features, config
>> ops etc. And dealing with inconsistent feature will be a pain. It may
>> work for simple case like a virtio-net device with only _F_MAC, but it
>> would be hard to be expanded. If we decide to go for vringh, there will
>> be a single virtio device and 2 virtqueues. In the endpoint part, it
>> will be 2 vringh vring (which is actually point the same virtqueue from
>> Host side) and a normal network device. There's no need for dealing with
>> inconsistency, since vringh basically sever as a a device
>> implementation, the feature negotiation is just between device (network
>> device with vringh) and driver (virtito-pci) from the view of Linux
>> running on the PCI Host.
>> - Maintainability: A third path for dealing virtio ring. We've already
>> had vhost and vringh, a third path will add a lot of overhead when
>> trying to maintaining them. My proposal will try to reuse vringh,
>> there's no need a new path.
>> - Layer violation: We want to hide the transport details from the device
>> and make virito-net device can be used without modification. But your
>> codes try to poke information like virtnet_info. My proposal is to just
>> have a new networking device that won't need to care virtio at all. It's
>> not that hard as you imagine to have a new type of netdev, I suggest to
>> take a look at how caif_virtio is done, it would be helpful.
>>
>> If you still decide to go with two two virtio device model, you need
>> probably:
>> - Proving two sets of config and features, and deal with inconsistency
>> - Try to reuse the vringh codes
>> - Do not refer internal structures from virtio-net.c
>>
>> But I recommend to take a step of trying vringh method which should be
>> much simpler.
>>
>> Thanks
>>
>>
>>> Thank you for your patience!
>>>
>>> Best,
>>> Haotian

