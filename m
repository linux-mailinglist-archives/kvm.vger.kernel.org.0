Return-Path: <kvm+bounces-60515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BAABF124B
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 14:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8122423F43
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7F2311C3A;
	Mon, 20 Oct 2025 12:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHQeSB40"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD713304967
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 12:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760962763; cv=none; b=t+M7kfTw1La+KNhyhikYaXJiBVWJOzRkB2k7XEfu7OA1iMkwXc4x0XlNgYDseslRQRpNFN2mLBbCTh1ikXYqGsrELmTC99mWJJRinjXWribZF6wcV5u7zHOWQES3xHxI2yz+4u/7ihU6Lk+Dqy9OyeTamVVwJn4xcAXKDtQh420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760962763; c=relaxed/simple;
	bh=hY+zN89xlI7lc9RRHt5oYwxs5QpVRwojNlKfwv12jR0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=iFpQAQLZKQprcgHTzGn2ll2apo7ztrze2kC9+FT3QWiFMyj7IgABDRHyNUfT+j0C+vpAjYjEZBKix8AcFFlj2h9o+PqV7w3Dpa11N6pW4xbVIqmnTjMbZ18R/D/mULUz9PYxyKq0B52/yKa4dgTgn6G+HWY6lFQV5Yk40xeYK/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHQeSB40; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3d50882cc2so818048466b.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 05:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760962760; x=1761567560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kT0j/s0XBuP0ITAjNCV5ZQF3F9LmCWWFhKV3gfp9k/0=;
        b=SHQeSB40mJHfY6q8RyBDkUygNSwYkbailWh3a86tdDWSD6oG+wCg5JzjDuAR5rOrYg
         dwGtCjpU8h9HDMcgcL5CnOaUU6fepyz4ULHL2EVUJpELSSuOGN4snhhPlzCUBkNeSc6I
         5zoVahhkHduh40WPgNEHjIseOztJTOD++3D3qq+npGQl3dcFl71m6E+SAvoFceo3vs07
         Lub4QqT9n0KYxwTOs87T3LSUvF16xAJGwmLZN3DyeYqcvirusY83c2yl9RCrhUWItqCf
         w1JbB5dm+MFaEnGj804CRTuAI5GutEC0rrX5WUFyvTiJk+4a3uL24Cu9GozRWscSNdBp
         Ajag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760962760; x=1761567560;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kT0j/s0XBuP0ITAjNCV5ZQF3F9LmCWWFhKV3gfp9k/0=;
        b=cfjjflp88IzgWMeb/gFEzE9D8K1sq2IMIUk+lFUhMN2siCM6seaBelcwdvXtoQwgOm
         UEmqLFqAywj04j65q9dvE3JZ4Je8+3IPcSL9zXGf8XjZfsldhnyD4zmNZ4lJ5qa1DN67
         L/jm3zQ0XlTKiNjSUAYwRqvPqqymXNOmS7Cqz6gkEvstmjQohgHfU/qgLHvLaitjJsYq
         gkQKHdi7Q9/KqlgFnKYZELr7WrMHZHz7HoXclMSQMFOpZI8iee/zPPStTaP55GzHsK5E
         NVm708FIGIQoo+VROKOh04D9sZ2l/9aIf8T2+I0rzSoeGLkIPe5WeAUZ7oK1jtjJp0N2
         ABoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfXEvgYMESQxwtwumxKH6wOE60pekJhdU3qJD065ByJmBZXprMw8+WwpVX/huApguRZVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvp+XEyXYaR+icxuKP/0A33s04Oy4QPu5png+iwfQ5tGQswEWi
	u6AypLfVb5FF0oX0dGBylk9SD3xTgR6UcIyUHnOoWNWN5EPe8ordi0lU
X-Gm-Gg: ASbGncuOucMqaF0wDXcVHxr0KFpEkAJvZHP9M2BNjgplcEJXQNnEg8mZnL8OtbZMEia
	R5xX6NjQ+t8hDTwc4zVs8r2fWkSdif396ivQuP+DPpdpZL8GHsuPw36vSpMWUGgIZuIiCHnrWI8
	gZQsw6OPZqJ5pUybIjfyqFG5MqdqBkxhfPHFJqqpDV01VRJPa85RDxDp6TP/hSFepDqzTnTs8yj
	BQph6905fzAXtQHOPmy0XoUu3/lISI7OCa/aHu/fuGwGNynZeIVdhxF9ye0GE5FfgLMvXRcVyaw
	nOS44h1ObaTxpEOamXfapRsDfD4cccgyr/lb253ls+O+ruKNtLorQU5iGvOLDT2KE2oZGe6cttL
	0VCowqsyFKNcwRGpZY9U6ElSCBw8mjphI6qnIb6lPJOMXBQU05dINQzlkp9WvvGejLFGZ19Bz2/
	cl5dtptbCwclwHVY8WEw==
X-Google-Smtp-Source: AGHT+IHxPPhHxkb1OPMx+8tRbXsfi7bsKNPwr2ehmzVPkmhExYX3HfawB7KM5n+STVBA8HM1UbVekw==
X-Received: by 2002:a17:907:3dac:b0:b45:8370:ef10 with SMTP id a640c23a62f3a-b647245845bmr1536621066b.22.1760962759904;
        Mon, 20 Oct 2025 05:19:19 -0700 (PDT)
Received: from ehlo.thunderbird.net ([90.187.110.129])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb0362fbsm784362466b.39.2025.10.20.05.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 05:19:19 -0700 (PDT)
Date: Mon, 20 Oct 2025 10:27:14 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>
CC: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org,
 =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Phil Dennis-Jordan <phil@philjordan.eu>,
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
In-Reply-To: <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
References: <20251016165520.62532-1-mohamed@unpredictable.fr> <20251016165520.62532-25-mohamed@unpredictable.fr> <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
Message-ID: <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 16=2E Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick=2Ebo=
uvier@linaro=2Eorg>:
>On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>> WHvGetVirtualProcessorInterruptControllerState2 and
>> WHvSetVirtualProcessorInterruptControllerState2 are
>> deprecated since Windows 10 version 2004=2E
>>=20
>> Use the non-deprecated WHvGetVirtualProcessorState and
>> WHvSetVirtualProcessorState when available=2E
>>=20
>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable=2Efr>
>> ---
>>   include/system/whpx-internal=2Eh |  9 +++++++
>>   target/i386/whpx/whpx-apic=2Ec   | 46 +++++++++++++++++++++++++------=
---
>>   2 files changed, 43 insertions(+), 12 deletions(-)
>
>Reviewed-by: Pierrick Bouvier <pierrick=2Ebouvier@linaro=2Eorg>

Couldn't we merge this patch already until the rest of the series is figur=
ed out?

Best regards,
Bernhard

