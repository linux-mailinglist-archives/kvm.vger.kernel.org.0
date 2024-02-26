Return-Path: <kvm+bounces-9843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD68867334
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAC8228975A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523F5381A1;
	Mon, 26 Feb 2024 11:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PN0ic6+N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F081E1DA24
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947247; cv=none; b=s573kHHqj4jUQ2fB092xYK33hEd2BuDQq+A69hiZLNvOTlaUI9TcyBNTU1cQ9vaRfkzErFkNtBu1/1QYBB/WEc1E5HghjVJQ0zeqoQgqGB2+Hlf4mQtPeIyubNjKfQpes3BX7dR4YAClfEzYnOU46i8ExG7s88+gNEE/ok2Uolg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947247; c=relaxed/simple;
	bh=+MjSgiwj5ResJF/Wp9XXR2mXK6nNnG8RpG4DFs2algg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uH1VZ1/zLoZnqJliieT0vbbR1K9bgLZtoKCRNp0KaZb4ycnIdpZzf93/amxHWSL6zZiLg1Obu574ZTEoGuw1HU6QPJVtri6t+fCI/+3S/32DuYkRZmm1A/4aHyDW8jPXwjLIuiTZwjYyHXEz+uFWTgwLTq1AcRI5Y5Ou6Uzk7xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PN0ic6+N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708947245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZOaJdE8PeYEjIrCUWsmLxfgMZZ6msDvRYam8ZbRXslw=;
	b=PN0ic6+Nm/Y+rivjEwF4sPvbImC0T7Ysnp+of9BJnY7slvhO3T5wefyqnzQWujKFdfaX2V
	hwTl5CdxpzdkP+9Xae4PTjoBouFAHf1gnpMubMLNfTlHNkOwDbKO3SqJSUi/LqlYUOdn7l
	HLctU/u16rGYY7/o5hmU9Q/JJrqBVzw=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-qC_A9uOkOhS9xa_1nMc5qA-1; Mon, 26 Feb 2024 06:34:03 -0500
X-MC-Unique: qC_A9uOkOhS9xa_1nMc5qA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-60915c6685aso4110777b3.3
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 03:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708947243; x=1709552043;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOaJdE8PeYEjIrCUWsmLxfgMZZ6msDvRYam8ZbRXslw=;
        b=WdrLMoQsr0335tcDXydGMr0nz5wUrelQ3YKfLHC1VDmSlsjWeHgtwIw8IuqxZ++kKp
         Hg6lFSFTQRmUHBE9uGrU4z/geaxFkVvcBkUz0sU7yhtdoAiFXTNg6FTNd2a4k3+GLdAI
         RNy9K0yqfsMXBocBdRkL8k1S3oXZGONyin9Zr/3fh3gbkfFQ4acLSxe2pTh/iTTqlo5N
         LnJh4Et+D5TAJ7W01Gbr9wvDKsz310D144YlXKp0dSMCUMYoEEkGTEPV9yJJqoas970J
         ICdK9GRtoMZBsl9ZZL80WTwaLZ+nBI+FfKMaMvYQmr+x2DYiqHEZ8dXH4muiNrfF/JVw
         5j3w==
X-Forwarded-Encrypted: i=1; AJvYcCVh4+kS5nMkOFv/UI891vqAngDvoCi5V4qV5Y2UqIeUXfMVGTSCrbVL5yknRgG54oatfnhozNEQ5bZVSh3++9jdVUul
X-Gm-Message-State: AOJu0YyyQR+wmDolG3bUa2syLv2rqrYk6WtTd76Njv1NHpyjFvCTBIIE
	JKQULFhEVXbaCOHLxSJ0eu+MwwcapzXx8z7zMK2J4iK9gHBa131vc0d9VDZcDhFjciFblvoPGqA
	wFfu7fKZL7odI188ogsc+jdQ9C/VLK15vEnJ//9ckp/803SdN9A==
X-Received: by 2002:a25:f306:0:b0:dcc:693e:b396 with SMTP id c6-20020a25f306000000b00dcc693eb396mr4104825ybs.2.1708947243395;
        Mon, 26 Feb 2024 03:34:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVfqVKS4F7BNE8Uq25y4OH59TTel/eaKivzXTgKLUGXdDfhzOnbhVGquOdGmRVkT2ExNTCUQ==
X-Received: by 2002:a25:f306:0:b0:dcc:693e:b396 with SMTP id c6-20020a25f306000000b00dcc693eb396mr4104813ybs.2.1708947243129;
        Mon, 26 Feb 2024 03:34:03 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-176-215.web.vodafone.de. [109.43.176.215])
        by smtp.gmail.com with ESMTPSA id a13-20020a05622a02cd00b0042dac47e9b4sm2344880qtx.5.2024.02.26.03.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 03:34:02 -0800 (PST)
Message-ID: <c05354c4-4130-4a55-8725-86fe9b676d75@redhat.com>
Date: Mon, 26 Feb 2024 12:33:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 01/32] powerpc: Fix KVM caps on POWER9
 hosts
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-2-npiggin@gmail.com>
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
In-Reply-To: <20240226101218.1472843-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> KVM does not like to run on POWER9 hosts without cap-ccf-assist=off.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/run | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/powerpc/run b/powerpc/run
> index e469f1eb3..5cdb94194 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -24,6 +24,8 @@ M+=",accel=$ACCEL$ACCEL_PROPS"
>   
>   if [[ "$ACCEL" == "tcg" ]] ; then
>   	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
> +elif [[ "$ACCEL" == "kvm" ]] ; then
> +	M+=",cap-ccf-assist=off"
>   fi

Since it is needed in both cases, you could also move it out of the 
if-statement and remove it from the tcg part.

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>


