Return-Path: <kvm+bounces-6824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C1D83A61F
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B018B223E9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99BB18C08;
	Wed, 24 Jan 2024 09:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9M+fU8u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDB18AF9
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 09:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706090323; cv=none; b=YJ0daFjAkNxG/OvnZuTMvhGy/4Bv2ZP7UpXcDvI7toMMrkU2XjlHmKhkDjaluqXrIbdlN+FIlJoG4cA+LgLFurnOTB4JjeF42lqTr2Uq7zaMI42C1CCINTxtbHbpCzvRnyWgO2P3bmwseGEmVxcSNR2LbEUnqMoKEkjwlCJknws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706090323; c=relaxed/simple;
	bh=bkjO83ib1M9eZUG4pgKQCIucEcIhujihnVXwfWPVEdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q9x/9G3Kcz1p4Q48kzvw2d7FpsEVDrOkJAILsPmRwKr4tY/F2vrBsqZaL0WD2LJ3AdpZfjeQCgPm6EV6SJ+YE/qiprSjcyTVqNE5FmLm10P4Q4hJ9jLLwhQLv0JaJSgEriZ+Mb2XX60D+IRGzxVM/Kma79U6udKHPAFkTk2Xgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9M+fU8u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706090320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yfq210ULOE/BqFwEQD11cQ/YT9iyvMnRT2vGiFHcUJM=;
	b=g9M+fU8uekJmJ7XJMzN2QF/CVdhdty2GZPQ+bEucKYxn0oqORb66A7eTUVjemPmgu3EMta
	VhT9FcOtNfj8sglugg9n4VaMc0NepogcbZPVK7yGXL+FcZjv0OazaAEQ5224yTCsMWItzF
	fsaNcGLGSfdbs/I2KDVdGEhxnouR1ys=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-Leq_mWjdOVSiOkNW77qbkA-1; Wed, 24 Jan 2024 04:58:38 -0500
X-MC-Unique: Leq_mWjdOVSiOkNW77qbkA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-429d0905823so98305741cf.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 01:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706090318; x=1706695118;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yfq210ULOE/BqFwEQD11cQ/YT9iyvMnRT2vGiFHcUJM=;
        b=ErtlgMkrxA3cGOPB+u2IGmuFa2OQQIVaOe7Z7BqAEN++OmtFFsZHEcOXRfq61m4lOl
         8ZzpT8WkN7B48cEm9fuaJVU849CqnmAwiNo+UicTk5VViz0K9RFsDE3WfvskxATSnqaC
         i8VblKX0ORZmK0/JJXlalpXKEHVRKfSSVnK6kH31dn++3Rp5RNhSF3JtyT+MtrqJEM3x
         nUduS3+EL+oRBlIfPAzb1mnR+7neasJ1kM3wrV96BYvdXZbacqKEFPSEBrya/koavkQy
         4uSGC44zGxGnStYZbgwqBQZ5DQMPW5v375n3TS/LG46imMTHjPi/WsMz8jIrxvJUrjWP
         9ntQ==
X-Gm-Message-State: AOJu0YxIStP7DQA7t1jweyv1RNe4wdEr0MCH59PO0K6faiimZrOONTK3
	oSZ2kcxcDyfEZOmXgmfbZCwASmTCQkQTop9HXXsMVm5wePmJTpxzXe5PeHgkpdpVfF0FWm7zBYH
	lIHtIUxZRbvmeYj6JDYkqwokIrsb/0QbEkK8MyB8gsCmTqpYOpw==
X-Received: by 2002:ac8:5f81:0:b0:42a:3aca:3715 with SMTP id j1-20020ac85f81000000b0042a3aca3715mr1450608qta.39.1706090317891;
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKQVZrvUmul3dbpKl5GFlQj49CP/5V+rS5rM8g76PTxlM0YEFyIhqvZqrMU0stMjOYim0ELw==
X-Received: by 2002:ac8:5f81:0:b0:42a:3aca:3715 with SMTP id j1-20020ac85f81000000b0042a3aca3715mr1450597qta.39.1706090317662;
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-121.web.vodafone.de. [109.43.177.121])
        by smtp.gmail.com with ESMTPSA id dq2-20020a05622a520200b00428346b88bfsm4231931qtb.65.2024.01.24.01.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
Message-ID: <5f8a77b9-1b6b-4319-b4b8-ea11ede43cb9@redhat.com>
Date: Wed, 24 Jan 2024 10:58:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 00/24] Introduce RISC-V
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
References: <20240124071815.6898-26-andrew.jones@linux.dev>
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
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2024 08.18, Andrew Jones wrote:
> This series adds another architecture to kvm-unit-tests (RISC-V, both
> 32-bit and 64-bit). Much of the code is borrowed from arm/arm64 by
> mimicking its patterns or by first making the arm code more generic
> and moving it to the common lib.
> 
> This series brings UART, SMP, MMU, and exception handling support.
> One should be able to start writing CPU validation tests in a mix
> of C and asm as well as write SBI tests, as is the plan for the SBI
> verification framework. kvm-unit-tests provides backtraces on asserts
> and input can be given to the tests through command line arguments,
> environment variables, and the DT (there's already an ISA string
> parser for extension detection).
> 
> This series only targets QEMU TCG and KVM, but OpenSBI may be replaced
> with other SBI implementations, such as RustSBI. It's a goal to target
> bare-metal as soon as possible, so EFI support is already in progress
> and will be posted soon. More follow on series will come as well,
> bringing interrupt controller support for timer and PMU testing,
> support to run tests in usermode, and whatever else people need for
> their tests.

I can't say much about the riscv details, but I very quickly skimmed through 
the series and I'm fine if we add that to the k-u-t, so FWIW:

Series
Acked-by: Thomas Huth <thuth@redhat.com>


