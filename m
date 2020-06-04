Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED00C1EE3A6
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgFDLpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:45:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgFDLpw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 07:45:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591271150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mGdl0RSQZKhVpNjVS/OmBxoCGQnHWjmoW5V8/c58GU0=;
        b=NaA0JNZZstMOF5oF2qC2XD4Nzirl/EkTZY3bPwxHGBpcbX4CjHIFk7Pzvg8lfGMrKZeMiS
        IGjVUH3M3bJUbdmF5OdeeQPQ/u5D5MhvfFESYBGTSAw8eZ/DLFnfm5aZGUYFhzv38HNMJ6
        4vT7UqTxAGNeWinAiM9ZFNyvKltVtzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-dYWJrmMxO-2WQjRdYJkLBA-1; Thu, 04 Jun 2020 07:45:48 -0400
X-MC-Unique: dYWJrmMxO-2WQjRdYJkLBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C766A80058E;
        Thu,  4 Jun 2020 11:45:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-105.ams2.redhat.com [10.36.112.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FF0710013D2;
        Thu,  4 Jun 2020 11:45:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
 <20200527105501.53681762.cohuck@redhat.com>
 <d3890f6a-1c0e-b4cc-f958-6f33bdf75666@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8b8fff3f-4954-c51e-59a3-813cb5066e26@redhat.com>
Date:   Thu, 4 Jun 2020 13:45:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d3890f6a-1c0e-b4cc-f958-6f33bdf75666@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/2020 13.35, Pierre Morel wrote:
> 
> 
> On 2020-05-27 10:55, Cornelia Huck wrote:
>> On Mon, 18 May 2020 18:07:27 +0200
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> First step for testing the channel subsystem is to enumerate the css and
>>> retrieve the css devices.
>>>
>>> This tests the success of STSCH I/O instruction, we do not test the
>>> reaction of the VM for an instruction with wrong parameters.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   s390x/Makefile      |  1 +
>>>   s390x/css.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++
>>>   s390x/unittests.cfg |  4 ++
>>>   3 files changed, 94 insertions(+)
>>>   create mode 100644 s390x/css.c
>>
>> (...)
>>
>>> +static void test_enumerate(void)
>>> +{
>>> +    struct pmcw *pmcw = &schib.pmcw;
>>> +    int cc;
>>> +    int scn;
>>> +    int scn_found = 0;
>>> +    int dev_found = 0;
>>> +
>>> +    for (scn = 0; scn < 0xffff; scn++) {
>>> +        cc = stsch(scn|SID_ONE, &schib);
>>> +        switch (cc) {
>>> +        case 0:        /* 0 means SCHIB stored */
>>> +            break;
>>> +        case 3:        /* 3 means no more channels */
>>> +            goto out;
>>> +        default:    /* 1 or 2 should never happened for STSCH */
>>> +            report(0, "Unexpected cc=%d on subchannel number 0x%x",
>>> +                   cc, scn);
>>> +            return;
>>> +        }
>>> +
>>> +        /* We currently only support type 0, a.k.a. I/O channels */
>>> +        if (PMCW_CHANNEL_TYPE(pmcw) != 0)
>>> +            continue;
>>> +
>>> +        /* We ignore I/O channels without valid devices */
>>> +        scn_found++;
>>> +        if (!(pmcw->flags & PMCW_DNV))
>>> +            continue;
>>> +
>>> +        /* We keep track of the first device as our test device */
>>> +        if (!test_device_sid)
>>> +            test_device_sid = scn | SID_ONE;
>>> +
>>> +        dev_found++;
>>> +    }
>>> +
>>> +out:
>>> +    report(dev_found,
>>> +           "Tested subchannels: %d, I/O subchannels: %d, I/O
>>> devices: %d",
>>> +           scn, scn_found, dev_found);
>>
>> Just wondering: with the current invocation, you expect to find exactly
>> one subchannel with a valid device, right?
> ...snip...
> 
>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>> index 07013b2..a436ec0 100644
>>> --- a/s390x/unittests.cfg
>>> +++ b/s390x/unittests.cfg
>>> @@ -83,3 +83,7 @@ extra_params = -m 1G
>>>   [sclp-3g]
>>>   file = sclp.elf
>>>   extra_params = -m 3G
>>> +
>>> +[css]
>>> +file = css.elf
>>> +extra_params =-device ccw-pong
>>
>> Hm... you could test enumeration even with a QEMU that does not include
>> support for the pong device, right? Would it be worthwhile to split out
>> a set of css tests that use e.g. a virtio-net-ccw device, and have a
>> css-pong set of tests that require the pong device?
>>
> 
> Yes, you are right, using a virtio-net-ccw will allow to keep this test
> without waiting for the PONG device to exist.
> 
> @Thomas, what do you think? I will still have to figure something out
> for PONG tests but here, it should be OK with virtio-net-ccw.

Sure, sounds good. We can go with -device virtio-net-ccw for now, and
then later add an additional entry a la:

[css-pong]
file = css.elf
device = ccw-pong

... where the test scripts then check for the availability of the device
first before starting the test?

 Thomas

