Return-Path: <kvm+bounces-17005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C918BFED0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C2A82898D9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A277A13A;
	Wed,  8 May 2024 13:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H438L9Qd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020D179945
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715175380; cv=none; b=oGeM1g/mvkUGX+h2TkqCmv5/NrIKxFlyquFyDW6eGCcxZTUpLGGxDcpXZg2NFtMuQ5UmUwaL1X4fDQ+V4IlvVAznRZsZmxVKDoM+vtkFFMNABCRAb8svcGouGB7ryUoUMuFgjnlTH1lMo10JEB4y7SzutGm4e+ZR3n9ATZZGbhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715175380; c=relaxed/simple;
	bh=xZ/2Obh52g1vI3tD7r2VsbhZPceQDa52gNisJ/zD270=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=hpi8pgXykI0jvcSt3i3Mn9OwsaH30WouiUX+atES+j8m0KTuvMTUPrODr6uiW7A03wk4+krMiEeHLIUAbOyyNWJNGNljir36/q3pDy1jicoy+9V1seWt/H5A8ejRXkAFH7mb1iaKKJZs4v/mmRdEC7hSPWGWNRbK0JhE6n9byJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H438L9Qd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715175377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jlOOVvquEONflhjYihi2YNb8HhKu47eWlw4WXGMSFeE=;
	b=H438L9QdybvKjnO2iNEAWyfRSXHEF/ShoLrOBE9thfK0yN/zo+yVDT5hrocQm7qE/rU+Fb
	nD5GluUgCrAaFnrkwbj/Nez37ZdcU3cIRp25qgvT7J/KPvv36yz+yLxcD2F18+pbexDJ3Q
	KV83FfqRY0H632JkeP2hUogcVY3wE8I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-gMWyk0XXPVSLws-LRzwZ4g-1; Wed, 08 May 2024 09:36:16 -0400
X-MC-Unique: gMWyk0XXPVSLws-LRzwZ4g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-418f8271081so14799595e9.3
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 06:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715175375; x=1715780175;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jlOOVvquEONflhjYihi2YNb8HhKu47eWlw4WXGMSFeE=;
        b=W7Swm4adfUmvCTTM7sr1YuWfRaSKiEnu8BWeK5usZ3YDXuR9MzIiB8Dp7/9+A9G0AL
         xZwuA8AdW0+w5TOwMNIRvLVJ4bHSGBEDECcBbOHITv79c2E7xuNDtS6EBwdLg08VSNS8
         ubAB2szs0K6U4C4bF2oVlya20quwz3FqaN00mZmx8y6b8JFZqjRDsyWvqlR32CqmVHKH
         4AHzE4NEVkd4NoKfxHqBNyb1TJmqmU93XDYc2+t9JQL8VNeaQ/pus9D393cHA4mDHFgO
         6iPjsPhGA3iEPuuCwStu5Cjk36i8s2oUtcQB3Ya52BInOffhz2GIRWT/kFZyukDvFJXa
         4GKA==
X-Gm-Message-State: AOJu0Yw8IGBB3lc723HVbFu0DG9u9vW/GT5YVW7mbHA7tAr7bOCk41+M
	QCmt1aFvwE8NZ4AIJc4vrrnJqFBuxZ0ixxe5NjHT/bcqSDNOzEk1z1Cl7xY97zMTpTkneU6kPJb
	b28Gr2WzOlCfH+kO2qut5XcFzd/QuRC7+FvdZ05zX+i8H4glPAA==
X-Received: by 2002:a05:600c:5027:b0:418:d6f2:a97a with SMTP id 5b1f17b1804b1-41f71cd2685mr27463605e9.13.1715175375026;
        Wed, 08 May 2024 06:36:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHr5S6VX+J+5hPD+jWfX8CO9JkNOJmRGWnOHIbdlGmr1BrExt9NlJKhWg/GQQf9KYlZRjb0w==
X-Received: by 2002:a05:600c:5027:b0:418:d6f2:a97a with SMTP id 5b1f17b1804b1-41f71cd2685mr27463435e9.13.1715175374590;
        Wed, 08 May 2024 06:36:14 -0700 (PDT)
