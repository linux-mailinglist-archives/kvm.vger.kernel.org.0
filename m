Return-Path: <kvm+bounces-32880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB9C9E116A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78882B21AEC
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E26153800;
	Tue,  3 Dec 2024 02:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Ah8UhOYM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E29A1EA84
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733193562; cv=none; b=d7jAEBfgiyU75WrDqN6CIWoCWnpLPOc6MBjhd0/CdvFlu2rUUjTY1PUqYNMba8CJuIv/ddSSZQenIfG1ZxK8ptYFNS7uZ4nfEosOsj9/5Eg3HlQ18aI1P+exKjvcw/eeduq/pw3/COxKxP1/oDEi8Fd/OqWjSARf0YyLMvOoDS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733193562; c=relaxed/simple;
	bh=Wciq+UGMrwPpmcpdk2ePzToy1IWXDCRZbJxlRsomWD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VlUkmDHoh/1uxN5PGGeO4atWAamwi5eDzkkR1aguxOGjEJCyUSFZMZyc/t4P2zfw63frNyGCHrztd/hSMPfpkbhdHv8alydZtgQFUjQQUGdRLHzO/NRXYdKFhlAYG4HaVSFd/kcJG+oxJVctzMMN4A3Kel9ogkMAQe0/L2rNei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Ah8UhOYM; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-843e3b49501so156728339f.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 18:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733193559; x=1733798359; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=807AMPvhV08hQjY+W9FqkSX3XWvObJEHMlCsMJUuV3g=;
        b=Ah8UhOYMwiuIRzQF2tHtSzwxS+d9Jok1zbzWwepke8U+ziFp3Go1c8s+6Rl6WkwC1C
         T21oNTPM7zOvVWaLH5GWE+UGdxvmRPo9znPwW6dmPYND0nX2HGUx9lgWUbSF9SYtyDSd
         NUENg9p8WlyS6yUQ+nW41J7p6+FBVGBztHTeR0md/5TUPCDRDrl3f5nDXKSNxM5nCHyR
         3USwdRC3mlC9soKdK/TlqA2zh50R/cvWkYu6JBdNsyP3rtrJNl8XpOjsC7JU5zg5JweG
         yTfB74+umDZyF5nrHuWA4t1cJfHghCagMp6hNgxtvJMxDYISfcvuuGX9RwlfowyPEVCy
         FshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733193559; x=1733798359;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=807AMPvhV08hQjY+W9FqkSX3XWvObJEHMlCsMJUuV3g=;
        b=SBMLOVRJTCC5eGCnw94kNsJ0PGwt6QKMYy+TtMhEjNhd8789FHIhgIS3ZAoe4mmxxD
         2Ein5rNf3NBv1bGus4bybFR+af2muaX3GiMVjcSF9l1ewj1hAxKq2daQSyZTwE7JGEan
         OhmOd0QhAXsvMxd3hb54YYDJjGhUjto/XOvzSNws4hPaB3C+dFupRJ/3+DfyXiOR5NU/
         C8oJNRaG5v1+8Ww3R0sEx0DSHS00t1yd/X2Z7UFf3i8DkYDNPAwx4ktaf9GwVms9Um7y
         U9ILofg0kqYLKnDvT4+KByrSdAwBLpQM0Bjt0Uic8MTT8FBiXt3DjxXtwCRzXkOjmUv4
         GKeg==
X-Forwarded-Encrypted: i=1; AJvYcCVRhJr78oiQOwJEl6UgcGWNudg978B2JlIfV0bTbPUNJtwUFssGUHUZIWv4K6bmf5E5Xk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmTvfwuwk51a9nMfISzgzNpKJLdsCcm9km4XdKbT10MfoNB+Mg
	V/fqAZpnrdKg/RZXMKHcDDAS3/2xgredPeupOFk+C9OtZn1L0kQIdXS34I0JLgA=
X-Gm-Gg: ASbGncstGyB95XspZE7Td58YUUlMY7niVwps7wYicAl85o+0YTWGK7QfDgPN8IX+va5
	BvUXjKW+0gnUJYgku6QuD+NYqr8uj/MHk6BLeQhW2WfVyTP9MEOThsAWvJlJFjlcEH+Wq7ZQftm
	DWKZo8CruzwkleJqXvQzbI+UHjfbP60rBRpie4kjDUXuPGd7YFnhyJRlinfqGF9nEGElOfA2Jzc
	rlkENhAYStzRDQTi6KuSKEeBaBLbsPdzgOumrLkvVblDHDtagamQ1g25EZBXrLs8LxWR2DsPyo=
X-Google-Smtp-Source: AGHT+IHd7BOnDkCqoWQpQn9axYX9LaHCjBDlODl0yRpMhp5QCmkH+d5KKW0iQf5wP+UEGLbQlYkP4Q==
X-Received: by 2002:a05:6602:3405:b0:841:a1c0:c058 with SMTP id ca18e2360f4ac-8445b577d49mr152097239f.9.1733193559650;
        Mon, 02 Dec 2024 18:39:19 -0800 (PST)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e230da8f03sm2387687173.17.2024.12.02.18.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 18:39:18 -0800 (PST)
