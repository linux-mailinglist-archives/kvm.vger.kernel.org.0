Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285C744A75C
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 08:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbhKIHNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 02:13:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232967AbhKIHNa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 02:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636441844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLEn1ZO8cMF4eZMnUkaaG2kdnz7aDLnKvgv1e8a3C0I=;
        b=Oo2HZd/7whvWrmvAgXhkZmcXhuXSFZDWzoTGHlkbWggtESpvhLN9S4/fhi4RtAsL97T4V9
        YlBItYbaRxxqUnDY4DQv0nZZDTamirGHB6BDqUKdA3WugGXgNd6F5mmM1NrWTso42QUoqX
        nwLfVUKmWKB+SsGU/WCfz2kWeO3+bhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-mmTB3IbkOVyW_ihFQ5WKnQ-1; Tue, 09 Nov 2021 02:10:43 -0500
X-MC-Unique: mmTB3IbkOVyW_ihFQ5WKnQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC33F1006AA1;
        Tue,  9 Nov 2021 07:10:41 +0000 (UTC)
Received: from [10.33.192.183] (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8EA4102AE44;
        Tue,  9 Nov 2021 07:10:35 +0000 (UTC)
Message-ID: <f5aa60d6-6e9b-e64c-9f6a-9e6bdfc21d32@redhat.com>
Date:   Tue, 9 Nov 2021 08:10:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
 <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
 <4d85f61a-818c-4f72-6488-9ae2b21ad90a@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
In-Reply-To: <4d85f61a-818c-4f72-6488-9ae2b21ad90a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/11/2021 14.00, Pierre Morel wrote:
> 
> 
> On 11/3/21 09:14, Thomas Huth wrote:
>> On 03/11/2021 08.56, Andrew Jones wrote:
>>> On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
>>>> +
>>>> +#define VIRTIO_ID_PONG         30 /* virtio pong */
>>>
>>> I take it this is a virtio test device that ping-pong's I/O. It sounds
>>> useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
>>> find it in QEMU at all?
>>
>> I also wonder whether we could do testing with an existing device instead? 
>> E.g. do a loopback with a virtio-serial device? Or use two virtio-net 
>> devices, connect them to a QEMU hub and send a packet from one device to 
>> the other? ... that would be a little bit more complicated here, but would 
>> not require a PONG device upstream first, so it could also be used for 
>> testing older versions of QEMU...
>>
>>   Thomas
>>
>>
> 
> Yes having a dedicated device has the drawback that we need it in QEMU.
> On the other hand using a specific device, serial or network, wouldn't we 
> get trapped with a reduce set of test possibilities?
> 
> The idea was to have a dedicated test device, which could be flexible and 
> extended to test all VIRTIO features, even the current implementation is yet 
> far from it.

Do you have anything in the works that could only be tested with a dedicated 
test device? If not, I'd rather go with the loopback via virtio-net, I think 
(you can peek into the s390-ccw bios sources to see how to send packets via 
virtio-net, shouldn't be too hard to do, I think).

The pong device could later be added on top for additional tests that are 
not possible with virtio-net. And having some basic tests with virito-net 
has also the advantage that the k-u-t work with QEMU binaries where the pong 
device is not available, e.g. older versions and downstream versions that 
only enable the bare minimum of devices to keep the attack surface small.

  Thomas


