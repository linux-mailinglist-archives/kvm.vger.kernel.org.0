Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE6E34A1B1
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 07:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhCZGVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 02:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhCZGVp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 02:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616739704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEmV2oGJKXgKTwFO5TgbyHMeneGFJ+8pDX/S9wM1xHo=;
        b=X9u+I8I+cE++j6IdMZb2kqndHiAnO30QjvU5jO5f3L+KEO/4rsMQw/HLnHWH/KGRCildFz
        MJNWnNZf3X8/VMOA2SXIhw4tfYo/bUykQgQZvyERHHuZuVek2RvFt4XjRZHuAj95qFRDsU
        nJX9zl+IAMQsFU/VepCv7Qi4xo/h7D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-qm9m_e2eP8eE_aHMOBULGw-1; Fri, 26 Mar 2021 02:21:40 -0400
X-MC-Unique: qm9m_e2eP8eE_aHMOBULGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF7E2190A7A0;
        Fri, 26 Mar 2021 06:21:38 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5EF01972B;
        Fri, 26 Mar 2021 06:21:30 +0000 (UTC)
Subject: Re: [RFC v3 3/5] KVM: implement wire protocol
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
 <f9b5c5cf-63a4-d085-8c99-8d03d29d3f58@redhat.com>
 <5c1c5682b29558a8d2053b4201fbb135e9a61790.camel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <24e7211c-e168-3f47-f789-5f1d743d79c5@redhat.com>
Date:   Fri, 26 Mar 2021 14:21:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <5c1c5682b29558a8d2053b4201fbb135e9a61790.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/3/17 下午9:08, Elena Afanasova 写道:
> On Tue, 2021-03-09 at 14:19 +0800, Jason Wang wrote:
>> On 2021/2/21 8:04 下午, Elena Afanasova wrote:
>>> Add ioregionfd blocking read/write operations.
>>>
>>> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
>>> ---
>>> v3:
>>>    - change wire protocol license
>>>    - remove ioregionfd_cmd info and drop appropriate macros
>>>    - fix ioregionfd state machine
>>>    - add sizeless ioregions support
>>>    - drop redundant check in ioregion_read/write()
>>>
>>>    include/uapi/linux/ioregion.h |  30 +++++++
>>>    virt/kvm/ioregion.c           | 162
>>> +++++++++++++++++++++++++++++++++-
>>>    2 files changed, 190 insertions(+), 2 deletions(-)
>>>    create mode 100644 include/uapi/linux/ioregion.h
>>>
>>> diff --git a/include/uapi/linux/ioregion.h
>>> b/include/uapi/linux/ioregion.h
>>> new file mode 100644
>>> index 000000000000..58f9b5ba6186
>>> --- /dev/null
>>> +++ b/include/uapi/linux/ioregion.h
>>> @@ -0,0 +1,30 @@
>>> +/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-
>>> note) OR BSD-3-Clause) */
>>> +#ifndef _UAPI_LINUX_IOREGION_H
>>> +#define _UAPI_LINUX_IOREGION_H
>>> +
>>> +/* Wire protocol */
>>> +
>>> +struct ioregionfd_cmd {
>>> +	__u8 cmd;
>>> +	__u8 size_exponent : 4;
>>> +	__u8 resp : 1;
>>> +	__u8 padding[6];
>>> +	__u64 user_data;
>>> +	__u64 offset;
>>> +	__u64 data;
>>> +};
>> Sorry if I've asked this before. Do we need a id for each
>> request/response? E.g an ioregion fd could be used by multiple
>> vCPUS.
>> VCPU needs to have a way to find which request belongs to itself or
>> not?
>>
> I don’t think the id is necessary here since all requests/responses are
> serialized.


It's probably fine for the first version but it will degrate the 
performance e.g if the ioregionfd is used for multiple queues (e.g 
doorbell). The design should have the capability to allow the extension 
like this.

Thanks

