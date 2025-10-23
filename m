Return-Path: <kvm+bounces-60877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2EAEC003BB
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 11:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6E63A3877
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 09:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966323054EE;
	Thu, 23 Oct 2025 09:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+mp9AS5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13326158C
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761211463; cv=none; b=I7Q+6aupxyspyoii+G5hXJWf+NPn9ItCoKmfML+rG1we6IE7rpnYJKfUkTb+3hQ8SqIu+wh85H0W0wxH25lGuSIy8KHgzLRL/6VipbJm5W/smCRxZt4iOvWijo1FQBONU2MG8P+A6KBiZ8PRy+BabWXODn5zE3c4AdDZ7SLINKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761211463; c=relaxed/simple;
	bh=oyL5+qcOSBNpcw4EVkJ/aBwJWr8pMTGFG5NP98rHpVQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Q7LqwRqqRKmYAJJgixSVKTcxOkxQGaMH/QZf74OBpKkX3E8m60r7nqUKjpvlgADFuxj04byobe21D+XCDUrqrfbw4+3OZsWTciVdXvCi0T15vBwZJKtov21AsRwamTNqE2+REk+06xEX09stBnSn7rUsyBhkI4Gg7MDwuXOTEX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+mp9AS5; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b463f986f80so139127866b.2
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761211460; x=1761816260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wc/vWIbe7zNmH17tpBpu1vmNiEABiUvd2vn+iEYOxDg=;
        b=l+mp9AS5QMuEpU+e4wZc4rvyCCOxfQBfLO7Jhyb1Fi+fODyf84pdv7kVFdaB/NDJKA
         /UDns1yeRlvM/gQntuqGmCuJJRrLDaretGnvHKRmvQ3FMkD4JBEv47KZP2LydBDUvjYw
         +S55zSekMyjNWnGukcjUmXhl0ZLtQD5chMBEGZ8qGkHPeAdjloyLjX6eOmLpneh43HAz
         YukAdGwJSQS064W5COFn45D1gIB36lYkPNwyBUk/6vISD82hBdT3NMh7wI9IB6HR5k2D
         EOqTGPTPUjU6Yd2qIHw1+LEzCufdNykPhQiYxQ2JNH+/J4jj9853XYZ8DNs+0xRr/RTE
         mi3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761211460; x=1761816260;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wc/vWIbe7zNmH17tpBpu1vmNiEABiUvd2vn+iEYOxDg=;
        b=XA3EL/vL3IkORyNSB3ryjFwcRwTUiZjyOwA1xaabkZQ6O/oaiXIAuiCPXvpTl+9Mb3
         ZIqdoqs5HgFMzN6L1rfSU4zo/e0JamMfbfKXzQUA6HBltAh8UbLwH5gsusbhXLe0T5G0
         PNssyGxQadw60F+jvTHDnpYITqGtq9CgVqV4ntPetD45+C8XW+D6OJwuyymrHLK9j6pk
         gmXNXf8jYYQ1LPYprLfUkBZr3Oczurp0CD/egmwYapklkBa87INR2tozZhfp6p8ST0UE
         Qbvs+EbGu/VaEwgMbHrrkGcmU/5va3/20lzzOAKE9QO4x+n8ekyMaCmCa7BT11aC6F0L
         1uBg==
X-Forwarded-Encrypted: i=1; AJvYcCWeW1UV8lrqXLEKOmKDtIl7zSQy8NtYAbHurXgQBuZvCHLGlVGzER7i6Jzq+Ity1bPKWh4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy28AnpBhQ3LqTY2Q4ftnzKMelgxbLBmq3L5rJLsdjq3Cbw9Ho5
	Vra4Wet2BWhjqJjMsM0cfqQyYMzqBiQWjItpChWFjRJ6kzQSIGJWbA7H
