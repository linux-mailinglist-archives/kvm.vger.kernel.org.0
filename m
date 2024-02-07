Return-Path: <kvm+bounces-8211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3890984C5E3
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 08:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E42F828B08A
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 07:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB17200BD;
	Wed,  7 Feb 2024 07:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFYH/tK+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F84200AB
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707292719; cv=none; b=B42Aji7vjw2st1TWhJQdBtsif6bRazorO97P25aek/p71IcClOuRCMYcWXGWxvsAqUTRMSKSgVNV0nU6N+90W4HkVJbMLfvVVfqVVFFabGIdxqrbDuNqypOZM6Bu+2FLDsTy79Uhc1UrQu5riD6eD1jIkQNdxbaXr4HX/jLJDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707292719; c=relaxed/simple;
	bh=wegJlsKxzhMiLpMvhMviLwKsk71wGPNz9YHSAT5mjPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b4xZNQ7igpioRVUpxhH+49GdBl2CypYtiEvNnK6bgwOg8FqSkdXGvjUeCJLRlwpCd8U133Ia2Tm+rIZ+5xv+1sXAeaVe3G3a1cPuMspqKD2cT2VIU9SLXUEBNhOxewAYwxsVfpQqhPrVcyKwy7opMwY1pqH/60pq19rxtTLXpms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFYH/tK+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707292714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXtKRnFkGoIwoyq75fyFW+2T2/NnWp1FVhv8bHmQMRk=;
	b=WFYH/tK+4OfLq1PSbg7zEfM8haldo3dSbaGlfjCij1dYp81TYs5VLg8sTI12ljbg8kH1IA
	yJZqyvC2DY2ZR51U3OYuu/hSUd12WmzCw5DrIduxYrl0wBapMgYkHINjbEGsB3uMOGhdzn
	XpPg0UdcDHkx6A9zXHbxzl5Zq3qdw38=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-HELRgTCkPmq-ypfZkpSe1A-1; Wed, 07 Feb 2024 02:58:33 -0500
X-MC-Unique: HELRgTCkPmq-ypfZkpSe1A-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-78319f64126so37893485a.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 23:58:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707292713; x=1707897513;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXtKRnFkGoIwoyq75fyFW+2T2/NnWp1FVhv8bHmQMRk=;
        b=UM+g3LgRQAwN1BYDl66EwLOk2zK6/coNpkn+0wHb+DIdFNGTGy+/uCpxnpvIbdrLrT
         u0RLN5LAtb1nyhcPPRKGZSjF4gbmOdJzdkECoU8THgRxkkpbbPiD50+5yHcNNz4pryXm
         Eo1HTweq+ppqUvpjmhNGi3DgHhLMbYGsutZ013ERmt4nTEXPNkgbOhO0UuAA+mFC1SB/
         yWytL/qvXt6LI9ayc3D1zD5+Iq0jLMTmYdFFMD2dVycIKyokegSUksJkCiH7kGgvY5D2
         5ls40KM/LGznkdkrTtfliN82NsNDRHZUj65qsY4OyZVXMczDxYTjHxAtCCzOTBmI0U25
         B7iQ==
X-Gm-Message-State: AOJu0Yyn4d8grGuKlf3c+Hl5QYBP99Vh2ANZ/gOkIGtpK9ZChuoPpJzm
	CV9fGmWziqMtQWkJa6LxF/UoXDWVqp56PqwrqBlXimdONKYTkScrQK9xrEliurY9PujbxbUS1yB
	N8FKJWd2Ga5qbHuA6z+t9sWf6hhnaPPGjUdHYYToZ/+cIjcuMEQ==
X-Received: by 2002:a05:620a:893:b0:785:9516:e18e with SMTP id b19-20020a05620a089300b007859516e18emr2959766qka.74.1707292713085;
        Tue, 06 Feb 2024 23:58:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2JN2Mgedfn05mNWMskVZ+JRFEbw01S3JaZHXZ9RYimMQtAsTihbPTpool2Yf5VxmPatMcAg==
X-Received: by 2002:a05:620a:893:b0:785:9516:e18e with SMTP id b19-20020a05620a089300b007859516e18emr2959757qka.74.1707292712767;
        Tue, 06 Feb 2024 23:58:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWXE1pNT2QRlPIHctn/MMH5bqYta7MvIyiMhFGaqZJ4cKOg0Kon/zrftNfQIwtabiSl4f/zhsnSSZzHtOUowgK88PgEVxzBCOZr8E0ecmP87llZyXTFJoQklMx12eJ4opVtSTOgZBcOxPm4RxXCzcdbrHXKeTolH7SH68j8Veb7oOEFH+I61NMOI+5KUlbjIIVjGYvGqE3ACH2z/pRda940pxJp/N85l7AY2FWEafslvVKg6H26JuxSXTO1YYwjYSM7wV/BeVQ5TwHE0duf3IQmMaU52d2JSi31mgQXmH9JiBUuSL8qSn9Q+tJXA/rggbfzLZ9vpjxMtLeYB/76ZkVkk/2kk3g3guTFSh8m1OlmpSPWAGcuekTUdejCDndZsRwsIIOtPg0kAYQjBPokjJMqHRfXO5g6XDAvgwQUDVyYA+AZJVaJSnhkhFhM6FAx68U9Q2i+GUZwY9gDon2p0M1TXgLVhes4UewnRle2BFjkNlG/GLg=
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id x28-20020a05620a14bc00b0078536f14c08sm307564qkj.47.2024.02.06.23.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 23:58:32 -0800 (PST)
Message-ID: <c9039fc4-9809-43d9-8a99-88da1446d67f@redhat.com>
Date: Wed, 7 Feb 2024 08:58:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arch-run: Clean up temporary files
 properly
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
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-3-npiggin@gmail.com>
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
In-Reply-To: <20240202065740.68643-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/02/2024 07.57, Nicholas Piggin wrote:
> Migration files weren't being removed when tests were interrupted.
> This improves the situation.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index d0864360..f22ead6f 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -134,12 +134,14 @@ run_migration ()
>   	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
>   	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
>   	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
> +
> +	# race here between file creation and trap
> +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> +	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
> +
>   	qmpout1=/dev/null
>   	qmpout2=/dev/null
>   
> -	trap 'kill 0; exit 2' INT TERM
> -	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
> -
>   	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>   		-mon chardev=mon1,mode=control | tee ${migout1} &
>   	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
> @@ -211,8 +213,8 @@ run_panic ()
>   
>   	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
>   
> -	trap 'kill 0; exit 2' INT TERM
> -	trap 'rm -f ${qmp}' RETURN EXIT
> +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> +	trap "rm -f ${qmp}" RETURN EXIT
>   
>   	# start VM stopped so we don't miss any events
>   	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \

So the point is that the "EXIT" trap wasn't executed without the "trap - 
TERM" in the other trap? ... ok, then your patch certainly makes sense.

Reviewed-by: Thomas Huth <thuth@redhat.com>


