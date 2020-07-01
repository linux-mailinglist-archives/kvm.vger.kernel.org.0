Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FC72108B5
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgGAJzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:55:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56483 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729109AbgGAJzd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 05:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593597332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Je7e+r7292aKuavAnjcPANtEH7N/fnSqK9E4e4P46/M=;
        b=Nb0/h64QZUkTbl9uERBW39EvIsUT2uFwNfbNJ20paUey0BKkwVlb3701a4L1d/U9hYsjG4
        C3JGVj8MmbE13Eyyl9lhwppOW2Zr12/2Vww7LXB7Q8pBakXk1lT8hJBSwgY7wsD1uVdC81
        qcjcm6Vo8iDyefnd3MU3H2tsxuczgag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-jqqthDMpN_S_S5-bjl1eOQ-1; Wed, 01 Jul 2020 05:55:28 -0400
X-MC-Unique: jqqthDMpN_S_S5-bjl1eOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D581100CCD3
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 09:55:27 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B456810013C1;
        Wed,  1 Jul 2020 09:55:26 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] scripts: Fix the check whether testname is
 in the only_tests list
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
References: <20200701083753.31366-1-thuth@redhat.com>
 <11b56d2f-e481-8951-69ea-8400f1cb7939@redhat.com>
 <c7485f32-d3bb-81f2-786a-3716f0a32800@redhat.com>
Message-ID: <bcf84232-4a3e-e8ed-e414-d9efb853ae8c@redhat.com>
Date:   Wed, 1 Jul 2020 11:55:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c7485f32-d3bb-81f2-786a-3716f0a32800@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2020 10.57, Thomas Huth wrote:
> On 01/07/2020 10.51, Paolo Bonzini wrote:
>> On 01/07/20 10:37, Thomas Huth wrote:
>>> When you currently run
>>>
>>>   ./run_tests.sh ioapic-split
>>>
>>> the kvm-unit-tests run scripts do not only execute the "ioapic-split"
>>> test, but also the "ioapic" test, which is quite surprising. This
>>> happens because we use "grep -w" for checking whether a test should
>>> be run or not - and "grep -w" does not consider the "-" character as
>>> part of a word.
>>>
>>> To fix the issue, convert the dash into an underscore character before
>>> running "grep -w".
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>   scripts/runtime.bash | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>> index 8bfe31c..03fd20a 100644
>>> --- a/scripts/runtime.bash
>>> +++ b/scripts/runtime.bash
>>> @@ -84,7 +84,8 @@ function run()
>>>           return
>>>       fi
>>> -    if [ -n "$only_tests" ] && ! grep -qw "$testname" 
>>> <<<$only_tests; then
>>> +    if [ -n "$only_tests" ] && ! sed s/-/_/ <<<$only_tests \
>>> +                               | grep -qw $(sed s/-/_/ <<< 
>>> "$testname") ; then
>>>           return
>>>       fi
>>>
>>
>> Simpler: grep -q " $testname " <<< " $only_tests "
> 
> That doesn't work:

I obviously missed the surrounding spaces ... not enough coffee... ;-)

  Thomas

