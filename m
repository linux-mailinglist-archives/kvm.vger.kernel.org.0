Return-Path: <kvm+bounces-16681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C17EE8BC873
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6871C209A8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1871A127E3B;
	Mon,  6 May 2024 07:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1BOp5fj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568038384
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714981063; cv=none; b=jSyYSEvKTYNKK8B5KMfalkJBmdPTP0BOH1Lfx5iMxSdWCLVGVeKo9VZTAwvaILIQIrrwGhXqnh7tJ16379UXNsdftX5HjmFIuA7wTYskWPLolQ+r+PtLARQME8n18cpekieQlY05qvLZYcWo6Ggsav5p+3jy/ko3swpRXKMArZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714981063; c=relaxed/simple;
	bh=FELeZu8y7WmWEM3MQdQQ1BWQtNju6wHQClAhHOXZYcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjlW5T/5Dvu0EQdWIEo7BjJJMK6Y/GD32qNkNgSBu6lxxcdzAT0a6kHC9G6hksRxaxMtyI7hQb97HgzMkbImWgQfy5cJlUW+EAPpwSCywNEgnHWAnWkjxIDGv+YpPrtq2oPlZVILwz5BxLvPJRL5oFQFlMo3r1iER7PsG8AEEvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d1BOp5fj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714981060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z2/StfFCKiPHiaGerg/V2iv95okh7df8NQGDSBy2T8Y=;
	b=d1BOp5fj2YColrMbFQXmIf1F8kc7Sx9RSqIjKjRAT4FEydlgtAHmF1XEGoiw8Hbwv2elCM
	pTtHY5cV5oDdEWvkP2N630Rg9z65L5VwnSGKqwW89evq6bIF69Otefc7fe6JaRYbBfB8CD
	wLWWx6ic5epAoOyUzD0nSL5nEOIioIY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-IA-YZxYkPtK8X1wKqLesWg-1; Mon, 06 May 2024 03:37:39 -0400
X-MC-Unique: IA-YZxYkPtK8X1wKqLesWg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-790fc382b68so160815485a.3
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 00:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714981059; x=1715585859;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2/StfFCKiPHiaGerg/V2iv95okh7df8NQGDSBy2T8Y=;
        b=hHVID+XgJoYGXgd3/jxffaYKwb6o0sLTVceSoCzY5QjKWi0IDSnua1ejlAmoPOj5KE
         /GtV4HJohMQ/XXOFglQ4qzVciN0nWTfSXYF/y5/8YzKjlYgNvb7KfmdEkViGq1TRdLgw
         ftkHRBU1LUEMzaUObkRHTs1zdRDbnMHAPazVbQu0+a7rrtKFUlSuzZ8pqsAXdKEPrP4T
         1asixb7gIiWSFBLQ09iGUHCPL6wVp2i4GeluV9pKijOHjmEjv4rS/rqTGK3SelrE+dC0
         9rOijVlS5N6kW4s8HHIcm2Ujf2nlBmDL6i1Eo7ExhenOH/YnzB46A6vN2zjLiA6oTag9
         617A==
X-Forwarded-Encrypted: i=1; AJvYcCWNUVjSUC3WVpZTXgJmy6oplEPuv6GVA/DmlwrqFosaje/8ip83dx4ao216CZnTfqVIghZfNC+9Dg2R2rafO0YpdRsz
X-Gm-Message-State: AOJu0YykRk/Bov1qIhD/JZKxfYIXiFY3QKzZ3Y9HqnRFOntejcpyYdGN
	krjHB8qDc3cLqkv4QcPxTzickzdr/Lq2iPDt6lSvT+S97BGgCkmNBvBQM84H5xQbB2M9MBV5Zry
	YL5x+sCASZi8k9frDmfzBeLCdEJKRYDahJwNdypbc+tz2uXKStw==
X-Received: by 2002:a05:620a:4493:b0:792:8448:8cbd with SMTP id x19-20020a05620a449300b0079284488cbdmr9070656qkp.26.1714981058881;
        Mon, 06 May 2024 00:37:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEvAeNYYY70BsD6iznpZJo2g5JJLURbvdXrZThg+8wMCRbE3UjcLT4AxnTUEfh6Vf4HaXVfw==
X-Received: by 2002:a05:620a:4493:b0:792:8448:8cbd with SMTP id x19-20020a05620a449300b0079284488cbdmr9070640qkp.26.1714981058354;
        Mon, 06 May 2024 00:37:38 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id p18-20020a05620a22f200b0078edc0a447dsm3642549qki.68.2024.05.06.00.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 00:37:38 -0700 (PDT)
Message-ID: <f2411fc8-5f90-4577-9599-f43bb8694cd0@redhat.com>
Date: Mon, 6 May 2024 09:37:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 03/31] powerpc: Mark known failing tests
 as kfail
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-4-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Mark the failing h_cede_tm and spapr_vpa tests as kfail.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/spapr_vpa.c | 3 ++-
>   powerpc/tm.c        | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
> index c2075e157..46fa0485c 100644
> --- a/powerpc/spapr_vpa.c
> +++ b/powerpc/spapr_vpa.c
> @@ -150,7 +150,8 @@ static void test_vpa(void)
>   		report_fail("Could not deregister after registration");
>   
>   	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
> -	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
> +	/* TCG known fail, could be wrong test, must verify against PowerVM */
> +	report_kfail(true, disp_count1 % 2 == 1, "Dispatch count is odd after deregister");

Using "true" as first argument looks rather pointless - then you could also 
simply delete the test completely if it can never be tested reliably.

Thus could you please introduce a helper function is_tcg() that could be 
used to check whether we run under TCG (and not KVM)? I think you could 
check for "linux,kvm" in the "compatible" property in /hypervisor in the 
device tree to see whether we're running in KVM mode or in TCG mode.

>   	report_prefix_pop();
>   }
> diff --git a/powerpc/tm.c b/powerpc/tm.c
> index 6b1ceeb6e..d9e7f455d 100644
> --- a/powerpc/tm.c
> +++ b/powerpc/tm.c
> @@ -133,7 +133,8 @@ int main(int argc, char **argv)
>   		report_skip("TM is not available");
>   		goto done;
>   	}
> -	report(cpus_with_tm == nr_cpus,
> +	/* KVM does not report TM in secondary threads in POWER9 */
> +	report_kfail(true, cpus_with_tm == nr_cpus,
>   	       "TM available in all 'ibm,pa-features' properties");

Could you check the PVR for POWER9 here instead of using "true" as first 
parameter?

  Thomas


