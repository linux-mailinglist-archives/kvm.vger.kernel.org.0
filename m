Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D522F59C3
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 05:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhANEGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 23:06:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbhANEGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 23:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610597113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2SauyeBoNIAKM9KVkqWMQKUoIK3y6HHp4d6VTJUfbI=;
        b=bpgTJNXj67KfKI0WSeSvAk+tRY3v8OwXH8gFuuaGncWpnfaBaRHDHhE3ozj9nGL41zP7Is
        hzQlDrUixZ83dxfw4ik2hwO+64srN5dcYx22Ui0isV8bwSpGPxOslAgGprrxLKCaDZNcGY
        NAPrxkSj+wPaBMJovsbQQzm8q58Pgsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-rUm7tYEMNqKybAhDO-Ndug-1; Wed, 13 Jan 2021 23:05:09 -0500
X-MC-Unique: rUm7tYEMNqKybAhDO-Ndug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D59F2800050;
        Thu, 14 Jan 2021 04:05:07 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EDB360C17;
        Thu, 14 Jan 2021 04:05:02 +0000 (UTC)
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
References: <0cc68c81d6fae042d8a84bf90dd77eecd4da7cc8.camel@gmail.com>
 <947ba980-f870-16fb-2ea5-07da617d6bb6@redhat.com>
 <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
 <20210107175311.GA168426@stefanha-x1.localdomain>
 <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
 <20210113155205.GA270353@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7bdcf76d-9eba-428a-bf40-0434934f24a9@redhat.com>
Date:   Thu, 14 Jan 2021 12:05:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210113155205.GA270353@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/13 下午11:52, Stefan Hajnoczi wrote:
> On Wed, Jan 13, 2021 at 10:38:29AM +0800, Jason Wang wrote:
>> On 2021/1/8 上午1:53, Stefan Hajnoczi wrote:
>>> On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
>>>> On 2021/1/6 下午11:05, Stefan Hajnoczi wrote:
>>>>> On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
>>>>>> On 2021/1/5 下午6:25, Stefan Hajnoczi wrote:
>>>>>>> On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
>>>>>>>> On 2021/1/5 上午8:02, Elena Afanasova wrote:
>>>>>>>>> On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
>>>>>>>>>> On 2021/1/4 上午4:32, Elena Afanasova wrote:
>>>>>>>>>>> On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
>>>>>>>>>>>> On 2020/12/29 下午6:02, Elena Afanasova wrote:
>>> 2. If separate userspace threads process the virtqueues, then set up the
>>>      virtio-pci capabilities so the virtqueues have separate notification
>>>      registers:
>>>      https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1150004
>>
>> Right. But this works only when PCI transport is used and queue index could
>> be deduced from the register address (separated doorbell).
>>
>> If we use MMIO or sharing the doorbell registers among all the virtqueues
>> (multiplexer is zero in the above case) , it can't work without datamatch.
> True. Can you think of an application that needs to dispatch a shared
> doorbell register to several threads?


I think it depends on semantic of doorbell register. I guess one example 
is the virito-mmio multiqueue device.


>
> If this is a case that real-world applications need then we should
> tackle it. This is where eBPF would be appropriate. I guess the
> interface would be something like:
>
>    /*
>     * A custom demultiplexer function that returns the index of the <wfd,
>     * rfd> pair to use or -1 to produce a KVM_EXIT_IOREGION_FAILURE that
>     * userspace must handle.
>     */
>    int demux(const struct ioregionfd_cmd *cmd);
>
> Userspace can install an eBPF demux function as well as an array of
> <wfd, rfd> fd pairs. The demux function gets to look at the cmd in order
> to decide which fd pair it is sent to.
>
> This is how I think eBPF datamatch could work. It's not as general as in
> our original discussion where we also talked about custom protocols
> (instead of struct ioregionfd_cmd/struct ioregionfd_resp).


Actually they are not conflict. We can make it a eBPF ioregion, then 
it's the eBPF program that can decide:

1) whether or not it need to do datamatch
2) how many file descriptors it want to use (store the fd in a map)
3) how will the protocol looks like

But as discussed it could be an add-on on top of the hard logic of 
ioregion since there could be case that eBPF may not be allowed not not 
supported. So adding simple datamatch support as a start might be a good 
choice.

Thanks


>
> Stefan

