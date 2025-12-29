Return-Path: <kvm+bounces-66783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B204CE7C4D
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24DC0300FA0B
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786E832A3C5;
	Mon, 29 Dec 2025 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P4oX+pWA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCC1E98E3
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030630; cv=none; b=UOZ7VFW9VPXE15rL2eFJRlg3QAtAJVMWtP/5H1K0Xcb+dY/3FM7QVfoZyAwUng56RtyO+5fsxm5lYyzuzMHlCqYZUQTujaw/M1inN0Su22mjTsRyHL2RItbgtxGwh+nGNs8fZPIl4lTzBZ65mP1CS0XZHhEzl2IVyA1BuZwnsLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030630; c=relaxed/simple;
	bh=1+nQZC45EoilWV0p6+NthJZz6Bu/z1yfSHDND3Muyco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oiKQAsHT5abMScn8Wp+RK0hwtXZaAbp7dFBQernjRv+oooaKhs4rUT5kIRNIt2p6pw1OwiBwd1iOF5grsTbkJpynW1waXdMtddTI4rmIBTmGRsnRzvpcMhDbbQ9xp+wGm+oyhEBJQ/h3rBltCdwXypWXZH/eQUEaW6V1WmeDuo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P4oX+pWA; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so8202884b3a.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030628; x=1767635428; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NMJvl+26zye/uc6N8hPetEtCSv2kkfCtjjQWUsWfol8=;
        b=P4oX+pWAiub+Lqzn5MToSlCc96YZD4bxJdnhyIsWXRRp5xoLPNN0u0/kim00Q7UqDH
         cG3cdK6dDDFP9jtXsPOEDiIjqg045cazFl+nq354DOeqVz/YeKwQtQm6LAPDVxSuDT6E
         yKUFioPM8Yw4VTBijn/9vzEe3WxI59WLcvPvoimj42KY4AB2tdWiIzeMsT5dPJ5Kpdnc
         cTfVbWDxPj09EEhSxA551ZKGPX9wQXseKTWyGmPGq2Ar0jPjy9IDTeJTSDbsIHtvmtlL
         Jy5vmwQu8gtMHf7eKIm7gtsDoBoy4BJ20z5NyIPPGuOqw6BMpWnY7A25TMvKF0B1/TPl
         7dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030628; x=1767635428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMJvl+26zye/uc6N8hPetEtCSv2kkfCtjjQWUsWfol8=;
        b=ZTPtvuetQzXv01E3m0rD+2uL5IS9Tx7FbxjAO6y8pPeFmJEAZDb6RCNzcIeJ+kP/FJ
         CHevfZ8BnhZzaFzNkXEKrMdaOOVWsbMdExAlitdoIotURlH7Tahjln4gjKRuiLiIfEDS
         aLc+AxYh3Lxbvj2PRFvjP1EEJrfNb+pJcpCX3883cnswNxGigm3wL+m3AJFaoNMvSuLM
         e9u//Fk8KF5nGl644VB2tPrYhEjaPhVF8OTt7r9HE39OUbc1pVEw3tok6YYHZrOd0JqA
         c6mxLGTfD9SuqOvKuvd/lP9CXcjgN2cHtEfxLPFSqqU57gKNG/PFPYqvz+Yp8cvRzYQ+
         ncAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY6Zf5RJh8qi8/UDxv/PWF2g9YzJYaWFPc15kyJ+9oeSq9ZgIjUUG1bNQlsP/XnsB2liU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1iMqLPekazyopEMqyLAzW15T5kW98ac56y4pmFoPOtes1L+y7
	1hq+7mTqAFnGsx/i1Nr9jo3qOJv6jVrcvTtkTapwjaG5GtllYZo4sjSaQvsMtpOL8WI=
X-Gm-Gg: AY/fxX7L7XugaCcW7qey2Di0/ux79l9YLboz7U3vo33eGT2YiDD5UtM/aL1LcPa5z6i
	ntmQYUDIWlxn7+gvXyFEqVKd8LCdHP115Qkl9Jl1QcUN5SWwOKvqpgBfwCpnUVYM1E4NMGv2dCY
	gsSJK6LX703SldhAljZeKKfBbxKIfOopRNsrdfaiMcYApX13IQpF9XOcQUGxuQhSSE+sZ9h3wl0
	jvFkYUa+LTV484EsaHonU7RSo0bBvhkPKy7zEUxg3tyAOHRfnVVsqBFvEvlTeNPqTiOceiKbf/M
	FOcF+dYZAx4ilSc474WhIgqdVX8xfzbK7qE3MC23wpOJ5RoqV0xL/pj/sT6MFq97N2gnbA5Of5c
	0QGchyuURvV0xaNDhEsCgPyVhY8HP70VzyJVvG1zahEFpFAHOMNLvpwouZpZvJc1arTHgiicrh8
	5TYn/4fZ/WRqkHo9wdkGw1GViztH5Io2XzRL+3qKqFlP9dH1O1MNG8hKL6/C1z1+z1XgI=
X-Google-Smtp-Source: AGHT+IGWKwlx6v7gYluQ1MLIMhcafWyUo/A9TAcRutAdcXVCZWqG3IA4aGb+/LU8vGsEZaPt18WRVw==
X-Received: by 2002:a05:6a00:4c83:b0:7a2:710d:43e7 with SMTP id d2e1a72fcca58-7ff648ede90mr25019660b3a.24.1767030628311;
        Mon, 29 Dec 2025 09:50:28 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm29978778b3a.24.2025.12.29.09.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:50:27 -0800 (PST)
Message-ID: <52121d27-59ae-4547-8c07-90514f1f2d74@linaro.org>
Date: Mon, 29 Dec 2025 09:50:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/28] tests: data: update AArch64 ACPI tables
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
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
 <20251228235422.30383-6-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-6-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:53 PM, Mohamed Mediouni wrote:
> After the previous commit introducing GICv3 + GICv2m configurations,
> update the AArch64 ACPI table for the its=off case.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   tests/data/acpi/aarch64/virt/APIC.its_off   | Bin 164 -> 188 bytes
>   tests/qtest/bios-tables-test-allowed-diff.h |   1 -
>   2 files changed, 1 deletion(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