X-Gm-Gg: ASbGncvlmHlkHsgVa2HzHYnvg6bLxFq3b08CSS0RxBffzAnzKl8yJ/U8XmF5N8KVVgJ
	zaTJeq4RhlalG0Jg3036BJKwGHwS2nO6akMsxbhYGE3/U+EqodoSIPzg9yjnhztSo2TJusH10EM
	vVXmtcY0xme8YrsXGzyHVTa3H2L1y5FiApx/tIZwKhnEF5vZnQ16WA43XVblQMFS/zVo6bdGnGh
	pJkiiyOcQ2XXJI0p4qimN36JND+qcHcJtSqnE61RNsWKO/8blivMGbuyl/YxsQMvHB1+54ChZKP
	lHtRbaG4uhLq/Irb0iAB/NkkyHkiB1OYGjbu+ExuYMwKZUzXQZxXpUNIkIF2VD2K4lx8UxGCyVV
	sUuzAnjxWAHxBDh2GZgxypgECJxAnxKpFbSly2zjmXJ5ZndE/c7TCmyaxyckxaYeNaRTzftWEk0
	5hyb4xLEkWT9UPzMLjEuoTRGNiquDSxS+MJXuU2jHZ2kQ=
X-Google-Smtp-Source: AGHT+IHU5Gei9CD4nq02yBKhEDZA0JJxDkKkZgFYiynYffZtcnsonISoZsbX4e2VEGaNNDX6TpUBgA==
X-Received: by 2002:a17:907:1b1b:b0:b39:57ab:ec18 with SMTP id a640c23a62f3a-b6d51c2f64amr167997066b.45.1761211460182;
        Thu, 23 Oct 2025 02:24:20 -0700 (PDT)
Received: from ehlo.thunderbird.net (ip-109-41-112-116.web.vodafone.de. [109.41.112.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d012bsm182635966b.7.2025.10.23.02.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 02:24:19 -0700 (PDT)
Date: Thu, 23 Oct 2025 09:23:58 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>
CC: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v7_24/24=5D_whpx=3A_apic=3A_use_non-deprec?=
 =?US-ASCII?Q?ated_APIs_to_control_interrupt_controller_state?=
In-Reply-To: <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
References: <20251016165520.62532-1-mohamed@unpredictable.fr> <20251016165520.62532-25-mohamed@unpredictable.fr> <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org> <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com> <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
Message-ID: <0C41CA0E-C523-4C00-AD07-71F6A7890C0E@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 23=2E Oktober 2025 06:33:18 UTC schrieb "Philippe Mathieu-Daud=C3=A9" <=
philmd@linaro=2Eorg>:
>On 20/10/25 12:27, Bernhard Beschow wrote:
>>=20
>>=20
>> Am 16=2E Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick=
=2Ebouvier@linaro=2Eorg>:
>>> On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>>>> WHvGetVirtualProcessorInterruptControllerState2 and
>>>> WHvSetVirtualProcessorInterruptControllerState2 are
>>>> deprecated since Windows 10 version 2004=2E
>>>>=20
>>>> Use the non-deprecated WHvGetVirtualProcessorState and
>>>> WHvSetVirtualProcessorState when available=2E
>>>>=20
>>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable=2Efr>
>>>> ---
>>>>    include/system/whpx-internal=2Eh |  9 +++++++
>>>>    target/i386/whpx/whpx-apic=2Ec   | 46 +++++++++++++++++++++++++---=
------
>>>>    2 files changed, 43 insertions(+), 12 deletions(-)
>>>=20
>>> Reviewed-by: Pierrick Bouvier <pierrick=2Ebouvier@linaro=2Eorg>
>>=20
>> Couldn't we merge this patch already until the rest of the series is fi=
gured out?
>
>OK if you provide your Tested-by tag (:

Oh, I did for an older version of the series w/o this patch: <https://lore=
=2Ekernel=2Eorg/qemu-devel/5758AEBA-9E33-4DCA-9B08-0AF91FD03B0E@gmail=2Ecom=
/>

I'll retest=2E

Best regards,
Bernhard

