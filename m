Return-Path: <kvm+bounces-8408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED23584F15D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55EC28494D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B1265BC6;
	Fri,  9 Feb 2024 08:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6RLnSIU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C008065BB6
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 08:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467355; cv=none; b=nuDknHMmeTUWwMcezcY0I5JveJaWFkivxpORCxtn9Wt1Y8auI07ufmM7zxfLA5TM89ech+xWG86wFIEgWOZ2iQyKprSHBWEJhSNcT73PA1nzV47awfn7TxZ0LqrfRPwFa4t2gl0xa8R8SbG+Yu1rCmGTtLVkBpOiBlmMensd4Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467355; c=relaxed/simple;
	bh=ar3mqjsIdbZN/oexSyU52xoSyOoZGf+sKohPZbfTlAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPjBz8ofQS/TmvmL9oUnqYJTZjxlOwU2KcvpQ/iISWiAuJGfaEmyQ1OSGbHPgKCvT5d3BcSE4W/bSOmb5t3gVjXvL43grC9BVLbgHttzbu+JzBRRyKuuS9s3qABAJSZKYBnRax5yvMgZYFjDzop20RI9+WUk42WU2NojRB1C+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6RLnSIU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707467352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CYwym9bcvYVUdfgrQAx0w53qMrol8jdhzpg8cj+Mxlw=;
	b=f6RLnSIUZXPCicCL7NMAW/GI6ESbHad1Kd2QxdqlXujdhw8uZbIEtexv5R6Rxbl7tRk6UE
	TDhl6ugoTYe7pRjBaZo0GFUvQaunNDrM0s4VkkgVbYnE6rNV1ZC7HMyx1RfcQpLQH8Uec4
	NowQTyOtPq8baIod4oRPmycsczudrLQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-aA_SdjQvNy24RZ7rtloAOw-1; Fri, 09 Feb 2024 03:29:10 -0500
X-MC-Unique: aA_SdjQvNy24RZ7rtloAOw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d0d1cafe68so6434881fa.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 00:29:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467349; x=1708072149;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYwym9bcvYVUdfgrQAx0w53qMrol8jdhzpg8cj+Mxlw=;
        b=eLTdlgrHvJArpr8AE8dzx8Y2nDUsgoGlIUSdNFh1FJZblpK6BThT2ubDhJfIrStBHG
         MuHfI3cm4zkTZr0YLE/F8FknjOThV2BfGE3hSakrMa+jS14Az+KgnfxywERg4GQTPclM
         n/RyrAlUB37AqBECJydJD+CIv+g1+n00Ru956S/tO4lDfHYU9diCNBvx8yPkPkukD2vZ
         Xdb+ZsBaN2IneklYkt1//Av7ReyYCG5MugecJ3FxO03dUeU3ggvYsLdaQY1UMv+hR7HZ
         XngK2BH/xhrq04c1n79L9w9Zhw1GjFMXyXM3nieZEH3q5lSFddJEpBRPo/JtpQsSTF6B
         fXFw==
X-Gm-Message-State: AOJu0YxYPuPUSmAqS/tw/VoHnocSuUsz1/eAjtAPlVN63s/DnM/LmRD5
	iSHyTZ1szF6PKwrEHeNRzZgED22PNwaaoadWlKZBE3mrwoueWR5KAKLdMFDz37dedSmQpWPkBD8
	bIjSgQlQ/xEGPrBuqKvulW4T8fkNVvHb1JssFjC/fJmK9ESC+Vg==
X-Received: by 2002:a05:6512:308e:b0:511:4a3c:bc67 with SMTP id z14-20020a056512308e00b005114a3cbc67mr667558lfd.9.1707467348817;
        Fri, 09 Feb 2024 00:29:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwQzReLeDNTCJB+qOG+onzJW+a/6xHFTd6Il5yE+rs5dotq6oI7ml/IRzP9nwb4WRCRf2AHg==
X-Received: by 2002:a05:6512:308e:b0:511:4a3c:bc67 with SMTP id z14-20020a056512308e00b005114a3cbc67mr667543lfd.9.1707467348491;
        Fri, 09 Feb 2024 00:29:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVpQeKhZnUF9IF482WFoi5RSuK2K0dPm/viY5gZvvdBGW8PlAajaezs2kgDI06usWdUXLoRirtPMouC6vzNVLm1ebJIWnLWDLZ0GEN+Ijk5unz/HqQMvORGDIXXL3Dtf+prelx+pNyvYgYqYusGnquqaTXZA7QhS6HkQap6Y42pIVEN3/EQmJy7vAJs2JpmpxDIiPxkRPxrVbsmZSVnuPOwCDkwsek/pGDlArNd6Bhx7ExRfGSaMOQ2ipZnPHh4xKDAKmuDjNtcq0sQclTvVZDBpof/gkZtZFbDZHPz4rmJ1ciKFyS3O6Q898x0YkZAk2y+sY3IzMbJvaRgk+otdK75cu7gdEwEl57Q4sWFImYaPJDLS4LbMQtxErNNwect2IH8XoJ7esHEcOsAFRZwxa5aVSJRog7z8LtqPN/lXwq8u0iG8XVW+VdnuP/432M3PyFw2p8MGpGvbbSILN0vtIlZUve5ulCwIGBluVrh3YxuLzmOOdbG19SRLy0gaYXvLczv3TncY87RBF6BZarBaQ6IX1OF
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id x21-20020ac24895000000b00511749fec62sm90472lfc.72.2024.02.09.00.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:29:07 -0800 (PST)
Message-ID: <92633259-1a46-4342-a709-7200c6d215ab@redhat.com>
Date: Fri, 9 Feb 2024 09:29:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 7/8] Add common/ directory for
 architecture-independent tests
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
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-8-npiggin@gmail.com>
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
In-Reply-To: <20240209070141.421569-8-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> x86/sieve.c is used by s390x, arm, and riscv via symbolic link. Make a
> new directory common/ for architecture-independent tests and move
> sieve.c here.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arm/sieve.c    |  2 +-
>   common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>   riscv/sieve.c  |  2 +-
>   s390x/sieve.c  |  2 +-
>   x86/sieve.c    | 52 +-------------------------------------------------
>   5 files changed, 55 insertions(+), 54 deletions(-)
>   create mode 100644 common/sieve.c
>   mode change 100644 => 120000 x86/sieve.c


Reviewed-by: Thomas Huth <thuth@redhat.com>


