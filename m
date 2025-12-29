Return-Path: <kvm+bounces-66799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DA3CE832E
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 22:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7995F3001027
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 21:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E193244661;
	Mon, 29 Dec 2025 21:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r31lWlC5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCBE14A8E
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 21:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767042991; cv=none; b=js13qthtQM5rl1uVIu9AI0u8974NYebBGAtXtrwCfYfeqsXwLYxFzfIcg6Yggk53E3itEhnKGv8zW7nVm0z8n8vo6wBT3c9Wy4ytz7V08CIKjZy7TlItYxSUOrU8FaZT5erqak8u3cZqqtJjAS1oyd+UFsFiemwc+B70c1VBjOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767042991; c=relaxed/simple;
	bh=6y+HyNwD5g+wa1kJC3jJX6XiHxEWqSEQZ6rjChjxSiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSEJjl3dZEWBgpqpniUJTPiN6vpHcouAk+fURWh/03QwsY1C2BmfkimWKpGkvm4Xs2hp4X/9WNchNBn8Q4zUMO92qyIG2xReG3PmOsfeukL5/PCT8XDkToQDdC3oShSTnaegZv95N0/+QJxco9QQ4y0mgfh/9wBzLAiSagLH4qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r31lWlC5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0f3f74587so134004235ad.2
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 13:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767042989; x=1767647789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qhFsOZyvBBszKZWunrdffetKMiWyonnb2R4wITLXaZg=;
        b=r31lWlC510z8mbNunlvDSexgAz/qL+/6QuEubtTMqgfTERbm8n1ae1oUTRrZKU4CSr
         EXP1fPePIHAvYrMrSJTyWgESvToIvmFSebh60vZE2uMOlkn/4qP5KPwfoHSWuWLbQQ1p
         IvAleui2sgv0iL3aAwiJmvt8cDJvl8kBjrwPhhImagSfKLbLoi/HO6KQU41zCdGAWwLX
         VbwmAnQGMzgrmVmx73LNIWF7L2leOH1vU9sOrTr+H5wsAYpSG7G1Ewc8pLjGwG+kIVq+
         F84yQJQXZZsBwqIBI44tpsndmxy7+C0vgYg/UxFKRZjcwdprWu+rPJsTY1nAKHlt+bKl
         LlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767042989; x=1767647789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qhFsOZyvBBszKZWunrdffetKMiWyonnb2R4wITLXaZg=;
        b=DziaxBBWiN3ijtFUYBhIHAFtdbolvBeEfBeQjO+P7FfzJMJnszCJAdybAB0oFspeWj
         n5pgto2qL9PhptgKfozykByW4/4A0nQYL/50rfGCIKBvfW9WIfoVgK7/skcxH3Aa+zel
         oOkUlW3xp5iioSdFNrQ8TZ+DKF6w3EDumskhWThTWK3+QsgnB9wVreaOXR3CueiRgcwQ
         ydpKPT/GsNxWNq+w50KQ1XnnkaAP4sSD6xpi6Cy/UZZM8MlIKDinLgubSPAD0ubOlGfh
         NEfMdYSq3CvRifXOT30lOiNAs0zKpcFeIEWNQaC5a2dsRaWUW8VbtGe94KFI7CT9uydl
         1FsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFhL8r6fCCXvrbLY/LqJRG8PHyes47iHD4q0ybfaTEyQah3gzcl6KwGbQ5c4GGKlbS2cU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcWvsQEm5wGGdCBLCzaYYzf/1iuRgn3eI/8VaeMnYajH/XNhVs
	ZjpRkqbDi48cv0g6YZVqKqzIxepjTq7TTYrbOEpUMtCbzR23PKLm0ks7oKElQWtnvH8=
X-Gm-Gg: AY/fxX5g/isYTSvoSnO4d/fA220eqnrHmICemUs//x71Qa7Qd+1sWw68x1HT9K9kxpg
	9VxDz7KncQCrEyZ8ENtjCX4bmJXroiaMZNvF06HyE5HXSLqs+5JjjEdi0iZT2m6IWix/iHbt3Tq
	9istoFa5bgQyLo94Ljy/BrYOB0pnsRX4b+f/oSlPvaninJrQ0bPQPdW9cImbFvkVkdWn6tQ9esi
	ey12/Hpp+p+Yi2XdNHo76BQQB2Td2YzCgTrGIizEsm5EhmVTCmcIQ7nVxaaeTPVMsTCwt8/loNR
	vmOIqvcI4TXC6aEZ0vREkD3DFJt6iaaSJ2sRiLbBt9IrzpEWpk3aluPM46aYHCRpe0KP3IfHdre
	5aYYj4SJZuNVzQnILbZAW6quHYHRKoA/ovdSql1AETGBdc6hzQJeECBkhZLpxfvQduBx36/Oyfj
	V3PKweitkPATjXhbutoHat2isQwQTrV+s0MfdCmuda4rsRln9cHkNGa+IN
X-Google-Smtp-Source: AGHT+IEGt52KsPDYD4kZ/T/EKTKTWuY3l6wP4cc7Qhm9l5w3PkTsTalivjc5D+ZGTBaFT/NH/WE3jQ==
X-Received: by 2002:a17:902:ccd1:b0:2a2:f465:1273 with SMTP id d9443c01a7336-2a2f4651332mr282066605ad.35.1767042988982;
        Mon, 29 Dec 2025 13:16:28 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d20dsm281656315ad.67.2025.12.29.13.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 13:16:28 -0800 (PST)
Message-ID: <3bb036dc-e38a-4879-bdae-34e1f0ae0ba9@linaro.org>
Date: Mon, 29 Dec 2025 13:16:27 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/28] whpx: reshuffle common code
To: Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: qemu-devel@nongnu.org, Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-12-mohamed@unpredictable.fr>
 <c8bba373-0ff1-4acc-ac3e-7157b3627247@linaro.org>
 <2F12B75F-5AE5-494A-96E8-5B0766804685@unpredictable.fr>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2F12B75F-5AE5-494A-96E8-5B0766804685@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/29/25 1:11 PM, Mohamed Mediouni wrote:
> 
> 
>> On 29. Dec 2025, at 19:46, Pierrick Bouvier 
>> <pierrick.bouvier@linaro.org> wrote:
>>
>> ERROR: New file 'accel/whpx/whpx-common.c' must not have license 
>> boilerplate header text, only the SPDX-License-Identifier, unless this 
>> file was copied from existing code already having such text.
> 
> Hello,
> 
> Deliberately didn’t do it because it’s copying chunks of the existing 
> x86_64 WHPX backend.
> 
> Should I still do it despite that?
>

I think you can remove the GPL boilerplate part yes.

> Thank you,
> -Mohamed


