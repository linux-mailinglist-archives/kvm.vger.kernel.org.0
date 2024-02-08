Return-Path: <kvm+bounces-8366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 041B984E90D
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 20:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B371BB2FA06
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 19:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B48381B3;
	Thu,  8 Feb 2024 19:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFrOs6qD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E17136B0A
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707420676; cv=none; b=NBBMvsuejRsEqShXcYjws7oF+HPZ7gvZ68fFish/GbYYPRwwcA0i8Ap+/3Q5qFKyBxVY+6yWKKApDkBIY90PKcM1K2vbdsNcgbAfLNgZVaIQsrSGaqbR8lSJhzHCgrQSgPxu9ZKadqkgEFIQUTP8yJrk7P+xcsGw0N9k47XEMvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707420676; c=relaxed/simple;
	bh=JTnL6CBuzBPqsrfYa0gkSIbWG2+BlvSoeYR5H7CNbok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tZPXPcn9py5iYxgO7yJMKVZW9OotjYHVjDuMYrpfFCar8N1A5KfU/IA7H+S3YEYB+ZgsQPKGg68JEU5q8KfFIzrKcvdNtmHSyO/vcL4hQ5Q0zsr/zkSkpdB27gI64HWz78YLMKM9I+Tgn0NpFEzX2orOVXubbOCbJh6sximzD50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BFrOs6qD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707420673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uQ9ZvCPxOXDHlqGQaVlrxREOk6cQTpNHPWgCRf8e/qY=;
	b=BFrOs6qDDTZ5Z9bvpwOt8yIiNWroODKbQABy59/s5RLLZa/ms1JvXolJuE/rKnM3XCQjM3
	MfeXeisW2JQh52uPHL82FhAoyW1SmIzJSSdaZ4yleNEL9l6IXoAunziRsydF4zzjums9Wi
	dVz2B3sUZowXp5fZvN66V9iCPwetVj4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-l7DjRl6xPYioe77wQwi8KQ-1; Thu, 08 Feb 2024 14:31:12 -0500
X-MC-Unique: l7DjRl6xPYioe77wQwi8KQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-560d90fca35so183363a12.1
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 11:31:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707420671; x=1708025471;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQ9ZvCPxOXDHlqGQaVlrxREOk6cQTpNHPWgCRf8e/qY=;
        b=s0a8W3yoMEZ7O/2rTS+ZAEczgllNDJZj+z1huOId+7CCMNCrqW97358UG09bfnQcQF
         BSql91cmr8Wrf61Wx+XZGen1of8YqGGIW5KGXiKt0ef6q0UGrCPpV4AQ9wvwA1tItDTZ
         3MBoSD6aelOlKAz34gbomZsvqd41gi66K6Gfm9MjDcyXwm3kyWup9254267XnKU2O5A8
         opIdc00L2RpgiWHP1ddh2WmvmcJTU1lvyay02UysI1QN6L09FHDGEDqgeeJtPjAg+PuJ
         HqtzJ1evRPGovhAVVHv7q2CqUO2pNoA7J3YbiMQqUZhEloW3Pmurq6nkQBfHakH5a8fl
         q5rg==
X-Gm-Message-State: AOJu0YylwAmE/wh6NoH4ystlytC7FLWH9qvD04p38wm3zPCawdIu6fl8
	4MYkSQB3pFqSdMMOhkavZij2o0uMz1WvnHxCtefaDhdQp/Pty3ZD9Jy6DcZvKuOy9D+4sh6v4b+
	wAbjRbWLwUPza/kRd03YN2/crq0kDIFG1wdRHAvsCQCA0zgH1GQ==
X-Received: by 2002:aa7:cf95:0:b0:55f:ec52:73c4 with SMTP id z21-20020aa7cf95000000b0055fec5273c4mr149358edx.34.1707420671059;
        Thu, 08 Feb 2024 11:31:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFsxHVj4yR3SB291sP445sVMKVbI81OF8XZl66Kj6TFmKLpg0hThCmEuUlU77ldDlIGOUSAxA==
X-Received: by 2002:aa7:cf95:0:b0:55f:ec52:73c4 with SMTP id z21-20020aa7cf95000000b0055fec5273c4mr149344edx.34.1707420670739;
        Thu, 08 Feb 2024 11:31:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXcg+MkJnBi7LuWObXkd21CPr5jg44VOWU2Tp6hczV31yWw/visww1h4gsVEhYRIbrjDNlJ66aHv626fudQWiW4lziVNxrQPY32V+YTnr8Hf1XinfvXKd3q1nnMXytRG6FYkC15kTmd/TfYEmUkDRhe1rdLYFgJMkYhWVXXSHXuUAViYGHCvR/OQ/937C8v44WkZRKc
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id n22-20020a05640206d600b0055ff708dee3sm41793edy.11.2024.02.08.11.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 11:31:10 -0800 (PST)
Message-ID: <ed511f49-ef77-4cc6-bebb-7f4e7c69e008@redhat.com>
Date: Thu, 8 Feb 2024 20:31:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] KVM: selftests: x86: Use TAP interface in the
 userspace_msr_exit test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20231005143839.365297-1-thuth@redhat.com>
 <20231005143839.365297-8-thuth@redhat.com> <ZbQIz3thIczeRhCs@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
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
In-Reply-To: <ZbQIz3thIczeRhCs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/01/2024 20.32, Sean Christopherson wrote:
> On Thu, Oct 05, 2023, Thomas Huth wrote:
>> Use the kselftest_harness.h interface in this test to get TAP
>> output, so that it is easier for the user to see what the test
>> is doing.
>>
>> Note: We're not using the KVM_ONE_VCPU_TEST() macro here (but the
>> generic TEST() macro from kselftest_harness.h) since each of the
>> tests needs a different guest code function.
> 
> I would much rather we add a KVM framework that can deal with this, i.e. build
> something that is flexible from the get-go.  Allowing tests to set the entry point
> after vCPU is fairly straightforward (patch below, compile tested only on x86).
> 
> With that, my vote would be to have KVM_ONE_VCPU_TEST_SUITE() *always* pass NULL
> for the entry point, and instead always require sub-tests to pass the guest code
> to KVM_ONE_VCPU_TEST().  I think having the sub-test explicitly specify its guest
> code will be helpful for developers reading the code. 

Yes, I agree that sounds quite a bit nicer. I'll give it a try...

  Thomas



