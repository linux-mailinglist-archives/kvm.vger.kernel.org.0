Return-Path: <kvm+bounces-17000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F998BFDCB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C9271F22505
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E2A59165;
	Wed,  8 May 2024 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3GDKmvU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5723FE3F
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715172922; cv=none; b=sIEGEhYC8aMUTFJi9Ii2FHdofqiiQRxuVRDL1qwPGpHnTZaGjlnm7nkk08UOvm2NSFcKFwjEz2nm4rw3XzEdJUyhC+LmsKI9Wvwm2A7sf3Xvvtu0xT/3fXZMuWzRYLWyMoo9sjcAda20i4FfmXcOboPUab8JPLnGNDaIoRw+rXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715172922; c=relaxed/simple;
	bh=XMgDG0TPvf9u0YHWmBR4a68kBaO/9bNy65pbcUa4yGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VY2lahVCYh0oL1xJr53GKD+LyUMG1fBl9gxxZ4/mssN2H4mqBkq0IVxsyE28pymQGZp8NIXMkw9SL/Xrln8oLk5UyB4/P5TZueYFCn7kc8AE/N0v4APqS4pQbZVCpP/Fyin7dnFAwsrmpzWgd5nazSejsQ2NJlG1Sy2hX3JkSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3GDKmvU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715172919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iYKRviCO0ESwo/Q7IHwYeyGnhjgwSW6TPsvug1uoKLc=;
	b=d3GDKmvU7ol3TpinKG8jsAfNDkYGGraxTQAVVuH75JOAs73ta/7AgGKATKIQX85QVgenGA
	+zTBHFb/P+5KhoLgJlrffeZBtMieKuVjhzOwNV2+N8GSNpWOKa1f6WIwfScADFQYX2eTqd
	A0jRE9F+0qWTvbyKz/MqJlepem4OsJw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-4B6q5CjOOeakrzJCKpbWBg-1; Wed, 08 May 2024 08:55:18 -0400
X-MC-Unique: 4B6q5CjOOeakrzJCKpbWBg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41e9feb655eso15314265e9.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 05:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715172917; x=1715777717;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYKRviCO0ESwo/Q7IHwYeyGnhjgwSW6TPsvug1uoKLc=;
        b=nHgYvlvlpLn4D/SL/n5qkiNV099of8xRGb+dFcZgdFQP3Y01A+b89vDYZDzQX9O0BW
         Xnc/n4AWwh4136qkgEevNwyXfiXTPo9qY3cSnutOSvodn9fEfcpT2jW+6TSJiFfDcynL
         IhQvuY3MoZQ+cI4jYyjA1V2HJYOU51rFRyrSKHtcPxzdY6Yy65q0d1uMF6+hdxV8pAaA
         eDvzDT0cJmifg5NihrkVGaptUFiAR5zOgQ4w17ABGkFbpHHpVPsbpNk/HI/XIJhixUg7
         ARMqUOvUeIgun2HGGh9z9zZELP6fUYRvJKHpSegIyKkr/zHo/OkDUnnzjS2XCOphy/vf
         Hxpg==
X-Forwarded-Encrypted: i=1; AJvYcCXRuXH+0CAknXWjfeXAT9DVIgi7ZeYEd6L1NIo+2ljLVzLc047nbfTyhv5uq5lxrTOheEoYXCVwdWW6ktkc3Qp8M/Mh
X-Gm-Message-State: AOJu0YyjSCdlR0H+OQuFmN2ujA9+HhW26aMDe2mRpxWqp2ThyiOgQwpU
	eMKZ2SnglIzJqDtRWx+NYtYyNET8i51c8W4vaRzt32eYG13pPj0DzwxblZZRYfiHPr5HRPO9P+o
	XBcneqC4w+N7yARKHcKTVn6ZpEvO04pYqrBbm5gcbBoAhHpmlug==
X-Received: by 2002:a05:600c:548e:b0:41a:408b:dbaa with SMTP id 5b1f17b1804b1-41f7093c527mr23352885e9.0.1715172917017;
        Wed, 08 May 2024 05:55:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYLU3AMWrITBc7txQdaLPQ7PZ2/BPNTBSnySZhsBKwezfWi1nBEFFZ4Muj5kJ28lbO4Tv1zw==
X-Received: by 2002:a05:600c:548e:b0:41a:408b:dbaa with SMTP id 5b1f17b1804b1-41f7093c527mr23352715e9.0.1715172916642;
        Wed, 08 May 2024 05:55:16 -0700 (PDT)
Received: from [10.33.192.191] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a056000001200b0034c78001f6asm15289416wrx.109.2024.05.08.05.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 05:55:16 -0700 (PDT)
Message-ID: <f304924b-8acf-40f6-9426-10fdf77712b6@redhat.com>
Date: Wed, 8 May 2024 14:55:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option to
 be specified in unittests.cfg
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-8-npiggin@gmail.com>
 <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>
 <D149GFR9LAZH.1X2F7YKPEJ42C@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <D149GFR9LAZH.1X2F7YKPEJ42C@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/05/2024 14.27, Nicholas Piggin wrote:
