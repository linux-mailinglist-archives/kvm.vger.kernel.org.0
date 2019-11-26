Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB45D109E15
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 13:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfKZMgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 07:36:43 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59714 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbfKZMgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 07:36:42 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAQCaVuR048859;
        Tue, 26 Nov 2019 06:36:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574771791;
        bh=vcERJ18wcMnaJA3/y4V2GMdIEZOjeBtH+vfdp4+d8nc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=njFTf4DLIvYOGiUVw5oLYxCa6mYYx/Sb0B5g9suruF6LGsZDSI5b3zrnJffI7Y6CH
         xFn8P7EMfPmhXJJyWhvEbpMInZZhtu0Fs1cShQc8ZNWiNtUEduD9GO0BTwz25ezm0g
         JtpSKl3YfoQUsqKgeDmlDzD7l8zOD/s9O5a1uEaw=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAQCaVZd061181
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 Nov 2019 06:36:31 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 26
 Nov 2019 06:36:31 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 26 Nov 2019 06:36:31 -0600
Received: from [10.24.69.157] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAQCaRsV126481;
        Tue, 26 Nov 2019 06:36:28 -0600
Subject: Re: [PATCH] pci: endpoint: functions: Add a virtnet EP function
To:     Jason Wang <jasowang@redhat.com>,
        Haotian Wang <haotian.wang@sifive.com>, <mst@redhat.com>,
        <lorenzo.pieralisi@arm.com>, <bhelgaas@google.com>,
        Alan Mikhak <alan.mikhak@sifive.com>
CC:     <linux-pci@vger.kernel.org>, <haotian.wang@duke.edu>,
        Jon Mason <jdmason@kudzu.us>, KVM list <kvm@vger.kernel.org>
References: <7067e657-5c8e-b724-fa6a-086fece6e6c3@redhat.com>
 <20190904215801.2971-1-haotian.wang@sifive.com>
 <59982499-0fc1-2e39-9ff9-993fb4dd7dcc@redhat.com>
 <2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com>
 <d87fbe2f-b3ae-5cb1-448a-41335febc460@redhat.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <9f8e596f-b601-7f97-a98a-111763f966d1@ti.com>
