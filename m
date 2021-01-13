Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29992F41E0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 03:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbhAMCkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 21:40:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbhAMCkJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 21:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610505521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iuGaYtVMBLhWJbYYLN9X8M05CK3YE9U9tMbPnKWv4Po=;
        b=XeSdIsS06LRplS9lWlz+C3P6tlPixV2Pcnw/uB0//SRHd1tEGBcH8UJRKkcPfSygLV0d0V
        m70x1Up+04p5LGxoZ+zt9ixbFy9m7pWX5ich16clr46g11LsEiaHSbTFEGryfJsIS6qS9w
        mmGpnRmR0X2BXR2/hec0kp2t7UzYYDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-CsH2_h15Oh6qS3DvThEEOA-1; Tue, 12 Jan 2021 21:38:36 -0500
X-MC-Unique: CsH2_h15Oh6qS3DvThEEOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50B49100A611;
        Wed, 13 Jan 2021 02:38:35 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7986010016FE;
        Wed, 13 Jan 2021 02:38:30 +0000 (UTC)
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
References: <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
 <d79bdf44-9088-e005-3840-03f6bad22ed7@redhat.com>
 <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
 <20210107175311.GA168426@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
Date:   Wed, 13 Jan 2021 10:38:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210107175311.GA168426@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/8 上午1:53, Stefan Hajnoczi wrote:
> On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
>> On 2021/1/6 下午11:05, Stefan Hajnoczi wrote:
>>> On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
>>>> On 2021/1/5 下午6:25, Stefan Hajnoczi wrote:
>>>>> On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
>>>>>> On 2021/1/5 上午8:02, Elena Afanasova wrote:
>>>>>>> On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
>>>>>>>> On 2021/1/4 上午4:32, Elena Afanasova wrote:
>>>>>>>>> On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
>>>>>>>>>> On 2020/12/29 下午6:02, Elena Afanasova wrote:
>>>>>>>>>>> This vm ioctl adds or removes an ioregionfd MMIO/PIO region.
>>>>>>>>>> How about FAST_MMIO?
>>>>>>>>>>
>>>>>>>>> I’ll add KVM_IOREGION_FAST_MMIO flag support. So this may be
>>>>>>>>> suitable
>>>>>>>>> for triggers which could use posted writes. The struct
>>>>>>>>> ioregionfd_cmd
>>>>>>>>> size bits and the data field will be unused in this case.
>>>>>>>> Note that eventfd checks for length and have datamatch support. Do
>>>>>>>> we
>>>>>>>> need to do something similar.
>>>>>>>>
>>>>>>> Do you think datamatch support is necessary for ioregionfd?
>>>>>> I'm not sure. But if we don't have this support, it probably means we can't
>>>>>> use eventfd for ioregionfd.
>>>>> This is an interesting question because ioregionfd and ioeventfd have
>>>>> different semantics. While it would be great to support all ioeventfd
>>>>> features in ioregionfd, I'm not sure that is possible. I think ioeventfd
>>>>> will remain useful for devices that only need a doorbell write register.
>>>>>
>>>>> The differences:
>>>>>
>>>>> 1. ioeventfd has datamatch. This could be implemented in ioregionfd so
>>>>>       that a datamatch failure results in the classic ioctl(KVM_RETURN)
>>>>>       MMIO/PIO exit reason and the VMM can handle the access.
>>>>>
>>>>>       I'm not sure if this feature is useful though. Most of the time
>>>>>       ioregionfd users want to handle all accesses to the region and the
>>>>>       VMM may not even know how to handle register accesses because they
>>>>>       can only be handled in a dedicated thread or an out-of-process
>>>>>       device.
>>>> It's about whether or not the current semantic of ioregion is sufficient for
>>>> implementing doorbell.
>>>>
>>>> E.g in the case of virtio, the virtqueue index is encoded in the write to
>>>> the doorbell. And if a single MMIO area is used for all virtqueues,
>>>> datamatch is probably a must in this case.
>>> struct ioregionfd_cmd contains not just the register offset, but also
>>> the value written by the guest. Therefore datamatch is not necessary.
>>>
>>> Datamatch would only be useful as some kind of more complex optimization
>>> where different values writtent to the same register dispatch to
>>> different fds.
>>
>> That's exactly the case of virtio. Consider queue 1,2 shares the MMIO
>> register. We need use datamatch to dispatch the notification to different
>> eventfds.
> I can see two options without datamatch:
>
> 1. If both virtqueues are handled by the same userspace thread then only
>     1 fd is needed. ioregionfd sends the value written to the register,
>     so userspace is able to distinguish between the virtqueues.


Right.


>
> 2. If separate userspace threads process the virtqueues, then set up the
>     virtio-pci capabilities so the virtqueues have separate notification
>     registers:
>     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1150004


Right. But this works only when PCI transport is used and queue index 
could be deduced from the register address (separated doorbell).

If we use MMIO or sharing the doorbell registers among all the 
virtqueues (multiplexer is zero in the above case) , it can't work 
without datamatch.


