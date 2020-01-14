Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1A613B149
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgANRrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:47:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21447 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726450AbgANRrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 12:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579024043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8MQJmmxhx6MNID9d0njZZ56kG0fOqofrJYc9sZflyI=;
        b=RHCV3zLRvpklBCzhsrTvqIdO0qii0qRjJzouf3JGmvedsu+eGpjI/cjUqSmU/VDFqQW9Lf
        QZk+jrkSeDSWHq95CKJ1sypsmRFQV0J+SY3rKwBbbgmrNvE+YzD6v2wtbFpMB3WN9Z8BwP
        hpb4ZrIOfBGY01ADLH5O6irz8KrmSG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-0D1sLN3MMk6lAzOoeUUV8Q-1; Tue, 14 Jan 2020 12:47:22 -0500
X-MC-Unique: 0D1sLN3MMk6lAzOoeUUV8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15BCF10120A6
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 17:47:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-74.gru2.redhat.com [10.97.116.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C4BC80F71;
        Tue, 14 Jan 2020 17:47:19 +0000 (UTC)
Subject: Re: [kvm-unit-tests] travis.yml: Prevent 'script' section from
 premature exit
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200113195102.44756-1-wainersm@redhat.com>
 <59bd7e8c-8321-8868-27a9-fb8a968e1ce0@redhat.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <0b4a3ecd-e12e-67bd-c1ac-2543b2aebc45@redhat.com>
Date:   Tue, 14 Jan 2020 15:47:17 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <59bd7e8c-8321-8868-27a9-fb8a968e1ce0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/14/20 2:48 PM, Thomas Huth wrote:
> On 13/01/2020 20.51, Wainer dos Santos Moschetta wrote:
>> The 'script' section finishes its execution prematurely whenever
>> a shell's exit is called. If the intention is to force
>> Travis to flag a build/test failure then the correct approach
>> is erroring any build command. In this change, it executes a
>> sub-shell process and exit 1, so that Travis capture the return
>> code and interpret it as a build error.
>>
>> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
>> ---
>>   .travis.yml | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/.travis.yml b/.travis.yml
>> index 091d071..a4405c3 100644
>> --- a/.travis.yml
>> +++ b/.travis.yml
>> @@ -119,5 +119,5 @@ before_script:
>>   script:
>>     - make -j3
>>     - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
>> -  - if grep -q FAIL results.txt ; then exit 1 ; fi
>> -  - if ! grep -q PASS results.txt ; then exit 1 ; fi
>> +  - if grep -q FAIL results.txt ; then $(exit 1) ; fi
>> +  - if ! grep -q PASS results.txt ; then $(exit 1) ; fi
> Basically a good idea, but I think we can even simplify these two lines
> into:
>
>   grep -q PASS results.txt && ! grep -q FAIL results.txt

Indeed this is a better idea.

>
> If you agree, could you update your patch and send a v2?

Sure, I will send the v2 with your proposed changes. Thanks!

- Wainer

>
>   Thanks,
>    Thomas

