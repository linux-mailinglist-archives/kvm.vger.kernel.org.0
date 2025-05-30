Return-Path: <kvm+bounces-48121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A9AAC962E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 21:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40F1FA20458
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 19:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B5127CCF2;
	Fri, 30 May 2025 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YczEaYC1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23D826F461
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 19:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748634256; cv=none; b=RPrYqdxoBTu/fqoaSnJjXabpGkf/QH3owTJuxfwGUOu3FQfctRcwcuIWHgvcEXvJWx0fk1EmKXuad55x2oV90Pn2nLM7uQ/FEjMnaYxs+1T0abwOuZy4+4A3Nu4/VS4FYkxv0pfGGIxBhzkIpTXSpacTsxTuBYa6AK30djo/7aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748634256; c=relaxed/simple;
	bh=oNUxAqiIERM1ixZom4CABLQ6R42AZAYfillFy57IOyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b21Aghi+Qr4cjhI0mQMv8tMClZWAm93/ZHFhgg4fQNLnfiLVtwL1yyPmMHNLc17yzVt254GfVvuPoZ7oTVStAU673I7q4hHsGxDtIFfOmCMwW1A4GadrSnKWismocyouCQn8pi1Fs/VWqoCMGM5jV4BAwdffltzOEAJxhBxBVkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YczEaYC1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748634253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XVMMDq/i9mPb9hw3hbmTldOmiaSNRmJmSEUQ9+dOxxE=;
	b=YczEaYC16a/G/6prQV8ZtbHa9hJWmXNln4XBFyBUGl37ebR9bT9I8JDuZZIWC87jHpNR7G
	ZawCddOADNF/bA5uD04tcnycb73kENv70JTDdDvKqueYo15RC+2+hOfGj0h7SSy8G997BN
	w7c2Eewh/eutOlWfOHA0aQPALzeZP8U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-8lYpSgI7N3y3jyXWpli4TQ-1; Fri, 30 May 2025 15:44:11 -0400
X-MC-Unique: 8lYpSgI7N3y3jyXWpli4TQ-1
X-Mimecast-MFC-AGG-ID: 8lYpSgI7N3y3jyXWpli4TQ_1748634251
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-605a2dab6b8so305897a12.2
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 12:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748634250; x=1749239050;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVMMDq/i9mPb9hw3hbmTldOmiaSNRmJmSEUQ9+dOxxE=;
        b=Aldy0ogVNRFTDXh9lGoS40LLzZM9u2ByDEvk6AF35LnKynu8QBlu5mK1KV+nOIPgqL
         62Tgb1E+xa/Otd4K4ABLgiAeLAvAirQjxaPjDlpepvutDcwNKGRPUdWG3BflirOMvHeU
         uQ+wUuzCQaHawHy0Am2UnfYhn3mHYJ9CUSYr9sos/7UKhYJFQgIhhN6D4WMmiGpvnIiK
         1XKRv4FDDWNVNmBi/smabC8b9igtjhUle/URh9gCwR1tlc2xEuWttlmIs9ymK8wCM974
         gnwv2ALT6TUML4QY52dhxOXx/93syscM69bc6IC2ODXeXGZ4c7U5zMcN/N8ul6iSo+Zj
         a9bw==
X-Gm-Message-State: AOJu0YwYvpKxn0XM95DmOJVL4wqA3f786yd3+E5Cs3Py+1FYPpGMYQtT
	WKRvayK9cnRqicObFH+WYinWvyYRRLO9QQYY3IM2L0TCYxAzmm7/875U5Soxb/lQK1QALjGLyZg
	xELU/sIbuub3ZI/XNiBQFIfviGTGhHiJHQ664cs0p0RoHz4n7o7CxTg==
X-Gm-Gg: ASbGncuR/veDuvJ7KciDY7iMtQXpdqXLz3gxPXafe/W+i+ygj5VA9vB8PLpeCMvjgx8
	Bp2V2tmXlj/4SaUygodRZFMVcZp6JTHLlnlIvku+RNWhvDbrIsBVQTEa3qTSMarv8lqxBHOudRi
	bwWd4LlCKhzLdZSUb9c8+TaQ+JCPi9R/oGtTxuEBMN1058dIi/uAIOP696iqTC55bw+NK6S7n4K
	RM/npe4Cs6WILI8LrQifutp7Wf3FDNIY9vsYl3pGUytBVdRP/prrcwdQgi0/rdyWL4PHbD3qvTe
	Cixf1EOSAkPfi+4ksKcPQMCKPwTbHvrWeGFY30CX5Tm8KtXjQ329Uto/peOnW3Y=
X-Received: by 2002:a05:6402:2811:b0:5ff:f72e:f494 with SMTP id 4fb4d7f45d1cf-6057c63cae7mr3239387a12.31.1748634249642;
        Fri, 30 May 2025 12:44:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk4D8hDp4cKoczBgWeubJwTqnctNQdGTAcE/pvA30+nmmu+zu8uyt5dvX9NbUpT+z5nt+STQ==
X-Received: by 2002:a05:6402:2811:b0:5ff:f72e:f494 with SMTP id 4fb4d7f45d1cf-6057c63cae7mr3239375a12.31.1748634249288;
        Fri, 30 May 2025 12:44:09 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-112-237.pools.arcor-ip.net. [47.64.112.237])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60566c5b6e9sm2123231a12.23.2025.05.30.12.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 12:44:08 -0700 (PDT)
Message-ID: <7d1d7262-0b59-4432-b75e-3c411a8d7e1c@redhat.com>
Date: Fri, 30 May 2025 21:44:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Remove the aarch64 job
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20250530115214.187348-1-thuth@redhat.com>
 <20250530-61a88b355b5b9621a26f7e1f@orel>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250530-61a88b355b5b9621a26f7e1f@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/05/2025 18.39, Andrew Jones wrote:
> On Fri, May 30, 2025 at 01:52:14PM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> According to:
>>
>>   https://docs.travis-ci.com/user/billing-overview/#partner-queue-solution
>>
>> only s390x and ppc64le are still part of the free OSS tier in Travis.
>> aarch64 has been removed sometime during the last year. Thus remove
>> the aarch64 job from our .travis.yml file now to avoid that someone
>> burns non-OSS CI credits with this job by accident now.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   .travis.yml | 10 ----------
>>   1 file changed, 10 deletions(-)
>>
>> diff --git a/.travis.yml b/.travis.yml
>> index 99d55c5f..799a186b 100644
>> --- a/.travis.yml
>> +++ b/.travis.yml
>> @@ -8,16 +8,6 @@ git:
>>   jobs:
>>     include:
>>   
>> -    - arch: arm64
>> -      addons:
>> -        apt_packages: qemu-system-aarch64
>> -      env:
>> -      - CONFIG="--arch=arm64 --cc=clang"
>> -      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi
>> -          pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr
>> -          selftest-setup selftest-smp selftest-vectors-kernel
>> -          selftest-vectors-user timer"
>> -
>>       - arch: ppc64le
>>         addons:
>>           apt_packages: clang qemu-system-ppc
>> -- 
>> 2.49.0
>>
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> 
> With gitlab-ci, I'm not even sure who still looks at Travis, so maybe
> nobody will notice that arm64 is getting dropped...

I guess I'm currently the only one who's using it ... so far, it was still a 
nice way to test automatically on non-x86 hosts, but seems like these 
options are also removed again bit by bit ... let's see how long ppc64le and 
s390x still survive there...

  Thomas


