Return-Path: <kvm+bounces-44239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE27A9BB50
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EB74926932
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30777224AE9;
	Thu, 24 Apr 2025 23:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nq/J0yLR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8CF221FBB
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537409; cv=none; b=fnSCnnNhC2qmOQrRxcrGKtw6LHzEyuY22gCGbRSsmPe6xqBVfTN+i6VzJX1evOp7pDBgBNbohgWE8y99uW4mkVw6l8bR0pLU3D6kvmKKmolVArsqSf266ajSQ7NWQDR4GLN4oB+P1l0C2aw4dpH/wE/gozx5UWyJ3PKtJ8wARjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537409; c=relaxed/simple;
	bh=eTBeCZP7PexW27NbSq+kcu0Pquxu8zr9hjpIVAGbQmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZNibCQ6Tyf21w8IfN0dlGIppHI4CJD0TO/Bu8ECgGDzcedoSksOmzvX0iJqT+cw0r0NRswZfCtS/D7COz+V4N00yYG6/T0Y+RGfYKiksqRsUzxnZVwsfUJ1i11gzvwpRtEI3ivmw2+TSlwivcnONa/R8ShXS23ZIk+S3cPqMt/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nq/J0yLR; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3054ef26da3so1364422a91.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537407; x=1746142207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmijQUg6qedi/1PXs9n2C3YLgh0edOYmWSOQO05yNzI=;
        b=Nq/J0yLRluMsWpfA7zEByqZQeIVYEKFXgI3ToGOQIbhYc41FlKuSIDufnGKOljCuEB
         6y6lRbTSAKYMQQcMc8uI71/2Ql3qZHQ7zQmU0aB1GpIPzgAnJAzpDrM/fqLtHk4gIR7a
         OiJQYEqid2hOTSmeIdQjMWTmCMBYvbyQx56xhjt3n7D4xZADvtBnXvvkLdgo/iCqRSgs
         H3kPONjRLOEJxBzfJJ4AssCNz0L4fKftFzi6oinvRji9bHbSYcHMw2Hci5IrsPSpqFOP
         zfyaQu5KW1bC82GrJR/pD847jyaYIzBNdBg5wqoBeWHsVLf87X6js0ZAKjek7J2GeBSk
         badQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537407; x=1746142207;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmijQUg6qedi/1PXs9n2C3YLgh0edOYmWSOQO05yNzI=;
        b=TJeL4OT/+YiUeAaTf8nvBY0AjGGPHRY0syx84MFtVOFifFpxY/3SHgsfhvwqpSkOf/
         ty6NlLBL2Rpa7b8Bj/84P4qA5OlnPoDNrbvWHdi/9RSWrT/YIMs4JQ56dx8kK46+YYcX
         5wdWVTuAA1LEBBFPQzT5EjzwhWP3lDF2wx8BeLnhoQKc0oXWTQsXBSlcN2/2jUINISn+
         Sinme9HWTqZGRldeG47Op/4dX+GIb3oixNtS1a2nDtZMGnaTU8eDaAWoLYW7yJq8v2nG
         uBrM1/l3Tn1BxtjjLygq4GS0CvFWYUSXkn7nT4iWoDDSWsv20ZNc1m6jy9C09rKm8Z24
         0sXw==
X-Forwarded-Encrypted: i=1; AJvYcCWQjXDpBRhYS0X5/tRQjaxhMnr3v/IAgBEwd1QVWx9FCy+HSHrjBjJV5TQglm/vxUI4RSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgycZehAHwjFqx912VVkc+eEdDCO0FB8ZBooJggtEwDs2f0YKr
	6ih5kDNMifYydmG3/SQfpzlOinIJYFstls43Q+kg1Cil9pVbLRNnb+o9VR/uVvg=
X-Gm-Gg: ASbGnctq4Afbm9y8Kwp2FLzr5T4uY+0siXTU4AiLDpk1etn6Mr0R6aG8rBVn3qoOtu4
	oXPaFXuNMefIc98JTMedT6Hh1TiTudZvff88lmofXUwQIqInSD7Eq/m4DSZkhiPryGkS39+4TOe
	gp3X9iIWWWWGi5oRL3RvEZP+Rs38nQ1szZvV8qEzpNw7VvP4OMjFICttmFuTJzTzQbT9M1CPdkb
	9YlHCorhVrQCM7WL3XfQCU8GjnRYcW8spQlzmBgi2ytFLnF+c9w6JXSomRVDgiHAyIym/6rND2G
	N/jEjIsTUVtp6EFNR73anCG34gAYL6uFpY8EsRmdL4faDet95bGBPA==
X-Google-Smtp-Source: AGHT+IHq/z2ESaola/00JY0QWo7+AJCgldmBSHnqFfO23MwHqLzex5qutnKf5V0X9FrPoAWVq1F2oA==
X-Received: by 2002:a17:90b:5408:b0:2fe:68a5:d84b with SMTP id 98e67ed59e1d1-309f7da5ae5mr472534a91.1.1745537407143;
        Thu, 24 Apr 2025 16:30:07 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309ef124ce9sm2028668a91.34.2025.04.24.16.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 16:30:06 -0700 (PDT)
Message-ID: <81732388-d0f7-4bdf-ac8a-3537276dc284@linaro.org>
Date: Thu, 24 Apr 2025 16:30:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] hw/hyperv: remove duplication compilation units
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org,
 kvm@vger.kernel.org, philmd@linaro.org, manos.pitsidianakis@linaro.org,
 richard.henderson@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 16:28, Pierrick Bouvier wrote:
> Work towards having a single binary, by removing duplicated object files.
> 
> v2
> - remove osdep from header
> - use hardcoded buffer size for syndbg, assuming page size is always 4Kb.
> 
> v3
> - fix assert for page size.
> 
> v4
> - use KiB unit
> 
> v5
> - rebase on top of system memory common series
> - make hw/hyperv/hyperv common
> 
> v6
> - rebase on top of master (now contains all changes needed for memory access)
> - finish making hw/hyperv/hyperv common (hw/hyperv/hyperv.c)
> 
> Pierrick Bouvier (8):
>    hw/hyperv/hv-balloon-stub: common compilation unit
>    hw/hyperv/hyperv.h: header cleanup
>    hw/hyperv/vmbus: common compilation unit
>    hw/hyperv/syndbg: common compilation unit
>    hw/hyperv/balloon: common balloon compilation units
>    hw/hyperv/hyperv_testdev: common compilation unit
>    include/system: make functions accessible from common code
>    hw/hyperv/hyperv: common compilation unit
> 
>   include/hw/hyperv/hyperv.h |  3 ++-
>   include/system/kvm.h       |  8 ++++----
>   hw/hyperv/hyperv.c         |  3 ++-
>   hw/hyperv/syndbg.c         |  9 ++++++---
>   hw/hyperv/vmbus.c          |  2 +-
>   hw/hyperv/meson.build      | 11 ++++++-----
>   6 files changed, 21 insertions(+), 15 deletions(-)
> 

@Maciej, this is now ready to be tested :)

Regards,
Pierrick

