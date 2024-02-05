Return-Path: <kvm+bounces-7998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E813A849999
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 730B81F24FBF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A131A1AAD3;
	Mon,  5 Feb 2024 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="azN/bIGF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376AA1CAAF
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707134673; cv=none; b=FxqUvmko4d3b/jmop3V+cluETBT8a5mObNk6jeG2s4on3YAnwfDL3Cnwod6J5rhwrk+Dv7aQl+zL66Ze+7Db4nbrhsCm9EzbVnwITz5sOEGorsgBhXXYuulZ1VzAjkjF/2nwjkZ0y3Dho4wsJ4zkcCfdETdRxq6ygUK2ObIqzpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707134673; c=relaxed/simple;
	bh=/ZRVuwJy3SQg04PlHWv//6vnnJxL7IiiSWt79kk2oxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GleXuNbRQY04RcBQ48C5W4Oz6DvKd9oqc3cGD6P+7LVrOgYuSUUPYAIFe/4m3jy1gVOnJloF16U1WZnj6U5qYd8JBu2a7UUqSz0RPSZRTjLtEUfvX0Tnv8U/8tUmLErbc/2iSDJv4jx4v5MZpmYIvm4ecmoUUDpidPbOLyNwtCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=azN/bIGF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707134670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cgWqZ/ywcH/fgEspFo/6QfPQCVxD3Q8p3yiG7wvUpz8=;
	b=azN/bIGFqsbpMh8Q8ycGMBhoRqvSqXaGlHPyBScfA46dEtB4hNxAwAIdtnRYuMEGOsernc
	dbRrSeY8b/iK6GzuJv2Fhd1UtdmKpBnRRbPfqK9I4PVNpgZbJBpk53JpSapyz37p2ik+r/
	t8oz0bE2igE3z6GDhkxwGwoFqb4USqI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-Hu8kbNXDMReh2v1bfkhDug-1; Mon, 05 Feb 2024 07:04:29 -0500
X-MC-Unique: Hu8kbNXDMReh2v1bfkhDug-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-68c7c5f300eso37894616d6.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 04:04:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707134669; x=1707739469;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cgWqZ/ywcH/fgEspFo/6QfPQCVxD3Q8p3yiG7wvUpz8=;
        b=eshe5/mX2Lbh7Fiw0PxvL663hINUU8lHcIrHkFz/30h9wC9VH1p4HYzyoARMTO/0kT
         vCLqpiMRQR3ACcvgY+cbeXiL8HBtzgRtcbT+aVXX6da7QCzxZx9+uJhKnTbt4iFHNssM
         lAo+2dDhsmkY/RpDFVr6VNMFzbOdSUThSdn3dSdKg+xEyVsh71j0W3fc9qo5P2ETfkf9
         J0nCq60SOE1hK62kXix3hE3gqOC8QcSvHnQGmpnZD7E2LwHT9pq+NTR2ZCGNXuJOg+xn
         Cp8QhY4VL4PiJg9ik+FYdVMRx/cv2wWy3GyMIPXNKUY4Jtl7LiuhFyJtUhRtvAz/z1ne
         Ex5A==
X-Gm-Message-State: AOJu0YzXEiNmD7RLTIFj95X89E9xY6RdB3CrDHNyhRLrSMiBBPxPz7BE
	UFHpj/MB+EJ4aGU3x8yYaGFBWJEv1vzh+TISkoOC74OOHExaxUbkx0+ySUBA9jOb2WJ0inW4uS3
	cpwWtkLiM3JiPtiVUrao9nk3/xT8bK+qw6HAX8mnw6+Lz/8GvJA==
X-Received: by 2002:a05:6214:5b0a:b0:68c:a02f:6079 with SMTP id ma10-20020a0562145b0a00b0068ca02f6079mr3441777qvb.29.1707134669270;
        Mon, 05 Feb 2024 04:04:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPoF8GgytGAV7N3xAL+dT9T6XQARIMDQXTEMpFPk8uuMyJ8vK0fkwLF4enOo9ZVfzxOqwKoQ==
X-Received: by 2002:a05:6214:5b0a:b0:68c:a02f:6079 with SMTP id ma10-20020a0562145b0a00b0068ca02f6079mr3441756qvb.29.1707134669050;
        Mon, 05 Feb 2024 04:04:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXmNidbUr0VtZ+6lzieCSIr/XlWKYGObahx4H5SEyWGq0u3Bb88mwSofTvDj6AAJNq+L4A7/2+Q2jCyGj/5T4McG2F7oHatZV/4mqxMUOl+55b0IXAnwYNCFHiZQIJaoOx4UB/5Tr+GbUq28A9lZCKKanKIfLyGg226L7Vbk2c4OlYqA3ClH79NbeHj3m+5qHyTIlX9eQIOoXWH9+7zjHYDI4EHL7Wqrn4vJM0KUfnYpZwJg2vdncFMOtTVhOr8YgxdP5G1wHWg2hGa0yJZt5HMXbkpga8BEsIUfIiF+PqEO/u89tBgFAETOL+nLrBmuu/9fUTjYCociI0dyVtaHl/PCl3lbpiI4f9nUj3zlYhNpDg06e5dXpdPKmE+q4Y45sFSdvBwMsl2g5XAoxVD86cgRaMY9BzZGZRQi8tsoIEVLi1s0JvlwR2hY9oE0NDiiG5nnPRwIBTUEeHvN7FvYl5Ex4NK4u0eoUm24JVSj6pixjtYR74=
Received: from [192.168.0.9] (ip-109-43-177-196.web.vodafone.de. [109.43.177.196])
        by smtp.gmail.com with ESMTPSA id ql4-20020a056214540400b0068c95ebd14csm2194205qvb.2.2024.02.05.04.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:04:28 -0800 (PST)
Message-ID: <cc1b4733-9a6f-4bb6-b8e6-1a6a8807b317@redhat.com>
Date: Mon, 5 Feb 2024 13:04:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 3/9] arch-run: Clean up initrd cleanup
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
 <20240202065740.68643-4-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240202065740.68643-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/02/2024 07.57, Nicholas Piggin wrote:
> Rather than put a big script into the trap handler, have it call
> a function.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index f22ead6f..cc7da7c5 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -271,10 +271,20 @@ search_qemu_binary ()
>   	export PATH=$save_path
>   }
>   
> +initrd_cleanup ()
> +{
> +	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
> +		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
> +	else
> +		unset KVM_UNIT_TESTS_ENV
> +		unset KVM_UNIT_TESTS_ENV_OLD
> +	fi
> +}
> +
>   initrd_create ()
>   {
>   	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
> -		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
> +		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
>

Why don't you move the 'rm -f $KVM_UNIT_TESTS_ENV' into the initrd_cleanup() 
function, too? ... that would IMHO make more sense for a function that is 
called *_cleanup() ?

  Thomas



