Return-Path: <kvm+bounces-54497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E675CB21C52
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 06:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 595C9425F20
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1B72D8375;
	Tue, 12 Aug 2025 04:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qAvnp3UO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDCC29BDA4
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 04:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754974195; cv=none; b=KlyB/njE1BQ+bDAlew/NM0Nc5qdh6sFPlns8p2g9f1njt/CsUfe1xwIF7Dn4otbhHdQMUkOQa0wfXey0dH5XTAF2q/2jjTnlsqiLPk3Daga8GJQrBAHlnSJ/nzZRveA8j7MoOKDadn0lTTX6Vh4tK3jz0rMtJo/HAQLU1wGnliM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754974195; c=relaxed/simple;
	bh=USwbopBGsdQ6fUUDSMheH5s7ezULI41+JIa9AHy2IP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ASA35rAWUVO/ysF8sKRPjqho5Cm0pN4yduDx+mZfKYqx5AjLLAQoch3iSQuy8JXK7p6x0mW3x6VDzX+zCWPAH9vkiLKOYE5kloj31vdnnm8OUDrXYqrnKjpzKCqVceLjNjCfIga0KxXjn2LjyuQEhg0NzzdXd6qtc7i7OtiYPuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qAvnp3UO; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b7823559a5so2354611f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 21:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754974191; x=1755578991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKO/btB8sgwjdTI9Kz/mOI1judsHVR/Ol8FXze9Q5lQ=;
        b=qAvnp3UO11btEF5MydiJ2yS/JQgZOROlczHXb4dop41jjnYAVB2xqwdl+dkcHiq6qi
         AHtyWeb4g5L5IKiH8PMHg9/NA/cncCa3EuJAawViihP8aZ0YaM7I0v/4WAgCEdevY3Cv
         WMDJ47xrSD1f0V8Fmz0JF0bqKammydVpva5E3eXMkd5w/G5E64LgUldB6rzbCYz03e8u
         bfBVjKT1Nb6vYzTWf802t0v7bNRO6ofpHYjRslI5ORl0eaL9gpzEArye/Z3xoMHLvDxX
         CoLrylbt2Qz1hXtJ6/mU9iL3s7JJzv3Fg793wRsgiCHO7BXBm5I+WqBWtd1EeaGMDwHc
         /6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754974191; x=1755578991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKO/btB8sgwjdTI9Kz/mOI1judsHVR/Ol8FXze9Q5lQ=;
        b=i51UwlRDZOQMwmP3ZM8v9Rh12DuhRXRZPi+Rpn8TJdmKBro1CO6yk5xZCwcNb5j02h
         NtVnpVp9W+gud2DRatHQ5HqNxGk/9YV7u9vba6OW9Em3rUnhU8f0Pvgb5QsJPbB/5T72
         nJaElkZrS+q7yGPx6QybVn8hkyp65IskUt2REEkcw00rxE7ZTWTM1y+08vdxQgPbxyi9
         ZJyYJEyHITlHoXp257ctUodfC+qV1IXNyHWi+KWCRNpmMhI0KveVRzvHotKBz7NcGt/H
         O8e8RDgK5f1sHwvowbKs/crGHr7p4f4XfSKpTccxB8/wMAt1S15sXQD0VgzOztO8brbO
         oLPg==
X-Forwarded-Encrypted: i=1; AJvYcCU2mzzGYZyftEBuUdSQgRAKXARl5MTayJ2rHFqYg6VggBWN/ZWudfncG8zXyITw82QmUY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3lru+ibRJPuenou2Sd4ExQsJ0BzOQpMptlhEQ+a4I3h2Af3h
	t5DjMfYgUJgGY1qJDNgqwheQ7gtO9gxLOMplp8f1gUWwkglAogbHvmk53r5j6/sQj+8=
X-Gm-Gg: ASbGncsFKBv4SyRf2MnmYcU2YbgexDeZz7EX3KHOF/G0hq/ZYgv3cZqlTcpasmpV+RD
	A8LODMV44nKSAXpxj+HUdIyrPPXBqFcwb7UnFN6qLdo9U9A17pi/kSyTmHwjnYUj9iGZC748927
	wsjbKznc06288GK9smtJ/1Ylr6WkTNFC5EnTAOkqYrmNVidATHcUiZkdLRAf/YrvsXZ0E1EOS5c
	p6gTmfMSZnmhOfUZOZhk+uG4RQILdLUNj+aLPZ34+ouZIpAVD3U3rWP5Tqbfc/V220MRZQy9IQy
	ykf3MHhyd0bDOWE3Cm/f238zRo8qHmvi/cpMWLQ+F+rjnzEB8Cq+BbORUZwMNPoQ3C8J0CcRfmd
	eWQ2kPtUEwlgkkXYzLTF9KGIEUmHV58L9Z4mlfymxrI2IHhdL5tBEQcMemyijg1mk8dMUS2NwXr
	S2
X-Google-Smtp-Source: AGHT+IFzSLCrFfOChpFZBEIxi3PmTUayS0Ee8wnnNgXG4m8ADogf3URL6YowrkJcbp3tQmtBfLy4LA==
X-Received: by 2002:a05:6000:2010:b0:3b7:95bc:a7ea with SMTP id ffacd0b85a97d-3b910fd9b71mr1537054f8f.22.1754974191512;
        Mon, 11 Aug 2025 21:49:51 -0700 (PDT)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58400f5sm274704575e9.2.2025.08.11.21.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 21:49:50 -0700 (PDT)
Message-ID: <14d7d948-e840-4ae7-ae93-122755d6a421@linaro.org>
Date: Tue, 12 Aug 2025 06:49:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/11] target/arm: Replace kvm_arm_pmu_supported by
 host_cpu_feature_supported
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Haibo Xu <haibo.xu@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>,
 Mark Burton <mburton@qti.qualcomm.com>, Alexander Graf <agraf@csgraf.de>,
 Claudio Fontana <cfontana@suse.de>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Mads Ynddal <mads@ynddal.dk>,
 Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org,
 Cameron Esfahani <dirty@apple.com>
References: <20250811170611.37482-1-philmd@linaro.org>
 <20250811170611.37482-8-philmd@linaro.org>
 <8efcc809-f548-4383-b742-e435d622da73@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <8efcc809-f548-4383-b742-e435d622da73@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/25 02:48, Richard Henderson wrote:
> On 8/12/25 03:06, Philippe Mathieu-Daudé wrote:
>> +++ b/target/arm/kvm.c
>> @@ -288,7 +288,7 @@ static bool 
>> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>                                1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>       }
>> -    if (kvm_arm_pmu_supported()) {
>> +    if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {
> 
> Why is false correct here?  Alternately, in the next patch, why is it 
> correct to pass true for the EL2 test?

I think I copied to KVM the HVF use, adapted on top of:
https://lore.kernel.org/qemu-devel/20250808070137.48716-12-mohamed@unpredictable.fr/

> 
> What is the purpose of the can_emulate parameter at all?

When using split-accel on pre-M3, we might emulate EL2:

        |   feat            |    can_emulate   |    retval
        +   ----            +      -----       +     ----M1/M2  | 
ARM_FEATURE_EL2         false            false
M1/M2  |  ARM_FEATURE_EL2         true             true
M3/M4  |  ARM_FEATURE_EL2         any              true

