Return-Path: <kvm+bounces-10872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8128715D6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A45A61C221CE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847687BB0F;
	Tue,  5 Mar 2024 06:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1SKFyWg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E2028E3F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709619987; cv=none; b=Rc/k+LKBG57EcJ4fOxMHawyH6eOK+F7a0A+5ni0atvVk5NMtCa+6ciL64WfwuR6qM8L1AmOMfsLIBLOYetBg4tXTeLDXKP56H4TxXR3I7yMGq4rQqtnxMOe/Oldk9ylffTvm2lHBrJsLZk2nj/KHprOCPb5pkSBBo8ByDxurDTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709619987; c=relaxed/simple;
	bh=6TUQKmeNKSWcwDFB/kZqSfdtYS8r8+0J2p/fQdqG4kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DaxcU8bAw257sYQTK75dfqmSqRMCcw7kFzjUX72lhODS1GQWLI+qJZQNCxtY4lPZP8V00D5gcv9PDRavorT4ZMOj7CcqK1/MH23vN0okaDF5Rxr2jP9Bc8mdcnBveCcrBil0IOdAeiT91ogK78fE6oGFoXdNsYtsph1eX8y2f7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1SKFyWg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709619985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Psz0OX/Ry6dfLhKgIYxOthAYSDfpuoHrqk87qxzifRI=;
	b=g1SKFyWg01on1dNKeZjfoqJWhuoHxP+psJ+SnhJWkcXwecRWKbr6CtzkCPMlLdhT8NDqNk
	iaSLln7CRi0f/+RMBSDyKNJuY7yhzEmQ5dZh96yap+dVlnncW7Zw4vDA6b3OR+cZqknMNJ
	RxcOFoWzr5Ot8P6QAqYDKBUlu/3FQ6Y=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-pFQc9OZaMeiveFSdHddItA-1; Tue, 05 Mar 2024 01:26:23 -0500
X-MC-Unique: pFQc9OZaMeiveFSdHddItA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a45851b0030so56267566b.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 22:26:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709619980; x=1710224780;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Psz0OX/Ry6dfLhKgIYxOthAYSDfpuoHrqk87qxzifRI=;
        b=IfYD8YN3EXXuAZz9Z9XhThAgo/JxQPR8qUvuMO5JZbb4t0sYPSke/a4oI6/cRUkR3l
         BJF3+1ivSlX/7QqIyA6eZMGU1yBUEDsKot+zeWCNKEcn0hAoenZwVMKCbCKXRS6DToIH
         1G1Qlie1o+/EpFF74WIWpzJKp+MEYWRCvybzdmWhpCxPfIHQcIbHOjEh1U00pKInMdc2
         aGAQpceG89ieBJ1dvetX83ID6McyZkbikvPg7y9JCPW3cXQ65A812WKuoyIXbQO2vGpz
         GKbdUP9f51IpHJDOBGv1er8ecox5JirXlZDLJSiHeT5hZgy4Lhv8FIsDaHQCIPoUAdCr
         BQIA==
X-Forwarded-Encrypted: i=1; AJvYcCWXIWrn3fj0xpAuCW7F+mphtOsOI3Qpcau8PJB9lJIlbmkwCwzpQoCQqcC8WIILzF1Ea6lAiLGs92ioIuKuLo4pCKok
X-Gm-Message-State: AOJu0YwkJ6Ju/HDByWWp7BtYos4cq7ov6fQj2WsolEpalQ37WqBCprRZ
	qfM9QD1HAOZ7ierjiNksM2k94+Gt0xKDZhIVSckKX8tAoxqtAPabuICTAecWEg6MgTx95xlX+i3
	qRD/1IIG3aXhAsFq7MYWTa8jXx7BEjWTn42fyHP/a4Zb92yh4DA==
X-Received: by 2002:a05:6402:2152:b0:566:ef8:93f6 with SMTP id bq18-20020a056402215200b005660ef893f6mr8250387edb.0.1709619980490;
        Mon, 04 Mar 2024 22:26:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTa/zG+QpTThJzAA9O4uIQf+HbpHsGxRptfQLve9GrKC5j34N1kdtZVpEBSY7iYj/0WVHqdw==
X-Received: by 2002:a05:6402:2152:b0:566:ef8:93f6 with SMTP id bq18-20020a056402215200b005660ef893f6mr8250373edb.0.1709619980229;
        Mon, 04 Mar 2024 22:26:20 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-243.web.vodafone.de. [109.43.178.243])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402321a00b0055fba4996d9sm5464921eda.71.2024.03.04.22.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:26:19 -0800 (PST)
Message-ID: <542716d5-2db2-4bba-9c58-f5fa32b22d52@redhat.com>
Date: Tue, 5 Mar 2024 07:26:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <CZLGGDYWE8P0.VKR8WWH6B6LM@wheely>
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
In-Reply-To: <CZLGGDYWE8P0.VKR8WWH6B6LM@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 03.19, Nicholas Piggin wrote:
> On Fri Mar 1, 2024 at 10:41 PM AEST, Thomas Huth wrote:
>> On 26/02/2024 11.12, Nicholas Piggin wrote:
>>> Add basic testing of various kinds of interrupts, machine check,
>>> page fault, illegal, decrementer, trace, syscall, etc.
>>>
>>> This has a known failure on QEMU TCG pseries machines where MSR[ME]
>>> can be incorrectly set to 0.
>>
>> Two questions out of curiosity:
>>
>> Any chance that this could be fixed easily in QEMU?
> 
> Yes I have a fix on the mailing list. It should get into 9.0 and
> probably stable.

Ok, then it's IMHO not worth the effort to make the k-u-t work around this 
bug in older QEMU versions.

>> Or is there a way to detect TCG from within the test? (for example, we have
>> a host_is_tcg() function for s390x so we can e.g. use report_xfail() for
>> tests that are known to fail on TCG there)
> 
> I do have a half-done patch which adds exactly this.
> 
> One (minor) annoyance is that it doesn't seem possible to detect QEMU
> version to add workarounds. E.g., we would like to test the fixed
> functionality, but older qemu should not. Maybe that's going too much
> into a rabbit hole. We *could* put a QEMU version into device tree
> to deal with this though...

No, let's better not do this - hardwired version checks are often a bad 
idea, e.g. when a bug is in QEMU 8.0.0 and 8.1.0, it could be fixed in 8.0.1 
and then it could get really messy with the version checks...

  Thomas


