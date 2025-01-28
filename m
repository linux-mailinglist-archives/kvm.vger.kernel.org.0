Return-Path: <kvm+bounces-36804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5E8A21347
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3243167301
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2871E0090;
	Tue, 28 Jan 2025 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MTWM36f+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4202199EAF
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097724; cv=none; b=uxhP8R1AkKD0K8IDqfJNx+7JgL4p/UFvGB0q4EJzMEzlZscf4mrtWCmxkqwWYaRubzIkMs6XocfezzLP1oCx4HdtAjYagUv0I9EK2VgoOWzKWxwxpvIiYrSMZ7ChCXG1CNBHbyhOBWc2DksRzRnbUGUpZXFe7AQA+OpBo659gQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097724; c=relaxed/simple;
	bh=dig+sN+S6+TmdlV8jOQYHU0Sy3zon7wshxRljHxxZnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/PsgCmHUoRjt1brgqy2Fyq4zvvzZnGGJtN31swa1+w9zHjqu+jUt46uGg8/OSk8m8XCzYycbizNuvVOcowqXc9fVQKvcNi7HNQmJLO1cSMvsY1OYslpZRnEfs0u0WomahwouoMUrdsX03BN7AiNxPp+vnYdbvMCknVzkIyEObc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MTWM36f+; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2f78a4ca5deso8321535a91.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097722; x=1738702522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tk6SC/sXu3nZ38nnpeSVXfPOJnas5Y5jvFOyhMpP5wY=;
        b=MTWM36f+yu8M/ftcfMt5SnNR3Xbb/J8Xi1f2XBJMRHUlvVoV8HsN6LyLP6dgQwuN0+
         BuR6Irb6oELPs5IS+Rt2DEFJRl8VQ33/0xJYU6KrcmfQ2vcebHG5QB1x0GVgeKapOXY8
         Y6ErTr+4IcoG+HBYHPVvA3REvaK2cVRLLiaPaq8SqB2ceamtfl4T/AmqTeermJv26Ze2
         0Ojv7XiuxhoQ4GKy63ygUKZ9M9OfHgooNimgk9EeQHL+tsv/44tLrYzwrvWktFMIRq/x
         IlkqUhiKQYr3NObPOlGoKldk/oFX3gm4AFypjhEPjzbVBcFC++sNcwBOMESK9TuPT7k3
         Mrww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097722; x=1738702522;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tk6SC/sXu3nZ38nnpeSVXfPOJnas5Y5jvFOyhMpP5wY=;
        b=sCSndKsJ93r1nSCp9oxZN4R5jXS0PGIR+sZkYrnfXVg/pgfXPDbcktL1O9z/aDjPIz
         rAcQDkf8YXW6eRyCSMCtU+i1tjjwzIj8lKw9o7BZLOMpfj10b7SIWPhDjTyW8fSauyHQ
         uZwdbr1o+sQOvntK+c1Y692gFUq5vVez+CWsACZpdC5Fx2EGUGYKBsUZbJSEeARDa854
         jkdfwQVHuWpu5gowWVYwu/fOtX+XTQIrYCqYRoBUOHc7f2h3xsSvAj1B1BhRExAymZQm
         rS3sdNPCCVWIUtE/fWvfqJKWMEEBV29Xu1s8udZ/P/ZfhqiwtvKLnZ1IrV7JSKW25CG1
         dNIA==
X-Forwarded-Encrypted: i=1; AJvYcCU+1g/nGmaWApfjyW9omorXL9FVauKtkEQHRLu4HvcOUMIw4QrRFlxB3oTyx03FEYfenmI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7QhZ61ScaP0q3oWXQivFY2AjFhdKzZU/sHIcpmQO/yB8XCHIj
	RUZOGAa3T2AFVe08yf3thqU+apsLF9OrsIfgE3SZXFlga1EXOUBB9tr4/Icpmbc=
X-Gm-Gg: ASbGncuhYLyrqfr224cwV3ECWq2YFGVawuYwplcdrPJ5MeY9QfXmW7Fahbuqd7pbC2j
	o//djPoU+9mi6oe171Cg3AkNntqUwypsmcDkN1xxCOyDDsu7PGbxrLY1IQM1KMKzRvGkC1Q3SiB
	jCMGR8ECDfOakbLwb1f/N3fobWmEIJrdsutO/12S47uRFyhg7Kv0fhwTx8qR5H3w+JfHfOMz+Y/
	7E7Tfj5K+H43PIDTbGSAVHpszH7b2a4t79UMBiUC9E19SbghzasyAFEf9PYZ3yoCgPAGBYbdMLM
	B8iZwRmomVM2/9E6i0wOeYaUH0peZiCFGlV3sCR6BSJCvdGqnaDNb67ayOaH3OJD24e+
X-Google-Smtp-Source: AGHT+IHXaHwiGgvoGyH4RXVKJr3J+3gnWSR7ML+JiAfdyojCEMUSMyRf8bjV2DFg5vmDLaJiVOu41w==
X-Received: by 2002:a17:90b:2c84:b0:2ee:cb5c:6c with SMTP id 98e67ed59e1d1-2f83ac70de7mr508691a91.22.1738097721886;
        Tue, 28 Jan 2025 12:55:21 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa456absm10898525a91.2.2025.01.28.12.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:55:21 -0800 (PST)
Message-ID: <55627824-fcbe-442a-ad95-24d5ac6e2ace@linaro.org>
Date: Tue, 28 Jan 2025 12:55:20 -0800
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
> @@ -91,7 +91,6 @@ void cpu_list_add(CPUState *cpu)
>       } else {
>           assert(!cpu_index_auto_assigned);
>       }
> -    QTAILQ_INSERT_TAIL_RCU(&cpus_queue, cpu, node);
>       cpu_list_generation_id++;
>   }
>   
> @@ -103,7 +102,6 @@ void cpu_list_remove(CPUState *cpu)
>           return;
>       }
>   
> -    QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
>       cpu->cpu_index = UNASSIGNED_CPU_INDEX;
>       cpu_list_generation_id++;
>   }

We might rename cpu_list_add/remove, since they no longer do what's said on the tin.


r~