> On Wed May 8, 2024 at 1:08 AM AEST, Thomas Huth wrote:
>> On 04/05/2024 14.28, Nicholas Piggin wrote:
>>> This allows different machines with different requirements to be
>>> supported by run_tests.sh, similarly to how different accelerators
>>> are handled.
>>>
>>> Acked-by: Thomas Huth <thuth@redhat.com>
>>> Acked-by: Andrew Jones <andrew.jones@linux.dev>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>    docs/unittests.txt   |  7 +++++++
>>>    scripts/common.bash  |  8 ++++++--
>>>    scripts/runtime.bash | 16 ++++++++++++----
>>>    3 files changed, 25 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/docs/unittests.txt b/docs/unittests.txt
>>> index 7cf2c55ad..6449efd78 100644
>>> --- a/docs/unittests.txt
>>> +++ b/docs/unittests.txt
>>> @@ -42,6 +42,13 @@ For <arch>/ directories that support multiple architectures, this restricts
>>>    the test to the specified arch. By default, the test will run on any
>>>    architecture.
>>>    
>>> +machine
>>> +-------
>>> +For those architectures that support multiple machine types, this restricts
>>> +the test to the specified machine. By default, the test will run on
>>> +any machine type. (Note, the machine can be specified with the MACHINE=
>>> +environment variable, and defaults to the architecture's default.)
>>> +
>>>    smp
>>>    ---
>>>    smp = <number>
>>> diff --git a/scripts/common.bash b/scripts/common.bash
>>> index 5e9ad53e2..3aa557c8c 100644
>>> --- a/scripts/common.bash
>>> +++ b/scripts/common.bash
>>> @@ -10,6 +10,7 @@ function for_each_unittest()
>>>    	local opts
>>>    	local groups
>>>    	local arch
>>> +	local machine
>>>    	local check
>>>    	local accel
>>>    	local timeout
>>> @@ -21,7 +22,7 @@ function for_each_unittest()
>>>    		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>>>    			rematch=${BASH_REMATCH[1]}
>>>    			if [ -n "${testname}" ]; then
>>> -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>>> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>>>    			fi
>>>    			testname=$rematch
>>>    			smp=1
>>> @@ -29,6 +30,7 @@ function for_each_unittest()
>>>    			opts=""
>>>    			groups=""
>>>    			arch=""
>>> +			machine=""
>>>    			check=""
>>>    			accel=""
>>>    			timeout=""
>>> @@ -58,6 +60,8 @@ function for_each_unittest()
>>>    			groups=${BASH_REMATCH[1]}
>>>    		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
>>>    			arch=${BASH_REMATCH[1]}
>>> +		elif [[ $line =~ ^machine\ *=\ *(.*)$ ]]; then
>>> +			machine=${BASH_REMATCH[1]}
>>>    		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
>>>    			check=${BASH_REMATCH[1]}
>>>    		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
>>> @@ -67,7 +71,7 @@ function for_each_unittest()
>>>    		fi
>>>    	done
>>>    	if [ -n "${testname}" ]; then
>>> -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>>> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
>>>    	fi
>>>    	exec {fd}<&-
>>>    }
>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>> index 177b62166..0c96d6ea2 100644
>>> --- a/scripts/runtime.bash
>>> +++ b/scripts/runtime.bash
>>> @@ -32,7 +32,7 @@ premature_failure()
>>>    get_cmdline()
>>>    {
>>>        local kernel=$1
>>> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
>>> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
>>>    }
>>>    
>>>    skip_nodefault()
>>> @@ -80,9 +80,10 @@ function run()
>>>        local kernel="$4"
>>>        local opts="$5"
>>>        local arch="$6"
>>> -    local check="${CHECK:-$7}"
>>> -    local accel="$8"
>>> -    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
>>> +    local machine="$7"
>>> +    local check="${CHECK:-$8}"
>>> +    local accel="$9"
>>> +    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
>>>    
>>>        if [ "${CONFIG_EFI}" == "y" ]; then
>>>            kernel=${kernel/%.flat/.efi}
>>> @@ -116,6 +117,13 @@ function run()
>>>            return 2
>>>        fi
>>>    
>>> +    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" != "$MACHINE" ]; then
>>> +        print_result "SKIP" $testname "" "$machine only"
>>> +        return 2
>>> +    elif [ -n "$MACHINE" ]; then
>>> +        machine="$MACHINE"
>>> +    fi
>>> +
>>>        if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
>>>            print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
>>>            return 2
>>
>> For some reasons that I don't quite understand yet, this patch causes the
>> "sieve" test to always timeout on the s390x runner, see e.g.:
>>
>>    https://gitlab.com/thuth/kvm-unit-tests/-/jobs/6798954987
> 
> How do you use the s390x runner?
> 
>>
>> Everything is fine in the previous patches (I pushed now the previous 5
>> patches to the repo):
>>
>>    https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/pipelines/1281919104
>>
>> Could it be that he TIMEOUT gets messed up in certain cases?
> 
> Hmm not sure yet. At least it got timeout right for the duration=90s
> message.

That seems to be wrong, the test is declared like this in s390x/unittests.cfg :

[sieve]
file = sieve.elf
groups = selftest
# can take fairly long when KVM is nested inside z/VM
timeout = 600

And indeed, it takes way longer than 90 seconds on that CI machine, so the 
timeout after 90 seconds should not occur here...

  Thomas


