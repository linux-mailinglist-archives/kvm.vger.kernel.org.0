Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502722F7111
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 04:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbhAODne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 22:43:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726311AbhAODne (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 22:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610682127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07u9w2RMCCnwjBFVKZddXiFsgFNPjUdeBmvqu0VF23o=;
        b=LXPjhgy87Y6SzWNk7H1CfJd5ErKHJfyqsJiAytZJdX1oh3rGxhoWHywDUkailePklZD6Pv
        aKRrVxdgTOHj3YIHj3k12hG5PoLX6b4T3e00tFXekFFmvvReiJEeewnsU73KygMsDXdTYd
        2KEDcTm+xwQO5W6F40j1YExYspWaNPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-QbtFbWuGMJiD3VcrMGLyBQ-1; Thu, 14 Jan 2021 22:42:02 -0500
X-MC-Unique: QbtFbWuGMJiD3VcrMGLyBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD88107ACF7;
        Fri, 15 Jan 2021 03:42:01 +0000 (UTC)
Received: from [10.72.13.112] (ovpn-13-112.pek2.redhat.com [10.72.13.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51E1010016FE;
        Fri, 15 Jan 2021 03:41:56 +0000 (UTC)
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
References: <29955fdc90d2efab7b79c91b9a97183e95243cc1.camel@gmail.com>
 <47e8b7e8-d9b8-b2a2-c014-05942d99452a@redhat.com>
 <20210105102517.GA31084@stefanha-x1.localdomain>
 <f9cd33f6-c30d-4e5a-bc45-8f42109fe1ce@redhat.com>
 <20210106150525.GB130669@stefanha-x1.localdomain>
 <32b49857-4ac7-0646-929d-c9238b50bc49@redhat.com>
 <20210107175311.GA168426@stefanha-x1.localdomain>
 <e22eaf2b-15f6-5b41-75a8-0e9b24e84e16@redhat.com>
 <20210113155205.GA270353@stefanha-x1.localdomain>
 <7bdcf76d-9eba-428a-bf40-0434934f24a9@redhat.com>
 <20210114161651.GG292902@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1f15d3a1-2ea5-3b42-fa02-1d21de3e04a0@redhat.com>
Date:   Fri, 15 Jan 2021 11:41:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210114161651.GG292902@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/15 上午12:16, Stefan Hajnoczi wrote:
> On Thu, Jan 14, 2021 at 12:05:00PM +0800, Jason Wang wrote:
>> On 2021/1/13 下午11:52, Stefan Hajnoczi wrote:
>>> On Wed, Jan 13, 2021 at 10:38:29AM +0800, Jason Wang wrote:
>>>> On 2021/1/8 上午1:53, Stefan Hajnoczi wrote:
>>>>> On Thu, Jan 07, 2021 at 11:30:47AM +0800, Jason Wang wrote:
>>>>>> On 2021/1/6 下午11:05, Stefan Hajnoczi wrote:
>>>>>>> On Wed, Jan 06, 2021 at 01:21:43PM +0800, Jason Wang wrote:
>>>>>>>> On 2021/1/5 下午6:25, Stefan Hajnoczi wrote:
>>>>>>>>> On Tue, Jan 05, 2021 at 11:53:01AM +0800, Jason Wang wrote:
>>>>>>>>>> On 2021/1/5 上午8:02, Elena Afanasova wrote:
>>>>>>>>>>> On Mon, 2021-01-04 at 13:34 +0800, Jason Wang wrote:
>>>>>>>>>>>> On 2021/1/4 上午4:32, Elena Afanasova wrote:
>>>>>>>>>>>>> On Thu, 2020-12-31 at 11:45 +0800, Jason Wang wrote:
>>>>>>>>>>>>>> On 2020/12/29 下午6:02, Elena Afanasova wrote:
>>>>> 2. If separate userspace threads process the virtqueues, then set up the
>>>>>       virtio-pci capabilities so the virtqueues have separate notification
>>>>>       registers:
>>>>>       https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1150004
>>>> Right. But this works only when PCI transport is used and queue index could
>>>> be deduced from the register address (separated doorbell).
>>>>
>>>> If we use MMIO or sharing the doorbell registers among all the virtqueues
>>>> (multiplexer is zero in the above case) , it can't work without datamatch.
>>> True. Can you think of an application that needs to dispatch a shared
>>> doorbell register to several threads?
>>
>> I think it depends on semantic of doorbell register. I guess one example is
>> the virito-mmio multiqueue device.
> Good point. virtio-mmio really needs datamatch if virtqueues are handled
> by different threads.
>
>>> If this is a case that real-world applications need then we should
>>> tackle it. This is where eBPF would be appropriate. I guess the
>>> interface would be something like:
>>>
>>>     /*
>>>      * A custom demultiplexer function that returns the index of the <wfd,
>>>      * rfd> pair to use or -1 to produce a KVM_EXIT_IOREGION_FAILURE that
>>>      * userspace must handle.
>>>      */
>>>     int demux(const struct ioregionfd_cmd *cmd);
>>>
>>> Userspace can install an eBPF demux function as well as an array of
>>> <wfd, rfd> fd pairs. The demux function gets to look at the cmd in order
>>> to decide which fd pair it is sent to.
>>>
>>> This is how I think eBPF datamatch could work. It's not as general as in
>>> our original discussion where we also talked about custom protocols
>>> (instead of struct ioregionfd_cmd/struct ioregionfd_resp).
>>
>> Actually they are not conflict. We can make it a eBPF ioregion, then it's
>> the eBPF program that can decide:
>>
>> 1) whether or not it need to do datamatch
>> 2) how many file descriptors it want to use (store the fd in a map)
>> 3) how will the protocol looks like
>>
>> But as discussed it could be an add-on on top of the hard logic of ioregion
>> since there could be case that eBPF may not be allowed not not supported. So
>> adding simple datamatch support as a start might be a good choice.
> Let's go further. Can you share pseudo-code for the eBPF program's
> function signature (inputs/outputs)?


It could be something like this:

1) The eBPF program context could be defined as ioregion_ctx:

struct ioregion_ctx {
     gpa_t addr;
     int len;
     void *val;
};

2) The eBPF program return value could be, 0 (IOREGION_OK) means that 
the the program can handle this I/O request, otherwise failure 
(IOREGION_FAIL)

So for implementing the datamatch, userspace is required to stored the 
file descriptors for doorbell dispatching in a map (dispatch_map). For 
virtio style doorbell, we can simply:

- find the fd via bpf map lookup
- build the protocol
- use the eBPF helper to send the command (I don't check but I guess we 
need invent new eBPF helpers for read and write from a file)

Like:

SEC("datamatch")
int datamatch_prog(struct ioregion_ctx *ctx)
{
     int *fd, ret;
     struct customized_protocol protocol;
     fd = bpf_map_lookup_elem(&ctx->val, &dispatch_map);
     if (!fd)
         return IOREGION_FAIL;
     build_protocol(ctx, &protocol);
     ret = bpf_fd_write(fd, &protocol, sizeof(protocol);
     if (ret != sizeof(protocol))
         return IOREGION_FAIL;
     return IOREGION_OK;
}

Thanks


>
> Stefan

