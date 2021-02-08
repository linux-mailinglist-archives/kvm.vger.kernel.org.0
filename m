Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80273136FF
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhBHPSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:18:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232733AbhBHPPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612797224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QnWSYO4DmxGTl0psJZQqO1COYOIHEj+7TNrQ9PAPK0k=;
        b=YkDMsJmASEiJiNdESHpA/jYO8l4boIdVuXTB/jzwkfkyxjMqArnZDXHykbCCPYmqHxOJZX
        kjTpF+2XkPrFPJ+FMpBMzcaCwx3oIyC1M9axAZEzZtyBmqjBGoFeUGWOf642YQeGAOXfPV
        76iUhvvHF7sx6QXKXFiaManSN5ds5no=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-pKqytjObPiauuuj_PS7qEw-1; Mon, 08 Feb 2021 10:13:42 -0500
X-MC-Unique: pKqytjObPiauuuj_PS7qEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FEAA8EC5E8
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 15:13:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-117.ams2.redhat.com [10.36.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E787610190B7;
        Mon,  8 Feb 2021 15:13:15 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Add new s390x targets to
 run tests with TCG and KVM accel
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Bandeira Condotta <mbandeir@redhat.com>,
        kvm@vger.kernel.org
Cc:     Marcelo Bandeira Condotta <mcondotta@redhat.com>
References: <20210208150227.178953-1-mbandeir@redhat.com>
 <8f34cddf-84bf-0726-8074-1688974a74d8@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6e56bdb9-72b4-369e-acb2-d5715e02ab92@redhat.com>
Date:   Mon, 8 Feb 2021 16:13:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8f34cddf-84bf-0726-8074-1688974a74d8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/2021 16.07, Paolo Bonzini wrote:
> On 08/02/21 16:02, Marcelo Bandeira Condotta wrote:
>> From: Marcelo Bandeira Condotta <mcondotta@redhat.com>
>>
>> A new s390x z15 VM provided by IBM Community Cloud will be used to run
>> the s390x KVM Unit tests natively with both TCG and KVM accel options.
>>
>> Signed-off-by: Marcelo Bandeira Condotta <mbandeir@redhat.com>
>> ---
>>   .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>> index d97e27e..bc7a115 100644
>> --- a/.gitlab-ci.yml
>> +++ b/.gitlab-ci.yml
>> @@ -155,3 +155,31 @@ cirrus-ci-macos-i386:
>>   cirrus-ci-macos-x86-64:
>>    <<: *cirrus_build_job_definition
>> +
>> +test-s390x-tcg:
>> +  stage: test
>> +  before_script: []
>> +  tags:
>> +    - s390x-z15-vm
>> +  script:
>> +    - ./configure --arch=s390x
>> +    - make -j2
>> +    - ACCEL=tcg ./run_tests.sh
>> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector 
>> diag288
>> +     stsi sclp-1g sclp-3g
>> +     | tee results.txt
>> +    - if grep -q FAIL results.txt ; then exit 1 ; fi
>> +
>> +test-s390x-kvm:
>> +  stage: test
>> +  before_script: []
>> +  tags:
>> +    - s390x-z15-vm
>> +  script:
>> +    - ./configure --arch=s390x
>> +    - make -j2
>> +    - ACCEL=kvm ./run_tests.sh
>> +     selftest-setup intercept emulator sieve skey diag10 diag308 vector 
>> diag288
>> +     stsi sclp-1g sclp-3g
>> +     | tee results.txt
>> +    - if grep -q FAIL results.txt ; then exit 1 ; fi

Acked-by: Thomas Huth <thuth@redhat.com>

> 
> So it will have a custom runner?  That's nice!
> 
> Do you have an example run already?

I've been in touch with Marcelo during the past days already, and I've 
already registered the runner that he set up on the s390x machine, so it 
should theoretically work now once this patch has been merged.

  Thomas

