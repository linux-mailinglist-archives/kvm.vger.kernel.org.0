Return-Path: <kvm+bounces-60170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E11BE4C97
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0A2224F242A
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8763346AC;
	Thu, 16 Oct 2025 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uqNVpzy0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF06334693
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634478; cv=none; b=bIs9o/1rQah7oB08icgE6om2lgR/077y6Z53fif7Q8QVehqGEyjQI1GpFY74QbNNqHrS+oDWGdZd61uTds/9e4NsCgfadWjDYi8tT6O1Osxr1nhxOD/iC3BZKfbcpLFvlOafsYtd2TgooSFNbPTnAuHEqnG0h+pkO1JFzkrgZ70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634478; c=relaxed/simple;
	bh=KhtMmMqcNcN7ouWPyyeIkZsebHJ2LLVmY7ke9RAfWnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9je/4wI0lv2PlIsI3+KPli+F+VaKp44PYbLKQoKVqUjbsaRLmQu2AutIuDqrDXSnF2xr3KU/Wh3dihWL2ubChhKd7k+042nPeiI7unVtnJV87CfGD3GS9VNqNzXjbBZ2jPDery9qGcuN77ZZ0sPjrZtCVOruSgD72txRUvh3w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uqNVpzy0; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so1373551b3a.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634476; x=1761239276; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mzbO6qxXTSLN2VfEZ7sgVqVzDYN015Du6ppqHnVvYSo=;
        b=uqNVpzy0s17Ix9L7PYbgRrrVHafvrAiMc3gadI+tBf3KhiYUkF/5CDMQ2kQcPDAAUp
         3PkumLMouyPzdq/Zvimh69jVA7yHJJh+c3bovy+OokGiWH6hTDj5HAJnJZKruveBaoCL
         nDbaxjis7YA9q+j+qPzzx3kPWczhSfsxoOD+KMCQPPthpNMYIR8iwhWr6PtSMvcmKp+Y
         V+hTtTQ1lboff4mwYctF+9Z0q/aUjBghDpPf0KlQzvqstJ+CjzlFAonAFYCsICxsYuPI
         3IVFKpPYbhfnT0rZz0tN6338wlheeKrZgUj078UyJaw0LizO0z7XL3FY7Jk1P/lH8xQP
         10rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634476; x=1761239276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzbO6qxXTSLN2VfEZ7sgVqVzDYN015Du6ppqHnVvYSo=;
        b=k8qaOpJ5LAeFNbfOY4RrO3VKRAr3uhIg4B7z5OM+ZOnGGAgSaqapWsud5meYKdI+rv
         T8LK7zyE5baXwL56pHhMVki7HiluCUvZz5kwu2FUjGHUAiAHf+obz0GX96mS4HP6eyjg
         AfU8tigUv8CXbzhSPRArOedwqogin7ayeav0Z6a5AMJahnxtGp4CdpzbtH6bu0nA3DZa
         ycxQ1VTeiLwe/sP/DD5DqIu8vVZmuFjs7cS8ZsaUl7i1ZgSetva+pyLHprwIEfVxMSKm
         GsPt+xltrj0f8hPAoArAG8z5CGCDWBVNKaWE1EFdGkErDw+2wxt9lP/UbXTsHDi/svM2
         yq6w==
X-Forwarded-Encrypted: i=1; AJvYcCUzI5JyON9oITXgd1l8yK/NKqCuF/LYqhe/wa0TS+u/7diwjyR28dgeitXICV8ED24Bu+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP+5zcjmunL+ksYwactiMPDjUd31kS/tgAz2td/Hr/mpeOFbqR
	hUlIq/FK4iC6EDFDvTBEfdKl+ZIRVDgqKBlLD8GUZCQH9cUOpm2IujTc1Jq7VMi1PCs=
X-Gm-Gg: ASbGncurFJmuA18lzGLiI2kQrJ1iRczpJ/H0RzSPqwNCNuvuuVWUOp8SkNA1KeC6rQY
	B4LSkuzIGmo4frbebqW67IxKEvsIH+/YCf0sPIem/zn4x1RsqSCYyDuLB59L3Y+1MZ598ZupL7K
	0hUzN0/yIXaJm3GICWDw/DZNXxZPiDIkOpyS1Tli7jVw7Cak/lIu531mriwx7rq/jVhLrNIsmAn
	VzjH6fkRMZkshws87OJxMRcdP/m4uDqvMC4l0c1ohxgP3+WYO/RstFdkETWemNNyODXDnWWPD0u
	vDkJjFv0H++kESBGXrOKATKiwAMneBKaHbl+lrOohMwuq1U3cFs2h/T0Qb7LwNiU90gzaOwK81M
	c50JzNGgr0Rf6LhBUW4LXh6XeqlfsLf4o82fM8Jg31bqnweatLNDZnGqBqcsGnvluKKk272Mzk7
	KDQTkPM3PYJmCEFmKggqG3bmk=
X-Google-Smtp-Source: AGHT+IEz4yyVpPHAHnaSdwY5OhhzkZ+c1o6Qi6CcgXGWF688z8Ud9rib7Lcs7Z3hHBFsvf4idG26UQ==
X-Received: by 2002:a05:6a21:6da1:b0:262:da1c:3bfb with SMTP id adf61e73a8af0-334a84854b9mr821530637.7.1760634476213;
        Thu, 16 Oct 2025 10:07:56 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a31e443e9sm1825218a12.16.2025.10.16.10.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:07:55 -0700 (PDT)
Message-ID: <0d421108-0a63-464d-82de-071ccbc61919@linaro.org>
Date: Thu, 16 Oct 2025 10:07:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/24] target/arm/kvm: add constants for new PSCI
 versions
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Sebastian Ott <sebott@redhat.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-2-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-2-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:54 AM, Mohamed Mediouni wrote:
> From: Sebastian Ott <sebott@redhat.com>
> 
> Add constants for PSCI version 1_2 and 1_3.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>   target/arm/kvm-consts.h | 2 ++
>   1 file changed, 2 insertions(+)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


