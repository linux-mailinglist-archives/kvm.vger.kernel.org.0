Return-Path: <kvm+bounces-40689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 861E8A59BC7
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BF171887F37
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D309230988;
	Mon, 10 Mar 2025 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n2LBMi1S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1B6158538
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741625801; cv=none; b=pkGRhWYcB8Hb+M3wwzckMuoWEECK0he8ZJY/NVHiQDNMYUkM9Hpcp6yN+4jpunsxTjcBhlPJqqI9GhzsDcGx0uJUazFqkC1anGEWkCUJV2pEi2xcQBZ5u53GaD/kC6w5JuXJ+mSuOLWhAl6t0WyH1BISvtiSgfAUVAMhbp+Q1kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741625801; c=relaxed/simple;
	bh=Q27YEq2U49jHqG/hGwjwp0kXWnrMKlmqxGCr74nLvhE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gcVgaLs7sDKOvUkDwJxHYLeg8nqUy00RVAbmiXBvOUsTvr98t8/VJuv0QMluA4wt1ZCFKOXGh6+7OWffGEstJWVF/Nwlc+C0CumfnyAlLnZc0VRHQutc2YQ5OYrK4s79m1MWfBL8dMx/4kkxrdqI/cf/m04Ay5PA20ldbKYlX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n2LBMi1S; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so5769350a91.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741625799; x=1742230599; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZkjkedmykN6Dnae+6hPjYb5eiAU0Rz5li5jIqpcMQ1w=;
        b=n2LBMi1SggxLv2XHoou6mWwuuE2nT/KJtarQb3R7MkMY15EFFoNyrxwB9hUbVu7M+L
         1prSuE/N9o2Z7aRxcCXvJFAuxy23px/c7t5FRuA1s50k7ml+c9riCRe9GSYxiR0oqVyY
         tVzIN0vydyrhyPxkV7q8yPwFTP+xM2E7/bHklk/C6RaYxi42KgHaUorfWQ4xz6csosqI
         +M+XpUsyrD4qnJvMUydPKX9B8RubUPuctFHJUTpV26bxM2N9QElfvpAzU9J428hlWweG
         VwLdBp/vji6N3bpoK8hhhZHg5/jjZES/K9ejCXF+mpek9fdrEE3t0zA1FJKfSc0WVCT2
         De7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741625799; x=1742230599;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkjkedmykN6Dnae+6hPjYb5eiAU0Rz5li5jIqpcMQ1w=;
        b=eKyKj+UGHyjPUR80Woifgq42xRr2IrRu0P97TieIpgTu+SvCuEodA89PfMbbSGxtDy
         2EPfz/tOYltCTRlLtTLLQxn/gNrpQGwWNBIo0t9F6+KEsk7cABG5QxBiSRLmF/1AfT6Z
         lPfyxwq2yxPjyDCD3pPwB21G+01B6SZ1sX/aGm+ECWxH8gFf6b1nZvMRyIvsJP7kNVSp
         Mk7W6DOshK3N3OBW+whUP/QtAQYSc/5IfGp037KCxmz5pbatjvbxfmSIEEDAn/JwYXkM
         mjt6ZDpuJzfIOqqtkWX+mrlwAx/SDNh8kGoBHAdui8sH/fLAlJG1SsZO+U7qg31gE5UB
         mu9A==
X-Forwarded-Encrypted: i=1; AJvYcCUUVP4fs78DP16Nn+SPtJ2rWxaXuGaUGdh4+hjovpE38lDLuMVFP/YYYcSQCrGQIWRoPuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJIUbmHcPZpCuWz+cZcEV9QwBGZCG1nwBR5Jr6xfWZBgijUKAl
	1PoAGaZ+zernI3kWLA7mJwSde8TMCJ1ksZphSGdtvtWksG6w5tNr1+7IGTCn+yU=
X-Gm-Gg: ASbGncsl/MhEO+JKMbg9OHsvfjcB+nsoxpPyOwjEBMwfagrHimppaGxLPozMAwp0hNb
	1y1hgiWZNOkoFzoCMpaSKSkHQFhilE9U5ghZxh7aTB0JvPk33bodiIoWV+e3h0tz2mxJWBO8bjt
	UKRjGNM7TqAT9UK4rz3GxbEBr6TgDehe/FFA+86SsKPyPRDb0L7QFazC8qMYNNn5P4JQaa58ia9
	9DQZsoV9HviH67CKu5/fob77qxJ1G9s07vKZjHiieFYruIVwBSlqPx+VCs4ymwA2s2XCXQlgJ5U
	aarVQF2rQp3lP/Mo7e6dP7llQ2Hzn5DtZ+ICWJqO8DUou+pCzLbGG4Cbmw==