Date:   Tue, 26 Nov 2019 18:05:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d87fbe2f-b3ae-5cb1-448a-41335febc460@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 26/11/19 3:28 PM, Jason Wang wrote:
> 
> On 2019/11/25 下午8:49, Kishon Vijay Abraham I wrote:
>> +Alan, Jon
>>
>> Hi Jason, Haotian, Alan,
>>
>> On 05/09/19 8:26 AM, Jason Wang wrote:
>>> On 2019/9/5 上午5:58, Haotian Wang wrote:
>>>> Hi Jason,
>>>>
>>>> I have an additional comment regarding using vring.
>>>>
>>>> On Tue, Sep 3, 2019 at 6:42 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>> Kind of, in order to address the above limitation, you probably want to
>>>>> implement a vringh based netdevice and driver. It will work like,
>>>>> instead of trying to represent a virtio-net device to endpoint,
>>>>> represent a new type of network device, it uses two vringh ring instead
>>>>> virtio ring. The vringh ring is usually used to implement the
>>>>> counterpart of virtio driver. The advantages are obvious:
>>>>>
>>>>> - no need to deal with two sets of features, config space etc.
>>>>> - network specific, from the point of endpoint linux, it's not a virtio
>>>>> device, no need to care about transport stuffs or embedding internal
>>>>> virtio-net specific data structures
>>>>> - reuse the exist codes (vringh) to avoid duplicated bugs, implementing
>>>>> a virtqueue is kind of challenge
>>>> With vringh.c, there is no easy way to interface with virtio_net.c.
>>>>
>>>> vringh.c is linked with vhost/net.c nicely
>>>
>>> Let me clarify, vhost_net doesn't use vringh at all (though there's a
>>> plan to switch to use vringh).
>>>
>>>
>>>> but again it's not easy to
>>>> interface vhost/net.c with the network stack of endpoint kernel. The
>>>> vhost drivers are not designed with the purpose of creating another
>>>> suite of virtual devices in the host kernel in the first place. If I try
>>>> to manually write code for this interfacing, it seems that I will do
>>>> duplicate work that virtio_net.c does.
>>>
>>> Let me explain:
>>>
>>> - I'm not suggesting to use vhost_net since it can only deal with
>>> userspace virtio rings.
>>> - I suggest to introduce netdev that has vringh vring assoticated.
>>> Vringh was designed to deal with virtio ring located at different types
>>> of memory. It supports userspace vring and kernel vring currently, but
>>> it should not be too hard to add support for e.g endpoint device that
>>> requires DMA or whatever other method to access the vring. So it was by
>>> design to talk directly with e.g kernel virtio device.
>>> - In your case, you can read vring address from virtio config space
>>> through endpoint framework and then create vringh. It's as simple as:
>>> creating a netdev, read vring address, and initialize vringh. Then you
>>> can use vringh helper to get iov and build skb etc (similar to caif_virtio).
>>  From the discussions above and from looking at Jason's mdev patches [1], I've
>> created the block diagram below.
>>
>> While this patch (from Haotian) deals with RC<->EP connection, I'd also like
>> this to be extended for NTB (using multiple EP instances. RC<->EP<->EP<->RC)
>> [2][3].
>>
>> +-----------------------------------+   +-------------------------------------+
>> |                                   |   |                                     |
>> |  +------------+  +--------------+ |   | +------------+  +--------------+    |
>> |  | vringh_net |  | vringh_rpmsg | |   | | virtio_net |  | virtio_rpmsg |    |
>> |  +------------+  +--------------+ |   | +------------+  +--------------+    |
>> |                                   |   |                                     |
>> |          +---------------+        |   |          +---------------+          |
>> |          |  vringh_mdev  |        |   |          |  virtio_mdev  |          |
>> |          +---------------+        |   |          +---------------+          |
>> |                                   |   |                                     |
>> |  +------------+   +------------+  |   | +-------------------+ +------------+|
>> |  | vringh_epf |   | vringh_ntb |  |   | | virtio_pci_common | | virtio_ntb ||
>> |  +------------+   +------------+  |   | +-------------------+ +------------+|
>> | (PCI EP Device)   (NTB Secondary  |   |        (PCI RC)       (NTB Primary  |
>> |                       Device)     |   |                          Device)    |
>> |                                   |   |                                     |
>> |                                   |   |                                     |
>> |             (A)                   |   |              (B)                    |
>> +-----------------------------------+   +-------------------------------------+
>>
>> GUEST SIDE (B):
>> ===============
>> In the virtualization terminology, the side labeled (B) will be the guest side.
>> Here it will be the place where PCIe host (RC) side SW will execute (Ignore NTB
>> for this discussion since PCIe host side SW will execute on both ends of the
>> link in the case of NTB. However I've included in the block diagram since the
>> design we adopt should be able to be extended for NTB as well).
>>
>> Most of the pieces in (B) already exists.
>> 1) virtio_net and virtio_rpmsg: No modifications needed and can be used as it
>>     is.
>> 2) virtio_mdev: Jason has sent this [1]. This could be used as it is for EP
>>     usecases as well. Jason has created mvnet based on virtio_mdev, but for EP
>>     usecases virtio_pci_common and virtio_ntb should use it.
> 
> 
> Can we implement NTB as a transport for virtio, then there's no need for
> virtio_mdev?

Yes, we could have NTB specific virtio_config_ops. Where exactly should
virtio_mdev be used?
> 
> 
>> 3) virtio_pci_common: This should be used when a PCIe EPF is connected. This
>>     should be modified to create virtio_mdev instead of directly creating virtio
>>     device.
>> 4) virtio_ntb: This is used for NTB where one end of the link should use
>>     virtio_ntb. This should create virtio_mdev.
>>
>> With this virtio_mdev can abstract virtio_pci_common and virtio_ntb and ideally
>> any virtio drivers can be used for EP or NTB (In the block diagram above
>> virtio_net and virtio_rpmsg can be used).
>>
>> HOST SIDE (A):
>> ===============
>> In the virtualization terminology, the side labeled (A) will be the host side.
>> Here it will be the place where PCIe device (Endpoint) side SW will execute.
>>
>> Bits and pieces of (A) should exist but there should be considerable work in
>> this.
>> 1) vringh_net: There should be vringh drivers corresponding to
>>     the virtio drivers on the guest side (B). vringh_net should register with
>>     the net core. The vringh_net device should be created by vringh_mdev. This
>>     should be new development.
>> 2) vringh_rpmsg: vringh_rpmsg should register with the rpmsg core. The
>>     vringh_rpmsg device should be created by vringh_mdev.
>> 3) vringh_mdev: This layer should define ops specific to vringh (e.g
>>     get_desc_addr() should give vring descriptor address and will depend on
>>     either EP device or NTB device). I haven't looked further on what other ops
>>     will be needed. IMO this layer should also decide whether _kern() or _user()
>>     vringh helpers should be invoked.
> 
> 
> Right, but probably not necessary called "mdev", it could just some abstraction
> as a set of callbacks.

