Return-Path: <kvm+bounces-10623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F23A86DFE9
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E073A1F21925
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DE86BFCB;
	Fri,  1 Mar 2024 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEmbtEVU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27466BFD9
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709291507; cv=none; b=RGHv1DxI7SXRM8xmRAWhvQZ3RF9xGYqVZfKH3lPon4+7ykTVE36KFZmoPHGCaRQvtJcFq1K5IinLh2Vss3zOS9dkKhWHiGWnbRbJlRysgLcbLVoMQS1yblBzweobx43Ow4EelzjvAMCc/lAf7oXb+Raz7mfPEH9Pzwp1qBCkfWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709291507; c=relaxed/simple;
	bh=/nweT/2peB6GrRwXiH15h6kY5fqcjX7Mq5LM/YOPU08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXRuiLCowVpfMRR2b+ySLeoLVif/TCRQLsp7j/0Mzafotz+y4KOkbrcn2CdbewQAHk7oztDr1h4ywFHhNMLOwvTEUwmkkhnUi4q8ds7v5bPTLBfDpQczzitfjJmx9hGfkd/TFqPoxVyWCB+MDN2KR+knFfqHI/GRdRhLpa1bAxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEmbtEVU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709291504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FCQYsUouDSxv5reDjPV/4WyHKOYkBj14Aw0nlup8uBQ=;
	b=JEmbtEVUapdjpPoWVE45DiWwryS17lfMPXrPs6sBF2DPu5sRuCSKOpa90pNcVa5Fjfcaq2
	tulqqKfMRiZMVHYisPlr3h0oocr/belCDSf6k6Xne2yvbP31OxzVsEN+Gp7GRtQsVIQxq0
	aIAK0ginb+J2OrIaF4BvZr5Dm97hguM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-r8aokBW9Pv6PX66TPWB6mA-1; Fri, 01 Mar 2024 06:11:43 -0500
X-MC-Unique: r8aokBW9Pv6PX66TPWB6mA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-42ec7864897so6238761cf.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:11:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709291503; x=1709896303;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCQYsUouDSxv5reDjPV/4WyHKOYkBj14Aw0nlup8uBQ=;
        b=O7w4zCvWZHR9MJwdf7uPROvAFFzAhPHd4fzXX0GPy8SMVQvqpMO+7nbkK07HEhyed3
         K/tE6ZxOm5rrGN7rakeexNn8N+e11BUm/Q69fCMk8lpxJD6YOiyqIkuxmcg1z2LAsSlb
         KBJ8iXEiy5ToDfgikbD2m7hRwhOmcMF1HCYQRYedn9N5qton1ihud8VQH3/aCgPyWRR2
         TjnTrYCiCvT108gb6eSShSZdftt69d7izm1XEfZFKmdwwni74uyJkSIz0P1AwnrN49/x
         A7mvXaBjRk7HTJjYdjnax9IjdApgXnkaktbHxL3J5ghoalyVwQI1dScLVGYbe8R9DMTq
         8CLw==
X-Forwarded-Encrypted: i=1; AJvYcCX1nYZwcLzv45jspiI77V23qNRT0IlcS/MzqeKP7ooIAv5rusuy1JfTv2sJeIIL5V9IXOAqjSdYtTZcowlklmQWC7L6
X-Gm-Message-State: AOJu0YxD+GVU8on0fiuP5vlfSIegO38fSpDr2Ag9IyTnnEfScOAIyDia
	QIdb7Nyc52KzSqLnOqmbSS8373E+kQ4h9hlKI7KzY/AAv8mVsn5E9XUxytoxqMntjeL3Xn3ZK27
	uVkbaUDKc7av0tYZTGJH2VeUtsymJD07sR7njPnrMUu2DrQhBtbolptVhjQ==
X-Received: by 2002:a05:622a:190b:b0:42e:8190:1974 with SMTP id w11-20020a05622a190b00b0042e81901974mr1411231qtc.59.1709291503136;
        Fri, 01 Mar 2024 03:11:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErXEfe705xXBhoFeCqf6iTiv9eaDLvwqBUTIjTmv+up8UgiX/WNvnRCbJQ4RdUyq4h5yLKww==
X-Received: by 2002:a05:622a:190b:b0:42e:8190:1974 with SMTP id w11-20020a05622a190b00b0042e81901974mr1411221qtc.59.1709291502844;
        Fri, 01 Mar 2024 03:11:42 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id k23-20020ac84757000000b0042ece270fdbsm233117qtp.93.2024.03.01.03.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 03:11:42 -0800 (PST)
Message-ID: <678e3dde-2579-4a21-9417-36f8374a2529@redhat.com>
Date: Fri, 1 Mar 2024 12:11:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 05/32] powerpc: Cleanup SPR and MSR
 definitions
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-6-npiggin@gmail.com>
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
In-Reply-To: <20240226101218.1472843-6-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> Move SPR and MSR defines out of ppc_asm.h and processor.h and into a
> new include, asm/reg.h.
> 
> Add a define for the PVR SPR and various processor versions, and replace
> the open coded numbers in the sprs.c test case.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/ppc_asm.h   |  8 +-------
>   lib/powerpc/asm/processor.h |  7 +------
>   lib/powerpc/asm/reg.h       | 30 ++++++++++++++++++++++++++++++
>   lib/powerpc/asm/time.h      |  1 +
>   lib/ppc64/asm/reg.h         |  1 +
>   powerpc/sprs.c              | 21 ++++++++++-----------
>   6 files changed, 44 insertions(+), 24 deletions(-)
>   create mode 100644 lib/powerpc/asm/reg.h
>   create mode 100644 lib/ppc64/asm/reg.h

Reviewed-by: Thomas Huth <thuth@redhat.com>


