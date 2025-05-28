Return-Path: <kvm+bounces-47870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B570AC6669
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DFF84E3B90
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB082797A3;
	Wed, 28 May 2025 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DD8EpSvD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3625F279791
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426145; cv=none; b=i5Ew1WwlIWCNM9/dQz/VjyyxNw3uOrbfvf1g3JCUP9HvgJlVE8ZSHAYjTENBQspa0eqalyEUd2mt2iLVDGKgNGR1xGwH8mc0P9p/SS/wSmylKh0pObajd9NAohbrtygbgeIaqRjofZczgZmvaOqnXWWWWmYMCxOxALoeQqsRrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426145; c=relaxed/simple;
	bh=Bq9NnJQCLieTHo46SHCR/l5w8PJhavGssYMF/tD3KAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHXaAx6rvRldh1fUcECsTGPvTFMkjtR1OiflWM4gsWarFXcPtF6iVNtXzKUGlDqKFwaOlfr9gPb5OcWLL2iWoRVfDif/7ZHo7djmMtzz6lO8IRZOyDll2aM2dMVjuCANl5weeAQypIFXWiTECCOG325TeBbODXprAFKlOaycYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DD8EpSvD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748426143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/cht4wxLcFIV4a9YvAsqXFOunCOP/XdOXqc3a31CrSY=;
	b=DD8EpSvDZVD1OkaY3BQjmrnupZnX5t4EfPTydjLHdQ3msTtdh6HA+51P56hjby/DDzrbV0
	iEk1m2oOPt0FZzyx7s/4HXHlqhQ5oyShAXdOnnSrzGtNtpDHtG7HOUB1BYL/+sFBcY7VVY
	k9y4UMSu160G5hwjXF4prDJNhHftl/I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-6P_s7WsaN1-zd35sww3LwQ-1; Wed, 28 May 2025 05:55:41 -0400
X-MC-Unique: 6P_s7WsaN1-zd35sww3LwQ-1
X-Mimecast-MFC-AGG-ID: 6P_s7WsaN1-zd35sww3LwQ_1748426140
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-44059976a1fso20923045e9.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 02:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748426139; x=1749030939;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/cht4wxLcFIV4a9YvAsqXFOunCOP/XdOXqc3a31CrSY=;
        b=rIwuhLHcHc/iO3av6NiYMwKbDPUvbuFjTal24TZdZQ0Gfi25kkKAfXxmD8dTmJaqzL
         vJegWWelCuaofn96a5XscIQOdADDrHrgw11bOc70HxKhTYJUqK+T2wYxjzEcmPREk0+/
         LfDP6iFTuwfoHSm5pfyi29k1HWUTPWNIjk9q4iA2MYPolw5sLS73vJA3Hs4uEVKnaRtW
         IQXtkpAaR1U7Hyk/pv/zYgiZxXdlmOei+VGRB3+k0wFbcHLPEgW7jgW6fd57QFCK9V3v
         J+dO2ommqik8xq0rkGdddj4z2oB6N49mr5lbeXlwzDy8V7BjPd/8KTUa8Ck/QpMT4gzz
         tcvg==
X-Forwarded-Encrypted: i=1; AJvYcCVm3zxuwlo8JG9khrZtuDXwUEQOTuYFMRk25XKt3iE1uxRQEr2OEdkbnfYRTtRXPY1OJzo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5mywImHB/3hBK/T9ud03c+7bfIiyHFM20XD9jCHbN+LAxibKp
	9pwlQNbgjmU0eWPDCYtXkbOC4YdENNlqwdnLzGOu3CR62Yp4T3z/84an8eo62C46Df8pOP3F3ku
	3NHs2LygWUKz68rGkuIN8i8z87Oizd614imAKc35GVvSlyxfPjlJu9pC/9WvCoIKD
X-Gm-Gg: ASbGncvhFXIafqA3Nbjskrh6x0pGsH+aRlKIABiFKPOf5hGtpTF5GV1GmLjL91n4Rq5
	EooVAqDAXdFSyTNyZdDzG6DUHO9ZWsYdl07yqvoRl01RuS7ek8oNWIfTNBUEFoeXaLABaV0Gc9O
	UnnSFSJt6mHpA1UsdnKShAg+WqtgOU1efgKGeMUJSQUeYkKGPkuRVqiZYD3Shpsgr87ScAZb1ei
	jcoD7cD6Q5Z+XUXU/TfRt7r4yR1vqcJHj82mokw6DN/UcoG6PYDd7MoHkKgZBtoS/u1t+tTLxiO
	oy2aOHcDD5G5j/o/lxcOdN8mvjcL+iawyyWqLjAOZ6IipxsfMffQ
X-Received: by 2002:a05:600c:810e:b0:445:1984:2479 with SMTP id 5b1f17b1804b1-45072545a3emr12228225e9.5.1748426139590;
        Wed, 28 May 2025 02:55:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/QDqORs/FPU6I7L8M2SGEUxj+I4km9Pmeldlp+XFogLbVFnrfaEvD1plPhMd3uKqoFlhGrw==
X-Received: by 2002:a05:600c:810e:b0:445:1984:2479 with SMTP id 5b1f17b1804b1-45072545a3emr12227925e9.5.1748426139154;
        Wed, 28 May 2025 02:55:39 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-112-237.pools.arcor-ip.net. [47.64.112.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4eac6e6cbsm1024110f8f.15.2025.05.28.02.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 02:55:38 -0700 (PDT)
Message-ID: <411a5e54-e9c4-4b97-8467-38f371bfd9d5@redhat.com>
Date: Wed, 28 May 2025 11:55:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv
 environments
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, david@redhat.com,
 nrb@linux.ibm.com
References: <20250528091412.19483-1-frankja@linux.ibm.com>
 <20250528091412.19483-2-frankja@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250528091412.19483-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/05/2025 11.13, Janosch Frank wrote:
> Diag10 isn't supported under either of these environments so let's
> make sure that the test bails out accordingly.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/diag10.c      | 15 +++++++++++++++
>   s390x/unittests.cfg |  1 +
>   2 files changed, 16 insertions(+)
> 
> diff --git a/s390x/diag10.c b/s390x/diag10.c
> index 579a7a5d..00725f58 100644
> --- a/s390x/diag10.c
> +++ b/s390x/diag10.c
> @@ -9,6 +9,8 @@
>    */
>   
>   #include <libcflat.h>
> +#include <uv.h>
> +#include <hardware.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/interrupt.h>
>   #include <asm/page.h>
> @@ -95,8 +97,21 @@ static void test_priv(void)
>   int main(void)
>   {
>   	report_prefix_push("diag10");
> +
> +	if (host_is_tcg()) {
> +		report_skip("Test unsupported under TCG");
> +		goto out;
> +	}
> +	if (uv_os_is_guest()) {
> +		report_skip("Test unsupported under PV");
> +		goto out;
> +	}
> +
>   	test_prefix();
>   	test_params();
>   	test_priv();

Would it make sense to run test_priv() at least for TCG/PV, too?

  Thomas


