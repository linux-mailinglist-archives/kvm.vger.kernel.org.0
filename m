Return-Path: <kvm+bounces-20953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C1892741A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 12:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30A65B21787
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28E51AB914;
	Thu,  4 Jul 2024 10:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h2Dhtw1L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D49D1D696
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 10:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720089149; cv=none; b=aGp/SH6MyVJtdTy4F0lwaFFSOGhG7/Ux9PdrfBHpk9Riccisw5OqyKhCPmmhLqBJs1BYI/3LKNZUJo2ypVyP6tOMBhsBOzsMceoI5AJQ2YGd2SB63En3Lww9GdbfSHnKhNxcCXx0M8vDgbXLtzmu5sKoySd6JKy9F1ZeWN2hyHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720089149; c=relaxed/simple;
	bh=vS/lSm/su/NLbW7XDF2l6nH3EvMeNhzVg69/SMovFb8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QoHUcGf1A7Gu8LfJ/0/2AKuu0GkJc2upjK0TcDVAuLwJLHAH/Rrk3jlcaSNps9bFCBsgr+IIPWVj1ROvQcynaY6uDc953E8yuQgS+lsRTUARLqmQZqvk74AXabQ3Z9syVc4O3n4PQxkjQ+YaAQ/cg9dOrXP+I+RRCrkqdJFqzxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h2Dhtw1L; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a77c349bb81so6396066b.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 03:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720089146; x=1720693946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ll1789K3RZMo075IXKmdTE4mfwiU9AkaVkKOsPwli5c=;
        b=h2Dhtw1LTzcg38oWYs9SmoNyO8u5GTpYn6k112FmchrETVgsHYdjkTuVcWUm6fnS/K
         YKyMfx8ICoxoPT4lXPFEkOGoSmJl0QcznasriJYUGlakPMYrqFIwGpiNBAxCEBqlwyXR
         32w4zAXSnXGNmFyPtxhP4WtaBt8obggvlprv7v7Ag/WehsqqyYbI3vz8FVgtAt8BTeaq
         0/R6OE8KeqOCd8fX4Xvi1hPd5M2UXQq3YsWsQrzkarSvqjSxuR8KTsSL8WQmVJSEG5Cx
         ek4PgsOSE/XLIn1eFNrY9C1F0S05mV/dR48Y+4LxGX7/jkhbxkhjVB/Gj/q5bCcwu3ve
         pgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720089146; x=1720693946;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ll1789K3RZMo075IXKmdTE4mfwiU9AkaVkKOsPwli5c=;
        b=gEt8g9P+tgjwIhuLvYJaDepM04pehN1p6dmSyrHa3ZolU92YXNco9FbCF2FP5uPOky
         MZUoY1ZNZbpYQaMAhbAeI0J5TCwLFC4ZbDVaAHOS1uxMY0ZTZSeLcOO6gRNDJajyEkps
         cLMorxohUFNHQolwXxnnhNMMJ4E/sWOeU5Fo6emXBsQUNvtifQZYS5eZ07Z25co+6OrZ
         XhTpUvJE3G76KTttYOSPJ7X/mViWFOhqK32Kg+DVJUBJAdATwfPG+7/u/2cwL/Zb9+IR
         fe88hDfoxD80gSJLbNIlauwQuO+dFzeEiQmyrR7tb7wZL4KnbH0tgy21Kuj7Snsx9NBR
         GBjw==
X-Forwarded-Encrypted: i=1; AJvYcCXMJhzQrI+k5EtCY15O6wQT5nVYOAzD6f8FXblvLM5q1n+y+SHyHwJ8o2ubyz7jxhufp8AfqkfBK8/BtZaqgE1iqF8v
X-Gm-Message-State: AOJu0YzG1ymprf0620GaYraipeEYFuGRqr1HSVm4My0NAnSf4Ff24lw6
	bJnFjVFFMt7qNVut4c5L3mDzDdCWxTxpX40YNYhU1+/bBWhsZfNzCcABHchPTTY=
X-Google-Smtp-Source: AGHT+IEUr/k4wsuFFI1HpUUBu37YY6nVBx+aUz1aY2C4uipNzYsojCSOZ6mn0U5wAAIP7oQlfcyt0g==
X-Received: by 2002:a17:907:c25:b0:a6f:51b3:cbbd with SMTP id a640c23a62f3a-a77ba45568amr98177066b.4.1720089145286;
        Thu, 04 Jul 2024 03:32:25 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a77ba8dab57sm35135566b.55.2024.07.04.03.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 03:32:24 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D11015F839;
	Thu,  4 Jul 2024 11:32:23 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>,  pbonzini@redhat.com,
  thuth@redhat.com,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  linux-arm-kernel@lists.infradead.org,  christoffer.dall@arm.com,  Anders
 Roxell <anders.roxell@linaro.org>,  Andrew Jones <andrew.jones@linux.dev>,
  Alexandru Elisei <alexandru.elisei@arm.com>,  Eric Auger
 <eric.auger@redhat.com>,  "open list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU
 introspection test if missing
In-Reply-To: <74e184afbc4b58fba984b91964915a9e@kernel.org> (Marc Zyngier's
	message of "Wed, 03 Jul 2024 08:23:37 +0100")
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
	<20240702163515.1964784-2-alex.bennee@linaro.org>
	<8c11996c-b36d-e560-cdeb-e543ee478a54@huawei.com>
	<74e184afbc4b58fba984b91964915a9e@kernel.org>
Date: Thu, 04 Jul 2024 11:32:23 +0100
Message-ID: <87ed89o3bc.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marc Zyngier <maz@kernel.org> writes:

> On 2024-07-03 08:09, Zenghui Yu wrote:
>> On 2024/7/3 0:35, Alex Benn=C3=A9e wrote:
>>> The test for number of events is not a substitute for properly
>>> checking the feature register. Fix the define and skip if PMUv3 is not
>>> available on the system. This includes emulator such as QEMU which
>>> don't implement PMU counters as a matter of policy.
>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> Cc: Anders Roxell <anders.roxell@linaro.org>
>>> ---
>>>  arm/pmu.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>> index 9ff7a301..66163a40 100644
>>> --- a/arm/pmu.c
>>> +++ b/arm/pmu.c
>>> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool
>>> overflow_at_64bits) {}
>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>>   #define ID_DFR0_PMU_NOTIMPL	0b0000
>>> -#define ID_DFR0_PMU_V3		0b0001
>>> +#define ID_DFR0_PMU_V3		0b0011
>> Why? This is a macro used for AArch64 and DDI0487J.a (D19.2.59, the
>> description of the PMUVer field) says that
>> "0b0001	Performance Monitors Extension, PMUv3 implemented."
>> while 0b0011 is a reserved value.
>
> I think this is a mix of 32bit and 64bit views (ID_DFR0_EL1.PerfMon
> instead of ID_AA64DFR0_EL1.PMUVer), and the whole thing is a mess
> (ID_AA64DFR0_PERFMON_MASK is clearly confused...).
>
> I haven't looked at how this patch fits in the rest of the code
> though.

Doh - yes different set of values for 32 bit.

>
>         M.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

