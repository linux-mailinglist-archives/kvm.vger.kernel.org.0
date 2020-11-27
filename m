Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDB2C5F0A
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 04:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbgK0Djq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 22:39:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727037AbgK0Djq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 22:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606448385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRpTLsgF/txC3+ZLF49orMM1xGYi7QtsWVXLf1XIl7I=;
        b=Slswnm3Yvn1HTbRn+qgAT8us/OXZ8kBs1riSG0UNqb3qGciD/8wXe2ipmgUVwSHFsduEdn
        5dCQlsOao3KWRTTUPGOH8AHcHOGl8/yqA+hsY/qXeX3uIsvUrWloTnSypOv6gSSUUfx8eY
        k0KKBQPw+oAMVXTdWMERG0jBLUjDxbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-VPMoAFDtOCG5v2Rjq0ttaQ-1; Thu, 26 Nov 2020 22:39:43 -0500
X-MC-Unique: VPMoAFDtOCG5v2Rjq0ttaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBCF01006C8E;
        Fri, 27 Nov 2020 03:39:41 +0000 (UTC)
Received: from [10.72.13.168] (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E595660BF1;
        Fri, 27 Nov 2020 03:39:24 +0000 (UTC)
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
 <20201126123659.GC1180457@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
Date:   Fri, 27 Nov 2020 11:39:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201126123659.GC1180457@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/11/26 下午8:36, Stefan Hajnoczi wrote:
> On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
>> On 2020/11/26 上午3:21, Elena Afanasova wrote:
>>> Hello,
>>>
>>> I'm an Outreachy intern with QEMU and I’m working on implementing the
>>> ioregionfd API in KVM.
>>> So I’d like to resume the ioregionfd design discussion. The latest
>>> version of the ioregionfd API document is provided below.
>>>
>>> Overview
>>> --------
>>> ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO accesses
>>> over a
>>> file descriptor without returning from ioctl(KVM_RUN). This allows device
>>> emulation to run in another task separate from the vCPU task.
>>>
>>> This is achieved through KVM ioctls for registering MMIO/PIO regions and
>>> a wire
>>> protocol that KVM uses to communicate with a task handling an MMIO/PIO
>>> access.
>>>
>>> The traditional ioctl(KVM_RUN) dispatch mechanism with device emulation
>>> in a
>>> separate task looks like this:
>>>
>>>     kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task <---messages---> device
>>> task
>>>
>>> ioregionfd improves performance by eliminating the need for the vCPU
>>> task to
>>> forward MMIO/PIO exits to device emulation tasks:
>>
>> I wonder at which cases we care performance like this. (Note that vhost-user
>> suppots set|get_config() for a while).
> NVMe emulation needs this because ioeventfd cannot transfer the value
> written to the doorbell. That's why QEMU's NVMe emulation doesn't
> support IOThreads.


I think it depends on how many different value that can be carried via 
doorbell. If it's not tons of, we can use datamatch. Anyway virtio 
support differing queue index via the value wrote to doorbell.


>
>>> KVM_CREATE_IOREGIONFD
>>> ---------------------
>>> :Capability: KVM_CAP_IOREGIONFD
>>> :Architectures: all
>>> :Type: system ioctl
>>> :Parameters: none
>>> :Returns: an ioregionfd file descriptor, -1 on error
>>>
>>> This ioctl creates a new ioregionfd and returns the file descriptor. The
>>> fd can
>>> be used to handle MMIO/PIO accesses instead of returning from
>>> ioctl(KVM_RUN)
>>> with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions must
>>> be
>>> registered with KVM_SET_IOREGION in order to receive MMIO/PIO accesses
>>> on the
>>> fd. An ioregionfd can be used with multiple VMs and its lifecycle is not
>>> tied
>>> to a specific VM.
>>>
>>> When the last file descriptor for an ioregionfd is closed, all regions
>>> registered with KVM_SET_IOREGION are dropped and guest accesses to those
>>> regions cause ioctl(KVM_RUN) to return again.
>>
>> I may miss something, but I don't see any special requirement of this fd.
>> The fd just a transport of a protocol between KVM and userspace process. So
>> instead of mandating a new type, it might be better to allow any type of fd
>> to be attached. (E.g pipe or socket).
> pipe(2) is unidirectional on Linux, so it won't work.


Can we accept two file descriptors to make it work?


>
> mkfifo(3) seems usable but creates a node on a filesystem.
>
> socketpair(2) would work, but brings in the network stack when it's not
> needed. The advantage is that some future user case might want to direct
> ioregionfd over a real socket to a remote host, which would be cool.
>
> Do you have an idea of the performance difference of socketpair(2)
> compared to a custom fd?


It should be slower than custom fd and UNIX socket should be faster than 
TIPC. Maybe we can have a custom fd, but it's better to leave the policy 
to the userspace:

1) KVM should not have any limitation of the fd it uses, user will risk 
itself if the fd has been used wrongly, and the custom fd should be one 
of the choice
2) it's better to not have a virt specific name (e.g "KVM" or "ioregion")

Or I wonder whether we can attach an eBPF program when trapping MMIO/PIO 
and allow it to decide how to proceed?

Thanks


>
> If it's neglible then using an arbitrary socket is more flexible and
> sounds good.
>
> Stefan