Yeah, we could have something like vringh_config_ops. Once we start to
implement, this might get more clear.
> 
> 
>> 4) vringh_epf: This will be used for PCIe endpoint. This will implement ops to
>>     get the vring descriptor address.
>> 5) vringh_ntb: Similar to vringh_epf but will interface with NTB device instead
>>     of EPF device.
>>
>> Jason,
>>
>> Can you give your comments on the above design? Do you see any flaws/issues
>> with the above approach?
> 
> 
> Looks good overall, see questions above.

Thanks for your comments Jason.

Haotian, Alan, Me or whoever gets to implement this first, should try to follow
the above discussed approach.

Thanks
Kishon

> 
> Thanks
> 
> 
>>
>> Thanks
>> Kishon
>>
>> [1] -> https://lkml.org/lkml/2019/11/18/261
>> [2] -> https://lkml.org/lkml/2019/9/26/291
>> [3] ->
>> https://www.linuxplumbersconf.org/event/4/contributions/395/attachments/284/481/Implementing_NTB_Controller_Using_PCIe_Endpoint_-_final.pdf
>>
>>>
>>>> There will be two more main disadvantages probably.
>>>>
>>>> Firstly, there will be two layers of overheads. vhost/net.c uses
>>>> vringh.c to channel data buffers into some struct sockets. This is the
>>>> first layer of overhead. That the virtual network device will have to
>>>> use these sockets somehow adds another layer of overhead.
>>>
>>> As I said, it doesn't work like vhost and no socket is needed at all.
>>>
>>>
>>>> Secondly, probing, intialization and de-initialization of the virtual
>>>> network_device are already non-trivial. I'll likely copy this part
>>>> almost verbatim from virtio_net.c in the end. So in the end, there will
>>>> be more duplicate code.
>>>
>>> It will be a new type of network device instead of virtio, you don't
>>> need to care any virtio stuffs but vringh in your codes. So it looks to
>>> me it would be much simpler and compact.
>>>
>>> But I'm not saying your method is no way to go, but you should deal with
>>> lots of other issues like I've replied in the previous mail. What you
>>> want to achieve is
>>>
>>> 1) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> virtio
>>> ring <-> Endpoint (virtio with customized config_ops).
>>>
>>> But I suggest is
>>>
>>> 2) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> vringh
>>> vring (virtio ring in the Host) <-> network device
>>>
>>> The differences is.
>>> - Complexity: In your proposal, there will be two virtio devices and 4
>>> virtqueues. It means you need to prepare two sets of features, config
>>> ops etc. And dealing with inconsistent feature will be a pain. It may
>>> work for simple case like a virtio-net device with only _F_MAC, but it
>>> would be hard to be expanded. If we decide to go for vringh, there will
>>> be a single virtio device and 2 virtqueues. In the endpoint part, it
>>> will be 2 vringh vring (which is actually point the same virtqueue from
>>> Host side) and a normal network device. There's no need for dealing with
>>> inconsistency, since vringh basically sever as a a device
>>> implementation, the feature negotiation is just between device (network
>>> device with vringh) and driver (virtito-pci) from the view of Linux
>>> running on the PCI Host.
>>> - Maintainability: A third path for dealing virtio ring. We've already
>>> had vhost and vringh, a third path will add a lot of overhead when
>>> trying to maintaining them. My proposal will try to reuse vringh,
>>> there's no need a new path.
>>> - Layer violation: We want to hide the transport details from the device
>>> and make virito-net device can be used without modification. But your
>>> codes try to poke information like virtnet_info. My proposal is to just
>>> have a new networking device that won't need to care virtio at all. It's
>>> not that hard as you imagine to have a new type of netdev, I suggest to
>>> take a look at how caif_virtio is done, it would be helpful.
>>>
>>> If you still decide to go with two two virtio device model, you need
>>> probably:
>>> - Proving two sets of config and features, and deal with inconsistency
>>> - Try to reuse the vringh codes
>>> - Do not refer internal structures from virtio-net.c
>>>
>>> But I recommend to take a step of trying vringh method which should be
>>> much simpler.
>>>
>>> Thanks
>>>
>>>
>>>> Thank you for your patience!
>>>>
>>>> Best,
>>>> Haotian
> 
