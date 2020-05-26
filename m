Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B3E1E2018
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbgEZKuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 06:50:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20920 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388670AbgEZKuF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 06:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590490204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fk8HHNsnJAUTJ9FIaNzxvVA1MW8HvVu7rNQ8UU+/QX8=;
        b=dt0NYxkTQ9ggifTksbBGuoOlUGm7M/LV3++VxF6bSXP3oX69iSGrF5WI7IypiSZjGg/xFR
        Xr+7kEVVhbYH9xYFz52QZvyzQghR/DnS7nEew/1o2TKSkQRLGb1mGR/2cirb2ByykmNkoz
        mEog7mlQDXReNyzzCBZOCqWYfA5MvLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-iIpZ9wvaNwONAhJgOtzhpg-1; Tue, 26 May 2020 06:50:00 -0400
X-MC-Unique: iIpZ9wvaNwONAhJgOtzhpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4F9F460;
        Tue, 26 May 2020 10:49:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-138.ams2.redhat.com [10.36.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 442446AD00;
        Tue, 26 May 2020 10:49:55 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
 <da731645-c408-2e79-4c78-a55b5f0d477b@redhat.com>
 <e87b8573-f227-6e28-9e53-3188b0374754@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a621c370-5ee6-7db2-5942-adb27d8fe9c9@redhat.com>
Date:   Tue, 26 May 2020 12:49:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e87b8573-f227-6e28-9e53-3188b0374754@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/2020 12.41, Janosch Frank wrote:
> On 5/25/20 9:12 PM, Thomas Huth wrote:
>> On 18/05/2020 18.07, Pierre Morel wrote:
>>> First step for testing the channel subsystem is to enumerate the css and
>>> retrieve the css devices.
>>>
>>> This tests the success of STSCH I/O instruction, we do not test the
>>> reaction of the VM for an instruction with wrong parameters.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>  s390x/Makefile      |  1 +
>>>  s390x/css.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++
>>>  s390x/unittests.cfg |  4 ++
>>>  3 files changed, 94 insertions(+)
>>>  create mode 100644 s390x/css.c
>> [...]
>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>> index 07013b2..a436ec0 100644
>>> --- a/s390x/unittests.cfg
>>> +++ b/s390x/unittests.cfg
>>> @@ -83,3 +83,7 @@ extra_params = -m 1G
>>>  [sclp-3g]
>>>  file = sclp.elf
>>>  extra_params = -m 3G
>>> +
>>> +[css]
>>> +file = css.elf
>>> +extra_params =-device ccw-pong
>>
>> I gave your patch series a try on a normal upstream QEMU (that does not
>> have the ccw-pong device yet), and the css test of course fails there,
>> since QEMU bails out with:
>>
>>  -device ccw-pong: 'ccw-pong' is not a valid device model name
>>
>> This is unfortunate - I think we likely have to deal with QEMUs for
>> quite a while that do not have this device enabled. Could you maybe add
>> some kind of check to the kvm-unit-tests scripts that only run a test if
>> a given device is available, and skip the test otherwise?
>>
>>  Thomas
>>
> 
> Could we for now remove it from unittests.cfg and let Pierre come up
> with a solution without delaying this whole series? I expect changes to
> run_tests.sh to attract a rather long discussion...

Fine for me, too.

 Thomas