Received: from [10.33.192.191] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41facbd295fsm5326515e9.36.2024.05.08.06.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 06:36:14 -0700 (PDT)
Message-ID: <50e43047-b251-465b-b4b0-b5987ec9aa78@redhat.com>
Date: Wed, 8 May 2024 15:36:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option to
 be specified in unittests.cfg
From: Thomas Huth <thuth@redhat.com>
To: Nicholas Piggin <npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-8-npiggin@gmail.com>
 <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>
 <D149GFR9LAZH.1X2F7YKPEJ42C@gmail.com>
 <f304924b-8acf-40f6-9426-10fdf77712b6@redhat.com>
 <1e07de7a-5b14-4168-aa14-56dae8766dc0@redhat.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <1e07de7a-5b14-4168-aa14-56dae8766dc0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/05/2024 14.58, Thomas Huth wrote:
> On 08/05/2024 14.55, Thomas Huth wrote:
>> On 08/05/2024 14.27, Nicholas Piggin wrote:
>>> On Wed May 8, 2024 at 1:08 AM AEST, Thomas Huth wrote:
>>>> On 04/05/2024 14.28, Nicholas Piggin wrote:
>>>>> This allows different machines with different requirements to be
>>>>> supported by run_tests.sh, similarly to how different accelerators
>>>>> are handled.
>>>>>
>>>>> Acked-by: Thomas Huth <thuth@redhat.com>
>>>>> Acked-by: Andrew Jones <andrew.jones@linux.dev>
>>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>>> ---
>>>>>    docs/unittests.txt   |  7 +++++++
>>>>>    scripts/common.bash  |  8 ++++++--
>>>>>    scripts/runtime.bash | 16 ++++++++++++----
>>>>>    3 files changed, 25 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/docs/unittests.txt b/docs/unittests.txt
>>>>> index 7cf2c55ad..6449efd78 100644
>>>>> --- a/docs/unittests.txt
>>>>> +++ b/docs/unittests.txt
>>>>> @@ -42,6 +42,13 @@ For <arch>/ directories that support multiple 
>>>>> architectures, this restricts
>>>>>    the test to the specified arch. By default, the test will run on any
>>>>>    architecture.
>>>>> +machine
>>>>> +-------
>>>>> +For those architectures that support multiple machine types, this 
>>>>> restricts
>>>>> +the test to the specified machine. By default, the test will run on
>>>>> +any machine type. (Note, the machine can be specified with the MACHINE=
>>>>> +environment variable, and defaults to the architecture's default.)
>>>>> +
>>>>>    smp
>>>>>    ---
>>>>>    smp = <number>
>>>>> diff --git a/scripts/common.bash b/scripts/common.bash
>>>>> index 5e9ad53e2..3aa557c8c 100644
>>>>> --- a/scripts/common.bash
>>>>> +++ b/scripts/common.bash
>>>>> @@ -10,6 +10,7 @@ function for_each_unittest()
>>>>>        local opts
>>>>>        local groups
>>>>>        local arch
>>>>> +    local machine
>>>>>        local check
>>>>>        local accel
>>>>>        local timeout
>>>>> @@ -21,7 +22,7 @@ function for_each_unittest()
>>>>>            if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>>>>>                rematch=${BASH_REMATCH[1]}
>>>>>                if [ -n "${testname}" ]; then
>>>>> -                $(arch_cmd) "$cmd" "$testname" "$groups" "$smp" 
>>>>> "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>>>>> +                $(arch_cmd) "$cmd" "$testname" "$groups" "$smp" 
>>>>> "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>>>>>                fi
>>>>>                testname=$rematch
>>>>>                smp=1
>>>>> @@ -29,6 +30,7 @@ function for_each_unittest()
>>>>>                opts=""
>>>>>                groups=""
>>>>>                arch=""
>>>>> +            machine=""
>>>>>                check=""
>>>>>                accel=""
>>>>>                timeout=""
>>>>> @@ -58,6 +60,8 @@ function for_each_unittest()
>>>>>                groups=${BASH_REMATCH[1]}
>>>>>            elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
>>>>>                arch=${BASH_REMATCH[1]}
>>>>> +        elif [[ $line =~ ^machine\ *=\ *(.*)$ ]]; then
>>>>> +            machine=${BASH_REMATCH[1]}
>>>>>            elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
>>>>>                check=${BASH_REMATCH[1]}
>>>>>            elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
>>>>> @@ -67,7 +71,7 @@ function for_each_unittest()
>>>>>            fi
>>>>>        done
>>>>>        if [ -n "${testname}" ]; then
>>>>> -        $(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" 
>>>>> "$opts" "$arch" "$check" "$accel" "$timeout"
>>>>> +        $(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" 
>>>>> "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>>>>>        fi
>>>>>        exec {fd}<&-
>>>>>    }
>>>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>>>> index 177b62166..0c96d6ea2 100644
>>>>> --- a/scripts/runtime.bash
>>>>> +++ b/scripts/runtime.bash
>>>>> @@ -32,7 +32,7 @@ premature_failure()
>>>>>    get_cmdline()
>>>>>    {
>>>>>        local kernel=$1
>>>>> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel 
>>>>> $RUNTIME_arch_run $kernel -smp $smp $opts"
>>>>> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine 
>>>>> ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
>>>>>    }
>>>>>    skip_nodefault()
>>>>> @@ -80,9 +80,10 @@ function run()
>>>>>        local kernel="$4"
>>>>>        local opts="$5"
>>>>>        local arch="$6"
>>>>> -    local check="${CHECK:-$7}"
>>>>> -    local accel="$8"
>>>>> -    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
>>>>> +    local machine="$7"
>>>>> +    local check="${CHECK:-$8}"
>>>>> +    local accel="$9"
>>>>> +    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
>>>>>        if [ "${CONFIG_EFI}" == "y" ]; then
>>>>>            kernel=${kernel/%.flat/.efi}
>>>>> @@ -116,6 +117,13 @@ function run()
>>>>>            return 2
>>>>>        fi
>>>>> +    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" != 
>>>>> "$MACHINE" ]; then
>>>>> +        print_result "SKIP" $testname "" "$machine only"
>>>>> +        return 2
>>>>> +    elif [ -n "$MACHINE" ]; then
>>>>> +        machine="$MACHINE"
>>>>> +    fi
>>>>> +
>>>>>        if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" 
>>>>> ]; then
>>>>>            print_result "SKIP" $testname "" "$accel only, but 
>>>>> ACCEL=$ACCEL"
>>>>>            return 2
>>>>
>>>> For some reasons that I don't quite understand yet, this patch causes the
>>>> "sieve" test to always timeout on the s390x runner, see e.g.:
>>>>
>>>>    https://gitlab.com/thuth/kvm-unit-tests/-/jobs/6798954987
>>>
>>> How do you use the s390x runner?
>>>
>>>>
>>>> Everything is fine in the previous patches (I pushed now the previous 5
>>>> patches to the repo):
>>>>
>>>>    https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/pipelines/1281919104
>>>>
>>>> Could it be that he TIMEOUT gets messed up in certain cases?
>>>
>>> Hmm not sure yet. At least it got timeout right for the duration=90s
>>> message.
>>
>> That seems to be wrong, the test is declared like this in 
>> s390x/unittests.cfg :
>>
>> [sieve]
>> file = sieve.elf
>> groups = selftest
>> # can take fairly long when KVM is nested inside z/VM
>> timeout = 600
>>
>> And indeed, it takes way longer than 90 seconds on that CI machine, so the 
>> timeout after 90 seconds should not occur here...
> 
> I guess you need to adjust arch_cmd_s390x in scripts/s390x/func.bash to be 
> aware of the new parameter, too?

This seems to fix the problem:

diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index fa47d019..6b817727 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -13,12 +13,13 @@ function arch_cmd_s390x()
         local kernel=$5
         local opts=$6
         local arch=$7
-       local check=$8
-       local accel=$9
-       local timeout=${10}
+       local machine=$8
+       local check=$9
+       local accel=${10}
+       local timeout=${11}
  
         # run the normal test case
-       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
  
         # run PV test case
         if [ "$accel" = 'tcg' ] || grep -q "migration" <<< "$groups"; then

If you don't like to respin, I can add it to the patch while picking it up?

  Thomas


