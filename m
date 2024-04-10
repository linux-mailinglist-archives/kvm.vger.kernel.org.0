Return-Path: <kvm+bounces-14074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1881189EB89
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 492101C20DB3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 07:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F4E13C91C;
	Wed, 10 Apr 2024 07:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRJxY7p5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C013AD30;
	Wed, 10 Apr 2024 07:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712733182; cv=none; b=RBvhLExSv97S1uEKG5bXAm1uEcL/ZXkJ//5wcVCm2trC2Iwy5mT1WiNh7sSL9fxVw+vTkeVhha/Dbf9saxtsaqtF6JRGn8HJsMI0IEDU+z/9OYWNTFGmzF+ZRFi82llc07tx3N2fJpGZIwWXALb2WVCxRfuldjbajlzKLypbAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712733182; c=relaxed/simple;
	bh=2xuaVJiYV98yQZyJqCo8wDjLB4OZ8dHeBSX32T6poTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b3Io/0pJZiu5FGeCI2rXF9sya/Zuz1/yIGn0/LEwFUv0yQUUkiJf9A9pa7ZvGiEnw8w8iLby85z8VqnFk/YP0UDGCm0ewM0kG/KWIVvvTANgbZ4WbNAIgaYZ3ce+p/xC5yath1ZCIe7oScwagtfBRRp2THqFHX6MJwDEerddQnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRJxY7p5; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-1e4c4fb6af3so6601905ad.0;
        Wed, 10 Apr 2024 00:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712733180; x=1713337980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v8Z0HpTMm7JW0HfSi1migXbtT3L5ZfuOmq81pu08fxY=;
        b=VRJxY7p5egdlDZm/rODV84LBK9rf1qTTfDxSAScpwgvnvqQorofUcgFZD+EjwqXxxb
         CEi+4kLzryoo3mWJz14UfoWUXko7bF7FSebmu36wk0dFXJkTTNQTYCCyup5kdf8hhqj2
         J2plN8SuPPMHaFt0jWIyGYHnfFmUNB5k/X6PdPhvYzWXKPl5VKuG6r6+1wB+3PfCQJ78
         snoKKCt+clqBxy223cRzcwFIgPXtHDDfD1M9txjD9QBjlEhYUM9WHSO+h+E1nMv9pA7h
         aBPd4qQomXW3cFHduf74VQyVmPTv6JveKRrn83TAYO0GOKQ5ZvieESUidI1vO86uQ4SL
         O9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712733180; x=1713337980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v8Z0HpTMm7JW0HfSi1migXbtT3L5ZfuOmq81pu08fxY=;
        b=McLksPKrtnmMw3Yh7+v+gVGOsLS+Hg6tVyrv9/aFbAhTohoiZ6gT4vXuXkiJA3AIMK
         HGK/e+kTKZlLna62Wuro9GivswzpVbgB665davjFvl0VmiDMvayV3x/oEK0WawEVE9k5
         D8pwStAwDZw2M5PrX4o5jtEpgbdGBS2RTEgkZQPRk5MoCFEobYiKnQwXZYGTrgim8mQ9
         JyDZFu+yKsVoULLzZ5/57YtR9GGY2M557P0h13i7USCKx5xymqx+ojlBdmpgbZfSw4bW
         r9EId3ETqExrN1T+WFNs2Hcn3BS9EXmc5vmIK2k4FfG65fxc9KzfNrYA4hkh3rz/o76x
         VebA==
X-Forwarded-Encrypted: i=1; AJvYcCVJZ8f8CMKZj3bfe/F7rWp9lcgLVZX6rVjYevKg9zyOjGFPzpyMeDqvRfLKpW7xJK8s4n4b/pVVHe4sfWbghIZEsvk7FvLyLyFXmj9OFdAnrbUGomiR2ezi9W4ZIfeGpykSsWlPnkl3NJOVAOHzNl29qJqVGMAP9gmwve5oqbaJ4iYu4A==
X-Gm-Message-State: AOJu0YyOEMBRB1S+Lf5G+1RwistUNYinSS9nR6LzcrNkysaBhjzyBptq
	KzDDQ+1K5Co3O8GUzSiMZstiXkEyST5gepir8s8Ubuqoml/ZugoT
X-Google-Smtp-Source: AGHT+IFMrqnJaJlYiQxwL0LAGuOQ3kVshpqFKiYiLZtdnpGtgTDNithiisZ0+SBC0c+D4ORu1fIAqA==
X-Received: by 2002:a17:903:a8c:b0:1e4:3c7f:c179 with SMTP id mo12-20020a1709030a8c00b001e43c7fc179mr5797235plb.12.1712733179945;
        Wed, 10 Apr 2024 00:12:59 -0700 (PDT)
Received: from [172.27.224.145] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id v12-20020a170902f0cc00b001e002673fddsm10100548pla.194.2024.04.10.00.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 00:12:59 -0700 (PDT)
Message-ID: <40a8d9d3-20a8-44e8-96d2-0dcd8627cfc8@gmail.com>
Date: Wed, 10 Apr 2024 15:12:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] RISCV: KVM: add tracepoints for entry and exit events
To: Shenlin Liang <liangshenlin@eswincomputing.com>, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
 <20240328031220.1287-2-liangshenlin@eswincomputing.com>
Content-Language: en-US
From: Eric Cheng <eric.cheng.linux@gmail.com>
In-Reply-To: <20240328031220.1287-2-liangshenlin@eswincomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/2024 11:12 AM, Shenlin Liang wrote:
> Like other architectures, RISCV KVM also needs to add these event
> tracepoints to count the number of times kvm guest entry/exit.
> 
> Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
> ---
>   arch/riscv/kvm/trace_riscv.h | 60 ++++++++++++++++++++++++++++++++++++

Conventionally, it should be named to trace.h, especially if only one. Refer to 
other arch's.


