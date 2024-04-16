Return-Path: <kvm+bounces-14732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EDE8A657E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 694CD1C2243D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8C084FD4;
	Tue, 16 Apr 2024 07:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fT89ZDvu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E984DFC
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713254137; cv=none; b=DHtRW7abEe634DHIYhf40IP3SBmIll8jQUO+s+7FjDSePVMLaTTFgEqTTuFzVEOYkQQyZV0IkxiBBd4+Fuvm0ZZk49W3UeHjn18DV+NwKosCV32z3YXOsxpCT7NIO7xJ2etkFx5pJSLp1WzIz2SgUm1XDORI25zxhP1CrmO3LX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713254137; c=relaxed/simple;
	bh=wJ7rgBO/A3Qn1OuY6ETgG7ywrrJ2EY8bkahbAtvnxgo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SibFCWWtHOP1IPmWGV8yaC2WP/+xLzTpvh2CrW3xJcbXumwxVmId5M6b/rx2POSXTN2KUbegtZYI9YFqa9/ux8fYfdVpscEak8k0nXXivAK0P9jk6ibevgGbfbNeP6G767g4a/HlPczn73Fvs/EBwvIdHCp/oxKS10fplPOh9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fT89ZDvu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713254134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S89tFe+K1CTG5fRksbFWnV+2+q7XeAKEw6AmjhBVsSc=;
	b=fT89ZDvubPxWvjJojIcWOYLQSH4kEqWy9vdVSdWg6h5Zd2GRTDx8tOlsSKkP3/L/RWKaqi
	em/oUhk/Qrqr24tNWdMzHtBQc4MEV684pp1QLy1aBs82L9y589+eVXNT95MUkjHUx1cfXR
	Np6NLsLYWZO53y1h0bWWXIH1T36zeto=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-2MGLjBmNNMOzHLagvkvGiA-1; Tue, 16 Apr 2024 03:55:32 -0400
X-MC-Unique: 2MGLjBmNNMOzHLagvkvGiA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-57034ee1459so682772a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 00:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713254131; x=1713858931;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S89tFe+K1CTG5fRksbFWnV+2+q7XeAKEw6AmjhBVsSc=;
        b=BIyNdy6hXnR6xgw85AKzbmn3zGIR3aFRz18jU+Nu8v1JNUpkyZWApt9NoCVaIuobDd
         Jik83hBpi5hAEP+ZLkOOm2S4a0L/ZoqQI7oHPe5E7IK25JgoQqMrCMI9QJy9vejVDNlY
         TwWoTsKtMvy+8qJykqulwQiYbuCbd5A2jpP/3cbbSPUh4+sWph8U3vuWfdPbvIZQPmZ0
         hpgdW6+u4Z1SbjwX45Yv0s8OqLtAYWkC6+4PW/2h9nnLsSeCAmWXkdjEbH8azOGM/GwZ
         TBlo9WtYnR0zg1yOB4DTUPwqErSytXrpmYTklyf4rPRJPblYH4MdNxJTclurVixseVsu
         3HIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0BEyTa3vkzGBOVRBiAwKCzWQnoMyKNLmSxRy2K+YhhPx3uNEnzclE/SdVOoOPGObRbAhNL2ShfYpGTT3gVYClJasY
X-Gm-Message-State: AOJu0Yynq+nJGtP5KQXKpg728zmO/V666kUlcHFjqgt6G4VgpSCeWiwJ
	3+HAb0UMkIg4hf1qjyqOw98jaibI4NHKQE/ecNDKvIahO44RyAjlfM5DTKQk2y4czIIj6hs2Pgu
	s9qde+9/eIE73eCuDC/6xU/OGFqrFsMpkGIsODIhPUn0YxmIRXg==
X-Received: by 2002:a50:cc93:0:b0:56e:2332:c282 with SMTP id q19-20020a50cc93000000b0056e2332c282mr8622371edi.14.1713254131188;
        Tue, 16 Apr 2024 00:55:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa0DXBEypul5UW11czuB/NKkbvt2k8AR7/Ww+kWF1gtW3L+HGVsO/bppG6FTx1l7Vk2upgdw==
X-Received: by 2002:a50:cc93:0:b0:56e:2332:c282 with SMTP id q19-20020a50cc93000000b0056e2332c282mr8622350edi.14.1713254130805;
        Tue, 16 Apr 2024 00:55:30 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm200778edu.27.2024.04.16.00.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 00:55:30 -0700 (PDT)
Message-ID: <56b4514b-e873-4509-89f3-fb6d96ff1274@redhat.com>
Date: Tue, 16 Apr 2024 09:55:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 06/35] gitlab-ci: Run migration selftest
 on s390x and powerpc
From: Thomas Huth <thuth@redhat.com>
To: Nico Boehr <nrb@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-7-npiggin@gmail.com>
 <171259239221.48513.3205716585028068515@t14-nrb>
 <e6c452bd-9101-40b7-ae3b-02400fed9e42@redhat.com>
 <bc91c2e1-6099-46c5-bbca-18bb7adb82d2@redhat.com>
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
In-Reply-To: <bc91c2e1-6099-46c5-bbca-18bb7adb82d2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/04/2024 09.18, Thomas Huth wrote:
> On 11/04/2024 21.22, Thomas Huth wrote:
>> On 08/04/2024 18.06, Nico Boehr wrote:
>>> Quoting Nicholas Piggin (2024-04-05 10:35:07)
>>>> The migration harness is complicated and easy to break so CI will
>>>> be helpful.
>>>>
>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>> ---
>>>>   .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
>>>>   s390x/unittests.cfg |  8 ++++++++
>>>>   2 files changed, 31 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>>> index ff34b1f50..60b3cdfd2 100644
>>>> --- a/.gitlab-ci.yml
>>>> +++ b/.gitlab-ci.yml
>>> [...]
>>>> @@ -135,7 +147,7 @@ build-riscv64:
>>>>   build-s390x:
>>>>    extends: .outoftree_template
>>>>    script:
>>>> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>>>> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>>>>    - mkdir build
>>>>    - cd build
>>>>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>>>> @@ -161,6 +173,8 @@ build-s390x:
>>>>         sclp-1g
>>>>         sclp-3g
>>>>         selftest-setup
>>>> +      selftest-migration-kvm
>>>
>>> We're running under TCG in the Gitlab CI. I'm a little bit confused why
>>> we're running a KVM-only test here.
>>
>> The build-s390x job is TCG, indeed, but we have the "s390x-kvm" job that 
>> runs on a KVM-capable s390x host, so it could be added there?
> 
> I now gave it a try and it seems to work, so I updated this patch and pushed 
> it to the repository now.

Hmm, "selftest-migration" now was failing once here:

  https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/6633865591

Let's keep an eye on it, and if it is not stable enough, we might need to 
disable it in the CI again...

  Thomas



