Return-Path: <kvm+bounces-25848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 243A196B978
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 570EE1C2183D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3291CFEA2;
	Wed,  4 Sep 2024 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKfMBZo3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6D1CF7A9
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725447444; cv=none; b=JYsy7E1Y0toeqEOdQGZ94+ko0dt3lo7k3ehPFwDAdA0nm6ynryFjcQCj15mRV6Bkg0efPNeg2E5kRADB39F07blRSMrx9eHhhoWloBQwZ4cwu2LRUcc2ny64qVPeIcVYRbpKkqCshY6WtpQ/3bTsgJOhpQbh3hgh9/DyWG6Swxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725447444; c=relaxed/simple;
	bh=IryjHPr+Sq6KjBqHBKJelks90Dd+fmdqZLQGaZdweb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iZ61t/ATySwt96YKL4BZOOAhHsWwVz493dq5pJ90gLTmWHC/uTzM4H1bPdPBYeyOT7DgvU8hh+a8bKGu/bI+hd2rS56SqINlpxjiuyxIHUvCC/OHFYeXkrK8FmoXGCAsnj+o1vsRorigEnza9A9hlWRq+ipYD0/wUF/eJA0/R0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZKfMBZo3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725447440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gUfy7vBSh0K01zFNsn5gxi7P6P/xGBI0zl9UM5g03aE=;
	b=ZKfMBZo3UX41JBCyxlZtyju4vYObq2GBS4FRKtAbDUiKJWdWiDZx3W8QnXpt/1BkKxaZ9Q
	ZNEs/tTynZVuOg4e1rCUt8NeRdR9sLHtBLgethlY9eg+pwMI2vv2PgUUMOdlS06/7j+F62
	9aASdm3nSfpkbY2MPQZCr6G3SiUFCyo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-h4Ofew9QPHqMfMeiaG8I0A-1; Wed, 04 Sep 2024 06:57:19 -0400
X-MC-Unique: h4Ofew9QPHqMfMeiaG8I0A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280b119a74so10882835e9.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 03:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725447438; x=1726052238;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUfy7vBSh0K01zFNsn5gxi7P6P/xGBI0zl9UM5g03aE=;
        b=uvvVrDvScsNplKl7udjhtCt8M6MGhQWv25fXG6XU+3Hlm4HZhhtRl9AfJ3cdRuD3AP
         P9voEY781ljIc2MWLXngPLLHEVHRySZlbGadrZH8L5JTbhSInWYDwb1j17xU4JhD63YO
         HDBUdwwluq2c2cHHeGQpgIGWJ1TBVagfvKSc4yGFq143rhYVI/RRv41o8zqxCJBDGrPl
         yP4tVVcYAP2XptPiEm/Ml+jHcQofokQbGrsKQqHcDc0F3KGayllGeLdkPwAt07eH+Ysa
         enkX7dBVYoLkOJISGc/3P0gRTJS5a/qNcQ7uszkrHS+NXAYp6T+iE81ZWnB8azLX48lq
         T1Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXAyAQEEs5qAI4r86S6iMPyaPv/jtzmYQ/crr/orv24xdKqBRfVoWiKxh3aTzluINoknPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZTwSeWZxYY4GVEudi3FW2NqZXuIoIXNBQU1eLS9tIv7kdihqA
	6/FwMO0OqkjbDPPr8MQgHy+v9OFpfUbMnLsm8HEI5PYHSLuLFQVD+u8IxgRdseSTpHXI3ENW7Hu
	Jxt49DCZj1F9wrwvFCCsXE3OrfGsJ7aSXisl7a9Ym8TQUkh6DOA==
X-Received: by 2002:a05:600c:4445:b0:42b:a7c7:5667 with SMTP id 5b1f17b1804b1-42bb01e6c71mr141132765e9.25.1725447438213;
        Wed, 04 Sep 2024 03:57:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3bTtG96Ys6nCpHR+NA9gfbqo3z2M1uNCXMJJTTF4fsqkhQOGYOpIpNQY5Ixhs8qpqzcI3xw==
X-Received: by 2002:a05:600c:4445:b0:42b:a7c7:5667 with SMTP id 5b1f17b1804b1-42bb01e6c71mr141132595e9.25.1725447437702;
        Wed, 04 Sep 2024 03:57:17 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-176-181.web.vodafone.de. [109.43.176.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bbc87773fsm160650225e9.0.2024.09.04.03.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 03:57:17 -0700 (PDT)
Message-ID: <40bc448a-420b-4dad-872c-5b10a756dd8c@redhat.com>
Date: Wed, 4 Sep 2024 12:57:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/4] Makefile: Prepare for clang EFI
 builds
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com,
 cade.richard@berkeley.edu, jamestiotio@gmail.com
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-8-andrew.jones@linux.dev>
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
In-Reply-To: <20240904105020.1179006-8-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/2024 12.50, Andrew Jones wrote:
> clang complains about GNU extensions such as variable sized types not
> being at the end of structs unless -Wno-gnu is used. We may
> eventually want -Wno-gnu, but for now let's just handle the warnings
> as they come. Add -Wno-gnu-variable-sized-type-not-at-end to avoid
> the warning issued for the initrd_dev_path struct.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   Makefile | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 3d51cb726120..7471f7285b78 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -50,6 +50,8 @@ EFI_CFLAGS += -fshort-wchar
>   # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
>   # starting address
>   EFI_CFLAGS += -fPIC
> +# Avoid error with the initrd_dev_path struct
> +EFI_CFLAGS += -Wno-gnu-variable-sized-type-not-at-end
>   # Create shared library
>   EFI_LDFLAGS := -Bsymbolic -shared -nostdlib
>   endif

Reviewed-by: Thomas Huth <thuth@redhat.com>


