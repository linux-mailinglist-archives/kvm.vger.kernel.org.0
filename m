Return-Path: <kvm+bounces-19870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37DBB90D717
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F338D284388
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F26336AFE;
	Tue, 18 Jun 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JyWlia7X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B0F2869B
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718724033; cv=none; b=Og0Db+FiJuKhL+cGe+fH/TzIHO4zFO45vwoi0siB751VHjEvL3+M3RH49lDRsrraWegRzA3TzoGdJA90djFDjY3fYIgC4zlLVU/ShxKiSKXckbFYVlFQgLYXY/PYxrs0okAKnXoIRlGqtv6Sydn+QozShAJ8/r1uPQrbndbcqJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718724033; c=relaxed/simple;
	bh=UpIL0FZhugtSO0PCHFB6YvCrVBy5Ez62yNiZ9IBrEHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTrzVEMck8JdRn5i6uqSxlmusHL0oGpmUNSBkfOeemq7ThSwwaXnDApFyASdg1DfCXxIrOOMYsu682k4cfE+oNcvEDA2b5moj/ScfEEUKJ0ToxekdvbDQrBbZhORasQWVFAuUCEV9owlT61lcXmiIDYXALKmepBrCXQfty/1eVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JyWlia7X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718724031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SdccRNwPFyO8O52lGoSzCDhRZy+l5WeB9XNZg0xkNc8=;
	b=JyWlia7X1wJmbGNyW3ZkWTR42zY0+YK4PTZsEcMoR1aNmUPrYYBMhKDf0hofLhwNCLRbpw
	nESJWkHLFuUyV8YlHrtTA3MR9CqrLmpzcCmLN2t7qphSXtj3Uc5WGGUfHmjHZdWq9zRw6B
	AkBTZVcR/ujuRywD71jaEZiGkq72VjA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-d6L4IML9P4KM0gQAB-4SfQ-1; Tue, 18 Jun 2024 11:20:29 -0400
X-MC-Unique: d6L4IML9P4KM0gQAB-4SfQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b062c433cfso64053746d6.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 08:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718724029; x=1719328829;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdccRNwPFyO8O52lGoSzCDhRZy+l5WeB9XNZg0xkNc8=;
        b=P657LoTqa3DwR+s5bTpKQWplnolcDdV5lbJK/zdyWJ/HRY9S43dwP5VY0VDRhWPIkE
         A6Vxtjqi1X8WYxUTzcBmCqdCkGHIqNlUfs8jslIeVn1kWbyNtIkp67NComrY0VXO4odT
         GwXd6mtqfDLYLFshICoA0QmhZ+ohiabsaqCG8I09tEehM5T9lj5cqldRo+1ELRvGnk8w
         lHXeY0Auonh+xgkybOpXjwWgiDzJES6t8Ro8CVr/Rs4wTYijTLsQi0NgHOdxg+RgD7i+
         4WB2jexkUhtiypeH6NCWZLjPTjhG3NE9loa18AQs0WSP4ZwLvexSV/Uc0Lf083YLsLy+
         RJ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSTlrxPEdG7lMBX2VFtlAkFCBsQzfs0/HO1u6gY3SKd/TvHXZ3WZhP9qvSYpcMmF1t0foI5aqWO0QVM5WvEZ2Guyg2
X-Gm-Message-State: AOJu0YzCDQkvfvMl5acHYgCR7l4XJftx1ksUbNKpI2NbRFl0m3otfWF3
	qLOVD0eVZB/aDrXOsVy029H5E8iE47kDIVuh6wqkfS9O0AyScr2+T0yPM3nTUMRs/jg7bvq8KYe
	5cTKyuPCuS68zqqRe+2I7Ej9WXMPZBTHD+m1RJoUnwewxGvSphA==
X-Received: by 2002:a0c:c984:0:b0:6b0:743b:71f2 with SMTP id 6a1803df08f44-6b501e3ce87mr281996d6.28.1718724029064;
        Tue, 18 Jun 2024 08:20:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHYdTKfMa+fw0QlZi2lQL28W8hkkoEUvyv23A+9PZBmV1nEVMxnmgvy3Ik3oKEJAer0lEgOg==
X-Received: by 2002:a0c:c984:0:b0:6b0:743b:71f2 with SMTP id 6a1803df08f44-6b501e3ce87mr281696d6.28.1718724028627;
        Tue, 18 Jun 2024 08:20:28 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-117.web.vodafone.de. [109.43.178.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441f2fcc297sm56340781cf.63.2024.06.18.08.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 08:20:28 -0700 (PDT)
Message-ID: <338c2a1d-7919-4fc6-8269-7f6e04748d53@redhat.com>
Date: Tue, 18 Jun 2024 17:20:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v10 08/15] powerpc: add pmu tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-9-npiggin@gmail.com>
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
In-Reply-To: <20240612052322.218726-9-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2024 07.23, Nicholas Piggin wrote:
> Add some initial PMU testing.
> 
> - PMC5/6 tests
> - PMAE / PMI test
> - BHRB basic tests
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/processor.h |   2 +
>   lib/powerpc/asm/reg.h       |   9 +
>   lib/powerpc/asm/setup.h     |   1 +
>   lib/powerpc/setup.c         |  20 ++
>   powerpc/Makefile.common     |   3 +-
>   powerpc/pmu.c               | 562 ++++++++++++++++++++++++++++++++++++
>   powerpc/unittests.cfg       |   3 +
>   7 files changed, 599 insertions(+), 1 deletion(-)
>   create mode 100644 powerpc/pmu.c

  Hi Nicholas!

Something in this patch breaks compiling with Clang in the Travis-CI:

  https://app.travis-ci.com/github/huth/kvm-unit-tests/builds/271013764

Not sure what exactly it is, the log is not very helpful. Do you have a 
ppc64 host where you could test your patches with Clang?

  Thomas