Message-ID: <b48c4319-1fbc-4703-88d2-6f495af9c24e@sifive.com>
Date: Mon, 2 Dec 2024 20:39:17 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] drivers/perf: riscv: Add raw event v2 support
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-3-a4f9691421f8@rivosinc.com>
 <e124c532-7a08-4788-843d-345827e35f5f@sifive.com>
 <CAHBxVyEwkPUcut0L7K9eewcmhOOidU16WnGRiPiP3D7-OS7HvQ@mail.gmail.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <CAHBxVyEwkPUcut0L7K9eewcmhOOidU16WnGRiPiP3D7-OS7HvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Atish,

On 2024-12-02 6:15 PM, Atish Kumar Patra wrote:
> On Mon, Dec 2, 2024 at 2:37 PM Samuel Holland <samuel.holland@sifive.com> wrote:
>> On 2024-11-19 2:29 PM, Atish Patra wrote:
>>> SBI v3.0 introduced a new raw event type that allows wider
>>> mhpmeventX width to be programmed via CFG_MATCH.
>>>
>>> Use the raw event v2 if SBI v3.0 is available.
>>>
>>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>>> ---
>>>  arch/riscv/include/asm/sbi.h |  4 ++++
>>>  drivers/perf/riscv_pmu_sbi.c | 18 ++++++++++++------
>>>  2 files changed, 16 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>>> index 9be38b05f4ad..3ee9bfa5e77c 100644
>>> --- a/arch/riscv/include/asm/sbi.h
>>> +++ b/arch/riscv/include/asm/sbi.h
>>> @@ -159,7 +159,10 @@ struct riscv_pmu_snapshot_data {
>>>
>>>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>>>  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
>>> +/* SBI v3.0 allows extended hpmeventX width value */
>>> +#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
>>>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
>>> +#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
>>>  #define RISCV_PLAT_FW_EVENT  0xFFFF
>>>
>>>  /** General pmu event codes specified in SBI PMU extension */
>>> @@ -217,6 +220,7 @@ enum sbi_pmu_event_type {
>>>       SBI_PMU_EVENT_TYPE_HW = 0x0,
>>>       SBI_PMU_EVENT_TYPE_CACHE = 0x1,
>>>       SBI_PMU_EVENT_TYPE_RAW = 0x2,
>>> +     SBI_PMU_EVENT_TYPE_RAW_V2 = 0x3,
>>>       SBI_PMU_EVENT_TYPE_FW = 0xf,
>>>  };
>>>
>>> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
>>> index 50cbdbf66bb7..f0e845ff6b79 100644
>>> --- a/drivers/perf/riscv_pmu_sbi.c
>>> +++ b/drivers/perf/riscv_pmu_sbi.c
>>> @@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(                                           \
>>>  #define PERF_EVENT_FLAG_USER_ACCESS  BIT(SYSCTL_USER_ACCESS)
>>>  #define PERF_EVENT_FLAG_LEGACY               BIT(SYSCTL_LEGACY)
>>>
>>> -PMU_FORMAT_ATTR(event, "config:0-47");
>>> +PMU_FORMAT_ATTR(event, "config:0-55");
>>>  PMU_FORMAT_ATTR(firmware, "config:62-63");
>>>
>>>  static bool sbi_v2_available;
>>> @@ -527,18 +527,24 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>>>               break;
>>>       case PERF_TYPE_RAW:
>>>               /*
>>> -              * As per SBI specification, the upper 16 bits must be unused
>>> -              * for a hardware raw event.
>>> +              * As per SBI v0.3 specification,
>>> +              *  -- the upper 16 bits must be unused for a hardware raw event.
>>> +              * As per SBI v3.0 specification,
>>> +              *  -- the upper 8 bits must be unused for a hardware raw event.
>>>                * Bits 63:62 are used to distinguish between raw events
>>>                * 00 - Hardware raw event
>>>                * 10 - SBI firmware events
>>>                * 11 - Risc-V platform specific firmware event
>>>                */
>>> -
>>>               switch (config >> 62) {
>>>               case 0:
>>> -                     ret = RISCV_PMU_RAW_EVENT_IDX;
>>> -                     *econfig = config & RISCV_PMU_RAW_EVENT_MASK;
>>> +                     if (sbi_v3_available) {
>>> +                             *econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
>>> +                             ret = RISCV_PMU_RAW_EVENT_V2_IDX;
>>> +                     } else {
>>> +                             *econfig = config & RISCV_PMU_RAW_EVENT_MASK;
>>> +                             ret = RISCV_PMU_RAW_EVENT_IDX;
>>
>> Shouldn't we check to see if any of bits 48-55 are set and return an error,
>> instead of silently requesting the wrong event?
>>
> 
> We can. I did not add it originally as we can't do much validation for
> the raw events for anyways.
> If the encoding is not supported the user will get the error anyways
> as it can't find a counter.
> We will just save 1 SBI call if the kernel doesn't allow requesting an
> event if bits 48-55 are set.

The scenario I'm concerned about is where masking off bits 48-55 results in a
valid, supported encoding for a different event. For example, in the HPM event
encoding scheme used by Rocket and inherited by SiFive cores, bits 8-55 are a
bitmap. So masking off some of those bits will exclude some events, but will not
create an invalid encoding. This could be very confusing for users.

Regards,
Samuel