X-Google-Smtp-Source: AGHT+IHIbgCn3Exn+AALN657KIom6PGObNAGMKxJbf0VIqQkDogxhfDXJch+Uz3paJ/iK/pOhThzrA==
X-Received: by 2002:a17:90b:4a51:b0:2fa:e9b:33b8 with SMTP id 98e67ed59e1d1-300ff10caacmr851943a91.18.1741625798731;
        Mon, 10 Mar 2025 09:56:38 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410aa883asm80360745ad.239.2025.03.10.09.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 09:56:38 -0700 (PDT)
Message-ID: <a57faa36-2e66-4438-accc-0cbfdeebf100@linaro.org>
Date: Mon, 10 Mar 2025 09:56:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] make system memory API available for common code
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Paul Durrant <paul@xen.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, manos.pitsidianakis@linaro.org,
 qemu-riscv@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
 <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu>
 <c5b9eea9-c412-461d-b79b-0fa2f72128ee@linaro.org>
In-Reply-To: <c5b9eea9-c412-461d-b79b-0fa2f72128ee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 09:28, Pierrick Bouvier wrote:
> Hi Zoltan,
> 
> On 3/10/25 06:23, BALATON Zoltan wrote:
>> On Sun, 9 Mar 2025, Pierrick Bouvier wrote:
>>> The main goal of this series is to be able to call any memory ld/st function
>>> from code that is *not* target dependent.
>>
>> Why is that needed?
>>
> 
> this series belongs to the "single binary" topic, where we are trying to
> build a single QEMU binary with all architectures embedded.
> 
> To achieve that, we need to have every single compilation unit compiled
> only once, to be able to link a binary without any symbol conflict.
> 
> A consequence of that is target specific code (in terms of code relying
> of target specific macros) needs to be converted to common code,
> checking at runtime properties of the target we run. We are tackling
> various places in QEMU codebase at the same time, which can be confusing
> for the community members.
> 
> This series take care of system memory related functions and associated
> compilation units in system/.
> 
>>> As a positive side effect, we can
>>> turn related system compilation units into common code.
>>
>> Are there any negative side effects? In particular have you done any
>> performance benchmarking to see if this causes a measurable slow down?
>> Such as with the STREAM benchmark:
>> https://stackoverflow.com/questions/56086993/what-does-stream-memory-bandwidth-benchmark-really-measure
>>
>> Maybe it would be good to have some performance tests similiar to
>> functional tests that could be run like the CI tests to detect such
>> performance changes. People report that QEMU is getting slower and slower
>> with each release. Maybe it could be a GSoC project to make such tests but
>> maybe we're too late for that.
>>
> 
> I agree with you, and it's something we have mentioned during our
> "internal" conversations. Testing performance with existing functional
> tests would already be a first good step. However, given the poor
> reliability we have on our CI runners, I think it's a bit doomed.
> 
> Ideally, every QEMU release cycle should have a performance measurement
> window to detect potential sources of regressions.
> 
> To answer to your specific question, I am trying first to get a review
> on the approach taken. We can always optimize in next series version, in
> case we identify it's a big deal to introduce a branch for every memory
> related function call.
> 
> In all cases, transforming code relying on compile time
> optimization/dead code elimination through defines to runtime checks
> will *always* have an impact, even though it should be minimal in most
> of cases. But the maintenance and compilation time benefits, as well as
> the perspectives it opens (single binary, heterogeneous emulation, use
> QEMU as a library) are worth it IMHO.
> 
>> Regards,
>> BALATON Zoltan
> 
> Regards,
> Pierrick
> 

As a side note, we recently did some work around performance analysis 
(for aarch64), as you can see here [1]. In the end, QEMU performance 
depends (roughly in this order) on:
1. quality of code generated by TCG
2. helper code to implement instructions
3. mmu emulation

Other state of the art translators that exist are faster (fex, box64) 
mainly by enhancing 1, and relying on various tricks to avoid 
translating some libraries calls. But those translators are host/target 
specific, and the ratio of instructions generated (vs target ones read) 
is much lower than QEMU. In the experimentation listed in the blog, I 
observed that for qemu-system-aarch64, we have an average expansion 
factor of around 18 (1 guest insn translates to 18 host ones).

For users seeing performance decreases, beyond the QEMU code changes, 
adding new target instructions may add new helpers, which may be called 
by the stack people use, and they can sometimes observe a slower behaviour.

There are probably some other low hanging fruits for other target 
architectures.

[1] https://www.linaro.org/blog/qemu-a-tale-of-performance-analysis/

