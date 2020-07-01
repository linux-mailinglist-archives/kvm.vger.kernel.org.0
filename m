Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA12106C9
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgGAI5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:57:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728575AbgGAI5O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 04:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593593832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RO2wUZZtSRLP0FQ1ubRpoLxbc9vZ/bHylNXHvs4rtds=;
        b=AvxShPT1uhDJ4Sa7Z2xIJOex+XdqqgVSLgVqVf8u4x3z6vXko+0AjZn8P+oqNcklD31sas
        Aj4pQTTZuGNBZ6V7aHpPD8xOqbMm4AviEzUTOmBJwjc9+LStD/mJ8hk4KnYp7EM4pQQMTQ
        W18NI0TdBXuYf6qOm7UqR8pAGmcNJic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-evkGr40lM1ih-e8EC4Cbrw-1; Wed, 01 Jul 2020 04:57:10 -0400
X-MC-Unique: evkGr40lM1ih-e8EC4Cbrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE6F8BFC0
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 08:57:09 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 215145C1C5;
        Wed,  1 Jul 2020 08:57:08 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] scripts: Fix the check whether testname is
 in the only_tests list
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
References: <20200701083753.31366-1-thuth@redhat.com>
 <11b56d2f-e481-8951-69ea-8400f1cb7939@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c7485f32-d3bb-81f2-786a-3716f0a32800@redhat.com>
Date:   Wed, 1 Jul 2020 10:57:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <11b56d2f-e481-8951-69ea-8400f1cb7939@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2020 10.51, Paolo Bonzini wrote:
> On 01/07/20 10:37, Thomas Huth wrote:
>> When you currently run
>>
>>   ./run_tests.sh ioapic-split
>>
>> the kvm-unit-tests run scripts do not only execute the "ioapic-split"
>> test, but also the "ioapic" test, which is quite surprising. This
>> happens because we use "grep -w" for checking whether a test should
>> be run or not - and "grep -w" does not consider the "-" character as
>> part of a word.
>>
>> To fix the issue, convert the dash into an underscore character before
>> running "grep -w".
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   scripts/runtime.bash | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index 8bfe31c..03fd20a 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -84,7 +84,8 @@ function run()
>>           return
>>       fi
>>   
>> -    if [ -n "$only_tests" ] && ! grep -qw "$testname" <<<$only_tests; then
>> +    if [ -n "$only_tests" ] && ! sed s/-/_/ <<<$only_tests \
>> +                               | grep -qw $(sed s/-/_/ <<< "$testname") ; then
>>           return
>>       fi
>>   
>>
> 
> Simpler: grep -q " $testname " <<< " $only_tests "

That doesn't work:

$ ./run_tests.sh ioapic-split
PASS apic-split (53 tests)
PASS ioapic-split (19 tests)
PASS apic (53 tests)
PASS ioapic (26 tests)

... because the $testname comes from unittests.cfg and $only_tests is 
the list that has been given on the command line. It would maybe work if 
the check was the other way round ... but that would require to rewrite 
quite a bit of the script logic...

By the way, you can currently also run "./run_test.sh badname" and it 
does *not* complain that "badname" is an illegal test name...

  Thomas

