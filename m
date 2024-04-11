Return-Path: <kvm+bounces-14320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 029968A1F62
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 246B81C209F1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0977B14286;
	Thu, 11 Apr 2024 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtJX+fh3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C012E5D
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863338; cv=none; b=fU9VnwgqjrqfUndzDhO+53/4eGR+wtJ2RaW4Lf7kJeBk+31TbagDQbNKYLRTUXUUPW6EBTqYSKst9+bYNju6M1t15d4fAGcsTalPIHSOoVU7m49lkj44KjMTaaYCAzZ/tybSCOvM9HaAxOMtG3u6MWLWPKU60aZuX3+JFV7C4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863338; c=relaxed/simple;
	bh=w+XxbG3F6AJRg6zdChgbDpEx2I7Q5FUnq/RwwT93teE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X04A85OmfEOprPlRMrMxsxd95WX4gx8Y9i9y193DXqpG27fEIZynNbcLZa7kmxQe+qvpFjvS9EdLro8E8nxjKQauX+xG+aqj5c6gdnsuybG1RsBQDxy0zS/GRRrgp7DIKi+ZYUESOp3Yei3hP2vlxALBEKI6UzlNNfFJ/9HpVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtJX+fh3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712863335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=18QsSf6cSqU7ygavXwYObjncvBPRu0gV7UzJI9r152U=;
	b=CtJX+fh31hicIEgWPial1X2ZcFCYZDYa85IVEo5tICSLy8JA13OhVq6IsHIHqtugxFgGWS
	0BNB5mMBaJ2iFKR0NhrJ0irwGc/1WBiZ/pUy8edEcv1TBRgXeezgM4TB93LHr8gP7rEEuC
	jOKtKDlL6pRPv8Lgbs7tigXM/iUHFio=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-HWPnhbGkPHm5ZUbiv682Uw-1; Thu, 11 Apr 2024 15:22:13 -0400
X-MC-Unique: HWPnhbGkPHm5ZUbiv682Uw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a46852c2239so8800966b.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712863332; x=1713468132;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=18QsSf6cSqU7ygavXwYObjncvBPRu0gV7UzJI9r152U=;
        b=IVN905xDKfZKyzyoCRQxjadDnk64AppmXnT7XPjfWzH5cBqhgni/aaj4TMEBEJ43aD
         Ol89NVNVSUuB2Nif2Ps+HjVgyTcFVy/V0RtxYuCn5XyC/WNafDd0l87KdxU7lG+s+c5C
         P3Wn4e3LyLLuzoyUubEH3WHskAlDDgOgswnZF0Pziqn6vATV0alcRtFJ39p4zTwQ6SwP
         yN+7cqefJxa9+iRlN4g8MkMm/C12SIb27G0xko8zqJhfZBMBpxUD3XJ2kLud5QJaqG+6
         sZBBsKDVfPf9u5jD1m/bLcs5Sxipvy6MgWdd47YEonCQPSCBPctMm94479YUFL98D4XO
         +W1A==
X-Forwarded-Encrypted: i=1; AJvYcCVFXG9gwvEhhTB9/1GBmJWd2dzLQjFB8eYD+apwx3DrF1klXZrwz+AlIpM+QLEQIRU3Gs0Md78aMNEzPCuvGNpepNVX
X-Gm-Message-State: AOJu0Yywm290bDwBNM/uoSESIpi9riQMWG7b+jWCCGVmT/RWw9YaL3na
	v4TPkL0SB6VuHwYivQ7GWaAySpVtvWfF36cBMFLTpVQcRpm0aYV73Kf/ZzIJUZHbJLVBxG3ngFZ
	nPoudsSzmsf14frJiMYnJ6KacmKLp8jtIPC1v8d+zYSMRrecoBg==
X-Received: by 2002:a17:906:d54c:b0:a51:9416:4c9d with SMTP id cr12-20020a170906d54c00b00a5194164c9dmr474484ejc.46.1712863332648;
        Thu, 11 Apr 2024 12:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyeQ1TJPhivcaEtnUjzeo5bhrEokf4/u40jykJuOeXTLFR1VvvgS+ZPUkvFNWW8vONPsSctQ==
X-Received: by 2002:a17:906:d54c:b0:a51:9416:4c9d with SMTP id cr12-20020a170906d54c00b00a5194164c9dmr474474ejc.46.1712863332314;
        Thu, 11 Apr 2024 12:22:12 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-142.web.vodafone.de. [109.43.179.142])
        by smtp.gmail.com with ESMTPSA id dm18-20020a170907949200b00a51983e6190sm1006517ejc.205.2024.04.11.12.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 12:22:11 -0700 (PDT)
Message-ID: <e6c452bd-9101-40b7-ae3b-02400fed9e42@redhat.com>
Date: Thu, 11 Apr 2024 21:22:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 06/35] gitlab-ci: Run migration selftest
 on s390x and powerpc
To: Nico Boehr <nrb@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-7-npiggin@gmail.com>
 <171259239221.48513.3205716585028068515@t14-nrb>
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
In-Reply-To: <171259239221.48513.3205716585028068515@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/04/2024 18.06, Nico Boehr wrote:
> Quoting Nicholas Piggin (2024-04-05 10:35:07)
>> The migration harness is complicated and easy to break so CI will
>> be helpful.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
>>   s390x/unittests.cfg |  8 ++++++++
>>   2 files changed, 31 insertions(+), 9 deletions(-)
>>
>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>> index ff34b1f50..60b3cdfd2 100644
>> --- a/.gitlab-ci.yml
>> +++ b/.gitlab-ci.yml
> [...]
>> @@ -135,7 +147,7 @@ build-riscv64:
>>   build-s390x:
>>    extends: .outoftree_template
>>    script:
>> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>>    - mkdir build
>>    - cd build
>>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>> @@ -161,6 +173,8 @@ build-s390x:
>>         sclp-1g
>>         sclp-3g
>>         selftest-setup
>> +      selftest-migration-kvm
> 
> We're running under TCG in the Gitlab CI. I'm a little bit confused why
> we're running a KVM-only test here.

The build-s390x job is TCG, indeed, but we have the "s390x-kvm" job that 
runs on a KVM-capable s390x host, so it could be added there?

  Thomas


