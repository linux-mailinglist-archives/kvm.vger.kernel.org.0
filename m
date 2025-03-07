Return-Path: <kvm+bounces-40414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DF0A571B7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A68FC18982F1
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2ECA24167B;
	Fri,  7 Mar 2025 19:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yszSFZOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDAA23ED63
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375810; cv=none; b=G/mRytq1fd+dpdhSue5zSe4TRs8Tmzxo4SC+LsT00AseB1m5oP/p0k/1ubVWad1X7dDagTo8ZQIZ8NCgitzu/g26KT2AGdUAquD1kcDhCaDhA1peQ1+vZotpl03P7o9x0js1Tce5C5hs8nncl2/Qn1T4oGbxEfDLwMO+eyOmbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375810; c=relaxed/simple;
	bh=wCBOHp+O9t4+PBZnsUb2A7ChT68TuOsOSSaK/QthOhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cae3Trj9t9lF2bPMGbbQVVHftQ36uYb0fCDKJ6ODNTmrwE7KnA2iB/YkUMgU9BUVomFn2tljVEObRzwun0ytgG3gPIrFv1RrZMQ1YJiSZUFWgQKvfMxRuIMHsih9Gi2DDweH7K8vw0R+jWu/n3iTbqu0pOGPMv9mPhsbVTL0Z2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yszSFZOh; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223f4c06e9fso41692145ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375808; x=1741980608; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OKe/9uxtkFAajxZczlKcExAQTZPTYGe/0Zw4RLHeawk=;
        b=yszSFZOhbnjVpD0yz0LU62VzVmh/eEs0SHC1x0v536hVRPunvP8PLIjCcv5mfHNEej
         6NaedwOHAmGADiyBXSj6c08Z59Q63Ro0JdIjd7qQxRvSk4YPVa6Ot6YaGGtHwj8a46Hn
         AOEde9p+MiN+Wdwqr9kls+J1EVkRVrpyKf3XVTBJHlI/0zr8e2MwFv9TDfvuzC3BkVmW
         6FvE69J6cf9kiWbm7lfKx+iJDirBxR3no+znyQbvNOgAbNVnV8TzXsJJDhvM/q9m1uhy
         3Zlj05pp9UQ3C1/vFSucdPu1cZtB0U43c1YQzKzeJH6d02q/xht3oqxd5m81nvD6OvtK
         4tTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375808; x=1741980608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKe/9uxtkFAajxZczlKcExAQTZPTYGe/0Zw4RLHeawk=;
        b=AHO+EQjDdCud4PT2CGqRgI3ySju9KBobm+B8l3Fn0T17X+3CKwpqLGDoOlUJvD06dE
         n4FPsBm9Ag5MvVIKkILDaQjDi5ShBWNSQ9jJF9MXB8+OIFe3qwRFynhVZYADW2Zvip2q
         nr0SzVpWajIw4rSKL9Xd/lzjsxuJUro+4DoxdPrPeAwSq+kzXNDI6R0wAz18YzvTyZoA
         1NPRukR+OHRXZI3SaC61o66nF/SemmZY/PKwi8hgPgptOXWJkbgvi69eDDCrMqh9Qaof
         j2fA/5Ycs3eUiVwQKOCDRoemVJ+mszpu9JKG0q5kX0bK0YjV2KQ0aklQUDENKjuP4ehR
         ptDA==
X-Forwarded-Encrypted: i=1; AJvYcCVpdxR+qiDAj0buItIPFeV73k2rzx2ta0n1vkALPqH+m/BNOgRN+e1/6BKLq/3HvIguVOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDo6/Mbgxd1tUZkjTF2uOmncdA+PI/ihwhKIT4cA3LA945PJO/
	I2kmMyulBwt5ORgqZxfgFCdZBGOuREBI6/gk1hAEih6x4BO+/lgkAnk1cRiUpQo=
X-Gm-Gg: ASbGncvmZYLzo564gtP5IYucXQPn+FOuxTkiwcEFrE+G4YmjqNuSK2HMB4PHgQEHlOV
	mHZXP3uFW/K8h4pg+Qj9LQdKNZ9aF/SFYgvwvnHPx0DgTTfqjcRlZnz28o8IkjAa373IVPPAcKo
	rrmi6QESHhDlh4cw+ewPQioEfdM1rC4z1q6NTjBrsEzdGVHryMimbZWxoFPOGLoY6+itiDOx9eA
	JKgddwDWTXFDrJeA8gIK92YkIvWOBw09VTS3pe+mRZpgJegPwv9YEaXAyVGy/Cu/iciLKYvB4Dw
	jdHm8F09vVBJaDOWcaev7yO26CRgSDKwI0AVy3vEih4E7rGGsms5a7UOwfuB4JPgDESfcVO3XNm
	6RJ+0Rr33
X-Google-Smtp-Source: AGHT+IGKZK8oJgsxTqvLKQzxgs81GESVfzH9goWbMO79ltB5TQZHurX6dLEbKPLbOJNsnE5z8XMbqQ==
X-Received: by 2002:a17:902:d48a:b0:215:758c:52e8 with SMTP id d9443c01a7336-22462a488fcmr13556705ad.12.1741375808621;
        Fri, 07 Mar 2025 11:30:08 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7fac1sm34002025ad.124.2025.03.07.11.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:30:08 -0800 (PST)
Message-ID: <2de80620-decb-4200-b3b6-158be3be4427@linaro.org>
Date: Fri, 7 Mar 2025 11:30:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] hw/hyperv/vmbus: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-4-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:09, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/vmbus.c     | 50 +++++++++++++++++++++----------------------
>   hw/hyperv/meson.build |  2 +-
>   2 files changed, 26 insertions(+), 26 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

