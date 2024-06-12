Return-Path: <kvm+bounces-19432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC1790506D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F223F1F23129
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6B216EBE6;
	Wed, 12 Jun 2024 10:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iStnx/NX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D7C1C6AE
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718188336; cv=none; b=lsSq+RxEZHSvTtxwbXgxLJYcLZNv0A6Dy4eBpL2jJ8nSwupLn/I/oKMi56t93llGzFeovuukcN2+7tpaMlNaKDuuIJYwVuDSbEpLBh3YoiUQfl3L8yM8xAdJLAthoHlhYCHNu5d+aFAEUbKLYI9TjOpAJVR03bAUkNcMn8kLBMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718188336; c=relaxed/simple;
	bh=RJOuGzUDz6GiaWaWds0kqjNdNympIykUXnU8SI5ODMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzHpf8ZIAmOjTVNrFD+44XSOgOiUz2va4p8UMJ6VZu6ovxNpzxq7PPIqcJCBAbKzjg5OhH3k3sLQC7BlmBkXtjNHyDwyDd2lAcxHxdxGpO9CEH+FwEJrn3m4JMNykz7sTbBCJ547Ac1TI/h6E87oYtUTbBH0yzEM02WSLxBsrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iStnx/NX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718188334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Xk4Ph2OIUlpFb1LCpnRhSDu6OaIUiqefP2RNDbhPaog=;
	b=iStnx/NXFi/pKNczWZ+vDJdhSu/D9I4bU+mC3QngOBP3g06aTbqskMQOSO077el6yo3U4y
	GWQN5csuDd285xxkSorgk0saeFQqdfEmOujGBsXt1LV/thU9e7vHpzdo/EFyHPhxKrt24f
	91LFVKs6CqJSH0QLcMh8eBSEcjRdXio=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-DwpdW_6zOdSqCS5WcpVU1w-1; Wed, 12 Jun 2024 06:32:12 -0400
X-MC-Unique: DwpdW_6zOdSqCS5WcpVU1w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42108822a8eso3928605e9.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 03:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718188331; x=1718793131;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xk4Ph2OIUlpFb1LCpnRhSDu6OaIUiqefP2RNDbhPaog=;
        b=DRVKLvsQlMH1DV8iT3lde+ytKJprePHARBsOYhK+crf1pqCq4FXr3nLcbMqg4Y0Hxs
         5yKDUlC/ftuAk9LOSAm32cH0PiUafn7Ht3nToQrhWLDHApe/mUaZXgC7Sv2GjMFt8JPz
         EIy+TV+YJIbVXxGTJxOnQOlolT1c9XxcJ9SzVPSejc4OvnirAtTo5nXDyg00vhr8jwYB
         MQ6Bf4QOVDAUw6DWGBx4qxkKvbr9ZZ86PjC7goEPPUzXCjwklsVjzUhbxDx4R6GuTeFi
         nuRP8UYzBHH8Rl3GZQ274sI3IKEMmarumnG/hpnjjWpO0A/RC8/cFpXvNyYz9nNPxXFX
         OTEw==
X-Gm-Message-State: AOJu0Yx29ZJnNMX8ijTPNp1ARW6rYifRFIjRHQRefscu8motH42TlgHa
	8cMJYuS/iOTnp9ykzsTc8HQtuWUWNKv/nx8GRfcta31djOXPfHn1TDIvgahnn1WmTLPSx+tQYEa
	HZvtcfokep1YXPYeihuw99PxHRRhgUCFErs5xc68H81Rth/8RxysHnkZAzw==
X-Received: by 2002:a05:600c:3ba5:b0:421:7dc3:9a15 with SMTP id 5b1f17b1804b1-4223c53b3dcmr52772745e9.11.1718188331539;
        Wed, 12 Jun 2024 03:32:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHlPbpcvE5QF7ZmnpWhp/eayJK6IKXHYAMvreeKwvOzWgFit3EioTrinNEEmrozxhletdx5g==
X-Received: by 2002:a05:600c:3ba5:b0:421:7dc3:9a15 with SMTP id 5b1f17b1804b1-4223c53b3dcmr52772485e9.11.1718188331187;
        Wed, 12 Jun 2024 03:32:11 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-68.web.vodafone.de. [109.43.176.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286ff387csm20583335e9.12.2024.06.12.03.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 03:32:10 -0700 (PDT)
Message-ID: <36a997ac-324f-4fd9-9607-d81bd378be33@redhat.com>
Date: Wed, 12 Jun 2024 12:32:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
 <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
 <20240603-20454ab2bca28b2a4b119db6@orel>
 <D1RNX51NOJV5.31CE9AGI74SKP@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D1RNX51NOJV5.31CE9AGI74SKP@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/06/2024 02.38, Nicholas Piggin wrote:
> On Mon Jun 3, 2024 at 6:56 PM AEST, Andrew Jones wrote:
>> On Mon, Jun 03, 2024 at 10:26:50AM GMT, Thomas Huth wrote:
>>> On 02/06/2024 14.25, Nicholas Piggin wrote:
>>>> Unless make V=1 is specified, silence make recipe echoing and print
>>>> an abbreviated line for major build steps.
>>>>
>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>> ---
>>>>    Makefile                | 14 ++++++++++++++
>>>>    arm/Makefile.common     |  7 +++++++
>>>>    powerpc/Makefile.common | 11 +++++++----
>>>>    riscv/Makefile          |  5 +++++
>>>>    s390x/Makefile          | 18 +++++++++++++++++-
>>>>    scripts/mkstandalone.sh |  2 +-
>>>>    x86/Makefile.common     |  5 +++++
>>>>    7 files changed, 56 insertions(+), 6 deletions(-)
>>>
>>> The short lines look superfluous in verbose mode, e.g.:
>>>
>>>   [OBJCOPY] s390x/memory-verify.bin
>>> objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin
>>>
>>> Could we somehow suppress the echo lines in verbose mode, please?
>>>
>>> For example in the SLOF project, it's done like this:
>>>
>>> https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=heads#L48
>>>
>>> By putting the logic into $CC and friends, you also don't have to add
>>> "@echo" statements all over the place.
>>
>> And I presume make will treat the printing and compiling as one unit, so
>> parallel builds still get the summary above the error messages when
>> compilation fails. The way this patch is now a parallel build may show
>> the summary for the last successful build and then error messages for
>> a build that hasn't output its summary yet, which can be confusing.
>>
>> So I agree that something more like SLOF's approach would be better.
> 
> Hmm... kbuild type commands is a pretty big patch. I like it though.
> Thoughts?

Looks pretty complex to me ... do we really need this complexity in the 
k-u-t? If not, I think I'd rather prefer to go with a more simple approach 
like the one from SLOF.

  Thomas



