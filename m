Return-Path: <kvm+bounces-7454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B638420EC
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 496161C277A1
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 10:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F75D65BD0;
	Tue, 30 Jan 2024 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NWNjXfP8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831CD60ED9
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706609666; cv=none; b=Vh/UVWGRRSLMpVlHeOtwdZ5DoQn23+8MD848d0R3Dk5GDL6kMc5ONM28v6mx/VJ4HV+FdOw65c+rrEm/zxtsbY+C+ouAi/G7EEFWssJvMVfOGYXRxR/SdlGEAQQwf9y62LBVfJZRITEfyOcrbxgQ7P3z1y6TNA/pIy+OrDeWFAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706609666; c=relaxed/simple;
	bh=pWlxnVvu+U+7GXTiDikyth7SfoBJ8VBR/ZHGyCqa624=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmwJKfrkJkBl0FQTAV1OCp4zB3eE1KZ0dlyLKYaKuph2ccEYvmg9Ulm4wCn9l3p3n2VU5+8KD7PlL71hDyyXuiQKs0YdIQHfQbQkZiYjblXNFtPuVHDRs6HpwrKJYWfwrMkt+o/gltoJ6lUDR3ralDNGYcsIeRf9hemTr4oyz/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NWNjXfP8; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2907a17fa34so2945184a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 02:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706609660; x=1707214460; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FUlxL+39zvpvl5E9zKEekDOOrtv6RH6k7fqk6sfwuMI=;
        b=NWNjXfP8HPaveJCGketbuyzvGDMtNoR+ytysqu89bVkM46mXw2WspntqQgS19qsI/k
         LoyxlvnOaLYF/c3Ptf4UV3qa8s2rC2fGRfMkjPnRB7IsUaprotVytIdpjqf7ENRAgQiI
         KdTU5P35H3Ort9EuJ5ns9zs7selELTqRHRtmQ+ii5/cxL6YJ6PCkRBZK+z3eHvhnyvFD
         fXnsoHqVmGDlZSAjASX1GvUx2E2dnAoTGx18MLB2qyB8cnVwjVDESLtxe8UjA6Vck+0l
         oeV/Yr/J7m5iQVrJP08rAVkN/TnlNv3HeJTHz5NwolDkhruhW9psfn9Vc1ypKWahCkuH
         x6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706609660; x=1707214460;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUlxL+39zvpvl5E9zKEekDOOrtv6RH6k7fqk6sfwuMI=;
        b=qvnQlPDyNEMk8zUezVZwICRMF3TR25ZyChsZGwjMDs0FGQi0dl1TSxl2LxUfk7sO4H
         +TjvIUTXPFKQh0jxs+NV/B1gafkLmQO9LpZPoMPuvpkk2HjzEVWEHWun6ollfAI/YjUA
         DgeGYo33rP6rFAAx/nat6L0nRFQjZaOBy+TqihCIOoMxEiJ95BdT6/K8439I6o3GmLaj
         1kGFa9D3ZxlyaDsZjCs7Bn5qJk4hUKmJt/QYBxIPT1GQiqrppdyZSuY3LSprRdUJVU1X
         76c3MDO2Bs0REPzJjjWObya112Xhtjp6aNwgbE1T0d6SlT7hp2Q8/OuE4APvgqvPrN82
         MOAA==
X-Gm-Message-State: AOJu0Yynyq2LgaA5oENrRtzqXz3YWg7FqpOFfQP6ggx5dkkNiky9Nawj
	gf5WjCgqPcEphztG2hK+xbOihTa3r1f39H7Us56h/K+n+sx3yT2iM12SyJ8/CX96L+YWkr/2ER4
	5/BY=
X-Google-Smtp-Source: AGHT+IEcoFWpnhKUl4j99xsHteg5M+jANkCADLKdR5PYE16G+bZO2y+w6/O3QrrNq/mOOoTnHIBrFw==
X-Received: by 2002:a17:90a:616:b0:293:8708:7a04 with SMTP id j22-20020a17090a061600b0029387087a04mr5097354pjj.18.1706609659751;
        Tue, 30 Jan 2024 02:14:19 -0800 (PST)
Received: from [192.168.0.103] ([103.210.27.218])
        by smtp.gmail.com with ESMTPSA id y13-20020a170902ed4d00b001d8f24ee024sm2544453plb.173.2024.01.30.02.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 02:14:19 -0800 (PST)
Message-ID: <6f47ce70-5d11-458d-969e-8b14a511862c@linaro.org>
Date: Tue, 30 Jan 2024 20:14:13 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/29] target/loongarch: Prefer fast cpu_env() over
 slower CPU QOM cast macro
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org, Song Gao <gaosong@loongson.cn>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-16-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240129164514.73104-16-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/30/24 02:44, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/loongarch/cpu.c            | 39 ++++++++---------------------
>   target/loongarch/gdbstub.c        |  6 ++---
>   target/loongarch/kvm/kvm.c        | 41 +++++++++----------------------
>   target/loongarch/tcg/tlb_helper.c |  6 ++---
>   4 files changed, 26 insertions(+), 66 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

