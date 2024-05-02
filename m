Return-Path: <kvm+bounces-16401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE948B966D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E9E61F23D37
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2C23D0D5;
	Thu,  2 May 2024 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxQo0RfF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DAF374FE
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 08:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714638438; cv=none; b=Evp64Tm9AsNtxKOJpG3ty+owtPEgi0uQtlN1ewhpOSfNnerN178KW3BfH3aWZ+lgnJMYoutUHSRvCax88ksasOSO9kIgrwyHTWqJ4pn85B+Bz7ZcHRyOepX3RREFYe9dsc4+Qx3cWFB3W9oIybRSqvrVYZjsTQ1+9xK+8gdLd0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714638438; c=relaxed/simple;
	bh=FNXL0Woy+SYHpnjVTDLsJudP5ULn+c2OFLWpMeinOBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FCPbnE4aZuWQkN1ScMVaDwwOWBAffjyuKVJvq5P7cdrCBlAFcPZZyF2wm3+/seGeZGTqJblSqzEZx4KLH/Ttan/rVgSvH97XWR1xFG7v65AhhEsHlqA+5c5Ci2E09bs54VR2GNJhhqAaOH43i+Xv2Ui4wDeMGJNx50Z8B59csaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxQo0RfF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714638436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p7ndgmJ4Q5mTTz6lBU7yUmLHmngiXphC0GSqdbIKWyA=;
	b=DxQo0RfF6546dkNrk/a5KtLgDgE3kBwSGmyOqTyPz2Cjvsevo3Nr56gAQPEyUoWG61udKM
	3y1zpgmyy36CG9ekllFlEjy72FGSIxLDnYqlSg5NhOaC9gwH7KAiXoLZhZ03gjLW0hSOFm
	Y1qZp4hWPY8NJL8/xTWh2Vhd3eWECrs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-noJpu2rXP_mpyotrznHeVg-1; Thu, 02 May 2024 04:27:14 -0400
X-MC-Unique: noJpu2rXP_mpyotrznHeVg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-439846258c4so96953591cf.1
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 01:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714638434; x=1715243234;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7ndgmJ4Q5mTTz6lBU7yUmLHmngiXphC0GSqdbIKWyA=;
        b=gSQUcZji09hXLflZM1jF6W/UPIPKhiGF0dFiaxGCHKkKNZmQ1490Lf0H8zvsknYSDR
         WxpAHRlsYIdRClCmbWRmQFcRddRHpT3UR9dIXcjICMpJRY2dsD+B1ERk/lk69aCfMFn6
         zTjIpZkkFKL6p/HemqSRInIBDBmnJcwSpQXCaeodtivpEMvcG1z0mn12tR5ekgVTpwqw
         NOW1vRjzwJ5A9M+b2BHyu2sY9J+Vo2SIhIsDU+4FV7sEAoP6ueT5/USpLEQiNhm1kOXQ
         5JA1T6uaagahi34a3oiJ7QwiXHg66PD3iG3xDUppei9fP6LzXv1GezolM/eoa1QVZOBq
         FUGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQDqwyVz9vCQkjbmChsqB7H1PhcsAt1mm1GKWWpcXS1kFuh/BD07VQy7PQ+AbaEv8quRJcL2HJmiA/qOEyWVqBfuo6
X-Gm-Message-State: AOJu0YzKYXgD+vzWzLAIKjfc+u721QxDnSwyeLYyj9YXO1irlDZiL+z1
	mQ0VeDPungvkGz/zrtJ9/LFmx+v0Hr2AvQ2mKIE2EeTDeoe2VVTFh8zIXudiGgZc047zmRTgRAy
	6tDNrrlC4MsJfzKFcWR3Vb+GuHwh8N/86kdg5l4HxJurgFJqzLA==
X-Received: by 2002:a05:622a:13cd:b0:43b:8bd:6a7a with SMTP id p13-20020a05622a13cd00b0043b08bd6a7amr5098266qtk.2.1714638434279;
        Thu, 02 May 2024 01:27:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaKNE4eUpMSVylcHqjThnkOpY7zsQJCBrbK4j5VlAKy3wezcr+k4NxglNLjqlgTgYpou2oxg==
X-Received: by 2002:a05:622a:13cd:b0:43b:8bd:6a7a with SMTP id p13-20020a05622a13cd00b0043b08bd6a7amr5098246qtk.2.1714638433763;
        Thu, 02 May 2024 01:27:13 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id bn4-20020a05622a1dc400b004378ec294f9sm261050qtb.72.2024.05.02.01.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 01:27:13 -0700 (PDT)
Message-ID: <bc766ea7-22de-4fc5-9790-1b2d67e39974@redhat.com>
Date: Thu, 2 May 2024 10:27:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] runtime: Adjust probe_maxsmp for older
 QEMU
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, pbonzini@redhat.com
References: <20240502080934.277507-2-andrew.jones@linux.dev>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240502080934.277507-2-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/2024 10.09, Andrew Jones wrote:
> probe_maxsmp is really just for Arm and for older QEMU which doesn't
> default to gicv3. So, even though later QEMU has a new error message
> format, we want to be able to parse the old error message format in
> order to use --probe-maxsmp when necessary. Adjust the parsing so it
> can handle both the old and new formats.
> 
> Fixes: 5dd20ec76ea6 ("runtime: Update MAX_SMP probe")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   scripts/runtime.bash | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index e7af9bda953a..fd16fd4cfa25 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -204,8 +204,10 @@ function probe_maxsmp()
>   {
>   	local smp
>   
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
>   		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
>   		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
>   		MAX_SMP=$smp
>   	fi

Reviewed-by: Thomas Huth <thuth@redhat.com>


