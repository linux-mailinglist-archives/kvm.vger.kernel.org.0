Return-Path: <kvm+bounces-8458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEEE84FB51
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 335551C25176
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CD27F48F;
	Fri,  9 Feb 2024 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPC5XmDG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F269E16
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707501445; cv=none; b=UVt8IkoIY7jhoHRaLLoSujRkVYY3cmu346EPyL3pbwDy4uxsabUWky2QqAeCihhc5SJIQvpq31Qf60xvF+J6Y02kHFf3I4ie5luN0k4oyv4dQ5bg4KsetfQKe61FnpOpzKHN52vIaM27SvD2Y/Pc7Fs6ILXtZwHGqgb0x8pf6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707501445; c=relaxed/simple;
	bh=Ullq2irJQ2xO6WZijRd1IqfiDrXBUIKp6+qZkaAWTd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRONcS7wrQxAQm1WYVmnYf7ltEuUkAEGpZcPVUKPNHpHZdN3fKjqXCp6qFH/OXaXwuUYBCcV6TaRoa025kNJs725/UfVj8k5jQhHYt1iL1XijhVPxY5qiGMD5PNFNkgdGtU5X9GreGX0RCKyrvJ0PoEYbp6yZGHW2IoAYddhNGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPC5XmDG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707501442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2kgITGNgRH4Wqk6mUUFnib2/8oqDp6rW8fOt5+7CaGI=;
	b=PPC5XmDGBvqKXPIj5WdfBw6jE58eM6EhdzRfuAfs2GNOcc2H+NIbz0LNykEfDeSpburPTU
	iNhNmuagYrekW4yMsMxQqU/12ZRufRT1YjTeLcPp6jgincqqbAwehlUExuf8g5OFXNBy3j
	tEDL9za3/it0t2koGaLoQWj8rwXX43g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-Pm7sv7hDNiakAI9KY9zNFg-1; Fri, 09 Feb 2024 12:57:21 -0500
X-MC-Unique: Pm7sv7hDNiakAI9KY9zNFg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7833761135dso148186685a.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 09:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707501441; x=1708106241;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2kgITGNgRH4Wqk6mUUFnib2/8oqDp6rW8fOt5+7CaGI=;
        b=gDp1Ki8sH2VyBCzCxIO38KRG8EkEltWBbwiABiZgbDX6eP0D9QRk1POGm80uhONQsO
         rezYlEDKg6CmiQTLDoQKTW0B78YjAJf0v4b9ZSVyKVW58TdONLwyZ0Oqi4KYId0QmWEr
         Pv9jB5Zm1zhTzMg1PG1MK0TLkysOFalshI3DUCBhnrFuY3OvYqUFCk8Gb77CkDh2Acpz
         gUT+Di9WhAXUFKX7feIqpSUmLMUl5IDlw/6RlhNHGoNyX4qPBWVhC3UzzU/G3IrL0R/6
         HTRz5ezThB1okPoV/ahZyNmtd7UAOk9oLrqBoxBUwJlvJ3CI+EoRPe8cxSaJ/sd8ExQb
         PAkA==
X-Gm-Message-State: AOJu0YzUWQbUCoSfNe+o728E0ZuRkRCFEY8Zp+Hraa26AywBiSUvfd0z
	wN/RlBLbpUQudQFLnvsTOqJ4LBbCg0X6uIYUGsEVrK9w8lZcRza8R2gz+27BNkexN4DnorMpqJb
	p7Cq3ZN0nOoZwLQuxgIzEHf48JNMH12eBEmPZ5dhhrWGlkav8xw==
X-Received: by 2002:a05:620a:199a:b0:783:cb5a:ec3b with SMTP id bm26-20020a05620a199a00b00783cb5aec3bmr2878165qkb.71.1707501440693;
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFh9eBa+uL0TgU8I7s2UC/0d5VeQVwvoUVp9Qb/f8h1ezUPmyU5PofF8iaO+q5Htkiy1Je+JQ==
X-Received: by 2002:a05:620a:199a:b0:783:cb5a:ec3b with SMTP id bm26-20020a05620a199a00b00783cb5aec3bmr2878147qkb.71.1707501440460;
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXxdog3KtAVjA17ihb7yJMbtJys8LsF81l51sg4R8zhMr2ceg2lq62vOmj3gdhH39XD6aOFg9/L2Tk7nAT44EypfeNloh5Yb7v4MNhzbRx4awkuF9OcLqiBSxinoNtZLQBjd50L0P1ROKqAWPwz+/ohXd3W9z1cF830kNeU2FJXwo8LBlzxZMk/AsGOGTG7TvpjQJSar+4xvsPmATSrwMdekkSzwlnVvUqAtnC0xfnJVhcy2Hmwxh4+pZu2R3EXYzUgXla5jBmGgT1V2oyqG0bckI9VnJeIVGRD4sIsai7qCEtnLQHCyTtxBJWqJ+wj5SuLs48NSjgUR9iw/Pswh+ZmZiJOGnuxamkYGHPerL947oleU1N+nqSQmvm2Hpcrd3vXFVykzbExpeInqc9aC4rz6ohJv5jdthDnIk9YkLNxuQjJmRdFIKgVoKuyURm1BI+3Vnx2cIYKcvMdK74s3GZinvKMrYLpZcLDpnQGHSWPH4yUTeqivOQ3O1cRuvuqj2A4zqr0mjnP5HtxAM2hrc/gYj4Z
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id f6-20020a05620a12e600b0078552b5e161sm896441qkl.78.2024.02.09.09.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
Message-ID: <54232155-ef97-4911-b1c7-acc7ee06a676@redhat.com>
Date: Fri, 9 Feb 2024 18:57:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 4/8] migration: Support multiple
 migrations
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-5-npiggin@gmail.com>
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
In-Reply-To: <20240209091134.600228-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 10.11, Nicholas Piggin wrote:
> Support multiple migrations by flipping dest file/socket variables to
> source after the migration is complete, ready to start again. A new
> destination is created if the test outputs the migrate line again.
> Test cases may now switch to calling migrate() one or more times.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/migrate.c         |  8 ++--
>   lib/migrate.h         |  1 +
>   scripts/arch-run.bash | 86 ++++++++++++++++++++++++++++++++++++-------
>   3 files changed, 77 insertions(+), 18 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