>
> With ioeventfd 2 fds are needed in case #1 because the data value
> written to the register is not communicated to userspace. But ioregionfd
> does not have this limitation, so I'm not sure whether datamatch is
> really needed in ioregionfd?
>
> Or is there a use case that I missed?
>
>>>>>>>> I guess the idea is to have a generic interface to let eventfd work
>>>>>>>> for
>>>>>>>> ioregion as well.
>>>>>>>>
>>>>>>> It seems that posted writes is the only "fast" case in ioregionfd. So I
>>>>>>> was thinking about using FAST_MMIO for this case only. Maybe in some
>>>>>>> cases it will be better to just use ioeventfd. But I'm not sure.
>>>>>> To be a generic infrastructure, it's better to have this, but we can listen
>>>>>> from the opinion of others.
>>>>> I think we want both FAST_MMIO and regular MMIO options for posted
>>>>> writes:
>>>>>
>>>>> 1. FAST_MMIO - ioregionfd_cmd size and data fields are zero and do not
>>>>>       contain information about the nature of the guest access. This is
>>>>>       fine for ioeventfd doorbell style registers because we don't need
>>>>>       that information.
>>>> Is FAST_MMIO always for doorbell? If not, we probably need the size and
>>>> data.
>>> My understanding is that FAST_MMIO only provides the guest physical
>>> address and no additional information. In fact, I'm not even sure if we
>>> know whether the access is a read or a write.
>>>
>>> So there is extremely limited information to work with and it's
>>> basically only useful for doorbell writes.
>>>
>>>>> 2. Regular MMIO - ioregionfd_cmd size and data fields contain valid data
>>>>>       about the nature of the guest access. This is needed when the device
>>>>>       register is more than a simple "kick" doorbell. For example, if the
>>>>>       device needs to know the value that the guest wrote.
>>>>>
>>>>> I suggest defining an additional KVM_SET_IOREGION flag called
>>>>> KVM_IOREGION_FAST_MMIO that can be set together with
>>>>> KVM_IOREGION_POSTED_WRITES.
>>>> If we need to expose FAST_MMIO to userspace, we probably need to define its
>>>> semantics which is probably not easy since it's an architecture
>>>> optimization.
>>> Maybe the name KVM_IOREGION_FAST_MMIO name should be changed to
>>> something more specific like KVM_IOREGION_OFFSET_ONLY, meaning that only
>>> the offset field is valid.
>>
>> Or we can do like what eventfd did, implies FAST_MMIO when memory_size is
>> zero (kvm_assign_ioeventfd()):
>>
>>      if (!args->len && bus_idx == KVM_MMIO_BUS) {
>>          ret = kvm_assign_ioeventfd_idx(kvm, KVM_FAST_MMIO_BUS, args);
>>          if (ret < 0)
>>              goto fast_fail;
>>      }
> Yes!
>
>>> I haven't checked if and how other architectures implement FAST_MMIO,
>>> but they will at least be able to provide the offset :).
>>>
>>>>> KVM_IOREGION_PIO cannot be used together with KVM_IOREGION_FAST_MMIO.
>>>>>
>>>>> In theory KVM_IOREGION_POSTED_WRITES doesn't need to be set with
>>>>> KVM_IOREGION_FAST_MMIO. Userspace would have to send back a struct
>>>>> ioregionfd_resp to acknowledge that the write has been handled.
>>>> Right, and it also depends on whether or not the hardware support (e.g
>>>> whether or not it can decode the instructions).
>>> The KVM_IOREGION_FAST_MMIO flag should be documented as an optimization
>>> hint. If hardware doesn't support FAST_MMIO then struct ioregionfd_cmd
>>> will contain all fields. Userspace will be able to process the cmd
>>> either way.
>>
>> You mean always have a fallback to MMIO for FAST_MMIO? That should be fine
>> but looks less optimal than the implying FAST_MMIO for zero length. I still
>> think introducing "FAST_MMIO" may bring confusion for users ...
> Regarding the fallback, my understanding is that ioeventfds are always
> placed on both the MMIO and FAST_MMIO bus when len is zero. That way
> architectures that don't support FAST_MMIO will still dispatch those
> ioeventfds. In virt/kvm/eventfd.c:kvm_assign_ioeventfd():
>
>    ret = kvm_assign_ioeventfd_idx(kvm, bus_idx, args);
>    ...
>    if (!args->len && bus_idx == KVM_MMIO_BUS) {
>        ret = kvm_assign_ioeventfd_idx(kvm, KVM_FAST_MMIO_BUS, args);
>
> So ioeventfd is already doing this fallback thing.
>
> Let's follow ioeventfd:
> 1. len=0 means the size/data fields are not needed. Userspace cannot
>     rely on these fields being valid.
> 2. There is an automatic fallback to the slow MMIO bus so that slow path
>     accesses are still detected by the ioregion.
>
> The explicit KVM_IOREGION_FAST_MMIO flag I mentioned is not needed.


Agreed.

Thanks


>
> Stefan

