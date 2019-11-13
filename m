Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0025FB38C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfKMPSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:18:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24641 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727640AbfKMPSE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 10:18:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573658283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75FUra0H2ZVXY1TzThkCvf4a8B59kjgc6vi6vAFn6To=;
        b=GKI6wDhYtf3odZzIhBWPWQo2Jl7QA+va0VUMb7l0G4Ovq9QmluqOFSn+WL7YJDljnKxe9y
        +jCJQHHzbpty0IEAP+rPU2xNNKBeEtuaTANSW+0JDmwjxPCEkuQw/ze+dfdRpi3tX/YONv
        MX7cexFv3yN5ZDMzA9+6vr0W+zfdmPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-__eZ30bQP9eGfiG4kaKIFg-1; Wed, 13 Nov 2019 10:18:00 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D28AEDBA3;
        Wed, 13 Nov 2019 15:17:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09CC66835;
        Wed, 13 Nov 2019 15:17:52 +0000 (UTC)
Subject: Re: [kvm-unit-test PATCH 5/5] travis.yml: Expect that at least one
 test succeeds
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-6-thuth@redhat.com> <87mucz7r3s.fsf@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <417bee9b-578b-5b3c-25a6-9998020ba514@redhat.com>
Date:   Wed, 13 Nov 2019 16:17:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87mucz7r3s.fsf@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: __eZ30bQP9eGfiG4kaKIFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/2019 16.06, Alex Benn=C3=A9e wrote:
>=20
> Thomas Huth <thuth@redhat.com> writes:
>=20
>> While working on the travis.yml file, I've run into cases where
>> all tests are reported as "SKIP" by the run_test.sh script (e.g.
>> when QEMU could not be started). This should not result in a
>> successful test run, so mark it as failed if not at least one
>> test passed.
>=20
> But doesn't this mean you could have everything fail except one pass and
> still report success?

The FAILs are already handled one line earlier...

>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  .travis.yml | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/.travis.yml b/.travis.yml
>> index 9ceb04d..aacf7d2 100644
>> --- a/.travis.yml
>> +++ b/.travis.yml
>> @@ -115,3 +115,4 @@ script:
>>    - make -j3
>>    - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
>>    - if grep -q FAIL results.txt ; then exit 1 ; fi

... here -----------^

>> +  - if ! grep -q PASS results.txt ; then exit 1 ; fi

Maybe it would also be nicer to provide proper exit values in the
run_tests.sh script, but the logic there gives me a bad headache...
grep'ing for FAIL and PASS in the yml script is way more easy.

 Thomas

