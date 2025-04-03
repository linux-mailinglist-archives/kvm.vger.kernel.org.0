Return-Path: <kvm+bounces-42592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E71A7A7BE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 18:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 751C33AC0C2
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B4D2512C0;
	Thu,  3 Apr 2025 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xZhZ4XdP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4D33DB
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743697116; cv=none; b=ScYhmgnFy0lnhifFu51S00lA0JBZ8sjfEbLjqbr2Q0cZrvKyeZI5nkMKwUkaaaWw2PVK3TPINtgeF2jHi0f0RLg4whlro9tLDqHrIM5fsscudU75Ry7okUv+ATOSY/t7omTO+1RTDgycveDLHWNixPNeC1htSuo645RWuWv30ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743697116; c=relaxed/simple;
	bh=x39luPc+dOXIM+x6bbOzkYde6vN7LjcapekMw7Cuda8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3lHQS7F9LWvzyGugfmgyspY1XttIsUbSGdBM+qQ6rIdE4ZNAwFj6+0kedMhHWwIzlnhpVwUyzox+kBCdX9kJRukl8fzdGQdUHYZVBwS70JEm1h/DbJG48ayXHbGgW4q/TR+sBJ9uy0bcHX6m+ISvnstznl7ohCjOkdx2Wcvj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xZhZ4XdP; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225df540edcso27991305ad.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743697114; x=1744301914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x39luPc+dOXIM+x6bbOzkYde6vN7LjcapekMw7Cuda8=;
        b=xZhZ4XdPsGC0PL+5NEHR/Elv9pQuZbJjX6XOO1L4Lr/zYAnqhjMCk4V9MH0gmKotG8
         tHw5bggsoQveMXJTl4ZBthivewSzZqf9SuEt36MSyTuR0EZljs8W8nmFlkYJ1mkMb0M/
         AFHQDX/B0btGxocXnYZ45Lfz/KtpSV9Ckgw4b0icORuHHfDa95Wma01QipY04rIi2GnS
         T7ewSOjMb9fyNlSaVDOXK4aGB0EFtVrj3/XefOdoVuYZT829rHY4KyEq69barVvDhPNc
         ujiu7KgbFCIffz0H629hg0sGLQK/9vNy8kcQrlP1/X6RvmC4L249mncPBzo4bvsYow2/
         G8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743697114; x=1744301914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x39luPc+dOXIM+x6bbOzkYde6vN7LjcapekMw7Cuda8=;
        b=jHvTvpa9ShEBn/K9k0mDIGcg2mKY3gpZu1uVqqis+BOp3rIXuS0VBnboArSq3Fd+7g
         Cztx2QiANw3d0nWUlQkZmGM+DMm7VRBNzcGvOjyYlZLWWT4JwZWtEiFNgmYQlCnGgJJy
         T9zN9adTj84kEXYSPxAgLQSo8e5I/5jez27jGLV8LXATQyjANLRKEQwfGUpJe8R+at4R
         zwkfKHCmjLn9azNSDShiSUzogxFTHVV2vkP3irY0uIlnjdJajtgnI63PIxH0UyIQBGbQ
         +YW8J5NTMkF0nF8ciJrHlDQBbDEWbYLm1MaqYi9522CIHFMHa074V8KDZrsqmPfCwbFp
         wfJw==
X-Forwarded-Encrypted: i=1; AJvYcCWDdhjU8yIJajAJSvfG9twt7Wq0Yjo8nrKPB5Sfy+121dIFLgYzOg30+FwngvurMKTrHIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbMq3/jDU6VrfHhhfOA7LfY4MKmp/h8NnSQ+IN4m/2NylXRM22
	ZC/APuOU0r7vuVpUc09TaiHxGc2IzqcWNnJC4inJ3r4ZzZmMM0mw7J50gXkCVxQ=
X-Gm-Gg: ASbGncv9o00hBB/vVrFh18fqEDW2lsZdSpU9jj9SwDmb3H2Y9NFYR2CiZwVZemmEUWr
	t0hLbkXhTaMS2PDBFTCWzdC7abhXhHy+b+YLnP2u6T/WZ2Ozuho/hEP2xcOKnEmCIIBxBXeN/dY
	ndcOlf1pzWcRz2Ocw6BXvB7DjygBZk07USt3NjosoverFAKQg+a0VQ/yNe1cXm+0QchhQphbwy3
	PFG5LDzAiwXVE85HxijXuUstFYMGr/NBsRffw9iYhIzUjJrbXkd1l/jJcpT5IHsE6GkqogsK0mu
	BGtMkilTDi3Iyck/fbw02JNJ6pBgw0D8f+gXt2ckmbjQzx+Mzvar+m2dWQ==
X-Google-Smtp-Source: AGHT+IF4q7/kri8teKMRY/8jyeWsH+vGxnupu4MuBAEpCr3j4cu/OyriJ+IN91ryNnKreauAlaARJQ==
X-Received: by 2002:a17:903:3b84:b0:21f:53a5:19e0 with SMTP id d9443c01a7336-229765d1a02mr56269955ad.12.1743697114494;
        Thu, 03 Apr 2025 09:18:34 -0700 (PDT)
Received: from [192.168.1.87] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297877266fsm16560025ad.215.2025.04.03.09.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 09:18:34 -0700 (PDT)
Message-ID: <72224ba2-2d6a-4d84-99c9-83af5a47efce@linaro.org>
Date: Thu, 3 Apr 2025 09:18:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/29] include/exec/cpu-all: move compile time check
 for CPUArchState to cpu-target.c
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
 <20250325045915.994760-4-pierrick.bouvier@linaro.org>
 <e11f5f2e-0838-4f28-88c1-a7241504d28a@linaro.org>
 <319fd6a2-93c1-42ec-866b-86e4d01b4b39@linaro.org>
 <1d13c66a-e932-48c4-801c-9b14890679c5@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <1d13c66a-e932-48c4-801c-9b14890679c5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8yLzI1IDEzOjA2LCBSaWNoYXJkIEhlbmRlcnNvbiB3cm90ZToNCj4gT24gNC8yLzI1
IDA4OjI1LCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4gT24gNC8xLzI1IDIwOjMxLCBQ
aGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+PiBXaXRoICJjcHUuaCIgaW5jbHVk
ZToNCj4+PiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBs
aW5hcm8ub3JnPg0KPj4+IFRlc3RlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBo
aWxtZEBsaW5hcm8ub3JnPg0KPj4+DQo+Pg0KPj4gSSBjYW4ndCByZXByb2R1Y2UgdGhpcyBl
cnJvci4NCj4+IFdpdGggdGhpcyBzZXJpZXMsIGNwdS5oIGlzIHB1bGxlZCB0cmFuc2l0aXZl
bHkgZnJvbSAiYWNjZWwvYWNjZWwtY3B1LXRhcmdldC5oIi4gSWRlYWxseSwNCj4+IGl0IHdv
dWxkIGJlIGJldHRlciB0byBhZGQgaXQgZXhwbGljaXRlbHkgeWVzLg0KPj4NCj4+IEBSaWNo
YXJkLCBjb3VsZCB5b3UgcGxlYXNlIGFtZW5kIHRoaXMgY29tbWl0IG9uIHRjZy1uZXh0IGFu
ZCBhZGQgYSBkaXJlY3QgaW5jbHVkZSB0byBjcHUuaD8NCj4gDQo+IERvbmUuDQo+IA0KDQpU
aGFua3MgUmljaGFyZCENCg0KPiANCj4gcn4NCg0K

