Return-Path: <kvm+bounces-22825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5257943FC9
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 147C01C21330
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 01:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72A02C6B7;
	Thu,  1 Aug 2024 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUNDpcTt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E992D7A8
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 00:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722473293; cv=none; b=VRy/gFPcZrW5wAlEPrzVAY4ZSZx9aexqzM7ujH0FvChYvJ7zEuoioKCCw1Hjf91Ydy0yRg1j/GQ8vqsseQZNpC4RUAZwN10VhKE1J4AHDERa4XOgynRlU4WnaQRtX97MaXuup5ugJFLSZ7dL8qgdjvNk4zhFbv+1BGPfZftiKCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722473293; c=relaxed/simple;
	bh=5V+7pkjfE2XZiiuBjUTWzLnRrMoiivIoOcezkBx35zY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azpMJndknPZdcHctglsW3TjpWSLOpr418b5ndISXiHlOrpYnKgm0vMlCKrZIPKdtizPP8JmXkksDTl256sx4UCkP35i3F8mS5Lzu7WoSr4KjSlaM1pxGLhueDKONR6BoMQsy1900qL95mIHvyxP/FemlpR1ThvS84FQDD4uNSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eUNDpcTt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722473290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RFQclzW/vuWIgsBJAJ96++9Y/pmxYncNjR7KuXyfSF4=;
	b=eUNDpcTtfdwY8MTSrIy3vXW2Lczd2/chI99X2at6Fcg0G9aqaw1r/bqccg66dtk1+yMXMd
	XqyCoZONt13+btAqkeu4i4RHtkJVP9IfZPoMvprSTrkKW+pvP3sqWHxW2cJhUIVOp5dMIk
	n2G30RlgQpqrv/lvdyC1KQeIVEPoWFs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-GI0obu9gMEaKa7RW5i4Qew-1; Wed, 31 Jul 2024 20:48:09 -0400
X-MC-Unique: GI0obu9gMEaKa7RW5i4Qew-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1d0b29198so689811085a.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 17:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722473289; x=1723078089;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFQclzW/vuWIgsBJAJ96++9Y/pmxYncNjR7KuXyfSF4=;
        b=caNpv/Cbm42ccZMt3WR5Z9xEZJoLo9QXXE/NfS6gpV08wrmfBFf6xFE0vznj0JxPgi
         hzsR33AwRyJkLNeuLlh/bzZMzvtTgpgsy+cc5TFU5sriOOq8ihJT+1bZ7F7yOOTOuSYd
         blTfWndkaHKuw8ysvWUDqATIhm/elxO4DPwQ5hEyDV7BAXNQMi6DSoBKw0MF4KLQbuHr
         Zw/lCrg3Oib2QbdAMiYjYukeYanKm5qvg+v883cQoeoDLXmCE+DP2xDzE2Maq2XJn719
         0+psAmR0UYj27t41OauR2VG6dreCXrMkf5RctVZpUFCCZNLGCyGMROZzuukM7hLinbam
         4wSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAKN2wtljYru9JewygoOPHtvY3Ei+8gDX93hXCujYYlxzlyayHAOBs12apdhJng6VvEuavjhbi4gU1s1njWELkY1bG
X-Gm-Message-State: AOJu0Yz8mTjMTuBazVECcce63+f3x5HkoeMZfw8Qp6JwiujnvLiWKYMU
	T4XB0W+A5XMSql5vcOz1EceCmP8IFhbIZ3+ZeCBgt79ay8nJSmHfgIvJOO2Gvt6iR3kv+LDKp+a
	3PRu83XX5VwJ2Uyp7CXG2fypj96AxNzoVKg6W/vebXsys9ktbow==
X-Received: by 2002:a05:620a:24c1:b0:79f:1e1:faa7 with SMTP id af79cd13be357-7a30c654a9emr124840985a.17.1722473288671;
        Wed, 31 Jul 2024 17:48:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrkwsj+j0FIIhACoKbuelZI3ds0w5Xqfu2eQJH7G5c6HZxlsFtxr6D1099YDkyRiNMJSdm4g==
X-Received: by 2002:a05:620a:24c1:b0:79f:1e1:faa7 with SMTP id af79cd13be357-7a30c654a9emr124838585a.17.1722473288292;
        Wed, 31 Jul 2024 17:48:08 -0700 (PDT)
Received: from [192.168.5.27] ([172.56.119.20])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1e4292ae6sm628776985a.74.2024.07.31.17.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 17:48:07 -0700 (PDT)
Message-ID: <2331dba4-4366-48fd-baaf-a5579df8ab59@redhat.com>
Date: Wed, 31 Jul 2024 20:48:05 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] Bump avocado to 103.0
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
 Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-13-crosa@redhat.com>
 <2d85304c-ccec-43d1-8806-bdf7b861543d@linaro.org>
Content-Language: en-US
From: Cleber Rosa <crosa@redhat.com>
In-Reply-To: <2d85304c-ccec-43d1-8806-bdf7b861543d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/29/24 8:02 AM, Philippe Mathieu-Daudé wrote:
> Does that restore feature parity for macOS developers? Because this
> community has been left behind ignored for over 2 years and already
> looked at alternatives for functional testing.
>

Hi Phillipe,


As early as Avocado 102.0,  macOS support is pretty complete. The exact 
words on the release notes[1] are:


"User of macOS will have a better experience when using Avocado. The 
full set of Avocado’s selftests are now run under macOS on CI. Please be 
advised that macOS is not currently supported at the same level of 
Linux-based operating systems due to the lack of 
contributors/maintainers with access to the needed hardware. If you are 
a user/developer and are willing to contribute to this, please let the 
Avocado team know."


When it comes to the lack of updates, that is a longer discussion 
indeed.  When it comes to alternatives, I don't expect the QEMU project 
to do anything else than what it's in its best interest. As late as this 
can be, please take it for what it's worth.  If it does any good to 
QEMU, please consider it.


Best,

- Cleber.


[1] - https://avocado-framework.readthedocs.io/en/latest/releases/102_0.html


>> Reference: 
>> https://avocado-framework.readthedocs.io/en/103.0/releases/lts/103_0.html
>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>> ---
>>   pythondeps.toml | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/pythondeps.toml b/pythondeps.toml
>> index f6e590fdd8..175cf99241 100644
>> --- a/pythondeps.toml
>> +++ b/pythondeps.toml
>> @@ -30,5 +30,5 @@ sphinx_rtd_theme = { accepted = ">=0.5", installed 
>> = "1.1.1" }
>>   # Note that qemu.git/python/ is always implicitly installed.
>>   # Prefer an LTS version when updating the accepted versions of
>>   # avocado-framework, for example right now the limit is 92.x.
>> -avocado-framework = { accepted = "(>=88.1, <93.0)", installed = 
>> "88.1", canary = "avocado" }
>> +avocado-framework = { accepted = "(>=103.0, <104.0)", installed = 
>> "103.0", canary = "avocado" }
>>   pycdlib = { accepted = ">=1.11.0" }
>


