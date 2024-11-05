Return-Path: <kvm+bounces-30821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E1D9BD92A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 23:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193A31C2273D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 22:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA5E216447;
	Tue,  5 Nov 2024 22:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NNyONHZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983191F80C4
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 22:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847254; cv=none; b=DdNOIreMwdSCxpXmEagMuPfqWcWe3kYkgGeG36UF3yb40M8KTedyEBqLDDK+rpFTfB+N1ub7cjsBLmvKsfbqaaK5vGfkIhaHjipsVHB5CQigv22TsK0+exRQj8haBq+eSeuMoylCZi5mpZdvqXIuZinok83lC68LviOzpGV6nIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847254; c=relaxed/simple;
	bh=RA8rXB8vDLjgeDqwxxYafe9c6ZCamWEQtr7hSumBRiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ftBj24YmFtAJDCYUgW93ytD3nQmAmjMGRPVVkuvO7OZXzyrEmiv8SyPIC5IGb7aLVW8v70L5mPBdnqh/zSeuO5Rdx6SUw5bhEgtVFAIsA0Gy2oskeWg76udl7nm59wpgdGDNGkZxiZSJG/NxanhXExa6lpdlz11cinEbxqzDQyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NNyONHZZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43163667f0eso51104065e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 14:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730847251; x=1731452051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cv0HzH1vNyWkqVfadbqu8tw5+s9qR0g25g6EENHzeSY=;
        b=NNyONHZZKM4crbDJGxM2hr9mK1WAkTsCno4cB3XOJ/DycTp5HL7K+vGuS4UH9HI8Bf
         3B6kkXWsPEmy0DWw6Yv6xcmQ+FwzWUBU6SlZtLcCIT6DP8cu5ZiWYpnSTEcLRLbRogLh
         MNrApvXbVRxsNq4ILZyf+ZF9adLy/tJDDMVtf+/nUiKShOgd4qflKXA8SHHH9j37wTYV
         oDhj8HhMc58vtMKrQsiZax5OaEPuJcm4Qq6Bv35DSUBdZr1lO5khys+TYe7yTqKiqQ0L
         McXSR0Bjnf0waWt6lZkbMkr7T5JHiUXEojKjEqTI2BaC6QXltATpGhz30xK1luTzx9K/
         FrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730847251; x=1731452051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv0HzH1vNyWkqVfadbqu8tw5+s9qR0g25g6EENHzeSY=;
        b=m3sPa9cfiDfRTfbUTDKpqVTQOKf8rLsQuVbjFEegY8nTf1sYGgx16FdGIUEFePilYq
         aIPqJvm6eV5u383bEquDuH0GgsfWIbr+rrQ9uQ1XYQChmN21FDZurzt3A9uW4D152Z+d
         BpAOY+B2nptXj7tsQDkrgZK4gRUotOUKXSoNH4FwiQ1W2WFy0LMGnBz+XIhgZ1mh1CGf
         1X6pU5V0pulnEW5dDfofGhaWE6R7k5q9sezxLNxD3Hl2j1TvpDfj+h9tMNdSl4hVC/vE
         NS1oiL8g6+N9ztW3vj8ouvI1fB1qLkV3AU/Kyyo15AUTRdnoA5uo10yUpwpJnMf3NEzn
         X7xg==
X-Forwarded-Encrypted: i=1; AJvYcCWN2ULLfXnq/Yt6jFOrFegLsBZ/4Fg/8qv3cRJgYLPCz8IL6pB0IMOElmmPOrBD+utkGO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAVpYvb+hEqI5lwQknmuU+ArwLW09x9tbkoSbZDhRXWHskFwLS
	ucgA3hD2dkIINzgsDoYxTmzr9Y3AMyb29aIkmZs7o3+HxxQ4YwC9toGmHNFXTtg=
X-Google-Smtp-Source: AGHT+IF7iWF2Ipw7+lGag7OS11tcIrj2DAa31GxxvDSSvIYwYLI0vYgG53ofk53jzA+KHiLDuooz8A==
X-Received: by 2002:a05:6000:1868:b0:37d:4846:3d29 with SMTP id ffacd0b85a97d-381c7a6cbf7mr11956058f8f.28.1730847250917;
        Tue, 05 Nov 2024 14:54:10 -0800 (PST)
Received: from [172.20.143.32] ([154.14.63.34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d4392sm17395628f8f.36.2024.11.05.14.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 14:54:10 -0800 (PST)
Message-ID: <1b00ec74-4dda-48d4-b74f-9ce45cf1a429@linaro.org>
Date: Tue, 5 Nov 2024 22:54:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/9] Introduce SMP Cache Topology
To: Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Sia Jee Heng <jeeheng.sia@starfivetech.com>,
 Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241101083331.340178-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

On 1/11/24 09:33, Zhao Liu wrote:
> Hi Paolo,
> 
> This is my v5, if you think it's okay, could this feature get the final
> merge? (Before the 9.2 cycle ends) :-)


> ---
> Zhao Liu (8):
>    i386/cpu: Don't enumerate the "invalid" CPU topology level
>    hw/core: Make CPU topology enumeration arch-agnostic
>    qapi/qom: Define cache enumeration and properties for machine
>    hw/core: Check smp cache topology support for machine
>    hw/core: Add a helper to check the cache topology level

Since the first patches aim to be generic I took the liberty to
queue them via the hw-misc tree. The rest really belongs to the
x86 tree.

>    i386/cpu: Support thread and module level cache topology
>    i386/cpu: Update cache topology with machine's configuration
>    i386/pc: Support cache topology in -machine for PC machine
 > Alireza Sanaee (1):
 >    i386/cpu: add has_caches flag to check smp_cache configuration
 >


