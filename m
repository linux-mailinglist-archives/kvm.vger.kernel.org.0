Return-Path: <kvm+bounces-22203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D3293B827
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 22:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38B93284937
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE2B2139584;
	Wed, 24 Jul 2024 20:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ial28SqH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6847D401
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 20:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721853739; cv=none; b=X5qr57Tsb+JPbXfM9k3lKO3qRxzaZr4XGXFaLGC8GUhP7dzUxdPEd5yaR8lG4fh2dyG5qnuJCBeiwtOVDXkkQ1V8HMzh38SGHlZ60uoPmy/zDalZi7hCoTk7j1KRg04BACR7H1FHcW+bur1FG+PXIU8jaI7FUKGvm2KL88zm5d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721853739; c=relaxed/simple;
	bh=VFIouTgzioPnV8PxR8/n0LUJ2CqqqOt9c1k3KYsJ+RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pf0KrG9z6WX9OD64K8Pt+B92M0WjfqsUoczXBZaKVFgj1mauvnknfMORY2Dus09uhmeTs1akg8UDXjQEnVN62G45lowk3IG6Np1m/ZiVPbwfsxbFJCjBTvuuJ91K21zw7HCJMh3pHhXqSPJA+W2MqjQmR6uXffTgAdiAgFo7NLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ial28SqH; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-24c5ec50da1so11947fac.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 13:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721853736; x=1722458536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SwfIRXOiJ/heI64+FQNlpZPVBndoeV1RDDhZJ9SjarM=;
        b=Ial28SqHYFLrCG9iuiDdtO25WPHoYZVH9wltjdc+WoNWIu0j77cI4Rn7hgHeYqz/s5
         Tl0ufAIfVMuATzHgOLx2RLnLk5StqxboNsrtzlka3/iB4hh5Hdop/UzO8a9lXrbkprlm
         ZuFObHVaeU/+xbASA9+gc7TmrvwzqvMneNMZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721853736; x=1722458536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SwfIRXOiJ/heI64+FQNlpZPVBndoeV1RDDhZJ9SjarM=;
        b=Vx9hWn26NOZCDvlSR/lGnMX2fSuG7xyZp9n/HcNfm6hbuCaxZEMxeHaUFWABbTQ+03
         +QRdUUq30Q3tErwpNQ00AOKecaNbvdVoq/mEuwkpyZCHZ86DXJ/92T5cY0H4DF+nQw84
         RaC5xBHgiEygtlBnWSoy/xen8PhqF8yZ9io2fOm1Dt2bRuesgRnK13DbhVpb/IBgGjNl
         1c5U3xCOX2Fl/hEkUaacLwdkxS0VdgkCr70Ht3nfi+xfTapxVJpyk8o2iycGI8do3IOS
         RSml2eqsfSaYZaU2yY0lS+oMKIwS7Snd1GrluFQe83iqE207J7srfnsZLTiG+4svsqVu
         fEgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb/aXd0KftEaXghd2Sm9bXB1MxNfal3W2x0XLINO3bTZH/5v/itKT9vXu2FSsZcey4msI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCheYW23egLHbABkbYFK2vEwDHKTMyaRGjDwlfHGNJxlmDjE/c
	4TKw3YZAIQnzzO1C1t5r+Dts+hmqNAMSKIXVV9Tkz8mI5df2anejclOgOCp8Ltk=
X-Google-Smtp-Source: AGHT+IFmjQM/tsv5clvcDuEEZcPj/WQfIe3Hmew0qHt87NCUlyPGfYsebGMK7/9TgEQGvEpYbVMdPg==
X-Received: by 2002:a05:6871:e2a3:b0:260:f1c6:2586 with SMTP id 586e51a60fabf-264c4538997mr198897fac.10.1721853736344;
        Wed, 24 Jul 2024 13:42:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f9ec428bsm18707a12.63.2024.07.24.13.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 13:42:15 -0700 (PDT)
Message-ID: <49d2134c-20e2-4042-9d01-9d7ca28af052@linuxfoundation.org>
Date: Wed, 24 Jul 2024 14:42:14 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: Documentation: Fix title underline too short
 warning
To: Chang Yu <marcus.yu.56@gmail.com>, pbonzini@redhat.com
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, chang.yu.56@protonmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <ZqB3lofbzMQh5Q-5@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <ZqB3lofbzMQh5Q-5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 21:40, Chang Yu wrote:
> Fix "WARNING: Title underline too short" by extending title line to the
> proper length.
> 
> Signed-off-by: Chang Yu <marcus.yu.56@gmail.com>
> ---
> Changes in v2:
>   - Fix the format of the subject and the commit message.
> 
> 
>   Documentation/virt/kvm/api.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index fe722c5dada9..a510ce749c3c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6368,7 +6368,7 @@ a single guest_memfd file, but the bound ranges must not overlap).
>   See KVM_SET_USER_MEMORY_REGION2 for additional details.
>   
>   4.143 KVM_PRE_FAULT_MEMORY
> -------------------------
> +---------------------------
>   
>   :Capability: KVM_CAP_PRE_FAULT_MEMORY
>   :Architectures: none

Look good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

