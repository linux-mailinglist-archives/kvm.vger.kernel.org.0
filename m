Return-Path: <kvm+bounces-36803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 409FAA21343
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20ED27A3EBD
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5211DFDA2;
	Tue, 28 Jan 2025 20:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XBE5Vjsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139A21A841A
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097635; cv=none; b=GEpWafk+fOibndmsPBXavd0pLAtCxxtozys0jKdoaj+lX9IadW0CrH4BOuHQRIuXIQmUJLGLdp5fnB3A4WiCd9IpkKDiyu8gO2oep8gEXMLa/0hNtlOeuebSSme9ouhHGVOwrFo6VlOKCUj5QAgmWQNIhLwklixXwuEIAI6v5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097635; c=relaxed/simple;
	bh=4UVnvOVyZfbs71P2hPz4ONbWV8UPB/pei/G0HJQzNy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g6YkAvvrfHczPSqGvciwSwyjAHoohZefwchTD24YbIscvDV6GsBLK6cb8AglRGNU8c7bU/ZlPpsLL1ncgd8jXY/wbyQ+7Tq8CC0534qGusfy1+peGpGLbmFwpH5RyXm+tZbFD4EvHmNzq4iHuK58EkmP70xqM9/qOVFtj9eUCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XBE5Vjsd; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216395e151bso874155ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097633; x=1738702433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EdYR+g3RZySNqBRj2P+MBIC+Dp11IBEcEZZWpWgjeRQ=;
        b=XBE5VjsdwmYp+R5u6vqZyd/uN5VXhqMAG3P00RXTk1XnFX/emamJUI7FSLCl2/BPHX
         cHX5N72a3T/ayFoIjhw0tqCVYChc/f7eh0SVvzFnvVi44zy0wfksP/bWy24ZjAyLyyEF
         ykKtagPvxD/9SPO2lsQV9rRBpB4B0oQCiu7zKNa+h0r3FmJ5bIH55ofbMNN7jEbC23fn
         D/igKssOdpmAn4TxXkfd/OZfAvL+K/+//14AUdqWRD1i5Q2uB6Jnm5YUo4sfXWHe6PZf
         GA9MlqYHyYOfmoGf76eGQTPtr/PU3G0yo4AiNkhv/NppcPaUiokBqJ8Ii2n7tL9117ud
         E1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097633; x=1738702433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EdYR+g3RZySNqBRj2P+MBIC+Dp11IBEcEZZWpWgjeRQ=;
        b=A7/tdCnsf2ev1q2Tn0NRKiG5BJpSVZ/NgtEJLM5rgMUbBj3kqzTX3IiUh8AvG4QJN9
         BX//LsjsEwj/AcaEhSfURqzwLgVcOQllb+KJ03r0iFQTBTuS9GRn1zcZlSv3xRgg49v4
         W38uYUXf4zc12+cAQJgqV8pICJm5V7wRR+EHC08901FqbN3lorNqfEAcgHwW9BAbfTze
         z+mCfFbjWezNbB8dzQD4xf/erwaZcTuPcVxkotxaMABcEvamErZgEP7yQQ0yrGdVdkyr
         xj8nqwtGgKkjENB+g3mmSDW4nCkMmfPdotdCFzb5SbS7mw9tXrZbx4VgsUkaAxMVf3Qf
         s6tw==
X-Forwarded-Encrypted: i=1; AJvYcCWOcYf8pa858dcrEZ7jdqW0EJwUjr1ozOcYV/d6q+9ijUiLS8itt7HXjYCrju+ItO5JNl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmt/Bri4mUzvnb80c+O6jV1GCfmAaSrv/h4CbM8dUg4kNVtEXj
	ar+cJnJYLkeWB4JuRPb7Wri3hnHJfmcRYLuTErpcGzf6kLBU2TSDQUPlivKqUuU=
X-Gm-Gg: ASbGncsrfZ2AiubDQZy5OQyC7dB23MOz8fEsPhlFmTfPUkP/nvvxm2ygP5k5wlJJeWy
	3tTl30+dGj5+8jVWZS8WYQ9KGpwbiRGiZ0GbPqvVVYjGpyG12TJMCaCfvZDHnLYn9eRWZE6F0ho
	s3dGtZ7st9N7JT0HVezjQNOZd8mwBx5XK5BnnDJ841wIEhkJ19e5XHuYuAwLOEc1HD1Vdw8JUjV
	ZAlUVO4LD9fE0x91NknWyVsqOO72tFjqjWKa/Aw+zPyX5YQabXNrVcJPBqcJ3cNOeuxooCrbjjZ
	uPyHFoQ/0hn8kGENRU64Z7ozpzCHtijXDPyAeRO6IL0qmGdlbhP20N9H0Q==
X-Google-Smtp-Source: AGHT+IGT3RYwq4TvBuMp7Yb1ABeHTb5L2izZWLlG8mrwmQfObeRas+wAp0zgDA63rMhcPAFSml9DFg==
X-Received: by 2002:a17:903:2445:b0:216:5db1:5dc1 with SMTP id d9443c01a7336-21dd7618768mr10778945ad.1.1738097633229;
        Tue, 28 Jan 2025 12:53:53 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414ef91sm85718885ad.209.2025.01.28.12.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:53:52 -0800 (PST)
Message-ID: <81a4e102-1eb9-40af-9c8c-beef06204390@linaro.org>
Date: Tue, 28 Jan 2025 12:53:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/9] cpus: Only expose REALIZED vCPUs to global
 &cpus_queue
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-8-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> cpu_list_add() was doing 2 distinct things:
> - assign some index to vCPU
> - add unrealized (thus in inconsistent state) vcpu to &cpus_queue
> 
> Code using CPU_FOREACH() macro would iterate over possibly
> unrealized vCPUs, often dealt with special casing.
> 
> In order to avoid that, we move the addition of vCPU to global queue
> to the DeviceWire handler, which is called just before switching the
> vCPU to REALIZED state. This ensure all &cpus_queue users (like via
> &first_cpu or CPU_FOREACH) get a realized vCPU in consistent state.
> 
> Similarly we remove it from the global queue at DeviceUnwire phase,
> just after marking the vCPU UNREALIZED.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   cpu-common.c         | 2 --
>   hw/core/cpu-common.c | 5 +++++
>   2 files changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

