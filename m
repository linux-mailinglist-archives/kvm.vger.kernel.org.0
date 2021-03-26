Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBD934A22C
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 07:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZGsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 02:48:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhCZGsG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 02:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616741285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7T66NK7RzhhLKNGnHgeuznGsneUpDSkJWEWR9gtmMJs=;
        b=S/cq3q8NZGXmsvOk3nmTCGE4/shr0wsFjnxfmbIUn0+jOVO42Elh1s9WxhdTJZUZaooxTN
        yS6LaaPju493n6nwiG/unxbP9u/F37zBV81V7evRNzRdbhQ4zlBVqmVJal0DfQZXIR+cxv
        w3ko+M6hmzpniYclzjCoVFvLlajHWI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-CZiFB5e4PFychvkUAFu8og-1; Fri, 26 Mar 2021 02:48:02 -0400
X-MC-Unique: CZiFB5e4PFychvkUAFu8og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3B5D814256;
        Fri, 26 Mar 2021 06:48:01 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E90C85D9CA;
        Fri, 26 Mar 2021 06:47:51 +0000 (UTC)
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
To:     Elena Afanasova <eafanasova@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
 <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
 <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
 <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
 <50823987-d285-7a18-7c46-771f08c3c0ff@redhat.com>
 <95b1dc00ff533ce004ecc656bd130bd07e29a1f0.camel@gmail.com>
 <6ff79d0b-3b6a-73d3-ffbd-e4af9758735f@redhat.com>
 <7257025149c6a7369e7e2fd7c6291879c4bc127d.camel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <069a99cd-2352-de6a-9e2e-47932e355650@redhat.com>
Date:   Fri, 26 Mar 2021 14:47:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7257025149c6a7369e7e2fd7c6291879c4bc127d.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/3/17 下午6:46, Elena Afanasova 写道:
> On Thu, 2021-03-11 at 11:04 +0800, Jason Wang wrote:
>> On 2021/3/11 12:41 上午, Elena Afanasova wrote:
>>> On Wed, 2021-03-10 at 15:11 +0100, Paolo Bonzini wrote:
>>>> On 10/03/21 14:20, Elena Afanasova wrote:
>>>>> On Tue, 2021-03-09 at 09:01 +0100, Paolo Bonzini wrote:
>>>>>> On 09/03/21 08:54, Jason Wang wrote:
>>>>>>>> +        return;
>>>>>>>> +
>>>>>>>> +    spin_lock(&ctx->wq.lock);
>>>>>>>> +    wait_event_interruptible_exclusive_locked(ctx->wq,
>>>>>>>> !ctx-
>>>>>>>>> busy);
>>>>>>> Any reason that a simple mutex_lock_interruptible() can't
>>>>>>> work
>>>>>>> here?
>>>>>> Or alternatively why can't the callers just take the
>>>>>> spinlock.
>>>>>>
>>>>> I'm not sure I understand your question. Do you mean why locked
>>>>> version
>>>>> of wait_event() is used?
>>>> No, I mean why do you need to use ctx->busy and wait_event,
>>>> instead
>>>> of
>>>> operating directly on the spinlock or on a mutex.
>>>>
>>> When ioregionfd communication is interrupted by a signal
>>> ioctl(KVM_RUN)
>>> has to return to userspace. I'm not sure it's ok to do that with
>>> the
>>> spinlock/mutex being held.
>>
>> So you don't answer my question. Why you can't use
>> mutex_lock_interruptible() here?
>>
>> It looks can do exactly what you want here.
>>
>> Thanks
>>
> I think mutex could work here. I used it for the first implementation.
> But is it ok to hold a mutex on kernel->user transitions? Is it correct
> pattern in this case?


I may miss something but the semantic is the same for the following of 
the two?

A:
     spin_lock(&ctx->wq.lock);
     wait_event_interruptible_exclusive_locked(ctx->wq, !ctx->busy);
     ctx->busy = true;
     spin_unlock(&ctx->wq.lock);

B:
     mutex_lock_interruptible(&ctx->lock);


> If ioctl returns to userspace and then ioregionfd is deleted or vcpu fd
> is closed, with a mutex held it will be necessary to unlock it.


It's something nature and anything different with your current code that 
uses spinlock + waitqueue? And we can know whehter or not we're 
interrupt by a singal (I notice you don't check the return value of 
wait_event_interruptible_exclusive_locked() and set ctx->busy to true 
unconditonally which is probably wrong.


>   But I
> think it’s a bit clearer to use wake_up in e.g. kvm_vcpu_release
> instead of mutex_unlock.


I am not sure I undersatnd here (I dont' this how it is doen in this patch).

Thanks


>   Paolo, could you please also comment on this?
>
>>

